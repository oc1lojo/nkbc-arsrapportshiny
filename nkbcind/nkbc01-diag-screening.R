nkbc01 <- list(
  code = "nkbc01",
  lab = "Screeningupptäckt bröstcancer",
  pop = "kvinnor i åldrarna 40-74 år vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Ålder 40-74 år vid diagnos
      a_pat_alder <= 74,
      a_pat_alder >= 40,

      # Enbart kvinnor
      KON_VALUE == 2
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      # Hantera missing
      outcome = as.logical(ifelse(a_diag_screening_Värde %in% c(0, 1), a_diag_screening_Värde, NA))
    )
  },
  target_values = c(60, 70),
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Mammografiscreening erbjuds alla kvinnor mellan 40–74 år.",
  vid_tolkning =
    c(
      paste(
        "Definitionen av \"screeningupptäckt fall\" kan enligt erfarenhet tolkas olika vilket kan påverka siffrorna.",
        "Enligt kvalitetsregistret avses enbart de fall som diagnostiserats i samband med en kallelse till den landstingsorganiserade screeningmammografin."
      ),
      "Det finns en osäkerhet avseende andel screeningupptäckta fall då det på vissa orter bara finns en mammografienhet som både utför screening och klinisk mammografi."
    ),
  teknisk_beskrivning = NULL
)
class(nkbc01) = "nkbcind"

filter_nkbc01_pop <- nkbc01$filter_pop
mutate_nkbc01_outcome <- nkbc01$mutate_outcome
