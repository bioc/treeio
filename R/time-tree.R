##' read timetree output
##'
##' @rdname treetime
##' @title read.timetree
##' @param file the output tree file of timetree
##' @return treedata object
##' @export
read.treetime <- function(file) {
    con <- readLines(file)
    con <- sub("(\\[)\\\\\\[(.*)\\\\\\](\\])", "\\1\\2\\3", con) 

    f <- tempfile()
    writeLines(con, f)
    x <- read.beast(f)
    x@file <- file
    return(x)
}

##' @rdname treetime
read.timetree <- function(file) {
    message("Please use `read.treetime() instead. The `read.timetree()` function may be removed in future version.\n")
    read.treetime(file)
}

