use warnings;
use strict;


my $expression_S7 = "/Users/billis/google_drive/myProjects/auth/snp/network/GeneCart18204_20-mar-2016.txt";
my $split_patern = "\t";
my %gene_replace;
my @header;


# if I want to use RPKM =1 else Log.
my $RPKM = 0;

open(EXP,$expression_S7) or die "Can't open $expression_S7 !\n";
while(<EXP>){
    chomp($_);
    if ( $_=~/^Gene/){
        @header = split(/$split_patern/,$_);
    }

    my @data = split(/$split_patern/,$_);
    my $loc_tag= $data[1]; # locus tag
    $gene_replace{$loc_tag} = $data[0] ;
}    
close EXP; 


my $genes_with_SNPs_file = "/Users/billis/google_drive/myProjects/auth/snp/network/test/genes_withmorethan2snps_condition.txt";

my $split_patern_ = "\t";

open(GEN,$genes_with_SNPs_file) or die "Can't open $genes_with_SNPs_file!\n";
while(<GEN>){
    chomp($_);
    if ($_=~/^#/) {
        next;
    }

    my @data_ = split(/$split_patern_/,$_);
    print $gene_replace{$data_[0]} . " " . $data_[1] . " " . $data_[2] . "\n"; 
}
close GEN; 
