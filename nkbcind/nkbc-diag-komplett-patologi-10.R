nkbc10 <- list(
  code = "nkbc10",
  lab = "Fullständig patologirapport (Grad, ER, PR, HER2, Ki67)",
  lab_short = "Fullständig patologirapport",
  pop = "primärt opererade fall med invasiv cancer utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Endast opererade
      !is.na(op_kir_dat),

      # Endast primär opereration (planerad om utförd ej finns)
      d_prim_beh_Varde == 1,

      # Endast invasiv cancer
      d_invasiv == "Invasiv cancer",

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Varde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      d_op_nhgok = op_pad_nhg_Varde %in% c(1, 2, 3),
      d_op_erok = op_pad_er_Varde %in% c(1, 2) | !is.na(op_pad_erproc),
      d_op_prok = op_pad_pr_Varde %in% c(1, 2) | !is.na(op_pad_prproc),
      d_op_herok = op_pad_her2_Varde %in% c(1, 2, 3) | op_pad_her2ish_Varde %in% c(1, 2),
      # Ki67 tillkom som nationell variabel 2014
      d_op_ki67ok = (op_pad_ki67_Varde %in% c(1, 2, 3) | !is.na(op_pad_ki67proc)) | period <= 2013,

      outcome = d_op_nhgok & d_op_erok & d_op_prok & d_op_herok & d_op_ki67ok
    )
  },
  target_values = c(95, 98),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Patologirapporten grundas i mikroskopiska vävnadsanalyser. Biomarkörerna etablerar grunden till den onkologiska behandlingen av bröstcancer (endokrin-, cytostatika-  eller antikroppsbehandling).",
  vid_tolkning = "Ki67 tillkom som nationell variabel 2014 och ingår ej i beräkning innan detta datum.",
  teknisk_beskrivning = NULL
)
class(nkbc10) <- "nkbcind"

filter_nkbc10_pop <- nkbc10$filter_pop
mutate_nkbc10_outcome <- nkbc10$mutate_outcome
