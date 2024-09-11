# tests/testthat/test-arlc_generate_clusters.R

library(testthat)
library(arlclustering)

# Test that arlc_generate_clusters works as expected
test_that("arlc_generate_clusters function works correctly", {
  # Load example data
  sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering")
  g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
  trans <- arlc_gen_transactions(g$graph)
  supportRange <- seq(0.1, 0.2, by = 0.1)
  Conf <- 0.5
  capture.output({ params <- arlc_get_apriori_thresholds(trans, supportRange, Conf) })
  capture.output({ grossRules <- arlc_gen_gross_rules(trans, params$minSupp, params$minConf, 1, params$lenRules) })
  capture.output({nonRR_rules <- arlc_get_NonR_rules(grossRules$GrossRules) })
  capture.output({NonRRSig_rules <- arlc_get_significant_rules(trans, nonRR_rules$FiltredRules) })
  capture.output({cleaned_rules <- arlc_clean_final_rules(NonRRSig_rules$FiltredRules) })


  # Checking inputs
  expect_type(cleaned_rules, "list")

  # Generate clusters
  capture.output({clusters <- arlc_generate_clusters(cleaned_rules) })

  # Test that the function returns
  expect_type(clusters, "list")
  expect_equal(clusters$TotClusters, 12) # Check the number of clusters
  expect_type(clusters$Clusters, "list")

  # Check that the output is a list with the correct structure
  expect_named(clusters, c("TotClusters", "Clusters"))
  expect_true(all(c("TotClusters", "Clusters") %in% names(clusters)))

  # Check that the function runs without error for different inputs
  expect_error(arlc_generate_clusters(cleaned_rules), NA)

})
