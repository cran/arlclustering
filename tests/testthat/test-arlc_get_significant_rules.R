# Load necessary libraries
library(testthat)
#library(arules) # Ensure this is available for is.significant
library(arlclustering)


# Test cases
test_that("arlc_get_significant_rules function works correctly", {
  # Load example data
  sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering")
  g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
  trans <- arlc_gen_transactions(g$graph)
  supportRange <- seq(0.1, 0.2, by = 0.1)
  Conf <- 0.5
  capture.output({ params <- arlc_get_apriori_thresholds(trans, supportRange, Conf) })
  capture.output({ grossRules <- arlc_gen_gross_rules(trans, params$minSupp, params$minConf, 1, params$lenRules) })
  nonRR_rules <- arlc_get_NonR_rules(grossRules$GrossRules)


  # Check inputs
  expect_type(nonRR_rules, "list")
  expect_s4_class(trans, "transactions")
  expect_equal(nonRR_rules$TotFiltredRules, 50)
  expect_s4_class(nonRR_rules$FiltredRules, "rules")
  expect_true(all(c("TotFiltredRules", "FiltredRules") %in% names(nonRR_rules)))

  # Run function
  result <- arlc_get_significant_rules(trans, nonRR_rules$FiltredRules)

  # Check if the result is a list
  expect_type(result, "list")
  expect_equal(result$TotFiltredRules, 50)

  # Check if the filtered rules are of class "rules"
  expect_s4_class(result$FiltredRules, "rules")

  # Check if the list contains the expected elements
  expect_named(result, c("TotFiltredRules", "FiltredRules"))

  # Check if the number of filtered rules is correct
  expect_true(result$TotFiltredRules <= length(nonRR_rules$FiltredRules))

  # Test that the list contains the correct elements
  expect_true(all(c("TotFiltredRules", "FiltredRules") %in% names(result)))

  # Check that the function runs without error for different inputs
  expect_error(arlc_get_significant_rules(trans, nonRR_rules$FiltredRules), NA)

})

