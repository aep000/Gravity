debug = true
function vectorMake(u,l)
return {u=u,l=l}
end
function vectorAdd(v1,v2)
	return {u=(v1.u+v2.u),l=(v1.l+v2.l)}
end
function vectorMinus(v1,v2)
	return {u=(v1.u-v2.u),l=(v1.l-v2.l)}
end
function vectorMult(v1,val)
	return {u=(v1.u*val),l=(v1.l*val)}
end
function vectorDot(v1,v2)
	return (v1.u*v2.u)+(v1.l*v2.l)
end
function vectorInv(v1)
	return {u=(v1.u*-1),l=(v1.l*-1)}
end
function gravFg(x1,y1,m1,x2,y2,m2)
	r = math.sqrt((x1-x2)^2+(y1-y2)^2)
	return GRAVCONSTANT*((m1*m2)/(r^2))
	end
function gravVec(x1,y1,m1,x2,y2,m2)
	Fg = gravFg(x1,y1,m1,x2,y2,m2)
	return vectorMake((y1-y2)*Fg,(x1-x2)*Fg)
end

radius=30
gravpts = {}
lns ={}
balls = {{10,0,10,v=vectorMake(-50,0)}}
ptamt=0
GRAVCONSTANT= .667
function gravEffect(ball,c)
	i =1
	
	while i <= #gravpts do
		gvec = gravVec(ball[1],ball[2],ball[3]*2,gravpts[i][1],gravpts[i][2],gravpts[i][3]*2)
		ball.v = vectorAdd(ball.v,gvec)
		i=i+1
	end
	i=1
	while(i<=#balls)do
		if(i~=c)then
			gvec = gravVec(ball[1],ball[2],ball[3],balls[i][1],balls[i][2],balls[i][3])
			ball.v = vectorAdd(ball.v,gvec)
		end
		i=i+1
	end
	
end
function ballMove(dt,ball)
	--print((ball.v.l*dt))
	ball[1]=ball[1]-(ball.v.l*dt)
	ball[2]=ball[2]-(ball.v.u*dt)
	end
mode="ball"
function placeBall()
if(love.mouse.isDown(1)and ldown ~= true) then
	ldown = true
	x = love.mouse.getX()
	y = love.mouse.getY()
	rval = overlap(x,y,radius)
	--print(rval[1])
	if(rval[1] ~= true)then
		table.insert(gravpts,{x, y, radius})
	end
end
if(love.mouse.isDown(1)~=true)then
	ldown=false
end
if(love.mouse.isDown(2)and ldown2 ~= true) then
	table.remove(gravpts,#gravpts)
	ldown2=true
	
end
if(love.mouse.isDown(2)~=true)then
	ldown2=false
end

end
--[[
function placebod()
	if(love.mouse.isDown(1)and ldown3 ~= true)then
	m3x=love.mouse.getX()
	m3y=love.mouse.getY()
	ldown3= true
end
if(love.mouse.isDown(1) ~= true and ldown3 == true)then
	table.insert(balls,{m3x,m3y,radius,v = vectorMake(m3y-love.mouse.getY(), m3x-love.mouse.getX())})
	ldown3=false
end
if(love.mouse.isDown(1)~=true)then
	ldown3=false
end
if(love.mouse.isDown(2)and ldown2 ~= true) then
	table.remove(balls,#balls)
	ldown2=true
	
end
if(love.mouse.isDown(2)~=true)then
	ldown2=false
end
end ]]--
function placeObj()
if(love.mouse.isDown(3)and ldown3 ~= true)then
	m3x=love.mouse.getX()
	m3y=love.mouse.getY()
	ldown3= true
end
if(love.mouse.isDown(3) ~= true and ldown3 == true)then
	local nx= love.mouse.getX()
	local ny= love.mouse.getY()
	local xmidpt = (m3x+nx)/2
	local ymidpt = (m3x+nx)/2
	local invm=-(nx-m3x)/(ny-m3y)
	local b= ball[2]-(invm*ball[1])
	dist123 = ((xmidpt-ball[1])/math.abs(xmidpt-ball[1]))*((ymidpt-ball[2])/math.abs(ymidpt-ball[2]))
	print(dist123)
	--v=vectorMake(pt1[1]-xmidpt,pt1[2]-ymidpt
	table.insert(lns,{m3x,m3y, nx, ny, dist123, xmidpt=xmidpt,ymidpt=ymidpt, invm=invm})
	--(m3y-love.mouse.getY(), m3x-love.mouse.getX())
	ldown3=false
end
if(love.mouse.isDown(3)~=true)then
	ldown3=false
end
end
kdownm=false
function place(dt)
if(love.keyboard.isDown('m') and kdownm == false)then
	kdownm=true
	if(mode =="ball")then
	mode ="obj"
	elseif(mode =="obj")then
	mode ="body"
	elseif(mode =="body")then
	mode ="ball"
	end
	elseif(love.keyboard.isDown('m')~=true)then
		kdownm=false
	end
if(love.keyboard.isDown('b'))then
	radius = radius+dt*30
end
if(love.keyboard.isDown('s'))then
	radius = radius-dt*30
end
end
--[[function reflect(ln)
	local b= ball[2]-(ln.invm*ball[1])
	local pt1 = {ball[1],((ln.invm)*(ball[1])+b)}
	local v = vectorMake(pt1[1]/math.sqrt(pt1[1]^2+pt1[2]^2),pt1[2]/math.sqrt(pt1[1]^2+pt1[2])^2) 
	local n = vectorMake(v.u/math.abs(v.u),v.l/math.abs(v.l))
	
	ball.v= vectorAdd(ball.v,vectorMult(n,(vectorDot(n,ball.v)*-2)))
end]]--
--[[function doesReflect()
	---2*(V dot N)*N + V
	i=1
	while i <= #lns do
		ln = lns[i]
		Dpts = math.sqrt((ln[1]-ln[3])^2+(ln[2]-ln[4])^2)
		Db1 = math.sqrt((ln[1]-ball[1])^2+(ln[2]-ball[2])^2)
		Db2 = math.sqrt((ln[3]-ball[1])^2+(ln[4]-ball[2])^2)
		if(math.abs((Db1+Db2)-Dpts)<ball[3]/2)then
			reflect(lns[i])
		end
		i=i+1
	end
	
end]]--
function overlap(x, y, r)
	i = 1
	retval = {false,0}
	while i <= #gravpts do
		x1=gravpts[i][1]
		y1=gravpts[i][2]
		if(math.sqrt((x1-x)^2+(y1-y)^2)<=gravpts[i][3]+r) then
			retval = {true,i}
			--print(retval[2])
		end
		i=i+1
	end
	return retval
end
function love.load(arg)

end
x = 0
ldown,ldown2,ldown3 = false
m3x,m3y=0
function love.update(dt)
place(dt)
local c=1
while(c<=#balls)do
gravEffect(balls[c],c)
--doesReflect()
ballMove(dt,balls[c])
c=c+1
end
end
function love.draw(dt)
love.graphics.setColor( 255, 255, 255 )
love.graphics.print("Size:"..radius.." (B to get bigger S to get smaller)\nMode: "..mode.." M to switch",10,10)
i = 1
while i <= #gravpts do
	if(type(gravpts[i][1])=="number")then
	love.graphics.circle("fill", gravpts[i][1], gravpts[i][2], gravpts[i][3])
	end
	i=i+1
end	
i=1
while i <= #lns do
	if(type(lns[i][1])=="number")then
	love.graphics.line(lns[i][1],lns[i][2],lns[i][3],lns[i][4])
	end
	i=i+1
end	
local c=1
love.graphics.setColor( 255, 0, 0 )
while(c<=#balls)do
	love.graphics.circle("fill", balls[c][1], balls[c][2], balls[c][3])
	c=c+1
end
end
x1,y1,x2,y2=0
function love.mousepressed(x, y, button)
print(overlap(x,y,radius)[1])

if(mode=="ball" and button == 1 and overlap(x,y,radius)[1] ~= true)then
	table.insert(gravpts,{x, y, radius})
elseif(mode=="body" and button==1)then
	x1=x
	y1=y
elseif(mode=="ball" and button == 2)then
	table.remove(gravpts,#gravpts)
elseif(mode=="body" and button == 2)then
	table.remove(balls,#balls)
end
end
function love.mousereleased(x, y, button)
if(mode=="body" and button==1)then
	x2=x
	y2=y
	table.insert(balls,{x1,y1,radius,v = vectorMake(y1-y2, x1-x2)})
end
end