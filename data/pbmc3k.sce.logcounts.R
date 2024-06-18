
pbmc3k.sce.logcounts <- local({
  callcheck <- 'resave_data_others' %in% unlist(lapply(
    X = sys.calls(),
    FUN = as.character
  ))
  if (!isTRUE(callcheck)) {
    return(NULL)
  }

  # Check required packages
  pkgcheck <- requireNamespace('rprojroot', quietly = TRUE) &&
    requireNamespace("stats", quietly = TRUE) &&
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

  mt <- grep(pattern = "^MT-", x = rownames(pbmc3k))

  nCount <- Matrix::colSums(pbmc3k)
  nFeature <- Matrix::colSums(pbmc3k > 0L)
  percentMT <- Matrix::colSums(pbmc3k[mt, , drop = FALSE]) / nCount * 100L

  outliers <- sapply(
    X = list(nCount = nCount, nFeature = nFeature),
    FUN = function(x) {
      x <- log2(x)
      med <- stats::median(x = x)
      mad <- stats::mad(x = x, center = med)
      return(x < med - (3L * mad))
    },
    simplify = FALSE,
    USE.NAMES = TRUE
  )
  outliers$percentMT <- local({
    med <- stats::median(percentMT)
    mad <- stats::mad(percentMT, center = med)
    med + (3L * mad) < percentMT
  })

  discard <- Reduce(f = `|`, x = outliers)
  pbmc3k[, !discard]
})
