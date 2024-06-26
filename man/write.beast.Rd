% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write-beast.R
\name{write.beast}
\alias{write.beast}
\title{write.beast}
\usage{
write.beast(treedata, file = "", translate = TRUE, tree.name = NULL)
}
\arguments{
\item{treedata}{\code{treedata} object, list of \code{treedata}, \code{phylo}, or list of \code{phylo}}

\item{file}{output file. If file = "", print the output content on screen}

\item{translate}{whether to translate taxa labels}

\item{tree.name}{names of the trees, NULL to use existing tree names}
}
\value{
output file or file content on screen
}
\description{
Export \code{treedata} object to BEAST NEXUS file. This function was adopted and modified from ape::write.nexus
}
\examples{
nhxfile <- system.file("extdata/NHX", "phyldog.nhx", package="treeio")
nhx <- read.nhx(nhxfile)
write.beast(nhx)
}
\author{
Guangchuang Yu
}
