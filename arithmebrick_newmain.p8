pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
 cls()
 mode="start"
end
 
function _update60()
 if mode=="game" then
  update_game()
 elseif mode=="start" then
  update_start()
 elseif mode=="gameover" then
  update_gameover()
 end
end
 
function update_start()
 if btn(4) then
  startgame()
 end
end
 
function startgame()
 mode="game"
 ball_r=2
 ball_dr=0.5
 
 pad_x=52
 pad_y=120
 pad_dx=0
 pad_w=24
 pad_h=3
 pad_c=7
 
 lives=3
 points=0
 serveball()
end
 
function serveball()
 ball_x=5
 ball_y=33
 ball_dx=1
 ball_dy=1
end
 
function gameover()
 mode="gameover"
end
 
function update_gameover()
 if btn(4) then
  startgame()
 end 
end
 
function update_game()
 local buttpress=false
 local nextx,nexty
 
 if btn(0) then
  --left
  pad_dx=-2.5
  buttpress=true
  --pad_x-=5
 end
 if btn(1) then
  --right
  pad_dx=2.5
  buttpress=true
  --pad_x+=5 
 end
 if not(buttpress) then
  pad_dx=pad_dx/1.3
 end
 pad_x+=pad_dx
 
 nextx=ball_x+ball_dx
 nexty=ball_y+ball_dy
 
 if nextx > 124 or nextx < 3 then
  nextx=mid(0,nextx,127)  
  ball_dx = -ball_dx
  sfx(0)
 end
 if nexty < 10 then
  nexty=mid(0,nexty,127) 
  ball_dy = -ball_dy
  sfx(0)
 end
 
 -- check if ball hit pad
 if ball_box(nextx,nexty,pad_x,pad_y,pad_w,pad_h) then
  -- deal with collision
  if deflx_ball_box(ball_x,ball_y,ball_dx,ball_dy,pad_x,pad_y,pad_w,pad_h) then
   ball_dx = -ball_dx
  else
   ball_dy = -ball_dy
  end
  sfx(1)
  points+=1
 end
 
 ball_x=nextx
 ball_y=nexty
 
 if nexty > 127 then
  sfx(2)
  lives-=1
  if lives<0 then
   gameover()
  else
   serveball()
  end
 end
end
 
 
function _draw()
 if mode=="game" then
  draw_game()
 elseif mode=="start" then
  draw_start()
 elseif mode=="gameover" then
  draw_gameover()
 end
end
 
function draw_start()
 cls()
 print("lazydevs_breakout",30,40,7)
 print("press -z- to start",32,80,11)
end
 
function draw_gameover()
 --cls()
 rectfill(0,60,128,75,0)
 print("game over",46,62,7)
 print("press ヌ█⬆️ to restart",27,68,6)
end
 
function draw_game()
 cls(1)
 circfill(ball_x,ball_y,ball_r, 10)
 rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,pad_c)
 
 rectfill(0,0,128,6,0)
 print("lives:"..lives,1,1,7)
 print("score:"..points,40,1,7)
 
end
 
function ball_box(bx,by,box_x,box_y,box_w,box_h)
 -- checks for a collion of the ball with a rectangle
 if by-ball_r > box_y+box_h then return false end
 if by+ball_r < box_y then return false end
 if bx-ball_r > box_x+box_w then return false end
 if bx+ball_r < box_x then return false end
 return true
end
 
function deflx_ball_box(bx,by,bdx,bdy,tx,ty,tw,th)
 -- calculate wether to deflect the ball
 -- horizontally or vertically when it hits a box
 if bdx == 0 then
  -- moving vertically
  return false
 elseif bdy == 0 then
  -- moving horizontally
  return true
 else
  -- moving diagonally
  -- calculate slope
  local slp = bdy / bdx
  local cx, cy
  -- check variants
  if slp > 0 and bdx > 0 then
   -- moving down right
   debug1="q1"
   cx = tx-bx
   cy = ty-by
   if cx<=0 then
    return false
   elseif cy/cx < slp then
    return true
   else
    return false
   end
  elseif slp < 0 and bdx > 0 then
   debug1="q2"
   -- moving up right
   cx = tx-bx
   cy = ty+th-by
   if cx<=0 then
    return false
   elseif cy/cx < slp then
    return false
   else
    return true
   end
  elseif slp > 0 and bdx < 0 then
   debug1="q3"
   -- moving left up
   cx = tx+tw-bx
   cy = ty+th-by
   if cx>=0 then
    return false
   elseif cy/cx > slp then
    return false
   else
    return true
   end
  else
   -- moving left down
   debug1="q4"
   cx = tx+tw-bx
   cy = ty-by
   if cx>=0 then
    return false
   elseif cy/cx < slp then
    return false
   else
    return true
   end
  end
 end
 return false
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
