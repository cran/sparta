#' Classes that can be converted to sparta
#'
#' A non-argument function, that outputs the classes
#' that can be converted to a sparta object
#' 
#' @export
allowed_class_to_sparta <- function() {
  c(.map_chr(utils::methods("as_sparta"), function(generic) sub("as_sparta.", "", generic)))  
}

#' Sparta Ones
#'
#' Construct a sparta object filled with ones
#'
#' @param dim_names A named list of discrete levels
#' @return A sparta object
#' @examples
#' sparta_ones(list(a = c("a1", "a2"), b = c("b1", "b2")))
#' @export
sparta_ones <- function(dim_names) {
  dim_ <- .map_int(dim_names, length)
  utab <- array(1L, dim_, dim_names) # Expensive?
  as_sparta(utab)
}

#' Sparse unity table
#'
#' Construct a sparse table of ones
#'
#' @param dim_names A named list of discrete levels
#' @param rank The value of each element. Default is \code{1}.
#' @return A sparta object
#' @examples
#' s <- sparta_unity_struct(list(a = c("a1", "a2"), b = c("b1", "b2")), rank = 1)
#' mult(s, 2)
#' @export
sparta_unity_struct <- function(dim_names, rank = 1L) {
  stopifnot(is_scalar(rank))
  structure(
    matrix(nrow = 0L, ncol = 0L),
    vals = rank, # vector("numeric", length = 0L),
    dim_names = dim_names,
    class = c("sparta_unity", "sparta", "matrix")
  )
}

#' Construct sparta object
#'
#' Helper function to construct a sparta object with given values and dim names
#' 
#' @param x matrix where columns represents cells in an array-like object
#' @param vals vector of values corresponding to x
#' @param dim_names a named list
#' @return A sparta object
#' @examples
#' x <- array(
#'   c(1,0,0,2,3,4,0,0),
#'   dim = c(2,2,2),
#'   dimnames = list(
#'     a = c("a1", "a2"),
#'     b = c("b1", "b2"),
#'     c = c("c1", "c2")
#'   )
#' )
#'
#' sx <- as_sparta(x)
#' sparta_struct(unclass(sx), vals(sx), dim_names(sx))
#' @export
sparta_struct <- function(x, vals, dim_names) {
  cond <- inherits(x, "matrix") &&
    inherits(vals, "numeric")   &&
    ncol(x) == length(vals)     &&
    length(dim_names) == nrow(x)
  stopifnot(cond)
  storage.mode(x) <- "integer"
  rownames(x) <- names(dim_names)
  structure(
    x,
    vals = vals,
    dim_names = dim_names,
    class = c("sparta", "matrix")
  )
}


#' Get value or cell name
#'
#' Find the value or the name of a cell
#'
#' @param x sparta
#' @param y named character vector or vector of cell indices
#' @examples
#' x <- array(
#'   c(1,0,0,2,3,4,0,0),
#'   dim = c(2,2,2),
#'   dimnames = list(
#'     a = c("a1", "a2"),
#'     b = c("b1", "b2"),
#'     c = c("c1", "c2")
#'   )
#' )
#'
#' sx <- as_sparta(x)
#' get_val(sx, c(a = "a2", b = "b1", c = "c2"))
#' get_cell_name(sx, sx[, 4])

#' @rdname get_val_cell
#' @export
get_val <- function(x, y) UseMethod("get_val")


#' @rdname get_val_cell
#' @export
get_val.sparta <- function(x, y) {
  
  if (is.null(names(y)) || (length(y) != length(attr(x, "dim_names")))) {
    stop("y must have names corresponding to the respective variables", call. = TRUE)
  }
  
  x_dim_names <- attr(x, "dim_names")
  y         <- y[names(x_dim_names)]
  idx       <- mapply(match, y, x_dim_names)
  
  if (anyNA(idx)) stop("some values of y are not valid.", call. = FALSE)
  if (inherits(x, "sparta_unity")) attr(x, "vals")
  
  idx_str   <- paste0(idx, collapse = "")
  idx_x     <- apply(x, 2L, paste0, collapse = "")
  which_idx <- match(idx_str, idx_x)
  if (is.na(which_idx)) {
     return(0L) 
  } else {
    return(attr(x, "vals")[which_idx])
  }
}


#' @rdname get_val_cell
#' @export
get_cell_name <- function(x, y) UseMethod("get_cell_name")


#' @rdname get_val_cell
#' @export
get_cell_name.sparta <- function(x, y) {
  if (!inherits(y, "integer")) stop("y must be an integer vector", call. = FALSE)
  structure(.map_chr(
    seq_along(dim_names(x)),
    function(i) (dim_names(x)[[i]])[y[i]]
  ), names = names(x))
}


#' Sparsity

#' @param x sparta
#' @return The ratio of \code{ncol(x)} and the total statespace of \code{x}
#' @examples
#'
#' x <- array(
#'   c(1,0,0,2,3,4,0,0),
#'   dim = c(2,2,2),
#'   dimnames = list(
#'     a = c("a1", "a2"),
#'     b = c("b1", "b2"),
#'     c = c("c1", "c2")
#'   )
#' )
#'
#' sx <- as_sparta(x)
#' sparsity(sx)
#' @export
sparsity <- function(x) UseMethod("sparsity")

#' @rdname sparsity
#' @export
sparsity.sparta <- function(x) 1 - ncol(x) / prod(.map_int(sparta::dim_names(x), length))

#' @rdname sparsity
#' @export
sparsity.sparta_unity <- function(x) 0L


#' Number of elements in a table

#' @param x sparta
#' @return The size of the sparta table \code{x}
#' @examples
#'
#' x <- array(
#'   c(1,0,0,2,3,4,0,0),
#'   dim = c(2,2,2),
#'   dimnames = list(
#'     a = c("a1", "a2"),
#'     b = c("b1", "b2"),
#'     c = c("c1", "c2")
#'   )
#' )
#'
#' sx <- as_sparta(x)
#' table_size(sx)
#' @export
table_size <- function(x) UseMethod("table_size")

#' @rdname table_size
#' @export
table_size.sparta <- function(x) prod(.map_int(sparta::dim_names(x), length))

#' Normalize

#' @param x sparta
#' @return A sparta object
#' @examples
#'
#' x <- array(
#'   c(1,0,0,2,3,4,0,0),
#'   dim = c(2,2,2),
#'   dimnames = list(
#'     a = c("a1", "a2"),
#'     b = c("b1", "b2"),
#'     c = c("c1", "c2")
#'   )
#' )
#'
#' sx <- as_sparta(x)
#' normalize(sx)
#' @export
normalize <- function(x) UseMethod("normalize")

#' @rdname normalize
#' @export
normalize.sparta <- function(x) {
  if (!inherits(x, "sparta_unity")) {
    attr(x, "vals") <- attr(x, "vals") / sum(attr(x, "vals"))
  } else {
    attr(x, "vals") <- 1 / table_size(x)
  }
  x
}

#' @rdname normalize
#' @export
normalize.numeric <- function(x) 1L

#' Equiv
#'
#' Determine if two sparta objects are equivalent
#' 
#' @param x sparta object
#' @param y sparta object
#' @return Logical. \code{TRUE} if \code{x} and \code{y} are equivalent
#' @examples
#'
#' x <- array(
#'   c(1,0,0,2,3,4,0,0),
#'   dim = c(2,2,2),
#'   dimnames = list(
#'     a = c("a1", "a2"),
#'     b = c("b1", "b2"),
#'     c = c("c1", "c2")
#'   )
#' )
#'
#' y <- array(
#'   c(2,0,0,2,3,4,0,0),
#'   dim = c(2,2,2),
#'   dimnames = list(
#'     a = c("a1", "a2"),
#'     b = c("b1", "b2"),
#'     c = c("c1", "c2")
#'   )
#' )
#' 
#' sx <- as_sparta(x)
#' sy <- as_sparta(y)
#' 
#' equiv(sx, sy)
#' equiv(sx, sx)
#'
#' @export
equiv <- function(x, y) UseMethod("equiv")

#' @rdname equiv
#' @export
equiv.sparta <- function(x, y) {
  if (!identical(dim(x), dim(y))) return(FALSE)
  if (anyNA(match(vals(x), vals(y)))) return(FALSE)
  all(apply(x, 2L, function(j) {
    cell <- get_cell_name(x, j)
    identical(get_val(x, cell), get_val(y, cell))
  }))
}

#' Sparta getters
#'
#' Getter methods for sparta objects
#' 
#' @param x sparta object

#' @rdname getter
#' @export
vals <- function(x) UseMethod("vals")

#' @rdname getter
#' @export
vals.sparta <- function(x) attr(x, "vals")

#' @rdname getter
#' @export
get_values <- function(x) UseMethod("get_values")

#' @rdname getter
get_values.sparta <- function(x) attr(x, "vals")

#' @rdname getter
#' @export
dim_names <- function(x) UseMethod("dim_names")

#' @rdname getter
#' @export
dim_names.sparta <- function(x) attr(x, "dim_names")

#' @rdname getter
#' @export
names.sparta <- function(x) names(attr(x, "dim_names"))

#' @rdname getter
#' @export
sparta_rank <- function(x) UseMethod("sparta_rank")

#' @rdname getter
#' @export
sparta_rank.sparta_unity <- function(x) attr(x, "vals")

#' Vector-like operations on sparta objects

#' @param x sparta
#' @param ... For S3 compatability.

#' @rdname vec-ops
#' @export
sum.sparta <- function(x, ...) {
  if (inherits(x, "sparta_unity")) {
    return(table_size(x) * sparta_rank(x))
  }
  sum(attr(x, "vals"))  
}

#' @rdname vec-ops
#' @export
max.sparta <- function(x, ...) {
  max(attr(x, "vals"))
}

#' @rdname vec-ops
#' @export
min.sparta <- function(x, ...) {
  min(attr(x, "vals"))
}

#' @rdname vec-ops
#' @export
which_min_cell <- function(x) UseMethod("which_min")

#' @rdname vec-ops
#' @export
which_min_cell.sparta <- function(x) {
  if (inherits(x, "sparta_unity")) {
    return(.map_chr(dim_names(x), function(z) z[1]))
  }
  idx <- x[, which.min(attr(x, "vals"))]
  mapply(
    function(a, b) a[b],
    attr(x, "dim_names"),
    idx
  )
}

#' @rdname vec-ops
#' @export
which_min_idx <- function(x) UseMethod("which_min_idx")

#' @rdname vec-ops
#' @export
which_min_idx.sparta <- function(x) {
  if (inherits(x, "sparta_unity")) return(NA)
  which.min(attr(x, "vals"))
}

#' @rdname vec-ops
#' @export
which_max_cell <- function(x) UseMethod("which_max_cell")

#' @rdname vec-ops
#' @export
which_max_cell.sparta <- function(x) {
  if (inherits(x, "sparta_unity")) {
    return(.map_chr(dim_names(x), function(z) z[1]))
  }
  idx <- x[, which.max(attr(x, "vals"))]
  mapply(
    function(a, b) a[b],
    attr(x, "dim_names"),
    idx
  )
}

#' @rdname vec-ops
#' @export
which_max_idx <- function(x) UseMethod("which_max_idx")

#' @rdname vec-ops
#' @export
which_max_idx.sparta <- function(x) {
  if (inherits(x, "sparta_unity")) return(NA)
  which.max(attr(x, "vals"))
}

#' Print
#'
#' Print method for sparta objects
#' 
#' @param x sparta object
#' @param ... For S3 compatability. Not used.
#' @export
print.sparta <- function(x, ...) {
  if (inherits(x, "sparta_unity")) {
    cat(" <sparta_unity>\n")
    cat("  rank:", attr(x, "vals"), "\n")
    cat("  variables:", paste(names(x), collapse = ", "), "\n")
  } else {
    d <- as.data.frame(t(x))
    colnames(d) <- names(x)
    d[["val"]] <- round(vals(x), 3)
    print(d, ...)
  }
}


