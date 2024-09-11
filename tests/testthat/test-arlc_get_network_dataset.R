# Load the required packages
library(testthat)
#library(igraph)
library(arlclustering)  # Adjust the package name as needed



# Test cases for arlc_get_network_dataset
test_that("arlc_get_network_dataset loads the graph and computes properties correctly", {
  # Define the path to a sample GML file for testing
  sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering") # Adjust as needed

  # Skip test if the sample GML file is not available
  skip_if_not(file.exists(sample_gml_file), "Sample GML file not found")

  # Call the function with a valid GML file
  g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")

  # Check if the result is a list
  expect_type(g, "list")
  expect_type(g$graphLabel, "character")
  expect_type(g$totalNodes, "integer")
  expect_type(g$totalEdges, "integer")
  expect_type(g$averageDegree, "double")

  # Check if the graph object is of class igraph
  expect_s3_class(g$graph, "igraph")


  # Check if the graph label is correct
  expect_equal(g$graphLabel, "Karate Club Network")

  # Check if the total nodes are correct
  expect_equal(g$totalNodes, vcount(g$graph))
  expect_equal(g$totalNodes, 34)

  # Check if the total edges are correct
  expect_equal(g$totalEdges, gsize(g$graph))
  expect_equal(g$totalEdges, 78)

  # Check if the average degree is correct
  expect_equal(g$averageDegree, mean(degree(g$graph)))

  # Test that the list contains the correct elements
  expect_true(all(c("graph", "graphLabel", "totalNodes", "totalEdges", "averageDegree") %in% names(g)))

  # Check that the function runs without error for different inputs
  expect_error(arlc_get_network_dataset(sample_gml_file, "Karate Club"), NA)
})

