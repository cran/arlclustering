library(testthat)
#library(igraph)
#library(arules)
library (arlclustering)



test_that("arlc_gen_transactions returns a transactions object", {
  sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering") # Adjust as needed
  g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")

  # Check inputs
  expect_type(g$graph, "list")
  expect_s3_class(g$graph, "igraph")
  expect_equal(g$graphLabel, "Karate Club Network")
  expect_equal(g$totalNodes, vcount(g$graph))
  expect_equal(g$totalNodes, 34)
  expect_equal(g$totalEdges, gsize(g$graph))
  expect_equal(g$totalEdges, 78)
  expect_equal(g$averageDegree, mean(degree(g$graph)))
  expect_true(all(c("graph", "graphLabel", "totalNodes", "totalEdges", "averageDegree") %in% names(g)))


  # Run function
  trans <- arlc_gen_transactions(g$graph)
  expect_s4_class(trans, "transactions")
  expect_equal(length(trans), 28)
  # Check that the function runs without error for different inputs
  expect_error(arlc_gen_transactions(g$graph), NA)
})

test_that("arlc_gen_transactions handles an empty graph", {
  g <- make_empty_graph()
  expect_type(g, "list")

  trans <- arlc_gen_transactions(g)
  expect_s4_class(trans, "transactions")
  expect_equal(length(trans), 0)

})


