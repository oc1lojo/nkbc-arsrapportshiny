nkbc03 <- list(
  code = "nkbc03",
  lab = "Individuell vårdplan (Min Vårdplan) har upprättats i samråd med patienten",
  lab_short = "Min vårdplan",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(
      x,
      # min vp tillkom mitten av 2014
      year(a_diag_dat) >= 2015
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      # Hantera missing
      outcome = as.logical(ifelse(a_omv_indivplan_Varde %in% c(0, 1), a_omv_indivplan_Varde, NA))
    )
  },
  target_values = c(95, 99),
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "En individuell skriftlig vårdplan, kallad Min vårdplan, ska tas fram för varje patient med cancer enligt den  Nationella Cancerstrategin (SOU 2009:11).",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc03) <- "nkbcind"

filter_nkbc03_pop <- nkbc03$filter_pop
mutate_nkbc03_outcome <- nkbc03$mutate_outcome
