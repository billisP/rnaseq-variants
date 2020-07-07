


# START: THIS CODE CREATE multiHISTOGRAMs and used in the poster # 

library(vcfR)
library(ggplot2)
library(reshape)


vcf <- read.vcfR("/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA196229/SRR807412.fastq.gz.vcf.NC_007604.vcf", verbose = TRUE )
dna <- ape::read.dna("/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA196229//637000308.fna", format = "fasta")
dna2 <- dna[ grep( "NC_007604", names(dna) ) ]
dna2 <- as.matrix(dna2)

gff <- read.table("/Users/kbillis/google_drive/myProjects/auth/snp/data/637000308.gbk.gff", sep="\t", quote="") 
gff2 <- gff[grep("NC_007604", gff[,1]),]
gff3 <- gff2[grep("gene", gff2[,3]),]


# loop over many files: 
# files_path="/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA196229/"
# files_path="/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA404081/"
files_path="/Users/kbillis/google_drive/myProjects/auth/snp/data/vcf_files_308/vcf_chr_ONLY/"
only_files <- dir(path=files_path, pattern = "*NC_007604.vcf") 

# remove 2 condtions that we didn't use: 
only_files<-only_files[-c(5, 6)];

# make whole file path
files = paste(files_path, only_files, sep="")


mm<-NULL
for (i in 1:length(files) ){
  vcf <- read.vcfR(files[i], verbose = TRUE )
  chrom <- create.chromR(name='NC_007604', vcf=vcf, seq=dna2, ann=gff3)
  chrom <- proc.chromR(chrom, verbose = TRUE, win.size=20000)
  mat1 <- cbind(chrom@win.info[,'start'],
               0, 
               chrom@win.info[,'end'], 
               chrom@win.info[,'variants']
               )

  mat1<-data.frame(mat1)
  file_name_bars<-paste(only_files[i],"_b", sep="")
  print(file_name_bars)

  if (i ==1) {
    x<-cbind(mat1[,3])
    x<-cbind(x,mat1[,4])
    xnames<-c("break",file_name_bars)
    colnames(x)<-xnames
    mm<-x
  } else {
    colnames(mat1)[4] <- file_name_bars
    mm<-cbind(mm,mat1[,4,drop = FALSE])
  }  
}

# remove additional strings: 
colnames(mm)<-gsub("-sorted.bam_RMDUP.bam.raw.bcf.vcf.NC_007604.vcf_b", "", colnames(mm))
# colnames(mm)<-gsub(".fastq.gz.vcf.NC_007604.vcf_b", "", colnames(mm))

# metadata file with names-ids of the files:
metadata_file = "/Users/kbillis/google_drive/myProjects/auth/snp/metadata/cyano_sample_id_sample_name.txt"
metadata_hash <- read.table(metadata_file, sep=" ", quote="")

for (i in 2:length(colnames(mm)) ) {
  id<-as.name(colnames(mm)[i])
  print(id)
  print(metadata_hash[metadata_hash[,2]==id,1])
  if (metadata_hash[metadata_hash[,2]==id,1]) {
     name_data<-(metadata_hash[metadata_hash[,2]==id,1])
     colnames(mm)[i]<-as.character(name_data)
  } else {
     print("not found")
  }  
}

# order colnames:  
mm<-mm[,order(colnames(mm))]
df <- melt(mm, id.vars=c("break"), variable.name = "Samples", value.name="Values")

# basic
p <- ggplot(df, aes(df[,1],value)) + geom_line(aes(color= variable)) + facet_grid(variable ~ .)
print(p)
# colour based on condition
ph <- ggplot(df, aes(df[,1],value, fill=variable)) + geom_bar(stat="identity") + facet_grid(variable ~ .) 
# colour based the value (higher values different colours)
ph <- ggplot(df, aes(df[,1],value, colour=value)) + geom_bar(stat="identity") + facet_grid(variable ~ .) + scale_colour_gradientn(colours=rainbow(4))


# END: THIS CODE CREATE multiHISTOGRAMs and used in the poster # 




# START: make ven diagrams - the don't have scale: 
# file with names-ids of the files:
metadata_file = "/Users/kbillis/google_drive/myProjects/auth/snp/metadata/cyano_sample_id_sample_name.txt"
metadata_hash <- read.table(metadata_file, sep=" ", quote="")


snpLists<-list()
for (i in 1:length(files) ){
  vcf <- read.vcfR(files[i], verbose = TRUE )
  xx<-data.frame(vcf@fix[,2])

  names_tobe<-as.name(only_files[i])
  names_tobe<-gsub("-sorted.bam_RMDUP.bam.raw.bcf.vcf.NC_007604.vcf", "", names_tobe)
  
  print(names_tobe)
  if (metadata_hash[metadata_hash[,2]==names_tobe,1]) {
     name_data<-(metadata_hash[metadata_hash[,2]==names_tobe,1])
     print(as.character(name_data) ) 
  } else {
     print("not found")
  }  
  print(as.character(name_data) ) 

  DF <- data.frame(num=rep(name_data, dim(xx)[1]), stringsAsFactors=FALSE)
  xx<-cbind(xx,DF)

  if (i ==1) {
    mmVenn<-xx
  } else {
    mmVenn<-rbind(mmVenn,xx)    
  }
}

  
colnames(mmVenn)[1]<-"position"
colnames(mmVenn)[2]<-"condition"

# with venneuler
temp<-mmVenn[grep("Temp", mmVenn[,2]), ]
plot(venneuler(temp))
venneuler(temp)

# https://stackoverflow.com/questions/8713994/venn-diagram-proportional-and-color-shading-with-semi-transparency
# END: make ven diagrams - the don't have scale: 




# START: another way  ## THIS IS HOW I DID THEM: 
library(gridExtra)
library(vcfR)
library(VennDiagram)

files_path="/Users/kbillis/google_drive/myProjects/auth/snp/data/vcf_files_308/vcf_chr_ONLY/"
only_files <- dir(path=files_path, pattern = "*NC_007604.vcf") 


# file with names-ids of the files: 
metadata_file = "/Users/kbillis/google_drive/myProjects/auth/snp/metadata/cyano_sample_id_sample_name.txt"
metadata_hash <- read.table(metadata_file, sep=" ", quote="")

# remove 2 condtions that we didn't use: 
only_files<-only_files[-c(5, 6)];

# make whole file path
files = paste(files_path, only_files, sep="")


for (i in 1:length(files) ){
  vcf <- read.vcfR(files[i], verbose = TRUE )
  xx<-data.frame(vcf@fix[,2])

  names_tobe<-as.name(only_files[i])
  names_tobe<-gsub("-sorted.bam_RMDUP.bam.raw.bcf.vcf.NC_007604.vcf", "", names_tobe)
  
  print(names_tobe)
  if (metadata_hash[metadata_hash[,2]==names_tobe,1]) {
     name_data<-(metadata_hash[metadata_hash[,2]==names_tobe,1])
     print(as.character(name_data) ) 
  } else {
     print("not found")
  }  
  print(as.character(name_data) ) 

  DF <- data.frame(num=rep(name_data, dim(xx)[1]), stringsAsFactors=FALSE)
  xx<-cbind(xx,DF)

  if (i ==1) {
    mmVenn<-xx
  } else {
    mmVenn<-rbind(mmVenn,xx)    
  }
}


venn_plot_temperature <- venn.diagram(
x = list(
"24h" = as.vector(mmVenn[grep("Temp[^1]*$", mmVenn[,2]), 1]),
"1h" = as.vector(mmVenn[grep("Temp[^24]*$", mmVenn[,2]), 1])
),
filename = "Temperature.png",
 main = "Temperature",
 scaled = TRUE, cat.pos = c(220, 150), 
 ext.text = FALSE,
 ext.line.lwd = 0.1,
 ext.dist = 0.15,
 ext.length = 1,
 cex = 3.2,
 cat.cex = 1.8, cat.dist=0.05,
 fill = c("blue", "green"),
 main.cex = 3, rotation.degree=45, line=0.5, lty = "blank", ext.line.lty = "dashed", inverted = FALSE

);


venn_plot_salt <- venn.diagram(
x = list(
"24h" = as.vector(mmVenn[grep("NaCl[^1]*$", mmVenn[,2]), 1]),
"1h" = as.vector(mmVenn[grep("NaCl[^24]*$", mmVenn[,2]), 1])
),
filename = "Salt.png",
 main = "Salt",
 scaled = TRUE, cat.pos = c(220, 150), 
 ext.text = FALSE,
 ext.line.lwd = 0.1,
 ext.dist = 0.15,
 ext.length = 1,
 cex = 3.2,
 cat.cex = 1.8, cat.dist=0.05,
 fill = c("blue", "green"),
 main.cex = 3, rotation.degree=45, line=0.5, lty = "blank", ext.line.lty = "dashed", inverted = FALSE
);


venn_plot_CO <- venn.diagram(
x = list(
"24h" = as.vector(mmVenn[grep("CO2[^1]*$", mmVenn[,2]), 1]),
"1h" = as.vector(mmVenn[grep("CO2[^24]*$", mmVenn[,2]), 1])
),
filename = "CO2.png",
 main = "Carbon Dioxide",
 scaled = TRUE, cat.pos = c(150, 220), 
 ext.text = FALSE,
 ext.line.lwd = 0.1,
 ext.dist = 0.15,
 ext.length = 1,
 cex = 3.2,
 cat.cex = 1.8, cat.dist=0.05,
 fill = c("blue", "green"),
 main.cex = 3, rotation.degree=45, line=0.5, lty = "blank", ext.line.lty = "dashed", inverted = TRUE
);


venn_plot_pH <- venn.diagram(
x = list(
"24h" = as.vector(mmVenn[grep("pH[^1]*$", mmVenn[,2]), 1]),
"1h" = as.vector(mmVenn[grep("pH[^24]*$", mmVenn[,2]), 1])
),
filename = "ph.png",
 main = "pH",
 scaled = TRUE, cat.pos = c(150, 220), 
 ext.text = FALSE,
 ext.line.lwd = 0.1,
 ext.dist = 0.15,
 ext.length = 1,
 cex = 3.2,
 cat.cex = 1.8, cat.dist=0.05,
 fill = c("blue", "green"),
 main.cex = 3, rotation.degree=45, line=0.5, lty = "blank", ext.line.lty = "dashed", inverted = TRUE
);



venn_plot_light <- venn.diagram(
 x = list(
 "24h" = as.vector(mmVenn[grep("light[^1]*$", mmVenn[,2]), 1]),
 "1h" = as.vector(mmVenn[grep("light[^24]*$", mmVenn[,2]), 1])
 ),
 filename = "light.png",
 main = "Light",
 scaled = TRUE, cat.pos = c(220, 150), 
 ext.text = FALSE,
 ext.line.lwd = 0.1,
 ext.dist = 0.15,
 ext.length = 1,
 cex = 3.2,
 cat.cex = 1.8, cat.dist=0.05,
 fill = c("blue", "green"),
 main.cex = 3, rotation.degree=45, line=0.5, lty = "blank", ext.line.lty = "dashed", inverted = FALSE
 );

grid.arrange(gTree(children=venn_plot_temperature), gTree(children=venn_plot_salt), 
  gTree(children=venn_plot_light), gTree(children=venn_plot_pH), gTree(children=venn_plot_CO), ncol=5)

# END: another way for ven  ## THIS IS HOW I DID THEM: 




# START: DATA from others (Nikos' friends): 
# working dir: /Users/kbillis/google_drive/myProjects/auth/snp/data_from_others/
# only one chromosome: NC_004463.1

# START: another way  ## THIS IS HOW I DID THEM: 
library(gridExtra)
library(vcfR)
library(VennDiagram)

files_path="/Users/kbillis/google_drive/myProjects/auth/snp/data_from_others/"
only_files <- dir(path=files_path, pattern = "*.vcf$") 

# file with names-ids of the files: 
metadata_file = "/Users/kbillis/google_drive/myProjects/auth/snp/metadata/cyano_sample_id_sample_name.txt"
metadata_hash <- read.table(metadata_file, sep=" ", quote="")

dna <- ape::read.dna("/Users/kbillis/google_drive/myProjects/auth/snp/data_from_others/sequence.fasta", format = "fasta")
# dna2 <- as.matrix(dna2)


# make whole file path
files = paste(files_path, only_files, sep="")

mm<-NULL
for (i in 1:length(files) ){
  vcf <- read.vcfR(files[i], verbose = TRUE )
  chrom <- create.chromR(vcf=vcf)
  chrom <- create.chromR(name='NC_004463.1', vcf=vcf, seq=dna)
  chrom <- proc.chromR(chrom, verbose = TRUE, win.size=80000)

  mat1 <- cbind(chrom@win.info[,'start'],
               0, 
               chrom@win.info[,'end'], 
               chrom@win.info[,'variants']
               )

  mat1<-data.frame(mat1)
  
  # .fastq.gz.sam.bam-sorted_RMDUP.bam.raw.vcf

  file_name_bars<-gsub(".fastq.gz.sam.bam-sorted_RMDUP.bam.raw.vcf", "", only_files[i])
  print(file_name_bars)

  if (i ==1) {
    x<-cbind(mat1[,3])
    x<-cbind(x,mat1[,4])
    xnames<-c("break",file_name_bars)
    colnames(x)<-xnames
    mm<-x
  } else {
    colnames(mat1)[4] <- file_name_bars
    mm<-cbind(mm,mat1[,4,drop = FALSE])
  }  
}




for (i in 2:length(colnames(mm)) ) {
  id<-as.name(colnames(mm)[i])
  print(id)
  print(metadata_hash[metadata_hash[,2]==id,1])
  if (metadata_hash[metadata_hash[,2]==id,1]) {
     name_data<-(metadata_hash[metadata_hash[,2]==id,1])
     colnames(mm)[i]<-as.character(name_data)
  } else {
     print("not found")
  }  
}

mm_for_ggplot<-mm
rownames(mm)<-mm[,1]
mm<-mm[,-c(1)];

plot(x=NULL,   y=NULL, xlim=c(0, 50), ylim=c(0, 60)  )
points(mm[,5], col = "green", cex=1.4)
points(mm[,6], col = "green", cex=1.4)
points(mm[,4], col = "green", cex=1.4)
points(mm[,1], col = "red", cex=1.4, pch = 16)
points(mm[,2], col = "red", cex=1.4, pch = 16)
points(mm[,3], col = "red", cex=1.4, pch = 16)


plot(x=NULL,   y=NULL, xlim=c(0, 50), ylim=c(0, 60)  )

lines(mm[,5], col = "green", cex=1.4)
lines(mm[,6], col = "green", cex=1.4)
lines(mm[,4], col = "green", cex=1.4)
lines(mm[,1], col = "red", cex=1.4, pch = 16)
lines(mm[,2], col = "red", cex=1.4, pch = 16)
lines(mm[,3], col = "red", cex=1.4, pch = 16)



# gg+plot
melt_mm<-melt(mm_for_ggplot, id.vars = "break", measure.vars = c("C1", "C2","C3","T1","T2","T3" ) )
col<-as.character(c("variety","treatment","note"))
colnames(melt_mm)<-col



p<-ggplot(melt_mm, aes(x=variety, y=note, colour=treatment)) + 
    geom_boxplot() +
    facet_wrap(~variety, scale="free")

p + theme(axis.line=element_blank(),axis.text.x=element_blank(),
           axis.text.y= element_text(colour = "grey80", size = rel(0.1) ),
           axis.title.y=element_blank(), 
           strip.text = element_blank())

# END: DATA from others (Nikos' friends): 





























































###########################################
##### NOT NOT NOT USED ### JUST TESTING ###
###########################################

names<-colnames(table_to_change)
for (i in 1:length(names) ){
  com<-as.numeric(table_to_change[,i])
  histdata<-hist(as.numeric(table_to_change[com>0,i]), breaks=40, freq = TRUE, main=names[i])
  x <- cbind(histdata$breaks[2:length(histdata$breaks)])
  colnames(x)<-names[i]
  x<-melt(x, measure.vars = c(names[i]) )
  x <- cbind(x,histdata$counts)
  if (i ==1) {
    mm<-x
  } else {
    mm<-rbind(mm,x)    
  }
}

x<-c("x1","x2","x3","x4")
colnames(mm)<-x

require(ggplot2)    
p <- ggplot(data = mm, aes(x=x3)) 
p <- p + geom_histogram(aes(weights=x4, fill=x2))
p <- p + scale_fill_brewer(palette="Set3")
p <- p + facet_wrap( ~ x2, ncol=1)
P <- p+ theme_bw() # white background
p





# get max length and prepare a list 
max_bp=length(dna2)
result <- vector("list", max_bp) 

# paly
chrom <- create.chromR(name='NC_007604', vcf=vcf, seq=dna2, ann=gff3)
chrom <- proc.chromR(chrom, verbose = TRUE, win.size=200000)
mat1 <- cbind(chrom@win.info[,'start'],
               0, 
               chrom@win.info[,'end'], 
               chrom@win.info[,'variants']
               )
plot7 <- dr.plot( dmat = as.matrix( chrom@var.info[,c(2,3)] ), 
                    rlst = list(mat1), 
                    chrom.e = max_bp,
                    dcol=c(rgb(34,139,34, maxColorValue = 255),
                    rgb(0,206,209, maxColorValue = 255)) 
                    )




# try to create my method. No need for that. 
chromoqc_me <- function( chrom, 
                      boxp = TRUE, 
                      dp.alpha = 255,
                      ...){
  
  if( class(chrom) != "chromR" ){
    stop( paste("expecting an object of class chromR, got", class(chrom), "instead.") )
  }
  

  
  # Phred-Scaled Quality (QUAL)
  dmat <- as.matrix( cbind(chrom@var.info[,"POS"], 
                           as.numeric( chrom@vcf@fix[,"QUAL"] ) ) )
  dmat <- dmat[ chrom@var.info[,"mask"], , drop = FALSE]
  myList3 <- list(title = "Phred-Scaled Quality (QUAL)",
                  dmat  = dmat,
                  dcol  = grDevices::rgb(red=139, green=0, blue=139, alpha=dp.alpha, maxColorValue = 255),
                  bwcol = grDevices::rgb(red=139, green=0, blue=139, maxColorValue = 255)
  )
  
  chromo( chrom, boxp = boxp, 
#          chrom.e = chrom@len,
          # drlist1 = myList1,
          # drlist2 = myList2,
          drlist3 = myList3,
          ...
  )
}

#' 
#' The function \strong{gt2popsum} is called to create summaries of the variant data.
#' 
#' The function \strong{var.win} is called to create windowized summaries of the chromR object.
#' 
#' Each \strong{window} receives a \strong{name} and its coordinates.
#' Several attempts are made to name the windows appropriately.
#' First, the CHROM column of vcfR@fix is queried for a name.
#' Next, the label of the sequence is queried for a name.
#' Next, the first cell of the annotation matrix is queried.
#' If an appropriate name was not found in the above locations the chromR object's 'name' slot is used.
#' Note that the 'name' slot has a default value.
#' If this default value is not updated then all of your windows may receive the same name.
#' 
#' 

proc.chromR_me <- function(x, win.size = 1e3, verbose=TRUE){
  stopifnot(class(x) == "chromR")
  
  if( is.null( x@seq ) & verbose == TRUE ){
    warning( "seq slot is NULL." )
  }
  if( nrow(x@ann) == 0 & verbose == TRUE ){
    warning( "annotation slot has no rows." )
  }
  
  if(class(x@seq) == "DNAbin"){
    ptime <- system.time(x@seq.info$nuc.win <- seq2rects(x)) 
    if(verbose==TRUE){
      message("Nucleotide regions complete.")
      message(paste("  elapsed time: ", round(ptime[3], digits=4)))
    }
  } else if ( is.null( x@seq ) & verbose == TRUE ){
    warning( "seq slot is NULL, chromosome representation not made (seq2rects)." )
  }
  
  if(class(x@seq) == "DNAbin"){
    ptime <- system.time(x@seq.info$N.win <- seq2rects(x, chars="n")) 
    if(verbose==TRUE){
      message("N regions complete.")
      message(paste("  elapsed time: ", round(ptime[3], digits=4)))      
    }
  } else if ( is.null( x@seq ) & verbose == TRUE ){
    warning( "seq slot is NULL, chromosome representation not made (seq2rects, chars=n)." )
  }


 
  # Windowize variants.
#  if(nrow(x@vcf.gt[x@var.info$mask,])>0){
  if( nrow( x@vcf@fix[x@var.info$mask, , drop = FALSE ] ) > 0 ){
    ptime <- system.time(x@win.info <- .windowize_variants(windows=x@win.info, variants=x@var.info[c('POS','mask')]))
    if(verbose==TRUE){
#      print("windowize_variants complete.")
#      print(paste("  elapsed time: ", round(ptime[3], digits=4)))
      message("windowize_variants complete.")
      message(paste("  elapsed time: ", round(ptime[3], digits=4)))
    }
  } else {
    if( nrow(x@win.info) > 0 ){
      x@win.info$variants <- 0
    }
  }
  
  return(x)
}



##### ##### seq.info functions #####

#' @rdname proc_chromR
#' @export
#' @aliases regex.win
#' 
#acgt.win <- function(x, max.win=1000, regex="[acgtwsmkrybdhv]"){
regex.win <- function(x, max.win=1000, regex="[acgtwsmkrybdhv]"){
  # A DNAbin will store in a list when the fasta contains
  # multiple sequences, but as a matrix when the fasta
  # only contains one sequence.
  if(is.matrix(as.character(x@seq))){
    seq <- as.character(x@seq)[1:length(x@seq)]    
  }
  if(is.list(as.character(x@seq))){
    seq <- as.character(x@seq)[[1]]
  }
  # Subset to nucleotides of interest.
  seq <- grep(regex, seq, ignore.case=T, perl=TRUE)
  if(length(seq) == 0){
    return(matrix(NA, ncol=2))
  }
  #
  bp.windows <- matrix(NA, ncol=2, nrow=max.win)
  bp.windows[1,1] <- seq[1]
  i <- 1
  # Scroll through the sequence looking for 
  # gaps (nucledotides not in the regex).
  # When you find them make a window.
  # Sequences with no gaps will have no
  # windows.
  for(j in 2:length(seq)){
    if(seq[j]-seq[j-1] > 1){
      bp.windows[i,2] <- seq[j-1]
      i <- i+1
      bp.windows[i,1] <- seq[j]
    }
  }
  bp.windows[i,2] <- seq[j]
  if(i == 1){
    # If there is one row we get an integer.
    # We need a matrix.
    bp.windows <- bp.windows[1:i,]
    bp.windows <- matrix(bp.windows, ncol=2)
  } else {
    bp.windows <- bp.windows[1:i,]
  }
  #  x@acgt.w <- bp.windows
  #  return(x)
  return(bp.windows)
}


#' @rdname proc_chromR
#' @aliases seq2rects
#' 
#' @description
#' Create representation of a sequence.
#' Begining and end points are determined for stretches of nucleotides.
#' Stretches are determined by querying each nucleotides in a sequence to determine if it is represented in the database of characters (chars).
#' 
#' 
#' @param chars a vector of characters to be used as a database for inclusion in rectangles
#' @param lower converts the sequence and database to lower case, making the search case insensitive
#' 
#'   
#' @export
#' 
seq2rects <- function(x, chars="acgtwsmkrybdhv", lower=TRUE){

  if(is.matrix(as.character(x@seq))){
#    seq <- as.character(x@seq)[1:length(x@seq)]
    seq <- as.character(x@seq)[1,]
  }

  if(lower == TRUE){
    seq <- tolower(seq)
    chars <- tolower(chars)
  }

  rects <- .seq_to_rects(seq, targets=chars)
  return(rects)
}


#' @rdname proc_chromR
#' @export
#' @aliases var.win
#' 
#var.win <- function(x, win.size=1e3){
var.win <- function(x, win.size=1e3){
  # A DNAbin will store in a list when the fasta contains
  # multiple sequences, but as a matrix when the fasta
  # only contains one sequence.
  
  # Convert DNAbin to string of chars.
  if(class(x@seq) == "DNAbin"){
    if(is.matrix(as.character(x@seq))){
      seq <- as.character(x@seq)[1:length(x@seq)]    
    } else if(is.list(as.character(x@seq))){
      seq <- as.character(x@seq)[[1]]
    }
  }

  # Create a vector of 0 and 1 marking genic sites.
  if(nrow(x@ann) > 0){
    genic_sites <- rep(0, times=x@len)
    genic_sites[unlist(apply(x@ann[, 4:5], MARGIN=1, function(x){seq(from=x[1], to=x[2], by=1)}))] <- 1
  }
  
  # Initialize data.frame of windows.
  win.info <- seq(1, x@len, by=win.size)
  win.info <- cbind(win.info, c(win.info[-1]-1, x@len))
  win.info <- cbind(1:nrow(win.info), win.info)
  win.info <- cbind(win.info, win.info[,3]-win.info[,2]+1)
  #  win.info <- cbind(win.info, matrix(ncol=7, nrow=nrow(win.info)))

  # Declare a function to count nucleotide classes.
  win.proc <- function(y, seq){
    seq <- seq[y[2]:y[3]]
    a <- length(grep("[aA]", seq, perl=TRUE))
    c <- length(grep("[cC]", seq, perl=TRUE))
    g <- length(grep("[gG]", seq, perl=TRUE))
    t <- length(grep("[tT]", seq, perl=TRUE))
    n <- length(grep("[nN]", seq, perl=TRUE))
    o <- length(grep("[^aAcCgGtTnN]", seq, perl=TRUE))
    count <- sum(x@vcf.fix$POS[x@var.info$mask] >= y[2] & x@vcf.fix$POS[x@var.info$mask] <= y[3])
    genic <- sum(genic_sites[y[2]:y[3]])
    #
    c(a,c,g,t,n,o, count, genic)
  }
  
  # Implement function to count nucleotide classes.
  if(class(x@seq) == "DNAbin"){
    win.info <- cbind(win.info, t(apply(win.info, MARGIN=1, win.proc, seq=seq)))
    win.info <- as.data.frame(win.info)
    names(win.info) <- c('window','start','end','length','A','C','G','T','N','other','variants', 'genic')
  }
  
  win.info
}


