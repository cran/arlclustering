## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(arlclustering)

## -----------------------------------------------------------------------------
test_results <- data.frame(
Network = c("Karate Club","Dolphins","LesMiserables","Word Adjacencies","Facebook-Friends","NetScience","Facebook L1 Org."),
  Tot.Nodes   = c(   34,    62,    77,   112,    362,     1589,   5793),
  Tot.Edges   = c(   78,   159,   254,   425,   1988,     2742,  45266),
  min.Supp    = c(  0.1,  0.05,  0.04,  0.03,   0.04,    0.011,  0.002),
  min.Conf    = c(  0.5,   0.5,   0.5,   0.5,    0.5,      0.5,    0.5),
  Tot.Rules   = c(   66,   201, 51774,   649,  74748,   875908,  97858),
  Communities = c(   12,    17,     7,    20,     20,        4,    190),
  Time.s      = c(0.276, 0.455, 1.485, 0.587,  3.501,   14.646, 12.335)
)

## -----------------------------------------------------------------------------
knitr::kable(test_results, caption = "ARLClustering Test Results Summary")

