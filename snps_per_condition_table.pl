# make a summary file/table with conditions and SNPs. 

use strict;
use warnings;


my $home_dir= "/Users/kbillis/";
# my $dir = "$home_dir/google_drive/myProjects/auth/snp/data/vcf_files_308/";  # my cyanobacteria
my $dir = "/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA196229/";

# original vcf files
# my @files = glob "$dir/12*.vcf"; # my cyanobacteria
my @files = glob "$dir/SR*fastq.gz-tuned.vcf";

# hash with samples_ids and samples_names
my $samples_id_names_file = "$home_dir/google_drive/myProjects/auth/snp/metadata/cyano_sample_id_sample_name.txt";
my %hash_samples_id_names;

open(IDS,  "$samples_id_names_file")  or die($!);
	while (<IDS>) {
   	chomp;
    next if (/^#/); 
    my @fields = split(/\s/, $_);
    	$hash_samples_id_names{$fields[1]} = $fields[0] ;
	}
close IDS;

# IF I AM NOT WRONG, this file has all the locations with SNPs
my $vcf_all_file = "/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA196229/all.vcf"; 
# my $vcf_all_file = "$home_dir/google_drive/myProjects/auth/snp/data/vcf_files_308/all.vcf"; # my cyanobacteria
my %snps;

open(ALL,$vcf_all_file) or die "Can't open $vcf_all_file!\n";
while(<ALL>){
    chomp($_);
	$snps{$_} = 1;
}
close ALL;




# Gene or aa or YesNo or snp_position or Quality or snps_per_gene_per_condition or intergenic
my $whatToPrint = "snps_per_gene_per_condition"; 


if ($whatToPrint eq "snps_per_gene_per_condition") {
	# make format condition gene number of SNPs
	
	my %load_all_genes_with_SNPs; 
    # WHERE file_all_come from. 
    # $ awk '{print $3,$1}'  /Users/kbillis/google_drive/myProjects/auth/snp/data/where_is/*-sorted.bam_RMDUP.bam.raw.bcf.vcf.where_is_2.tab | grep -v "#" | sort |  uniq | wc
    # 3657    7314   76810
    # $ wc  /Users/kbillis/google_drive/myProjects/auth/s	np/data/where_is/snpPosition_locusTag.tab
    # 3657    7314   76810 /Users/kbillis/google_drive/myProjects/auth/snp/data/where_is/snpPosition_locusTag.tab
    # 1000769 Intergenic
    # 1000769 Synpcc7942_0992
	# my $file_all = "$home_dir/google_drive/myProjects/auth/snp/data/where_is/snpPosition_locusTag.tab"; 
    my $file_all = "$dir/snpPosition_locusTag.tab";

	foreach my $vcf_file (@files) {
        # this is to store all 
        my %number_of_snps_perGene_and_per_Condition; # key is each gene. Probably should use a gff file. 
        open(ALL,$file_all) or die "Can't open $file_all!\n";
            while(<ALL>){
                if ( ($_=~/^#/) or ($_ =~/NC_007595/) or ($_ =~/Intergenic/) ){ 
                    next; 
                }
                my @data_all = split('\s',$_);
                $number_of_snps_perGene_and_per_Condition{$data_all[1]} = 0 ;
            }
        close ALL; 	

        # $vcf_file =~ s/\-sorted.bam_RMDUP.bam.raw.bcf.vcf$//;
        my @tmp = split('/', $vcf_file);

        @tmp = split('\.', $tmp[$#tmp]); 

        print "$tmp[0]\t" . $hash_samples_id_names{$tmp[0]} . "\n";

        # $vcf_file = "$home_dir/google_drive/myProjects/auth/snp/data/where_is/$tmp[$#tmp]";
        # $vcf_file = $vcf_file . "-sorted.bam_RMDUP.bam.raw.bcf.vcf.where_is_2.tab"; 
        my $split_patern = "\t";
        print "VCF_files_is: $vcf_file \n";
        open(VCF,$vcf_file) or die "Can't open $vcf_file!\n";
            while(<VCF>){
                chomp($_);
                if ( ($_=~/^#/) or ($_ =~/NC_007595/) or ($_ =~/Intergenic/) ){ 
                    # store header and comment fields
                    # print "\n##############\n";
                    next;
                }
                my @data = split(/$split_patern/,$_);
                my $snp_pos = $data[1];
                my $corresponding_gene = $data[0]; 
                if ( $number_of_snps_perGene_and_per_Condition{$corresponding_gene} ){
                    $number_of_snps_perGene_and_per_Condition{$corresponding_gene}++ ;
                } else { 
                    $number_of_snps_perGene_and_per_Condition{$corresponding_gene} = 1 ;
                } 
            }
        close VCF;

        my $output = $vcf_file . "_countsPerCondition.tab"; 
        open(OUT,'>',$output) or die "Can't open out \n" ; 
        foreach my $g_c (keys %number_of_snps_perGene_and_per_Condition) {
            print OUT $g_c . "\t" . $number_of_snps_perGene_and_per_Condition{$g_c} . "\t" . $hash_samples_id_names{$tmp[0]} . "\t" . "$tmp[0]" . "\n";
        }
        close OUT; 
        print "OUT_files_is: $output \n";
    }
}



if ($whatToPrint eq "intergenic") {
    my %load_all_genes_with_SNPs; 
    my $file_all = "$home_dir/google_drive/myProjects/auth/snp/data/where_is/snpPosition_locusTag.tab"; 

    foreach my $vcf_file (@files) {
        # this is to store all snps positions, then I will check if there are in annotated genes or only in intergenic regions 
        my %snp_positions; 
        open(ALL,$file_all) or die "Can't open $file_all!\n";
        while(<ALL>){
            if ( ($_=~/^#/) or ($_ =~/NC_007595/) ){ 
               next; 
            }
            my @data_1 = split('\s',$_);
            $snp_positions{$data_1[0]} = 0 ;
        }
        close ALL;  


        $vcf_file =~ s/\-sorted.bam_RMDUP.bam.raw.bcf.vcf$//;
        my @tmp = split("/", $vcf_file);
        # print "$tmp[$#tmp]\t" . $hash_samples_id_names{$tmp[$#tmp]} . "\t";
        $vcf_file = "$home_dir/google_drive/myProjects/auth/snp/data/where_is/$tmp[$#tmp]";
        $vcf_file = $vcf_file . "-sorted.bam_RMDUP.bam.raw.bcf.vcf.where_is_2.tab"; 
        my $split_patern = "\t"; 
        # print "$vcf_file \n";
        my $switch = 0; 
        open(VCF,$vcf_file) or die "Can't open $vcf_file!\n";
        while(<VCF>){
            chomp($_);
            my @data_int = split('\t',$_);
            my $snp_pos = $data_int[2];

            if ($_ =~/NC_007595/){ 
                next;
            } elsif ($_=~/^#/){
                $switch = 0; 
            } elsif ($_=~/Intergenic/){
                $switch = $switch +1 ; 
            } else {
               # print $_ . "not really possible\n";
            }
        
            if ($switch == 2) {
               print  $hash_samples_id_names{$tmp[$#tmp]} . " I found a intergenic $snp_pos\n";
            }
        }
    }
}


if ($whatToPrint eq "aa") {
  foreach my $vcf_file (@files) {
	
    # /Users/kbillis/Documents/myProjects/auth/snp/data/aa_change	
	# /Users/kbillis/Documents/myProjects/auth/snp/data/aa_change/1266.1.1258-sorted.bam_RMDUP.bam.raw.bcf.vcf.where_is_2.tab.txt
    # /Users/kbillis/Documents/myProjects/auth/snp/data/vcf_files_308/1266.1.1258-sorted.bam_RMDUP.bam.raw.bcf.vcf
    # /Users/kbillis/Documents/myProjects/auth/snp/data/where_is/1266.1.1258-sorted.bam_RMDUP.bam.raw.bcf.vcf.where_is_2.tab
	
	# print "$vcf_file \n";

    $vcf_file =~ s/\-sorted.bam_RMDUP.bam.raw.bcf.vcf$//;

	my @tmp = split("/", $vcf_file); 
	print "$tmp[$#tmp]\t" . $hash_samples_id_names{$tmp[$#tmp]} . "\t";

    $vcf_file = "$home_dir/google_drive/myProjects/auth/snp/data/aa_change/$tmp[$#tmp]";
    $vcf_file = $vcf_file . "-sorted.bam_RMDUP.bam.raw.bcf.vcf.where_is_2.tab.txt";
    
    # print "$vcf_file \n";
    
    my $split_patern = " :: ";
    
	my %snp_perCondition; 
    open(VCF,$vcf_file) or die "Can't open $vcf_file!\n";
    while(<VCF>){
        chomp($_);
        if ( ($_=~/^#/) or ($_ =~/NC_007595/) ){ 
        	# store header and comment fields
        	# print "\n##############\n";
        	next;
        }

        my @data = split(/$split_patern/,$_);
        my $snp_pos = $data[6];
        # print "$snp_pos \n";
        if ( (length($data[10])) > 2 ) {
	        $snp_perCondition{$snp_pos} = $data[10] ;
	    } else { 
	        $snp_perCondition{$snp_pos} = "NoChange" ;
	    
	    }     
    }
    close VCF; 	
	
	# check which snps has this file 
	
	foreach my $snp (keys %snps) {
	# print $snp . "\n";
		if ($snp_perCondition{$snp}) {
			print "$snp_perCondition{$snp}" . "_" . $snp . "\t"; 
			# print "$snp_perCondition{$snp}\t"; 
		} else {
			print "0\t"; 
		}
	}
	print "\n";

  }
}



if ($whatToPrint eq "Gene") {
  foreach my $vcf_file (@files) {
	
    # /Users/kbillis/Documents/myProjects/auth/snp/data/aa_change	
	# /Users/kbillis/Documents/myProjects/auth/snp/data/aa_change/1266.1.1258-sorted.bam_RMDUP.bam.raw.bcf.vcf.where_is_2.tab.txt
    # /Users/kbillis/Documents/myProjects/auth/snp/data/vcf_files_308/1266.1.1258-sorted.bam_RMDUP.bam.raw.bcf.vcf
    # /Users/kbillis/Documents/myProjects/auth/snp/data/where_is/1266.1.1258-sorted.bam_RMDUP.bam.raw.bcf.vcf.where_is_2.tab
	
	# print "$vcf_file \n";

    $vcf_file =~ s/\-sorted.bam_RMDUP.bam.raw.bcf.vcf$//;

	my @tmp = split("/", $vcf_file); 
	print "$tmp[$#tmp]\t" . $hash_samples_id_names{$tmp[$#tmp]} . "\t";

    $vcf_file = "$home_dir/google_drive/myProjects/auth/snp/data/aa_change/$tmp[$#tmp]";
    $vcf_file = $vcf_file . "-sorted.bam_RMDUP.bam.raw.bcf.vcf.where_is_2.tab.txt";
    
    # print "$vcf_file \n";
    
    my $split_patern = " :: ";
    
	my %snp_perCondition; 
    open(VCF,$vcf_file) or die "Can't open $vcf_file!\n";
    while(<VCF>){
        chomp($_);
        if ( ($_=~/^#/) or ($_ =~/NC_007595/) ){ 
        	# store header and comment fields
        	# print "\n##############\n";
        	next;
        }

        my @data = split(/$split_patern/,$_);
        my $snp_pos = $data[6];
        # print "$snp_pos \n";
        $snp_perCondition{$snp_pos} = $data[0] ; 
    }
    close VCF; 	
	
	# check which snps has this file 
	
	foreach my $snp (keys %snps) {
	# print $snp . "\n";
		if ($snp_perCondition{$snp}) {
			# print "$snp_perCondition{$snp}" . "_" . $snp . "\t"; 
			print "$snp_perCondition{$snp}\t"; 
		} else {
			print "0\t"; 
		}
	}
	print "\n";

  }
}



if ($whatToPrint eq "YesNo") {

  foreach my $vcf_file (@files) {
	# my $test =1;
	# print "$vcf_file \n";

	my %snp_perCondition; 
    open(VCF,$vcf_file) or die "Can't open $vcf_file!\n";
    while(<VCF>){
        chomp($_);
        if ( ($_=~/^#/) or ($_ =~/^NC_007595/) ){ 
        	# store header and comment fields
        	# print "\n##############\n";
        	next;
        }

        my @data = split(/\t/,$_);
        my $snp_pos = $data[1];
        # print "$snp_pos \n";
        $snp_perCondition{$snp_pos} = 1; 
    }
    close VCF; 
    
    $vcf_file =~ s/\-sorted.bam_RMDUP.bam.raw.bcf.vcf$//;
	my @tmp = split("/", $vcf_file); 
	print "$tmp[$#tmp]\t" . $hash_samples_id_names{$tmp[$#tmp]} . "\t";
	
	# check which snps has this file 	
	foreach my $snp (sort { $snps{$b} <=> $snps{$a} } keys %snps ) {
	# print $snp . "\n";
	
		if ($snp_perCondition{$snp}) {
			print "$snp_perCondition{$snp}" . "_" . $snp . "\t"; 
		} else {
			print "0\t"; 
		}
	}
	print "\n";

  }
  
}  



if ($whatToPrint eq "snp_position") {
	foreach my $snp (keys %snps) {
		print $snp . "\t";
	}
	print "\n";

}


if ($whatToPrint eq "Quality") {

  foreach my $vcf_file (@files) {
	# my $test =1;
	# print "$vcf_file \n";

	my %snp_perCondition; 
    open(VCF,$vcf_file) or die "Can't open $vcf_file!\n";
    while(<VCF>){
        chomp($_);
        if ( ($_=~/^#/) or ($_ =~/^NC_007595/) ){ 
        	# store header and comment fields
        	# print "\n##############\n";
        	next;
        }

        my @data = split(/\t/,$_);
        my $snp_pos = $data[1];
        # print "$snp_pos \n";
        # for filter only 5... for all 5..$#data 
        # my $tmp_st = $data[5] ; # join("_", @data[5..$#data]);

        my $tmp_st = join("_", @data[6..$#data]);
        $snp_perCondition{$snp_pos} = $tmp_st ; 
    }
    close VCF; 
    
    $vcf_file =~ s/\-sorted.bam_RMDUP.bam.raw.bcf.vcf$//;
	my @tmp = split("/", $vcf_file); 
	print "$tmp[$#tmp]\t" . $hash_samples_id_names{$tmp[$#tmp]} . "\t";
	
	# check which snps has this file 
	
	foreach my $snp (sort { $snps{$b} <=> $snps{$a} } keys %snps ) {
	# print $snp . "\n";
	
        #if ($snp=~/142064/) {
        #	print "found1!!\n";
        #} else {
        #	$test =0;
        #	next;
        #}	
		if ($snp_perCondition{$snp}) {
			# print "$snp_perCondition{$snp}" . "_" . $snp . "\t"; 
			print "$snp_perCondition{$snp}" . "\t"; 
		} else {
			print "0\t"; 
		}
	}
	print "\n";

  }
  
}  



# not working! 
sub print_res {
	
	my ($vcf_file, %hash_samples_id_names, %snps, %snp_perCondition) = @_; 
	
    $vcf_file =~ s/\-sorted.bam_RMDUP.bam.raw.bcf.vcf$//;
	my @tmp = split("/", $vcf_file); 
	print "$tmp[$#tmp]\t" . $hash_samples_id_names{$tmp[$#tmp]} . "\t";
	
	# check which snps has this file 
	
	foreach my $snp (keys %snps ) {
	    print $snp . "\n";
		if ($snp_perCondition{$snp}) {
			print "$snp_perCondition{$snp}" . "_" . $snp . "\t"; 
		} else {
			print "0\t"; 
		}
	}
	print "\n";


}

  
  
