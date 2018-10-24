use warnings;
use strict;


my $expression_S7 = "/Users/kbillis/google_drive/myProjects/auth/snp/data_from_others/uniprot_S7_id_locusTag.tab"; 
my $Bradyrhizobium_japonicum_proteome_file = "/Users/kbillis/google_drive/myProjects/auth/snp/data_from_others/uniprot_proteome_Bradyrhizobium_japonicum.txt";

my $split_patern = "\t";
my %gene_replace;
my %protein_name; 
my @header;



open(EXP,$Bradyrhizobium_japonicum_proteome_file) or die "Can't open $Bradyrhizobium_japonicum_proteome_file !\n";
while(<EXP>){
    chomp($_);

    my @data = split(/\t/,$_);
    my $key = $data[0]; 
    $protein_name{$key} = $data[2] ; 
    # print $key . "--" . $data[1]  . "--\n"; 

}    
close EXP; 


# if I want to use RPKM =1 else Log.
open(EXP,$expression_S7) or die "Can't open $expression_S7 !\n";
while(<EXP>){
    chomp($_);

    my @data = split(/$split_patern/,$_);
    my $key = $data[1]; 
    my $loc_tag= $data[4]; # locus tag
    $gene_replace{$key} = $loc_tag ;
    $protein_name{$key} = $data[2] ; 
    # print $key . "--" . $loc_tag  . "--\n"; 

}    
close EXP; 


my $genes_with_SNPs_file = "/Users/kbillis/google_drive/myProjects/auth/snp/data_from_others/blastp.Synechococcus_ids_with_2orMore_snps_proteins.VS.Uniprot_Bradyrhizobium_hardFilter.out";

my $split_patern_ = "\t";

open(GEN,$genes_with_SNPs_file) or die "Can't open $genes_with_SNPs_file!\n";
while(<GEN>){
    chomp($_);
    if ($_=~/^#/) {
        next;
    }

    my @data_ = split(/$split_patern_/,$_);
    my @data1_ = split(/\|/,$data_[0]);
    my @data2_ = split(/\|/,$data_[1]);

    my $tmp_gg = $data1_[2];
    my $tmp_gg_2 =  $data2_[1];
    print $data_[0] . " " . $gene_replace{$tmp_gg} . "||" . $protein_name{$tmp_gg} . "||" . $data_[1] . "||" . $protein_name{$tmp_gg_2} . "||" . $data_[10] . "\n"; 
}
close GEN; 
