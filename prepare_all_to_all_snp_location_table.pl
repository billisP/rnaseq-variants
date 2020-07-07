use warnings;
use strict;



my $vcf_all_file = "/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA_all_data/VEP_results/vari_sour_feat.tab"; 

my %snps;
my %samples; 
my %found; 

open(ALL,$vcf_all_file) or die "Can't open $vcf_all_file!\n";
while(<ALL>){
    chomp($_);
    my @tmp = split('\t', $_);
    
    $snps{$tmp[0]} = 1;
	$samples{$tmp[2]} = 1; 
	$found{$tmp[0]}{$tmp[2]} = 1
}
close ALL;

my %hash_of_hash; 
foreach my $sam_tmp (keys %samples) {
	foreach my $snp_tmp (keys %snps) {
        if ($found{$snp_tmp}{$sam_tmp}) {
        	print $snp_tmp . "\t" . $sam_tmp . "\t" . 1 . "\n" ; 
        } else {
        	print $snp_tmp . "\t" . $sam_tmp . "\t" . 0 . "\n" ;
        }
        
	}
}


