#' Get Transactional Dataset
#'
#' This function generates a transactional dataset from a graph.
#'
#' @param graph A graph object.
#'
#' @return A transactional dataset.
#'
#' @examples
#' \donttest{
#' library(arlclustering)
#' # Create a sample transactions dataset
#' sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering")
#' g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
#' trans <- arlc_gen_transactions(g$graph)
#' }
#' @importFrom igraph as_adjacency_matrix
#' @importFrom methods as
#' @export

arlc_gen_transactions <- function(graph) {
  if (!"igraph" %in% class(graph)) {
    stop("The input must be an igraph object.")
  }

  # Convert the graph to an adjacency matrix
  adjMat <- as.matrix(igraph::as_adjacency_matrix(graph))

  # Convert the adjacency matrix to transactions
  transactions_list <- apply(adjMat, 1, function(row) {
    nodes <- which(row == 1)
    if (length(nodes) > 1) {
      nodes
    } else {
      NULL
    }
  })

  # Remove NULL values
  transactions_list <- transactions_list[!sapply(transactions_list, is.null)]

  # Ensure transactions_list is a list
  transactions_list <- lapply(transactions_list, as.vector)

  # Remove duplicate transactions
  transunique <- unique(transactions_list)

  # Convert to a transactions object
  trx <- methods::as(transunique, "transactions")

  return(trx)
}
