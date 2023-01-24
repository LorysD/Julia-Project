padding <- function(image, filter, color) {
  filter_size <- dim(filter)[1]
  size_padding <- (filter_size - 1) / 2
  if (color) {
    padded_image <- array(0, dim(image) + c(filter_size - 1, filter_size - 1, 0))
    padded_image[1:dim(image)[1] + size_padding, 1:dim(image)[2] + size_padding, ] <- image
  } else {
    padded_image <- array(0, dim(image) + filter_size - 1)
    padded_image[1:dim(image)[1] + size_padding, 1:dim(image)[2] + size_padding] <- image
  }
  return(padded_image)
}

transform_pixel <- function(i, j, padded_image, filter, color) {
  size_padding <- (dim(filter)[1] - 1) / 2
  i1 <- i - size_padding
  i2 <- i + size_padding
  j1 <- j - size_padding
  j2 <- j + size_padding
  if (color) {
    img_piece <- c()
    for (col in 1:dim(padded_image)[3]) {
      img_piece <- c(img_piece,
                     sum(padded_image[i1:i2, j1:j2, col] * filter))
    }
    return(img_piece)
  } else {
    return(sum(padded_image[i1:i2, j1:j2] * filter))
  }
}

conv <- function(image, filter) {
  start_time <- Sys.time()
  color <- length(dim(image)) == 3
  transformed_image <- image
  padded_image <- padding(image, filter, color)
  size_padding <- (dim(filter)[1] - 1) / 2
  for (i in 1:dim(image)[1]) {
    i_lag <- i + size_padding
    for (j in 1:dim(image)[2]) {
      j_lag <- j + size_padding
      transformed_pixel <- transform_pixel(i_lag, j_lag, padded_image, filter, color)
      if (color) {
        transformed_image[i, j, ] <- transformed_pixel
      } else {
        transformed_image[i, j] <- transformed_pixel
      }
    }
  }
  return(list(transformed_image, as.numeric(Sys.time() - start_time)))
}
