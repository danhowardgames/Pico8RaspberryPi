--new code reference
--***in _init()***
camx,camy = 0,0--camera coordinates
--check each map tile and spawn enemies
for mapx=0,127 do
	for mapy=0,63 do
		local sprite = mget(mapx,mapy) --get sprite
		if sprite==2 then
			create_enemy(mapx*8,mapy*8)
		--set map tile to blank so we dont draw it as background
			mset(mapx,mapy,0)
		end
		if sprite==3 then --turret
			create_turret(mapx*8,mapy*8)
			mset(mapx,mapy,0)
		end
	end
end
--***in _update()***
--make player scroll with screen
		player.x+=1
--change player boundary locking to camera
		player.x=mid(camx,player.x,camx+120)
		player.y=mid(camy,player.y,camy+120)
--kill player if hits terrain
if player_terrain_collision() then
	gameover = true
	create_explosion(player.x,player.y,20)
	sfx(1)
	music(-1)
end
--change to laser boundary
laser.x+=5 --speed up laser
if laser.x>camx+130 then --delete laser if off camera
	del(lasers,laser)
end
--change so enemies only attack when on camera
for enemy in all(enemies) do --enemy update loop
 if enemy.name=='blob' then enemy.x-=1 end
	if enemy.x<camx+130 and enemy.y<camy+128 then
		--[[rest of code here]]
		if enemy.name=='turret' then
			if enemy.animtimer%60==0 then
				create_mucus(enemy.x,enemy.y)
			end
		end
		if enemy.name=='mucus' then
			enemy.x+=enemy.vx
			enemy.y+=enemy.vy
		end
		if enemy.x<camx-8 then
			del(enemies,enemy)
		end
	end
end
--***in _draw()***
if not gameover then camx+=1 end --increment camera x value
if camx>=1024 then --if cam off right edge of map
	camy+=128 --move down one row
	camx=-128 --move to left of map
	player.x-=1152 --full width of map +1 screen(1024+128)
	player.y+=128--down one screen
end

camera(camx,camy)--set camera
map(0,0,0,0,128,64)--draw map onto screen
--update to background to lock to camera
rectfill(camx,camy,camx+128,camy+128,1)
for star in all(stars)do
	star.x -= star.speed
	pset(star.x+camx,star.y+camy,7)
	if star.x < 0 then
		star.x = 130
		star.y=rnd(128)
	end
end
--update to only animate blob enemy
if enemy.name=='blob' then
	enemy.sprite = enemy.sprites[flr--[[etc]]]
end
--update to gameover text to lock to camera
if gameover then
	print('game over',camx+50,camy+64,7)
end
--show score on screen
print('score: '..score,camx+2,camy+2,7)
--***other functions***
function player_terrain_collision()
	for newx=0,6,6 do --nested for loops generate 4 points
		for newy=0,7,7 do
			--divide by 8 to convert pixels to map coords
			local sprite = mget((player.x+newx)/8,(player.y+newy)/8)
			if fget(sprite,0) then return true end
		end
	end
	return false
end
--new turret enemy
function create_turret(x,y)
	local turret={x=x,y=y,sprite=3,name='turret'}
	turret.animtimer=0
	add(enemies,turret)
end
--new mucus projectile
function create_mucus(x,y)
	--maths that sets mucus velocity towards player
	local angle=atan2(player.x+32-x,player.y-y)
	local velocityx=cos(angle)*1.5
	local velocityy=sin(angle)*1.5
	local mucus={x=x,y=y,vx=velocityx,vy=velocityy,sprite=50}
	mucus.name='mucus'
	mucus.animtimer=0
	add(enemies,mucus)
end
--add name to blob enemy
function create_enemy(x,y)
	enemy.name='blob'
end