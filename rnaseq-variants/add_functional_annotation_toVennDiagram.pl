# add_functional_annotation_toVen_diagram output

# “elements” output of 2.4 step
# /Users/billis/google_drive/myProjects/auth/snp/data/where_is/snpPosition_locusTag.tab 
# /Users/billis/google_drive/myProjects/auth/snp/data/locusTag_function_cassette_COG.txt

use strict;
use warnings; 


add_functional_info_to_grouped_g();

sub add_functional_info_to_grouped_g {
my $locusTag_FunAnnot= "/Users/billis/google_drive/myProjects/auth/snp/data/locusTag_function_cassette_COG.txt"; 
my $snpPos_locusTag = "/Users/billis/google_drive/myProjects/auth/snp/data/where_is/snpPosition_locusTag.tab";
my $ouputOf_R_venScript= "/Users/billis/google_drive/myProjects/auth/snp/results/venDiagrams_data/test.out";
my %snpP_locTag;
my %locTag_FuAn;
my $last_element = "";

open(LA,$locusTag_FunAnnot) or die "Can't open $locusTag_FunAnnot !\n";
while(<LA>){
    chomp($_);
    my @data = split(";",$_);
    $last_element = $data[3] if ($data[3]);  
    $locTag_FuAn{$data[0]} = $data[1] . "." . $data[2] . "." .$last_element;
}
close(LA);


open(SG,$snpPos_locusTag) or die "Can't open $snpPos_locusTag !\n";
while(<SG>){
    chomp($_);
    my @data = split('\s',$_);
    if ($snpP_locTag{$data[0]}) {
    	$snpP_locTag{$data[0]} = $data[1] . "." . $snpP_locTag{$data[0]} ;
    } else {
    	$snpP_locTag{$data[0]} = $data[1] ;
    }
}
close(SG);


my @all_per_group; 
my @arr_occ;
open(RO,$ouputOf_R_venScript) or die "Can't open $ouputOf_R_venScript !\n"; 
while(<RO>){ 
    chomp($_); 
    if ( $_=~/^\$/){ 
    	count_occurence(@arr_occ) if ($#arr_occ > 0);
    	print "\n" . $_ . "\n";
    	@arr_occ = ();
    } else {
    	my @array = split (/"/, $_); 
    	foreach my $element (@array) {
    		if ($snpP_locTag{$element}) {
    		    next if ($snpP_locTag{$element} eq "Intergenic" ); # skip the intergenic 
    			my @array_s2 = split('\.', $snpP_locTag{$element}); 
    			my $one = $array_s2[0]; 
    			my $two = $array_s2[1];
    			# print $_ . "line \n";
    			# print $element . " " . $snpP_locTag{$element} .  "  ->" . $one . " " . $two .  " " . "\n" ;

    			# print "--->" . $element . " " . $snpP_locTag{$element} . " " . $locTag_FuAn{$array_s2[0]} ."\n" if ($locTag_FuAn{$array_s2[0]}); 
    			# print "--->" . $element . " " . $snpP_locTag{$element} . " " . $locTag_FuAn{$array_s2[1]} ."\n" if ($locTag_FuAn{$array_s2[1]});
    			push(@arr_occ, $locTag_FuAn{$array_s2[0]} . " " . $snpP_locTag{$element} . " " . $element ) if ($locTag_FuAn{$array_s2[0]}); 
    			push(@arr_occ, $locTag_FuAn{$array_s2[1]} . " " . $snpP_locTag{$element} . " " . $element ) if ($locTag_FuAn{$array_s2[1]}); 
    		}
    	}    
    }
} 
close(RO);

count_occurence(@arr_occ) if ($#arr_occ > 0);

}


# R_script_for_venn_diagram();


sub count_occurence {
	my @data_arra = @_;

	my %count;  
	@data_arra = sort @data_arra;
	foreach my $l (@data_arra) {
    	$l =~ s/,//g; 
    	$l =~ s/\./ /g; 
		print $l . "\n";
        foreach my $str (split /\s+/, $l) {
        	$count{$str}++;
    	}
	}
	foreach my $str (sort keys %count) {
	    if ( ($count{$str} > 5) && ($str ne "-") && ($str ne "hypothetical") && ($str ne "and") && ($str ne "protein") && ($str ne "Intergenic")  ) {
	    	printf "%-31s %s\n", $str, $count{$str} ;
	    	
	    }
	}
	# print $#data_arra . "\n"; 

}


sub R_script_for_venn_diagram {

my $file_save = "";

print 'files_path="~/Downloads/expression_wigs/"
#read all file names in the directory and save in a vector
only_files <- dir(path=files_path, pattern = "*.wig") 
files = paste(files_path,only_files, sep="")

# to see the table (Sense)
snp <- read.csv(files[1], sep=" ", row.names=2, header=TRUE)[c()]
snp_aaEff <- read.csv(files[1], sep=" ", row.names=2, header=TRUE)[c()]

for (i in 1:length(files)) {
  xx_snp <- read.csv(files[i], sep=" ", header=TRUE)[c(5)]
  xx_snp_aaEff <- read.csv(files[i], sep=" ", header=TRUE)[c(6)]
  
  xx_snp <- cbind(xx_snp)
  snp = cbind(snp, xx_snp)
  colnames(snp)[i] <- only_files[i]

  xx_snp_aaEff <- cbind(xx_snp_aaEff)
  snp_aaEff = cbind(snp_aaEff, xx_snp_aaEff)
  colnames(snp_aaEff)[i] <- only_files[i]
}

rowS<-rowSums(snp)
colS<-colSums(snp)
CO<-colS[c("Reference.wig","CO2_1_h.wig","CO2_24_h.wig")]
light<-colS[c("Reference.wig","light_1_h.wig","light_24_h.wig")]
nacl<-colS[c("Reference.wig","NaCl_1_h.wig","NaCl_24_h.wig")]
ph<-colS[c("Reference.wig","pH_1_h.wig","pH_24_h.wig")]
temp<-colS[c("Reference.wig","Temp_1_h.wig","Temp_24_h.wig")]

rowS_aa<-rowSums(snp_aaEff)
colS_aa<-colSums(snp_aaEff)

CO_aa<-colS_aa[c("Reference.wig","CO2_1_h.wig","CO2_24_h.wig")]
light_aa<-colS_aa[c("Reference.wig","light_1_h.wig","light_24_h.wig")]
nacl_aa<-colS_aa[c("Reference.wig","NaCl_1_h.wig","NaCl_24_h.wig")]
ph_aa<-colS_aa[c("Reference.wig","pH_1_h.wig","pH_24_h.wig")]
temp_aa<-colS_aa[c("Reference.wig","Temp_1_h.wig","Temp_24_h.wig")]

dataM=cbind(CO, CO_aa)
dataM=cbind(light, light_aa)
dataM=cbind(nacl, nacl_aa)
dataM=cbind(ph, ph_aa)
dataM=cbind(temp, temp_aa)

rowS<-rowSums(snp)
rowS_aa<-rowSums(snp_aaEff)
snp_only<-snp[rowS>0,]
snp_aaEff_only<-snp_aaEff[rowS_aa>0,]


Intersect_b <- function (x) {  
  # Multiple set version of intersect
  # x is a list
  if (length(x) == 1) {
    unlist(x)
  } else if (length(x) == 2) {
    intersect(x[[1]], x[[2]])
  } else if (length(x) > 2){
    intersect(x[[1]], Intersect(x[-1]))
  }
}

Union_b <- function (x) {  
  # Multiple set version of union
  # x is a list
  if (length(x) == 1) {
    unlist(x)
  } else if (length(x) == 2) {
    union(x[[1]], x[[2]])
  } else if (length(x) > 2) {
    union(x[[1]], Union(x[-1]))
  }
}

Setdiff_b <- function (x, y) {
  # Remove the union of the ys from the common xs. 
  # x and y are lists of characters.
  xx <- Intersect_b(x)
  yy <- Union_b(y)
  setdiff(xx, yy)
}




# xx.1 <- list(CO2_1=snp_only$CO2_1_h.wig , CO2_24=snp_only$CO2_24_h.wig , ref=snp_only$Reference.wig ) 
# xx.1 <- list(light_1=snp_only$light_1_h.wig ,light_24= snp_only$light_24_h.wig , ref=snp_only$Reference.wig)
xx.1 <- list(NaCl_1=snp_only$NaCl_1_h.wig ,NaCl_24= snp_only$NaCl_24_h.wig , ref=snp_only$Reference.wig)
# xx.1 <- list(ph_1=snp_only$pH_1_h.wig , ph_24=snp_only$pH_24_h.wig , ref=snp_only$Reference.wig)
# xx.1 <- list(Temp_1=snp_only$Temp_1_h.wig , Temp_24=snp_only$Temp_24_h.wig , ref=snp_only$Reference.wig)

# Create a list of all the combinations
combs <- unlist(lapply(1:length(xx.1), function(j) combn(names(xx.1), j, simplify = FALSE)), recursive = FALSE)
names(combs) <- sapply(combs, function(i) paste0(i, collapse = ""))
str(combs)
elements <-  lapply(combs, function(i) Setdiff_b(xx.1[i], xx.1[setdiff(names(xx.1), i)]))
n.elements <- sapply(elements, length)
print(n.elements)



'

}

