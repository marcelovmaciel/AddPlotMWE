import Pkg

Pkg.activate("../")

using Revise
using AddPlotMWE
using Agents
using GLMakie
using InteractiveDynamics



m = model_initialize(500, 2)

fig,stepper = abm_play(m,dummystep,model_step!)

foo = Observable([Point{2}(x) for x in values(m.properties[:othervars])])

scatter(fig[1,2], foo)

fig # the second plot indeed appears. Lets click step a few times

foo[] = [Point{2}(x) for x in values(m.properties[:othervars])] #update the observable

fig #voila the second plot changed.

# Now try to make it change when I click stuff

m = model_initialize(500, 2)

fig,stepper = abm_play(m,dummystep,model_step!)

foo = Observable([Point{2}(x) for x in values(m.properties[:othervars])])

scatter(fig[1,2], foo)

# Maybe adding a new step function?
function newstep(m, foo = foo)
    model_step!(m)
    foo[] = [Point{2}(x) for x in values(m.properties[:othervars])]
end

InteractiveDynamics.abm_play!(fig,stepper, m, dummystep,
                              newstep, spu = 1:10)

fig # nope, doesn't work
