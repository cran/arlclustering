# tests/testthat/test_arlc_gen_gross_rules.R

library(testthat)
library(arlclustering)


test_that("arlc_gen_gross_rules function works correctly", {
  # Load Data and parameters
  sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering") # Adjust as needed
  g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
  trans <- arlc_gen_transactions(g$graph)
  supportRange <- seq(0.1, 0.2, by = 0.1)
  Conf <- 0.5
  capture.output({ params <- arlc_get_apriori_thresholds(trans, supportRange, Conf) })
  minSupp <- params$minSupp
  minConf <- params$minConf
  minLenRules <- 1
  maxLenRules <- params$lenRules

  # Checking inputs
  expect_true(is.numeric(as.numeric(params$minSupp)))
  expect_equal(params$minSupp, 0.1)
  expect_type(params$minSupp, "double")

  expect_true(is.numeric(as.numeric(params$minConf)))
  expect_equal(params$minConf, 0.5)
  expect_type(params$minConf, "double")

  expect_true(is.numeric(as.numeric(params$bestLift)))
  expect_equal(params$bestLift, 7)
  expect_type(params$bestLift, "double")

  expect_true(is.numeric(params$lenRules))
  expect_equal(params$lenRules, 66)
  expect_type(params$lenRules, "double")

  expect_true(is.numeric(params$ratio))
  expect_equal(params$ratio, 2)
  expect_type(params$ratio, "double")
  expect_true(params$ratio >= 2)

  expect_s4_class(trans, "transactions")


  # Run function
  capture.output({ result <- arlc_gen_gross_rules(trans, minSupp, minConf, minLenRules, maxLenRules) })

  expect_true(is.list(result))
  expect_true("TotalRulesWithLengthFilter" %in% names(result))
  expect_true("GrossRules" %in% names(result))
  expect_true(all(c("TotalRulesWithLengthFilter", "GrossRules") %in% names(result)))

  expect_true(is.numeric(result$TotalRulesWithLengthFilter))
  expect_true(inherits(result$GrossRules, "rules"))

  # Additional checks for correctness
  expect_true(length(result$GrossRules) > 0)
  expect_true(all(length(result$GrossRules) >= minLenRules))
  expect_true(all(length(result$GrossRules) <= maxLenRules))

  # Check that the function runs without error for different inputs
  expect_error(capture.output({ result <- arlc_gen_gross_rules(trans, minSupp, minConf, minLenRules, maxLenRules) }), NA)
})

