#' Clean Final Rules
#'
#' This function cleans the final set of association rules.
#'
#' @param final_rules A set of final rules to be cleaned.
#'
#' @return A cleaned set of rules.
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
#' message(cleaned_rules)
#' }
#' @import methods
#' @export

arlc_clean_final_rules <- function(final_rules) {
  # Convert S4 object to data frame
  df <- as(final_rules, "data.frame")
  #head(df$rules) # v
  clean_df <- gsub('[{}=>"]', "", df$rules)
  clean_df <- gsub("  ", ",", clean_df)
  clean_df <- gsub(" ", ",", clean_df)
  #head(clean_df[1])
  values <- lapply(strsplit(clean_df, ","), as.numeric)
  clean_df <- lapply(values, sort)
  vec <- unique (clean_df)

  return(vec)
}
