use warnings;
use strict;

my $string = "\@RG\tID:thymus_R1\tSM:thymus \tDS:thymus 101 illumina \tCN:Illumina \tPL:i" ;


$string =~ s/\t/\\t/g  ;

print $string . "\n";
