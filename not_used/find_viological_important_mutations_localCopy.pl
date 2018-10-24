use strict;
use warnings;
# use diagnostics;
use Getopt::Long;

# use PDL;
# use PDL::IO::Misc;
# use PDL::IO::FastRaw;
# use PDL::NiceSlice;
# use IO::File;


# INIT VARS
my ( $vcf_file, $algorithm, $infasta, $genes_infile, $outfile);
our $test;

# GET OPTIONS
GetOptions(
    'gff=s'    => \$genes_infile,
    'vcf=s'    => \$vcf_file,
    
    'out=s'    => \$outfile
);

# use: perl  /Users/kbillis/Documents/auth/snp/scripts/find_viological_important_mutations_localCopy.pl -gff /Users/kbillis/Documents/auth/snp/data/637000308.gbk.gff

warn('load genes to hash start!\n');

my %annot_chr_array = &load_array_with($genes_infile);

warn('load genes to hash finished!\n');

warn('load genes to object starts!\n');

my $read_cov = new Gene($genes_infile, $vcf_file);    # object uses 0-based coordinates


sub load_array_with {

    my $gff_infile = shift;
    my %hash_annotation;
    
    open(GFF, "$gff_infile") or die("Unable to open gff file $gff_infile");
    while (<GFF>){
        chomp;
        my ($chr,$src,$type,$start,$end,$score,$strand,$phase,$annot1)=split(/\t/, $_);
        my $gene;
        print "Before: $strand\n" if $test;
        if ( $strand eq "+" ) { $strand= "plus" } else {  $strand= "minus"  };
        print "after: $strand\n" if $test;
        my $len = $end - $start; 

        if ($type eq "source") {
            my @arr = map { [] } 1..$len;
            $hash_annotation{$chr}{'plus'} = [@arr];
            $hash_annotation{$chr}{'minus'} = [@arr];
            @arr = ();

        } elsif ($type eq "gene") {
        	# nothing!
        } else {
            # print "$len \n";
            if (/gene_id "(.*?)"/) {
                # $_ =~m/gene_id "(.*?)"/s;
                $gene =$1;
            } else {
                warn("load_hash:: I can't find gene_id for $_ ");
                next;
            }
            print "process $gene \n" if $test; 
            
            my @value_array = @{$hash_annotation{$chr}{$strand}}; 
            my $startPre= $start - 50 if ($start > 50);
            my $endAfter=$end + 50 if ($end < scalar(@value_array) );
            
            
            for ($startPre; $startPre < $start; $startPre++) {
                $value_array[$startPre]= "lim_" . $gene;
                # $minus{$start}=0;
                # $minus_c{$start}=0;
                # $plus_c{$start}=0; 
            }
            for ($endAfter; $endAfter> $end; $endAfter++) {
                $value_array[$endAfter]= "lim_" . $gene;
                # $minus{$start}=0;
                # $minus_c{$start}=0;
                # $plus_c{$start}=0; 
            } 
            for ($start; $start > $end; $start++) {
                $value_array[$endAfter]= "lim_" . $gene;
                # $minus{$start}=0;
                # $minus_c{$start}=0;
                # $plus_c{$start}=0; 
            } 
            $hash_annotation{$chr}{$strand}  = [@value_array];                  
        }            
    }
    close(GFF);

return %hash_annotation;
}







# initialise object (per gene)  
package Gene;
 
# objects are blessed arrays, not hashes.
use constant {
    GE => 0,    # SNP array
    LE => 1,    # length
    ST => 2,    # start
    SR => 4,    # strand
    SC => 5,    # scaffold/ sequence
    # AN => 6,    # other annotation info
    # SN => 7,    # snp location
    # SNA => 8,   # snp annotation
    EX => 9,    # expression info
};

 
###############################################################################
## INIT
sub new
{
    my ($class, $infile, $snpfile) = @_;
    my $this = [ {} ];
    bless $this, $class;
    # $this->load_vcf($snpfile) if $snpfile;
    $this->load_gff($infile) if $infile;
    return $this;
}


# load gff annotation

sub load_gff {
    my ($this, $gff_infile_l) = @_;
    open(IN, "$gff_infile_l") or die("Unable to open gff file $gff_infile_l");
    while (<IN>){
        chomp;
        $this -> _save_gene($_);
    }
    close(IN);
return;
}

 
sub _save_gene {
    my ($this, $tmp) = @_;
    my ($chr,$src,$type,$start,$end,$score,$strand,$phase,$annot1)=split(/\t/, $tmp);
    
    return unless ($type ne "source");

    my $len = $end - $start; 
    # print "$len \n";
    $_ =~m/gene_id "(.*?)"/s;
    my $gene =$1;
    
    # $this->[GE] -> {$gene};    # gene
    $this->[LE] -> {$gene} = $len;
    $this->[ST] -> {$gene} = $start;    # start
    $this->[SR] -> {$gene} = $strand;    # strand
    $this->[SC] -> {$gene} = $chr;     # scaffold/ sequence
    # $this->[AN] -> {$gene} = $tmp;   # other annotation info
    # $this->[SN] -> {$gene} = "";   # snp location
    # $this->[SNA] -> {$gene} = "";  # snp annotation
    $this->[EX] -> {$gene} = "";    # expression info

}




# PARSE VCF FILE & OUTPUT SORTED VCF # 

sub load_vcf {
    my %vcf_hash;
    my $header;
    open(VCF,$vcf_file) or die "Can't open $vcf_file!\n";
    while(<VCF>){
        if($_=~/^#/){ $header .= $_; } # store header and comment fields
        chomp($_);
        my @data = split(/\t/,$_);
        my $contig = $data[0];
        my $start = $data[1];
        my $variant = $data[4]."to".$data[5];
        my $line = $_;
        
        #print $contig,":",$start,"\n";
        $vcf_hash{$contig}{$start}{$variant}=$line;
    }
    close(VCF);
return (%vcf_hash);
}




# have an array with genes, marks genes- starts in order to find the mutations that present in the beginning of those.








