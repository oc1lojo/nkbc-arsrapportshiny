nkbc11_def <- list(
  code = "nkbc11",
  lab = "Bröstbevarande operation",
  pop = "primärt opererade fall med invasiv cancer <=30 mm eller ej invasiv cancer <=20 mm utan fjärrmetastaser vid diagnos",
  pop_short = "primärt opererade fall med små tumörer utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = c(70, 80),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Ett bröstbevarande ingrepp och  strålbehandling är  standradingrepp  för majoriten av tidigt upptäckta bröstcancrar . Tumörens egenskaper, form och storlek på bröstet spelar roll för av av kirurgisk operationsmetod.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

filter_nkbc11_pop <- nkbc11_def$filter_pop
mutate_nkbc11_outcome <- nkbc11_def$mutate_outcome
