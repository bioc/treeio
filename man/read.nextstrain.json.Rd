% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nextstrain.json.R
\name{read.nextstrain.json}
\alias{read.nextstrain.json}
\title{read.nextstrain.json}
\usage{
read.nextstrain.json(x)
}
\arguments{
\item{x}{the json tree file of auspice from nextstrain.}
}
\value{
treedata object
}
\description{
read.nextstrain.json
}
\examples{
file1 <- system.file("extdata/nextstrain.json", "minimal_v2.json", package="treeio") 
tr <- read.nextstrain.json(file1)
tr
}
\author{
Shuangbin Xu
}
