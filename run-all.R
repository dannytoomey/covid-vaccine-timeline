# Use this master script to generate all of the results
# see README for details

# Packages ------
devtools::install_github("mrc-ide/nimue")
devtools::install_github("mrc-ide/squire")
devtools::install_github(
  "mrc-ide/squire.page",
  ref = "fc27dcabec55d70ec293328813cec644c56a63db"
)
devtools::install_github(
  "mrc-ide/drjacoby",
  ref = "476d94f3eb7357f8e2278834c0af04afd772cf69"
)


# Generate vaccination timelines -----
ord_runs <- lapply(
  list(
    "generate_production_counterfactual",
    "generate_vaccine_counterfactual"
  ),
  function(x) {
    cm <- orderly::orderly_run(x)
    orderly::orderly_commit(cm)
  }
)


# Generate and plot infection timelines -----

tasks <- list('generate_counterfactuals', 'deaths_averted_plot_timeline')

parameter_sets <- list(
    list(
      excess=FALSE, 
      boosters=TRUE,
      double_boosters = FALSE
    ),
    list(
      excess=TRUE, 
      boosters=TRUE,
      double_boosters = FALSE
    ),
    list(
      excess=TRUE, 
      boosters=TRUE,
      double_boosters = TRUE
    ) 
  )

ord_runs <- lapply(
  tasks,
  function(task) {
    lapply(
      parameter_sets,
      function(params) {
        cm <- orderly::orderly_run(task, parameters = params)
        orderly::orderly_commit(cm)
      })
  }
)

preprint <- orderly::orderly_run("preprint")
orderly::orderly_commit(preprint)