nkbc17_def <- list(
  code = "nkbc17",
  lab = "Välgrundad misstanke om cancer till första besök i specialiserad vård",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  prop_within_value = 7,
  target_values = c(75, 90),
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.",
  vid_tolkning = "Startpunkten för SVF har tolkats olika av vårdgivare vilket ger upphov till variation varför ledtiden skall tolkas med försiktighet.",
  inkl_beskr_missca = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc17_pop <- nkbc17_def$filter_pop
mutate_nkbc17_outcome <- nkbc17_def$mutate_outcome
