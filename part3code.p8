--new code reference for space shooter
--see full project in github for full context

--within _init()
player.sprites={1,17} --player sprite table
player.animtimer=0 --player animation timer
explosions={} --expl;osions table
stars = {} -- background stars table
for i=0,24 do -- populate starts table with 24 stars
	add(stars,{
		x=rnd(128),
		y=rnd(128),
		speed=rnd(10)+1
	})
end

--within _update()
if btn(2) and not btn(3) then --banking left
	player.sprites = {33,49}
elseif btn(3) and not btn(2)then -- banking right
	player.sprites = {32,48}
else -- flying straight
	player.sprites = {1,17}
end

--within _draw()
for enemy in all(enemies) do
	enemy.animtimer+=1 -- increment enemy animation timer
	--assign sprite to be drawn depending on enemy speed
	enemy.sprite = enemy.sprites[flr(enemy.animtimer/5-enemy.speed*3)%#enemy.sprites+1]
	outline_spr(enemy.sprite,enemy.x,enemy.y)
end


rectfill(0,0,128,128,1) --draw background
for star in all(stars)do
	star.x -= star.speed --move star left
	pset(star.x,star.y,7) --draw star as white dot
	if star.x < 0 then --if off screen then reset
		star.x = 128
		star.y=rnd(128)
	end
end


--within create_enemy()
enemy.sprites={2,18,2,34} --sprite set
enemy.animtimer=0 -- timer for animations

--new functions
function create_explosion(x,y,radius)
 local explosion={
  x=x,
  y=y,
  radius=radius,
  timer=0,
 }
 add(explosions,explosion)
end

--draw explosions
function draw_explosion(explosion)
 if explosion.timer<2 then -- white filled circle
  circfill(explosion.x,explosion.y,explosion.radius,7)
 elseif explosion.timer<4 then -- red filled circle 
  circfill(explosion.x,explosion.y,explosion.radius,8)
 elseif explosion.timer<5 then -- organge circle
  circ(explosion.x,explosion.y,explosion.radius,9)
  del(explosions,explosion) -- delete
  return
 end
 explosion.timer+=1
end

function outline_spr(sprite,x,y)
 for i=1,15 do --set all colours to black
  pal(i,0)
 end
 for xoffset=-1,1 do --draw sprites offset by
  for yoffset=-1,1 do --1 pixel in each direction
   spr(sprite,x+xoffset,y+yoffset)
  end
 end
 pal() --reset palette back to normal
 spr(sprite,x,y)  --draw main sprite
end