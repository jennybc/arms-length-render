library(stringr)
library(plyr)

## hacky script to clean up, verbosely, in between render() attempts

## usually working directory will be src/ when this is called
jwd <- origwd <- getwd()
if(basename(jwd) == 'src') { setwd(".."); jwd <- getwd() }
if(basename(jwd) != 'arms-length-render') {
  stop("can't set project home directory as working directory")
}

## list and remove derived files
jfiles <- list.files(recursive = TRUE)
keep_regex <-
  c(".Rproj$", "README.md", "Makefile",
    "src/clean.r", "src/[a-z]+.rmd", "src/[a-z]+.r$")
keep_me <- laply(jfiles, function(x) any(str_detect(x, pattern = keep_regex)))
keep_files <- jfiles[keep_me]
remove_files <- setdiff(jfiles, keep_files)
keep_files
remove_files
message("removing files:\n", paste(remove_files, collapse = "\n"))
file.remove(remove_files)

## list and remove the now-empty directories
jdirs <- list.dirs()
jdirs <- jdirs[!str_detect(jdirs, "^\\./\\.")]
jdirs <- jdirs[!jdirs == "."]
keep_regex <- "src$"
keep_me <- laply(jdirs, function(x) any(str_detect(x, pattern = keep_regex)))
keep_dirs <- jdirs[keep_me]
remove_dirs <- rev(setdiff(jdirs, keep_dirs))
remove_dirs
message("removing directories:\n", paste(remove_dirs, collapse = "\n"))
file.remove(remove_dirs)

setwd(origwd)
