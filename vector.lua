GRAVCONSTANT= .0000000000667
function vector.make(d,l)
return {u=u,l=l}
end
function vector.add(v1,v2)
	return {u=(v1.u+v2.u),l=(v1.l+v2.l)}
end
function grav.Fg(x1,y1,m1,x2,y2,m2)
	r = math.sqrt((x1-x2)^2+(y1-y2)^2)
	return GRAVCONSTANT*((m1*m2)/(r^2))
	end
function grav.vec(x1,y1,m1,x2,y2,m2)
	Fg = grav.Fg(x1,y1,m1,x2,y2,m2)
	return vector.make((y1-y2)*Fg,(x1-x2)*Fg)
end

	