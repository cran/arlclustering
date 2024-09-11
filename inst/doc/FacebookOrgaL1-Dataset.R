## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(arlclustering)
#library(igraph)

## -----------------------------------------------------------------------------
# Start the timer
t1 <- system.time({
  dataset_path <- system.file("extdata", "Facebook_Org_L1.gml", package = "arlclustering")
  if (dataset_path == "") {
    stop("Facebook_Org_L1.gml file not found")
  }
  
  g <- arlc_get_network_dataset(dataset_path, "Facebook L1 Organization")
  g$graphLabel
  g$totalNodes
  g$totalEdges
  g$averageDegree
})

# Display the total processing time
message("Graph loading Processing Time: ", t1["elapsed"], " seconds\n")

## -----------------------------------------------------------------------------
# Start the timer
t2 <- system.time({
  transactions <- arlc_gen_transactions(g$graph)
  transactions
})

# Display the total processing time
message("Transaction dataset Processing Time: ", t2["elapsed"], " seconds\n")

## -----------------------------------------------------------------------------
# Start the timer
t3 <- system.time({
  params <- arlc_get_apriori_thresholds(transactions,
                                        supportRange = seq(0.002, 0.003, by = 0.001),
                                        Conf = 0.5)
  params$minSupp
  params$minConf
  params$bestLift
  params$lenRules
  params$ratio
})

# Display the total processing time
message("Graph loading Processing Time: ", t3["elapsed"], " seconds\n")

## -----------------------------------------------------------------------------
# Start the timer
t4 <- system.time({
  minLenRules <- 1
  maxLenRules <- params$lenRules
  if (!is.finite(maxLenRules) || maxLenRules > 5*length(transactions)) {
    maxLenRules <- 5*length(transactions)
  }
  
  grossRules <- arlc_gen_gross_rules(transactions,
                                     minSupp = params$minSupp,
                                     minConf = params$minConf,
                                     minLenRules = minLenRules+1,
                                     maxLenRules = maxLenRules)
  grossRules$TotalRulesWithLengthFilter
})
# Display the total number of clusters and the total processing time
message("Gross rules generation Time: ", t4["elapsed"], " seconds\n")

## -----------------------------------------------------------------------------
t5 <- system.time({
  NonRedRules <- arlc_get_NonR_rules(grossRules$GrossRules)
  NonRSigRules <- arlc_get_significant_rules(transactions,
                                             NonRedRules$FiltredRules)
  NonRSigRules$TotFiltredRules
})
# Display the total number of clusters and the total processing time
message("\nClearing rules Processing Time: ", t5["elapsed"], " seconds\n")

## -----------------------------------------------------------------------------
t6 <- system.time({
  cleanedRules <- arlc_clean_final_rules(NonRSigRules$FiltredRules)
  clusters <- arlc_generate_clusters(cleanedRules)
  clusters$TotClusters
})
# Display the total number of clusters and the total processing time
message("Cleaning final rules Processing Time: ", t6["elapsed"], " seconds\n")

message("The total comsumed time is:",t1["elapsed"]+ t2["elapsed"]+t3["elapsed"]+t4["elapsed"]+t5["elapsed"]+t6["elapsed"], "seconds\n")

## -----------------------------------------------------------------------------
arlc_clusters_plot(g$graph,
                   g$graphLabel,
                   clusters$Clusters)


