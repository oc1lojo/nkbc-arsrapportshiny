nkbc10_def <- list(
  code = "nkbc10",
  lab = "Fullständig patologirapport (Grad, ER, PR, HER2, Ki67)",
  lab_short = "Fullständig patologirapport",
  pop = "primärt opererade fall med invasiv cancer utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = c(95, 98),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Patologirapporten grundas i mikroskopiska vävnadsanalyser. Biomarkörerna etablerar grunden till den onkologiska behandlingen av bröstcancer (endokrin-, cytostatika-  eller antikroppsbehandling).",
  vid_tolkning = "Ki67 tillkom som nationell variabel 2014 och ingår ej i beräkning innan detta datum.",
  teknisk_beskrivning = NULL
)

filter_nkbc10_pop <- nkbc10_def$filter_pop
mutate_nkbc10_outcome <- nkbc10_def$mutate_outcome
