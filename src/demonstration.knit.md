

```r
library(rmarkdown)
```


### Directory structure of a toy project
PROJDIR: top-level directory = RStudio project = git repo

  * `src`: holds R and Rmd source
  * `html-xxx`: holds resulting Markdown and HTML files, possibly in subdirectories
  * in real life, there would be sister directories for data, results, etc.  
  
We will render `PROJDIR/src/foo.rmd`, which holds the default RStudio new R Markdown file. 

When rendering the stuff in `src/`, the working directory will be `src/`.  


```r
sessionInfo()
```

```
## R version 3.1.0 (2014-04-10)
## Platform: x86_64-apple-darwin10.8.0 (64-bit)
## 
## locale:
## [1] en_CA.UTF-8/en_CA.UTF-8/en_CA.UTF-8/C/en_CA.UTF-8/en_CA.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
## [1] plyr_1.8.1       stringr_0.6.2    rmarkdown_0.2.46
## 
## loaded via a namespace (and not attached):
## [1] digest_0.6.4    evaluate_0.5.5  formatR_0.10    htmltools_0.2.4
## [5] knitr_1.6       methods_3.1.0   Rcpp_0.11.1     tools_3.1.0
```

### Plain vanilla, *in situ* render
Of course this works.


```r
render('foo.rmd', quiet = TRUE)
source('clean.r')
```

```
## removing files:
## src/foo.html
## removing directories:
```

### `output_dir` != working directory
This works.


```r
render('foo.rmd', quiet = TRUE, output_dir = '../html-high')
source('clean.r')
```

```
## removing files:
## html-high/foo.html
## removing directories:
## ./html-high
```

### `output_dir` != working directory AND is at different level of file hierarchy
This works.


```r
dir.create('../html-high/')
render('foo.rmd', quiet = TRUE, output_dir = '../html-high/html-low')
source('clean.r')
```

```
## removing files:
## html-high/html-low/foo.html
## removing directories:
## ./html-high/html-low
## ./html-high
```

### `intermediates_dir` != working directory
__Does not work.__


```r
## not run because causes fatal pandoc error
# pandoc: Could not find data file ./foo_files/figure-html/cars-plot.png
# Error: pandoc document conversion failed with error 97
#render('foo.rmd', quiet = TRUE, intermediates_dir = '../html-high')
source('clean.r')
```

```
## removing files:
## 
## removing directories:
```

### Equate `output_dir` and `intermediates_dir` to distinct directory, at same level in hierarchy
This works for the wrong reason. Since the common directory for output and intermediates is at the same level in hierarchy as the source directory, the incorrect relative paths in `pandoc_conver()` just happen to work out.


```r
common_dir <- '../html-high'
render('foo.rmd', quiet = TRUE,
       output_dir = common_dir, intermediates_dir = common_dir)
source('clean.r')
```

```
## removing files:
## html-high/foo.html
## removing directories:
## ./html-high
```

### Equate `output_dir` and `intermediates_dir` to distinct, lower-in hierarchy directory
__Does not work.__


```r
dir.create('../html-high/')
common_dir <- '../html-high/html-low'
## not run because causes fatal pandoc error:
# pandoc: ../html-high/html-low/foo.utf8.md: openFile: does not exist (No such file or directory)
# Error: pandoc document conversion failed with error 1
# render('foo.rmd', quiet = TRUE,
#        output_dir = common_dir, intermediates_dir = common_dir)
source('clean.r')
```

```
## removing files:
## 
## removing directories:
## ./html-high
```


---
title: "demonstration.r"
author: "jenny"
date: "Wed Jun 11 16:25:29 2014"
---
