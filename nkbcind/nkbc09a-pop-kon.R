nkbc09a_def <- list(
  code = "nkbc09a",
  lab = "Kön vid diagnos",
  lab_short = "Kön",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x) # ingen filtrering
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = factor(KON_VALUE,
        levels = c(1, 2),
        labels = c("Män", "Kvinnor")
      )
    )
  },
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Bröstcancer drabbar både män och kvinnor.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

filter_nkbc09a_pop <- nkbc09a_def$filter_pop
mutate_nkbc09a_outcome <- nkbc09a_def$mutate_outcome
