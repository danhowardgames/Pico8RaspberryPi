--attack of the green blobs
--by dan lambton-howard
function _init() -- called once at start
	player = {x=20, y=64, sprite=1} --player table
	enemies = {}
	lasers = {} 
	create_wave(rnd(6)+5) --start game with a wave
	wavetimer = 0
	waveintensity = 5
	score = 0
end

function _update() -- called 30 times per second
	wavetimer+=1
	if not gameover then --only move the player if not gameover
		if btn(0) then player.x-=2 end
		if btn(1) then player.x+=2 end
		if btn(2) then player.y-=2 end
		if btn(3) then player.y+=2 end	
		if btnp(4) then create_laser(player.x+5,player.y+3) end	
	end
	--stop player going off screen edges
	player.x=mid(0,player.x,120)
	player.y=mid(0,player.y,120)

	for enemy in all(enemies) do --enemy update loop
		enemy.x-=enemy.speed --move enemy left	
		for laser in all(lasers) do --check collision w.laser
			if enemy_collision(laser.x,laser.y,enemy) then
				del(enemies,enemy)
				del(lasers,laser)
				score+=100
			end
		 end
	 	--check collision w/ player
		if enemy_collision(player.x+4,player.y+4,enemy) then
			gameover = true
		end
		--delete enemy if off screen
		if enemy.x<-8 then
			del(enemies,enemy)
		end	 
	end
	
	for laser in all(lasers) do --laser update loop
		laser.x+=3 --move laser to the right
		if laser.x>130 then --delete laser if off screen
			del(lasers,laser)
		end
	end
	
	if wavetimer==90 then --every 3 seconds spawn wave
		create_wave(rnd(6)+waveintensity)
		wavetimer=0 -- reset timer
		waveintensity+=1
	end
end

function _draw() --called 30 times per second
	cls() --clear screen
	if not gameover then
		spr(player.sprite,player.x,player.y) --draw player
	end
	
	for enemy in all(enemies) do --draw enemies
		spr(enemy.sprite,enemy.x,enemy.y)
	end
	
	for laser in all(lasers) do --draw lasers
		rect(laser.x,laser.y,laser.x+2,laser.y+1,8)
	end
	
	if gameover then --print game over to screen
		print('game over',50,64,7)
	end
	print('score: '..score,2,2,7) --show score on screen
end
--creates an enemy at x,y with random speed 1-2
function create_enemy(x,y)
	enemy={x=x,y=y,speed=rnd(1)+1,sprite=2}
	add(enemies,enemy)
end
--spawns a wave of enemies off screen
function create_wave(size)
	for i=1,size do create_enemy(256,rnd(128)) end
end

function create_laser(x,y)
	laser = {x=x,y=y}	
	add(lasers,laser)
end
--returns true if x,y are within a 8x8 rectangle around enemy
function enemy_collision(x,y,enemy)
	if x>=enemy.x and x<=enemy.x+8 and y>=enemy.y and y<=enemy.y+8 then
		return true
	end
	return false
end