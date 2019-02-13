nkbc09f_def <- list(
  code = "nkbc09f",
  lab = "Fjärrmetastaser vid diagnos",
  lab_short = "Fjärrmetastaser",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  sjhkod_var = "a_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Fall med fjärrmetastaser definieras som upptäckta inom 3 månader från provtagningsdatum (diagnosdatum).",
  vid_tolkning =
    paste(
      "T.o.m. 2012 var det möjligt att registrera en tumör som att fjärrmetastaser ej kan bedömas (MX) i NKBC.",
      "Dessa har grupperats ihop med Uppgift saknas."
    ),
  teknisk_beskrivning = NULL
)

filter_nkbc09f_pop <- nkbc09f_def$filter_pop
mutate_nkbc09f_outcome <- nkbc09f_def$mutate_outcome
