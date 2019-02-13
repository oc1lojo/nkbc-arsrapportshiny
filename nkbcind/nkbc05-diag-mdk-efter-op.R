nkbc05_def <- list(
  code = "nkbc05",
  lab = "Multidisciplinär konferens efter operation",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = c(90, 99),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Att definierade specialister och professioner deltar i MDK och formulerar behandlingsrekommendationer har betydelse för vårdprocess för jämlik vård, kunskapsstyrd vård och för kvalitetssäkring.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

filter_nkbc05_pop <- nkbc05_def$filter_pop
mutate_nkbc05_outcome <- nkbc05_def$mutate_outcome
