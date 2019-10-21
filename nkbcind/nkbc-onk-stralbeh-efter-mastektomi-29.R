nkbc29 <- list(
  code = "nkbc29",
  lab = "Strålbehandling efter mastektomi",
  pop = "invasiva fall med spridning till lymfkörtlarna (fall med enbart mikrometastas exkluderade) och utan fjärrmetastaser vid diagnos, opererade med mastektomi",
  pop_short = "invasiva fall med mastektomi, spridning till lymfkörtlarna och utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      year(a_diag_dat) >= 2012,

      # Endast invasiv cancer
      d_invasiv == "Invasiv cancer",

      # Endast mastektomi och subkutan mastektomi
      op_kir_brost_Varde %in% c(2, 4),

      # Spridning till lymfkörtlar
      op_pad_lglmetant > 0,

      # Ej fall med endast mikrometastas
      !((op_pad_snmakrometant == 0 & op_pad_snmikrometant > 0 & op_pad_lglmetant == op_pad_snmikrometant) %in% TRUE),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Varde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = as.logical(post_rt_Varde)
    )
  },
  target_values = c(70, 85),
  sjhkod_var = "post_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_pn"),
  om_indikatorn =
    paste(
      "Då hela bröstet opereras bort (mastektomi) behövs ofta inte strålbehandling.",
      "Vid spridning till lymfkörtlarna (makrometastas) bör dock strålbehandling ges både mot bröstkorgsvägg och lymfkörtlar.",
      "Lokoregional strålbehandling rekommenderas inte vid endast mikrometastas."
    ),
  vid_tolkning =
    "Spridning till lymfkörtlar är definerat som metastas > 0.2 mm i axillen (fall med enbart mikrometastas är exkluderade).",
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)
class(nkbc29) <- "nkbcind"

filter_nkbc29_pop <- nkbc29$filter_pop
mutate_nkbc29_outcome <- nkbc29$mutate_outcome
