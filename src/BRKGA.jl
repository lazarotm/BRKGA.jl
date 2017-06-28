module BRKGA
#Pkg.update()

include("brkga_types.jl")
include("brkga_gfunctions.jl")
include("brkga_functions_samples.jl")
include("brkga_main.jl")
include("brkga_parser.jl")

#functions and variables exported
export main,n, p, pe, pm, rhoe, K, MAXT, generation,
X_INTVL, X_NUMBER, MAX_GENS, N_Evolutions

n=2
p=100
pe=0.30
pm=0.20
rho=0.70
K=3
X_INTVL=100
X_NUMBER=2
it=-1
N_Evolutions=1
dm=[0,0]
dmu=[0,0]
dml=[0,0]
sd=270001
ep=1.0e-10
generation=0
ter=1
of="none"
ifn="booth"
efn=""

println(ARGS)

for i = 1:length(ARGS)

	if search(ARGS[i],"of=") == 1:3
		aux = ARGS[i]
		of = aux[4:length(aux)]
		println(of)
	elseif search(ARGS[i],"ifn=") == 1:4
		aux = ARGS[i]
		ifn = aux[5:length(aux)]
		println(ifn)
	elseif search(ARGS[i],"efn=") == 1:4
		aux = ARGS[i]
		efn = aux[5:length(aux)]
		println(efn)
	else
		eval(parse(ARGS[i]))
	end	
end


main(n=n,p=p,pe=pe,pm=pm,rho=rho,K=K,X_INTVL=X_INTVL, X_NUMBER=X_NUMBER, it=it, N_Evolutions=N_Evolutions, dm=dm, dmu=dmu, dml=dml, ifn=ifn, efn=efn,sd=sd, of=of, ep=ep, generation=generation, ter=ter)

end

