% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/beast.R, R/mega.R
\name{read.beast}
\alias{read.beast}
\alias{read.mrbayes}
\alias{read.beast.newick}
\alias{read.mega}
\title{read.beast}
\usage{
read.beast(file, threads = 1, verbose = FALSE)

read.mrbayes(file, threads = 1, verbose = FALSE)

read.beast.newick(file, threads = 1, verbose = FALSE)

read.mega(file, threads = 1, verbose = FALSE)
}
\arguments{
\item{file}{newick file}

\item{threads}{number of threads for multithreading (default: 1)}

\item{verbose}{set TRUE to log progress (default: FALSE)}
}
\value{
treedata object

treedata object
}
\description{
read beast/mrbayes/mega Nexus output

read beast/mrbayes/mega newick file format
}
\examples{
file <- system.file("extdata/BEAST", "beast_mcc.tree", package="treeio")
read.beast(file)
file <- system.file("extdata/MrBayes", "Gq_nxs.tre", package="treeio")
read.mrbayes(file)
tr <- read.beast.newick(
        textConnection(
          '(a[&rate=1]:2,(b[&rate=1.1]:1,c[&rate=0.9]:1)[&rate=1]:1);'
        )
)
}
\author{
Guangchuang Yu \url{https://guangchuangyu.github.io}

Bradley R Jones
}
