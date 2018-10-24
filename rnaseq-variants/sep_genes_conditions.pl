# de duleuei.

my $genes_with_SNPs_file = "/Users/billis/google_drive/myProjects/auth/snp/network/test/genes_withmorethan2snps_condition.txt";

my $split_patern_ = " ";

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