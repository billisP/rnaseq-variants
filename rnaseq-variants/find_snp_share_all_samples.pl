# script to get snps files (vcf) of many conditions and find those that appear in many conditions
 
use strict;
use warnings;
 
 
# memtime samtools mpileup -C 50 -DS -uf ./../data/637000308.fna  1267.2.1260-sorted.bam  2> 1267.2.1260.mpileup.stderr | bcftools view -bvcg  -  2> 1267.2.1260.prefix.afs > 1267.2.1260.raw.bcf
# bcftools view 1267.2.1260.raw.bcf | vcfutils.pl varFilter -D 10000 > 1267.2.1260.raw.vcf

 
my @vcf_files = <~/Documents/auth/snp/data/vcf_files_308/*vcf>;
# my @vcf_files = ("//house/groupdirs/genome_biology/kbillis/transciptomics/snp/S7/1266.1.1258-sorted.bam");
my %snp;

foreach my $vcf_f (@vcf_files) {
    print "#start FILE: $vcf_f \n";
    # my $mpileup = $vcf_f . "stderr";
    # my $afs = $vcf_f . "afs";
    # my $bcf = $vcf_f . "bcf";
    # my $vcf = $vcf_f . "vcf";
    # system("memtime samtools mpileup -C 50 -DS -uf //house/groupdirs/genome_biology/kbillis/transciptomics/snp/data/637000308.fna $vcf_f  2> $mpileup | bcftools view -bvcg  -  2> $afs  > $bcf");
    # if ( $? == -1 ) {
    #   print "command failed: $!\n";
    # }
    # system("bcftools view $bcf | vcfutils.pl varFilter -D 10000 > $vcf");
    # if ( $? == -1 ) {
    #   print "command failed: $!\n";
    # } 
    # $vcf_f = $vcf;
     
    open(IN,  "$vcf_f")  or die($!);
        while (<IN>) {
            chomp;
            next if (/#/);
            my @tmpArray = ();
            # my $tmp = $_;
            my @dataSNP = split(/\t/);
            if ($snp{$dataSNP[1]}) {
                @tmpArray = @{$snp{$dataSNP[1]}};
                push(@tmpArray, $_ ); 
                 
                @{$snp{$dataSNP[1]}} = @tmpArray;   
            } else {
                # my @tmpArray = $snp{$dataSNP[1]} ;    
                push(@tmpArray, $_);
                @{$snp{$dataSNP[1]}} = @tmpArray;
            }
        }
    close IN;
}
 
# check which snps found many times in many samples!!
for (keys %snp) {
    my @val_array = @{$snp{$_}};
    if (scalar(@val_array) >12) {
        print "key is $_ exists " . scalar(@val_array) . "\n";
        foreach my $tmp (@val_array) {
            my @dataPrint = split(/\t/, $tmp);
            print  $dataPrint[0] . "\t" .  $dataPrint[1] . "\t" . $dataPrint[3] . "\t" . $dataPrint[4] . "\n" ;
            
        }
    }
}
