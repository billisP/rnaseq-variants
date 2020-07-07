#A. PREPARE HEATMAPs
#B. GROUP SAMPLES BY PROJECT ID 
#C. FIND vulnerable GENEs

# A. PREPARE HEATMAPs
### HEATMAP No 1 ###
library(gplots)

# only others data
data_original <- read.table("/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA_all_data/VEP_results/variations_PER_all_sample_all_gene_combinations.txt", sep="\t", quote="", header=FALSE)

# others and my data
data_original <- read.table("/Users/kbillis/google_drive/myProjects/auth/snp/scripts/rnaseq-variants/counts_per_sample_gene_all.tab", sep="\t", quote="", header=FALSE)

library(reshape2)
data_original_matrix<-dcast(data_original, data_original$V1 ~ data_original$V2)

rownames(data_original_matrix) <- data_original_matrix[,1]
data_original_matrix[,1] <- NULL

# https://stackoverflow.com/questions/22278508/how-to-add-colsidecolors-on-heatmap-2-after-performing-bi-clustering-row-and-co
# set the custom distance and clustering functions, per your example 
hclustfunc <- function(x) hclust(x, method="complete") 
distfunc <- function(x) dist(x, method="euclidean") 

# perform clustering on rows and columns 
cl.row <- hclustfunc(distfunc(data_original_matrix)) 
cl.col <- hclustfunc(distfunc(t(data_original_matrix)))

# find rows with only zeros  and without zeros
# zero_row <- data_original_matrix[rowSums(data_original_matrix) < 1, ]
# nonzero_row <- data_original_matrix[rowSums(data_original_matrix) > 0, ]

png("~/heatmaps_with_all.png",   width=5000,height=15000, res = 500        )
heatmap(as.matrix(data_original_matrix), cexRow=0.25, cexCol=0.25)
hclustfun=hclustfunc, distfun=distfunc)
dev.off()


# HEATMAP No 2
# source("https://bioconductor.org/biocLite.R")
# BiocManager::install(c("ComplexHeatmap"))
# https://bioc.ism.ac.jp/packages/3.8/bioc/manuals/ComplexHeatmap/man/ComplexHeatmap.pdf
library(ComplexHeatmap)

my_matrix<-as.matrix(data_original_matrix)

# data to use: 
my_matrix<-my_matrix[,64:2674]

Heatmap(my_matrix)

# We can split the heatmap into clusters with different colour (10 clusters) 
library(dendextend)
dend = hclust(dist( ,method="maximum"),method="ward.D")


fontsize=


Heatmap(my_matrix,
				        cluster_columns=FALSE,
				        row_names_side = "left",
				        row_dend_side = "left",
				        row_names_gp=gpar(cex=fontsize), column_names_gp=gpar(cex=fontsize), 
				        row_dend_width = unit(3, "cm"), 				        clustering_distance_rows ="maximum",
				        clustering_method_rows = "ward.D", cluster_rows = color_branches(dend, k = 10))





#B. GROUP SAMPLES BY PROJECT ID 

project_id_sample_id_metadata = "/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/project_id_AND_sample_id.tab"
metadata_hash <- read.table(project_id_sample_id_metadata, sep="\t", quote="", header=TRUE)

my_matrix_rownames<-rownames(my_matrix)

for (i in 1:length(my_matrix_rownames))  {
  id<-as.vector(my_matrix_rownames[i])
  print(id)
  name_data<-(metadata_hash[metadata_hash[,3]==id,1])
  print(name_data)
  if (!is.null(name_data)  & length(name_data)  ) {
     # name_data<-(metadata_hash[metadata_hash[,3]==id,1])
     my_matrix_rownames[i]<-as.vector(name_data)
  } else {
     print("not found")
  }  
}

# if I want to replace the the row names (sample names) with my_matrix_rownames (project ids)
rownames(my_matrix)<-my_matrix_rownames

# colors
library(RColorBrewer)
# view all paletes
# display.brewer.all()

# I want the reds: 
myCol <-brewer.pal(n = 8, name = "Reds")

Heatmap(my_matrix_ordered, col=myCol, 
				        cluster_columns=FALSE,
				        cluster_rows=FALSE,
				        row_names_side = "left",
				        row_dend_side = "left",
				        row_names_gp=gpar(cex=fontsize), column_names_gp=gpar(cex=fontsize),  				        
				        )




#C. FIND vulnerable GENEs of regions from other samples: 

### 1 action: 
# HERE ARE GENES: variations_PER_all_sample_all_gene_combinations.txt 
data_original <- read.table("/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA_all_data/VEP_results/variations_PER_all_sample_all_gene_combinations.txt", sep="\t", quote="", header=FALSE)
library(reshape2)
data_original_matrix<-dcast(data_original, data_original$V1 ~ data_original$V2)
# data_original <-as.data.frame(data_original) # if not
rownames(data_original_matrix) <- data_original_matrix[,1]
data_original_matrix[,1] <- NULL


# HERE ARE SNPs locations :
vars <- read.csv("/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA_all_data/VEP_results/vari_sour_feat_with_TRUE_FALSE_sort.tab", sep="\t", header = FALSE)
data_wide <- spread(vars, V1, V3 )
rownames(data_wide)<-data_wide[,1]
# remove 1 column
data_wide<-data_wide[,2:14078]
data_wide_T <-as.data.frame(data_wide_T)


### 2 action: 
# select group that you want to explore: 
WT_culture <-data_original_matrix[ , grepl( "WT culture" , names( data_original_matrix ) ) ]
SE01_snps <-data_original_matrix[ , grepl( "SE0" , names( data_original_matrix ) ) ]
replicate <-data_original_matrix[ , grepl( "wild type replicate" , names( data_original_matrix ) ) ]


### 3 action: 
# standard method after this point
my_matrix<-WT_culture  # WT_culture or SE01_snps or replicate or ....
my_matrix<-as.matrix(my_matrix)
rowSummary<-rowSums(my_matrix)

# only genes with variants 
my_matrix_var<-my_matrix[rowSummary>1,]

my_matrix_var<-t(my_matrix_var)
# those that they have more than 3 variants in total per row. IF I USE VARIANTS LOCATIONs this will be very very usefull. 
dim(my_matrix[rowSummary>3,])

fontsize=0.7

library(dendextend)
Heatmap(my_matrix_var,
				        cluster_columns=FALSE, cluster_rows=FALSE, 
				        row_names_side = "left",
				        row_dend_side = "left",
				        row_names_gp=gpar(cex=fontsize), column_names_gp=gpar(cex=fontsize), 
				        row_dend_width = unit(3, "cm") )










