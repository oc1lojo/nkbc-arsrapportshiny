nkbc03_def <- list(
  code = "nkbc03",
  lab = "Individuell vårdplan (Min Vårdplan) har upprättats i samråd med patienten",
  lab_short = "Min vårdplan",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x,
      # min vp tillkom mitten av 2014
      year(a_diag_dat) >= 2015
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      # Hantera missing
      outcome = as.logical(ifelse(a_omv_indivplan_Värde %in% c(0, 1), a_omv_indivplan_Värde, NA))
    )
  },
  target_values = c(80, 95),
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "En individuell skriftlig vårdplan, kallad Min vårdplan, ska tas fram för varje patient med cancer enligt den  Nationella Cancerstrategin (SOU 2009:11).",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

filter_nkbc03_pop <- nkbc03_def$filter_pop
mutate_nkbc03_outcome <- nkbc03_def$mutate_outcome
