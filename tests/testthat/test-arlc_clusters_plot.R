# test_arlc_clusters_plot.R

library(testthat)
library(arlclustering)



test_that("arlc_clusters_plot plots: generates a set of communities", {
  # Load example data
  sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering") # Adjust as needed
  g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
  trans <- arlc_gen_transactions(g$graph)
  # Define support and confidence ranges
  supportRange <- seq(0.1, 0.2, by = 0.1)
  Conf <- 0.5
  # Getting parameters
  capture.output({ params <-arlc_get_apriori_thresholds(trans, supportRange, Conf) })
  capture.output({ grossRules <- arlc_gen_gross_rules(trans, params$minSupp, params$minConf, 1, params$lenRules) })
  capture.output({ nonRR_rules <- arlc_get_NonR_rules(grossRules$GrossRules)})
  capture.output({ NonRRSig_rules <- arlc_get_significant_rules(trans, nonRR_rules$FiltredRules)})
  capture.output({ cleaned_rules <- arlc_clean_final_rules(NonRRSig_rules$FiltredRules)})
  capture.output({ clusters <- arlc_generate_clusters(cleaned_rules)})

  # Checking inputs
  expect_type(g$graph, "list")
  expect_s3_class(g$graph, "igraph")
  expect_equal(g$graphLabel, "Karate Club Network")
  expect_equal(g$totalNodes, vcount(g$graph))
  expect_equal(g$totalNodes, 34)
  expect_equal(g$totalEdges, gsize(g$graph))
  expect_equal(g$totalEdges, 78)
  expect_equal(g$averageDegree, mean(degree(g$graph)))
  expect_true(all(c("graph", "graphLabel", "totalNodes", "totalEdges", "averageDegree") %in% names(g)))

  # Run the function

  # Capture the console output
  capture.output(suppressMessages({ output <- arlc_clusters_plot(g$graph, "Karate Club", clusters$Clusters) }))

  # Checking the output :
  expect_true(length(output) > 0)

  # Check that clusters is a list
  expect_true(is.list(clusters$Clusters))

  # Check that the clusters list is not empty
  expect_true(length(clusters$Clusters) == 12)

  # Check that each element of the list is not empty
  expect_true(all(sapply(clusters$Clusters, length) > 0))

  # Check that the function runs without error for different inputs
  expect_error(capture.output(suppressMessages({ arlc_clusters_plot(g$graph, "Karate Club", clusters$Clusters) })), NA)
})

