library(rmarkdown)

#+ include = FALSE
source('clean.r')

#' ### Directory structure of a toy project
#' PROJDIR: top-level directory = RStudio project = git repo
#' 
#'   * `src`: holds R and Rmd source
#'   * `html-xxx`: holds resulting Markdown and HTML files, possibly in subdirectories
#'   * in real life, there would be sister directories for data, results, etc.  
#'   
#' We will render `PROJDIR/src/foo.rmd`, which holds the default RStudio new R Markdown file. 
#' 
#' When rendering the stuff in `src/`, the working directory will be `src/`.  

sessionInfo()

#' ### Plain vanilla, *in situ* render
#' Of course this works.
#+ warning = FALSE
render('foo.rmd', quiet = TRUE)
source('clean.r')

#' ### `output_dir` != working directory
#' This works.
#+ warning = FALSE
render('foo.rmd', quiet = TRUE, output_dir = '../html-high')
source('clean.r')

#' ### `output_dir` != working directory AND is at different level of file hierarchy
#' This works.
#+ warning = FALSE
dir.create('../html-high/')
render('foo.rmd', quiet = TRUE, output_dir = '../html-high/html-low')
source('clean.r')

#' ### `intermediates_dir` != working directory
#' __Does not work.__
#+ warning = FALSE
## not run because causes fatal pandoc error
# pandoc: Could not find data file ./foo_files/figure-html/cars-plot.png
# Error: pandoc document conversion failed with error 97
#render('foo.rmd', quiet = TRUE, intermediates_dir = '../html-high')
source('clean.r')

#' ### Equate `output_dir` and `intermediates_dir` to distinct directory, at same level in hierarchy
#' This works for the wrong reason. Since the common directory for output and intermediates is at the same level in hierarchy as the source directory, the incorrect relative paths in `pandoc_convert()` just happen to work out.
#+ warning = FALSE
common_dir <- '../html-high'
render('foo.rmd', quiet = TRUE,
       output_dir = common_dir, intermediates_dir = common_dir)
source('clean.r')

#' ### Equate `output_dir` and `intermediates_dir` to distinct, lower-in hierarchy directory
#' __Does not work.__
#+ warning = FALSE
dir.create('../html-high/')
common_dir <- '../html-high/html-low'
## not run because causes fatal pandoc error:
# pandoc: ../html-high/html-low/foo.utf8.md: openFile: does not exist (No such file or directory)
# Error: pandoc document conversion failed with error 1
# render('foo.rmd', quiet = TRUE,
#        output_dir = common_dir, intermediates_dir = common_dir)
source('clean.r')