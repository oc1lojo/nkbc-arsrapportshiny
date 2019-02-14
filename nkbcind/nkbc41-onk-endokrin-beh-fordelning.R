nkbc41 <- list(
  code = "nkbc41",
  lab = "Endokrin behandling, pre- respektive postoperativt",
  pop = "opererade östrogenreceptorpositiva invasiva fall utan fjärrmetastaser vid diagnos",
  pop_short = "opererade ER+ invasiva fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      period >= 2012,

      # Endast opererade
      !is.na(op_kir_dat),

      # Endast invasiv cancer
      d_invasiv == "Invasiv cancer",

      # ER+
      d_er_Värde == 1,

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      # Pre eller postoperativ
      outcome = factor(
        case_when(
          post_endo_Värde == 1 & pre_endo_Värde == 1 ~ 1,
          pre_endo_Värde == 1 ~ 0,
          post_endo_Värde == 1 ~ 2,
          post_endo_Värde == 0 | pre_endo_Värde == 0 ~ 3
        ),
        levels = c(0, 1, 2, 3),
        labels = c(
          "Enbart preoperativ",
          "Både pre-och postoperativ",
          "Enbart postoperativ",
          "Ingen"
        )
      )
    )
  },
  sjhkod_var = "d_onk_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Den aktuella tabellen presenterar andelen fall som fått preoperativ respektive postoperativ endokrin behandling eller bägge.",
  vid_tolkning = "Här presenteras data för påbörjad behandling. Det finns studier som visar att ca 70% av patienterna stoppar eller gör längre avbrott i sin endokrinabehandling i huvudsak p.g.a. biverkningar.",
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)
class(nkbc41) = "nkbcind"

filter_nkbc41_pop <- nkbc41$filter_pop
mutate_nkbc41_outcome <- nkbc41$mutate_outcome
