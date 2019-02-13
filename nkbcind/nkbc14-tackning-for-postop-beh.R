nkbc14_def <- list(
  code = "nkbc14",
  lab = "Täckningsgrad för rapportering av postoperativ onkologisk behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = c(70, 85),
  sjhkod_var = "d_onkpostans_sjhkod",
  om_indikatorn = "Rapportering av given onkologisk behandling sker på ett eget formulär till kvalitetsregistret, separat från anmälan. Rapporteringen sker cirka 1 - 1,5 år efter anmälan.",
  vid_tolkning = NULL,
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc14_pop <- nkbc14_def$filter_pop
mutate_nkbc14_outcome <- nkbc14_def$mutate_outcome
