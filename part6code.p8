--new code reference
--init()
shkx,shky = 0,0 --screen shake variables
particles={} --table of particles
title = true --title state bool
timer = 0 --timer for states
music(16) --new title music

--update()
if title then
	timer+=1
	if btn(4) and timer>30 then
		timer=0
		title = false
		sfx(11)
	 	music(0)
	end
else
--reset of update
end

--in player update loop
if player.animtimer%2==0 then
	create_particle(player.x,player.y+3+rnd(2),-0.5,0)
end
--update screen shake
update_shake()

--sprinkle liberally...
add_shake(8)

--at end of if not gameover loop
if gameover then
	timer+=1
	if btn(4) and timer>30 then
		reload()--load all game data
		gameover=false
		_init() -- set game to initial state
	end
end

--draw()
if title then
	cls()
	camera(0,0)--reset camera
	--title gfx
	spr(64,32,12,6,4)
	spr(118,54,43)
	spr(72,86,28,2,2)
	spr(70,88,50,2,2)
	spr(104,30,48,2,2)
	print('attack of the',36,72,3)
	spr(74,12,80,6,2)
	spr(106,70,80,6,2)
	if timer>30 then
		print('press z to start',32,112,7)
	end	
	rect(0,0,127,127,3)
else
--rest of draw code
end

--set camera shake
camera(camx+shkx,camy+shky)

--other functions
function add_shake(amount)
	local a=rnd(1)
	shkx+=amount*cos(a)
	shky+=amount*sin(a)
end

function update_shake()
	if abs(shkx)+abs(shky)<0.5 then
		shkx,shky=0,0
	else
		shkx*=-0.5-rnd(0.2)
		shky*=-0.5-rnd(0.2)
	end
end

function create_particle(x,y,vx,vy)
	local p={x=x,y=y,vx=vx,vy=vy,colour=10,age=0}
	add(particles,p)
end

function update_particles()
	for p in all(particles) do
		p.age+=1
		if p.age>15 then
			del(particles,p)
		elseif p.age>10 then
			p.colour=4
		elseif p.age>5 then
			p.colour=9
		end
		p.x+=p.vx
		p.y+=p.vy
		pset(p.x,p.y,p.colour)
	end
end
--in create_explosion()
--add particles to explosions
for i=1,10 do
	local a=rnd(1)
	local vx=cos(a)*rnd(2)
	local vy=sin(a)*rnd(2)
	create_particle(x,y,vx,vy)
end