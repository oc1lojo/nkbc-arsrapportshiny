nkbc39_def <- list(
  code = "nkbc39",
  lab = "Patienten ingår i studie",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
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
