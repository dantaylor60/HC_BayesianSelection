\name{summaryout}
\alias{summaryout}

\title{
Summary function for objects of type VarSelectHC
}
\description{
Function to summarize the output obtained from performing variable selection with heredity constraints using the VarSelectHC function.
}
\usage{
summaryout(mcmc.out, insampledata, modelprior.nams, shr.adj = T, 
           outsampledata, respnam, top.ave = 10, betaprtype = "IP", 
           parsprbeta = list(alpha = 1, nu = 1))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mcmc.out}{
object obtained from VarSelectHC
}
  \item{insampledata}{
data frame containing data used in the variable selection procedure
}
  \item{modelprior.nams}{
character vector or character string with names of priors considered for the model space.  This vector or string has to match the argument model.prior.pars used in VarSelectHC.
}
  \item{shr.adj}{
logical. TRUE if shrinkage from g-priors is used for estimation of the regression coefficients. If FALSE the LS estimates are used.
}
  \item{outsampledata}{
data frame containing holout data for model validation after selection.  This argument is required, thus if there is no holdout sample available, set this argument to the same data frame as the one used for "insampledata", in such as case the MSPE's obtained are no longer appropriate.
}
  \item{respnam}{
character string with the name of the response variable
}
  \item{top.ave}{
integer greater than 0 denoting the number of models to be used for model averaging
}
  \item{betaprtype}{
g-prior used to obtain the shrinkage coefficient for the regression parameters. , taking the values 'NP','IP','ZS', or 'HG' for normal prior, intrinsic prior, Zellner-Siow prior, or hyper g-prior. For the hyper g-prior, the prior on w=1/g is taken to be proportional to w^(-.5)*(b+w)^((a+1)/2).Defaults to "IP".
}
  \item{parsprbeta}{
parameter of the g-prior, when appropriate. The intrinsic and Zellner-Siow priors have no parameters. The normal prior has parameter w=1/g, defaulting to 1. The hyper g, has parameter (a,b), defaulting to (2,1).
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
\item{formulaHPMs }{Vector of characters with variables included in the Highest Probability models (HPMs) identified with each of the model priors considered}
\item{TopModels }{List of data frames with the formulas for the top "top.ave" models identified and the model posterior probabilities. There is one data frame for each model prior considered.}
\item{post.HPM }{Vector of model posterior probabilities of the HPM with each model prior considered.}
\item{postcumm.Top }{Vector of the cummulative model posterior probabilities for the top "top.ave" models for each model prior considered.}
\item{MSPE.HPM }{Root mean squared prediction error for the HPM's using a holdout data set.}
\item{MSPE.ave }{Root mean squared prediction error from model averaging using a holdout data set.}
}
\references{
Taylor-Rodriguez, D., Womack, A., & Bliznyuk, N. (2015). Bayesian Variable Selection on Model Spaces Constrained by Heredity Conditions. Journal of Computational and Graphical Statistics, (July 2015), 0–0. doi:10.1080/10618600.2015.1056793

Womack, A. J., León-Novelo, L., & Casella, G. (2014). Inference From Intrinsic Bayes’ Procedures Under Model Selection and Uncertainty. Journal of the American Statistical Association, 109(507), 1040–1053. doi:10.1080/01621459.2014.880348

}
\author{
Daniel Taylor-Rodriguez and Andrew Womack
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{VarSelectHC}}
}
\examples{
#simulate some random predictors
X<-data.frame(x1=rnorm(100),x2=runif(200),x3=runif(200),fvar=as.factor(rbinom(200,1,.3)))

#simulate response using as the true model x1 + x1^2 + fvar
y <- with(data.frame(model.matrix(terms(as.formula(~x1+x2+fvar)),X)),rnorm(200,mean=(-2+2*x1+x1^2-fvar1),sd=1))

#--- make data frame
#data for model selection and fitting
ind.insample <- sample(1:200,100)
datain <- data.frame(y=y[ind.insample],X[ind.insample,])

#holdout data for validation
data.holdout <- data.frame(y=y[-ind.insample],X[-ind.insample,])
  
#define vector of model prior types to be considered (it can also be a single one)
modpriorvec = c("EPP","HIP","HTP")
  
#run the variable selection procedure
res=VarSelectHC(full.formula=as.formula(y ~ x1 + x2 + x3 + fvar),
                data=datain,
                base.formula=as.formula(.~ 1),
                maxdeg=2,
                nodes.to.remove = NULL,
                model.prior.type=modpriorvec,
                model.prior.pars="children",
                beta.prior.type="IP",
                beta.prior.pars=list(alpha=1,nu=1),
                start.formula=as.formula(y~x1),
                niter=5000)


summary.res <- summaryout(mcmc.out=res,insampledata=datain,modelprior.nams=modpriorvec,
                          shr.adj=T,outsampledata=data.holdout,respnam="y",top.ave=10,betaprtype="IP",
                          parsprbeta=list(alpha=1,nu=1))
}
\keyword{linear models}
\keyword{polynomial regression}
\keyword{Bayesian variable selection}
\keyword{heredity constraints}
\keyword{model priors}
