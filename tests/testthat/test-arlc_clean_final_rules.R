# Load the required packages
library(testthat)
#library(arules)
library(arlclustering)  # Adjust the package name as needed


# Test cases for arlc_clean_final_rules
test_that("arlc_clean_final_rules cleans the rules correctly", {
  # Load example data
  sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering")
  g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
  trans <- arlc_gen_transactions(g$graph)
  supportRange <- seq(0.1, 0.2, by = 0.1)
  Conf <- 0.5
  capture.output({ params <- arlc_get_apriori_thresholds(trans, supportRange, Conf) })
  capture.output({ grossRules <- arlc_gen_gross_rules(trans, params$minSupp, params$minConf, 1, params$lenRules) })
  nonRR_rules <- arlc_get_NonR_rules(grossRules$GrossRules)
  NonRRSig_rules <- arlc_get_significant_rules(trans, nonRR_rules$FiltredRules)

  # Check inputs
  expect_type(NonRRSig_rules, "list")
  expect_equal(NonRRSig_rules$TotFiltredRules, 50)
  expect_s4_class(NonRRSig_rules$FiltredRules, "rules")
  expect_named(NonRRSig_rules, c("TotFiltredRules", "FiltredRules"))
  expect_true(NonRRSig_rules$TotFiltredRules <= length(nonRR_rules$FiltredRules))
  expect_true(all(c("TotFiltredRules", "FiltredRules") %in% names(NonRRSig_rules)))

  # Call the function with the synthetic rules
  cleaned_rules <- arlc_clean_final_rules(NonRRSig_rules$FiltredRules)

  # Check if the result is a list
  expect_type(cleaned_rules, "list")

  # Check if the elements of the list are numeric vectors
  expect_true(all(sapply(cleaned_rules, is.numeric)))

  # Check that the function runs without error for different inputs
  expect_error(arlc_clean_final_rules(NonRRSig_rules$FiltredRules), NA)
})
