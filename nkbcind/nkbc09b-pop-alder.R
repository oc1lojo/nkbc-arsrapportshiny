nkbc09b_def <- list(
  code = "nkbc09b",
  lab = "Ålder vid diagnos",
  lab_short = "Ålder",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  prop_within_unit = "år",
  prop_within_value = 65,
  sjhkod_var = "a_inr_sjhkod",
  other_vars = "d_invasiv",
  om_indikatorn = "Det är ovanligt med bröstcancer i unga år.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

filter_nkbc09b_pop <- nkbc09b_def$filter_pop
mutate_nkbc09b_outcome <- nkbc09b_def$mutate_outcome
