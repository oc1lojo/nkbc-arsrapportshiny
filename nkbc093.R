######################################################
# Project: Årsrapport
NAME <- "nkbc093"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated: se git 
######################################################


# Population - Invasivitet ------------------------------------------------
GLOBALS <- defGlobals(LAB = "Invasivitet vid diagnos",
                      SHORTLAB = "Invasivitet",
                      POP = "alla anmälda fall.",
                      SJHKODUSE <- "a_inr_sjhkod"
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = invasiv
  ) %>%
  filter(
    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, invasiv)


link <- rccShiny(
  data = dftemp,
  folder = NAME,
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    "Invasiv cancer innebär att cancercellerna infiltrerar i bröstkörtelns stödjevävnad och kan sprida sig via lymfsystemet eller blodbanan till andra organ. Cancer in situ (CIS),  ett förstadium till bröstcancer, innebär att cancercellerna ligger inuti bröstets utförsgångar och  körtlar. CIS kan inte spridas, det vill säga ge upphov till fjärrmetastaser.", 
    descTolk, 
    descTekBes()
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  )
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))