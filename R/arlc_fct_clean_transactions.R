#' Clean Transactions by Removing Overlapping Sets
#'
#' This function processes a list of sets and removes those that are fully overlapped by other sets.
#'
#' @param all_sets A list of sets where each set is a vector of elements.
#'
#' @return A list of sets with fully overlapped sets removed.
#'
#' @details The function iterates through each set and checks if it is fully overlapped by any other set. If a set is fully overlapped, it is excluded from the final list of sets. The result is a list of sets with no fully overlapped sets.
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
#' nonRR_rules <- arlc_get_NonR_rules(grossRules$GrossRules)
#' NonRRSig_rules <- arlc_get_significant_rules(trans, nonRR_rules$FiltredRules)
#' cleaned_rules <- arlc_clean_final_rules(NonRRSig_rules$FiltredRules)
#'
#' vec <- lapply(cleaned_rules, function(v) unique(unlist(v)))
#' vec2 <- split(vec, sapply(vec, `[`, 1))
#' sorted_result <- lapply(vec2, function(v) sort(unique(unlist(v))))
#'
#' clusters <- arlc_fct_clean_transactions(sorted_result)
#'
#' message (clusters)
#' }
#'
#' @export

arlc_fct_clean_transactions <- function(all_sets) {
  # Sort each set to handle unordered sets
  sorted_sets <- lapply(all_sets, sort)

  # Remove exact duplicates
  unique_sets <- unique(sorted_sets)

  # Initialize a list to keep track of sets that are not subsets of others
  non_subsets <- list()

  # Check for subsets
  for (i in seq_along(unique_sets)) {
    is_subset <- FALSE
    for (j in seq_along(unique_sets)) {
      if (i != j && all(unique_sets[[i]] %in% unique_sets[[j]])) {
        is_subset <- TRUE
        break
      }
    }
    if (!is_subset) {
      non_subsets <- c(non_subsets, list(unique_sets[[i]]))
    }
  }

  return(non_subsets)
}


