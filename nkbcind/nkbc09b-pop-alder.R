nkbc09b <- list(
  code = "nkbc09b",
  lab = "Ålder vid diagnos",
  lab_short = "Ålder",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = as.numeric(a_pat_alder)
    )
  },
  prop_within_unit = "år",
  prop_within_value = 65,
  sjhkod_var = "a_inr_sjhkod",
  other_vars = "d_invasiv",
  om_indikatorn = "Bröstcancer förekommer i alla åldrar, men blir vanligare med ökande ålder.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc09b) <- "nkbcind"

filter_nkbc09b_pop <- nkbc09b$filter_pop
mutate_nkbc09b_outcome <- nkbc09b$mutate_outcome
