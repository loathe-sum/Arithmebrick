pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- arithmebrick
-- dont go down #include rabbit hole

function _init()
    cls(3)
end

function _update()

 -- ---button controls---

 -- button press check to change speed when released
 but_press=false
 -- left/⬅️
 if btn(0) then
 pad_xs-=3
 -- says button is not pressed
 -- when released (by checking)
 -- x axis
 but_press=false
 end


 -- right/➡️
 if btn(1) then
 pad_xs+=3
 -- says button is not pressed when released
 but_press=false
 end

 -- if button not pressed
 -- then slow down speed
 if not(but_press) then
  pad_xs=pad_xs/1.6
 end

 -- tutorial ball modifiers
 ball_x+=ball_xs
 ball_y+=ball_ys
 ball_rad+=ball_radm
 ball_clr+=ball_clrm

 -- tutorial pad modifiers
 pad_x+=pad_xs

 -- tutorial ball limits

 -- color flash range
 if (ball_clr<10)
 or (ball_clr>12)
 then ball_clrm= -ball_clrm
 end

 -- x limit check
 if (ball_x<1) or
 (ball_x>125)  then
 ball_xs= -ball_xs
 -- play sfx 1 at x edge
 sfx(0)
 end
 -- y limit check
 if (ball_y<1) or
 (ball_y>125)  then
 ball_ys= -ball_ys
 -- play sfx 1 at x edge
 sfx(0)
 end

 -- radius limit
 if (ball_rad<1) or
 (ball_rad>4)
 then
 ball_radm= -ball_radm
 end

 -- gives ball_spr a speed
 ball_spr_x+=ball_spr_xs
 ball_spr_y+=ball_spr_ys

 -- checks x limits
 if (ball_spr_x<1) or
 (ball_spr_x>125)  then
 ball_spr_xs= -ball_spr_xs
 -- play sfx 1 at x edge
 sfx(1)
 end

 -- checks y limits
 if (ball_spr_y<1) or
 (ball_spr_y>125)  then
 -- if min or max reached,
 -- inverts speed to send back
 ball_spr_ys= -ball_spr_ys
 -- play sfx 1 at y edge
 sfx(1)
 end
 -- default pad color
 pad_clr=7
 -- if ball hits, change color of pad
if ball_hit_box(pad_x,pad_y,pad_w,pad_h,pad_clr) then
    pad_clr=8
    ball_ys= -ball_ys
end
-- if sprite hits, change color of pad
if ball_spr_hit_box(pad_x,pad_y,pad_w,pad_h,pad_clr) then
    pad_clr=12
    ball_spr_ys= -ball_spr_ys
end

end

function _draw()

 -- clear screen, set bg clr
 cls(3)
 -- draw rect to look like plat
 rectfill
 (
 pad_x,pad_y,
 pad_x+pad_w,pad_h+pad_y,
 pad_clr
 )

 -- tutorial ball
 circfill
 (
 ball_x,ball_y,
 ball_rad,ball_clr
 )

 -- main ball sprite
 spr(0,ball_spr_x,ball_spr_y)
end

 -- setup hitbox for the ball

function ball_hit_box
 --4 hit box coordinates
(box_x,box_y,box_w,box_h)
 
 --hitbox against pad_rect points
 if
 --upper point of ball
 (ball_y-ball_rad>box_y+box_h)
 then
 return false
 end
 if
 --upper lower point of ball
 (ball_y+ball_rad<box_y)
 then
 return false
 end
 if
 --left point of ball
 (ball_x-ball_rad>box_x+box_w)
 then
 return false
 end
 -- right point of ball
 if (ball_x+ball_rad < box_x)
 then
 return false
 end
 --if above 4 conditions false
 --then ball hitbox being
 --activated is true
 return true
 end
-- same set as 4 above but for sprite
function ball_spr_hit_box
    --establishes the same 4 points
    --as the pad
    (box_x,box_y,box_w,box_h)
    --hitbox against pad
    if
    (ball_spr_y-8>box_y+box_h)
    then
    return false
    end
    if
    (ball_spr_y+8<box_y)
    then
    return false
    end
    if
    (ball_spr_x-8>box_x+box_w)
    then
    return false
    end
    if (ball_spr_x+8<box_x)
    then
    return false
    end
    --if above 4 conditions false
    --then ball hitbox being
    --activated is true
    return true
end
-->8
-- global variables

-- tutorial ball

ball_x=rnd(109)
ball_xs=1
ball_y=1
ball_ys=1
ball_rad=2
ball_radm=.1
ball_clr=9
ball_clrm=.1

-- ball sprite

ball_spr_x=1    -- x position
ball_spr_xs=1.5 -- x speed
ball_spr_y=9    -- y position
ball_spr_ys=1.5   -- y speed
--ball_spr_rad=8-- 8x8 spr

-- pad rect

pad_x=52
pad_xs=0
pad_y=124
pas_ys=1
pad_w=24
pad_h=2
pad_clr=7
-->8
-- test container

--[[ function to do rnd(127) but 
set min to 19 rather than built in 0.
max is also built into rnd feature
and can be set rnd(#)
function spawn_x_min ()
    ball_spawn_x=rnd(127)
    if ball_spawn_x < 20 then
    ball_spawn_x=20
    end


end
]]

-- ray test for bounce calc


-- copy and pasted test function for ball bounce direction
-- split into quadrants for each direction of impact
-- can be multipurpose, like for when ball bounces into bricks instead of pad
-- it can have high accuracy collision detection
-- last function the crucial part
-- has the cases and switches

--start of test
--[[box_x=32
box_y=58
box_w=64
box_h=12
box_clr=10

ray_x= 0
ray_y= 0
ray_dx= -2
ray_dy= -2

debug1="swag"

function _init()
cls()
end
function _update()
 if btn(0) then ray_x-=1 end
 if btn(1) then ray_x+=1 end
 if btn(2) then ray_y-=1 end
 if btn(3) then ray_y+=1 end
end
function _draw()
 cls()
 rect(box_x,box_y,
 box_x+box_w,box_y+box_h,box_clr)
 local
 test_x,test_y = ray_x,ray_y
 repeat
  pset(test_x,test_y,8)
  test_x+=ray_dx
  test_y+=ray_dy
 until test_x<0 or test_x>128
 or test_y<0 or test_y>128
 if deflx_hitbox(ray_x,ray_y,
 ray_dx,ray_dy,box_x,box_y,box_w,box_h) then
  print ("horizontal")
 else
  print("vertical")
 end
 print(debug1)
end

-- function for how to deflect
-- from hitbox
function deflx_hitbox
-- defines arguments
-- b = ball , t = target
(bx,by,bdx,bdy,tx,ty,tw,th)
 --case 1, chk if moving vert 
 if bdx==0 then return false
 --case 2, chk if moving horiz
 elseif bdy==0 then return true

 else
 -- moving diagonally
 -- check slope
 local slope = bdy/bdx
 -- check coordinate
 local cx,cy
 -- check quadrants
 if slope > 0 and bdx > 0 then
  -- moving down right *wrong*
 	debug1="q1"
 	cx = tx-bx
 	cy = ty-by
 	if cx<=0 then 
 	 return false
 	elseif cy/cx<slope then 
 	 return true
  else 
   return false
  end
  elseif slope<0 and bdx>0 then
  debug1="q2"
  -- moving up right
  cx = tx-bx
  cy = ty+th-by
  if cx<=0 then  
  return false
  elseif cy/cx < slope then
  return false
  else return true
  end
  elseif 
  slope > 0 and bdx<0 then
  debug1="q3"
  -- moving left up
  cx = tx+tw-bx
  cy = ty+th-by
  if cx>=0 then
  return false
  elseif cy/cx > slope then
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
  elseif cy/cx < slope then
  return false
  else
  return true
  end
  end
 end
 return false
end]]

--end of test
__gfx__
00eeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e7777e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e787787e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e778877e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e778877e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e787787e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e7777e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00eeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00eeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e7777e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e7c77c7e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e77cc77e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e77cc77e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e7c77c7e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e7777e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00eeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000505022050260502a0502f05034050390503e0502a05019050130500805038000280001d0000f00006000010000000000000000000000000000010000000002000020000200002000020000100001000
00010000292502925029250282502825018250112500f2500d2500a25007250042500025000250002300220001200012000020000200000000000000000000000000000000000000000000000000000000000000
