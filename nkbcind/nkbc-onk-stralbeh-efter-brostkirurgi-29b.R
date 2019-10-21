nkbc29b <- list(
  code = "nkbc29b",
  lab = "Strålbehandling efter bröstkirurgi",
  pop = "fall opererade med bröstkirurgi och utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      year(a_diag_dat) >= 2012,

      # Opererade med bröstkirurgi (fall med enbart axillkirurgi exkluderade)
      op_kir_brost_Varde %in% c(1, 2, 4),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Varde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      d_pn = factor(
        case_when(
          op_pad_lglmetant == 0 ~ "Nej (pN-)",
          (op_pad_snmakrometant == 0 & op_pad_snmikrometant > 0 & op_pad_lglmetant == op_pad_snmikrometant) %in% TRUE ~ "Enbart mikrometastas",
          op_pad_lglmetant > 0 & op_pad_lglmetant <= 3 ~ "1-3 metastaser",
          op_pad_lglmetant >= 4 ~ "=> 4 metastaser",
          TRUE ~ "Uppgift saknas"
        ),
        levels = c("Nej (pN-)", "Enbart mikrometastas", "1-3 metastaser", "=> 4 metastaser", "Uppgift saknas")
      ),
      d_op_kir_brost_kat = factor(
        case_when(
          op_kir_brost_Varde %in% 1 ~ 1L,
          op_kir_brost_Varde %in% c(2, 4) ~ 2L,
          TRUE ~ NA_integer_
        ),
        levels = c(1, 2),
        labels = c("Partiellt mastektomi", "Mastektomi")
      ),
      outcome = as.logical(post_rt_Varde)
    )
  },
  sjhkod_var = "post_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv", "d_pn", "d_prim_beh", "d_op_kir_brost_kat"),
  om_indikatorn = NULL,
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc29b) <- "nkbcind"

filter_nkbc2b_pop <- nkbc29b$filter_pop
mutate_nkbc29b_outcome <- nkbc29b$mutate_outcome
