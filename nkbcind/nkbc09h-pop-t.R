nkbc09h <- list(
  code = "nkbc09h",
  lab = "Tumörstorlek",
  pop = "primärt opererade invasiva fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Enbart primärt opererade
      !is.na(op_kir_dat),
      d_prim_beh_Värde %in% 1,

      # Enbart invasiv cancer
      d_invasiv == "Invasiv cancer",

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = op_pad_invstl
    )
  },
  prop_within_unit = "mm",
  prop_within_value = 20,
  sjhkod_var = "op_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = '<mark>TBA. [Denna rapport baseras på variabeln op_pad_invstl, se variabelbeskrivningen på <a href="https://www.cancercentrum.se/stockholm-gotland/cancerdiagnoser/brost/kvalitetsregister/dokument/">https://www.cancercentrum.se/stockholm-gotland/cancerdiagnoser/brost/kvalitetsregister/dokument/</a>]</mark>',
  vid_tolkning = "<mark>TBA</mark>",
  teknisk_beskrivning = NULL
)
class(nkbc09h) <- "nkbcind"

filter_nkbc09h_pop <- nkbc09h$filter_pop
mutate_nkbc09h_outcome <- nkbc09h$mutate_outcome
