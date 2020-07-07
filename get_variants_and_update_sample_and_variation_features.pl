use strict;
use warnings;

# ensembl:
use Bio::EnsEMBL::Registry;

# me:
use File::Basename;
use Data::Dumper;

# get registry
my $reg = 'Bio::EnsEMBL::Registry';
$reg->load_all(
"/Users/kbillis/programs/enscode/ensembl-variation/scripts/import/registry_test.pm"
# "/Users/kbillis/programs/enscode/ensembl-variation/scripts/import/registry_test_Billis_samples.pm"
);

# adaptors:
my $vfa = $reg->get_adaptor( 'synechococcus_elongatus_pcc_7942',
	'variation', 'variationfeature' );
my $sa =
  $reg->get_adaptor( 'synechococcus_elongatus_pcc_7942', 'core', 'slice' );

# get a slice for the new feature to be attached to
my $slice = $sa->fetch_by_region( 'chromosome', 'Chromosome' );

# Variation feature adaptor
# my $vfa = $reg->get_adaptor( 'synechococcus_elongatus_pcc_7942', 'variation', 'variationfeature' );
my $va = $reg->get_adaptor( "synechococcus_elongatus_pcc_7942",
	"variation", "variation" );

# my $sa  = $reg->get_adaptor( 'synechococcus_elongatus_pcc_7942', 'variation', 'source' );
my $trv = $reg->get_adaptor( 'synechococcus_elongatus_pcc_7942',
	'variation', 'transcriptvariation' )
  ;    #get the adaptor to get TranscriptVariation objects

# Fetch the variation feature objects overlapping the Slice
# my @var_features = @{ $vfa->fetch_all() };
# print "Number of variations features: ", scalar @var_features, "\n";

# read file
my $VEP_results_file = $ARGV[0];
my $split_patern_    = " ";

# my %hash_VEP_results;
my ( $filename, $directories, $suffix ) = fileparse($VEP_results_file);
my @arr = split( '\.', $filename );
# my $sample_id = $arr[0];
my $sample_id = $arr[0] . ".". $arr[1] . "." . $arr[2] ; # for my data with dots. 


 
open( TAB, $VEP_results_file ) or die "Can't open $VEP_results_file !\n";
while (<TAB>) {
	chomp($_);
	if ( $_ =~ /^#/ ) {
		next;
	}
	my @data_all = split( '\t', $_ );

	# file Variation name : NC_007604_8145_G/A
	$data_all[0] =~ s/_//;
	my ( $prefix, $position, $allele_info ) = split( '_', $data_all[0] );
	my $new_allele_info = $allele_info =~ s/\//_/r;
	my $id_variant =
	    $sample_id . "_"
	  . "Chromosome" . "_"
	  . $position . "_"
	  . $new_allele_info;

	next if length($allele_info) > 3;
	next if ( $allele_info =~ /-/ );

# NC_007604_2433499_G/-	NC_007604:2433499	-	Synpcc7942_2369	ABB58399	Transcript	upstream_gene_variant	-	-	-	-	-	-	MODIFIER	1542	1	-
# variation_name:NC_007604_Chromosome_2433498_CG_C seq_region_start: 2433499   allele_string:G/-
# NC_007604_Chromosome_2433498_CG_C
	print "## id_variant: $id_variant " . "gene_name:"
	  . $data_all[3]
	  . " -- Allele:"
	  . $data_all[2]
	  . " -- Consequence:"
	  . $data_all[6]
	  . " -- cDNA_position:"
	  . $data_all[7]
	  . " -- Protein_position:"
	  . $data_all[9]
	  . " -- Amino_acids:"
	  . $data_all[10]
	  . " -- Codons:"
	  . $data_all[11]
	  . " -- IMPACT:"
	  . $data_all[13] . "\n";
	  
	  
	my $feature_stable_id = $data_all[3] ;
	my $allele_string     = $data_all[2] ;
	my $consequence_types = $data_all[6] ;
	my $cdna_start        = $data_all[7] ;
	my $cds_start         = $data_all[8] ;
	my $translation_start = $data_all[9] ;
	my $pep_allele_string = $data_all[10] ;
	my $codon_allele_string = $data_all[11] ;
	my $impact            = $data_all[13] ;
	# my $sift_prediction   = 'tolerated - low confidence'; 
	
	# sift_prediction was:  enum('tolerated','deleterious','tolerated - low confidence','deleterious - low confidence')
	# I update it to: ALTER TABLE transcript_variation MODIFY COLUMN sift_prediction  enum('tolerated','deleterious','tolerated - low confidence','deleterious - low confidence', 'HIGH', 'LOW', 'MODERATE', 'MODIFIER');
	# enum('tolerated','deleterious','tolerated - low confidence','deleterious - low confidence','HIGH','LOW','MODERATE','MODIFIER')
	
	
	# my $variant = $vfa->fetch_by_name($id_variant);
	my $vf1 = $va->fetch_by_name($id_variant)->get_all_VariationFeatures->[0];
	my $variation_feature_id = $vf1->dbID; 

	if ( defined($vf1) ) {
		# don't use them
		# my $vf = get_VariationFeatures($vf1);
		my $cdba = $reg->get_DBAdaptor( "synechococcus_elongatus_pcc_7942", 'core' );
		my $gene = $cdba->get_GeneAdaptor->fetch_by_stable_id( $data_all[3] );
		my $transcript = $gene->get_all_Transcripts;
		print "## " . $gene->stable_id() . "\n";

		print "UPDATE variation_feature SET consequence_types = '$consequence_types' where variation_feature_id = $variation_feature_id ; \n " ; 
		my $insert_command = "INSERT INTO transcript_variation ( variation_feature_id , feature_stable_id , allele_string , somatic , consequence_types , cds_start , cds_end , cdna_start , " . 
		" cdna_end , translation_start , translation_end , distance_to_transcript , codon_allele_string , pep_allele_string , hgvs_genomic , hgvs_transcript , hgvs_protein , polyphen_prediction , " .
		" polyphen_score , sift_prediction , sift_score , display ) VALUES ( $variation_feature_id , '$feature_stable_id' , '$allele_string' , 0 , '$consequence_types' , $cds_start , 0 , $cdna_start , " .
		" 0 , $translation_start , 0 , 0 , '$codon_allele_string' , '$pep_allele_string' , 'NA' , 'NA' , 'NA' , 'unknown' , 0 , '$impact' , 0 , 1 ) ; \n" ;
		my $new_insert = $insert_command  =~ s/\-/NULL/g;
		print $insert_command;
		# print $new_insert;  
		# print "VF1:Variation ", $vf1->variation_name,
		#  " dbID ", $vf1->dbID, 
		#  " at position ", $vf1->seq_region_start,
		#  " on chromosome ", $vf1->seq_region_name, "\n";

	}
	else {
		print "variant_id:" . $id_variant . "\n";
		print "Can't find it \n";
	}

	#fetch_by_name()

}
close TAB;

sub get_VariationFeatures {
	my $var = shift;

	print __LINE__ . "\n";

	# get all VariationFeature objects: might be more than 1 !!!
	my @vfs = @{ $vfa->fetch_all_by_Variation($var) };
	if ( scalar(@vfs) == 1 ) {
		print $vfs[0]->variation_name(), ",";    # print rsID
		print $vfs[0]->allele_string(),  ",";    # print alleles
		return $vfs[0];
	}
	else {
		die;
	}
	foreach my $vf ( @{ $vfa->fetch_all_by_Variation($var) } ) {
		print $vf->variation_name(), ",";        # print rsID
		print $vf->allele_string(),  ",";        # print alleles
		print join( ",", @{ $vf->consequence_type() } ),
		  ",";                                   # print consequenceType
		 # print substr($var->five_prime_flanking_seq,-10) , "[",$vf->allele_string,"]"; #print the allele string
		 # print substr($var->three_prime_flanking_seq,0,10), ","; # print RefSeq
		 # print $vf->seq_region_name, ":", $vf->start,"-",$vf->end; # print position in Ref in format Chr:start-end
		 # get_TranscriptVariations($vf); # get Transcript information
		print "\n";

		# print Dumper($vf);

	}
}

#print "consequence type: ", ( join ",", @{ $tv->consequence_type } ), "\n";
#print "cdna coords: ", $tv->cdna_start,        '-', $tv->cdna_end,        "\n";
#print "cds coords: ",  $tv->cds_start,         '-', $tv->cds_end,         "\n";
#print "pep coords: ",  $tv->translation_start, '-', $tv->translation_end, "\n";
#print "amino acid change: ", $tv->pep_allele_string, "\n";
#print "codon change: ",      $tv->codons,            "\n";
#print "allele sequences: ",
#  (
#	join ",",
#	map { $_->variation_feature_seq }
#	  @{ $tv->get_all_TranscriptVariationAlleles }
#  ),
#  "\n";

# $config->{transcriptvariation_adaptor}->store($tv);

