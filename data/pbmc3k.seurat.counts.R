
pbmc3k.seurat.counts <- local({
  callcheck <- 'resave_data_others' %in% unlist(lapply(
    X = sys.calls(),
    FUN = as.character
  ))
  if (!isTRUE(callcheck)) {
    return(NULL)
  }

  # Check required packages
  pkgcheck <- requireNamespace('rprojroot', quietly = TRUE) &&
    requireNamespace('Matrix', quietly = TRUE)
  if (!isTRUE(pkgcheck)) {
    return(NULL)
  }

  # Find our `data` directory
  data.dir <- rprojroot::find_package_root_file('data')
  if (!dir.exists(data.dir)) {
    return(NULL)
  }

  # Find the source file for the raw pbmc3k
  src <- Filter(
    f = file.exists,
    x = file.path(data.dir, sprintf('pbmc3k.%s', c('rda', 'R')))
  )
  if (!length(src)) {
    return(NULL)
  }

  # Load the source file, with preference given to the rda over the R script
  src <- src[1L]
  env <- new.env()
  pbmc3k <- switch(
    EXPR = tools::file_ext(src),
    R = {
      resave_data_others <- function(srcfile, envir) {
        sys.source(file = srcfile, envir = envir, chdir = TRUE)
        return(invisible(x = NULL))
      }
      resave_data_others(srcfile = src, envir = env)
      env$pbmc3k
    },
    rda = {
      load(file = src, envir = env, verbose = TRUE)
      env$pbmc3k
    }
  )

  # If pbmc3k was `NULL` for whatever reason, return `NULL`
  if (is.null(pbmc3k)) {
    return(NULL)
  }

  nfeatures <- Matrix::colSums(pbmc3k > 0L)
  pbmc3k <- pbmc3k[, which(nfeatures >= 200L)]

  ncells <- Matrix::rowSums(pbmc3k > 0L)
  pbmc3k <- pbmc3k[which(ncells >= 3L), ]

  pbmc3k
})
