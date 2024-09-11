#' Get Significant Rules
#'
#' This function filters significant rules from a set of non-redundant rules.
#'
#' @description This function takes all transactions and a set of non-redundant rules as input,
#' and returns significant rules based on a specified method and adjustment.
#'
#' @param all_trans A dataframe containing all transactions.
#' @param nonRR_rules A list of non-redundant rules.
#'
#' @return A list containing the total number of significant non-redundant rules and the significant rules themselves.
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
#' }
#' @importFrom arules is.significant
#' @export

arlc_get_significant_rules <- function(all_trans, nonRR_rules) {
  # is.significant filter Parameters
  method = "fisher"
  adjust = "bonferroni" #'bonferroni', 'holm'

  # Get significant rules
  sigR_nnRR_Rules <- nonRR_rules[!is.significant(nonRR_rules, all_trans, method, adjust)]

  if (length(sigR_nnRR_Rules) < 1) {
    #message('Significant rule set is the same as the redundant rule set...')
    sigR_nnRR_Rules <- nonRR_rules
  }

  total_nonRedandant_signif_rules <- length(sigR_nnRR_Rules)

  return(list(TotFiltredRules = total_nonRedandant_signif_rules,
              FiltredRules = sigR_nnRR_Rules
              )
         )
}
