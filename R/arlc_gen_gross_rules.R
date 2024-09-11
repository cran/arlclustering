#' Get Gross Rules
#'
#' This function generates gross association rules from transactions.
#'
#' @param transactions A transactions object.
#' @param minSupp Minimum support threshold.
#' @param minConf Minimum confidence threshold.
#' @param minLenRules Minimum length of rules.
#' @param maxLenRules Maximum length of rules.
#'
#' @return A set of gross association rules.
#'
#' @examples
#' \donttest{
#' library(arlclustering)
#' # Create a sample transactions dataset
#' sample_gml_file <- system.file("extdata", "karate.gml", package = "arlclustering")
#' g <- arlc_get_network_dataset(sample_gml_file, "Karate Club")
#' trans <- arlc_gen_transactions(g$graph)
#' supportRange <- seq(0.1, 0.2, by = 0.1)
#' Conf <- 0.5
#' params <- arlc_get_apriori_thresholds(trans, supportRange, Conf)
#' grossRules <- arlc_gen_gross_rules(trans, params$minSupp, params$minConf, 1, params$lenRules)
#' }
#' @importFrom arules apriori
#' @export

arlc_gen_gross_rules <- function(transactions, minSupp, minConf, minLenRules, maxLenRules) {
  # Ensure the transactional data is of class transactions
  if (!inherits(transactions, "transactions")) {
    stop("The transactions object must be of class 'transactions'.")
  }
  # Ensure minSupp and minConf are numeric
  #if (!is.numeric(minSupp) || !is.numeric(minConf) || !is.numeric(minLenRules) || !is.numeric(maxLenRules) ) {
  #  stop("minSupp, minConf, minLenRules and maxLenRules must be numeric values.")
  #}

  # if (maxLenRules > length(transactions))
  # {
  #   maxLenRules <- length(transactions)
  # }
  # Execute Apriori algorithm with specified parameters
  gross_rules <- arules::apriori(transactions,
                                 parameter = list(support = as.numeric(minSupp),
                                                  confidence = as.numeric(minConf),
                                                  minlen = as.numeric(minLenRules),
                                                  maxlen = as.numeric(maxLenRules)),
                                 target = "rules")

  # Compute the total number of gross rules with length filter
  total_rules_with_length_filter <- length(gross_rules)

  # Return the total number of gross rules with length filter and the gross rules themselves
  return(list(TotalRulesWithLengthFilter = total_rules_with_length_filter,
              GrossRules = gross_rules))
}
