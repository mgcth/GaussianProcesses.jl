module GaussianProcesses
using Optim, PDMats, Distances, Distributions, Klara, FastGaussQuadrature
using Compat
import Compat: view, cholfact!

import Base: +, *
import Base: rand, rand!, mean, cov, push!

# Functions that should be available to package
# users should be explicitly exported here

export GP, GPE, GPMC, predict,
     Kernel, SumKernel, ProdKernel, Masked, FixedKern, fix, Noise, Const, SE, SEIso, SEArd, Periodic, Poly, RQ, RQIso, RQArd, Lin, LinIso, LinArd, Mat, Mat12Iso, Mat12Ard, Mat32Iso, Mat32Ard, Mat52Iso, Mat52Ard, #kernel functions
    MeanZero, MeanConst, MeanLin, MeanPoly, SumMean, ProdMean, #mean functions
    GaussLik, BernLik, ExpLik, StuTLik, PoisLik, BinLik, predict_obs, #likelihood functions
    mcmc, optimize!                                           #inference functions

typealias MatF64 AbstractMatrix{Float64}
typealias VecF64 AbstractVector{Float64}

# all package code should be included here
include("means/means.jl")
include("kernels/kernels.jl")
include("likelihoods/likelihoods.jl")
include("utils.jl")
include("chol_utils.jl")
include("GP.jl")
include("GPE.jl")
include("GPMC.jl")
include("mcmc.jl")
include("optimize.jl")

# This approach to loading supported plotting packages is taken from the "KernelDensity" package
macro glue(pkg)
    path = joinpath(dirname(@__FILE__),"glue",string(pkg,".jl"))
    init = Symbol(string(pkg,"_init"))
    quote
        $(esc(init))() = Base.include($path)
        isdefined(Main,$(QuoteNode(pkg))) && $(esc(init))()
    end
end

@glue Gadfly
@glue PyPlot
# This does not require @glue because it uses the interface defined in
# ScikitLearnBase, which is a skeleton package.
include("glue/ScikitLearn.jl")

end # module
