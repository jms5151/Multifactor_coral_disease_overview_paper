library(curl)

list_ftp_files <- function(ftp_path){
  # list files
  list_files <- curl::new_handle()
  curl::handle_setopt(list_files, ftp_use_epsv = TRUE, dirlistonly = TRUE)
  con <- curl::curl(url = ftp_path, "r", handle = list_files)
  files <- readLines(con)
  close(con)
  files
}
