# ---------------------------------------------------------
#                NON-EXPORTED HELPERS
# ---------------------------------------------------------

# MAPS
# ----
.map_chr <- function(x, fun, ...) {
  vapply(X = x, FUN = fun, FUN.VALUE = character(1), ...)
}

.map_int <- function(x, fun, ...) {
  vapply(X = x, FUN = fun, FUN.VALUE = integer(1), ...)
}

.map_dbl <- function(x, fun, ...) {
  vapply(X = x, FUN = fun, FUN.VALUE = double(1), ...)
}

.map_lgl <- function(x, fun, ...) {
  vapply(X = x, FUN = fun, FUN.VALUE = logical(1), ...)
}


# SETS
# ----
neq_null <- function(x) !is.null(x)

eq_empt_chr <- function(x) identical(x, character(0))
'%ni%' <- Negate('%in%')

# ASSERTERS
# ---------
is_scalar <- function(x) {
  is.atomic(x) && length(x) == 1L && (inherits(x, "numeric") || inherits(x, "integer"))
}


is_non_empty_vector_chr <- function(x) {
  is.vector(x, mode = "character") && length(x) > 0L
}

is_named_list <- function(x) {
  if (is.null(names(x))) return(FALSE)
  if ("" %in% names(x)) {
    return(FALSE) 
  } else {
    return(TRUE)
  }
}

