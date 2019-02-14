nkbc26 <- list(
  code = "nkbc26",
  lab = "Sentinel node operation",
  pop = "invasiva fall utan spridning till lymfkörtlar (klinisk diagnos) eller fjärrmetastaser vid diagnos",
  pop_short = "invasiva fall utan spridning till lymfkörtlar eller fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Endast invasiv cancer
      d_invasiv == "Invasiv cancer",

      # Klinisk N0
      a_tnm_nklass_Värde == 0,

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = case_when(
        op_kir_axilltyp_Värde == 1 ~ 1L,
        op_kir_axilltyp_Värde == 2 ~ 0L,
        op_kir_axilltyp_Värde == 3 ~ 1L,
        op_kir_axilltyp_Värde == 4 ~ 0L,
        op_kir_axilltyp_Värde == 98 ~ NA_integer_,
        TRUE ~ NA_integer_
      ),
      outcome = as.logical(ifelse(op_kir_axill_Värde %in% 0, 0, outcome))
    )
  },
  target_values = c(90, 95),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn =
    paste(
      "Kännedom om tumörspridning till axillens lymfkörtlar vägleder behandlingsrekommendationer.",
      "Sentinelnodetekniken minskar risken för armbesvär då endast ett fåtal (1–4) körtlar tas bort."
    ),
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc26) = "nkbcind"

filter_nkbc26_pop <- nkbc26$filter_pop
mutate_nkbc26_outcome <- nkbc26$mutate_outcome
