% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers_sparta.R
\name{normalize}
\alias{normalize}
\alias{normalize.sparta}
\alias{normalize.numeric}
\title{Normalize}
\usage{
normalize(x)

\method{normalize}{sparta}(x)

\method{normalize}{numeric}(x)
}
\arguments{
\item{x}{sparta}
}
\value{
A sparta object
}
\description{
Normalize
}
\examples{

x <- array(
  c(1,0,0,2,3,4,0,0),
  dim = c(2,2,2),
  dimnames = list(
    a = c("a1", "a2"),
    b = c("b1", "b2"),
    c = c("c1", "c2")
  )
)

sx <- as_sparta(x)
normalize(sx)
}
