#' Get Apriori Thresholds
#'
#' This function generates gross rules based on the best obtained thresholds.
#'
#' @description This function takes a transaction dataset and ranges for support and confidence,
#' computes the best thresholds, and returns the best minimum support, minimum confidence,
#' best lift, total number of gross rules, and ratio of generated rules to total number of transactions.
#'
#' @param trx A transaction dataset of class `transactions` from the `arules` package.
#' @param supportRange A sequence of values representing the range for minimum support.
#' @param Conf A sequence of values representing the range for minimum confidence.
#'
#' @return A list containing:
#' \item{minSupp}{The best minimum support value.}
#' \item{minConf}{The best minimum confidence value.}
#' \item{bestLift}{The highest lift value obtained.}
#' \item{lenRules}{The total number of gross rules generated.}
#' \item{ratio}{The ratio of generated rules to the total number of transactions.}
#'
#' @details This function iterates through the given ranges of support and confidence values,
#' applies the Apriori algorithm to find association rules for each pair of values, and selects
#' the pair that produces rules with the highest lift. The function then returns the best thresholds
#' along with the lift, number of rules, and their ratio to the total transactions.
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
#' message(params$minSupp)
#' message(params$minConf)
#' message(params$bestLift)
#' message(params$lenRules)
#' message(params$ratio)
#' }
#'
#' @export

arlc_get_apriori_thresholds <- function(trx, supportRange, Conf) {
  # Initialize variables
  min_supp <- 0.0
  min_conf <- 0.0
  best_lift <- 0.0
  len_rules <- 0.0

  # Get thresholds based on support and confidence ranges
  output_list <- arlc_fct_get_best_apriori_thresholds( trx, supportRange, Conf)

  # Assign values from output_list
  min_supp <- as.double(format(output_list[[1]], scientific = FALSE))
  min_conf <- as.double(format(output_list[[2]], scientific = FALSE))
  best_lift <-  as.double(format(output_list[[3]], scientific = FALSE))
  len_rules <- as.double(output_list[[4]])

  ##message(paste('-- > Generated rules represent approximately ', round(lenRules / length(trx), digits = 0), ' times the total number of transactions'))

  # Return results as a list
  return(list(minSupp = min_supp,
              minConf = min_conf,
              bestLift = best_lift,
              lenRules = len_rules,
              #ratio = paste0(round(len_rules / length(trx), digits = 0), " times the total number of nodes")
              ratio = round(len_rules / length(trx), digits = 0)
             )
         )
}
