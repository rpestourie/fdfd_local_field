# checks Fresnel's transmission coefficient numerically
n_incident = 1.
n_transmit = 1.45
ref_local_field = get_local_field(Float64[0.5], refractive_indexes=ones(3) * n_incident)[3]
interface_localfield = get_local_field(Float64[0.5],  refractive_indexes=Float64[n_transmit, n_incident, n_incident])[3]

transmission_numerical = abs2(interface_localfield)/abs2(ref_local_field)/n_incident*n_transmit
transmission_fresnel = ((2n_incident)/(n_incident+n_transmit))^2/n_incident*n_transmit

@test abs(transmission_fresnel - transmission_numerical)/abs(transmission_fresnel)< 1e-2
