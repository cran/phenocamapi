#' Downloading the midday images for PhenoCam sites given a time range
#'
#' @param site a character string, the PhenoCam site name
#' @param y integer numeric, the year for which midday images are downloaded
#' @param months a vector of integer numeric, months for which midday images are downloaded
#' @param days a vector of integer numeric, days for which midday images are downloaded
#' @param download_dir a character string, path to directory where images are downloaded
#' @return a character string, path to directory where images are downloaded
#' @import RCurl
#' @export
#' @examples
#'
#' download_dir <- download_midday_images('dukehw',
#'  y = 2018,
#'  months = 2,
#'  days=1,
#'  download_dir= tempdir())
#'
download_midday_images <- function(site, y = year(Sys.Date()), months = 1, days=1, download_dir){
  midday_list <- get_midday_list(site)
  midday_table <- parse_phenocam_filenames(midday_list)

  download_list <- midday_table[Year==y&Month%in%months&Day%in%days, filepaths]

  n <- length(download_list)

  if(n==0) {
    warning('no files to download!')
    return(NULL)
  }

  if(!dir.exists(download_dir)){
    dir.create(download_dir)
    message('directory ', download_dir, ' was created!')
  }

  pb <- txtProgressBar(0, n , style = 3)
  for(i in 1:n){
    destfile <- paste0(download_dir, '/', basename(download_list[i]))
    download.file(download_list[i], destfile = destfile, quiet = TRUE)
    setTxtProgressBar(pb, i)
  }

  download_dir
}

