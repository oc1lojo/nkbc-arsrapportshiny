nkbc13_def <- list(
  code = "nkbc13",
  lab = "Täckningsgrad för rapportering av preoperativ onkologisk behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling",
  pop_short = "fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      year(a_diag_dat) >= 2012,

      # Endast opererade
      !is.na(op_kir_dat),

      # Endast preoponk behandling (planerad om utförd ej finns)
      d_prim_beh_Värde == 2,

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = ifelse(!is.na(pre_inr_dat) | !is.na(pre_inr_enh) | !is.na(pre_inr_initav), TRUE, FALSE)
    )
  },
  target_values = c(70, 85),
  sjhkod_var = "d_onkpreans_sjhkod",
  om_indikatorn = "Rapportering av given onkologisk behandling sker på ett eget formulär till kvalitetsregistret, separat från anmälan. Rapporteringen sker cirka 1 - 1,5 år efter anmälan.",
  vid_tolkning = NULL,
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc13_pop <- nkbc13_def$filter_pop
mutate_nkbc13_outcome <- nkbc13_def$mutate_outcome
