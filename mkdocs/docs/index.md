---
html_preview: False
output:
  md_document:
    variant: markdown
---

treeio: Base classes and functions for parsing and exporting phylogenetic tree
==============================================================================

<!-- AddToAny BEGIN -->
<div class="a2a_kit a2a_kit_size_32 a2a_default_style">

<a class="a2a_dd" href="//www.addtoany.com/share"></a>
<a class="a2a_button_facebook"></a> <a class="a2a_button_twitter"></a>
<a class="a2a_button_google_plus"></a>
<a class="a2a_button_pinterest"></a> <a class="a2a_button_reddit"></a>
<a class="a2a_button_sina_weibo"></a> <a class="a2a_button_wechat"></a>
<a class="a2a_button_douban"></a>

</div>

<script async src="//static.addtoany.com/menu/page.js"></script>
<!-- AddToAny END -->
<img src="https://raw.githubusercontent.com/jotsetung/BioC-stickers/master/treeio/treeio.png" height="128", align="right" />

<link rel="stylesheet" href="https://guangchuangyu.github.io/css/font-awesome.min.css">
<link rel="stylesheet" href="https://guangchuangyu.github.io/css/academicons.min.css">

[![releaseVersion](https://img.shields.io/badge/release%20version-0.99.10-blue.svg?style=flat)](https://bioconductor.org/packages/treeio)
[![develVersion](https://img.shields.io/badge/devel%20version-0.99.11-blue.svg?style=flat)](https://github.com/guangchuangyu/treeio)
[![total](https://img.shields.io/badge/downloads-68/total-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/treeio)
[![month](https://img.shields.io/badge/downloads-35/month-blue.svg?style=flat)](https://bioconductor.org/packages/stats/bioc/treeio)

The `treeio` package defines classes and functions for parsing and
exporting phylogenetic trees. *treeio* is released within the
[Bioconductor](https://bioconductor.org/packages/treeio/) project and
the source code is hosted on
<a href="https://github.com/GuangchuangYu/treeio"><i class="fa fa-github fa-lg"></i>
GitHub</a>.

<i class="fa fa-user"></i> Authors
----------------------------------

Guangchuang Yu and Tommy Tsan-Yuk Lam, School of Public Health, The
University of Hong Kong.

<a href="https://twitter.com/guangchuangyu"><i class="fa fa-twitter fa-3x"></i></a>
<a href="https://guangchuangyu.github.io/blog_images/biobabble.jpg"><i class="fa fa-wechat fa-3x"></i></a>
<a href="https://www.ncbi.nlm.nih.gov/pubmed/?term=Guangchuang+Yu[Author+-+Full]"><i class="ai ai-pubmed ai-3x"></i></a>
<a href="https://scholar.google.com.hk/citations?user=DO5oG40AAAAJ&hl=en"><i class="ai ai-google-scholar ai-3x"></i></a>
<a href="https://orcid.org/0000-0002-6485-8781"><i class="ai ai-orcid ai-3x"></i></a>
<a href="https://impactstory.org/u/0000-0002-6485-8781"><i class="ai ai-impactstory ai-3x"></i></a>

<i class="fa fa-book"></i> Citation
-----------------------------------

`treeio` was splitted from `ggtree` package, please cite the following
article when using `treeio`:

[![doi](https://img.shields.io/badge/doi-10.1111/2041--210X.12628-blue.svg?style=flat)](http://dx.doi.org/10.1111/2041-210X.12628)
[![citation](https://img.shields.io/badge/cited%20by-8-blue.svg?style=flat)](https://scholar.google.com.hk/scholar?oi=bibs&hl=en&cites=7268358477862164627)
[![Altmetric](https://img.shields.io/badge/Altmetric-352-blue.svg?style=flat)](https://www.altmetric.com/details/10533079)

**G Yu**, DK Smith, H Zhu, Y Guan, TTY Lam<sup>\*</sup>. ggtree: an R
package for visualization and annotation of phylogenetic trees with
their covariates and other associated data. ***Methods in Ecology and
Evolution***. 2017, 8(1):28-36.

<!--
## <i class="fa fa-pencil"></i> Featured Articles

![](https://guangchuangyu.github.io/featured_img/ggtree/2015_peiyu_1-s2.0-S1567134815300721-gr1.jpg)

<i class="fa fa-hand-o-right"></i> Find out more on <i class="fa fa-pencil"></i> [Featured Articles](https://guangchuangyu.github.io/ggtree/featuredArticles/).

-->
<i class="fa fa-download"></i> Installation
-------------------------------------------

Install `treeio` is easy, follow the guide on the [Bioconductor
page](https://bioconductor.org/packages/treeio/):

``` {.r}
## try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
## biocLite("BiocUpgrade") ## you may need this
biocLite("treeio")
```

<!-- If you have problems when installing some of the dependent packages, please refer to the [ggtree-installation](https://github.com/GuangchuangYu/ggtree/wiki/ggtree-installation) wiki page.
-->
<i class="fa fa-cogs"></i> Overview
-----------------------------------

#### <i class="fa fa-angle-double-right"></i> Supported tree format:

-   Newick
-   NEXUS
-   New Hampshire eXtended format (NHX)
-   Jplace
-   Phylip

#### <i class="fa fa-angle-double-right"></i> Supported software output:

-   BEAST
-   EPA
-   HYPHY
-   MrBayes
-   PHYLODOG
-   phyloT
-   pplacer
-   r8s
-   RAxML
-   RevBayes

#### <i class="fa fa-angle-double-right"></i> Tree manipulation

-   `merge_tree` for merging evolutionary evidences inferred from
    different phylogenetic analyses

<i class="fa fa-hand-o-right"></i> Find out details and examples on
<i class="fa fa-book"></i>
[Documentation](https://guangchuangyu.github.io/treeio/documentation/).

<i class="fa fa-code-fork"></i> Projects that depend on *treeio*
----------------------------------------------------------------

#### <i class="fa fa-angle-double-right"></i> CRAN packages

-   [harrietr](https://cran.r-project.org/package=harrietr): Wrangle
    Phylogenetic Distance Matrices and Other Utilities

#### <i class="fa fa-angle-double-right"></i> Bioconductor packages

-   [LINC](https://www.bioconductor.org/packages/LINC): co-expression of
    lincRNAs and protein-coding genes
-   [philr](https://www.bioconductor.org/packages/philr): Phylogenetic
    partitioning based ILR transform for metagenomics data

<i class="fa fa-comments"></i> Feedback
---------------------------------------

<ul class="fa-ul">
    <li><i class="fa-li fa fa-hand-o-right"></i> Please make sure you have followed <a href="https://guangchuangyu.github.io/2016/07/how-to-bug-author/"><strong>the important guide</strong></a> before posting any issue/question</li>
    <li><i class="fa-li fa fa-bug"></i> For bugs or feature requests, please post to <i class="fa fa-github-alt"></i> <a href="https://github.com/GuangchuangYu/treeio/issues">github issue</a></li>
    <li><i class="fa-li fa fa-question"></i>  For user questions, please post to <i class="fa fa-google"></i> <a href="https://groups.google.com/forum/#!forum/bioc-treeio">google group</a></li>
    <li><i class="fa-li fa fa-support"></i> We are also following every post tagged with <strong>treeio</strong> on <a href="https://support.bioconductor.org">Bioconductor support site</a> and <a href="https://www.biostars.org">Biostars</a></li>
    <li><i class="fa-li fa fa-commenting"></i> Join the group chat on <a href="https://twitter.com/hashtag/treeio"><i class="fa fa-twitter fa-lg"></i></a> and <a href="http://huati.weibo.com/k/treeio"><i class="fa fa-weibo fa-lg"></i></a></li>

</ul>