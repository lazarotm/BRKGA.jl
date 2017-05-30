
function ackley(x)
	
	n = length(x)

	summation1 = -20 * exp(-0.2 * sqrt( sum(x.*x) / n ))
	summation2 = exp(sum(map(cos,*(x,2,pi))) / n )
	return summation1 - summation2 + 20 + e
end

function booth(x)
     return ( x[1] + (2*x[2]) - 7 )^2 + ( (2*x[1]) + x[2] - 5 )^2
end