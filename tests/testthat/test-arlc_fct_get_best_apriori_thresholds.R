library(testthat)
#library(arules)
library(arlclustering)


# Define a test case for the function arlc_get_apriori_thresholds
test_that("arlc_get_apriori_thresholds returns correct results", {
  # Load example data
  sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering") # Adjust as needed
  g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
  trans <- arlc_gen_transactions(g$graph)

  # Define support and confidence ranges for the tests
  supportRange <- seq(0.1, 0.2, by = 0.1)
  Conf <- 0.5

  # Check inputs
  expect_s4_class(trans, "transactions")
  expect_type(supportRange, "double")
  expect_equal(supportRange, seq(0.1, 0.2, by = 0.1))
  expect_type(Conf, "double")
  expect_true(Conf == 0.5)

  # Run the function
  capture.output({ result <- arlc_get_apriori_thresholds(trans, supportRange, Conf) })

  # Check that the result is a list
  expect_type(result, "list")

  # Check that the list has the correct names
  expect_named(result, c("minSupp", "minConf", "bestLift", "lenRules", "ratio"))
  expect_true(all(c("minSupp", "minConf", "bestLift", "lenRules", "ratio") %in% names(result)))

  # Check that the elements are of the expected types and values
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

  # Check that the ratio is a non-negative value
  expect_true(result$ratio >= 2)

  # Check that the function runs without error for different inputs
  expect_error(arlc_get_apriori_thresholds(trans, supportRange, Conf), NA)
})


