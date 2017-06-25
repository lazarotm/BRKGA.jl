
function parse_bounds( dm, dmu, dml, n )
	
	teto = chao = fill(0,0)

	if dm == [0,0] && dmu==[0,0] && dml==[0,0]
		teto = fill(10,n)
		chao = fill(-10,n)
	elseif dm != [0,0]
		teto = fill(dm[2],n)
		chao = fill(dm[1],n)
	else
		teto = dmu
		chao = dml
	end

	print("Upper bounds: ")
	println(teto) #vetor de limite superior
	print("Lower bounds: ")
	println(chao) #vetor de limite inferior

	return teto,chao

	

end

function parse_function_name( efn, ifn )

	if efn != ""
		
		println("\nUtilizando função externa: ")
		println(typeof(include(efn)))
		return include(efn)
	else		
		println("\nUtilizando função interna: ")
		println(typeof(eval(parse(ifn))))
		return eval(parse(ifn))
	end
end

function parse_it_or_ep( it, ep, generation, currentFitness )
	return ( generation < it && it != 0 ) $ ( it == 0 && currentFitness > ep )
end