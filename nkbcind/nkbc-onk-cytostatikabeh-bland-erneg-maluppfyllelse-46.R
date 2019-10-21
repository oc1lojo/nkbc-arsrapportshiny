nkbc46 <- list(
  code = "nkbc46",
  lab = "Cytostatikabehandling, måluppfyllelse",
  pop = paste(
    "opererade östrogenreceptornegativa invasiva fall med större tumörer eller spridning till lymfkörtlar",
    "(T2-T4 eller cN+ för opererade  fall efter preoperativ onkologisk behandling, tumörstorlek > 10 mm eller pN+ för primärt opererade fall)",
    "utan fjärrmetastaser vid diagnos"
  ),
  pop_short = "opererade ER- invasiva fall med större tumörer eller spridning till lymfkörtlar utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      period >= 2012,

      # Endast opererade
      !is.na(op_kir_dat),

      # Endast invasiv cancer
      d_invasiv == "Invasiv cancer",

      # ER-
      d_er_Varde == 2,

      # större tumörer eller spridning till lymfkörtlar
      (
        # Om operation efter påbörjad/genomförd preop onk beh: T2-T4 (>20mm) eller cN+
        d_prim_beh_Varde == 2 &
          (a_tnm_tklass_Varde %in% c(20, 30, 42, 44, 45, 46) | a_tnm_nklass_Varde %in% c(10, 20, 30))
      ) | (
        # Om primär operation: tumörstorlek > 10 mm eller pN+
        d_prim_beh_Varde == 1 &
          (op_pad_invstl > 10 | op_pad_lglmetant > 0)
      ),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Varde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = case_when(
        d_prim_beh_Varde == 1 ~ as.logical(post_kemo_Varde),
        d_prim_beh_Varde == 2 ~ as.logical(pre_kemo_Varde) | post_kemo_Varde %in% 1,
        TRUE ~ NA
      )
    )
  },
  target_values = c(80, 90),
  sjhkod_var = "d_onk_sjhkod",
  other_vars = c("a_pat_alder", "d_prim_beh"),
  om_indikatorn = "Pre- eller postoperativ cytostatikabehandling rekommenderas i allmänhet vid bröstcancer med spridning till axillens lymfkörtlar, men även utan lymfkörtelengagemang om tumören har svag hormonell känslighet och/eller då det föreligger riskfaktorer.",
  vid_tolkning = NULL,
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)
class(nkbc46) <- "nkbcind"

filter_nkbc46_pop <- nkbc46$filter_pop
mutate_nkbc46_outcome <- nkbc46$mutate_outcome
