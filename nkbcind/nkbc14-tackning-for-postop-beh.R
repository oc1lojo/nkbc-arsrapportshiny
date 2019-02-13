nkbc14_def <- list(
  code = "nkbc14",
  lab = "Täckningsgrad för rapportering av postoperativ onkologisk behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      year(a_diag_dat) >= 2012,

      # Endast opererade
      !is.na(op_kir_dat),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = ifelse(!is.na(post_inr_dat) | !is.na(post_inr_enh) | !is.na(post_inr_initav), TRUE, FALSE)
    )
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
