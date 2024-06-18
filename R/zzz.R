
#' @docType package
#'
#' @keywords internal package
#'
#' @aliases pbmc3k-package NULL
#'
'_PACKAGE'

#' PBMC 3k
#'
#' 2,700 peripheral blood mononuclear cells (PBMC) from 10X genomics; this is
#' effectively what one would get with
#' \code{\link[Seurat:Read10X]{Seurat::Read10X}()}
#'
#' @format A \code{\link[Matrix:dgCMatrix-class]{dgCMatrix}} with the raw,
#' unfiltered PBMC 3k counts
#'
#' @source \url{https://support.10xgenomics.com/single-cell-gene-expression/datasets/1.1.0/pbmc3k}
#'
#' @keywords datasets
#'
"pbmc3k"

#' Raw PBMC 3k Counts: \CRANpkg{Seurat} Edition
#'
#' @format A \code{\link[Matrix:dgCMatrix-class]{dgCMatrix}} with the raw,
#' filtered PBMC 3k counts
#'
#' @keywords datasets
#'
#' @inherit pbmc3k source
#'
#' @references \href{https://satijalab.org/seurat/articles/pbmc3k_tutorial}{Seurat PBMC 3k Guided Clustering Tutorial}
#'
#' @seealso
#' \code{\link[SeuratObject:CreateSeuratObject]{SeuratObject::CreateSeuratObject}()},
#' \code{\link[SeuratObject:CreateAssayObject]{SeuratObject::CreateAssayObject}()}
#'
#' @family seurat
#' @family raw
#'
"pbmc3k.seurat.counts"

#' Log-Normalized PBMC 3k: \CRANpkg{Seurat} Edition
#'
#' @format A \code{\link[Matrix:dgCMatrix-class]{dgCMatrix}} with the
#' log-normalized PBMC 3k counts
#'
#' @keywords datasets
#'
#' @inherit pbmc3k source
#'
#' @inherit pbmc3k.seurat.counts references
#'
#' @seealso \code{\link[Seurat:NormalizeData]{Seurat::NormalizeData}()}
#'
#' @family seurat
#' @family norm
#'
"pbmc3k.seurat.norm"

#' Log-Normalized PBMC 3k: \pkg{SingleCellExperiment} Edition
#'
#' @format A \code{\link[Matrix:dgCMatrix-class]{dgCMatrix}} with the
#' log-normalized PBMC 3k counts
#'
#' @inherit pbmc3k.seurat.norm format
#'
#' @keywords datasets
#'
#' @note There is not a raw, filtered matrix following a Bioconductor workflow
#' as \pkg{scuttle} does not filter the raw counts matrix in the same way that
#' \code{\link[SeuratObject:CreateSeuratObject]{SeuratObject::CreateSeuratObject}()} does
#'
#' @inherit pbmc3k source
#'
#' @references \href{https://bioconductor.org/books/3.17/OSCA.intro/analysis-overview.html}{Orchestrating Single-Cell Analysis with Bioconductor version 1.8.0}
#'
#' @seealso \code{\link[scuttle:perCellQCMetrics]{scuttle::perCellQCMetrics}()},
#' \code{\link[scuttle:quickPerCellQC]{scuttle::quickPerCellQC}()},
#' \code{\link[scuttle:perCellQCFilters]{scuttle::perCellQCFilters}()},
#' \code{\link[scuttle:isOutlier]{scuttle::isOutlier}()}
#'
#' @family sce
#' @family norm
#'
"pbmc3k.sce.logcounts"
