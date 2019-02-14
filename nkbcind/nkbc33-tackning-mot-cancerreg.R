nkbc33 <- list(
  code = "nkbc33",
  lab = "Täckningsgrad mot cancerregistret",
  pop = "alla anmälda fall",
  target_values = c(95, 99),
  sjhkod_var = "a_inr_sjhkod",
  om_indikatorn = "Anmälan till cancerregistret och anmälan till kvalitetsregistret är kombinerade och därmed undviks dubbelarbete.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc33) = c("nkbc33", "nkbcind")
