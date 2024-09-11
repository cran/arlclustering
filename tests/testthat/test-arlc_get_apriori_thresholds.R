# Load the required packages
library(testthat)
library(arlclustering)

# Define the test context
test_that("arlc_get_apriori_thresholds function works correctly", {
  # Load example data
  sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering")
  g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
  trans <- arlc_gen_transactions(g$graph)
  supportRange <- seq(0.1, 0.2, by = 0.1)
  Conf <- 0.5

  # Check inputs
  expect_s4_class(trans, "transactions")
  expect_type(Conf, "double")
  expect_equal(supportRange, seq(0.1, 0.2, by = 0.1))
  expect_equal(Conf, 0.5)


  # Run the function
  capture.output({ result <- arlc_get_apriori_thresholds(trans, supportRange, Conf) })

  # Test that the list contains the correct elements
  expect_named(result, c("minSupp", "minConf", "bestLift", "lenRules", "ratio"))
  expect_true(all(c("minSupp", "minConf", "bestLift", "lenRules", "ratio") %in% names(result)))


  # Check if the output is a list
  expect_type(result, "list")

  # Check if all expected elements are in the list

  # Check if the values are numeric (or can be converted to numeric)
  expect_true(is.numeric(as.numeric(result$minSupp)))
  expect_equal(result$minSupp, 0.1)
  expect_type(result$minSupp, "double")

  expect_true(is.numeric(as.numeric(result$minConf)))
  expect_equal(result$minConf, 0.5)
  expect_type(result$minConf, "double")

  expect_true(is.numeric(as.numeric(result$bestLift)))
  expect_equal(result$bestLift, 7)
  expect_type(result$bestLift, "double")

  expect_true(is.numeric(result$lenRules))
  expect_equal(result$lenRules, 66)
  expect_type(result$lenRules, "double")

  expect_true(is.numeric(result$ratio))
  expect_equal(result$ratio, 2)
  expect_type(result$ratio, "double")

  # Check if the support and confidence values are within the specified ranges
  expect_true(as.numeric(result$minSupp) %in% supportRange)
  expect_true(as.numeric(result$minConf) %in% Conf)

  # Check if the ratio is calculated correctly
  expect_equal(result$ratio, round(result$lenRules / length(trans), digits = 0))

  # Check that the function runs without error for different inputs
  expect_error(arlc_get_apriori_thresholds(trans, supportRange, Conf), NA)
})

