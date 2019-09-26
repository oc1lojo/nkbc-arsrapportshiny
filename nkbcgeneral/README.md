
<!-- README.md är genererad från README.Rmd. Vänligen redigera den filen. -->

# nkbcgeneral

Planen är att lägga generella verktyg för bearbetning av NKBC-data här.

Den långsiktiga planen är att skapa ett R-paket.

Visionen är att detta R-paket kommer vara en **central** plats för
definition, implementering och dokumentation av generell bearbetning av
NKBC-data i **alla** utdata-kanaler.

  - Planerad använding på INCA
      - NKBC Koll på läget (KPL), med R-paketet
        [rccKPL](https://bitbucket.org/cancercentrum/rcckpl)
      - NKBC Vården i siffror, med R-paketet
        [incavis](https://bitbucket.org/cancercentrum/incavis)
      - NKBC onlinerapporter innanför inloggning på INCA (snart med
        R-paketet
        [rccShiny](https://bitbucket.org/cancercentrum/rccshiny))
  - Planerad använding lokalt på RCC Stockholm-Gotland
      - Framtagande av NKBC Interaktiva Årsrapport med R-paketet
        [rccShiny](https://bitbucket.org/cancercentrum/rccshiny)
          - <https://bitbucket.org/cancercentrum/nkbc-arsrapportshiny>
      - Datauttagsärenden inom NKBC
          - jfr
            <https://www.cancercentrum.se/samverkan/vara-uppdrag/kunskapsstyrning/kvalitetsregister/datauttag/>
      - Andra sammanställningar

Jfr
<https://www.cancercentrum.se/samverkan/vara-uppdrag/statistik/kvalitetsregisterstatistik/>

## Installation

``` r
# install.packages("devtools")
# devtools::install_bitbucket("cancercentrum/nkbcgeneral") # inte implementerad än
```

## Användning

``` r
library(dplyr)
library(tidyr)
library(lubridate)

# library(nkbcgeneral) # inte implementerat än
for (file_name in list.files(pattern = "*.R$")) {
  source(file_name, encoding = "UTF-8")
}
```

Läs in ögonblickskopia av NKBC exporterad från INCA.

``` r
load(
  unzip(
    file.path(Sys.getenv("BRCA_DATA_DIR"), "2019-09-02", "nkbc_nat_id 2019-09-02 09-02-35.zip"),
    exdir = tempdir()
  )
)
```

Generell förbearbetning av NKBC-data.

``` r
df_main <- df %>%
  mutate_if(is.factor, as.character) %>%
  clean_nkbc_data() %>%
  mutate_nkbc_d_vars()
```
