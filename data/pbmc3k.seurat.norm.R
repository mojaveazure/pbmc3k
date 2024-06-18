
pbmc3k.seurat.norm <- local({
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

  # Find the source file for the raw pbmc3k.seurat.counts
  src <- Filter(
    f = file.exists,
    x = file.path(
      data.dir,
      sprintf('pbmc3k.seurat.counts.%s', c('rda', 'R'))
    )
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
        return(invisible(NULL))
      }
      resave_data_others(srcfile = src, envir = env)
      env$pbmc3k.seurat.counts
    },
    rda = {
      load(file = src, envir = env, verbose = TRUE)
      env$pbmc3k.seurat.counts
    }
  )

  # If pbmc3k.seurat.counts was `NULL` for whatever reason, return `NULL`
  if (is.null(pbmc3k)) {
    return(NULL)
  }

  nCount <- Matrix::colSums(pbmc3k)
  nFeature <- Matrix::colSums(pbmc3k > 0L)
  mt <- grep(pattern = '^MT-', x = rownames(pbmc3k))
  percentMT <- Matrix::colSums(pbmc3k[mt, , drop = FALSE]) / nCount * 100

  pbmc3k <- pbmc3k[, nFeature > 200L & nFeature < 2500L & percentMT < 5L]

  # Normalize pbmc3k
  p <- pbmc3k@p + 1L
  np <- length(p)
  if (requireNamespace('utils', quietly = TRUE)) {
    pb <- utils::txtProgressBar(max = np, file = stderr(), style = 3L)
  }
  for (i in seq_len(np)) {
    if (i == np) {
      break
    }
    start <- p[i]
    end <- p[i + 1L] - 1L
    x <- pbmc3k@x[start:end]
    pbmc3k@x[start:end] <- log1p(x / sum(x) * 10000)
    if (requireNamespace('utils', quietly = TRUE)) {
      utils::setTxtProgressBar(pb, i)
    }
  }

  if (requireNamespace('utils', quietly = TRUE)) {
    close(pb)
  }

  pbmc3k

})
