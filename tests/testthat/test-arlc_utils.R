# test_arlc_utils.R

library(testthat)
#library(arlc_utils) # Adjust this if your package name is different

test_that("arlc_is_numeric_vector works correctly", {
  expect_true(arlc_is_numeric_vector(c(1, 2, 3)))
  expect_error(arlc_is_numeric_vector(c(1, 2, 3)), NA) # Check that the function runs without error

  expect_false(arlc_is_numeric_vector(c(1, "a", 3)))
  expect_error(arlc_is_numeric_vector(c(1, "a", 3)), NA) # Check that the function runs without error

  expect_false(arlc_is_numeric_vector(c("a", "b", "c")))
  expect_error(arlc_is_numeric_vector(c("a", "b", "c")), NA) # Check that the function runs without error

})


test_that("arlc_measure_time measures execution time", {
  capture.output(suppressMessages({ result <- arlc_measure_time(Sys.sleep, 1) }))
  expect_equal(result, NULL)
  # Check that the function runs without error for different inputs
  expect_error(capture.output(suppressMessages({arlc_measure_time(Sys.sleep, 1)})), NA)
})

test_that("arlc_list_to_df converts list to data frame correctly", {
  lst <- list(a = c(x = 1, y = 2), b = c(x = 3, y = 4))
  df <- arlc_list_to_df(lst)
  expected_df <- data.frame(x = c(1, 3), y = c(2, 4), stringsAsFactors = FALSE)
  rownames(expected_df) <- c("a", "b")
  expect_equal(df, expected_df)

  # Check that the function runs without error for different inputs
  expect_error(arlc_list_to_df(lst), NA)
})

test_that("arlc_generate_uid generates unique identifiers", {
  uid1 <- arlc_generate_uid()
  uid2 <- arlc_generate_uid()
  expect_equal(nchar(uid1), 10)
  expect_true(uid1 != uid2)

  # Check that the function runs without error for different inputs
  expect_error(arlc_generate_uid(), NA)
})

test_that("arlc_file_exists_readable checks file existence and readability", {
  test_file <- tempfile()
  file.create(test_file)
  expect_true(arlc_file_exists_readable(test_file))
  unlink(test_file)

  # Check that the function runs without error for different inputs
  expect_error(arlc_file_exists_readable(test_file), NA)
})

test_that("arlc_count_na counts NA values correctly", {
  df <- data.frame(a = c(1, NA, 3), b = c(NA, NA, 3))
  expect_equal(arlc_count_na(df), c(a = 1, b = 2))

  # Check that the function runs without error for different inputs
  expect_error(arlc_count_na(df), NA)
})

test_that("arlc_replace_na replaces NA values correctly", {
  vec <- c(1, NA, 3)
  df <- data.frame(a = c(1, NA, 3), b = c(NA, NA, 3))
  expect_equal(arlc_replace_na(vec, 0), c(1, 0, 3))

  # Check that the function runs without error for different inputs
  expect_error(arlc_replace_na(vec, 0), NA)

  expect_equal(arlc_replace_na(df, 0), data.frame(a = c(1, 0, 3), b = c(0, 0, 3), stringsAsFactors = FALSE))
  # Check that the function runs without error for different inputs
  expect_error(arlc_replace_na(df, 0), NA)
})

test_that("arlc_normalize_vector normalizes a vector correctly", {
  vec <- c(1, 2, 3, 4, 5)
  normalized_vec <- arlc_normalize_vector(vec)
  expect_equal(normalized_vec, c(0, 0.25, 0.5, 0.75, 1))
  expect_error(arlc_normalize_vector(vec), NA)
})

test_that("arlc_calculate_mode calculates mode correctly", {
  vec <- c(1, 2, 2, 3, 4)
  expect_equal(arlc_calculate_mode(vec), 2)
  expect_error(arlc_calculate_mode(vec), NA)
})

test_that("arlc_df_summary creates a summary correctly", {
  df <- data.frame(a = c(1, 2, 3, 4, 5), b = c(5, 4, 3, 2, 1))
  summary_df <- arlc_df_summary(df)
  expected_summary <- data.frame(
    Column = c("a", "b"),
    Count = c(5, 5),
    Mean = c(3, 3),
    Median = c(3, 3),
    SD = c(1.58, 1.58),
    stringsAsFactors = FALSE
  )
  rownames(expected_summary) <- c("a", "b")
  expect_equal(summary_df, expected_summary, tolerance = 0.01)
  expect_error(arlc_df_summary(df), NA)
})


test_that("arlc_convert_date_format converts date formats correctly", {
  date_str <- "2023-01-01"
  new_date <- arlc_convert_date_format(date_str, "%Y-%m-%d", "%d-%m-%Y")
  expect_equal(new_date, "01-01-2023")
  expect_error(arlc_convert_date_format(date_str, "%Y-%m-%d", "%d-%m-%Y"), NA)
})

test_that("arlc_generate_date_sequence generates date sequences correctly", {
  start_date <- "2023-01-01"
  end_date <- "2023-01-10"
  dates <- arlc_generate_date_sequence(start_date, end_date, "day")
  expected_dates <- seq.Date(as.Date(start_date), as.Date(end_date), by = "day")
  expect_equal(dates, expected_dates)
  expect_error(arlc_generate_date_sequence(start_date, end_date, "day"), NA)
})
