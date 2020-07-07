-- MySQL dump 10.13  Distrib 5.6.43, for osx10.14 (x86_64)
--
-- Host: localhost    Database: synechococcus_variation_43_96
-- ------------------------------------------------------
-- Server version	5.6.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `allele`
--

DROP TABLE IF EXISTS `allele`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `allele` (
  `allele_id` int(11) NOT NULL AUTO_INCREMENT,
  `variation_id` int(11) unsigned NOT NULL,
  `subsnp_id` int(11) unsigned DEFAULT NULL,
  `allele_code_id` int(11) unsigned NOT NULL,
  `population_id` int(11) unsigned DEFAULT NULL,
  `frequency` float unsigned DEFAULT NULL,
  `count` int(11) unsigned DEFAULT NULL,
  `frequency_submitter_handle` int(10) DEFAULT NULL,
  PRIMARY KEY (`allele_id`),
  KEY `variation_idx` (`variation_id`),
  KEY `subsnp_idx` (`subsnp_id`),
  KEY `population_idx` (`population_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allele`
--

LOCK TABLES `allele` WRITE;
/*!40000 ALTER TABLE `allele` DISABLE KEYS */;
/*!40000 ALTER TABLE `allele` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `allele_code`
--

DROP TABLE IF EXISTS `allele_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `allele_code` (
  `allele_code_id` int(11) NOT NULL AUTO_INCREMENT,
  `allele` varchar(60000) DEFAULT NULL,
  PRIMARY KEY (`allele_code_id`),
  UNIQUE KEY `allele_idx` (`allele`(1000))
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allele_code`
--

LOCK TABLES `allele_code` WRITE;
/*!40000 ALTER TABLE `allele_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `allele_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `allele_synonym`
--

DROP TABLE IF EXISTS `allele_synonym`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `allele_synonym` (
  `allele_synonym_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `variation_id` int(10) unsigned NOT NULL,
  `hgvs_genomic` varchar(600) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`allele_synonym_id`),
  UNIQUE KEY `variation_name_idx` (`variation_id`,`name`),
  KEY `name_idx` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allele_synonym`
--

LOCK TABLES `allele_synonym` WRITE;
/*!40000 ALTER TABLE `allele_synonym` DISABLE KEYS */;
/*!40000 ALTER TABLE `allele_synonym` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `associate_study`
--

DROP TABLE IF EXISTS `associate_study`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `associate_study` (
  `study1_id` int(10) unsigned NOT NULL,
  `study2_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`study1_id`,`study2_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `associate_study`
--

LOCK TABLES `associate_study` WRITE;
/*!40000 ALTER TABLE `associate_study` DISABLE KEYS */;
/*!40000 ALTER TABLE `associate_study` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attrib`
--

DROP TABLE IF EXISTS `attrib`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attrib` (
  `attrib_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `attrib_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`attrib_id`),
  UNIQUE KEY `type_val_idx` (`attrib_type_id`,`value`(80))
) ENGINE=MyISAM AUTO_INCREMENT=610 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attrib`
--

LOCK TABLES `attrib` WRITE;
/*!40000 ALTER TABLE `attrib` DISABLE KEYS */;
INSERT INTO `attrib` VALUES (1,469,'SO:0001483'),(2,470,'SNV'),(3,471,'SNP'),(4,469,'SO:1000002'),(5,470,'substitution'),(6,469,'SO:0001019'),(7,470,'copy_number_variation'),(8,471,'CNV'),(9,469,'SO:0000667'),(10,470,'insertion'),(11,469,'SO:0000159'),(12,470,'deletion'),(13,469,'SO:1000032'),(14,470,'indel'),(15,469,'SO:0000705'),(16,470,'tandem_repeat'),(17,469,'SO:0001059'),(18,470,'sequence_alteration'),(19,469,'SO:0001628'),(20,470,'intergenic_variant'),(21,471,'INTERGENIC'),(24,471,'UPSTREAM'),(27,471,'DOWNSTREAM'),(32,469,'SO:0001575'),(33,470,'splice_donor_variant'),(34,471,'ESSENTIAL_SPLICE_SITE'),(36,470,'splice_acceptor_variant'),(37,469,'SO:0001630'),(38,470,'splice_region_variant'),(39,471,'SPLICE_SITE'),(40,469,'SO:0001627'),(41,470,'intron_variant'),(42,471,'INTRONIC'),(43,469,'SO:0001623'),(44,470,'5_prime_UTR_variant'),(45,471,'5PRIME_UTR'),(46,469,'SO:0001624'),(47,470,'3_prime_UTR_variant'),(48,471,'3PRIME_UTR'),(54,471,'SYNONYMOUS_CODING'),(55,469,'SO:0001583'),(57,471,'NON_SYNONYMOUS_CODING'),(62,469,'SO:0001587'),(63,470,'stop_gained'),(64,471,'STOP_GAINED'),(65,469,'SO:0001578'),(66,470,'stop_lost'),(67,471,'STOP_LOST'),(68,469,'SO:0001567'),(69,470,'stop_retained_variant'),(70,469,'SO:0002012'),(72,469,'SO:0001589'),(73,470,'frameshift_variant'),(74,471,'FRAMESHIFT_CODING'),(75,469,'SO:0001626'),(76,470,'incomplete_terminal_codon_variant'),(77,471,'PARTIAL_CODON'),(78,469,'SO:0001621'),(79,470,'NMD_transcript_variant'),(80,471,'NMD_TRANSCRIPT'),(81,469,'SO:0001619'),(82,470,'non_coding_transcript_variant'),(83,471,'WITHIN_NON_CODING_GENE'),(84,469,'SO:0001620'),(85,470,'mature_miRNA_variant'),(86,471,'WITHIN_MATURE_miRNA'),(87,469,'SO:0001580'),(88,470,'coding_sequence_variant'),(89,471,'CODING_UNKNOWN'),(90,469,'SO:0001566'),(91,470,'regulatory_region_variant'),(92,471,'REGULATORY_REGION'),(97,469,'SO:0000234'),(98,470,'mRNA'),(99,469,'SO:0000673'),(100,470,'transcript'),(101,469,'SO:0000185'),(102,470,'primary_transcript'),(103,469,'SO:0000655'),(104,470,'ncRNA'),(105,469,'SO:0000276'),(106,470,'miRNA'),(107,469,'SO:0005836'),(108,470,'regulatory_region'),(109,469,'SO:0000409'),(110,470,'binding_site'),(111,470,'structural_variant'),(112,469,'SO:0001537'),(113,471,'SV'),(114,470,'probe'),(115,469,'SO:0000051'),(116,471,'CNV_PROBE'),(118,473,'transcript'),(119,474,'20'),(120,474,'21'),(122,474,'18'),(124,474,'19'),(125,472,'splice-5'),(126,473,'primary_transcript'),(127,474,'1'),(128,472,'splice-3'),(129,469,'SO:0001574'),(130,474,'8'),(131,472,'intron'),(132,474,'15'),(133,472,'untranslated_5'),(134,473,'mRNA'),(135,474,'13'),(136,472,'untranslated_3'),(137,474,'14'),(138,474,'5'),(139,472,'cds-synon'),(140,474,'10'),(141,472,'missense'),(142,474,'7'),(143,474,'6'),(144,472,'nonsense'),(145,474,'3'),(146,474,'4'),(147,472,'frameshift'),(149,474,'16'),(150,473,'ncRNA'),(151,474,'17'),(152,473,'miRNA'),(153,474,'12'),(154,474,'11'),(155,473,'regulatory_region'),(157,473,'TF_binding_site'),(158,469,'SO:0001782'),(159,470,'TF_binding_site_variant'),(176,477,'hapmap'),(177,477,'ind_venter'),(178,477,'ind_watson'),(179,477,'fail_all'),(180,477,'fail_nonref'),(181,477,'fail_ambig'),(182,477,'fail_gt_fq'),(183,477,'fail_incons_map'),(184,477,'fail_mult_map'),(185,477,'fail_no_alleles'),(186,477,'fail_no_gt'),(187,477,'fail_no_map'),(188,477,'fail_no_seq'),(189,477,'fail_non_nt'),(190,477,'fail_mult_alleles'),(191,477,'ph_hgmd_pub'),(193,477,'ph_nhgri'),(194,477,'ph_omim'),(195,477,'ph_variants'),(196,477,'ph_uniprot'),(197,477,'ph_cosmic'),(198,477,'ph_ega'),(200,470,'copy_number_gain'),(201,469,'SO:0001742'),(202,471,'gain'),(203,470,'copy_number_loss'),(204,469,'SO:0001743'),(205,471,'loss'),(206,470,'inversion'),(207,469,'SO:1000036'),(208,470,'complex_structural_alteration'),(209,469,'SO:0001784'),(210,471,'complex alteration'),(211,470,'tandem_duplication'),(212,469,'SO:1000173'),(213,471,'tandem duplication'),(214,477,'fail_dbsnp_suspect'),(215,478,'unknown'),(216,478,'untested'),(217,478,'non-pathogenic'),(218,478,'probable-non-pathogenic'),(219,478,'probable-pathogenic'),(220,478,'pathogenic'),(221,478,'drug-response'),(222,478,'histocompatibility'),(223,478,'other'),(224,479,'Not tested'),(225,479,'Benign'),(226,479,'Pathogenic'),(227,479,'Uncertain Significance'),(228,479,'likely benign'),(229,479,'likely pathogenic'),(242,470,'mobile_element_insertion'),(243,469,'SO:0001837'),(244,471,'mobile element insertion'),(245,477,'PorcineSNP60'),(253,470,'duplication'),(254,469,'SO:1000035'),(255,470,'sequence_feature'),(256,469,'SO:0000110'),(257,477,'hapmap_ceu'),(258,477,'hapmap_hcb'),(259,477,'hapmap_jpt'),(260,477,'hapmap_yri'),(261,474,'26'),(262,474,'22'),(263,474,'23'),(265,474,'25'),(266,474,'24'),(267,481,'sift'),(268,481,'polyphen_humvar'),(269,481,'polyphen_humdiv'),(270,476,'tolerated'),(271,476,'deleterious'),(272,475,'probably damaging'),(273,475,'possibly damaging'),(274,475,'benign'),(275,475,'unknown'),(286,470,'interchromosomal_breakpoint'),(287,469,'SO:0001873'),(288,471,'interchromosomal breakpoint'),(289,470,'intrachromosomal_breakpoint'),(290,469,'SO:0001874'),(291,471,'intrachromosomal breakpoint'),(292,470,'translocation'),(293,469,'SO:0000199'),(294,474,'38'),(295,469,'SO:0001631'),(296,470,'upstream_gene_variant'),(297,469,'SO:0001632'),(298,470,'downstream_gene_variant'),(299,469,'SO:0001819'),(300,470,'synonymous_variant'),(301,470,'missense_variant'),(302,469,'SO:0001821'),(303,470,'inframe_insertion'),(304,469,'SO:0001822'),(305,470,'inframe_deletion'),(306,470,'start_lost'),(307,469,'SO:0001792'),(308,470,'non_coding_transcript_exon_variant'),(309,474,'36'),(310,474,'30'),(311,469,'SO:0001893'),(312,470,'transcript_ablation'),(313,469,'SO:0001889'),(314,470,'transcript_amplification'),(315,469,'SO:0001895'),(316,470,'TFBS_ablation'),(317,469,'SO:0001892'),(318,470,'TFBS_amplification'),(319,474,'28'),(320,469,'SO:0001894'),(321,470,'regulatory_region_ablation'),(322,474,'31'),(323,469,'SO:0001891'),(324,470,'regulatory_region_amplification'),(325,474,'33'),(326,469,'SO:0001907'),(327,470,'feature_elongation'),(328,469,'SO:0001906'),(329,470,'feature_truncation'),(330,474,'37'),(331,471,'duplication'),(332,477,'Affy_500K'),(333,477,'Affy_SNP6'),(334,477,'Illumina_660Q'),(335,477,'Illumina_1M-duo'),(337,477,'Cardio-Metabo_Chip'),(338,477,'HumanOmni1-Quad'),(339,477,'Illumina_CytoSNP12v1'),(340,477,'HumanHap650Y'),(341,477,'HumanOmni2.5'),(342,477,'Human610_Quad'),(343,477,'HumanHap550'),(344,477,'esp_6500'),(345,477,'clin_assoc'),(346,473,'sequence_feature'),(348,477,'Chicken600K'),(350,477,'BovineHD'),(351,477,'BovineLD'),(352,477,'BovineSNP50'),(353,477,'MGP'),(354,477,'HumanOmni5'),(355,477,'phencode'),(356,477,'OvineSNP50'),(357,477,'OvineHDSNP'),(358,477,'ExomeChip'),(359,477,'ImmunoChip'),(360,477,'all_chips'),(361,470,'novel_sequence_insertion'),(362,469,'SO:0001838'),(363,471,'novel sequence insertion'),(364,479,'not provided'),(365,479,'association'),(366,479,'risk factor'),(367,497,'Multiple_observations'),(368,497,'Frequency'),(369,497,'HapMap'),(370,497,'1000Genomes'),(371,497,'Cited'),(372,497,'ESP'),(373,477,'HumanOmniExpress'),(374,477,'ClinVar'),(375,470,'genetic_marker'),(376,469,'SO:0001645'),(377,480,'uncertain significance'),(378,480,'not provided'),(379,480,'benign'),(380,480,'likely benign'),(381,480,'likely pathogenic'),(382,480,'pathogenic'),(383,480,'drug response'),(384,480,'histocompatibility'),(385,480,'other'),(386,480,'confers sensitivity'),(387,480,'risk factor'),(388,480,'association'),(389,480,'protective'),(390,477,'HumanCoreExome'),(391,476,'tolerated - low confidence'),(392,476,'deleterious - low confidence'),(395,477,'LSDB'),(396,477,'dbPEX'),(397,477,'HbVar'),(398,477,'Infevers'),(399,477,'KAT6BDB'),(400,477,'LMDD'),(401,477,'OIVD'),(402,477,'PAHdb'),(404,477,'1kg_3'),(405,477,'1kg_3_afr'),(406,477,'1kg_3_amr'),(407,477,'1kg_3_eas'),(408,477,'1kg_3_sas'),(409,477,'1kg_3_eur'),(410,477,'1kg_3_com'),(411,477,'1kg_3_afr_com'),(412,477,'1kg_3_amr_com'),(413,477,'1kg_3_eas_com'),(414,477,'1kg_3_sas_com'),(415,477,'1kg_3_eur_com'),(416,469,'SO:0001818'),(417,470,'protein_altering_variant'),(418,497,'Phenotype_or_Disease'),(419,477,'lsdb_variants'),(420,477,'exac'),(421,497,'ExAC'),(422,470,'interchromosomal_translocation'),(423,469,'SO:0002060'),(424,470,'intrachromosomal_translocation'),(425,469,'SO:0002061'),(426,470,'Alu_insertion'),(427,469,'SO:0002063'),(428,477,'PorcineLD'),(429,477,'PorcineHD'),(430,477,'Affy_PorcineHD'),(431,470,'complex_substitution'),(432,469,'SO:1000005'),(433,471,'complex substitution'),(434,497,'1000Bull_Genomes'),(435,497,'WTSI_MGP'),(436,508,'co-located allele'),(437,509,'Data source'),(438,509,'OLS exact'),(439,509,'OLS partial'),(440,509,'Zooma exact'),(441,509,'Zooma partial'),(442,509,'Manual'),(443,509,'HPO'),(444,509,'Orphanet'),(445,477,'CTM'),(446,477,'LVP'),(447,477,'RexD'),(448,477,'Bora_Bora'),(449,477,'Perm-R'),(450,477,'Imida-R'),(451,477,'Propo-R'),(452,477,'JPD_insecticide_resistance'),(453,477,'PMID:24168143_dengue_functional_polymorphisms'),(454,477,'PMID:24593293_insecticide_resistance'),(455,477,'Australia_2011'),(456,477,'Florida_2011'),(457,477,'Puerto_Rico_2013'),(458,477,'Uganda_2011'),(459,477,'Mexico_2013'),(460,477,'Texas_2011'),(461,477,'Hawaii_2011'),(462,477,'Thailand_2011'),(463,477,'PMID_25721127_Aedes_SNP_chip_all_field_isolates'),(464,477,'Senegal_Goudiry_2011'),(465,477,'Tahiti_2013'),(466,477,'Brazil_2013'),(467,477,'Senegal_Sedhiou_2011'),(468,477,'agsnp01'),(469,477,'4ARR'),(470,477,'KISUMU'),(471,477,'Akron'),(472,477,'L3-5'),(473,477,'G3'),(474,477,'TEP1_variations'),(475,477,'agsnp01_66k'),(476,477,'lstm_gg_0.8k'),(477,477,'S.marcescens_infectivity_resistance'),(478,477,'affy_250k_snps'),(479,477,'perl_1m_snps'),(480,477,'cao_snps'),(481,477,'wtchg_snps'),(482,477,'wtchg_insertions'),(483,477,'wtchg_all_variations'),(484,477,'wtchg_substitutions'),(485,477,'salk_snps'),(486,477,'nordborg_snps'),(487,477,'salk_all_variations'),(488,477,'nordborg_all_variations'),(489,477,'salk_deletions'),(490,477,'1001_snps'),(491,477,'1001_deletions'),(492,477,'1001_insertions'),(493,477,'1001_substitutions'),(494,477,'1001_all_variations_bc'),(495,477,'nordborg_substitutions'),(496,477,'salk_substitutions'),(497,477,'wtchg_deletions'),(498,477,'cao_all_variations'),(499,477,'wgs_SNP'),(500,477,'RNA-seq_SNP'),(501,477,'MxB_popseq_SNP'),(502,477,'OWB_popseq_SNP'),(503,477,'iSelect_9k'),(504,477,'Indiana'),(505,477,'Maine'),(506,477,'Massachusetts'),(507,477,'New_Hampshire'),(508,477,'North_Carolina'),(509,477,'Wikel_ODU_colony'),(510,477,'Wikel_UTMB_colony'),(511,477,'Wisconsin'),(512,477,'Virginia'),(513,477,'Florida'),(514,477,'RADSeq_tick_population_analysis'),(515,477,'duitama'),(516,477,'zhao'),(517,477,'bgi'),(518,477,'omap'),(519,477,'mcnally'),(520,477,'3k'),(521,477,'myles_hq_snps'),(522,477,'PMID:26206155_deltamethrin_resistance_study'),(523,477,'PMID:26206155_high_significance_deltamethrin_resistance_variants'),(524,477,'PMID:23708298_Anopheles_16_genomes'),(525,477,'Burkina_Faso'),(526,477,'Cameroon'),(527,477,'Tanzania'),(528,477,'Iran_A_form'),(529,477,'Iran_D_form'),(530,477,'DDT_resistant'),(531,477,'DDT_susceptible'),(532,477,'Haleta'),(533,477,'Queensland'),(534,477,'Madang'),(535,477,'Tanna'),(536,477,'Folonzo'),(537,477,'Kiribina'),(538,477,'arabiensis'),(539,477,'coluzzii'),(540,477,'gambiae'),(541,477,'goundry'),(542,477,'MR4_colony_variations_WTSI-Ag-GVP-0.1'),(543,477,'Campo'),(544,477,'Ballingho'),(545,477,'Ipono'),(546,477,'Luba'),(547,477,'Kenya'),(548,477,'Mpumalanga'),(549,477,'India'),(550,477,'Thailand'),(551,477,'Zimbabwe'),(552,477,'China_S'),(553,477,'China_R'),(554,477,'Indian_strain_colony'),(555,477,'AS01-WBAN'),(556,477,'AS01-CHB'),(557,477,'AS01-BAN'),(558,477,'AS01-IRN'),(559,477,'AS01-KAZ'),(560,469,'SO:0002096'),(561,470,'short_tandem_repeat_variation'),(562,471,'short tandem repeat variation'),(563,469,'SO:0001786'),(564,470,'loss_of_heterozygosity'),(565,471,'loss of heterozygosity'),(566,477,'Axiom820'),(567,477,'Axiom35'),(568,477,'EMS_Kronos'),(569,477,'EMS_Cadenza'),(570,477,'KASP'),(571,477,'HapMap_WEC'),(572,477,'HapMap_GBS'),(573,497,'TOPMed'),(578,477,'IHVs_AB'),(579,477,'IHVs_AD'),(580,477,'IHVs_BD'),(581,477,'iSelect'),(582,470,'mobile_element_deletion'),(583,469,'SO:0002066'),(584,471,'mobile element deletion'),(585,497,'gnomAD'),(586,477,'gnomAD'),(587,477,'GoatSNP50'),(588,509,'Rat Genome Database'),(589,509,'Animal_QTLdb'),(590,509,'ClinVar'),(591,509,'DDG2P'),(592,509,'NHGRI-EBI GWAS catalog'),(593,509,'MGP'),(594,509,'IMPC'),(595,477,'Illumina_EquineSNP50'),(596,531,'likely benign'),(597,531,'likely deleterious'),(598,532,'likely disease causing'),(599,532,'likely benign'),(600,533,'tolerated'),(601,534,'high'),(602,534,'medium'),(603,534,'low'),(604,534,'neutral'),(605,481,'dbnsfp_cadd'),(606,481,'dbnsfp_meta_svm'),(607,481,'dbnsfp_mutation_assessor'),(608,481,'dbnsfp_revel'),(609,481,'cadd');
/*!40000 ALTER TABLE `attrib` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attrib_set`
--

DROP TABLE IF EXISTS `attrib_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attrib_set` (
  `attrib_set_id` int(11) unsigned NOT NULL DEFAULT '0',
  `attrib_id` int(11) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `set_idx` (`attrib_set_id`,`attrib_id`),
  KEY `attrib_idx` (`attrib_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attrib_set`
--

LOCK TABLES `attrib_set` WRITE;
/*!40000 ALTER TABLE `attrib_set` DISABLE KEYS */;
INSERT INTO `attrib_set` VALUES (1,1),(1,2),(1,3),(2,4),(2,5),(3,6),(3,7),(3,8),(4,9),(4,10),(5,11),(5,12),(6,13),(6,14),(7,15),(7,16),(8,17),(8,18),(38,97),(38,98),(39,99),(39,100),(40,101),(40,102),(41,103),(41,104),(42,105),(42,106),(43,107),(43,108),(44,109),(44,110),(45,111),(45,112),(45,113),(46,114),(46,115),(46,116),(49,200),(49,201),(49,202),(50,203),(50,204),(50,205),(51,206),(51,207),(52,208),(52,209),(52,210),(53,211),(53,212),(53,213),(54,242),(54,243),(54,244),(60,255),(60,256),(79,72),(79,73),(79,74),(79,134),(79,138),(79,147),(87,286),(87,287),(87,288),(88,289),(88,290),(88,291),(89,292),(89,293),(90,19),(90,20),(90,21),(90,294),(91,24),(91,118),(91,266),(91,295),(91,296),(92,27),(92,118),(92,265),(92,297),(92,298),(93,32),(93,33),(93,34),(93,125),(93,126),(93,145),(94,34),(94,36),(94,126),(94,128),(94,129),(94,145),(95,37),(95,38),(95,39),(95,126),(95,135),(97,43),(97,44),(97,45),(97,122),(97,133),(97,134),(98,46),(98,47),(98,48),(98,124),(98,134),(98,136),(99,54),(99,132),(99,134),(99,139),(99,299),(99,300),(100,55),(100,57),(100,134),(100,141),(100,153),(100,301),(101,57),(101,134),(101,140),(101,302),(101,303),(102,57),(102,134),(102,154),(102,304),(102,305),(103,62),(103,63),(103,64),(103,134),(103,144),(103,146),(104,65),(104,66),(104,67),(104,134),(104,143),(105,54),(105,68),(105,69),(105,132),(105,134),(106,57),(106,70),(106,134),(106,142),(106,306),(107,75),(107,76),(107,77),(107,134),(107,137),(109,81),(109,82),(109,83),(109,150),(109,263),(111,84),(111,85),(111,86),(111,151),(111,152),(112,87),(112,88),(112,89),(112,134),(112,149),(113,90),(113,91),(113,92),(113,155),(113,309),(114,92),(114,157),(114,158),(114,159),(114,310),(115,127),(115,134),(115,311),(115,312),(116,130),(116,134),(116,313),(116,314),(117,157),(117,261),(117,315),(117,316),(118,157),(118,317),(118,318),(118,319),(119,157),(119,320),(119,321),(119,322),(120,157),(120,323),(120,324),(120,325),(121,309),(121,326),(121,327),(121,346),(122,328),(122,329),(122,330),(122,346),(123,253),(123,254),(123,331),(124,40),(124,41),(124,42),(124,120),(124,126),(124,131),(125,78),(125,79),(125,80),(125,134),(125,262),(126,83),(126,119),(126,150),(126,307),(126,308),(127,361),(127,362),(127,363),(128,375),(128,376),(129,134),(129,153),(129,416),(129,417),(130,422),(130,423),(131,424),(131,425),(132,426),(132,427),(133,431),(133,432),(133,433),(134,560),(134,561),(134,562),(135,563),(135,564),(135,565),(137,582),(137,583),(137,584);
/*!40000 ALTER TABLE `attrib_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attrib_type`
--

DROP TABLE IF EXISTS `attrib_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attrib_type` (
  `attrib_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `code` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  PRIMARY KEY (`attrib_type_id`),
  UNIQUE KEY `code_idx` (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attrib_type`
--

LOCK TABLES `attrib_type` WRITE;
/*!40000 ALTER TABLE `attrib_type` DISABLE KEYS */;
INSERT INTO `attrib_type` VALUES (1,'embl_acc','European Nucleotide Archive (was EMBL) accession',NULL),(2,'status','Status',NULL),(3,'synonym','Synonym',NULL),(4,'name','Name','Alternative/long name'),(5,'type','Type of feature',NULL),(6,'toplevel','Top Level','Top Level Non-Redundant Sequence Region'),(7,'GeneCount','Gene Count','Total Number of Genes'),(10,'SNPCount','Short Variants','Total Number of SNPs'),(11,'codon_table','Codon Table','Alternate codon table'),(12,'_selenocysteine','Selenocysteine',NULL),(13,'bacend','bacend',NULL),(14,'htg','htg','High Throughput phase attribute'),(15,'miRNA','Micro RNA','Coordinates of the mature miRNA'),(16,'non_ref','Non Reference','Non Reference Sequence Region'),(17,'sanger_project','Sanger Project name',NULL),(18,'clone_name','Clone name',NULL),(19,'fish','FISH location',NULL),(21,'org','Sequencing centre',NULL),(22,'method','Method',NULL),(23,'superctg','Super contig id',NULL),(24,'inner_start','Max start value',NULL),(25,'inner_end','Min end value',NULL),(26,'state','Current state of clone',NULL),(27,'organisation','Organisation sequencing clone',NULL),(28,'seq_len','Accession length',NULL),(29,'fp_size','FP size',NULL),(30,'BACend_flag','BAC end flags',NULL),(31,'fpc_clone_id','fpc clone',NULL),(32,'KnwnPCCount','protein_coding_KNOWN','Number of Known Protein Coding'),(33,'NovPCCount','protein_coding_NOVEL','Number of Novel Protein Coding'),(36,'PredPCCount','protein_coding_PREDICTED','Number of Predicted Protein Coding'),(37,'IGGeneCount','IG_gene','Number of IG Genes'),(38,'IGPsGenCount','IG_pseudogene','Number of IG Pseudogenes'),(39,'TotPsCount','total_pseudogene','Total Number of Pseudogenes'),(42,'KnwnPCProgCount','protein_coding_in_progress_KNOWN','Number of Known Protein Coding in progress'),(43,'NovPCProgCount','protein_coding_in_progress_NOVEL','Number of Novel Protein Coding in progress'),(44,'AnnotSeqLength','Annotated sequence length','Annotated Sequence'),(45,'TotCloneNum','Total number of clones','Total Number of Clones'),(46,'NumAnnotClone','Fully annotated clones','Number of Fully Annotated Clones'),(47,'ack','Acknowledgement','Acknowledgement for manual annotation'),(48,'htg_phase','High throughput phase','High throughput genomic sequencing phase'),(49,'description','Description','A general descriptive text attribute'),(50,'chromosome','Chromosome','Chromosomal location for supercontigs that are not assembled'),(51,'nonsense','Nonsense Mutation','Strain specific nonesense mutation'),(52,'author','Author','Group resonsible for Vega annotation'),(53,'author_email','Author email address','Author email address'),(54,'remark','Remark','Annotation remark'),(55,'transcr_class','Transcript class','Transcript class'),(57,'ccds','CCDS','CCDS identifier'),(58,'CCDS_PublicNote','CCDS Public Note','Public Note for CCDS identifier, provided by http://www.ncbi.nlm.nih.gov/CCDS'),(59,'Frameshift','Frameshift','Frameshift modelled as intron'),(62,'ncRNA','Structure','RNA secondary structure line'),(63,'skip_clone','skip clone  Skip clone in align_by_clone_identity.pl',NULL),(64,'coding_cnt','Coding genes','Number of protein coding Genes'),(67,'pseudogene_cnt','Pseudogenes','Number of pseudogenes'),(80,'supercontig','SuperContig name',NULL),(81,'well_name','Well plate name',NULL),(82,'bacterial','Bacterial',NULL),(90,'bacend_well_nam','BACend well name',NULL),(91,'alt_well_name','Alt well name',NULL),(92,'TranscriptEdge','Transcript Edge',NULL),(93,'alt_embl_acc','Alt European Nucleotide Archive (was EMBL) acc',NULL),(94,'alt_org','Alt org',NULL),(95,'intl_clone_name','International Clone Name',NULL),(96,'embl_version','European Nucleotide Archive (was EMBL) Version',NULL),(97,'chr','Chromosome Name','Chromosome Name Contained in the Assembly'),(98,'equiv_asm','Equivalent EnsEMBL assembly','For full chromosomes made from NCBI AGPs'),(109,'HitSimilarity','hit similarity','percentage id to parent transcripts'),(110,'HitCoverage','hit coverage','coverage of parent transcripts'),(111,'PropNonGap','proportion non gap','proportion non gap'),(112,'NumStops','number of stops',NULL),(113,'GapExons','gap exons','number of gap exons'),(114,'SourceTran','source transcript','source transcript'),(115,'EndNotFound','end not found','end not found'),(116,'StartNotFound','start not found','start not found'),(117,'Frameshift Fra','Frameshift modelled as intron',NULL),(118,'ensembl_name','Ensembl name','Name of equivalent Ensembl chromosome'),(119,'NoAnnotation','NoAnnotation','Clones without manual annotation'),(120,'hap_contig','Haplotype contig','Contig present on a haplotype'),(121,'annotated','Clone Annotation Status',NULL),(122,'keyword','Clone Keyword',NULL),(123,'hidden_remark','Hidden Remark',NULL),(124,'mRNA_start_NF','mRNA start not found',NULL),(125,'mRNA_end_NF','mRNA end not found',NULL),(126,'cds_start_NF','CDS start not found',NULL),(127,'cds_end_NF','CDS end not found',NULL),(128,'write_access','Write access for Sequence Set','1 for writable , 0 for read-only'),(129,'hidden','Hidden Sequence Set',NULL),(130,'vega_name','Vega name','Vega seq_region.name'),(131,'vega_export_mod','Export mode','E (External), I (Internal) etc'),(132,'vega_release','Vega release','Vega release number'),(133,'atag_CLE','Clone_left_end','Clone_lef_end feature marked in GAP database'),(134,'atag_CRE','Clone_right_end','Clone_right_end feature marked in GAP database'),(135,'atag_Misc','Misc','miscellaneous feature marked in GAP database'),(136,'atag_Unsure','Unsure','region of uncertain DNA sequence marked in GAP database'),(137,'MultAssem','Multiple Assembled seq region','Part of Seq Region is part of more than one assembly'),(140,'wgs','WGS contig','WGS contig integrated into the map'),(141,'bac','AGP clones','tiling path of clones'),(142,'GeneGC','Gene GC','Percentage GC content for this gene'),(143,'TotAssemblyLeng','Finished sequence length','Length of the assembly not counting sequence gaps'),(144,'amino_acid_sub','Amino acid substitution','Some translations have been manually curated for amino acid substitiutions. For example a stop codon may be changed to an amino acid in order to prevent premature truncation, or one amino acid can be substituted for another.'),(145,'_rna_edit','rna_edit','RNA edit'),(146,'kill_reason','Kill Reason','Reason why a transcript has been killed'),(147,'strip_UTR','Strip UTR','Transcript needs bad UTR removing'),(148,'TotAssLength','Finished sequence length','Finished Sequence'),(149,'PsCount','pseudogene','Number of Pseudogenes'),(152,'TotPTCount','total_processed_transcript','Total Number of Processed Transcripts'),(153,'TotPCCount','total_protein_coding','Total Number of Protein Coding'),(156,'PolyPsCount','polymorphic_pseudogene','Number of Polymorphic Pseudogenes'),(157,'TotIGGeneCount','total_IG_gene','Total Number of IG Genes'),(158,'ProcPsCount','proc_pseudogene','Number of Processed Pseudogenes'),(159,'UnPsCount','unproc_pseudogene','Number of Unprocessed Pseudogenes'),(160,'TPsCount','transcribed_pseudogene','Number of Transcribed Pseudogenes'),(161,'TECCount','TEC','Number of TEC Genes'),(164,'IsoPoint','Isoelectric point','Pepstats attributes'),(165,'Charge','Charge','Pepstats attributes'),(166,'MolecularWeight','Molecular weight','Pepstats attributes'),(167,'NumResidues','Number of residues','Pepstats attributes'),(168,'AvgResWeight','Ave. residue weight','Pepstats attributes'),(170,'initial_met','Initial methionine','Set first amino acid to methionine'),(171,'NonGapHCov','NonGapHCov',NULL),(172,'otter_support','otter support','Evidence ID that was used as supporting feature for building a gene in Vega'),(173,'enst_link','enst link','Code to link a OTTT with an ENST when they both share the CDS of ENST'),(174,'upstream_ATG','upstream ATG','Alternative ATG found upstream of the defined as start ATG for the transcript'),(175,'TPPsCount','transcribed_processed_pseudogene','Number of Transcribed Processed Pseudogenes'),(176,'TUPsCount','transcribed_unprocessed_pseudogene','Number of Transcribed Unprocessed Pseudogenes'),(177,'UniPsCount','unitary_pseudogene','Number of Unitary Pseudogenes'),(180,'TUyPsCount','transcribed_unitary_pseudogene','Number of Transcribed Unitary Pseudogenes'),(181,'PolyCount','polymorphic','Number of Polymorphic Genes'),(184,'TRGeneCount','TR_gene','Number of TR Genes'),(185,'TRPsCount','TR_pseudo','Number of TR Pseudogenes'),(186,'tp_ott_support','otter protein transcript support','Evidence ID that was used as supporting feature for building a gene in Vega'),(187,'td_ott_support','otter dna transcript support','Evidence ID that was used as supporting feature for building a gene in Vega'),(188,'ep_ott_support','otter protein exon support','Evidence ID that was used as supporting feature for building a gene in Vega'),(189,'ed_ott_support','otter dna exon support','Evidence ID that was used as supporting feature for building a gene in Vega'),(191,'StopGained','SNP causes stop codon to be gained','This transcript has a variant that causes a stop codon to be gained in at least 10 percent of a HapMap population'),(192,'StopLost','SNP causes stop codon to be lost','This transcript has a variant that causes a stop codon to be lost in at least 10 percent of a HapMap population'),(198,'lost_frameshift','lost_frameshift','Frameshift on the query sequence is lost in the target sequence'),(199,'AltThreePrime','Alternate three prime end','The position of other possible three prime ends for the transcript'),(216,'GeneInLRG','Gene in LRG','This gene is contained within an LRG region'),(217,'GeneOverlapLRG','Gene overlaps LRG','This gene is partially overlapped by a LRG region (start or end outside LRG)'),(218,'readthrough_tra','readthrough transcript','Havana readthrough transcripts'),(300,'CNE','Constitutive exon','An exon that is always included in the mature mRNA, even in different mRNA isoforms'),(301,'CE','Cassette exon','One exon is spliced out of the primary transcript together with its flanking introns'),(302,'IR','Intron retention','A sequence is spliced out as an intron or remains in the mature mRNA transcript'),(303,'MXE','Mutually exclusive exons','In the simpliest case, one or two consecutive exons are retained but not both'),(304,'A3SS','Alternative 3\' sites','Two or more splice sites are recognized at the 5\' end of an exon. An alternative 3\' splice junction (acceptor site) is used, changing the 5\' boundary of the downstream exon'),(305,'A5SS','Alternative 5\' sites','Two or more splice sites are recognized at the 3\' end of an exon. An alternative 5\' splice junction (donor site) is used, changing the 3\' boundary of the upstream exon'),(306,'AFE','Alternative first exon','The second exons of each variant have identical boundaries, but the first exons do not overlap'),(307,'ALE','Alternative last exon','Penultimate exons of each splice variant have identical boundaries, but the last exons do not overlap'),(308,'II','Intron isoform','Alternative donor or acceptor splice sites lead to truncation or extension of introns, respectively'),(309,'EI','Exon isoform','Alternative donor or acceptor splice sites leads to truncation or extension of exons, respectively'),(310,'AI','Alternative initiation','Alternative choice of promoters'),(311,'AT','Alternative termination','Alternative choice of polyadenylation sites'),(312,'patch_fix','Assembly Patch Fix','Assembly patch that will, in the next assembly release, replace the corresponding sequence found in the current assembly'),(313,'patch_novel','Assembly Patch Novel','Assembly patch that will, in the next assembly release, be retained as an alternate non-reference sequence in a similar way to haplotypes'),(314,'LRG','Locus Reference Genomic','Locus Reference Genomic sequence'),(315,'NoEvidence','Evidence for transcript removed','Supporting evidence for this projected transcript has been removed'),(316,'circular_seq','Circular sequence','Circular chromosome or plasmid molecule'),(317,'external_db','External database','External database to which seq_region name may be linked'),(318,'split_tscript','split_tscript','split_tscript'),(319,'Threep','Three prime end','Alternate three prime end'),(320,'gene_cluster','Gene cluster','Havana annotated gene cluster'),(328,'_rib_frameshift','Ribosomal Frameshift','Position and magnitude of frameshift'),(345,'vega_ref_chrom','Vega reference chromosome','Haplotypes reference a regular chromosome (indicated in the value of the attribute)'),(346,'PutPCCount','protein_coding_PUTATIVE','Number of Putative Protein Coding'),(347,'proj_alt_seq','Projection altered sequence','Projected sequence differs from original'),(348,'hav_gene_type','Havana gene biotype','Gene biotype assigned by Havana'),(353,'noncoding_cnt','Non coding genes','Number of non coding genes'),(358,'PHIbase_mutant','PHI-base mutant','PHI-base phenotype of the mutants'),(360,'ncrna_host','ncrna_host','Havana ncrna_host gene'),(361,'peptide-class','Peptide classification','The classification of the gene or transcript based on alignment to NR (values: TE WH NH)'),(362,'working-set','Working Gene Set','High-confidence set of genes, composed of evidence-based genes and non-overlapping protein-coding ab initio gene models'),(363,'filtered-set','Filtered Gene Set v1','Working genes that are screened for TE content and orthology with sorghum and rice'),(364,'super-set','Super Working Gene Set','Set of all working gene set loci from both Builds 4a and 5a'),(365,'projected4a2','Projected by alignment','Temporary (Monday, August 23, 2010)'),(366,'merged','Merged species',NULL),(367,'karyotype_rank','Rank in the karyotype','For a given seq_region, if it is part of the species karyotype, will indicate its rank'),(368,'noncoding_acnt','Non coding genes','Number of non coding genes on alternate sequences'),(369,'coding_acnt','Coding genes','Number of protein coding genes on alternate sequences'),(370,'pseudogene_acnt','Pseudogenes','Number of pseudogenes on alternate sequences'),(371,'clone_end','Clone end','Side of the contig on which a vector lies (enum:RIGHT, LEFT)'),(372,'contig_scaffold','Contig Scaffold','Scaffold that contains mutually ordered contigs'),(373,'current_version','Current Accession Version','Identifies the most recent version of an accession'),(374,'seq_status','Sequence Status','Sequence status.'),(375,'clone_vector','Vector sequence','A clone-end vector associated with a contig (enum:SP6, T7).'),(376,'creation_date','Creation date','Creation date of annotation'),(377,'update_date','Update date','Last update date of annotation'),(378,'seq_date','Sequence date','Sequence date'),(379,'has_stop_codon','Contains stop codon','Translation attribute'),(380,'havana_cv','Havana CV term','Controlled vocabulary terms from Havana'),(381,'TlPPsCount','translated_processed_pseudogene','Number of Translated Processed Pseudogenes'),(382,'NoTransRefError','No translations due to reference error','This gene is believed to include protein coding transcripts, but no transcript has a translation due to a reference assembly error making specifying the translation impossible.'),(383,'parent_exon_key','parent_exon_key','The exon key to identify a projected transcript\'s parent transcript.'),(386,'parent_sid','parent_sid','The parent stable ID to identify a projected transcript\'s parent transcript. For internal statistics use only since this method does not work in all cases.'),(387,'noncoding_acnt_s','Small non coding genes','Number of small non coding genes on alternate sequences'),(388,'noncoding_acnt_m','Misc non coding genes','Number of unclassified (miscellaneous) non coding genes on alternate sequences'),(389,'noncoding_cnt_s','Small non coding genes','Number of small non coding genes'),(390,'noncoding_cnt_l','Long non coding genes','Number of long non coding genes'),(391,'TlUPsCount','translated_unprocessed_pseudogene','Number of Translated Unprocessed Pseudogenes'),(393,'AFFYMETRIXCount','AFFYMETRIX Count','Total Number of AFFYMETRIX features'),(394,'RFLPCount','RFLP Count','Total Number of RFLP features'),(395,'xref_id','Xref ID','ID of associated database reference'),(396,'vega_chr_type','Vega chrom type','Type of chromosome - haplotype, other, etc'),(398,'genscan','Genscan gene predictions','Number of prediction genes generated by Genscan'),(399,'gsc','GSC gene prediction','Number of prediction genes generated by gsc'),(400,'snap','Snap gene prediction','Number of prediction genes generated by Snap'),(401,'fgenesh','FGENESH gene prediction','Number of prediction genes generated by FGENESH'),(402,'genefinder','Genefinder gene prediction','Number of prediction genes generated by Genefinder'),(403,'transcript_cnt','Gene transcripts','Number of transcripts'),(404,'transcript_acnt','Gene transcripts','Number of transcripts on the alternate sequences'),(405,'ref_length','Golden Path Length','Length of the primary assembly'),(406,'total_length','Base Pairs','Total length of the assembly'),(407,'refseq_compare','refseq_compare','This attribute can be applied to both gene and transcript. It is supposed to give an indication of whether the annotation in the ensembl database is matched by annotation that we have imported from refseq. At the gene level, the match is unlikely to be an exact match because all or some of the transcripts may differ. Also, the biotype e.g. coding potential may differ. therefore, matching is a bit fuzzy and is done primarily on genomic location and then also takes gene length and gene name into consideration.'),(408,'coding_rcnt','Readthrough coding genes','Number of readthrough coding genes'),(409,'coding_racnt','Readthrough coding genes','Number of readthrough coding genes on alternate sequences'),(410,'noncoding_racnt_l','Readthrough long non coding genes','Number of readthrough long non coding genes on alternate sequences'),(411,'noncoding_racnt_s','Readthrough small non coding genes','Number of readthrough small non coding genes on alternate sequences'),(412,'noncoding_rcnt_s','Readthrough small non coding genes','Number of readthrough small non coding genes'),(413,'noncoding_rcnt_l','Readthrough long non coding genes','Number of readthrough long non coding genes'),(414,'pseudogene_rcnt','Readthrough pseudogenes','Number of readthrough pseudogenes'),(415,'pseudogene_racnt','Readthrough pseudogenes','Number of readthrough pseudogenes on alternate sequences'),(416,'gencode_level','GENCODE annotation level','level 1 (verified loci), level 2 (manually annotated loci), level 3 (automatically annotated loci)'),(417,'gencode_basic','GENCODE basic annotation','GENCODE Basic is a view provided by UCSC for users. It includes a subset of the GENCODE transcripts. In general, for protein coding genes it will show only the full length models (unless a protein coding gene has no full-length models, in which case other rules apply). For noncoding genes, it will also only show the full-length (mRNA start and end found) models (unless there are no full-length models, in which case other rules apply).'),(418,'struct_var','Structural variants','Total Number of structural variants'),(419,'genblast','GenBlastG gene predictions','Number of prediction genes generated by GenBlastG'),(420,'syn_gene_pairs','Syntenic gene pairs','Syntenic gene relationship from Gramene pipeline'),(421,'vectorbase_maker_pre','VectorBase gene predictions','Number of prediction genes generated with MAKER, by VectorBase.'),(422,'trnascan','tRNAscan-SE predictions','Number of predicted tRNA genes generated by tRNAscan-SE'),(423,'tgac_pred_supp7','T. turgidum RNA-seq alignments','Number of T. turgidum RNA-seq alignments from Krasileva et al.'),(424,'tgac_pred_supp17','T. aestivum RNA-seq alignments','Number of T. aestivum RNA-seq alignments from Krasileva et al.'),(425,'genome_component','Genome Component Name','For polyploid genome, the genome component name the seq_region belongs to'),(426,'transcript_whl','RNA-seq transcripts','RNA-seq transcripts from EchinoBase'),(427,'appris','APPRIS','APPRIS is a system that deploys a range of computational methods to provide value to the annotations of the human genome. APPRIS also selects one of the CDS for each gene as the principal isoform. APPRIS defines the principal variant by combining protein structural and functional information and information from the conservation of related species. principal1 - APPRIS principal isoform. principal2 - APPRIS candidate isoform (CCDS). principal3 - APPRIS candidate isoform (earliest CCDS). principal4 - APPRIS candidate isoform (longest CCDS). principal5 - APPRIS candidate isoform (longest coding sequence). alternative1 - APPRIS candidate isoform that is conserved in at least three tested species. alternative2 - APPRIS candidate isoform that appears to be conserved in fewer than three tested species'),(428,'TSL','Transcript Support Level','Transcription Support Level (TSL) is a method to highlight the well-supported and poorly-supported transcript models for users. The method relies on the primary data that can support full-length transcript structure and data are provided by UCSC.  The following categories are assigned to each of the evaluated annotations. tsl1 - all splice junctions of the transcript are supported by at least one non-suspect mRNA. tsl2 - the best supporting mRNA is flagged as suspect or the support is from multiple ESTs. tsl3 - the only support is from a single EST. tsl4 - the best supporting EST is flagged as suspect. tsl5 - no single transcript supports the model structure. tslNA - the transcript was not analyzed for one of the following reasons: pseudogene annotation, including transcribed pseudogenes.Human leukocyte antigen (HLA) transcript. Immunoglobin gene transcript.  T-cell receptor transcript. Single-exon transcript (will be included in a future version)'),(429,'protein_coverage','Protein Coverage','Protein coverage for this gene derived from geneTree in compara'),(430,'consensus_coverage','Consensus Coverage','Consensus coverage for this gene derived from geneTree in compara'),(431,'has_start_codon','Contains start codon','Translation attribute'),(437,'lncRNACount','lncRNA_Count','Number of lncRNAs'),(438,'ncRNACount','ncRNA_Count','Number of ncRNAs'),(439,'UnclassPTCount','UnclassPT_Count','Number of Unclassified Processed Transcripts'),(444,'noncoding_cnt_m','Misc non coding genes','Number of unclassified (miscellaneous) non coding genes'),(445,'noncoding_rcnt_m','Readthrough misc non coding genes','Number of readthrough unclassified (miscellaneous) non coding genes'),(446,'noncoding_racnt_m','Readthrough misc non coding genes','Number of readthrough unclassified (miscellaneous) non coding genes on alternate sequences'),(447,'noncoding_acnt_l','Long non coding genes','Number of long non coding genes on alternate sequences'),(448,'noncoding_racnt','Readthrough non coding genes','Number of readthrough non coding genes on alternate sequences'),(449,'noncoding_rcnt','Readthrough non coding genes','Number of readthrough non coding genes'),(450,'rseq_mrna_match','RefSeq model genomic seq to mRNA match','This is a transcript attribute that signifies an exact match between the underlying genomic sequence of the RefSeq transcript with the corresponding RefSeq mRNA sequence the model was built from (based on a match between the transcript stable id and an accession in the RefSeq mRNA file). An exact match occurs when the underlying genomic sequence of the model can be perfectly aligned to the mRNA sequence post polyA clipping.'),(451,'rseq_mrna_nonmatch','RefSeq model genomic seq to mRNA non-match','This is a transcript attribute that signifies a non-match between the underlying genomic sequence of the RefSeq transcript with the corresponding RefSeq mRNA sequence the model was built from. A non-match is deemed to have occurred if the underlying genomic sequence does not have a perfect alignment to the mRNA sequence post polyA clipping. It can also signify that no comparison was possible as the model stable id may not have had a corresponding entry in the RefSeq mRNA file (sometimes happens when accessions are retired or changed). When a non-match occurs one or several of the following transcript attributes will also be present to provide more detail on the nature of the non-match: rseq_5p_mismatch, rseq_cds_mismatch, rseq_3p_mismatch, rseq_nctran_mismatch, rseq_no_comparison'),(452,'rseq_5p_mismatch','RefSeq model genomic seq (5\' UTR) to mRNA mismatch','This is a transcript attribute that signifies a mismatch between the underlying genomic sequence of the RefSeq transcript with the corresponding RefSeq mRNA sequence the model was built from. Specifically, there is a mismatch in the 5\' UTR of the RefSeq model. Information about the mismatch can be found in the value field of the transcript attribute.'),(453,'rseq_cds_mismatch','RefSeq model genomic seq (CDS) to mRNA mismatch','This is a transcript attribute that signifies a mismatch between the underlying genomic sequence of the RefSeq transcript with the corresponding RefSeq mRNA sequence the model was built from. Specifically, there is a mismatch in the CDS of the RefSeq model. Information about the mismatch can be found in the value field of the transcript attribute.'),(454,'rseq_3p_mismatch','RefSeq model genomic seq (3\' UTR) to mRNA mismatch','This is a transcript attribute that signifies a mismatch between the underlying genomic sequence of the RefSeq transcript with the corresponding RefSeq mRNA sequence the model was built from. Specifically, there is a mismatch in the 3\' UTR of the RefSeq model. Information about the mismatch can be found in the value field of the transcript attribute.'),(455,'rseq_nctran_mismatch','RefSeq model genomic seq (non-coding) to mRNA mismatch','This is a transcript attribute that signifies a mismatch between the underlying genomic sequence of the RefSeq transcript with the corresponding RefSeq mRNA sequence the model was built from. This is a comparison between the entire underlying genomic sequence of the RefSeq model to the mRNA in the case of RefSeq models that are non-coding. Information about the mismatch can be found in the value field of the transcript attribute.'),(456,'rseq_no_comparison','RefSeq model no comparison made to mRNA','This is a transcript attribute that signifies that no alignment was carried out between the underlying genomic sequence of RefSeq model and a corresponding RefSeq mRNA. The reason for this is generally that no corresponding, unversioned accession was found in the RefSeq mRNA file for the transcript stable id. This sometimes happens when accessions are retired or replaced. A second possibility is that the sequences were too long and problematic to align (though this is rare). The value field gives more information about the reason no comparison was possible.'),(457,'rseq_ens_match_wt','RefSeq model to overlapping Ensembl model whole transcript match','This is a transcript attribute that signifies that for the RefSeq transcript there is an overlapping Ensembl model that is identical across the whole transcript. A whole transcript match is defined as follows: 1) In the case that both models are coding, the transcript, CDS and peptide sequences are all identical and the genomic coordinates of every exon match. 2) In the case that both transcripts are non-coding the transcript sequences and the genomic coordinates of every exon are identical. No comparison is made between a coding and a non-coding transcript. Useful related attributes are: rseq_ens_match_cds and rseq_ens_no_match.'),(458,'rseq_ens_match_cds','RefSeq model to overlapping Ensembl model CDS match','This is a transcript attribute that signifies that for the RefSeq transcript there is an overlapping Ensembl model that is identical across the CDS region only. A CDS match is defined as follows: the CDS and peptide sequences are identical and the genomic coordinates of every translatable exon match. Useful related attributes are: rseq_ens_match_wt and rseq_ens_no_match.'),(459,'rseq_ens_no_match','RefSeq model to overlapping Ensembl model no match','This is a transcript attribute that signifies that for the RefSeq transcript there is no overlapping Ensembl model that is identical across either the whole transcript or the CDS. This is caused by differences between the transcript, CDS or peptide sequences or between the exon genomic coordinates. Useful related attributes are: rseq_ens_match_wt and rseq_ens_match_cds.'),(468,'ccds_transcript','CCDS transcript','This attribute signifies that a transcript has a matching CCDS transcript (the accession of which will be in the value column of the transcript_attrib entry). A match occurs when the genomic coordinates of all coding exons of the transcript are identical to the genomic coordinate of all coding exons in the overlapping CCDS model.'),(469,'SO_accession','SO accession','Sequence Ontology accession'),(470,'SO_term','SO term','Sequence Ontology term'),(471,'display_term','display term','Ensembl display term'),(472,'NCBI_term','NCBI term','NCBI term'),(473,'feature_SO_term','feature SO term','Sequence Ontology term for the associated feature'),(474,'rank','rank','Relative severity of this variation consequence'),(475,'polyphen_prediction','polyphen prediction','PolyPhen-2 prediction'),(476,'sift_prediction','sift prediction','SIFT prediction'),(477,'short_name','Short name','A shorter name for an instance, e.g. a VariationSet'),(478,'dbsnp_clin_sig','dbSNP/ClinVar clinical significance','The clinical significance of a variant as reported by ClinVar and dbSNP'),(479,'dgva_clin_sig','DGVa clinical significance','The clinical significance of a structural variant as reported by DGVa'),(480,'clinvar_clin_sig','ClinVar clinical significance','The clinical significance of a variant as reported by ClinVar'),(481,'prot_func_analysis','Protein function analysis ','The program used to make protein function predictions'),(482,'associated_gene','Associated gene','ID of gene(s) linked by phenotype association'),(483,'risk_allele','Risk allele','Risk allele in phenotype association'),(484,'p_value','P-value','P-value denoting significance of an observed phenotype annotation'),(485,'variation_names','Variation names','Variant ID(s) linked with a phenotype association'),(486,'sample_id','Sample ID','Sample ID for source of phenotype association'),(487,'strain_id','Strain ID','Strain ID for source of phenotype association'),(488,'lod_score','LOD score','Log Of Odds score'),(489,'variance','Variance','Variance statistic'),(490,'inheritance_type','Inheritance type','Inheritance type of a trait'),(491,'external_id','External ID','External identifier for an entity'),(492,'odds_ratio','Odds ratio','Odds ratio used to denote significance of an observed phenotype annotation'),(493,'beta_coef','Beta coefficient','Beta coefficient (or standardized coefficient) used to denote significance of an observed phenotype annotation'),(494,'allele_symbol','Allele symbol','Allele symbol linked with phenotype association'),(495,'allele_accession_id','Allele accession ID','Allele accession ID linked with phenotype association'),(496,'marker_accession_id','Marker accession ID','Marker ID linked with phenotype association'),(497,'evidence','Variant evidence status','Evidence status for a variant'),(498,'review_status','ClinVar review_status','ClinVar review_status for assertation'),(499,'based_on','Evidence type used for protein impact prediction','Evidence type used for a PolyPhen protein impact prediction'),(500,'conservation_score','Sift conservation score','Median conservation va in an alignment used to make a Sift prediction'),(501,'sequence_number','Number of sequences in alignment','Number of protein sequences in the alignment use to make a protein impact prediction'),(502,'otter_truncated','Otter truncated feature','This feature extends beyond the slice, but has been trimmed. (For use in otter client-server communications.)'),(503,'trans_spliced','Trans-spliced transcript','A single RNA transcript derived from multiple precursor mRNAs.'),(505,'genebuild_msu7_tes','TE-related Gene (MSU)','Number of TE-related genes predicted by <a href=\"http://rice.plantbiology.msu.edu\">MSU</a> through a process of automatic and manual curation'),(506,'ibsc_low_confidence','PGSB low-confidence','Number of low-confidence genes annotated by the <A HREF=\"http://pgsb.helmholtz-muenchen.de/plant/barley/index.jsp\">International Barley Sequencing Consortium</A>'),(507,'pubmed_id','PubMed ID','PubMed identifier'),(508,'var_att','variation_attrib','An attribute of a variation'),(509,'ontology_mapping','Ontology Mapping','Method used to link a description to an ontology term'),(510,'enst_refseq_compare','ENST/RefSeq sequence and structural comparisons','Each Ensembl transcript is compared to overlapping RefSeq transcripts. The comparison is only coding-coding or non-coding to non-coding. The calculations are as follows: Foreach Ensembl transcript:  Fetch overlapping RefSeq transcripts  Foreach RefSeq transcript:    1) Check if all exon coordinates match    2) Check if transcript sequences match    3) If both transcripts are protein coding:        a) Check if the CDS exon coordinates match        b) Check if the CDS sequences match        c) Check if the translation sequences match Checks 1 & 2 only are run on pairs of non-coding transcripts, while checks 1, 2, 3a, 3b and 3c are run for pairs of protein coding transcripts. For non-coding models: RefSeq transcript accessions passing checks 1 and 2 will get a line in the value column consisting of all such accessions (separated by \":\") suffixed  by \":whole_transcript\", to indicate these RefSeq accessions have a complete sequence and structural match across the entire transcript. Checks 3a, 3b and 3c are not considered as the transcripts are non-coding For coding models: RefSeq transcript accessions passing all five checks will get a line in the value column consisting of all such accessions (separated by \":\") suffixed  by \":whole_transcript\", to indicate these RefSeq accessions have a complete sequence and structural match across the entire transcript RefSeq transcript accessions passing tests 3a,3b and 3c (but not both test 1 & 2)  will get a line in the value column consisting of all such accessions (separated by \":\") suffixed  by \":cds_only\", to indicate these RefSeq accessions have a sequence and structural match across only the CDS region.'),(511,'rna_gene_biotype','Biotype','Biotype of an RNA gene'),(512,'cmscan_truncated','Truncated','In a cmscan alignment, the end of the gene which is truncated'),(513,'cmscan_accuracy','Accuracy','The accuracy value in a cmscan alignment'),(514,'cmscan_bias','Bias','The bias value in a cmscan alignment'),(515,'cmscan_gc','GC','The GC value in a cmscan alignment'),(516,'cmscan_significant','Significant','The significant value in a cmscan alignment'),(517,'rfam_accession','Accession','Rfam accession'),(518,'broken_translation','broken translation','Transcript contains translation which contains stop codon.'),(519,'proj_parent_t','projection parent transcript','Stable identifier of the parent transcript this transcript was projected from (projection between different species and/or assemblies).'),(520,'proj_parent_g','projection parent gene','Stable identifier of the parent gene this gene was projected from (projection between different species and/or assemblies).'),(521,'MIM','MIM id','MIM id'),(522,'vectorbase_adar','VectorBase gene predictions','Number of prediction genes generated with MAKER, by VectorBase.'),(523,'_transl_start','Translation start','The start position for translation within a transcript-level seq_edit.'),(524,'_transl_end','Translation end','The end position for translation within a transcript-level seq_edit.'),(525,'submitter','submitter','A group submitting data to a major repository eg. ClinVar'),(527,'submitter_id','Submitter_ID','ID for data submitter'),(526,'DateLastEvaluated','EvalDate','The most recent date on which evidence was evaluated and this conclusion drawn.'),(528,'qtaro_category','Q-TARO Category','The phenotype \"Category of Object Character\" in the <a href=\"http://qtaro.abr.affrc.go.jp\">Q-TARO (QTL Annotation Rice Online) database</a>'),(529,'qtaro_parent_a','Q-TARO Parent A','Parent A in the <a href=\"http://qtaro.abr.affrc.go.jp\">Q-TARO (QTL Annotation Rice Online) database</a> QTL Information Table.'),(530,'qtaro_parent_b','Q-TARO Parent B','Parent B in the <a href=\"http://qtaro.abr.affrc.go.jp\">Q-TARO (QTL Annotation Rice Online) database</a> QTL Information Table.'),(531,'cadd_pred','CADD prediction','CADD prediction'),(532,'dbnsfp_revel_pred','dbNSFP REVEL prediction','dbNSFP REVEL prediction'),(533,'dbnsfp_meta_svm_pred','dbNSFP MetaSVM prediction','dbNSFP MetaSVM prediction'),(534,'dbnsfp_ma_pred','dbNSFP mutation assessor prediction','dbNSFP mutation assessor prediction');
/*!40000 ALTER TABLE `attrib_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compressed_genotype_region`
--

DROP TABLE IF EXISTS `compressed_genotype_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `compressed_genotype_region` (
  `sample_id` int(10) unsigned NOT NULL,
  `seq_region_id` int(10) unsigned NOT NULL,
  `seq_region_start` int(11) NOT NULL,
  `seq_region_end` int(11) NOT NULL,
  `seq_region_strand` tinyint(4) NOT NULL,
  `genotypes` blob,
  KEY `pos_idx` (`seq_region_id`,`seq_region_start`),
  KEY `sample_idx` (`sample_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compressed_genotype_region`
--

LOCK TABLES `compressed_genotype_region` WRITE;
/*!40000 ALTER TABLE `compressed_genotype_region` DISABLE KEYS */;
/*!40000 ALTER TABLE `compressed_genotype_region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compressed_genotype_var`
--

DROP TABLE IF EXISTS `compressed_genotype_var`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `compressed_genotype_var` (
  `variation_id` int(11) unsigned NOT NULL,
  `subsnp_id` int(11) unsigned DEFAULT NULL,
  `genotypes` blob,
  KEY `variation_idx` (`variation_id`),
  KEY `subsnp_idx` (`subsnp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compressed_genotype_var`
--

LOCK TABLES `compressed_genotype_var` WRITE;
/*!40000 ALTER TABLE `compressed_genotype_var` DISABLE KEYS */;
/*!40000 ALTER TABLE `compressed_genotype_var` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coord_system`
--

DROP TABLE IF EXISTS `coord_system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coord_system` (
  `coord_system_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `species_id` int(10) unsigned NOT NULL DEFAULT '1',
  `name` varchar(40) NOT NULL,
  `version` varchar(255) DEFAULT NULL,
  `rank` int(11) NOT NULL,
  `attrib` set('default_version','sequence_level') DEFAULT NULL,
  PRIMARY KEY (`coord_system_id`),
  UNIQUE KEY `rank_idx` (`rank`,`species_id`),
  UNIQUE KEY `name_idx` (`name`,`version`,`species_id`),
  KEY `species_idx` (`species_id`)
) ENGINE=MyISAM AUTO_INCREMENT=174 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coord_system`
--

LOCK TABLES `coord_system` WRITE;
/*!40000 ALTER TABLE `coord_system` DISABLE KEYS */;
INSERT INTO `coord_system` VALUES (172,1,'chromosome','ASM1252v1',1,'default_version'),(173,1,'plasmid','ASM1252v1',2,'default_version');
/*!40000 ALTER TABLE `coord_system` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `display_group`
--

DROP TABLE IF EXISTS `display_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `display_group` (
  `display_group_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `display_priority` int(10) unsigned NOT NULL,
  `display_name` varchar(255) NOT NULL,
  PRIMARY KEY (`display_group_id`),
  UNIQUE KEY `display_name` (`display_name`),
  UNIQUE KEY `display_priority` (`display_priority`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `display_group`
--

LOCK TABLES `display_group` WRITE;
/*!40000 ALTER TABLE `display_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `display_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_allele`
--

DROP TABLE IF EXISTS `failed_allele`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_allele` (
  `failed_allele_id` int(11) NOT NULL AUTO_INCREMENT,
  `allele_id` int(10) unsigned NOT NULL,
  `failed_description_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`failed_allele_id`),
  UNIQUE KEY `allele_idx` (`allele_id`,`failed_description_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_allele`
--

LOCK TABLES `failed_allele` WRITE;
/*!40000 ALTER TABLE `failed_allele` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_allele` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_description`
--

DROP TABLE IF EXISTS `failed_description`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_description` (
  `failed_description_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  PRIMARY KEY (`failed_description_id`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_description`
--

LOCK TABLES `failed_description` WRITE;
/*!40000 ALTER TABLE `failed_description` DISABLE KEYS */;
INSERT INTO `failed_description` VALUES (1,'Variant maps to more than 3 different locations'),(2,'None of the variant alleles match the reference allele'),(3,'Variant has more than 3 different alleles'),(4,'Loci with no observed variant alleles in dbSNP'),(5,'Variant does not map to the genome'),(6,'Variant has no genotypes'),(7,'Genotype frequencies do not add up to 1'),(8,'Variant has no associated sequence'),(9,'Variant submission has been withdrawn by the 1000 genomes project due to high false positive rate'),(11,'Additional submitted allele data from dbSNP does not agree with the dbSNP refSNP alleles'),(12,'Variant has more than 3 different submitted alleles'),(13,'Alleles contain non-nucleotide characters'),(14,'Alleles contain ambiguity codes'),(15,'Mapped position is not compatible with reported alleles'),(16,'Flagged as suspect by dbSNP'),(17,'Variant can not be re-mapped to the current assembly'),(18,'Supporting evidence can not be re-mapped to the current assembly'),(19,'Variant maps to more than one genomic location'),(20,'Variant at first base in sequence'),(21,'Reference allele does not match the bases at this genome location'),(22,'Alleles cannot be resolved');
/*!40000 ALTER TABLE `failed_description` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_structural_variation`
--

DROP TABLE IF EXISTS `failed_structural_variation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_structural_variation` (
  `failed_structural_variation_id` int(11) NOT NULL AUTO_INCREMENT,
  `structural_variation_id` int(10) unsigned NOT NULL,
  `failed_description_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`failed_structural_variation_id`),
  UNIQUE KEY `structural_variation_idx` (`structural_variation_id`,`failed_description_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_structural_variation`
--

LOCK TABLES `failed_structural_variation` WRITE;
/*!40000 ALTER TABLE `failed_structural_variation` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_structural_variation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_variation`
--

DROP TABLE IF EXISTS `failed_variation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_variation` (
  `failed_variation_id` int(11) NOT NULL AUTO_INCREMENT,
  `variation_id` int(10) unsigned NOT NULL,
  `failed_description_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`failed_variation_id`),
  UNIQUE KEY `variation_idx` (`variation_id`,`failed_description_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_variation`
--

LOCK TABLES `failed_variation` WRITE;
/*!40000 ALTER TABLE `failed_variation` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_variation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_variation_feature`
--

DROP TABLE IF EXISTS `failed_variation_feature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_variation_feature` (
  `failed_variation_feature_id` int(11) NOT NULL AUTO_INCREMENT,
  `variation_feature_id` int(10) unsigned NOT NULL,
  `failed_description_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`failed_variation_feature_id`),
  UNIQUE KEY `variation_feature_idx` (`variation_feature_id`,`failed_description_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_variation_feature`
--

LOCK TABLES `failed_variation_feature` WRITE;
/*!40000 ALTER TABLE `failed_variation_feature` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_variation_feature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genotype_code`
--

DROP TABLE IF EXISTS `genotype_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genotype_code` (
  `genotype_code_id` int(11) unsigned NOT NULL,
  `allele_code_id` int(11) unsigned NOT NULL,
  `haplotype_id` tinyint(2) unsigned NOT NULL,
  `phased` tinyint(2) unsigned DEFAULT NULL,
  KEY `genotype_code_id` (`genotype_code_id`),
  KEY `allele_code_id` (`allele_code_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genotype_code`
--

LOCK TABLES `genotype_code` WRITE;
/*!40000 ALTER TABLE `genotype_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `genotype_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `individual`
--

DROP TABLE IF EXISTS `individual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `individual` (
  `individual_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `gender` enum('Male','Female','Unknown') NOT NULL DEFAULT 'Unknown',
  `father_individual_id` int(10) unsigned DEFAULT NULL,
  `mother_individual_id` int(10) unsigned DEFAULT NULL,
  `individual_type_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`individual_id`),
  KEY `father_individual_idx` (`father_individual_id`),
  KEY `mother_individual_idx` (`mother_individual_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `individual`
--

LOCK TABLES `individual` WRITE;
/*!40000 ALTER TABLE `individual` DISABLE KEYS */;
/*!40000 ALTER TABLE `individual` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `individual_synonym`
--

DROP TABLE IF EXISTS `individual_synonym`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `individual_synonym` (
  `synonym_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `individual_id` int(10) unsigned NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`synonym_id`),
  KEY `individual_idx` (`individual_id`),
  KEY `name` (`name`,`source_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `individual_synonym`
--

LOCK TABLES `individual_synonym` WRITE;
/*!40000 ALTER TABLE `individual_synonym` DISABLE KEYS */;
/*!40000 ALTER TABLE `individual_synonym` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `individual_type`
--

DROP TABLE IF EXISTS `individual_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `individual_type` (
  `individual_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`individual_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `individual_type`
--

LOCK TABLES `individual_type` WRITE;
/*!40000 ALTER TABLE `individual_type` DISABLE KEYS */;
INSERT INTO `individual_type` VALUES (1,'fully_inbred','multiple organisms have the same genome sequence'),(2,'partly_inbred','single organisms have reduced genome variability due to human intervention'),(3,'outbred','a single organism which breeds freely'),(4,'mutant','a single or multiple organisms with the same genome sequence that have a natural or experimentally induced mutation');
/*!40000 ALTER TABLE `individual_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meta`
--

DROP TABLE IF EXISTS `meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta` (
  `meta_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `species_id` int(10) unsigned DEFAULT '1',
  `meta_key` varchar(40) NOT NULL,
  `meta_value` varchar(255) NOT NULL,
  PRIMARY KEY (`meta_id`),
  UNIQUE KEY `species_key_value_idx` (`species_id`,`meta_key`,`meta_value`),
  KEY `species_value_idx` (`species_id`,`meta_value`)
) ENGINE=MyISAM AUTO_INCREMENT=16139 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meta`
--

LOCK TABLES `meta` WRITE;
/*!40000 ALTER TABLE `meta` DISABLE KEYS */;
INSERT INTO `meta` VALUES (1,NULL,'schema_type','variation'),(2,NULL,'schema_version','96'),(3,NULL,'patch','patch_95_96_a.sql|schema version'),(4,NULL,'patch','patch_95_96_b.sql|modify index on variation_synonym'),(5,NULL,'patch','patch_95_96_c.sql|add new entries to the failed_description table'),(6,NULL,'patch','patch_95_96_d.sql|create table to store failed variation features'),(7,NULL,'patch','patch_95_96_e.sql|Rename motif_name to binding_matrix_stable_id.');
/*!40000 ALTER TABLE `meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meta_coord`
--

DROP TABLE IF EXISTS `meta_coord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_coord` (
  `table_name` varchar(40) NOT NULL,
  `coord_system_id` int(10) unsigned NOT NULL,
  `max_length` int(11) DEFAULT NULL,
  UNIQUE KEY `table_name` (`table_name`,`coord_system_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meta_coord`
--

LOCK TABLES `meta_coord` WRITE;
/*!40000 ALTER TABLE `meta_coord` DISABLE KEYS */;
/*!40000 ALTER TABLE `meta_coord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `motif_feature_variation`
--

DROP TABLE IF EXISTS `motif_feature_variation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `motif_feature_variation` (
  `motif_feature_variation_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `variation_feature_id` int(11) unsigned NOT NULL,
  `feature_stable_id` varchar(128) DEFAULT NULL,
  `motif_feature_id` int(11) unsigned NOT NULL,
  `allele_string` text,
  `somatic` tinyint(1) NOT NULL DEFAULT '0',
  `consequence_types` set('TF_binding_site_variant','TFBS_ablation','TFBS_fusion','TFBS_amplification','TFBS_translocation') DEFAULT NULL,
  `binding_matrix_stable_id` varchar(60) DEFAULT NULL,
  `motif_start` int(11) unsigned DEFAULT NULL,
  `motif_end` int(11) unsigned DEFAULT NULL,
  `motif_score_delta` float DEFAULT NULL,
  `in_informative_position` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`motif_feature_variation_id`),
  KEY `variation_feature_idx` (`variation_feature_id`),
  KEY `feature_stable_idx` (`feature_stable_id`),
  KEY `consequence_type_idx` (`consequence_types`),
  KEY `somatic_feature_idx` (`feature_stable_id`,`somatic`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `motif_feature_variation`
--

LOCK TABLES `motif_feature_variation` WRITE;
/*!40000 ALTER TABLE `motif_feature_variation` DISABLE KEYS */;
/*!40000 ALTER TABLE `motif_feature_variation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phenotype`
--

DROP TABLE IF EXISTS `phenotype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phenotype` (
  `phenotype_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `stable_id` varchar(255) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`phenotype_id`),
  UNIQUE KEY `desc_idx` (`description`),
  KEY `name_idx` (`name`),
  KEY `stable_idx` (`stable_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phenotype`
--

LOCK TABLES `phenotype` WRITE;
/*!40000 ALTER TABLE `phenotype` DISABLE KEYS */;
/*!40000 ALTER TABLE `phenotype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phenotype_feature`
--

DROP TABLE IF EXISTS `phenotype_feature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phenotype_feature` (
  `phenotype_feature_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `phenotype_id` int(11) unsigned DEFAULT NULL,
  `source_id` int(11) unsigned DEFAULT NULL,
  `study_id` int(11) unsigned DEFAULT NULL,
  `type` enum('Gene','Variation','StructuralVariation','SupportingStructuralVariation','QTL','RegulatoryFeature') DEFAULT NULL,
  `object_id` varchar(255) DEFAULT NULL,
  `is_significant` tinyint(1) unsigned DEFAULT '1',
  `seq_region_id` int(11) unsigned DEFAULT NULL,
  `seq_region_start` int(11) unsigned DEFAULT NULL,
  `seq_region_end` int(11) unsigned DEFAULT NULL,
  `seq_region_strand` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`phenotype_feature_id`),
  KEY `phenotype_idx` (`phenotype_id`),
  KEY `object_idx` (`object_id`,`type`),
  KEY `type_idx` (`type`),
  KEY `pos_idx` (`seq_region_id`,`seq_region_start`,`seq_region_end`),
  KEY `source_idx` (`source_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phenotype_feature`
--

LOCK TABLES `phenotype_feature` WRITE;
/*!40000 ALTER TABLE `phenotype_feature` DISABLE KEYS */;
/*!40000 ALTER TABLE `phenotype_feature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phenotype_feature_attrib`
--

DROP TABLE IF EXISTS `phenotype_feature_attrib`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phenotype_feature_attrib` (
  `phenotype_feature_id` int(11) unsigned NOT NULL,
  `attrib_type_id` int(11) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  KEY `phenotype_feature_idx` (`phenotype_feature_id`),
  KEY `type_value_idx` (`attrib_type_id`,`value`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phenotype_feature_attrib`
--

LOCK TABLES `phenotype_feature_attrib` WRITE;
/*!40000 ALTER TABLE `phenotype_feature_attrib` DISABLE KEYS */;
/*!40000 ALTER TABLE `phenotype_feature_attrib` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phenotype_ontology_accession`
--

DROP TABLE IF EXISTS `phenotype_ontology_accession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phenotype_ontology_accession` (
  `phenotype_id` int(11) unsigned NOT NULL,
  `accession` varchar(255) NOT NULL,
  `mapped_by_attrib` set('437','438','439','440','441','442','443','444','588','589','590','591','592','593','594') DEFAULT NULL,
  `mapping_type` enum('is','involves') DEFAULT NULL,
  PRIMARY KEY (`phenotype_id`,`accession`),
  KEY `accession_idx` (`accession`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phenotype_ontology_accession`
--

LOCK TABLES `phenotype_ontology_accession` WRITE;
/*!40000 ALTER TABLE `phenotype_ontology_accession` DISABLE KEYS */;
/*!40000 ALTER TABLE `phenotype_ontology_accession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `population`
--

DROP TABLE IF EXISTS `population`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `population` (
  `population_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `size` int(10) DEFAULT NULL,
  `description` text,
  `collection` tinyint(1) DEFAULT '0',
  `freqs_from_gts` tinyint(1) DEFAULT NULL,
  `display` enum('LD','MARTDISPLAYABLE','UNDISPLAYABLE') DEFAULT 'UNDISPLAYABLE',
  `display_group_id` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`population_id`),
  KEY `name_idx` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `population`
--

LOCK TABLES `population` WRITE;
/*!40000 ALTER TABLE `population` DISABLE KEYS */;
/*!40000 ALTER TABLE `population` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `population_genotype`
--

DROP TABLE IF EXISTS `population_genotype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `population_genotype` (
  `population_genotype_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `variation_id` int(11) unsigned NOT NULL,
  `subsnp_id` int(11) unsigned DEFAULT NULL,
  `genotype_code_id` int(11) DEFAULT NULL,
  `frequency` float DEFAULT NULL,
  `population_id` int(10) unsigned DEFAULT NULL,
  `count` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`population_genotype_id`),
  KEY `population_idx` (`population_id`),
  KEY `variation_idx` (`variation_id`),
  KEY `subsnp_idx` (`subsnp_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `population_genotype`
--

LOCK TABLES `population_genotype` WRITE;
/*!40000 ALTER TABLE `population_genotype` DISABLE KEYS */;
/*!40000 ALTER TABLE `population_genotype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `population_structure`
--

DROP TABLE IF EXISTS `population_structure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `population_structure` (
  `super_population_id` int(10) unsigned NOT NULL,
  `sub_population_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `super_population_idx` (`super_population_id`,`sub_population_id`),
  KEY `sub_population_idx` (`sub_population_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `population_structure`
--

LOCK TABLES `population_structure` WRITE;
/*!40000 ALTER TABLE `population_structure` DISABLE KEYS */;
/*!40000 ALTER TABLE `population_structure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `population_synonym`
--

DROP TABLE IF EXISTS `population_synonym`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `population_synonym` (
  `synonym_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `population_id` int(10) unsigned NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`synonym_id`),
  KEY `population_idx` (`population_id`),
  KEY `name` (`name`,`source_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `population_synonym`
--

LOCK TABLES `population_synonym` WRITE;
/*!40000 ALTER TABLE `population_synonym` DISABLE KEYS */;
/*!40000 ALTER TABLE `population_synonym` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `protein_function_predictions`
--

DROP TABLE IF EXISTS `protein_function_predictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protein_function_predictions` (
  `translation_md5_id` int(11) unsigned NOT NULL,
  `analysis_attrib_id` int(11) unsigned NOT NULL,
  `prediction_matrix` mediumblob,
  PRIMARY KEY (`translation_md5_id`,`analysis_attrib_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `protein_function_predictions`
--

LOCK TABLES `protein_function_predictions` WRITE;
/*!40000 ALTER TABLE `protein_function_predictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `protein_function_predictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `protein_function_predictions_attrib`
--

DROP TABLE IF EXISTS `protein_function_predictions_attrib`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protein_function_predictions_attrib` (
  `translation_md5_id` int(11) unsigned NOT NULL,
  `analysis_attrib_id` int(11) unsigned NOT NULL,
  `attrib_type_id` int(11) unsigned NOT NULL,
  `position_values` blob,
  PRIMARY KEY (`translation_md5_id`,`analysis_attrib_id`,`attrib_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `protein_function_predictions_attrib`
--

LOCK TABLES `protein_function_predictions_attrib` WRITE;
/*!40000 ALTER TABLE `protein_function_predictions_attrib` DISABLE KEYS */;
/*!40000 ALTER TABLE `protein_function_predictions_attrib` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publication`
--

DROP TABLE IF EXISTS `publication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publication` (
  `publication_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `authors` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `pmid` int(10) DEFAULT NULL,
  `pmcid` varchar(255) DEFAULT NULL,
  `year` int(10) unsigned DEFAULT NULL,
  `doi` varchar(50) DEFAULT NULL,
  `ucsc_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`publication_id`),
  KEY `pmid_idx` (`pmid`),
  KEY `doi_idx` (`doi`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publication`
--

LOCK TABLES `publication` WRITE;
/*!40000 ALTER TABLE `publication` DISABLE KEYS */;
/*!40000 ALTER TABLE `publication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `read_coverage`
--

DROP TABLE IF EXISTS `read_coverage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `read_coverage` (
  `seq_region_id` int(10) unsigned NOT NULL,
  `seq_region_start` int(11) NOT NULL,
  `seq_region_end` int(11) NOT NULL,
  `level` tinyint(4) NOT NULL,
  `sample_id` int(10) unsigned NOT NULL,
  KEY `seq_region_idx` (`seq_region_id`,`seq_region_start`),
  KEY `sample_idx` (`sample_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `read_coverage`
--

LOCK TABLES `read_coverage` WRITE;
/*!40000 ALTER TABLE `read_coverage` DISABLE KEYS */;
/*!40000 ALTER TABLE `read_coverage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulatory_feature_variation`
--

DROP TABLE IF EXISTS `regulatory_feature_variation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regulatory_feature_variation` (
  `regulatory_feature_variation_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `variation_feature_id` int(11) unsigned NOT NULL,
  `feature_stable_id` varchar(128) DEFAULT NULL,
  `feature_type` text,
  `allele_string` text,
  `somatic` tinyint(1) NOT NULL DEFAULT '0',
  `consequence_types` set('regulatory_region_variant','regulatory_region_ablation','regulatory_region_fusion','regulatory_region_amplification','regulatory_region_translocation') DEFAULT NULL,
  PRIMARY KEY (`regulatory_feature_variation_id`),
  KEY `variation_feature_idx` (`variation_feature_id`),
  KEY `feature_stable_idx` (`feature_stable_id`),
  KEY `consequence_type_idx` (`consequence_types`),
  KEY `somatic_feature_idx` (`feature_stable_id`,`somatic`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulatory_feature_variation`
--

LOCK TABLES `regulatory_feature_variation` WRITE;
/*!40000 ALTER TABLE `regulatory_feature_variation` DISABLE KEYS */;
/*!40000 ALTER TABLE `regulatory_feature_variation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample`
--

DROP TABLE IF EXISTS `sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample` (
  `sample_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `individual_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `study_id` int(10) unsigned DEFAULT NULL,
  `display` enum('REFERENCE','DEFAULT','DISPLAYABLE','UNDISPLAYABLE','LD','MARTDISPLAYABLE') DEFAULT 'UNDISPLAYABLE',
  `has_coverage` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `variation_set_id` set('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64') DEFAULT NULL,
  PRIMARY KEY (`sample_id`),
  KEY `individual_idx` (`individual_id`),
  KEY `study_idx` (`study_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample`
--

LOCK TABLES `sample` WRITE;
/*!40000 ALTER TABLE `sample` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_genotype_multiple_bp`
--

DROP TABLE IF EXISTS `sample_genotype_multiple_bp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_genotype_multiple_bp` (
  `variation_id` int(10) unsigned NOT NULL,
  `subsnp_id` int(15) unsigned DEFAULT NULL,
  `allele_1` varchar(25000) DEFAULT NULL,
  `allele_2` varchar(25000) DEFAULT NULL,
  `sample_id` int(10) unsigned DEFAULT NULL,
  KEY `variation_idx` (`variation_id`),
  KEY `subsnp_idx` (`subsnp_id`),
  KEY `sample_idx` (`sample_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_genotype_multiple_bp`
--

LOCK TABLES `sample_genotype_multiple_bp` WRITE;
/*!40000 ALTER TABLE `sample_genotype_multiple_bp` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample_genotype_multiple_bp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_population`
--

DROP TABLE IF EXISTS `sample_population`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_population` (
  `sample_id` int(10) unsigned NOT NULL,
  `population_id` int(10) unsigned NOT NULL,
  KEY `sample_idx` (`sample_id`),
  KEY `population_idx` (`population_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_population`
--

LOCK TABLES `sample_population` WRITE;
/*!40000 ALTER TABLE `sample_population` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample_population` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_synonym`
--

DROP TABLE IF EXISTS `sample_synonym`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_synonym` (
  `synonym_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_id` int(10) unsigned NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`synonym_id`),
  KEY `sample_idx` (`sample_id`),
  KEY `name` (`name`,`source_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_synonym`
--

LOCK TABLES `sample_synonym` WRITE;
/*!40000 ALTER TABLE `sample_synonym` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample_synonym` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seq_region`
--

DROP TABLE IF EXISTS `seq_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seq_region` (
  `seq_region_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `coord_system_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`seq_region_id`),
  UNIQUE KEY `name_cs_idx` (`name`,`coord_system_id`),
  KEY `cs_idx` (`coord_system_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seq_region`
--

LOCK TABLES `seq_region` WRITE;
/*!40000 ALTER TABLE `seq_region` DISABLE KEYS */;
INSERT INTO `seq_region` VALUES (12726,'Chromosome',172),(12728,'1',173);
/*!40000 ALTER TABLE `seq_region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `source`
--

DROP TABLE IF EXISTS `source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `source` (
  `source_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(24) NOT NULL,
  `version` int(11) DEFAULT NULL,
  `description` varchar(400) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `type` enum('chip','lsdb') DEFAULT NULL,
  `somatic_status` enum('germline','somatic','mixed') DEFAULT 'germline',
  `data_types` set('variation','variation_synonym','structural_variation','phenotype_feature','study') DEFAULT NULL,
  PRIMARY KEY (`source_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `source`
--

LOCK TABLES `source` WRITE;
/*!40000 ALTER TABLE `source` DISABLE KEYS */;
/*!40000 ALTER TABLE `source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `structural_variation`
--

DROP TABLE IF EXISTS `structural_variation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structural_variation` (
  `structural_variation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `variation_name` varchar(255) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `study_id` int(10) unsigned DEFAULT NULL,
  `class_attrib_id` int(10) unsigned NOT NULL DEFAULT '0',
  `clinical_significance` set('uncertain significance','not provided','benign','likely benign','likely pathogenic','pathogenic','drug response','histocompatibility','other','confers sensitivity','risk factor','association','protective') DEFAULT NULL,
  `validation_status` enum('validated','not validated','high quality') DEFAULT NULL,
  `is_evidence` tinyint(4) DEFAULT '0',
  `somatic` tinyint(1) NOT NULL DEFAULT '0',
  `copy_number` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`structural_variation_id`),
  UNIQUE KEY `variation_name` (`variation_name`),
  KEY `source_idx` (`source_id`),
  KEY `study_idx` (`study_id`),
  KEY `attrib_idx` (`class_attrib_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `structural_variation`
--

LOCK TABLES `structural_variation` WRITE;
/*!40000 ALTER TABLE `structural_variation` DISABLE KEYS */;
/*!40000 ALTER TABLE `structural_variation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `structural_variation_association`
--

DROP TABLE IF EXISTS `structural_variation_association`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structural_variation_association` (
  `structural_variation_id` int(10) unsigned NOT NULL,
  `supporting_structural_variation_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`structural_variation_id`,`supporting_structural_variation_id`),
  KEY `structural_variation_idx` (`structural_variation_id`),
  KEY `supporting_structural_variation_idx` (`supporting_structural_variation_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `structural_variation_association`
--

LOCK TABLES `structural_variation_association` WRITE;
/*!40000 ALTER TABLE `structural_variation_association` DISABLE KEYS */;
/*!40000 ALTER TABLE `structural_variation_association` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `structural_variation_feature`
--

DROP TABLE IF EXISTS `structural_variation_feature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structural_variation_feature` (
  `structural_variation_feature_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `seq_region_id` int(10) unsigned NOT NULL,
  `outer_start` int(11) DEFAULT NULL,
  `seq_region_start` int(11) NOT NULL,
  `inner_start` int(11) DEFAULT NULL,
  `inner_end` int(11) DEFAULT NULL,
  `seq_region_end` int(11) NOT NULL,
  `outer_end` int(11) DEFAULT NULL,
  `seq_region_strand` tinyint(4) NOT NULL,
  `structural_variation_id` int(10) unsigned NOT NULL,
  `variation_name` varchar(255) DEFAULT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `study_id` int(10) unsigned DEFAULT NULL,
  `class_attrib_id` int(10) unsigned NOT NULL DEFAULT '0',
  `allele_string` longtext,
  `is_evidence` tinyint(1) NOT NULL DEFAULT '0',
  `somatic` tinyint(1) NOT NULL DEFAULT '0',
  `breakpoint_order` tinyint(4) DEFAULT NULL,
  `length` int(10) DEFAULT NULL,
  `variation_set_id` set('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64') NOT NULL DEFAULT '',
  PRIMARY KEY (`structural_variation_feature_id`),
  KEY `pos_idx` (`seq_region_id`,`seq_region_start`,`seq_region_end`),
  KEY `structural_variation_idx` (`structural_variation_id`),
  KEY `source_idx` (`source_id`),
  KEY `study_idx` (`study_id`),
  KEY `attrib_idx` (`class_attrib_id`),
  KEY `variation_set_idx` (`variation_set_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `structural_variation_feature`
--

LOCK TABLES `structural_variation_feature` WRITE;
/*!40000 ALTER TABLE `structural_variation_feature` DISABLE KEYS */;
/*!40000 ALTER TABLE `structural_variation_feature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `structural_variation_sample`
--

DROP TABLE IF EXISTS `structural_variation_sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `structural_variation_sample` (
  `structural_variation_sample_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `structural_variation_id` int(10) unsigned NOT NULL,
  `sample_id` int(10) unsigned DEFAULT NULL,
  `zygosity` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`structural_variation_sample_id`),
  KEY `structural_variation_idx` (`structural_variation_id`),
  KEY `sample_idx` (`sample_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `structural_variation_sample`
--

LOCK TABLES `structural_variation_sample` WRITE;
/*!40000 ALTER TABLE `structural_variation_sample` DISABLE KEYS */;
/*!40000 ALTER TABLE `structural_variation_sample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study`
--

DROP TABLE IF EXISTS `study`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `study` (
  `study_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `url` varchar(255) DEFAULT NULL,
  `external_reference` varchar(255) DEFAULT NULL,
  `study_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`study_id`),
  KEY `source_idx` (`source_id`),
  KEY `external_reference_idx` (`external_reference`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study`
--

LOCK TABLES `study` WRITE;
/*!40000 ALTER TABLE `study` DISABLE KEYS */;
/*!40000 ALTER TABLE `study` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submitter`
--

DROP TABLE IF EXISTS `submitter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submitter` (
  `submitter_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`submitter_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submitter`
--

LOCK TABLES `submitter` WRITE;
/*!40000 ALTER TABLE `submitter` DISABLE KEYS */;
/*!40000 ALTER TABLE `submitter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submitter_handle`
--

DROP TABLE IF EXISTS `submitter_handle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submitter_handle` (
  `handle_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `handle` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`handle_id`),
  UNIQUE KEY `handle` (`handle`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submitter_handle`
--

LOCK TABLES `submitter_handle` WRITE;
/*!40000 ALTER TABLE `submitter_handle` DISABLE KEYS */;
/*!40000 ALTER TABLE `submitter_handle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subsnp_handle`
--

DROP TABLE IF EXISTS `subsnp_handle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subsnp_handle` (
  `subsnp_id` int(11) unsigned NOT NULL,
  `handle` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`subsnp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subsnp_handle`
--

LOCK TABLES `subsnp_handle` WRITE;
/*!40000 ALTER TABLE `subsnp_handle` DISABLE KEYS */;
/*!40000 ALTER TABLE `subsnp_handle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tmp_sample_genotype_single_bp`
--

DROP TABLE IF EXISTS `tmp_sample_genotype_single_bp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_sample_genotype_single_bp` (
  `variation_id` int(10) NOT NULL,
  `subsnp_id` int(15) unsigned DEFAULT NULL,
  `allele_1` char(1) DEFAULT NULL,
  `allele_2` char(1) DEFAULT NULL,
  `sample_id` int(10) unsigned NOT NULL,
  KEY `variation_idx` (`variation_id`),
  KEY `subsnp_idx` (`subsnp_id`),
  KEY `sample_idx` (`sample_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 MAX_ROWS=100000000;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tmp_sample_genotype_single_bp`
--

LOCK TABLES `tmp_sample_genotype_single_bp` WRITE;
/*!40000 ALTER TABLE `tmp_sample_genotype_single_bp` DISABLE KEYS */;
/*!40000 ALTER TABLE `tmp_sample_genotype_single_bp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transcript_variation`
--

DROP TABLE IF EXISTS `transcript_variation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transcript_variation` (
  `transcript_variation_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `variation_feature_id` int(11) unsigned NOT NULL,
  `feature_stable_id` varchar(128) DEFAULT NULL,
  `allele_string` text,
  `somatic` tinyint(1) NOT NULL DEFAULT '0',
  `consequence_types` set('splice_acceptor_variant','splice_donor_variant','stop_lost','coding_sequence_variant','missense_variant','stop_gained','synonymous_variant','frameshift_variant','non_coding_transcript_variant','non_coding_transcript_exon_variant','mature_miRNA_variant','NMD_transcript_variant','5_prime_UTR_variant','3_prime_UTR_variant','incomplete_terminal_codon_variant','intron_variant','splice_region_variant','downstream_gene_variant','upstream_gene_variant','start_lost','stop_retained_variant','inframe_insertion','inframe_deletion','transcript_ablation','transcript_fusion','transcript_amplification','transcript_translocation','feature_elongation','feature_truncation','protein_altering_variant','start_retained_variant') DEFAULT NULL,
  `cds_start` int(11) unsigned DEFAULT NULL,
  `cds_end` int(11) unsigned DEFAULT NULL,
  `cdna_start` int(11) unsigned DEFAULT NULL,
  `cdna_end` int(11) unsigned DEFAULT NULL,
  `translation_start` int(11) unsigned DEFAULT NULL,
  `translation_end` int(11) unsigned DEFAULT NULL,
  `distance_to_transcript` int(11) unsigned DEFAULT NULL,
  `codon_allele_string` text,
  `pep_allele_string` text,
  `hgvs_genomic` text,
  `hgvs_transcript` text,
  `hgvs_protein` text,
  `polyphen_prediction` enum('unknown','benign','possibly damaging','probably damaging') DEFAULT NULL,
  `polyphen_score` float DEFAULT NULL,
  `sift_prediction` enum('tolerated','deleterious','tolerated - low confidence','deleterious - low confidence') DEFAULT NULL,
  `sift_score` float DEFAULT NULL,
  `display` int(1) DEFAULT '1',
  PRIMARY KEY (`transcript_variation_id`),
  KEY `variation_feature_idx` (`variation_feature_id`),
  KEY `consequence_type_idx` (`consequence_types`),
  KEY `somatic_feature_idx` (`feature_stable_id`,`somatic`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transcript_variation`
--

LOCK TABLES `transcript_variation` WRITE;
/*!40000 ALTER TABLE `transcript_variation` DISABLE KEYS */;
/*!40000 ALTER TABLE `transcript_variation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translation_md5`
--

DROP TABLE IF EXISTS `translation_md5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translation_md5` (
  `translation_md5_id` int(11) NOT NULL AUTO_INCREMENT,
  `translation_md5` char(32) NOT NULL,
  PRIMARY KEY (`translation_md5_id`),
  UNIQUE KEY `md5_idx` (`translation_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translation_md5`
--

LOCK TABLES `translation_md5` WRITE;
/*!40000 ALTER TABLE `translation_md5` DISABLE KEYS */;
/*!40000 ALTER TABLE `translation_md5` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation`
--

DROP TABLE IF EXISTS `variation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation` (
  `variation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `ancestral_allele` varchar(255) DEFAULT NULL,
  `flipped` tinyint(1) unsigned DEFAULT NULL,
  `class_attrib_id` int(10) unsigned DEFAULT '0',
  `somatic` tinyint(1) NOT NULL DEFAULT '0',
  `minor_allele` varchar(50) DEFAULT NULL,
  `minor_allele_freq` float DEFAULT NULL,
  `minor_allele_count` int(10) unsigned DEFAULT NULL,
  `clinical_significance` set('uncertain significance','not provided','benign','likely benign','likely pathogenic','pathogenic','drug response','histocompatibility','other','confers sensitivity','risk factor','association','protective') DEFAULT NULL,
  `evidence_attribs` set('367','368','369','370','371','372','418','421','573','585') DEFAULT NULL,
  `display` int(1) DEFAULT '1',
  PRIMARY KEY (`variation_id`),
  UNIQUE KEY `name` (`name`),
  KEY `source_idx` (`source_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation`
--

LOCK TABLES `variation` WRITE;
/*!40000 ALTER TABLE `variation` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation_attrib`
--

DROP TABLE IF EXISTS `variation_attrib`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation_attrib` (
  `variation_id` int(11) unsigned NOT NULL,
  `attrib_id` int(11) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  KEY `variation_idx` (`variation_id`),
  KEY `attrib_value_idx` (`attrib_id`,`value`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation_attrib`
--

LOCK TABLES `variation_attrib` WRITE;
/*!40000 ALTER TABLE `variation_attrib` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation_attrib` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation_citation`
--

DROP TABLE IF EXISTS `variation_citation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation_citation` (
  `variation_id` int(10) unsigned NOT NULL,
  `publication_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`variation_id`,`publication_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation_citation`
--

LOCK TABLES `variation_citation` WRITE;
/*!40000 ALTER TABLE `variation_citation` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation_citation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation_feature`
--

DROP TABLE IF EXISTS `variation_feature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation_feature` (
  `variation_feature_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `seq_region_id` int(10) unsigned NOT NULL,
  `seq_region_start` int(11) NOT NULL,
  `seq_region_end` int(11) NOT NULL,
  `seq_region_strand` tinyint(4) NOT NULL,
  `variation_id` int(10) unsigned NOT NULL,
  `allele_string` varchar(50000) DEFAULT NULL,
  `variation_name` varchar(255) DEFAULT NULL,
  `map_weight` int(11) NOT NULL,
  `flags` set('genotyped') DEFAULT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `consequence_types` set('intergenic_variant','splice_acceptor_variant','splice_donor_variant','stop_lost','coding_sequence_variant','missense_variant','stop_gained','synonymous_variant','frameshift_variant','non_coding_transcript_variant','non_coding_transcript_exon_variant','mature_miRNA_variant','NMD_transcript_variant','5_prime_UTR_variant','3_prime_UTR_variant','incomplete_terminal_codon_variant','intron_variant','splice_region_variant','downstream_gene_variant','upstream_gene_variant','start_lost','stop_retained_variant','inframe_insertion','inframe_deletion','transcript_ablation','transcript_fusion','transcript_amplification','transcript_translocation','TFBS_ablation','TFBS_fusion','TFBS_amplification','TFBS_translocation','regulatory_region_ablation','regulatory_region_fusion','regulatory_region_amplification','regulatory_region_translocation','feature_elongation','feature_truncation','regulatory_region_variant','TF_binding_site_variant','protein_altering_variant','start_retained_variant') NOT NULL DEFAULT 'intergenic_variant',
  `variation_set_id` set('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64') NOT NULL DEFAULT '',
  `class_attrib_id` int(10) unsigned DEFAULT '0',
  `somatic` tinyint(1) NOT NULL DEFAULT '0',
  `minor_allele` varchar(50) DEFAULT NULL,
  `minor_allele_freq` float DEFAULT NULL,
  `minor_allele_count` int(10) unsigned DEFAULT NULL,
  `alignment_quality` double DEFAULT NULL,
  `evidence_attribs` set('367','368','369','370','371','372','418','421','573','585') DEFAULT NULL,
  `clinical_significance` set('uncertain significance','not provided','benign','likely benign','likely pathogenic','pathogenic','drug response','histocompatibility','other','confers sensitivity','risk factor','association','protective') DEFAULT NULL,
  `display` int(1) DEFAULT '1',
  PRIMARY KEY (`variation_feature_id`),
  KEY `pos_idx` (`seq_region_id`,`seq_region_start`,`seq_region_end`),
  KEY `variation_idx` (`variation_id`),
  KEY `variation_set_idx` (`variation_set_id`),
  KEY `consequence_type_idx` (`consequence_types`),
  KEY `source_idx` (`source_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation_feature`
--

LOCK TABLES `variation_feature` WRITE;
/*!40000 ALTER TABLE `variation_feature` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation_feature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation_genename`
--

DROP TABLE IF EXISTS `variation_genename`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation_genename` (
  `variation_id` int(10) unsigned NOT NULL,
  `gene_name` varchar(255) NOT NULL,
  PRIMARY KEY (`variation_id`,`gene_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation_genename`
--

LOCK TABLES `variation_genename` WRITE;
/*!40000 ALTER TABLE `variation_genename` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation_genename` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation_hgvs`
--

DROP TABLE IF EXISTS `variation_hgvs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation_hgvs` (
  `variation_id` int(10) unsigned NOT NULL,
  `hgvs_name` varchar(255) NOT NULL,
  PRIMARY KEY (`variation_id`,`hgvs_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation_hgvs`
--

LOCK TABLES `variation_hgvs` WRITE;
/*!40000 ALTER TABLE `variation_hgvs` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation_hgvs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation_set`
--

DROP TABLE IF EXISTS `variation_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation_set` (
  `variation_set_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `short_name_attrib_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`variation_set_id`),
  KEY `name_idx` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation_set`
--

LOCK TABLES `variation_set` WRITE;
/*!40000 ALTER TABLE `variation_set` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation_set_structural_variation`
--

DROP TABLE IF EXISTS `variation_set_structural_variation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation_set_structural_variation` (
  `structural_variation_id` int(10) unsigned NOT NULL,
  `variation_set_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`structural_variation_id`,`variation_set_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation_set_structural_variation`
--

LOCK TABLES `variation_set_structural_variation` WRITE;
/*!40000 ALTER TABLE `variation_set_structural_variation` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation_set_structural_variation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation_set_structure`
--

DROP TABLE IF EXISTS `variation_set_structure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation_set_structure` (
  `variation_set_super` int(10) unsigned NOT NULL,
  `variation_set_sub` int(10) unsigned NOT NULL,
  PRIMARY KEY (`variation_set_super`,`variation_set_sub`),
  KEY `sub_idx` (`variation_set_sub`,`variation_set_super`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation_set_structure`
--

LOCK TABLES `variation_set_structure` WRITE;
/*!40000 ALTER TABLE `variation_set_structure` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation_set_structure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation_set_variation`
--

DROP TABLE IF EXISTS `variation_set_variation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation_set_variation` (
  `variation_id` int(10) unsigned NOT NULL,
  `variation_set_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`variation_id`,`variation_set_id`),
  KEY `variation_set_idx` (`variation_set_id`,`variation_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation_set_variation`
--

LOCK TABLES `variation_set_variation` WRITE;
/*!40000 ALTER TABLE `variation_set_variation` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation_set_variation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variation_synonym`
--

DROP TABLE IF EXISTS `variation_synonym`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variation_synonym` (
  `variation_synonym_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `variation_id` int(10) unsigned NOT NULL,
  `subsnp_id` int(15) unsigned DEFAULT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`variation_synonym_id`),
  UNIQUE KEY `name_idx` (`name`,`source_id`,`variation_id`),
  KEY `variation_idx` (`variation_id`),
  KEY `subsnp_idx` (`subsnp_id`),
  KEY `source_idx` (`source_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variation_synonym`
--

LOCK TABLES `variation_synonym` WRITE;
/*!40000 ALTER TABLE `variation_synonym` DISABLE KEYS */;
/*!40000 ALTER TABLE `variation_synonym` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-08-10 11:20:06
