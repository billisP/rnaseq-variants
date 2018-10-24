
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


# loop over many files: 
# files_path="/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA196229/"
files_path="/Users/kbillis/DATA_ANALYSIS_PHD/Synechococcus_elongatus_PCC_7942/PRJNA404081/"
only_files <- dir(path=files_path, pattern = "*NC_007604.vcf") 
files = paste(files_path, only_files, sep="")
# par(mfrow = c(1, length(files)))

for (i in 1:length(files) ){
  vcf <- read.vcfR(files[i], verbose = TRUE )
  chrom <- create.chromR(name='NC_007604', vcf=vcf, seq=dna2, ann=gff3)
  chrom <- proc.chromR(chrom, verbose = TRUE, win.size=50000)
  mat1 <- cbind(chrom@win.info[,'start'],
               0, 
               chrom@win.info[,'end'], 
               chrom@win.info[,'variants']
               )
  # plot7 <- dr.plot( dmat = as.matrix( chrom@var.info[,c(2,3)] ), 
  #                  rlst = list(mat1), 
  #                  chrom.e = max_bp,
  #                  dcol=c(rgb(34,139,34, maxColorValue = 255),
  #                  rgb(0,206,209, maxColorValue = 255)) 
  #                  )            
  # x<-melt(x)


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



df <- melt(mm, id.vars=c("break"), variable.name = "Samples", value.name="Values")
p <- ggplot(df, aes(df[,1],value)) + geom_line(aes(color= variable)) + facet_grid(variable ~ .)
print(p)





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


