include("../src/fdfd_local_field.jl")

using Plots
pyplot()

ps = transpose(0.1:0.01:0.9)

E_local_field = [get_local_field(ps[:,i])[3] for i=1:length(ps)]

Plots.plot(real.(E_local_field))
Plots.plot!(imag.(E_local_field))
gui()

Plots.plot(angle.(E_local_field))
gui()
