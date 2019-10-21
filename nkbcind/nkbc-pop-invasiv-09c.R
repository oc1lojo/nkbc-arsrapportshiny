nkbc09c <- list(
  code = "nkbc09c",
  lab = "Invasivitet vid diagnos",
  lab_short = "Invasivitet",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = d_invasiv
    )
  },
  sjhkod_var = "a_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Invasiv cancer innebär att cancercellerna infiltrerar i bröstkörtelns stödjevävnad och kan sprida sig via lymfsystemet eller blodbanan till andra organ. Cancer in situ (CIS),  ett förstadium till bröstcancer, innebär att cancercellerna ligger inuti bröstets utförsgångar och  körtlar. CIS kan inte spridas, det vill säga ge upphov till fjärrmetastaser.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc09c) <- "nkbcind"

filter_nkbc09c_pop <- nkbc09c$filter_pop
mutate_nkbc09c_outcome <- nkbc09c$mutate_outcome
