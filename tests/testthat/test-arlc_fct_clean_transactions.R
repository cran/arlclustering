library(testthat)

# Define the test cases
test_that("arlc_fct_clean_transactions removes fully overlapped sets correctly", {
  # Test case 1: Basic functionality
  all_sets <- list(
    c(1, 2, 3),
    c(2, 3),
    c(4, 5),
    c(5, 6, 7)
  )
  expected_output <- list(
    c(1, 2, 3),
    c(4, 5),
    c(5, 6, 7)
  )
  cleaned_sets <- arlc_fct_clean_transactions(all_sets)
  expect_equal(cleaned_sets, expected_output)
  # Check that the function runs without error for different inputs
  expect_error(arlc_fct_clean_transactions(all_sets), NA)


  # Test case 2: No overlapping sets
  all_sets <- list(
    c(1, 2),
    c(3, 4),
    c(5, 6)
  )
  expected_output <- list(
    c(1, 2),
    c(3, 4),
    c(5, 6)
  )
  cleaned_sets <- arlc_fct_clean_transactions(all_sets)
  expect_equal(cleaned_sets, expected_output)
  # Check that the function runs without error for different inputs
  expect_error(arlc_fct_clean_transactions(all_sets), NA)

  # Test case 3: All sets are unique and overlapping
  all_sets <- list(
    c(1, 2, 3),
    c(1, 2, 3, 4),
    c(1, 2, 3, 4, 5)
  )
  expected_output <- list(
    c(1, 2, 3, 4, 5)
  )
  cleaned_sets <- arlc_fct_clean_transactions(all_sets)
  expect_equal(cleaned_sets, expected_output)
  # Check that the function runs without error for different inputs
  expect_error(arlc_fct_clean_transactions(all_sets), NA)

  # Test case 4: Mixed overlap
  all_sets <- list(
    c(1, 2),
    c(2, 3),
    c(1, 2, 3),
    c(4, 5),
    c(5, 6)
  )
  expected_output <- list(
    c(1, 2, 3),
    c(4, 5),
    c(5, 6)
  )
  cleaned_sets <- arlc_fct_clean_transactions(all_sets)
  expect_equal(cleaned_sets, expected_output)
  # Check that the function runs without error for different inputs
  expect_error(arlc_fct_clean_transactions(all_sets), NA)

  # Test case 5: Empty input
  all_sets <- list()
  expected_output <- list()
  cleaned_sets <- arlc_fct_clean_transactions(all_sets)
  expect_equal(cleaned_sets, expected_output)
  # Check that the function runs without error for different inputs
  expect_error(arlc_fct_clean_transactions(all_sets), NA)

  # Test case 6: Single set
  all_sets <- list(
    c(1, 2, 3)
  )
  expected_output <- list(
    c(1, 2, 3)
  )
  cleaned_sets <- arlc_fct_clean_transactions(all_sets)
  expect_equal(cleaned_sets, expected_output)
  # Check that the function runs without error for different inputs
  expect_error(arlc_fct_clean_transactions(all_sets), NA)

  # Test case 7: Duplicate sets
  all_sets <- list(
    c(1, 2, 3),
    c(1, 2, 3),
    c(4, 5),
    c(4, 5)
  )
  expected_output <- list(
    c(1, 2, 3),
    c(4, 5)
  )
  cleaned_sets <- arlc_fct_clean_transactions(all_sets)
  expect_equal(cleaned_sets, expected_output)
  # Check that the function runs without error for different inputs
  expect_error(arlc_fct_clean_transactions(all_sets), NA)
})

