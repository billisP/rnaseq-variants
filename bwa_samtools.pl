
# This script takes a fastq and results in a vcf


use strict;
use warnings;
use Getopt::Long;

# 
my $working_dir = $ARGV[0]; 
my $fastq       = $ARGV[1];
my $ref_Genome  = $ARGV[2]; 

print "how to run: 
perl bwa_samtools.pl WORKING_DIRECTORY FASTQ_FILE GENOME_FILE \n " if (!defined($working_dir) or !defined($fastq) or !defined($ref_Genome) ) ; 




my $genome_fai = $ref_Genome . ".bwt";	
if (-r $genome_fai){
	print "genome indexes are there"; 
} else {
	die("bwa_samtools.pl:No index dude! "); 
	# index_genome($genome); 
}
my $sorted_bam= run_bwa($ref_Genome, $fastq); 
my $remove_duplications_bam=remove_duplications_from_bam_file($sorted_bam);




### M A I N      F U N C T I O N S   ###

sub run_bwa {
	my ($genome, $fastq) = @_;

	my $name=$fastq;
	# $name=~s/.fastq//;

	my $bwa = "bwa "; 
	my $samtools = "samtools "; 

	print "\n## start... sampel: $fastq ... name: $name  ## \n";

	
	print "commandsToRun: aln \n";
	my $sai= $name . ".sai";
	system("$bwa aln $genome $fastq > $sai");
	if ( $? == -1 ) {
		print "command failed: $!\n";
	} else {
		printf "\ncommand bwa aln exited with value %d", $? >> 8;
	}
	print "\n----alignment is ready\n";


	# to make the SAM (results) file
	my $sam= $name . ".sam";
	system("$bwa samse -n 10 $genome $sai $fastq > $sam");
	if ( $? == -1 ) {
		die("command failed: $!");
	}else{
		printf "\ncommand bwa samse -n 10 exited with value %d", $? >> 8;
	}
	print "\n----bwa work is done (sam file is ready)\n";


	my $del = delete_file($fastq); 
	$del = delete_file($sai); 



	## SAMTOOLS ####

	my $bam = $name . ".bam";	
	my $genome_fai = $genome . ".fai";	
	
	print "\ncmd: samtools view\n"; 
	system("$samtools view -bt $genome_fai $sam > $bam");
	if ( $? == -1 ) {
		die("command failed: $!\n");
	}else{
		printf "\ncommand samtools view -bt exited with value %d", $? >> 8;
	}
	print "----BAM is ready";

	$del = delete_file($sam); 


	my $sorted= $name . "-sorted.bam";
	system("$samtools sort $bam -o $sorted");
	if ( $? == -1 ) {
		die("command_ sort _failed: $!");
	} else{
		printf "\ncommand samtools sort exited with value %d", $? >> 8;
	}

	$del = delete_file($bam); 


	print "\ncommand_index: samtools index \n";
	system("$samtools index $sorted");
	if ( $? == -1 ){
		die("command failed: $!");
	}else{
		printf "\ncommand samtools index exited with value %d", $? >> 8;
	}
	
	print "\n----BAM-sorted is ready:\n";
	print "$name complete\n";

	
	print "\ncommand_flagsta: samtools flagstat \n";
	system("$samtools flagstat $sorted");
	if ( $? == -1 ){
		die("command failed: $!");
	}else{
		printf "command samtools flagstat exited with value %d", $? >> 8;
	}
	
	print "\n----flagstat is ready:\n";
	print "## $name complete ##\n";

return $sorted; 
} 


sub remove_duplications_from_bam_file {
	my $bam_file = shift; 
	
	my $bam_no_duplications = $bam_file . ".dupl.bam";  
	my $samtools = "samtools "; 
	print "\ncommand: samtools rmdup (remove duplicationed reads) \n";
	system("$samtools rmdup -s $bam_file  $bam_no_duplications");
	if ( $? == -1 ){
		print "command failed: $!\n";
	}else{
		printf "\ncommand samtools index exited with value %d", $? >> 8;
	}
	print "\n----remove duplications is ready:\n";

return $bam_no_duplications;
}




### H E L P      F U N C T I O N S   ###

sub delete_file {
	my $file_to_delete = shift; 
    print "\n[delete file: $file_to_delete] \n"; 

	system("rm  $file_to_delete ");
	if ( $? == -1 )
	{
		print "rm (delete) command failed: $!\n";
	} else {
		printf "\ncommand rm exited with value %d", $? >> 8;
	}
}



