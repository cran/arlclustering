#' Get Network Dataset
#'
#' This function loads a network dataset from a specified GML file and computes basic graph properties.
#'
#' @description This function reads a network dataset from a GML file, assigns node names, and calculates
#' various properties of the graph such as total edges, total nodes, and average degree.
#'
#' @param file_path The file path to the GML file to be loaded.
#' @param label A label for the graph.
#'
#' @return A list containing the graph object and its properties: total edges, total nodes, and average degree.
#'
#' @examples
#' \donttest{
#' # Create a sample transactions dataset
#' sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering")
#' loaded_karate <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
#' message(loaded_karate$graph)
#' message(loaded_karate$graphLabel)
#' message(loaded_karate$totalEdges)
#' message(loaded_karate$graphEdges)
#' message(loaded_karate$totalNodes)
#' message(loaded_karate$graphNodes)
#' message(loaded_karate$averageDegree)
#' }
#' @import igraph
#' @export

arlc_get_network_dataset <- function(file_path, label) {

    # Check if file exists and is readable
    if (!file.exists(file_path)) {
      stop("The network file does not exist: ", file_path)
    }
    if (file.access(file_path, 4) != 0) {
      stop("The network file is not readable: ", file_path)
    }

  # --------------------------------------------------------------------------------------
  # Attempt to read the GML file
  tryCatch({
    # Load the graph from the GML file
    graphG <- igraph::read_graph(file = file_path, format = "gml")

    # Assign names to the vertices
    graphG$names <- V(graphG)
    graphG$edges <- E(graphG)

    # Compute graph properties
    total_edges <- gsize(graphG)
    total_nodes <- vcount(graphG)
    average_degree <- mean(degree(graphG))

    # Create a label for the graph
    graph_label <- paste0(label, ' Network')

    # Return a list containing the graph and its properties
    return(list(
      graph = graphG,
      graphLabel = graph_label,
      totalNodes = as.integer(total_nodes),
      totalEdges = as.integer(total_edges),
      graphNodes = graphG$names,
      graphEdges = graphG$edges,
      averageDegree = average_degree
    ))
  }, error = function(e) {
    stop("Error in reading GML file: ", file_path, "\n", e$message)
  })
}
