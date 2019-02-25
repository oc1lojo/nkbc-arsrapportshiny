df_tmp <- data.frame(
  region = c(
    rep(tackning_tbl$region, tackning_tbl$finns),
    rep(tackning_tbl$region, tackning_tbl$ejfinns)
  ),
  period = c(
    rep(tackning_tbl$ar, tackning_tbl$finns),
    rep(tackning_tbl$ar, tackning_tbl$ejfinns)
  ),
  outcome = c(
    rep(rep(TRUE, dim(tackning_tbl)[1]), tackning_tbl$finns),
    rep(rep(FALSE, dim(tackning_tbl)[1]), tackning_tbl$ejfinns)
  )
)

rccShiny(
  data = df_tmp,
  folder = code(nkbc33),
  path = output_path,
  outcomeTitle = lab(nkbc33),
  textBeforeSubtitle = textBeforeSubtitle(nkbc33),
  description = description(nkbc33, report_end_year),
  varOther = varOther(nkbc33),
  targetValues = target_values(nkbc33)
)
