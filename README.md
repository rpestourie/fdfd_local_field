# fdfd_local_field

This application solves Maxwell’s equations in the frequency domain in parallel for multiple instances of a parametrized 
geometry with the goal of 
1. solving for metasurfaces using domain decomposition, 
2. train surrogate models for offline Maxwell’s solve and large-scale optimization. 

The design of metasurfaces — large-area ultrathin nanopatterned surfaces designed to mimic bulky lenses — 
is computationally challenging because of the enormous range of scales they involve. 
Indeed, they present two very different length scales, namely their feature size (of the order of 10 nm) 
and their diameter (of the order of the centimeter). Recent work from Johnson group @MIT Mathematics [1], [2] 
has made the design possible using decomposition methods which breaks the computational domain of the metasurface 
into multiple smaller domains. A first approach is to solve Maxwell's equations for a multitude of subdomains 
in parallel and online. However, during large scale optimization, we need to simulate many different metasurfaces 
and this online approach remains slow. A second approach is to use a surrogate model, which is trained using solutions 
to Maxwell’s equation on the subdomain but is much faster to evaluate. A surrogate model dramatically increases the speed 
of simulation for metasurfaces and makes large scale optimization possible, at the cost of a tradeoff between training time 
and accuracy if the surrogate model. Using embarrassingly parallel solves for the training subdomains simulations alleviates 
this trade-off.

Julia enables us to write and solve Maxwell’s equations in 2D very elegantly and efficiently. Julia also gives us more 
freedom and control than its commercial software counterpart.

## References

[1]	R. Pestourie, C. Pérez-Arancibia, Z. Lin, W. Shin, F. Capasso, and S. G. Johnson, “Inverse design of large-area metasurfaces,” Opt. Express, vol. 26, no. 26, pp. 33732–33747, Dec. 2018, doi: 10.1364/OE.26.033732.

[2]	Z. Lin and S. G. Johnson, “Overlapping domains for topology optimization of large-area metasurfaces,” Opt. Express, vol. 27, no. 22, pp. 32445–32453, Oct. 2019, doi: 10.1364/OE.27.032445.
