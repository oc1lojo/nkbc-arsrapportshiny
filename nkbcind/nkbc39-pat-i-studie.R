nkbc39_def <- list(
  code = "nkbc39",
  lab = "Patienten ingår i studie",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      period >= 2012,

      # Endast opererade
      !is.na(op_kir_dat),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      # Hantera missing
      a_beh_studie = as.logical(ifelse(a_beh_studie_Värde %in% c(0, 1), a_beh_studie_Värde, NA)),
      pre_beh_studie = as.logical(ifelse(pre_beh_studie_Värde %in% c(0, 1), pre_beh_studie_Värde, NA)),
      post_beh_studie = as.logical(ifelse(post_beh_studie_Värde %in% c(0, 1), post_beh_studie_Värde, NA)),
      # Beräkna indikator
      outcome =
        case_when(
          a_beh_studie | pre_beh_studie | post_beh_studie ~ TRUE,
          !a_beh_studie | !pre_beh_studie | !post_beh_studie ~ FALSE
        )
    )
  },
  sjhkod_var = "post_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn =
    paste(
      "Ett övergripande mål är att erbjuda alla bröstcancerpatienter medverkan i studier för att utveckla nya behandlingar och arbetssätt.",
      "Indikatorn gäller alla typer av studier (t.ex. kliniska studier, omvårdnadsstudier, fysioterapi-studier).",
      "Indikatorn infördes 2017 och bör tolkas med försiktighet (regionala skillnader och underrapportering)."
    ),
  vid_tolkning = NULL,
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc39_pop <- nkbc39_def$filter_pop
mutate_nkbc39_outcome <- nkbc39_def$mutate_outcome
