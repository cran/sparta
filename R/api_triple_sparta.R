# #' Construct sparta object
# #'
# #' Helper function to construct a sparta object with given values and dim names
# #' 
# #' @param x matrix where columns represents cells in an array-like object
# #' @param vals vector of values corresponding to x
# #' @param dim_names a named list
# #' @param B Character vector of unity variables
# #' @param gamma Numeric
# #' @return A sparta triple object
# #' @examples
# #' @export
# sparta_struct_triple <- function(x, vals, dim_names, B, gamma) {
#   cond <- inherits(x, "matrix") &&
#     inherits(vals, "numeric")   &&
#     ncol(x) == length(vals)     &&
#     length(dim_names) == nrow(x)
#   stopifnot(cond)
#   storage.mode(x) <- "integer"
#   rownames(x) <- names(dim_names)
#   phi <- structure(x, vals = vals, dim_names = dim_names, class = c("sparta", "matrix"))
#   trip <- list(phi = phi, B = B, gamma = gamma)
# }


# Define mult, div, marg etc. on these
