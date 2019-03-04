\name{VarSelectHC-package}
\alias{VarSelectHC-package}
\alias{VarSelectHC}
\docType{package}
\title{
Bayesian variable selection under heredity constraints
}
\description{
Bayesian variable selection when considering linear regression models with interactions and polynomial terms of orders 2 and higher.  The algorithm constrains the model space to respect the hierarchical polynomial structure subject to strong or weak heredity constraints. The function has severeal choices of priors on the model space and on the model parameters. For full details on the model set-up and the random walk, 
please refer to the articles listed below.
}
\details{
\tabular{ll}{
Package: \tab VarSelectHC\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2016-01-08\cr
License: \tab What license is it under?\cr
}

}
\author{
Daniel Taylor-Rodriguez and Andrew Womack

Maintainer: Daniel Taylor-Rodriguez <dt108@stat.duke.edu>
}
\references{
Taylor-Rodriguez, D., Womack, A., & Bliznyuk, N. (2015). Bayesian Variable Selection on Model Spaces Constrained by Heredity Conditions. Journal of Computational and Graphical Statistics, (July 2015), 0–0. doi:10.1080/10618600.2015.1056793

Womack, A. J., León-Novelo, L., & Casella, G. (2014). Inference From Intrinsic Bayes’ Procedures Under Model Selection and Uncertainty. Journal of the American Statistical Association, 109(507), 1040–1053. doi:10.1080/01621459.2014.880348
}

\keyword{ package }

\examples{
#simulate some random predictors
X<-data.frame(x1=rnorm(200),x2=runif(200),x3=runif(200),fvar=as.factor(rbinom(200,1,.3)))

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
