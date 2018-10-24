use strict;
use warnings;



my $positions_file = $ARGV[0];
my $gff_infile_l = $ARGV[1];
my $uniprot_file = $ARGV[2]; # "/Users/kbillis/google_drive/myProjects/auth/snp/data_from_others/"; 


my %countGene; 

#  load gff annotation
my %annotation;
open(IN, "$gff_infile_l") or die("Unable to open gff file $gff_infile_l");
    while (<IN>){
        chomp;
        my $gene; 
        my ($chr,$src,$type,$start,$end,$score,$strand,$phase,$annot1)=split(/\t/, $_);
        next if (/region/);
        next if (/exon/);
        next if (/tRNA/);  
        next if (/rRNA/);       
        next if (/CDS/);
        next if (/^#/);
        if (/Name=(.*?);/) {
            # $_ =~m/gene_id "(.*?)"/s;
            $gene =$1;
            $countGene{$gene} = 0; 
            $annotation{$gene} = $_ ;
        } else {
            warn("load_hash:: I can't find gene_id for line: $_ ");
            next;
        }
    }
close(IN);


my %uniprot_naming_rizo; 
# my $uniprot_file = "/Users/kbillis/google_drive/myProjects/auth/snp/data_from_others/"; 
if (defined($uniprot_file)) {
  open(UNI,$uniprot_file) or die "Can't open $uniprot_file!\n";
    while (<UNI>){
      chomp; 
      my ($entry, $entry_name, $protein_names, $organism, $gname_loc , $gname)=split(/\t/, $_ );
      $uniprot_naming_rizo{$gname_loc} = $entry_name; 
      # $uniprot_naming_rizo{$gname} = $entry; 
    }
}    


open(VCF,$positions_file) or die "Can't open $positions_file!\n";
while(<VCF>){
    chomp;
    my $pos = $_;
    my $found_in_gene = 0; 
    foreach my $gene (keys %annotation) {
        my ($chr,$src,$type,$start,$end,$score,$strand,$phase,$annot1)=split(/\t/, $annotation{$gene} );
        # print "$pos is possion and $start is start, $end is end \n"; 
        
        if  ( ($pos > $start) && ($pos < $end) ) {
        	# print "$chr,$src,$type, start: $start , end: $end ,$score,$strand,$phase,$annot1 \n"; 
        	$found_in_gene=1; 
        	$countGene{$gene}++;
        	my $uniprot_rename_gene = ""; 
        	if ($uniprot_naming_rizo{$gene}) {
        		$uniprot_rename_gene = $uniprot_naming_rizo{$gene} . " hh" ;
        	}
        	print "$pos found $gene $uniprot_rename_gene \n"; 
        } elsif ( ($pos == $start) || ($pos == $end) ) {
        	print "$pos is at the start or at the end!!! $gene \n";
        	$found_in_gene=1; 
        	$countGene{$gene}++;        	
        } else {
        	# print "nothing interesting!\n"; 
        }
    # exit;
    } 
    print "$pos found intergenic_region\n" if ($found_in_gene == 0 ); 
    
}

