# this tells you where each snp is. In which particular gene etc..  

use strict;
use warnings;
# use diagnostics;
use Getopt::Long;


# INIT VARS
my ( $vcf_file, $algorithm, $infasta, $genes_infile, $outfile);

# GET OPTIONS
GetOptions(
    'gff=s'    => \$genes_infile,
    'vcf=s'    => \$vcf_file,
    
    'out=s'    => \$outfile # the output is going to be a file with info of snps and genes 
);

# use: perl  /Users/kbillis/google_drive/myProjects/auth/snp/scripts/find_where_is_the_snp.pl   -gff /Users/kbillis/Documents/auth/snp/data/637000308.gbk.gff -vcf 

print "#load genes start! \n";
my $gff_data_ref = load_gff($genes_infile);    # object uses 0-based coordinates
my %hash_annotation = save_annotation_in_hash($gff_data_ref);

print "#load genes finished! \n";

my $last = load_vcf($vcf_file, $outfile, %hash_annotation); 

print "#all finished! \n";


    

# load gff annotation
sub load_gff {
    my ($gff_infile_l) = shift;
    my @array;
    open(IN, "$gff_infile_l") or die("Unable to open gff file $gff_infile_l");
    while (<IN>){
        chomp;
        push(@array,$_);
    }
    close(IN);
    
return \@array;
}

 
sub save_annotation_in_hash {
    my ($gff_data) = @_;

    my (@data)= @$gff_data;
    my %annotation_hash;

    
    foreach my $tmp (@data) {
        my ($chr,$src,$type,$start,$end,$score,$strand,$phase,$annot1)=split(/\t/, $tmp);
        
        if ( $strand eq "+" ) { $strand= "plus" } else {  $strand= "minus"  };
        
        if ($type eq "source") {
            
    	    my $i;
    	    foreach $i ($start .. $end) { 
    	        $annotation_hash{$chr}{'plus'}[$i] = "Intergenic";
    	        $annotation_hash{$chr}{'minus'}[$i] = "Intergenic";

    	        # print "original:  ".$i."\n";
    	    }
    	    
        } elsif ($type eq "gene") {
        # nothing!
        } else {
        
            my $gene = "";
            if ($tmp =~ m/gene_id "(.*?)"/) {
                # $_ =~m/gene_id "(.*?)"/s;
                $gene =$1;
            } else {
                warn("load_hash:: I can't find gene_id for $_ ");
                next;
            }
            
            # print "process $gene \n"; 
    	    my $j; 
    	    foreach $j ($start .. $end) { 
    	        $annotation_hash{$chr}{$strand}[$j] = $gene; 
    	        # print "original:  ".$j."\n"; 
    	    } 
        } 
    } 
return(%annotation_hash);           
} 



# PARSE VCF FILE & Report where the mutation is # 
sub load_vcf {
    my ($vcf_file, $outfile, %annotation_hash) = @_;

    my $header;
    my $strand;
    
    my $outfile_index = $outfile . "indel"; 
    open(INDEL, ">", "$outfile_index") or (die "Can't open OUTFILE_indel: $!");
    open(OUTFILE, ">", "$outfile") or (die "Can't open OUTFILE: $!");
    open(VCF,$vcf_file) or die "Can't open $vcf_file!\n";
    while(<VCF>){
        chomp($_);
        if($_=~/^#/){ 
        	# store header and comment fields
        	$header .= $_; 
        	next;
        } 
        
        my @data = split(/\t/,$_);
        my $chr = $data[0];
        my $start = $data[1];
        my $variant= $data[4]."to".$data[5];
        # my $length_of_change= length($data[4]); 
        if ( $_=~/INDEL/ ) {
            print INDEL $_ . "\n"; 
            next; 
        }

	    print OUTFILE "#---------------------------------------------\n";
        $strand = "plus"; 
        print OUTFILE $annotation_hash{$chr}{$strand}[$start] . "\t" . $_ . "\n";
        $strand = "minus"; 
        print OUTFILE $annotation_hash{$chr}{$strand}[$start] . "\t" . $_ . "\n";

        
        #print $contig,":",$start,"\n";
    }
    close(VCF);
    close(OUTFILE);
return;
}




# have an array with genes, marks genes- starts in order to find the mutations that present in the beginning of those.











