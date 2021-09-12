module AddPlotMWE

using Agents
using Distributions


mutable struct  DummyAgent{n} <: AbstractAgent
    id::Int
    pos::NTuple{n,Float64}
    othervar::Vector{Float64}
end

function model_initialize(nagents,n)
    space = ContinuousSpace(ntuple(x -> float(1),n))

    model = ABM(DummyAgent{n}, space, properties = Dict(:n=> n,
                                                        :othervars => Dict{Int64, Array{Float64}}()))

        for i in 1:nagents
        pos = Tuple(rand(Uniform(0,1), n))
        othervar =  rand(Uniform(0.4,0.5),n)
        add_agent_pos!(DummyAgent{n}(i, pos,othervar), model)
    end

    model.properties[:othervars] =  Dict((model[x].id => model[x].othervar)
                                        for x in allids(model))
    return model
end


function model_step!(model)
    # Ill write a step that changes only the second plot
    for i in allids(model)
        randombound = rand(Uniform(0.5,1)) # so the second plot changes
        model[i].othervar = rand(Uniform(0.4, randombound),model.properties[:n])
        model.properties[:othervars][i] = model[i].othervar
    end
end

export DummyAgent, model_initialize, model_step!
end # module
