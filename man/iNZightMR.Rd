% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/iNZightMR.R
\name{iNZightMR}
\alias{iNZightMR}
\title{Create iNZightMR multiple response object (MRO)}
\usage{
iNZightMR(frm, data, Labels = NULL, inverse = FALSE, ...)
}
\arguments{
\item{frm}{formula containing the response variables}

\item{data}{a data.frame containing response and explanatory variables}

\item{Labels}{labels for the response categories; by default, the function
will attempt to. Can also be the function \code{substrsplit},
which will detect a common base in the variables
(see Details)}

\item{inverse}{if \code{TRUE}, binary responses will be reversed (see details)}

\item{...}{additional arguments, passed to \code{\link{model.frame}}}
}
\value{
An \code{mro} object containing a multiple response binary matrix and input
  data source
}
\description{
Creates a multiple response object (MRO) containing binary response matrix
(zeros and ones) as well as the input data source.
}
\details{
The individual response variable names can be detected from the
variable name by passing \code{Labels = substrsplit}.
For example, in `ethniceng` and `ethnicmri`, `ethnic` is common
to both, so the labels will be `eng` and `mri`.

If a user wants to inverse the response (zeros becomes ones), then pass
\code{inverse = TRUE}. This is useful when the responses are characters
(such as "correct" and "wrong", where correct would be given a zero)
and the order needs reversing (so that correct is 1 instead).
}
\examples{
mr <- iNZightMR(online ~ onlinegame + onlinevideo + onlinemusic,
    data = census.at.school.5000)

# users can also override the variable names
iNZightMR(online ~ onlinegame + onlinevideo + onlinemusic,
    Labels = c("gaming", "youtube", "spotify"),
    data = census.at.school.5000
)
}
\seealso{
\link{barplotMR}, \link{mroPara}
}
