use strict;
use warnings;
use Bio::EnsEMBL::LookUp;
use Data::Dumper;

my $test_cases = $ARGV[0];


# connect remotely
if ( $test_cases == 1 ) {
	use Bio::EnsEMBL::LookUp;
	my $lookup = Bio::EnsEMBL::LookUp->new();

# Getting DBAdaptors
# 1. by name
# my $dba = $lookup->get_by_name_exact('escherichia_coli_str_k_12_substr_mg1655');
# my $dba = $lookup->get_all_by_name_pattern('%nechococcus%7942%');
# my $dba = $lookup->get_by_assembly_accession('GCA_000005845.2') # E. coli

	my $dba = $lookup->get_by_name_exact('synechococcus_elongatus_pcc_7942')
	  ;    # get_by_assembly_accession('GCA_000012525.1');  # works
	print "DEBUG:adaptor: \n ";
	print Dumper($dba);

	my $genes = $dba->get_GeneAdaptor()->fetch_all();
	print "Found " . scalar @$genes . " genes for " . $dba->species() . "\n";

	# 2. by taxonomy
	# $dba = $lookup->get_all_by_taxon_id(388919); #
	# $dba = $lookup->get_all_by_taxon_branch(561); # branch id

	# 3. by genomic INSDC accession
	# $dba = $lookup->get_all_by_accession('U00096');

	# 4. by genome assembly accession
	# $dba = $lookup->get_by_assembly_accession('GCA_000005845.2') # E. coli

}

# connect remotely to ensembl 
if ( $test_cases == 2 ) {
	use Bio::EnsEMBL::Registry;

	my $reg  = 'Bio::EnsEMBL::Registry';
	my $host = 'ensembldb.ensembl.org';
	my $user = 'anonymous';

	$reg->load_registry_from_db(
		-host => $host,
		-user => $user
	);

	# Get adaptor to StructuralVariation object
	my $sva = $reg->get_adaptor( "human", "variation", "structuralvariation" );

}

# let's try local registry.
# register_dbs('localhost', 13306, 'root', '', 'bacteria_11_collection_core_43_96_1' );
if ( $test_cases == 3 ) {
	use Bio::EnsEMBL::LookUp::LocalLookUp;
	print "Loading registry\n";
	Bio::EnsEMBL::LookUp::LocalLookUp->register_all_dbs( "localhost", 13306,
		"root", "", 'bacteria_11_collection_core_43_96_1' );
	print "Building helper\n";
	my $helper = Bio::EnsEMBL::LookUp::LocalLookUp->new();

	# synechococcus_elongatus_pcc_7942
	my ($dba) =
	  @{ $helper->get_by_name_exact('synechococcus_elongatus_pcc_7942') };

	# my $dba = $helper->get_all('GCA_000012525.1');

	my $genes = $dba->get_GeneAdaptor()->fetch_all();

	# my $genes = $dba->get_GeneAdaptor()->fetch_all();
	print "Found " . scalar @$genes . " genes for " . $dba->species() . "\n";
	
	my $gene = $dba->get_GeneAdaptor->fetch_by_stable_id("Synpcc7942_0094");
	my $transcript = $gene->get_all_Transcripts; 
	print Dumper($transcript);

	
}


# connect to variation local db and copy genes
if ( $test_cases == 4 ) {
	use strict;
	use Bio::EnsEMBL::Registry;
	use Bio::EnsEMBL::Utils::Sequence qw(reverse_comp);
	use Bio::EnsEMBL::Utils::Exception qw(warning);
	use Bio::EnsEMBL::Variation::Utils::VEP qw(parse_line get_all_consequences);
	use Bio::EnsEMBL::Variation::Utils::Sequence qw(SO_variation_class);

	# object types need to imported explicitly to use new_fast
	use Bio::EnsEMBL::Variation::Variation;
	use Bio::EnsEMBL::Variation::SampleGenotype;

	# use this for remapping
	use Bio::EnsEMBL::SimpleFeature;

	use Getopt::Long;
	use FileHandle;
	use Socket;
	use IO::Handle;
	use Data::Dumper;
	use Time::HiRes qw(gettimeofday tv_interval);
	use ImportUtils qw(load);
	use Digest::MD5 qw(md5_hex);
	use Cwd 'abs_path';

	use constant DISTANCE  => 100_000;
	use constant MAX_SHORT => 2**16 - 1;

	use Bio::EnsEMBL::DBSQL::DBAdaptor;
	use Bio::EnsEMBL::Variation::DBSQL::DBAdaptor;

	my $reg = 'Bio::EnsEMBL::Registry';

	$reg->load_all("/Users/kbillis/programs/enscode/ensembl-variation/scripts/import/registry_test.pm");

	my $vdba_pre = $reg->get_DBAdaptor( 'synechococcus_elongatus_pcc_7942', 'variation', 'variation' )
	  || usage( "Cannot find variation db for " . 'human' );

	print "Connected to database ", $vdba_pre->dbc->dbname, " on ",  $vdba_pre->dbc->host, " as user ", $vdba_pre->dbc->username;

    my $vdba = $vdba_pre->dbc->db_handle;
    

	my ($seq_region_id, $chr_name, %seq_region_ids);
	my $sth = $vdba->prepare(qq{SELECT seq_region_id, name FROM seq_region});
	$sth->execute;
	$sth->bind_columns(\$seq_region_id, \$chr_name);
	$seq_region_ids{$chr_name} = $seq_region_id while $sth->fetch;
	$sth->finish;
	
	print "DEBUG:seq_Region: $seq_region_id \n"; 

}




# connect to local core  from registry
if ( $test_cases == 5 ) {
	use strict;
	use Bio::EnsEMBL::Registry;
	use Bio::EnsEMBL::Utils::Sequence qw(reverse_comp);
	use Bio::EnsEMBL::Utils::Exception qw(warning);
	use Bio::EnsEMBL::Variation::Utils::VEP qw(parse_line get_all_consequences);
	use Bio::EnsEMBL::Variation::Utils::Sequence qw(SO_variation_class);

	# object types need to imported explicitly to use new_fast
	use Bio::EnsEMBL::Variation::Variation;
	use Bio::EnsEMBL::Variation::SampleGenotype;

	# use this for remapping
	use Bio::EnsEMBL::SimpleFeature;

	use Getopt::Long;
	use FileHandle;
	use Socket;
	use IO::Handle;
	use Data::Dumper;
	use Time::HiRes qw(gettimeofday tv_interval);
	use ImportUtils qw(load);
	use Digest::MD5 qw(md5_hex);
	use Cwd 'abs_path';

	use constant DISTANCE  => 100_000;
	use constant MAX_SHORT => 2**16 - 1;

	use Bio::EnsEMBL::DBSQL::DBAdaptor;
	use Bio::EnsEMBL::Variation::DBSQL::DBAdaptor;

	
	my $reg = 'Bio::EnsEMBL::Registry';
	$reg->load_all("/Users/kbillis/programs/enscode/ensembl-variation/scripts/import/registry_test.pm");

	my $slice_adaptor = $reg->get_adaptor("synechococcus_elongatus_pcc_7942", "core", "slice");
	# print Dumper($slice_adaptor) ;
	die("ERROR: Could not get slice adaptor\n") unless defined($slice_adaptor);


	my $cdba = $reg->get_DBAdaptor("synechococcus_elongatus_pcc_7942",'core');

	print "Connected to database ", $cdba->dbc->dbname, " on ",  $cdba->dbc->host, " as user ", $cdba->dbc->username;


	my $dbh  = $cdba->dbc->db_handle;

	
	# my ($seq_region_id, $chr_name, %seq_region_ids);
	# my $sth = $dbh->prepare(qq{SELECT seq_region_id, name FROM seq_region});
	# $sth->execute;
	# $sth->bind_columns(\$seq_region_id, \$chr_name);
	# $seq_region_ids{$chr_name} = $seq_region_id while $sth->fetch;
	# $sth->finish;
	
	my $chr_name = "Chromosome"; 
	print "DEBUG:seq_Region: $chr_name \n"; 
	
	my $slice = $slice_adaptor->fetch_by_region('chromosome', $chr_name, undef, undef, undef, undef, undef);
	
	print "DEBUG:" . $slice->seq_region_name . "\n"; 
	
	
	# my @genes = @{ $cdba->get_GeneAdaptor->fetch_all_by_Slice($slice) };
	# print "DEBUG:" . scalar(@genes) . "\n";
	
	my $gene = $cdba->get_GeneAdaptor->fetch_by_stable_id("Synpcc7942_0094");
	my $transcript = $gene->get_all_Transcripts; 
	# print Dumper($transcript);
	



}


