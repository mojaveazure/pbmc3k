
pbmc3k <- local({
  # Check that we're running during package build
  callcheck <- "resave_data_others" %in% unlist(x = lapply(
    X = sys.calls(),
    FUN = as.character
  ))
  if (!isTRUE(callcheck)) {
    return(NULL)
  }

  # Check required packages
  if (!requireNamespace("Matrix", quietly = TRUE)) {
    return(NULL)
  }

  # Download the raw data from 10x
  tmpdir <- tempfile(pattern = "pbmc3k")
  dir.create(tmpdir, showWarnings = FALSE, recursive = TRUE)
  on.exit(unlink(tmpdir, recursive = TRUE, force = TRUE))

  url <- "http://cf.10xgenomics.com/samples/cell-exp/1.1.0/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz"
  dest <- file.path(tmpdir, basename(url))
  utils::download.file(url = url, destfile = dest)
  utils::untar(tarfile = dest, exdir = tmpdir)

  # Read in the raw counts matrix, cell barcodes, and feature names
  ddir <- file.path(tmpdir, "filtered_gene_bc_matrices", "hg19")
  features <- read.table(file.path(ddir, "genes.tsv"))
  features[, 2L] <- make.unique(gsub(
    pattern = "_",
    replacement = "-",
    x = features[, 2L]
  ))
  row.names(features) <- features[, 2L]
  mat <- methods::as(
    Matrix::readMM(file.path(ddir, "matrix.mtx")),
    Class = "CsparseMatrix"
  )
  dimnames(mat) <- list(
    features[, 2L],
    gsub(
      pattern = "-1$",
      replacement = "",
      x = read.table(file.path(ddir, "barcodes.tsv"))[, 1L]
    )
  )
  mat
})
