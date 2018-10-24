# june 2012: I used the core of the script to do the counting for metaTransciptomics datasets.
# Sep 2012: Summarize the coverage and Divide to average length of the read or Maximun read Length (read length)


#!/jgi/tools/bin/perl -w

# jgiperl //house/homedirs/k/kbillis/mySoftware/scripts/readCov_metaTranSimple.pl -ref  -gff ./../../sub/20005/9484/9484.assembled.gff -sam /house/groupdirs/genetic_analysis/rna/projects/Delaware_MO_Early_Summer_May_10_metatranscriptome_403861/CPHN/CPHN.2302.4.1860_qtrim_jartifacts.rRNA_cleaned_map_to_mg_ref_unmapped_map_to_assembly.bam  -exp /house/groupdirs/genome_biology/rna_seq/sub/20005/9484/res.etstNON.txt  -map ./../../sub/20005/9484/9484.assembled.names_map -lib non -sid xxx -eid 20005


use strict;
use warnings;
use Getopt::Long;


# INIT VARS
my ($help, $ref_infile, $sam_infile, $genes_infile, $genes_outfile, $map_names_file, $lib, $experiment_oid ,$sample_oid);
$lib = "directional"; 
$experiment_oid = "expNA"; 
$sample_oid= "sampleNA"; 
# GET OPTIONS
GetOptions(
    'lib=s'    => \$lib,
    'eid=s'    => \$experiment_oid,
    'sid=s'    => \$sample_oid,
    'ref=s'    => \$ref_infile,
    'gff=s'    => \$genes_infile,
    'sam=s'    => \$sam_infile,
    'exp=s'    => \$genes_outfile,
    'map=s'    => \$map_names_file,
    'h|help'   => \$help
);


my $usage = <<'ENDHERE';
NAME
    readCov_SeAn_auto.pl
PURPOSE
    Find Cov (+ strand) and Cor (- strand) per gene for MetaTransciptomics (NO alternative splicing)
    Say directional or non-directional libraries
INPUT
    --lib <> : directional or non-directional
    --eid <> : expression experiment id,
    --sid <> : sample id, 
    --ref <> : ref_infile,
    --gff <> : annotation file,
    --sam <> : sam file or bam file
    --map <> : map previous names with new

OUTPUT
    --exp <> : outfile, counts per gene

BY
    (base on Ed's script)
    kbillis@lbl.gov
ENDHERE

die ($usage) if ($help);

# INIT OBJECT
my $read_cov = new ReadCov($ref_infile, $map_names_file);    # object uses 0-based coordinates
print "scaffold and name_map files were loaded\n";


# LOAD ALIGNMENTS
# there are two case if the script will take into account XA (multiple hits) or not
$read_cov->read_sam_fileXA($sam_infile) if $sam_infile; 
# $read_cov->read_sam_file($sam_infile, $map_names_file) if $sam_infile;
print "sam/bam file processed\n";
# GENE OUTPUT
$read_cov->write_gene_cov_tsv($genes_infile, $genes_outfile, $sample_oid, $experiment_oid, $lib );
print "counting is done\n";

# OBJECT

package ReadCov;

# objects are blessed arrays, not hashes.
use constant {
    SEQ => 0,    # hash of chrom ID => nucleotide sequence
    LEN => 1,    # hash of chrom ID => chrom length (in bp)
    COV => 2,    # hash of chrom ID => read coverage per base
    COR => 3,	 # hash of chrom ID => read coverage per base (reverse of COV)
    RLE => 4,	 # average mapped read or maximun mapped read length => used for the counting 
    MAP => 5	 # previous (assembly group use) names/ids of the loaded sequences
};

use PDL;
use PDL::IO::Misc;
use PDL::IO::FastRaw;
use PDL::NiceSlice;
use IO::File;

###############################################################################
## INIT
sub new
{
    my ($class, $infile, $mapfile) = @_;
    my $this = [ {}, {}, {}, {}];
    bless $this, $class;
    $this->read_fasta($infile) if $infile;
    $this->mapNames($mapfile) if $mapfile;
    return $this;
}

###############################################################################
# LOAD SEQUENCE DATA
sub read_fasta
{
    my ($this, $infile) = @_;
    my ($chr, $seq) = ('', '');
    open(FASTA, "<$infile") or die("ERROR: Cannot open $infile\n");
    while (<FASTA>) {
        chomp;
        if (/^>(\S+)/) {
            $this->_save_chr($chr, $seq);
	    	my @d=split(/ /,$1);
            ($chr, $seq) = ($d[0], '');
		} else {
            $seq .= $_;
        }
    }
    $this->_save_chr($chr, $seq);
    close FASTA;
    return
}

# private sub
# parse info to the object
sub _save_chr
{
    my ($this, $chr, $seq) = @_;
    return unless $chr and $seq;
    # $this->[SEQ]->{$chr} = uc($seq);
    my $len = $this->[LEN]->{$chr} = length($seq);
    $this->[COV]->{$chr} = zeroes($len);
    $this->[COR]->{$chr} = zeroes($len);

    # $this->[RDS]->{$chr} = zeroes($len);
    # $this->[RDR]->{$chr} = zeroes($len);
}

# find previous names for the selected sequences
sub mapNames {
	my ($this, $file1) = @_;
	my %hashRename;
	if (-e $file1) {
		print "Map File Exists!";
	    open(IN, "<$file1") or die("ERROR: Cannot open $file1\n");
		while (<IN>) {
			chomp;
			my @line=split(/\t/);
			if ($this->[LEN]->{$line[1]}) {
				$this->[MAP]->{$line[1]} =	$line[0];	# uncomment those lines			
			} 
		}
		close IN;
	} else {
		print "there isN'T a file to map names\n";
	}	
return %hashRename;	
}  


# LOAD ALIGNMENT DATA
# don't use the alternative mapping regions
sub read_sam_file {
    my ($this, $infile )=@_;
    my $count=0;
    my $m=0;
    my $prev_read_id='';
    my %map_names;
    my $max=0;
    my $fh = getFileHandle($infile);
	foreach my $chr (keys %{$this->[MAP]}) {
		my $mapId  = $this->[MAP]->{$chr};
		$map_names{$mapId} = $chr; 
	}
    
    while (<$fh>) {
        chomp;
        next if /^@/; # header section
		my $x = 1;
        my @row=split(/\t/);
        my $read_id=$row[0];
        my $flag=$row[1];
        my $ref_id=$row[2];
		my $strand= $flag & (1 << 4) ? '-':'+';
		my $not_ = $flag & (1 << 2) ?  'no': 'yes';
		next if $not_ eq "no";
        next if $ref_id eq '*'; # unaligned
        if ( $map_names{$ref_id} ) {
        	$ref_id = $map_names{$ref_id};
        }      
		# print "$ref_id \n";
		
		if (exists($this->[COV]->{$ref_id}) ) {
		} else {
			next;
		}
	
        my $cigar=$row[5];
        my $len=ref_length($cigar);
        $count = $count + $len;
        $m = $m+1;
        my $left = $row[3]-1; # convert to 0-based coord system
        my $right = $left + $len - 1; # convert to 0-based coord system
		$this->add_read($ref_id, $strand, [$left],[$right], $x);
        $prev_read_id=$read_id;
        $max = $len if ($len>$max);
    }
    die "no mapped reads to the given contigs\n" if ($m==0) ;
    my $aveReadLength = $count/$m ;
    # $this->[RLE]->{"le"} = $aveReadLength;  # can replace $aveReadLEngth with $max!
	$this->[RLE]->{"le"} = $max; # SOS I change it
    print "$count | $m\n";
    print "average read length: $aveReadLength\n";
    
    return;

    sub ref_length {
        my $fullcigar=shift;
        my $len=0;
        my $cigar=$fullcigar;
        while($cigar) {
            if ($cigar =~ /^(\d+)([MIDNSHP])(.*)$/) {
                $cigar=$3;
                unless ($2 eq 'I' or $2 eq 'S' or $2 eq 'H') { $len += $1 ? $1:1 }
            } else {
                die("Unable to parse cigar string, \"$fullcigar\"\n");
            }
        }
        return $len;
    }
    	
}


sub getFileHandle {
    my ($file) = @_;
    my $fh;
    my $msg = "Impossible to open $file:";
    if ($file =~ /\.gz$/) {
        open($fh, "gzip -dc '$file' |") || die "$msg $!\n";
    } elsif ($file =~ /\.bam$/) {
        # trying to open a bam file
        # first check samtools is in the path
        my $samtools = `which samtools`;
        chomp($samtools);
        if ($samtools){
            open($fh, "samtools view -h '$file' |") || die "$msg $!\n";
        } else {
            die "Trying to open a bam file, but `samtools` is not in \$PATH\n";
        }
    } else {
        open($fh, $file) || die "$msg $!\n";
    }
    
    return $fh;
}

###########################
###	OR			
### take into account XA

sub read_sam_fileXA {
    my ($this, $infile )=@_;
    my $count=0;
    my $s=0; # summary of the reads per file
    my $m=0; # mapped reads per file
    my $max=0;
    my $prev_read_id='';
    my %map_names;
    my $fh = getFileHandle($infile);
	foreach my $chr (keys %{$this->[MAP]}) {
		my $mapId  = $this->[MAP]->{$chr};
		$map_names{$mapId} = $chr; 
	}

    while (<$fh>) {
        chomp;
        next if /^@/; # header section
        $s = $s+1;
		my $x = 1;
        my @row=split(/\t/);
        my $read_id=$row[0];
        my $flag=$row[1];
        my $ref_id=$row[2];
		my $strand= $flag & (1 << 4) ? '-':'+';
		my $not_ = $flag & (1 << 2) ?  'no': 'yes';
		next if $not_ eq "no";
        next if $ref_id eq '*'; # unaligned
        if ( $map_names{$ref_id} ) {
        	$ref_id = $map_names{$ref_id};
        }      
		
		if (exists($this->[COV]->{$ref_id}) ) {
		} else { next; }
	
        my $cigar=$row[5];
        my $len=ref_length($cigar);
        $count = $count + $len;        
        $m = $m+1;
        $max = $len if ($len>$max);
		# print "$len\n";

        my $left = $row[3]-1; # convert to 0-based coord system
        my $right = $left + $len - 1; # convert to 0-based coord system
		$this->add_read($ref_id, $strand, [$left],[$right], $x);
        $prev_read_id=$read_id;
		my @XA=();
		if(/XA:Z:/) {
			# test
			#split all alternative reads
			my @line = split(/XA:Z:/);
			push(@XA, @line[1..$#line]);
			foreach my $multiRead (@XA) {
				if (!defined($multiRead)) {next;}
				my @alterReadXA = split(/;/, $multiRead);			
				foreach my $alterRead (@alterReadXA) {
					my @readXA = split(/,/, $alterRead);
					$ref_id = $readXA[0];
					my $pos = $readXA[1];
					if ( $map_names{$ref_id} ) {
						$ref_id = $map_names{$ref_id};
					} 
					if (exists($this->[COV]->{$ref_id}) ) {
					} else { next; }
					
					if ($pos =~ /[+]/ ) {
						$strand = "+";
						$pos =~ s/[+-]//g;
						my $startPos = $pos;
						$cigar=$row[5];
						$len=ref_lengthXA($cigar);
						$left = $startPos;
						$right=$left + $len - 1; # convert to 0-based coord system
						$x=1; # at this point and before I could change the value- weight of the read
						$this->add_read($ref_id, $strand, [$left],[$right], $x);
					} 
					elsif ($pos =~ /[-]/ ) {
						$strand = "-";
						$pos =~ s/[+-]//g;
						my $startPos = $pos;
						$cigar=$row[5];
						$len=ref_lengthXA($cigar);
						$left = $startPos;
						$right=$left + $len - 1; # convert to 0-based coord system
						$x=1; # at this point and before I could change the value- weight of the read
						$this->add_read($ref_id, $strand, [$left],[$right], $x);
					}	
					else { print " problem with $read_id";}
				}
			}
		}
    }
    die "no mapped reads to the given contigs\n" if ($m==0) ;
    my $aveReadLength = $count/$m ;
    # $this->[RLE]->{"le"} = $aveReadLength;
    $this->[RLE]->{"le"} = $max;
    print "$count | mapped reads: $m | summary of the reads: $s\n";
    print "average read length: $aveReadLength\n";


    sub ref_lengthXA {
        my $fullcigar=shift;
        my $len=0;
        my $cigar=$fullcigar;
        while($cigar) {
            if ($cigar =~ /^(\d+)([MIDNSHP])(.*)$/) {
                $cigar=$3;
                unless ($2 eq 'I' or $2 eq 'S' or $2 eq 'H') { $len += $1 ? $1:1 }
            } else {
                die("Unable to parse cigar string, \"$fullcigar\"\n");
            }
        }
        return $len;
    } 
return;
}



## ACCESSORS
#a mutator method is a method used to control changes to a variable.
=head2 seq

Given a chromosome ID, returns the complete sequence.

=cut

sub seq
{
    my ($this, $chr) = @_;
    die("$chr does not exist\n") unless exists($this->[SEQ]->{$chr});
    return $this->[SEQ]->{$chr};
}

=head2 chrs

Returns an alphabetically-sorted list of chromosome IDs

=cut

sub chrs
{
    my $this = shift;
    return sort keys %{$this->[LEN]};
}

=head2 size

Given a chromosome ID, returns the length in base pairs.

=cut

sub size
{
    my ($this, $chr) = @_;
    die("$chr does not exist\n") unless exists($this->[LEN]->{$chr});
    return $this->[LEN]->{$chr};
}

=head2 sizes

Returns a hash of chromosome ID and lengths.

=cut

sub sizes
{
    my $this = shift;
    # Note: Returns a copy of the data held in the object, not a pointer to the object's private data!
    my %sizes;
    foreach my $chr (keys %{$this->[LEN]}) {
        $sizes{$chr} = $this->[LEN]->{$chr};
    }
    return \%sizes;
}

## INPUT

=head2 add_read

Save a read's alignment.  Note: 0-based coordinates are used.

=cut
#it is called from read_sam_file sub
sub add_read
{
    my ($this, $chr, $strands, $starts, $ends, $x) = @_;

    # VALIDATE INPUT    
    die("Invalid chr, $chr\n")    unless exists($this->[COV]->{$chr});
    die("Invalid starts array\n") unless @$starts;
    die("Invalid ends array\n")   unless @$ends;
    $x = 1 unless $x;    # used for adding several identical reads at once (optional; default to 1)

    # INCREMENT COVERAGE VECTOR FOR EACH EXON LOCUS
    my $len=0;
    for (my $i = 0 ; $i <= $#$starts ; $i++) {
        my $start = $starts->[$i];
        unless ($start >= 0) {
            print "Warning: Invalid start coordinate, $start, for contig, $chr (" . $this->[LEN]->{$chr} . " bp)\n";
            $start=0;

        }
        unless ($start < $this->[LEN]->{$chr}) {
            die "Invalid start coordinate, $start, for contig, $chr (" . $this->[LEN]->{$chr} . " bp)\n" 
        }
        my $end = $ends->[$i];
        if ( $end >= $this->[LEN]->{$chr} ) {
            print "Warning: Invalid end coordinate, $end, for contig, $chr (" . $this->[LEN]->{$chr} . " bp)\n";
            $end = $this->[LEN]->{$chr} - 1;
        }
        
		if ($strands eq "+") {
	        $this->[COV]->{$chr}->($start : $end) += $x;
    	    $len += ($end-$start+1);
		} elsif ($strands eq "-") {
			$this->[COR]->{$chr}->($start : $end) += $x;
    	    $len += ($end-$start+1);
       	}
    }

    # INCREMENT READ COUNTER
    # choose midpoint
    my $half = int($len/2);
    my $pos;
    for (my $i=0; $i<=$#$starts; $i++) {
        my $start = $starts->[$i];
        my $end = $ends->[$i];
        my $len = $end-$start+1;
        if ($half < $len) { # midpoint is in this block
            $pos = $start + $half;
        } else {
            $half -= $len;
        }
    }
}

=head2 locus_coverage_stats

Returns coverage stats for a locus/gene.

=cut

sub locus_coverage_stats
{
    my ($this, $chr, $starts, $ends) = @_;
    die("Chromosome ($chr) does not exist!\n") unless exists($this->[LEN]->{$chr});
    if ($ends->[$#$ends] >= $this->[LEN]->{$chr}) {
        print "Warning: Locus ends as position ".$ends->[$#$ends].", beyond end of $chr (".$this->[LEN]->{$chr}." bp)\n";
        $ends->[$#$ends] = $this->[LEN]->{$chr} - 1;
    }
    my $tot_len = 0;
    for (my $i = 0 ; $i <= $#$starts ; $i++) {
        $tot_len += ($ends->[$i] - $starts->[$i] + 1);
    }
    my $chr_cov  = $this->[COV]->{$chr};
    my $chr_cor  = $this->[COR]->{$chr};

    my $gene_cov = zeroes($tot_len);
    my $gene_cor = zeroes($tot_len);

    my $start    = 0;
    my $end      = 0;
    for (my $i = 0 ; $i <= $#$starts ; $i++) {
        my $ex_start = $starts->[$i];
        my $ex_end = $ends->[$i];
        my $ex_len = $ex_end - $ex_start + 1;
        $end += ($ex_len - 1);
        $gene_cov ($start : $end) .= $chr_cov ($ex_start : $ex_end);
		$gene_cor ($start : $end) .= $chr_cor ($ex_start : $ex_end);
		$start = ++$end;
    }
    my $reads  = sum($gene_cov       (0 : $tot_len - 1));     # sum($gene_rds       (0 : $tot_len - 1));
    my $readsA  = sum($gene_cor       (0 : $tot_len - 1));      # sum($gene_rdr       (0 : $tot_len - 1));
    
    my $aveReadLen = $this->[RLE]->{"le"};
    
    $reads = $reads/$aveReadLen;
    $reads = int($reads + 0.5);
    $readsA = $readsA/$aveReadLen;
    $readsA = int($readsA + 0.5);
    
    my $median = oddmedian($gene_cov (0 : $tot_len - 1));
    my $medianA = oddmedian($gene_cor (0 : $tot_len - 1));

    my ($mean, $stddev) = stats($gene_cov (0 : $tot_len - 1));
    my ($meanA, $stddevA) = stats($gene_cor (0 : $tot_len - 1));

    $mean   = int($mean * 100 + 0.5) / 100;
    $meanA   = int($meanA * 100 + 0.5) / 100;

    $stddev = int($stddev * 100 + 0.5) / 100;
    $stddevA = int($stddevA * 100 + 0.5) / 100;

    return ($tot_len, $reads, $median, $mean, $stddev, $readsA, $medianA, $meanA, $stddevA);
}

sub write_gene_cov_tsv {

    my ($this, $infile, $outfile, $sample_oid, $experiment_oid, $lib ) = @_;

    my @prev_starts;
    my @prev_ends;
    my @geneCalled;
    my $prev_type;
    my $prev_Strand='';
    my ($len, $reads, $median, $mean, $stddev, $readsA, $medianA, $meanA, $stddevA);
    my ($chr,$src,$type,$start,$end,$score,$strandG,$phase,$comment,$geneID, $prev_genOID, $geneOID, $img_scaffold_oid);
    my ($sec,$min,$hour,$day,$month,$yr19,@rest);
    my %hash_type;
    my %hast_sca;
    my @array_type;
    my $intT =0 ;

    open(IN,  "<$infile")  or die($!);
	while (<IN>) {
	chomp;
		next if /^##/; # header section
		($chr,$src,$type,$start,$end,$score,$strandG,$phase,$comment)=split(/\t/);
		$hash_type{$type} = 1; 
	}
    close IN;	


    @array_type = keys %hash_type;

    my @array_type1 = grep(!/source/, @array_type);
    # my @array_type1 = @array_type;
    @array_type1 = grep(!/repeat_region/, @array_type1);
    @array_type1 = grep(!/rRNA/, @array_type1);
    @array_type1 = grep(!/exon/, @array_type1);
    @array_type = grep(!/gene/, @array_type1);

    open(OUT, ">$outfile") or die($!);
    print OUT "scaffold_accession\tlocus_tag\tstrand\tlocus_type\tlength\treads_cnt\tmean\tmedian\tstdev\treads_cntA\tmeanA\tmedianA\tstdevA\texperiment\tsample\n";

	foreach my $typeVal (@array_type) {
	
	open(IN,  "<$infile")  or die($!);
		while (<IN>) {
		chomp;
		next if /^##/; # header section
	
		($chr,$src,$type,$start,$end,$score,$strandG,$phase,$comment)=split(/\t/);
		$start  =~ s/\>//g;
		$start  =~ s/\<//g;

		$end  =~ s/\>//g;
		$end  =~ s/\<//g;
		
		$strandG = "+" if ($strandG eq "1");
		$strandG = "-" if ($strandG eq "-1");

		@prev_starts = ();
		@prev_ends =();
		
			if ( $type eq $typeVal ) {
				push @prev_starts, $start;
				push @prev_ends, $end;
				# to find the id of the gene
				my @geneCalled= split(/"/, $_);
				if ($geneCalled[1]) {
					$geneID=$geneCalled[1];	
				} else {
					$_ =~m/;locus_tag=(.*?);/s;
					$geneID =$1;
					$_ =~m/;scaffold_oid=(.*?);/s;
					$img_scaffold_oid =$1;
				}
				
				if (!defined($geneID)) {
					$_ =~m/;gene_id=(.*?);/s;
					$geneID =$1;					
				}
				if (!defined($geneID)) {
					$_ =~m/;locus_tag=(.*?)$/s;
					$geneID =$1;					
				}

				if (!defined($geneID)) {
					print "still don`t defined~~ $_ \n";
					die;
				}				
				
				next unless exists($this->[COV]->{$chr});

				if ( $lib eq "directional") {
					# when the libraries are directional / strand specific
					if ($strandG eq "+") {
						($len, $reads, $median, $mean, $stddev, $readsA, $medianA, $meanA, $stddevA) = $this->locus_coverage_stats($chr, \@prev_starts, \@prev_ends);
						print OUT join("\t", $chr, $geneID, $strandG, $type, $len, $readsA, $meanA, $medianA, $stddevA, $reads, $mean, $median, $stddev,  $experiment_oid , $sample_oid), "\n";
					} elsif ($strandG eq "-") {
						($len, $reads, $median, $mean, $stddev, $readsA, $medianA, $meanA, $stddevA) = $this->locus_coverage_stats($chr, \@prev_starts, \@prev_ends);
						print OUT join("\t", $chr, $geneID, $strandG, $type, $len, $reads, $mean, $median, $stddev, $readsA, $meanA, $medianA, $stddevA, $experiment_oid , $sample_oid ), "\n";

					} else {
						print "problem\n";
					}
					
				} else {
					($len, $reads, $median, $mean, $stddev, $readsA, $medianA, $meanA, $stddevA) = $this->locus_coverage_stats($chr, \@prev_starts, \@prev_ends);
					
					$reads =$reads + $readsA;
					$readsA = $medianA = $meanA = $stddevA = $median = $mean = $stddev = "0";

					# if there is any problem check the loading file of the hash.
					# if (!$img_scaffold_oid) { $img_scaffold_oid = "NaV"; }  # print "warning:no img scaffold oid\n".
				
					next if  ( $reads == 0 );
					print OUT join("\t" , $chr, $geneID, $strandG, $type, $len, $reads, $mean , $median , $stddev, $readsA, $meanA, $medianA, $stddevA, $experiment_oid , $sample_oid), "\n";
				}
			}	
		}
		
	}
    	
    close IN;
    close OUT;	
}


__END__


