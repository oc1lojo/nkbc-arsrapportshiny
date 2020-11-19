app_dirs <- c(
  list.dirs(path = "sv", recursive = FALSE),
  list.dirs(path = "en", recursive = FALSE)
)

n_apps <- length(app_dirs)

for (i in 1:n_apps) {
  cat(paste0("Publicerar (", i, "/", n_apps, "): ", app_dirs[i], "...\n"))

  suppressMessages(
    suppressWarnings(
      rsconnect::deployApp(
        appDir = app_dirs[i],
        # Namngivningskonvention: register_språk_app
        appName = paste(
          c("brostcancer", unlist(strsplit(app_dirs[i], split = .Platform$file.sep))),
          collapse = "_"
        ),
        logLevel = "quiet",
        forceUpdate = TRUE
      )
    )
  )
}

# Lista alla publicerade webbapplikationer
# rsconnect::applications()
