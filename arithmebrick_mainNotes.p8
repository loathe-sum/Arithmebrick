pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
 cls()
 mode="start"
 -- particle tables
 prts={}
 lft_prts={}
 ryt_prts={}
 -- start text flash
 strt_txt_clr=7
 strt_txt_flsh=1
 z_text_clr=11
 z_text_flsh=.1
 flsh_mod=.2
 ball_clr=7
end
 
function _update60()
-- 60fps checks game state
 if mode=="game" then
  update_game()
 elseif mode=="start" then
  update_start()
 elseif mode=="gameover" then
  update_gameover()
 end
end
 
function update_start()

 -- flashing press z text
 z_text_clr+=z_text_flsh
 if z_text_clr <8 or z_text_clr >15
 then
 z_text_flsh = -z_text_flsh
 end
 
 -- press x for vfx
 if btn(❎) then
  add(prts,{x=5+rnd(90),y=10})
  strt_txt_clr+=strt_txt_flsh
  if strt_txt_clr <3 or strt_txt_clr >14
  then strt_txt_flsh= -strt_txt_flsh
  end
 end
 
 
  for fuck in all(prts) do
  fuck.x+=1+rnd(3)
  fuck.y+=1+rnd(10)
  end
 
 -- press left for vfx 
 if btn(⬅️) then
  add(lft_prts,{x=47,y=63})
 end
  for left in all(lft_prts) do
  left.x+=1+rnd(2)
  left.y+=rnd(1)
  end
 -- press right for vfx 
  if btn(➡️) then
  add(ryt_prts,{x=79,y=61})
  end
  for right in all(ryt_prts) do
  right.x-=rnd(2)
  right.y+=rnd(1)
  end
  
 -- press z to start
 if btn(4) then
  startgame()
  sfx(4)
 end
end
 
function startgame()
 -- declaring global variables
 mode="game"
 ball_r=2
 ball_dr=0.5
 
 pad_x=51
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
 ball_y=31
 ball_dx=1
 ball_dy=1
end

function cust_min()

if ball_x<3 or ball_x>30
then
serveball()
end
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
 
 -- pad movement left
 if btn(0) then
  --left
  pad_dx=-2.5
  buttpress=true
  --pad_x-=5
 end
 -- pad movement right
 if btn(1) then
  --right
  pad_dx=2.5
  buttpress=true
  --pad_x+=5 
 end
 -- smooth/slow when released
 if not(buttpress) then
  pad_dx=pad_dx/1.8
 end
 -- pad location and smooth
 pad_x+=pad_dx
 -- creates next ball position
 -- adding current to delta
 nextx=ball_x+ball_dx
 nexty=ball_y+ball_dy
 
 -- bounce ball off sides
 if nextx > 124 or nextx < 3 then
  nextx=mid(0,nextx,127)  
  ball_dx = -ball_dx
  sfx(0)
 end
 -- bounce ball back from top
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
   sfx(3)
  else
   serveball()
  end
 end
end
 
 
function _draw()
-- 60fps check on what to draw
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
 prts_clr=10
 for fuck in all(prts) do
  circfill(fuck.x+rnd(3),fuck.y+rnd(5),1,prts_clr+(-16+rnd(31)))
 end
 for left in all(lft_prts) do
  circfill(left.x+rnd(3),left.y+rnd(10),1,prts_clr+rnd(5))
 end
 for right in all(ryt_prts) do
  circfill(right.x-rnd(3),right.y+rnd(10),1,prts_clr+rnd(4))
 end
 print("arithmebrick_test",30,40,strt_txt_clr)
 print("press -z- to start",28,80,z_text_clr)
end
 
function draw_gameover()
 --cls()
 rectfill(0,60,128,75,0)
 print("game over",46,62,7)
 print("press -z- to restart",27,68,6)
end
 
function draw_game()
 cls(1)
 -- center line for ref
 rectfill(63,0,63,127,14)
 -- center line for ref
 rectfill(0,63,127,63,14)
 circfill(ball_x,ball_y,ball_r, ball_clr)
 rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,pad_c)
 
 rectfill(0,0,128,6,0)
 print("balls:"..lives,1,1,7)
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
__sfx__
00010000123501235011340113401134011320113101131011320113003140035400374003a4003e4003f4000000000000000003f4003f4003e4003e4003c4003c4003b4003a4003940038400374000000000000
00010000163501635016350193501a340193301832019320193000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000021350203502725027250221501b05016350133500f3500c3500a350073500435002350003500035000000000000000000000000000000000000000000000000000000000000000000000000000000000
000600001c3501d450273502a4502e350274502e3501c45015450173500a350064400d330034300a330114300d130033200212000110000000000000000000000000000000000000000000000000000000000000
00040000165501455029550210502705028050225500b55026050095500c0502e550375101d5501c5503e550305002d500125000e5000e500175001b5001b5001850014500155001750012500195000e50000520
