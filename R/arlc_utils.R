# utils.R

#' Check if a Vector is Numeric
#'
#' This function checks if all elements of a vector are numeric.
#'
#' @param x A vector.
#'
#' @return TRUE if all elements are numeric, FALSE otherwise.
#'
#' @examples
#' arlc_is_numeric_vector(c(1, 2, 3))
#' arlc_is_numeric_vector(c(1, "a", 3))
#' @export
arlc_is_numeric_vector <- function(x) {
  return(all(sapply(x, is.numeric)))
}

#' Measure Execution Time of a Function
#'
#' This function measures the execution time of a given function.
#'
#' @param func The function to measure.
#' @param ... Additional arguments to pass to the function.
#'
#' @return The result of the function execution.
#'
#' @examples
#' arlc_measure_time(Sys.sleep, 1)
#' @export
arlc_measure_time <- function(func, ...) {
  start_time <- Sys.time()
  result <- func(...)
  end_time <- Sys.time()
  elapsed_time <- end_time - start_time
  message("Elapsed time:", elapsed_time, "\n")
  return(result)
}

#' Convert List of Vectors to Data Frame
#'
#' This function converts a list of named vectors to a data frame.
#'
#' @param lst A list of named vectors.
#'
#' @return A data frame with each element of the list as a row.
#'
#' @examples
#' lst <- list(a = c(x = 1, y = 2), b = c(x = 3, y = 4))
#' arlc_list_to_df(lst)
#' @export
arlc_list_to_df <- function(lst) {
  do.call(rbind, lapply(lst, function(x) as.data.frame(t(x), stringsAsFactors = FALSE)))
}

#' Generate a Unique Identifier
#'
#' This function generates a unique identifier string.
#'
#' @param length The length of the unique identifier. Default is 10.
#'
#' @return A unique identifier string.
#'
#' @examples
#' arlc_generate_uid()
#' arlc_generate_uid(15)
#' @export
arlc_generate_uid <- function(length = 10) {
  chars <- c(letters, LETTERS, 0:9)
  paste(sample(chars, length, replace = TRUE), collapse = "")
}

#' Check if a File Exists and is Readable
#'
#' This function checks if a file exists and is readable.
#'
#' @param filepath The path to the file.
#'
#' @return TRUE if the file exists and is readable, FALSE otherwise.
#'
#' @examples
#' arlc_file_exists_readable("example.txt")
#' @export
arlc_file_exists_readable <- function(filepath) {
  return(file.exists(filepath) && file.access(filepath, 4) == 0)
}

#MEL

#' Count NA Values in a Data Frame
#'
#' This function counts the number of NA values in each column of a data frame.
#'
#' @param df A data frame.
#'
#' @return A named vector with the count of NA values in each column.
#'
#' @examples
#' arlc_count_na(data.frame(a = c(1, NA, 3), b = c(NA, NA, 3)))
#' @export
arlc_count_na <- function(df) {
  sapply(df, function(col) sum(is.na(col)))
}

#' Replace NA with a Specified Value
#'
#' This function replaces NA values in a vector or data frame with a specified value.
#'
#' @param x A vector or data frame.
#' @param value The value to replace NA with.
#'
#' @return The vector or data frame with NA values replaced.
#'
#' @examples
#' arlc_replace_na(c(1, NA, 3), 0)
#' arlc_replace_na(data.frame(a = c(1, NA, 3), b = c(NA, NA, 3)), 0)
#' @export
arlc_replace_na <- function(x, value) {
  if (is.data.frame(x)) {
    x <- as.data.frame(lapply(x, function(col) ifelse(is.na(col), value, col)))
  } else {
    x <- ifelse(is.na(x), value, x)
  }
  return(x)
}

#' Normalize a Numeric Vector
#'
#' This function normalizes a numeric vector to have values between 0 and 1.
#'
#' @param x A numeric vector.
#'
#' @return A normalized numeric vector.
#'
#' @examples
#' arlc_normalize_vector(c(1, 2, 3, 4, 5))
#' @export
arlc_normalize_vector <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

#' Calculate the Mode of a Vector
#'
#' This function calculates the mode of a vector.
#'
#' @param x A vector.
#'
#' @return The mode of the vector.
#'
#' @examples
#' arlc_calculate_mode(c(1, 2, 2, 3, 4))
#' @export
arlc_calculate_mode <- function(x) {
  uniqx <- unique(x)
  uniqx[which.max(tabulate(match(x, uniqx)))]
}

#' Create a Summary of a Data Frame
#'
#' This function creates a summary of a data frame including count, mean, median, and standard deviation for numeric columns.
#'
#' @param df A data frame.
#'
#' @return A data frame summarizing the statistics of the input data frame.
#'
#' @examples
#' arlc_df_summary(data.frame(a = c(1, 2, 3, 4, 5), b = c(5, 4, 3, 2, 1)))
#' @importFrom stats sd median
#' @export
arlc_df_summary <- function(df) {
  numeric_cols <- df[sapply(df, is.numeric)]
  summary_df <- data.frame(
    Column = names(numeric_cols),
    Count = sapply(numeric_cols, length),
    Mean = sapply(numeric_cols, mean, na.rm = TRUE),
    Median = sapply(numeric_cols, median, na.rm = TRUE),
    SD = sapply(numeric_cols, sd, na.rm = TRUE)
  )
  return(summary_df)
}

#' Convert a Date to a Different Format
#'
#' This function converts a date from one format to another.
#'
#' @param date_str A date string.
#' @param from_format The current format of the date string.
#' @param to_format The desired format of the date string.
#'
#' @return The date string in the new format.
#'
#' @examples
#' arlc_convert_date_format("2023-01-01", "%Y-%m-%d", "%d-%m-%Y")
#' @export
arlc_convert_date_format <- function(date_str, from_format, to_format) {
  date_obj <- as.Date(date_str, format = from_format)
  return(format(date_obj, format = to_format))
}

#' Generate a Sequence of Dates
#'
#' This function generates a sequence of dates between two given dates.
#'
#' @param start_date The start date.
#' @param end_date The end date.
#' @param by The step size for the sequence (e.g., "day", "week", "month").
#'
#' @return A vector of dates.
#'
#' @examples
#' arlc_generate_date_sequence("2023-01-01", "2023-01-10", "day")
#' @export
arlc_generate_date_sequence <- function(start_date, end_date, by = "day") {
  return(seq.Date(as.Date(start_date), as.Date(end_date), by = by))
}
