use strict;
use warnings;
# use diagnostics;
use Getopt::Long;



# INIT VARS
my ( $vcf_infile, $algorithm, $infasta, $genes_infile, $outfile);

# GET OPTIONS
GetOptions(
    'gff=s'    => \$genes_infile,
    'fasta=s'  => \$infasta,
    'vcf=s'    => \$vcf_infile,  # this is not a real vcf, it is a tuned!!
    
    # 'out=s'    => \$outfile
);

my %gff_data_ref = load_gff($genes_infile);    # object uses 0-based coordinates

print "#find_if_the_aminoacid_change.pl load fasta! \n";
my %seq_hash = read_fasta($infasta); 

print "#find_if_the_aminoacid_change.pl load SNPs! \n";
my $snps = load_vcf($vcf_infile, \%gff_data_ref, \%seq_hash );

print "\n#find_if_the_aminoacid_change.pl all finished! \n";


# load gff annotation

sub load_gff {
    my ($gff_infile_l) = shift;
    my %annotation;
    open(IN, "$gff_infile_l") or die("Unable to open gff file $gff_infile_l");
    while (<IN>){
        chomp;
        my $gene; 
        my ($chr,$src,$type,$start,$end,$score,$strand,$phase,$annot1)=split(/\t/, $_);
        next if (/source/);
        if (/gene_id "(.*?)"/) {
            # $_ =~m/gene_id "(.*?)"/s;
            $gene =$1;
            $annotation{$gene} = $_ ;
        } else {
            warn("find_if_the_aminoacid_change.pl load_hash:: I can't find gene_id for $_ ");
            next;
        }


    }
    close(IN);
    
return %annotation;
}


sub read_fasta
{
    my ($infile) = shift;
    my ($chr, $seq) = ('', '');
    my %hast_seq_f;
    open(FASTA, "<$infile") or die("ERROR: Cannot open $infile\n");
    while (<FASTA>) {
        chomp;
        if (/^>(\S+)/) {
            $hast_seq_f{$chr} = $seq;
            ($chr, $seq) = ($1, '');
        } else {
            $seq .= $_;
        }
    }
    
    $hast_seq_f{$chr} = $seq;

    close FASTA;
    return %hast_seq_f;
}



# PARSE VCF FILE & Report where the mutation is # 
sub load_vcf {
    my $vcf_file = shift; 
    my $annot_hash = shift; 
    my $seq_hash = shift;

    my $header;
    my $strand;
    
    my $output_where_is_the_mut = $vcf_file . ".newOut"; 

    my $countIntergenic = 100; 

    open(OUTNVCF, ">", "$output_where_is_the_mut") or (die "Can't open OUTFILE: $!");
    open(VCF,$vcf_file) or die "Can't open $vcf_file!\n";
    while(<VCF>){
        chomp($_);
        
        if($_=~/^#/){ 
            if ($countIntergenic == 2) {
                # print "find_if_the_aminoacid_change.pl it was integenic\n"; 
            } elsif ($countIntergenic == 1) {
                # print "find_if_the_aminoacid_change.pl things were good\n"; 
            } elsif ($countIntergenic == 100) {
                # print "find_if_the_aminoacid_change.pl first one\n"; 
            } elsif ($countIntergenic == 0) {
                # print "find_if_the_aminoacid_change.pl problem\n"; 
            }
            $countIntergenic = 0; 
            next;
        }

        $countIntergenic = $countIntergenic + 1  if (/Interge/);

        my @data = split(/\t/,$_);
        my $gene = $data[0]; 
        my $chr_snp = $data[1];
        my $snp_position = $data[2];
        my $variant= $data[4]."to".$data[5];
        next if (!$annot_hash->{$gene});
        next if (length($data[5])>1);
        my $annot_data = $annot_hash->{$gene};

        my ($chr,$src,$type,$start,$end,$score,$strand,$phase,$annot1)=split(/\t/, $annot_data);
        print OUTNVCF "$gene :: $chr_snp :: $strand :: $start :: $end :: SNP :: $snp_position :: $variant :: ";


        my $length = $end - $start; 
        my $contig = $seq_hash->{$chr};
        # $start should be -1 to have the correct coordinates!  
        my $seqDNA;
        my $mutSeqDNA; 
        
        $data[5]   =~ tr/[A,T,C,G]/[a,t,c,g]/;

        my $mutContig = $contig; 
        # print "length of the seq is:" . length($contig) . "\n";
        # print "#####"; 
        my $nucleotide_to_change = substr( $mutContig, $snp_position-1, 1 ); 
        # print "DEBUG" . $data[4] . "--" . $nucleotide_to_change . "\n"; 
        die ("DEBUG::SNP_pos: $nucleotide_to_change " ) if ($data[4] ne $nucleotide_to_change); 

        if ($strand eq "+") {
            # do nothing
            # create a contig with the snp:
	    substr($mutContig,$snp_position-1,1,$data[5]);        
            $seqDNA = substr $contig , $start-1, $length ;
            $mutSeqDNA = substr $mutContig , $start-1, $length ; 
        } elsif ($strand eq "-") {
            # $length = $length + 6;             
            # this is the correct one:
            
            # at first get the DNA of gene, reverse complimentary and 
            $seqDNA = reverse(substr $contig , $start, $length) ;
            # print "ori_reverse_DNA: $seqDNA  \n"; 
            $seqDNA =~ tr/[A,T,C,G]/[T,A,G,C]/; 
            # print "tr_reverse_DNA: $seqDNA  \n"; 
            
            # Pay attention here. For snp. Else, I will change the snp. 
            $mutContig =~ tr/[A,T,C,G]/[T,A,G,C]/; 
	    substr($mutContig,$snp_position-1,1,$data[5]); 
            $mutSeqDNA = reverse(substr $mutContig , $start, $length) ;
        }

        # print "snp position in sequence: " . $start . "  " . $snp_position . "  " . ($snp_position - $start) . " \n";
        # print "snpDNA: $mutSeqDNA  \n"; 
        
        print OUTNVCF " difference :: ";
#GCGTTGATGGAACTGGGTTCGACCCTGCGAGATCAGGGAATAAGATGGTGCCAGCGATCACAGGCGCCTATGAAGGTCTACGTTCTGCTCTACAACGCGGGCACTGATAACGAGGGGATCCATTCGCTTTCGATCGGGGATGAAAACATCATCCTGATGTTTGAAGACGAGGATGATGCCCAGCGCTACGCCATGTTGCTCGAAGCGCAGGACTTTCAGGCTCCCATTGTCGAAGCGATTGACCGCGAAGAAGTCGAAGCTTTTTGCCAAGACTCCCCCTATCAGCCGCAATTGATTCCCCGGGATTTTCGACCCAGCAATGACTTTGAACGGTTGCTGCTCGCCCCGCCAGAGTTGAATCGCGAGGAAACCGATTGGTCTGAGGATGGTCGTTCGGCAGACGTTGCGGATGAGGAGGCAGACTCACTACCTGCCAGTGATCTCGAAGCATTGCGTCGCCGTCTAGAAGGCTTGCTCTA
#GCGTTGATGGAACTGGGTTCGACCCTGCGAGAGCAGGGAATAAGATGGTGCCAGCGATCACAGGCGCCTATGAAGGTCTACGTTCTGCTCTACAACGCGGGCACTGATAACGAGGGGATCCATTCGCTTTCGATCGGGGATGAAAACATCATCCTGATGTTTGAAGACGAGGATGATGCCCAGCGCTACGCCATGTTGCTCGAAGCGCAGGACTTTCAGGCTCCCATTGTCGAAGCGATTGACCGCGAAGAAGTCGAAGCTTTTTGCCAAGACTCCCCCTATCAGCCGCAATTGATTCCCCGGGATTTTCGACCCAGCAATGACTTTGAACGGTTGCTGCTCGCCCCGCCAGAGTTGAATCGCGAGGAAACCGATTGGTCTGAGGATGGTCGTTCGGCAGACGTTGCGGATGAGGAGGCAGACTCACTACCTGCCAGTGATCTCGAAGCATTGCGTCGCCGTCTAGAAGGCTTGCTCTA

        my $maskDNA = $seqDNA ^ $mutSeqDNA;
        while ($maskDNA =~ /[^\0]/g) { 
            print OUTNVCF substr($seqDNA,$-[0],1), ' ', substr($mutSeqDNA,$-[0],1), ' ', $-[0], "";
        }        
        print OUTNVCF " :: ";       

        my $trans = "";
        for my $codon ($seqDNA =~ /(...)/g) {
            $trans = $trans . codon2aa($codon);
        } 

        my $transMut = "";
        for my $codon ($mutSeqDNA =~ /(...)/g) {
            $transMut = $transMut . codon2aa($codon);
        } 
        # print "oriProtein: $trans\n";    
        # print "MutProtein: $transMut\n";

        # find the difference between original and mutated protein
        my $mask = $trans ^ $transMut; 
        my $aminoAcid_change = ""; 
        while ($mask =~ /[^\0]/g) { 
            # print OUTNVCF substr($trans,$-[0],1), ' ', substr($transMut,$-[0],1), ' ', $-[0], "";
            $aminoAcid_change = substr($trans,$-[0],1) . ' ' . substr($transMut,$-[0],1) . ' ' . $-[0] . ""; 
        } 
        
        if ($aminoAcid_change eq "") {
            print OUTNVCF " X X NN"; 
        } else {
            print OUTNVCF $aminoAcid_change; 
        }

        print OUTNVCF " \n";
    }
    close(VCF);
    close(OUTNVCF);

return;
}








sub codon2aa {
    my($codon) = @_;

    $codon = uc $codon;
 
    my(%genetic_code) = (
    
    'TCA' => 'S',    # Serine
    'TCC' => 'S',    # Serine
    'TCG' => 'S',    # Serine
    'TCT' => 'S',    # Serine
    'TTC' => 'F',    # Phenylalanine
    'TTT' => 'F',    # Phenylalanine
    'TTA' => 'L',    # Leucine
    'TTG' => 'L',    # Leucine
    'TAC' => 'Y',    # Tyrosine
    'TAT' => 'Y',    # Tyrosine
    'TAA' => '_',    # Stop
    'TAG' => '_',    # Stop
    'TGC' => 'C',    # Cysteine
    'TGT' => 'C',    # Cysteine
    'TGA' => '_',    # Stop
    'TGG' => 'W',    # Tryptophan
    'CTA' => 'L',    # Leucine
    'CTC' => 'L',    # Leucine
    'CTG' => 'L',    # Leucine
    'CTT' => 'L',    # Leucine
    'CCA' => 'P',    # Proline
    'CCC' => 'P',    # Proline
    'CCG' => 'P',    # Proline
    'CCT' => 'P',    # Proline
    'CAC' => 'H',    # Histidine
    'CAT' => 'H',    # Histidine
    'CAA' => 'Q',    # Glutamine
    'CAG' => 'Q',    # Glutamine
    'CGA' => 'R',    # Arginine
    'CGC' => 'R',    # Arginine
    'CGG' => 'R',    # Arginine
    'CGT' => 'R',    # Arginine
    'ATA' => 'I',    # Isoleucine
    'ATC' => 'I',    # Isoleucine
    'ATT' => 'I',    # Isoleucine
    'ATG' => 'M',    # Methionine
    'ACA' => 'T',    # Threonine
    'ACC' => 'T',    # Threonine
    'ACG' => 'T',    # Threonine
    'ACT' => 'T',    # Threonine
    'AAC' => 'N',    # Asparagine
    'AAT' => 'N',    # Asparagine
    'AAA' => 'K',    # Lysine
    'AAG' => 'K',    # Lysine
    'AGC' => 'S',    # Serine
    'AGT' => 'S',    # Serine
    'AGA' => 'R',    # Arginine
    'AGG' => 'R',    # Arginine
    'GTA' => 'V',    # Valine
    'GTC' => 'V',    # Valine
    'GTG' => 'V',    # Valine
    'GTT' => 'V',    # Valine
    'GCA' => 'A',    # Alanine
    'GCC' => 'A',    # Alanine
    'GCG' => 'A',    # Alanine
    'GCT' => 'A',    # Alanine
    'GAC' => 'D',    # Aspartic Acid
    'GAT' => 'D',    # Aspartic Acid
    'GAA' => 'E',    # Glutamic Acid
    'GAG' => 'E',    # Glutamic Acid
    'GGA' => 'G',    # Glycine
    'GGC' => 'G',    # Glycine
    'GGG' => 'G',    # Glycine
    'GGT' => 'G',    # Glycine
    );

    if(exists $genetic_code{$codon}) {
        return $genetic_code{$codon};
    }else{
        print STDERR "Bad codon \"$codon\"!!\n";
        exit;
    }
}






my $example_to_test_the_very_extreme = "
Synpcc7942_2578 :: NC_007604 :: - :: 2663093 :: 2663566 :: SNP :: 2663540 :: AtoG :: DEBUGA--A
ori_reverse_DNA: TACCTTGACCCAAGCTGGGACGCTCTAGTCCCTTATTCTACCACGGTCGCTAGTGTCCGCGGATACTTCCAGATGCAAGACGAGATGTTGCGCCCGTGACTATTGCTCCCCTAGGTAAGCGAAAGCTAGCCCCTACTTTTGTAGTAGGACTACAAACTTCTGCTCCTACTACGGGTCGCGATGCGGTACAACGAGCTTCGCGTCCTGAAAGTCCGAGGGTAACAGCTTCGCTAACTGGCGCTTCTTCAGCTTCGAAAAACGGTTCTGAGGGGGATAGTCGGCGTTAACTAAGGGGCCCTAAAAGCTGGGTCGTTACTGAAACTTGCCAACGACGAGCGGGGCGGTCTCAACTTAGCGCTCCTTTGGCTAACCAGACTCCTACCAGCAAGCCGTCTGCAACGCCTACTCCTCCGTCTGAGTGATGGACGGTCACTAGAGCTTCGTAACGCAGCGGCAGATCTTCCGAACGAGAT
tr_reverse_DNA: ATGGAACTGGGTTCGACCCTGCGAGATCAGGGAATAAGATGGTGCCAGCGATCACAGGCGCCTATGAAGGTCTACGTTCTGCTCTACAACGCGGGCACTGATAACGAGGGGATCCATTCGCTTTCGATCGGGGATGAAAACATCATCCTGATGTTTGAAGACGAGGATGATGCCCAGCGCTACGCCATGTTGCTCGAAGCGCAGGACTTTCAGGCTCCCATTGTCGAAGCGATTGACCGCGAAGAAGTCGAAGCTTTTTGCCAAGACTCCCCCTATCAGCCGCAATTGATTCCCCGGGATTTTCGACCCAGCAATGACTTTGAACGGTTGCTGCTCGCCCCGCCAGAGTTGAATCGCGAGGAAACCGATTGGTCTGAGGATGGTCGTTCGGCAGACGTTGCGGATGAGGAGGCAGACTCACTACCTGCCAGTGATCTCGAAGCATTGCGTCGCCGTCTAGAAGGCTTGCTCTA
snp position in sequence: 2663093  2663540  447
snpDNA: ATGGAACTGGGTTCGACCCTGCGAGAgCAGGGAATAAGATGGTGCCAGCGATCACAGGCGCCTATGAAGGTCTACGTTCTGCTCTACAACGCGGGCACTGATAACGAGGGGATCCATTCGCTTTCGATCGGGGATGAAAACATCATCCTGATGTTTGAAGACGAGGATGATGCCCAGCGCTACGCCATGTTGCTCGAAGCGCAGGACTTTCAGGCTCCCATTGTCGAAGCGATTGACCGCGAAGAAGTCGAAGCTTTTTGCCAAGACTCCCCCTATCAGCCGCAATTGATTCCCCGGGATTTTCGACCCAGCAATGACTTTGAACGGTTGCTGCTCGCCCCGCCAGAGTTGAATCGCGAGGAAACCGATTGGTCTGAGGATGGTCGTTCGGCAGACGTTGCGGATGAGGAGGCAGACTCACTACCTGCCAGTGATCTCGAAGCATTGCGTCGCCGTCTAGAAGGCTTGCTCTA
T g 26 :: oriProtein: MELGSTLRDQGIRWCQRSQAPMKVYVLLYNAGTDNEGIHSLSIGDENIILMFEDEDDAQRYAMLLEAQDFQAPIVEAIDREEVEAFCQDSPYQPQLIPRDFRPSNDFERLLLAPPELNREETDWSEDGRSADVADEEADSLPASDLEALRRRLEGLL
MutProtein: MELGSTLREQGIRWCQRSQAPMKVYVLLYNAGTDNEGIHSLSIGDENIILMFEDEDDAQRYAMLLEAQDFQAPIVEAIDREEVEAFCQDSPYQPQLIPRDFRPSNDFERLLLAPPELNREETDWSEDGRSADVADEEADSLPASDLEALRRRLEGLL
D E 8
#all finished!

in this case the A becomes G ... but it is in reverse strand, so the T will become G !   
"; 







        #print $contig,":",$start,"\n";
        
        # $data[5] = "X";
        
		# mutated DNA and protein 
        # $contig =~ eval "tr/$data[4]/$data[5]/, $snp_position"  ;
        # substr( $contig, $_, 1 ) =~ tr/A/X/ for  $snp_position;;
        # substr($contig, index($contig, $data[4]), $snp_position) = $data[5];

