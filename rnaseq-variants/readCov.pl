#billis@tallinn:~/mySoftware/scripts/from_others$ perl edReadCovBegin.pl -ref ./rubbish/S6.pSYSG.fna -sam ./rubbish/S6_1272.1.1268_smallXA.sam

# use lib "/software/CGP/external-perl/lib/perl/5.10.0/";
# use lib "/nfs/users/nfs_k/kb15/perl5/lib/perl5/x86_64-linux-thread-multi/";
# to install PDL:  "cpan PDL"

use strict;
use warnings;
use Getopt::Long;

# INIT VARS
my ( $ref_infile, $sam_infile, $genes_infile, $genes_outfile );

# GET OPTIONS
GetOptions(
	'ref=s' => \$ref_infile,
	'sam=s' => \$sam_infile,
	'gff=s' => \$genes_infile,
	'exp=s' => \$genes_outfile
);

print "start1\n";
# INIT OBJECT
my $read_cov = new ReadCov($ref_infile);    # object uses 0-based coordinates
print "start2\n";
# LOAD ALIGNMENTS
$read_cov->read_sam_file($sam_infile) if $sam_infile;
print "start3\n";
# GENE OUTPUT
$read_cov->write_gene_cov_tsv( $genes_infile, $genes_outfile );

print "finished fine\n";

exit;

# OBJECT

package ReadCov;

# objects are blessed arrays, not hashes.
use constant {
	SEQ => 0,    # hash of chrom ID => nucleotide sequence
	LEN => 1,    # hash of chrom ID => chrom length (in bp)
	COV => 2,    # hash of chrom ID => read coverage per base
	RDS => 3
	, # hash of chrom ID => number of reads (each read contributes at a single point)
	COR => 4,    # COV reverse
	RDR => 5     # RDS reverse

};

use PDL;
use PDL::IO::Misc;
use PDL::IO::FastRaw;
use PDL::NiceSlice;
use IO::File;

###############################################################################
## INIT

sub new {
	my ( $class, $infile ) = @_;
	my $this = [ {}, {}, {}, {} ];
	bless $this, $class;
	$this->read_fasta($infile) if $infile;
	return $this;
}

###############################################################################
# LOAD SEQUENCE DATA

sub read_fasta {
	my ( $this, $infile ) = @_;
	my ( $chr, $seq ) = ( '', '' );
	open( FASTA, "<$infile" ) or die("ERROR: Cannot open $infile\n");
	while (<FASTA>) {
		chomp;
		if (/^>(\S+)/) {
			$this->_save_chr( $chr, $seq );
			( $chr, $seq ) = ( $1, '' );
		}
		else {
			$seq .= $_;
		}
	}
	$this->_save_chr( $chr, $seq );
	close FASTA;
	return;
}

# private sub
# parse info to the object
sub _save_chr {
	my ( $this, $chr, $seq ) = @_;
	return unless $chr and $seq;
	$this->[SEQ]->{$chr} = uc($seq);
	my $len = $this->[LEN]->{$chr} = length($seq);
	$this->[COV]->{$chr} = zeroes($len);
	$this->[COR]->{$chr} = zeroes($len);

	$this->[RDS]->{$chr} = zeroes($len);
	$this->[RDR]->{$chr} = zeroes($len);
}


# LOAD ALIGNMENT DATA
sub read_sam_file {
  my ( $this, $infile ) = @_;
  my $prev_read_id = '';	
  my $msg = "Impossible to open $infile:";
  if ($infile =~ /\.gz$/) {
    open(IN, "gzip -dc '$infile' |") || die "$msg $!\n";
  } elsif ($infile =~ /\.bam$/) {
    # trying to open a bam file
    # first check samtools is in the path
    my $samtools = `which samtools`;
    chomp($samtools);
    if ($samtools){
      open(IN, "samtools view -h $infile | ") || die "$msg $!\n";
    } else {
      die "Trying to open a bam file, but `samtools` is not in \$PATH\n";
    }
  } elsif  ($infile =~ /\.sam$/) {
  	open(IN, "$infile") || die "can' open the file $!\n";
  } else {
    open(IN, $infile) || die "$msg $!\n";
  }
	
	while (<IN>) {
		chomp;
		next if /^@/;    # header section
		my @row     = split(/\t/);
		my $read_id = $row[0];
		# chr id, which is the reference
		my $ref_id = $row[2];
		next if $ref_id eq '*';    # unaligned
		my $cigar = $row[5];
		next if $cigar eq '*';    # unaligned pair
		my $len   = ref_length($cigar);
		my $left  = $row[3] - 1;          # convert to 0-based coord system
		my $right = $left + $len - 1;     # convert to 0-based coord system
		my $flag  = $row[1];
		my $strand = $flag & ( 1 << 4 ) ? '-' : '+';
		$this->add_read( $ref_id, $strand, [$left], [$right] );
		$prev_read_id = $read_id;
		# print $_  . "\n";
	}
	close IN;
	return;

	sub ref_length {
		my $fullcigar = shift;
		my $len       = 0;
		my $cigar     = $fullcigar;
		while ($cigar) {
			if ( $cigar =~ /^(\d+)([MIDNSHP])(.*)$/ ) {
				$cigar = $3;
				unless ( $2 eq 'I' or $2 eq 'S' or $2 eq 'H' ) {
					$len += $1 ? $1 : 1;
				}
			}
			else {
				die("Unable to parse cigar string, \"$fullcigar\"\n");
			}
		}
		return $len;
	}
}



## ACCESSORS
#a mutator method is a method used to control changes to a variable.

=head2 seq
 
Given a chromosome ID, returns the complete sequence.
 
=cut

sub seq {
	my ( $this, $chr ) = @_;
	die("$chr does not exist\n") unless exists( $this->[SEQ]->{$chr} );
	return $this->[SEQ]->{$chr};
}

=head2 chrs
 
Returns an alphabetically-sorted list of chromosome IDs
 
=cut

sub chrs {
	my $this = shift;
	return sort keys %{ $this->[LEN] };
}

=head2 size
 
Given a chromosome ID, returns the length in base pairs.
 
=cut

sub size {
	my ( $this, $chr ) = @_;
	die("$chr does not exist\n") unless exists( $this->[LEN]->{$chr} );
	return $this->[LEN]->{$chr};
}

=head2 sizes
 
Returns a hash of chromosome ID and lengths.
 
=cut

sub sizes {
	my $this = shift;

# Note: Returns a copy of the data held in the object, not a pointer to the object's private data!
	my %sizes;
	foreach my $chr ( keys %{ $this->[LEN] } ) {
		$sizes{$chr} = $this->[LEN]->{$chr};
	}
	return \%sizes;
}

## INPUT

=head2 add_read
 
Save a read's alignment.  Note: 0-based coordinates are used.
 
=cut

#it is called from read_sam_file sub
sub add_read {
	my ( $this, $chr, $strands, $starts, $ends, $x ) = @_;

	# VALIDATE INPUT

	#foreach my $line (@{$starts}) {
	#   print "$line\n";
	#}
	return unless exists( $this->[COV]->{$chr} );
	return unless exists( $this->[COR]->{$chr} ); 
	# die("Invalid chr, $chr\n")    unless exists( $this->[COV]->{$chr} );
	# die("Invalid chr, $chr\n")    unless exists( $this->[COR]->{$chr} );
	die("Invalid starts array\n") unless @$starts;
	die("Invalid ends array\n")   unless @$ends;
	$x = 1 unless $x; # used for adding several identical reads at once (optional; default to 1)

	# INCREMENT COVERAGE VECTOR FOR EACH EXON LOCUS
	my $len = 0;
	for ( my $i = 0 ; $i <= $#$starts ; $i++ ) {
		my $start = $starts->[$i];
		unless ( $start >= 0 ) {
			print
			  "Warning: Invalid start coordinate, $start, for contig, $chr ("
			  . $this->[LEN]->{$chr}
			  . " bp)\n";
			$start = 0;

		}
		unless ( $start < $this->[LEN]->{$chr} ) {
			die "Invalid start coordinate, $start, for contig, $chr ("
			  . $this->[LEN]->{$chr}
			  . " bp)\n";
		}
		my $end = $ends->[$i];
		if ( $end >= $this->[LEN]->{$chr} ) {
			print "Warning: Invalid end coordinate, $end, for contig, $chr ("
			  . $this->[LEN]->{$chr}
			  . " bp)\n";
			$end = $this->[LEN]->{$chr} - 1;
		}
		if ( $strands eq "+" ) {
			$this->[COV]->{$chr}->( $start : $end ) += $x;
			$len += ( $end - $start + 1 );

			#print "$strands\t$start\t$end\n";
		}
		elsif ( $strands eq "-" ) {
			$this->[COR]->{$chr}->( $start : $end ) += $x;
			$len += ( $end - $start + 1 );

			#print "$strands\t$start\t$end\n";
		}
	}

	# INCREMENT READ COUNTER
	# choose midpoint
	my $half = int( $len / 2 );
	my $pos;
	for ( my $i = 0 ; $i <= $#$starts ; $i++ ) {
		my $start = $starts->[$i];
		my $end   = $ends->[$i];
		my $len   = $end - $start + 1;
		if ( $half < $len ) {    # midpoint is in this block
			$pos = $start + $half;
		}
		else {
			$half -= $len;
		}
	}

	if ( $strands eq "+" ) {
		$this->[RDS]->{$chr}->($pos) += $x;

		#print "$strands\t$start\t$end\n";
	}
	elsif ( $strands eq "-" ) {
		$this->[RDR]->{$chr}->($pos) += $x;

		#print "$strands\t$start\t$end\n";
	}
}

=head2 locus_coverage_stats
 
Returns coverage stats for a locus/gene.  Multiple block/exon loci are supported.
 
=cut

# probably I will need 2 of those functions... and I will ask here the number of reads acconordingto strand...
sub locus_coverage_stats {
	my ( $this, $chr, $starts, $ends ) = @_;
	die("Chromosome ($chr) does not exist!\n")
	  unless exists( $this->[LEN]->{$chr} );
	if ( $ends->[$#$ends] >= $this->[LEN]->{$chr} ) {
		print "Warning: Locus ends as position "
		  . $ends->[$#$ends]
		  . ", beyond end of $chr ("
		  . $this->[LEN]->{$chr}
		  . " bp)\n";
		$ends->[$#$ends] = $this->[LEN]->{$chr} - 1;
	}
	my $tot_len = 0;
	for ( my $i = 0 ; $i <= $#$starts ; $i++ ) {
		$tot_len += ( $ends->[$i] - $starts->[$i] + 1 );
	}
	my $chr_cov = $this->[COV]->{$chr};
	my $chr_cor = $this->[COR]->{$chr};

	print "$chr_cov";
	my $chr_rds = $this->[RDS]->{$chr};
	my $chr_rdr = $this->[RDR]->{$chr};

	my $gene_cov = zeroes($tot_len);
	my $gene_cor = zeroes($tot_len);

	my $gene_rds = zeroes($tot_len);
	my $gene_rdr = zeroes($tot_len);

	my $start = 0;
	my $end   = 0;
	for ( my $i = 0 ; $i <= $#$starts ; $i++ ) {
		my $ex_start = $starts->[$i];
		my $ex_end   = $ends->[$i];
		my $ex_len   = $ex_end - $ex_start + 1;
		$end += ( $ex_len - 1 );
		$gene_cov ( $start : $end ) .= $chr_cov ( $ex_start : $ex_end );
		$gene_cor ( $start : $end ) .= $chr_cor ( $ex_start : $ex_end );
		$gene_rds ( $start : $end ) .= $chr_rds ( $ex_start : $ex_end );
		$gene_rdr ( $start : $end ) .= $chr_rdr ( $ex_start : $ex_end );

		$start = ++$end;
	}
	my $reads = sum( $gene_rds ( 0 : $tot_len - 1 ) );

	#    my $reads  = sum($gene_rdr       (0 : $tot_len - 1));

	my $median = oddmedian( $gene_cov ( 0 : $tot_len - 1 ) );

	#    my $median = oddmedian($gene_cor (0 : $tot_len - 1));
	#my $print =$gene_cor (0 : $tot_len - 1);

	my ( $mean, $stddev ) = stats( $gene_cov ( 0 : $tot_len - 1 ) );

	#    my ($mean, $stddev) = stats($gene_cor (0 : $tot_len - 1));

	$mean   = int( $mean * 100 + 0.5 ) / 100;
	$stddev = int( $stddev * 100 + 0.5 ) / 100;
	return ( $tot_len, $reads, $median, $mean, $stddev );
}

=head2 write_gene_cov_tsv
 
Write gene coverage statistics as tab-separated values.  Genes must be in Gff3 format. Gff uses a 1-based coordinate system.
 
=cut

sub write_gene_cov_tsv {
	my ( $this, $infile, $outfile ) = @_;
	open( IN,  "<$infile" )  or die($!);
	open( OUT, ">$outfile" ) or die($!);
	print OUT "#chr\tgene\ttype\tlen\treads\tmedian\tmean\tstddev\n";

	my $prev_chr;
	my $prev_gene = '';
	my @prev_starts;
	my @prev_ends;
	my @geneCalled;
	my $tab;
	while (<IN>) {
		chomp;

#        my ($chr,$src,$type,$start,$end,$score,$strand,$phase,$annot)=split(/\t/);
		my ( $chr, $src, $type, $start, $end, $score, $strand, $phase, $annot1 )
		  = split(/\t/);
		my $geneID;

		#   print "$annot1\n";
		# BK add this to see the id of the gene
		@geneCalled = split( /"/, $_ );
		$geneID     = $geneCalled[1];

#        if(!defined($type)){next;}
# the problem that appears is because the gff files aren`t real gff files...!!
# I should try to remove that if and instead of this To add this info to print out join... few lines below
#        if ($type) {
		if ( $type eq "exon") {

#            my %annot=();
#            foreach my $a (split(/;/, $annot)) {
#                my ($key,$value)=split(/=/, $a);
#                $annot{$key}=$value;
#            }
#            my $gene = exists($annot{ID}) ? $annot{ID} : "$chr.$start"; # create ID if not defined, as ID is the chromosome and the start pos of the gene
			my $gene = $geneID;
			if ( $gene eq $prev_gene ) {
				push @prev_starts, $start;
				push @prev_ends,   $end;
			}
			else {
				if ($prev_gene) {

					# there I should add this info about type...
					my ( $len, $reads, $median, $mean, $stddev ) =
					  $this->locus_coverage_stats( $prev_chr, \@prev_starts,
						\@prev_ends );
					print OUT join( "\t",
						$prev_chr, $prev_gene, $type, $len, $reads, $median,
						$mean, $stddev ),
					  "\n";
					$tab = "$type";
				}
				$prev_chr    = $chr;
				$prev_gene   = $gene;
				@prev_starts = ($start);
				@prev_ends   = ($end);
			}
		}

	}
	if ( $prev_chr and $prev_gene and @prev_starts and @prev_ends ) {

		my ( $len, $reads, $median, $mean, $stddev ) =
		  $this->locus_coverage_stats( $prev_chr, \@prev_starts, \@prev_ends );

		#here there is a problem.... with $tab
		print OUT join( "\t",
			$prev_chr, $prev_gene, $tab, $len, $reads, $median, $mean,
			$stddev ),
		  "\n";
	}

	close OUT;
}

__END__
