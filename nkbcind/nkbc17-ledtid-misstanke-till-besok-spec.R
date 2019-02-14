nkbc17 <- list(
  code = "nkbc17",
  lab = "Välgrundad misstanke om cancer till första besök i specialiserad vård",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Endast fall med år från 2013 (1:a kontakt tillkom 2013)
      year(a_diag_dat) >= 2013
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      d_a_diag_misscadat = ymd(coalesce(a_diag_misscadat, a_diag_kontdat)),
      outcome = as.numeric(ymd(a_diag_besdat) - d_a_diag_misscadat),

      outcome = ifelse(outcome < 0, 0, outcome)
    )
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
class(nkbc17) = "nkbcind"

filter_nkbc17_pop <- nkbc17$filter_pop
mutate_nkbc17_outcome <- nkbc17$mutate_outcome
