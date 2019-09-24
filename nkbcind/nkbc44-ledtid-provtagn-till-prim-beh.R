nkbc44 <- list(
  code = "nkbc44",
  lab = "Provtagningsdatum  till primär behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,

      # Endast opererade
      !is.na(op_kir_dat),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      d_pre_onk_dat = pmin(ymd(pre_kemo_dat),
        ymd(pre_rt_dat),
        ymd(pre_endo_dat),
        na.rm = TRUE
      ),
      d_prim_beh_dat = case_when(
        d_prim_beh_Värde == 1 ~ ymd(op_kir_dat),
        d_prim_beh_Värde == 2 ~ d_pre_onk_dat,
        TRUE ~ ymd(NA_character_)
      ),
      outcome = as.numeric(d_prim_beh_dat - ymd(a_diag_dat)),
      outcome = ifelse(outcome < 0, 0, outcome)
    )
  },
  prop_within_value = 28,
  sjhkod_var = "d_prim_beh_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv", "d_prim_beh"),
  om_indikatorn = NULL,
  vid_tolkning = NULL,
  inkl_beskr_missca = TRUE,
  teknisk_beskrivning = NULL
)
class(nkbc44) <- "nkbcind"

filter_nkbc44_pop <- nkbc44$filter_pop
mutate_nkbc44_outcome <- nkbc44$mutate_outcome
