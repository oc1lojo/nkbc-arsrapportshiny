NAME <- "nkbc09g2"
nkbc09g <- list(
  code = "nkbc09g",
  lab = "Spridning till lymfkörtlarna vid operation",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Enbart opererade
      !is.na(op_kir_dat),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = d_pnstat
    )
  },
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn =
    paste(
      "Kännedom om tumörspridning till axillens lymfkörtlar ger prognostisk information inför val av postoperativ onkologisk behandling.",
      "Bedömning av tumörspridning till axillens lymfkörtlar görs baserad på mikroskopisk analys av sentinel node och/eller övriga lymfkörtlar i axillen."
    ),
  vid_tolkning =
    c(
      "I populationen ingår både primärt opererade och opererade efter påbörjad/genomförd preoperativ onkologisk behandling.",
      "Spridning till lymfkörtlar är definerat som metastas > 0.2 mm i axillen."
    ),
  teknisk_beskrivning = NULL
)
class(nkbc09g) <- "nkbcind"

filter_nkbc09g_pop <- nkbc09g$filter_pop
mutate_nkbc09g_outcome <- nkbc09g$mutate_outcome
