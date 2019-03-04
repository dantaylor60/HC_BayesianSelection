\name{VarSelectHC}
\alias{VarSelectHC}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Bayesian variable selection under heredity constraints
}
\description{
Bayesian variable selection when considering linear regression models with interactions and polynomial terms of orders 2 and higher.  The algorithm constrains the model space to respect the hierarchical polynomial structure subject to strong or weak heredity constraints. The function has severeal choices of priors on the model space and on the model parameters. For full details on the model set-up and the random walk, 
please refer to the articles listed below.
}
\usage{
VarSelectHC(full.formula, data, base.formula = as.formula(. ~ 1), SH = TRUE, 
            maxdeg = 0, nodes.to.remove = NULL, model.prior.type = "EPP", 
            model.prior.pars = "children", beta.prior.type = "IP", 
            beta.prior.pars = list(alpha = 1, nu = 1), eff = TRUE, centerscale = FALSE, 
            start.formula = as.formula(. ~ 1), niter = 10000)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{full.formula}{
  formula corresponding to the largest model (e.g., as.formula(y ~ x1+x2+x1^2+x1*x2) ). If maxdeg > 0, then this formula can be made up of only the terms on which the polynomial surface of order maxdeg will be generated (e.g., as.formula(y ~ x1+x2+...+xp) if there are p predictors of order 1).  If factors are considered for selection, these must also be included in the formula, the polynomial surface will include higher order interactions of the factors and numerical variables, but will exclude redundant higher order terms including those factors.
}
  \item{data}{
  data frame containing the response in the first column and the order 1 variables in the model, including those in the base model (for example, data should not include x1^2 or x1*x2, but it should include x1 and x2). Factors can also be considered for selection. Defaults to the intercept only model.
}
  \item{base.formula}{
formula corresponding to the smallest model.  This smallest model contains predictors that are included in all models and on which variable selection is not performed (e.g. as.formula(.~ 1) or as.formula(.~ 1+x1)). Required.
}
  \item{SH}{
logical. If TRUE selection is performed assuming Strong Heredity (default). If FALSE Weak Heredity is assumed.
}
  \item{maxdeg}{
an integer that determines the maximum degree of the polynomial surface. If zero, then base.formula and full.formula are used to determine the model space.  If maxdeg>0, then takes the order 1 predictors on which full.formula is based on and makes a full polynomial surface of degree  maxdeg in those predictors. Defaults to 0. Although maxdeg can be chosen to be any positive integer, if number of variables considered is large, values larger than 4 may make the function very slow.
}
  \item{nodes.to.remove}{
character vector with names of variables to remove from the model space (e.g., c("x1","x1*x2","x1^3"))
}
  \item{model.prior.type}{
character string specifying the choice of model prior used.  The choices are the equal probability prior ("EPP"), hierarchical uniform prior ("HUP"),  hierarchical independence prior ("HIP"), hierarchical order prior ("HOP"), hierarchical length prior ("HLP"), hierarchical type prior ("HTP").  Defaults to "EPP". See additional details below.
}
  \item{model.prior.pars}{
Parameter to specify if stronger prior penalization is required to account for test multiplicity.  Possible choices are "unif" to have no additional penalization and "children" to specify hierarchical penalization according to children terms. See details below.
}
  \item{beta.prior.type}{
kind of prior used to compute Bayes' Factors, taking the values 'NP','IP','ZS', or 'HG' for normal prior, intrinsic prior, Zellner-Siow prior, or hyper g-prior. For the hyper g-prior, the prior on w=1/g is taken to be proportional to w^(-.5)*(b+w)^((a+1)/2).
}
  \item{beta.prior.pars}{
parameter of the g-prior, when appropriate. The intrinsic and Zellner-Siow priors have no parameters. The normal prior has parameter w=1/g, defaulting to 1. The hyper g, has parameter (a,b), defaulting to (2,1).
}
  \item{eff}{
logical variable denoting whether the prior precision for the coefficients of a model should be scaled by the number of covariates. Defaults to TRUE and a model with p covariates is scaled by (p+1)/n, if FALSE each model is scaled by 1/n.
}
  \item{centerscale}{
logical parameter. TRUE if centering and scaling of the predictors is required, FALSE otherwise. 
}
  \item{start.formula}{
optional formula for the starting model in the random walk. When left unspecified it defaults to base model.
}
  \item{niter}{
number of simulations for the random walk, defaults to 10000.
}
}
\details{
For a complete description of the priors available for the model space see Taylor-Rodriguez et al. (2015), and see Womack and León-Novelo (2014) for the specification of the priors for the regression parameters.
}
\value{
\item{MF.mat }{Matrix with the monomial representation for each term in the full model}
\item{MB.mat }{Matrix with the monomial representation for each term in the base model}
\item{M.start }{List containing the nodes, the extreme nodes and the children of the starting model (see Taylor-Rodriguez et al. for more details)}
\item{nodes }{List where each element corresponds to one variable in the full model, containing the information used in the mcmc algorithm for the variables (nodes). Each element  of the list contains the monomial representation of the variable ("vec"), the position in the list for its children nodes, for its parent nodes, the degree of the node, the name of the node and the formulaic representation of the node}
\item{models }{List containing the information of every model discovered during the random walk.  Each particular model (an element in the list) is itself a list containing: the position in the "nodes" object (described above) of the variables (nodes) contained in the model, it's extreme (extreme) and children (children) nodes, the residual sums of squares of the model (RSS), the log-Bayes factor (logBF) and the log of the model prior (modpr)}
\item{model.sequence }{character vector with the sequence of accepted models, where models are represented by the position of its variables inside of the "nodes" object }
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
\code{\link{summaryout}}
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
