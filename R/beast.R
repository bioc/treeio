##' read beast/mrbayes/mega Nexus output
##'
##'
##' @rdname beast-parser
##' @title read.beast
##' @param file beast file
##' @return treedata object
##' @importFrom ape read.nexus
##' @export
##' @author Guangchuang Yu \url{https://guangchuangyu.github.io}
##' @examples
##' file <- system.file("extdata/BEAST", "beast_mcc.tree", package="treeio")
##' read.beast(file)
read.beast <- function(file) {
    text <- readLines(file)

    treetext <- read.treetext_beast(text)
    stats <- read.stats_beast(text, treetext)
    phylo <- read.nexus(file)

    if (length(treetext) == 1) {
        obj <- BEAST(file, treetext, stats, phylo)
    } else {
        obj <- lapply(seq_along(treetext), function(i) {
            BEAST(file, treetext[i], stats[[i]], phylo[[i]])
        })
        names(obj) <- names(phylo)
        class(obj) <- "treedataList"
    }
    return(obj)
}


##' @rdname beast-parser
##' @export
##' @examples
##' file <- system.file("extdata/MrBayes", "Gq_nxs.tre", package="treeio")
##' read.mrbayes(file)
read.mrbayes <- read.beast

##' read beast/mrbayes/mega newick file format
##'
##'
##' @rdname beast-parser
##' @title read.beast.newick
##' @param file newick file
##' @return treedata object
##' @importFrom ape read.tree
##' @export
##' @author Bradley R Jones
##' @examples
##' tr <- read.beast.newick(
##'         textConnection(
##'           '(a[&rate=1]:2,(b[&rate=1.1]:1,c[&rate=0.9]:1)[&rate=1]:1);'
##'         )
##' )
read.beast.newick <- function(file) {
    text <- readLines(file)
    treetext <- text
    phylo <- read.tree(textConnection(treetext))

    stats <- if (length(treetext) == 1){
        read.stats_beast_internal(text, treetext)
    } else {
        lapply(treetext, read.stats_beast_internal, beast=text)
    }

    if (length(treetext) == 1) {
        obj <- BEAST(file, treetext, stats, phylo)
    } else {
        obj <- lapply(seq_along(treetext), function(i) {
            BEAST(file, treetext[i], stats[[i]], phylo[[i]])
        })
        class(obj) <- "treedataList"
    }
    return(obj)
}

#' @importFrom yulab.utils use_perl
BEAST <- function(file, treetext, stats, phylo) {
    stats$node <- gsub("\"*'*", "", stats$node, perl = use_perl())

    phylo <- remove_quote_in_tree_label(phylo)

    obj <- new("treedata",
               ## fields      = fields,
               treetext    = treetext,
               phylo       = phylo,
               data        = stats,
               file        = filename(file)
    )

    return(obj)
}

remove_quote_in_tree_label <- function(phylo) {
    if (!is.null(phylo$node.label)) {
        phylo$node.label <- gsub("\"*'*", "", phylo$node.label, perl = use_perl())
    }
    if ( !is.null(phylo$tip.label)) {
        phylo$tip.label <- gsub("\"*'*", "", phylo$tip.label, perl = use_perl())
    }
    return(phylo)
}


read.treetext_beast <- function(beast) {
    ii <- grep("begin trees;", beast, ignore.case = TRUE, perl = use_perl())
    jj <- grep("end;", beast, ignore.case = TRUE, perl = use_perl())
    jj <- jj[jj > max(ii)][1]
    jj <- c(ii[-1], jj)

    trees <- lapply(seq_along(ii), function(i) {
        tree <- beast[(ii[i]+1):(jj[i]-1)]
        tree <- tree[grep("^\\s*tree", tree, ignore.case = TRUE, perl = use_perl())]
        sub("[^(]*", "", tree)
    }) %>% unlist

    return(trees)
}

read.trans_beast <- function(beast) {
    i <- grep("TRANSLATE", beast, ignore.case = TRUE, perl = use_perl())
    if (length(i) == 0) {
        return(matrix())
    }
    end <- grep(";", beast, fixed = TRUE)
    j <- end[which(end > i)[1]]
    trans <- beast[(i+1):j] %>%
        gsub("^\\s+", "", ., perl = use_perl()) %>%
        gsub(",|;", "", ., perl = use_perl())
    trans <- trans[nzchar(trans)]
    ## remove quote if strings were quoted
    trans <- gsub("'|\"", "", trans, perl = use_perl())
    trans <- strsplit(trans, split="\\s+") %>%
        do.call(rbind, .)
    ## trans is a matrix
    return(trans)
}


read.stats_beast <- function(beast, trees) {
    if (length(trees) == 1) {
        return(read.stats_beast_internal(beast, trees))
    }
    lapply(trees, read.stats_beast_internal, beast=beast)
}



read.stats_beast_internal <- function(beast, text) {
    ##tree <- gsub(" ", "", tree)
    ## tree2 <- gsub("\\[[^\\[]*\\]", "", tree)
    ## phylo <- read.tree(text = tree2)
    ## tree2 <- add_pseudo_nodelabel(phylo, tree2)

    is_translated <- any(grepl("TRANSLATE", beast, ignore.case = TRUE, perl = use_perl()))

    phylo <- read.tree(text = text)
    tree2 <- add_pseudo_nodelabel(phylo, is_translated)

    ## node name corresponding to stats
    nn <- strsplit(tree2, split=",") %>% unlist %>%
        strsplit(., split="\\)") %>% unlist %>%
        gsub("\\(*", "", ., perl = use_perl()) %>%
        gsub("[:;].*", "", ., perl = use_perl()) %>%
        gsub(" ", "", ., perl = use_perl()) %>%
        gsub("'", "", ., perl = use_perl()) %>%
        gsub('"', "", ., perl = use_perl())

    phylo <- read.tree(text = tree2)
    root <- rootnode(phylo)
    nnode <- phylo$Nnode

    tree_label <- c(phylo$tip.label, phylo$node.label)
    ii <- match(nn, tree_label)


    if (is_translated == TRUE) {
        label2 <- c(phylo$tip.label, root:getNodeNum(phylo))
        ## label2 <- c(treeinfo[treeinfo$isTip, "label"], root:(root+nnode-1))
    } else {
        ## node <- as.character(treeinfo$node[match(nn, treeinfo$label)])
        label2 <- as.character(1:getNodeNum(phylo))
    }
    node <- label2[match(nn, tree_label)]

    ## stats <- unlist(strsplit(tree, "\\["))[-1]
    ## stats <- sub(":.+$", "", stats
    ## BEAST1 edge stat fix
   	text <- gsub("\\]:\\[&(.+?\\])", ",\\1:", text, perl = use_perl())
    # t1:[&mutation="test1"]0.04 -> t1[&mutation="test1"]:0.04
    text <- gsub(":(\\[.+?\\])", "\\1:", text, perl = use_perl())

    if (grepl("\\:[0-9\\.eEL+\\-]*\\[", text, perl = use_perl()) || grepl("\\]\\[", text, perl = use_perl())){
        # t1:0.04[&mutation="test1"] -> t1[&mutation="test1"]:0.04
        # or t1[&prob=100]:0.04[&mutation="test"] -> t1[&prob=100][&mutation="test"]:0.04 (MrBayes output)
        # pattern <- "(\\w+)?(:?\\d*\\.?\\d*[Ee]?[\\+\\-]?\\d*)?(\\[&.*?\\])"
        pattern <- "(\\w+)?(:[\\+\\-]?\\d*\\.?\\d*[Ee]?[\\+\\-]?\\L*\\d*)?(\\[&.*?\\])"
        text <- gsub(pattern, "\\1\\3\\2", text)  # not PCRE compatible
    }
    #if (grepl("\\]:[0-9\\.eE+\\-]*\\[", tree) || grepl("\\]\\[", tree)) {
    #    ## MrBayes output
    #    stats <- strsplit(tree, "\\]:[0-9\\.eE+\\-]*\\[") %>% unlist
    #    lstats <- lapply(stats, function(x) {
    #        unlist(strsplit(x, split="\\][,\\)]"))
    #    })
    #
    #    for (i in seq_along(stats)) {
    #        n <- length(lstats[[i]])
    #        if (i == length(stats)) {
    #            stats[i] <- lstats[[i]][n]
    #        } else {
    #            stats[i] <- paste0(lstats[[i]][n],
    #                               sub("&", ",", lstats[[i+1]][1])
    #            )
    #        }
    #    }
    #    stats <- gsub("\\]\\[&", ",", stats)
    #} else {
    #    ## BEAST output
    #    stats <- strsplit(tree, ":") %>% unlist
    #}
    stats <- strsplit(text, ":") %>% unlist
    names(stats) <- node

    stats <- stats[grep("\\[", stats, perl = use_perl())]
    stats <- sub("[^\\[]*\\[", "", stats, perl = use_perl())

    stats <- sub("^&", "", stats, perl = use_perl())
    # this is for MrBayes output
    stats <- sub("\\]\\[&", ",", stats, perl = use_perl())
    stats <- sub("];*$", "", stats, perl = use_perl())
    stats <- gsub("\"", "", stats, perl = use_perl())

    stats2 <- lapply(seq_along(stats), function(i) {
        x <- stats[[i]]
        y <- unlist(strsplit(x, ","))
        # the stats information does not has always {}
        #sidx <- grep("=\\{", y)
        #eidx <- grep("\\}$", y)
        # [&mutation="test1,test2",rate=80,90]
        sidx1 <- grep("=", y, fixed = TRUE)
        eidx1 <- sidx1 - 1
        eidx1 <- c(eidx1[-1], length(y))
        # for better parsing [&mutation="test",name="A"] single value to key.
        sidx <- sidx1[!(sidx1==eidx1)]
        eidx <- eidx1[!(sidx1==eidx1)]

        flag <- FALSE
        if (length(sidx) > 0) {
            flag <- TRUE
            SETS <- lapply(seq_along(sidx), function(k) {
                p <- y[sidx[k]:eidx[k]]
                gsub(".*=\\{", "", p, perl = use_perl()) %>%
                    gsub("\\}$", "", ., perl = use_perl()) %>%
                    gsub(".*=", "", ., perl = use_perl())
            })
            names(SETS) <- gsub("=.*", "", y[sidx], perl = use_perl())

            kk <- lapply(seq_along(sidx), function(k) {
                sidx[k]:eidx[k]
            }) %>%
                unlist
            y <- y[-kk]
        }

        if (length(y) == 0)
            return(SETS)

        name <- gsub("=.*", "", y, perl = use_perl())
        val <- gsub(".*=", "", y, perl = use_perl()) %>%
            gsub("^\\{", "", ., perl = use_perl()) %>%
            gsub("\\}$", "", ., perl = use_perl())

        if (flag) {
            nn <- c(name, names(SETS))
        } else {
            nn <- name
        }

        res <- rep(NA, length(nn))
        names(res) <- nn

        for (i in seq_along(name)) {
            res[i] <- if(is_numeric(val[i])) as.numeric(val[i]) else val[i]
        }
        if (flag) {
            j <- i
            for (i in seq_along(SETS)) {
                if(is_numeric(SETS[[i]])) {
                    res[i+j] <- list(as.numeric(SETS[[i]]))
                } else {
                    res[i+j] <- SETS[i]
                }
            }
        }

        return(res)
    })

    nn <- lapply(stats2, names) %>% unlist %>%
        unique %>% sort


    stats2 <- lapply(stats2, function(x) {
        y <- x[nn]
        names(y) <- nn
        y[vapply(y, is.null, logical(1))] <- NA
        y
    })

    stats3 <- do.call(rbind, stats2)
    stats3 <- as_tibble(stats3)

    ## no need to extract sd from prob+-sd
    ## as the sd is stored in prob_stddev
    ##
    ## "prob_stddev"   "prob(percent)" "prob+-sd"
    ##
    ##
    ##
    ## idx <- grep("\\+-", colnames(stats3))
    ## if (length(idx)) {
    ##     for (i in idx) {
    ##         stats3[,i] <- as.numeric(gsub("\\d+\\+-", "", stats3[,i]))
    ##     }
    ## }

    cn <- gsub("(\\d+)%", "0.\\1", colnames(stats3), perl = use_perl())
    cn <- gsub("\\(([^\\)]+)\\)", "_\\1", cn, perl = use_perl())
    ## cn <- gsub("\\+-", "_", cn)

    colnames(stats3) <- cn
    stats3$node <- names(stats)
    
    if (length(cn) > 0) {
        i <- vapply(stats3,
                    function(x) max(vapply(x, length, numeric(1))),
                    numeric(1))

        for (j in which(i==1)) {
            stats3[,j] <- unlist(stats3[,j])
        }
    }

    stats3$node <- as.integer(stats3$node)
    return(stats3)
}


add_pseudo_nodelabel <- function(phylo, translated=FALSE) {
    # When TRANSLATE is TRUE, the tip.label of tree line is
    # the node number of phylo that is parsed via read.nexus, So the
    # tip.label can not be replaced in this condition
    if (translated == TRUE) {
        phylo$node.label <- paste0("N", seq_len(Nnode(phylo)))
    } else {
        # However when TRANSLATE is not provided, the tip.label
        # of tree line is not the node number of phylo that is parsed
        # via read.nexus. Moreover, the node label does not affect
        # the node number of phylo that is parsed via read.nexus.
        # So the tip.label and node.label can be replaced in this condition.
        phylo$tip.label <- paste0("T", seq_len(Ntip(phylo)))
        phylo$node.label <- paste0("N", seq_len(Nnode(phylo)))
    }
    treetext <- write.tree(phylo)
    return(treetext)
}
