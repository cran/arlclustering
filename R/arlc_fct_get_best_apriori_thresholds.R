#' Get Best Apriori Thresholds
#'
#' This function finds the best support and confidence thresholds for the Apriori algorithm
#' to maximize the lift of the generated association rules.
#'
#' @param transactions A transaction dataset of class `transactions` from the `arules` package.
#' @param support_range A numeric vector specifying the range of support values to be tested.
#' @param conf A numeric value (0.5 or 1.0) specifying the confidence value.
#'
#' @return A numeric vector containing the best support, best confidence, highest lift, and the number of rules found.
#' The return value is a named vector with elements \code{best_support}, \code{best_confidence}, \code{best_lift}, and \code{len_rules}.
#'
#' @details This function iterates through the given ranges of support and confidence values,
#' applies the Apriori algorithm to find association rules for each pair of values, and selects
#' the pair that produces rules with the highest lift.
#'
#' @examples
#' \donttest{
#' library(arlclustering)
#' sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering")
#' g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
#' trans <- arlc_gen_transactions(g$graph)
#' supportRange <- seq(0.1, 0.2, by = 0.1)
#' Conf <- 0.5
#' best_thresholds <- arlc_fct_get_best_apriori_thresholds(trans, supportRange, Conf)
#' }
#'
#' @importFrom arules apriori
#' @export

arlc_fct_get_best_apriori_thresholds <- function(transactions, support_range, conf) {
  # Validate supportRange
  support_diff <- max(support_range) - min(support_range)
  #if (support_diff != 0.02) {
  if (!(support_diff %in% c("0, 0.2", "0.02", "0.002", "0.1", "0.01", "0.001"))){
    stop("ERROR: The Support Range must be null or at least cover a ranges 0.1 or 0.2, 0.01 or 0.02, and 0.001 or 0.002")
  }

  # Validate confidenceRange
  # confidence_diff <- max(confidenceRange) - min(confidenceRange)
  # if (confidence_diff != 0.2) {
  #   stop("confidenceRange must cover a range of exactly 0.2")
  # }
  if (!(conf %in% c("0.5", "1.0"))){
    stop("Confidence must either be 0.5 or 1.0")
  }

  # Initialize variables to store the best support, confidence, lift, and rules
  best_support <- 0
  best_confidence <- 0
  best_rules <- NULL
  best_lift <- 0
  len_rules <- 0

  # Loop through the support and confidence values
  for (support in support_range) {
    #for (confidence in confidence_range) {
      # Run Apriori algorithm with the current support and confidence
      gross_rules <- arules::apriori(
        transactions,
        parameter = list(support=support, confidence=conf),
        target = "rules",
        control = list(verbose = FALSE)
      )

      # Check if rules are found and if they have higher lift than the previous best rules
      if (length(gross_rules) > 0 && max(gross_rules@quality$lift) > best_lift) {
        best_support <- support
        best_confidence <- conf
        best_lift <- max(gross_rules@quality$lift)
        best_rules <- gross_rules
      }
    #}
  }

  # Calculate the number of rules found
  len_rules <- length(best_rules)

  # Return the best support, confidence, lift, and number of rules found
  return(c(best_support, best_confidence, best_lift, len_rules))
}
