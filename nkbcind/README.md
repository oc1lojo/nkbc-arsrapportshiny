
<!-- README.md är genererad från README.Rmd. Vänligen redigera den filen. -->

# nkbcind

Planen är att lägga material för beräkning av kvalitetsindikatorer för
NKBC här.

Den långsiktiga planen är att skapa ett R-paket.

Visionen är att detta R-paket kommer vara en **central** plats för
definition, implementering och dokumentation av beräkning av
kvalitetsindikatorer för NKBC i **alla** utdata-kanaler.

  - Planerad använding på INCA
      - NKBC Koll på läget (KPL), med R-paketet
        [rccKPL](https://bitbucket.org/cancercentrum/rcckpl)
      - NKBC Vården i siffror, med R-paketet
        [incavis](https://bitbucket.org/cancercentrum/incavis)
      - NKBC onlinerapporter innanför inloggning på INCA (snart med
        R-paketet
        [rccShiny](https://bitbucket.org/cancercentrum/rccshiny))
  - Planerad använding lokalt på RCC Stockholm-Gotland
      - Framtagande av NKBC Interaktiv Årsrapport med R-paketet
        [rccShiny](https://bitbucket.org/cancercentrum/rccshiny)
          - <https://bitbucket.org/cancercentrum/nkbc-arsrapportshiny>

Jfr
<https://www.cancercentrum.se/samverkan/vara-uppdrag/statistik/kvalitetsregisterstatistik/>

## Installation

``` r
# install.packages("devtools")
# devtools::install_bitbucket("cancercentrum/nkbcind") # inte implementerad än
```

## Användning

``` r
library(dplyr)
library(tidyr)
library(lubridate)

# library(nkbcgeneral) # inte implementerat än
for (file_name in list.files(file.path("..", "nkbcgeneral"), pattern = "*.R$")) {
  source(file.path("..", "nkbcgeneral", file_name), encoding = "UTF-8")
}

# library(nkbcind) # inte implementerat än
for (file_name in list.files(pattern = "*.R$")) {
  source(file_name, encoding = "UTF-8")
}
```

TODO Lägg till exempel.

Tills vidare:

  - För att skapa en Shiny-rapport så börjar jag alltså med allmän
    bearbetning av NKBC-data för att sedan skapa själva
    Shiny-rapporterna,
    <https://bitbucket.org/cancercentrum/nkbc-arsrapportshiny/src/develop/main.R>
  - …som använder definitionen (här nkbc01 som exempel)
    <https://bitbucket.org/cancercentrum/nkbc-arsrapportshiny/src/develop/nkbcind/nkbc01-diag-screening.R>
  - …och metoderna  
    <https://bitbucket.org/cancercentrum/nkbc-arsrapportshiny/src/develop/nkbcind/nkbcind-methods.R>
