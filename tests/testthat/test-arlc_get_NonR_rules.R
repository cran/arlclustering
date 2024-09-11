# Load the packages
library(testthat)
library(arlclustering)
#library(arules)


# Define the test cases
test_that("arlc_get_NonR_rules function works correctly", {
  # Load example data
  sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering") # Adjust as needed
  g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
  trans <- arlc_gen_transactions(g$graph)
  supportRange <- seq(0.1, 0.2, by = 0.1)
  Conf <- 0.5
  capture.output({ params <- arlc_get_apriori_thresholds(trans, supportRange, Conf) })
  capture.output({ grossRules <- arlc_gen_gross_rules(trans, params$minSupp, params$minConf, 1, params$lenRules) })

  # Check inputs
  expect_true(is.list(grossRules))
  expect_true(all(c("TotalRulesWithLengthFilter", "GrossRules") %in% names(grossRules)))
  expect_true(is.numeric(grossRules$TotalRulesWithLengthFilter))
  expect_true(inherits(grossRules$GrossRules, "rules"))
  expect_true(length(grossRules$GrossRules) == 66)
  expect_true(all(length(grossRules$GrossRules) >= 1))

  # Run function
  nonRR_rules <- arlc_get_NonR_rules(grossRules$GrossRules)

  # Test that the function returns a list
  expect_type(nonRR_rules, "list")
  expect_equal(nonRR_rules$TotFiltredRules, 50)
  expect_s4_class(nonRR_rules$FiltredRules, "rules")

  # Test that the list contains the correct elements
  expect_named(nonRR_rules, c("TotFiltredRules", "FiltredRules"))
  expect_true(all(c("TotFiltredRules", "FiltredRules") %in% names(nonRR_rules)))

  # Check that the function runs without error for different inputs
  expect_error(arlc_get_NonR_rules(grossRules$GrossRules), NA)
})

