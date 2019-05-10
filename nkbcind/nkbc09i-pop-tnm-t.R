nkbc09i <- list(
  code = "nkbc09i",
  lab = "Tumörstorlek (klinisk) vid diagnos",
  lab_short = "Tumörstorlek",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(
      x
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = d_tstad
    )
  },
  sjhkod_var = "a_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Kännedom om tumörens utbredning i bröstet påverkar val av primär behandling, typ av kirurgi och val av postoperativ onkologisk behandling. Grundas på bilddiagnostik och klinisk undersökning.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc09i) <- "nkbcind"

filter_nkbc09i_pop <- nkbc09i$filter_pop
mutate_nkbc09i_outcome <- nkbc09i$mutate_outcome
