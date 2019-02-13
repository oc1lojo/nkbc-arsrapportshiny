nkbc20_def <- list(
  code = "nkbc20",
  lab = "Första behandlingsdiskussion till preoperativ onkologisk behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  prop_within_value = 14,
  target_values = c(75, 90),
  sjhkod_var = "pre_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn =
    c(
      "I preoperativ onkologisk behandling ingår cytostatika, strålning eller endokrin behandling.",
      "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid."
    ),
  vid_tolkning =
    paste(
      "Andelen preoperativt behandlade patienter varierar i landet och före start av behandling görs flera undersökningar som kan förlänga tiden till start.",
      "Många patienter som startar preoperativ onkologisk behandling ingår i behandlingsstudier där vissa undersökningar är obligatoriska som annars hade gjorts senare.",
      "Siffrorna skall därför tolkas med viss försiktighet."
    ),
  teknisk_beskrivning = NULL
)

filter_nkbc20_pop <- nkbc20_def$filter_pop
mutate_nkbc20_outcome <- nkbc20_def$mutate_outcome
