add_sjhdata <- function(x, sjukhuskoder = sjukhuskoder, sjhkod_var) {
  names(x)[names(x) == sjhkod_var] <- "sjhkod"

  x %>%
    mutate(sjhkod = as.integer(sjhkod)) %>%
    left_join(sjukhuskoder, by = c("sjhkod" = "sjukhuskod")) %>%
    mutate(
      region = case_when(
        region_sjh_txt == "Sthlm/Gotland" ~ 1L,
        region_sjh_txt == "Uppsala/Örebro" ~ 2L,
        region_sjh_txt == "Sydöstra" ~ 3L,
        region_sjh_txt == "Syd" ~ 4L,
        region_sjh_txt == "Väst" ~ 5L,
        region_sjh_txt == "Norr" ~ 6L,
        TRUE ~ NA_integer_
      ),
      region = ifelse(is.na(region), d_region_lkf, region),
      landsting = substr(sjhkod, 1, 2) %>% as.integer(),
      # Fulfix Bröstmottagningen, Christinakliniken Sh & Stockholms bröstklinik så hamnar i Stockholm
      landsting = if_else(
        sjhkod %in% c(97333, 97563), 10L, landsting
      ),
      landsting = if_else(
        landsting %in% c(
          seq(10, 13),
          seq(21, 28),
          30,
          seq(41, 42),
          seq(50, 57),
          seq(61, 65)
          # seq(91,96)
        ),
        landsting,
        NA_integer_
      )
    )
}
