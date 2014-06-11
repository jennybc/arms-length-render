Simple repo to demonstrate path problems with `render()` in `rmarkdown_0.2.46`, when using the `output_dir` and `intermediates_dir` arguments to put derived files somewhere *other* than where the input lives.

See [Makefile.md](Makefile.md) for a demonstration of how things break down.

What I think is wrong:

  * [Around here in `pandoc.R`](https://github.com/rstudio/rmarkdown/blob/master/R/pandoc.R#L55-58), in the definition of `pandoc_convert()`, the working directory is set to that of `input`, which at this point is already an intermediate file, e.g. `foo.utf8.md`.
  * But this intermediate file is still specified *relative to the original working directory*, which I suspect will always be the directory of the source file. Similar issue for the output file. Example when sending intermediates and output to same place, distinct from source file's directory:
    - source: `PROJDIR/src/foo.rmd`
    - working directory when `render()` is called: `PROJDIR/src/`
    - desired directory for results Markdown and HTML files: `PROJDIR/html-high/html-low`
    - value of `utf8_input` in `render()` and `input` in `pandoc_convert()`: `../html-high/html-low/foo.utf8.md`
    - value of `pandoc_to` in `render()` and `output` in `pandoc_convert()`: `../html-high/html-low/foo.utf8.html`
  * The pandoc arguments are then built up including these paths that are relative to the wrong working directory and fatal errors ensue re: various files not being found / existing. Inside `pandoc_convert()`, the `input` and `output` arguments need to be processed so that they are correct relative to the current working directory, which I suspect will always be the `intermediates` directory, since it's based on `input`.

