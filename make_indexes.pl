# This script takes to prepare bwa and samtools indexes


use strict;
use warnings;

# 
my $ref_Genome  = $ARGV[0]; 
# my $bwa = $ARGV[1]; 




my $genome_bwt = $ref_Genome . ".bwt";    
my $genome_fai = $ref_Genome . ".fai";
if ( (-r $genome_fai) and (-r $genome_bwt) ) {
   print "genome indexes are there\n"; 
} else {
   print "make_indexes.pl:No index dude! I will do it... \n" ; 
   index_genome($ref_Genome); 
}




sub index_genome {
my $genome = shift; 

my $bwa = "bwa "; 
my $samtools = "samtools "; 

system("$bwa index -a bwtsw $genome");
	if ( $? == -1 ) {
		die("command failed: $!");
 	} else {
		printf "success: command exited with value %d", $? >> 8;
	}

print "\n";

system("$samtools faidx $genome");
	if ( $? == -1 ){
		die("command failed: $!");
	} else {
		printf "success: command samtools faidx exited with value %d", $? >> 8;
	}
}

print "\n\n\n";

