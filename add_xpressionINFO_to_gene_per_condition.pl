# replace gene and condition with expression value. 
use warnings;
use strict;


my $expression_S7 = "/Users/kbillis/Documents/myProjects/auth/snp/data/expression_data_S7.txt";
my $split_patern = "\t";
my %gene_condition;
my @header; 


# if I want to use RPKM =1 else Log.
my $RPKM = 0;

open(EXP,$expression_S7) or die "Can't open $expression_S7 !\n";
while(<EXP>){
    chomp($_);
    if ( $_=~/^#/){ 
        @header = split(/$split_patern/,$_);

    }
    
    my @data = split(/$split_patern/,$_);
    my $gene= $data[1];
    my ($i, $start, $stop); 
    
    if ($RPKM == 1) {
    	$start = 3; 
    	$stop = 16;
    } else {
        $start = 18;
        $stop = 28;
    }
    
    for (my $i=$start; $i<$stop; $i++) {    
        my @data = split(/$split_patern/,$_);
        my $gene= $data[1];
    
        $gene_condition{$gene}{$header[$i]} = $data[$i] ;
    
    }    

}    
close EXP; 	



# my $genes_with_SNPs_file = "/Users/kbillis/Documents/myProjects/auth/snp/results/genes_with_snps_per_conditions_filterFree.tab" ;

# we don't use Nitrogen condition for the paper! 
my $genes_with_SNPs_file = "/Users/kbillis/Documents/myProjects/auth/snp/results/gene_only.tab";

my $split_patern_ = "\t";

open(GEN,$genes_with_SNPs_file) or die "Can't open $genes_with_SNPs_file!\n";
while(<GEN>){
    chomp($_);
    if ($_=~/^#/) { 
        next;
    }

    my @data_ = split(/$split_patern_/,$_);

    # print "$snp_pos \n";
    for (my $y =0; $y<=$#data_; $y++) {
        if ( $gene_condition{$data_[$y]}{$data_[1]} ) {
            print $gene_condition{$data_[$y]}{$data_[1]} . "\t";
            # print $data_[$y] . "_" .$gene_condition{$data_[$y]}{$data_[1]} . "\t"; # to check
	    } else { 
	        print "$data_[$y]" . "\t"  ;	    
	    }
	}
	print "\n";
	
} 
close GEN; 	
