use strict;
use Bio::EnsEMBL::Registry;

# get registry
my $reg = 'Bio::EnsEMBL::Registry';
# $reg->load_registry_from_db(-host => 'ensembldb.ensembl.org', -user => 'anonymous');
$reg->load_all("/Users/kbillis/programs/enscode/ensembl-variation/scripts/import/registry_test.pm");

print __LINE__ . "\n";
# my $vfa = $reg->get_adaptor('human', 'variation', 'variationfeature');
my $vfa = $reg->get_adaptor('synechococcus_elongatus_pcc_7942','variation','variationfeature');


print __LINE__ . "\n";
# my $sa = $reg->get_adaptor('human', 'core', 'slice');
my $sa = $reg->get_adaptor('synechococcus_elongatus_pcc_7942', 'core', 'slice');
print __LINE__ . "\n";

# use Data::Dumper; 
# print Dumper($vfa); 
# get a slice for the new feature to be attached to
my $slice = $sa->fetch_by_region('chromosome', 'Chromosome');
print __LINE__ . "\n";


# create a new VariationFeature object
my $new_vf = Bio::EnsEMBL::Variation::VariationFeature->new(
  -start => 16095,
  -end => 16095,
  -slice => $slice,           # the variation must be attached to a slice
  -allele_string => 'C/T',    # the first allele should be the reference allele
  -strand => 1,
  -map_weight => 1,
  -adaptor => $vfa,           # we must attach a variation feature adaptor
  -variation_name => 'newSNP',
);

print __LINE__ . "\n";


# get the consequence types
my $cons = $new_vf->get_all_TranscriptVariations();
print "Number of TranscriptVariations: " . scalar(@{$cons}) . "\n";

foreach my $con (@{$cons}) {
  foreach my $string (@{$con->consequence_type}) {
    print
      "Variation ", $new_vf->variation_name,
      " at position ", $new_vf->seq_region_start,
      " on chromosome ", $new_vf->seq_region_name,
      " has consequence ", $string,
      " in transcript ", $con->transcript->stable_id, "\n";
  }
}





