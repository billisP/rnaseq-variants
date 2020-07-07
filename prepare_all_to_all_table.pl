use warnings;
use strict;

use Bio::EnsEMBL::DBSQL::DBAdaptor;
use Bio::EnsEMBL::Variation::DBSQL::DBAdaptor;





my $prepare_genes = "yes"; # to prepare genes or something else. 
	
my $reg = 'Bio::EnsEMBL::Registry';
$reg->load_all("/Users/kbillis/programs/enscode/ensembl-variation/scripts/import/registry_test.pm");

my $cdba = $reg->get_DBAdaptor( "synechococcus_elongatus_pcc_7942", 'core' );
my $sa =
  $reg->get_adaptor( 'synechococcus_elongatus_pcc_7942', 'core', 'slice' );

# get a slice for the new feature to be attached to
my $slice = $sa->fetch_by_region( 'chromosome', 'Chromosome' );


my $vdba_pre = $reg->get_DBAdaptor( 'synechococcus_elongatus_pcc_7942', 'variation', 'variation' )
	  || usage( "Cannot find variation db for " . 'synechococcus_elongatus_pcc_7942' );
# print "Connected to database ", $vdba_pre->dbc->dbname, " on ",  $vdba_pre->dbc->host, " as user ", $vdba_pre->dbc->username;


my $vdba = $vdba_pre->dbc->db_handle;
my ($source_id, $description, $name);
my %source_info; 
my $sth = $vdba->prepare(qq{SELECT source_id, description, name FROM source});
$sth->execute;
$sth->bind_columns(\$source_id, \$description, \$name);
$source_info{$name} = $description while $sth->fetch;
$sth->finish;


if ($prepare_genes eq "yes") {
my $query_count = "select count(*), variation_feature.source_id , source.description ,  transcript_variation.feature_stable_id , source.name from variation_feature , transcript_variation, source  WHERE source.source_id = variation_feature.source_id   AND  transcript_variation.variation_feature_id = variation_feature.variation_feature_id  group by variation_feature.source_id , transcript_variation.feature_stable_id"; 
my ($count, $variation_feature, $source_description, $feature_stable_id, $source_name); 
my %counts; 
my $sth_1 = $vdba->prepare(qq{$query_count});
$sth_1->execute;
$sth_1->bind_columns(\$count, \$variation_feature, \$source_description, \$feature_stable_id, \$source_name);
$counts{$source_name}{$feature_stable_id} = $count while $sth_1->fetch;
$sth_1->finish;


my @genes = @{ $slice->get_all_Genes() };
 
foreach my $gene (@genes) {
	my $gene_stable_id = $gene->stable_id() ;
	foreach my $source_name_key (keys %source_info) {
		my $count_value = 0; 
		if ( defined($counts{$source_name_key}{$gene_stable_id} ) )  { 
			$count_value = $counts{$source_name_key}{$gene_stable_id} ; 
			# print "my new  value: $source_name $gene_stable_id $count_value \n" ; 
		} 
		print $gene_stable_id . "\t" . $source_info{$source_name_key} . "\t" . $source_name_key . "\t" . $count_value . "\n";
	}
}

my $more_info_for_this_gene = ""; 
my $stable_id_of_this_gene = "";
if ($more_info_for_this_gene) {
#	my $gene = $cdba->get_GeneAdaptor->fetch_by_stable_id($stable_id_of_this_gene); 
}
}

if ($prepare_genes eq "no") {
"select  variation_feature.seq_region_start ,  variation_feature.source_id , source.description ,  transcript_variation.feature_stable_id , source.name from variation_feature , transcript_variation, source  WHERE source.source_id = variation_feature.source_id   AND  transcript_variation.variation_feature_id = variation_feature.variation_feature_id  group by variation_feature.source_id , transcript_variation.feature_stable_id limit 2 ;	"; 
}


