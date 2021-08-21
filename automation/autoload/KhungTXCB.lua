-- 草莓Dâu Tây 's Type Fx Vert
-- Edit by Effector Cmy

local tr = aegisub.gettext
include("karaskel.lua")

script_name = tr"Khung TXCB2"
script_description = tr"Cmy's Clip to Draw"
script_author = "Niels Martin Hansen"
script_version = "1"

function setnb(ref) 
    local snb = ""   
	for i = 1, 10 do 
	    if ref == ('%s') : format(i-1) or ref == "." 
		    then snb = snb .. "1" break 
		else snb = snb .. "" end 
		end 
		return snb 
	end ;                      
	
function int(val)
    val = ('%s') : format(val) 
    local set_val = ""  
	for i = 1, val : len() do 
	    if setnb(val : sub(i, i)) ~= "1" 
		    then set_val = set_val .. "1" break 
		else set_val = set_val .. "" end 
		end ; 
		if set_val == "1" 
		    then return 0 
		else return ('%d') : format(val) end 
	end ;
	
	kk = {"Khung 1","Khung 1 Trái - Phải","Khung 1 Phải - Trái","Khung 1 Trên - Dưới","Khung 1 Dưới - Trên","Khung 2","Khung 2 Trái - Phải","Khung 3","Khung 3 Trái - Phải","Khung 4 loop 1","Khung 4 loop 2","Khung 4 -> loop 1","Khung 4 -> loop 2"} 

function add_khung(subtitles, selected_lines, active_line)
    ADD = aegisub.dialog.display
	for z, i in ipairs(selected_lines) do
		local l = subtitles[i]
menu = {
    {x = 0, y = 0, width = 15, class = "dropdown", name = "drd", items = kk, value = kk[1]},
	{x = 0, y = 1, width = 15, class = "intedit", name = "time", value = 400},
} 
    P, res = ADD(menu)
	
	text = l.text : gsub("^({\\[^}]-}).*","%1")
	text = text : gsub("\\an%d","")
	text = text : gsub("\\p%d","")
	text = text : gsub("\\fscx[%d%.]+","")
	text = text : gsub("\\fscy[%d%.]+","")
	text = text : gsub("\\bord[%d%.]","")
	text = text : gsub("\\shad[%d%.]","")
	rclip_x1,rclip_y1,rclip_x2,rclip_y2 = text : match("\\clip%(([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)%)")  
	if not rclip_x1 then rclip_x1,rclip_y1,rclip_x2,rclip_y2 = 0,0,0,0 end      
	if text:match("\\pos") 
	    then xx,yy=text:match("\\pos%(([%d%.%-]+),([%d%.%-]+)%)") 
	else xx,yy=(rclip_x1+rclip_x2)/2,(rclip_y1+rclip_y2)/2
	end
	pos_tags = "\\pos("..xx..","..yy..")" 
	sh = {width = rclip_x2-rclip_x1, height = rclip_y2-rclip_y1, top = rclip_y1-yy, bottom = rclip_y2-yy, left = rclip_x1-xx, right = rclip_x2-xx}
	
    if res.drd == kk[1] 
        then add_tags, shape = pos_tags .. "\\p1\\an7\\fscx100\\fscy100\\bord0\\shad0", ("m %d %d l %d %d l %d %d l %d %d "):format(rclip_x1-xx,rclip_y1-yy,rclip_x2-xx,rclip_y1-yy,rclip_x2-xx,rclip_y2-yy,rclip_x1-xx,rclip_y2-yy)   
	elseif res.drd == kk[2]	
	    then add_tags, shape = pos_tags .. "\\p1\\an7\\fscx100\\fscy100\\bord0\\shad0" .. ("\\clip(%d,%d,%d,%d)\\t(%d,%d,\\clip(%d,%d,%d,%d))"):format(rclip_x1-10,rclip_y1-10,rclip_x1-10,rclip_y2+10,0,res.time,rclip_x1-10,rclip_y1-10,rclip_x2+10,rclip_y2+10), ("m %d %d l %d %d l %d %d l %d %d "):format(rclip_x1-xx,rclip_y1-yy,rclip_x2-xx,rclip_y1-yy,rclip_x2-xx,rclip_y2-yy,rclip_x1-xx,rclip_y2-yy) 
	elseif res.drd == kk[3]	
	    then add_tags, shape = pos_tags .. "\\p1\\an7\\fscx100\\fscy100\\bord0\\shad0" .. ("\\clip(%d,%d,%d,%d)\\t(%d,%d,\\clip(%d,%d,%d,%d))"):format(rclip_x2+10,rclip_y1-10,rclip_x2+10,rclip_y2+10,0,res.time,rclip_x1-10,rclip_y1-10,rclip_x2+10,rclip_y2+10), ("m %d %d l %d %d l %d %d l %d %d "):format(rclip_x1-xx,rclip_y1-yy,rclip_x2-xx,rclip_y1-yy,rclip_x2-xx,rclip_y2-yy,rclip_x1-xx,rclip_y2-yy) 
	elseif res.drd == kk[4]	
	    then add_tags, shape = pos_tags .. "\\p1\\an7\\fscx100\\fscy100\\bord0\\shad0" .. ("\\clip(%d,%d,%d,%d)\\t(%d,%d,\\clip(%d,%d,%d,%d))"):format(rclip_x1-10,rclip_y1-10,rclip_x2+10,rclip_y1-10,0,res.time,rclip_x1-10,rclip_y1-10,rclip_x2+10,rclip_y2+10), ("m %d %d l %d %d l %d %d l %d %d "):format(rclip_x1-xx,rclip_y1-yy,rclip_x2-xx,rclip_y1-yy,rclip_x2-xx,rclip_y2-yy,rclip_x1-xx,rclip_y2-yy) 
	elseif res.drd == kk[5]	
	    then add_tags, shape = pos_tags .. "\\p1\\an7\\fscx100\\fscy100\\bord0\\shad0" .. ("\\clip(%d,%d,%d,%d)\\t(%d,%d,\\clip(%d,%d,%d,%d))"):format(rclip_x1-10,rclip_y2+10,rclip_x2+10,rclip_y2+10,0,res.time,rclip_x1-10,rclip_y1-10,rclip_x2+10,rclip_y2+10), ("m %d %d l %d %d l %d %d l %d %d "):format(rclip_x1-xx,rclip_y1-yy,rclip_x2-xx,rclip_y1-yy,rclip_x2-xx,rclip_y2-yy,rclip_x1-xx,rclip_y2-yy) 
	elseif res.drd == kk[6]	
	    then add_tags, shape = pos_tags .. "\\p1\\an7\\fscx100\\fscy100\\bord3\\shad0\\c&HFFFFFF&\\3vc(&HE2C3A8&,&HE2C3A8&,&HECDBB1&,&HECDBB1&)" .. ("\\clip(%d,%d,%d,%d)"):format(rclip_x1+1,rclip_y1-10,rclip_x2+10,rclip_y2+10), ("m %d %d l %d %d l %d %d l %d %d "):format(rclip_x1-xx,rclip_y1-yy,rclip_x2-xx,rclip_y1-yy,rclip_x2-xx,rclip_y2-yy,rclip_x1-xx,rclip_y2-yy) 
	elseif res.drd == kk[7]	
	    then add_tags, shape = pos_tags .. "\\p1\\an7\\fscx100\\fscy100\\bord3\\shad0\\c&HFFFFFF&\\3vc(&HE2C3A8&,&HE2C3A8&,&HECDBB1&,&HECDBB1&)" .. ("\\clip(%d,%d,%d,%d)\\t(%d,%d,\\clip(%d,%d,%d,%d))"):format(rclip_x1,rclip_y1-10,rclip_x1,rclip_y2+10,0,res.time,rclip_x1+1,rclip_y1-10,rclip_x2+10,rclip_y2+10), ("m %d %d l %d %d l %d %d l %d %d "):format(rclip_x1-xx,rclip_y1-yy,rclip_x2-xx,rclip_y1-yy,rclip_x2-xx,rclip_y2-yy,rclip_x1-xx,rclip_y2-yy) 
	elseif res.drd == kk[8] 
        then add_tags, shape = pos_tags .. "\\p1\\an7\\fscx100\\fscy100\\xbord18\\ybord3\\shad0\\c&HFFFFFF&\\3c&HF5C387&", ("m %d %d l %d %d l %d %d l %d %d l %d %d l %d %d l %d %d l %d %d l %d %d l %d %d "):format(sh.left-sh.height/4,sh.top,sh.right+sh.height/4,sh.top,sh.right+sh.height/4,sh.top+sh.height/4,sh.right,0,sh.right+sh.height/4,sh.bottom-sh.height/4,sh.right+sh.height/4,sh.bottom,sh.left-sh.height/4,sh.bottom,sh.left-sh.height/4,sh.bottom-sh.height/4,sh.left,0,sh.left-sh.height/4,sh.top+sh.height/4) 
	elseif res.drd == kk[9] 
        then add_tags, shape = pos_tags .. "\\p1\\an7\\fscx100\\fscy100\\xbord18\\ybord3\\shad0\\c&HFFFFFF&\\3c&HF5C387&" .. ("\\clip(%d,%d,%d,%d)\\t(%d,%d,\\clip(%d,%d,%d,%d))"):format(rclip_x1-sh.height/2,rclip_y1-sh.height/2,rclip_x1-sh.height/2,rclip_y2+sh.height/2,0,res.time,rclip_x1-sh.height/2,rclip_y1-sh.height/2,rclip_x2+sh.height/2,rclip_y2+sh.height/2), ("m %d %d l %d %d l %d %d l %d %d l %d %d l %d %d l %d %d l %d %d l %d %d l %d %d "):format(sh.left-sh.height/4,sh.top,sh.right+sh.height/4,sh.top,sh.right+sh.height/4,sh.top+sh.height/4,sh.right,0,sh.right+sh.height/4,sh.bottom-sh.height/4,sh.right+sh.height/4,sh.bottom,sh.left-sh.height/4,sh.bottom,sh.left-sh.height/4,sh.bottom-sh.height/4,sh.left,0,sh.left-sh.height/4,sh.top+sh.height/4) 
	elseif res.drd == kk[10] 
        then add_tags, shape = pos_tags .. ("\\clip(%d,%d,%d,%d)\\p1\\an7\\fscx100\\fscy100\\bord3\\shad0\\c&HBA330B&\\3c&HFCCDCD&"):format(rclip_x1+1,rclip_y1-10,rclip_x2+sh.height,rclip_y2+10), ("m %d %d l %d %d l %d %d l %d %d l %d %d "):format(rclip_x1-xx,rclip_y1-yy,rclip_x2-xx,rclip_y1-yy,rclip_x2-xx+sh.height/2,rclip_y1-yy+sh.height/2,rclip_x2-xx,rclip_y2-yy,rclip_x1-xx,rclip_y2-yy)
	elseif res.drd == kk[11] 
        then add_tags, shape = pos_tags .. "\\p1\\an7\\fscx100\\fscy100\\bord3\\shad0\\1vc(&HFCCDCD&,&HFCCDCD&,&HEFB486&,&HEFB486&)\\3vc(&HFCCDCD&,&HFCCDCD&,&HEFB486&,&HEFB486&)",("m %d %d l %d %d l %d %d l %d %d l %d %d l %d %d"):format(rclip_x2-xx,rclip_y1-yy,rclip_x2-xx+sh.height/2,rclip_y1-yy+sh.height/2,rclip_x2-xx,rclip_y2-yy,rclip_x2-xx,rclip_y2-yy-sh.height/4,rclip_x2-xx+sh.height/4,rclip_y2-yy-sh.height/2,rclip_x2-xx,rclip_y1-yy+sh.height/4)
	elseif res.drd == kk[12] 
        then add_tags, shape = ("\\move(%d,%d,%d,%d,20,%d)\\clip(%d,%d,%d,%d)\\p1\\an7\\fscx100\\fscy100\\bord3\\shad0\\c&HBA330B&\\3c&HFCCDCD&"):format(xx-sh.width,yy,xx,yy,res.time,rclip_x1+1,rclip_y1-10,rclip_x2+sh.height,rclip_y2+10), ("m %d %d l %d %d l %d %d l %d %d l %d %d "):format(rclip_x1-xx,rclip_y1-yy,rclip_x2-xx,rclip_y1-yy,rclip_x2-xx+sh.height/2,rclip_y1-yy+sh.height/2,rclip_x2-xx,rclip_y2-yy,rclip_x1-xx,rclip_y2-yy)
	elseif res.drd == kk[13] 
        then add_tags, shape = ("\\move(%d,%d,%d,%d,20,%d)\\p1\\an7\\fscx10\\fscy10\\t(0,%d,\\fscx100\\fscy100)\\bord3\\shad0\\1vc(&HFCCDCD&,&HFCCDCD&,&HEFB486&,&HEFB486&)\\3vc(&HFCCDCD&,&HFCCDCD&,&HEFB486&,&HEFB486&)"):format(xx-sh.width,yy,xx,yy,res.time,res.time/5),("m %d %d l %d %d l %d %d l %d %d l %d %d l %d %d"):format(rclip_x2-xx,rclip_y1-yy,rclip_x2-xx+sh.height/2,rclip_y1-yy+sh.height/2,rclip_x2-xx,rclip_y2-yy,rclip_x2-xx,rclip_y2-yy-sh.height/4,rclip_x2-xx+sh.height/4,rclip_y2-yy-sh.height/2,rclip_x2-xx,rclip_y1-yy+sh.height/4)
	end
	
	if rclip_x1 ~= 0 and rclip_x2 ~= 0 and rclip_y1 ~= 0 and rclip_y2 ~= 0 
	    then text = text .. shape end   
		text = text : gsub("\\pos%(([%d%.%-]+),([%d%.%-]+)%)","")
		text = text : gsub("\\clip%(([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)%)",add_tags)   
		
	if P and rclip_x1 ~= 0 and rclip_x2 ~= 0 and rclip_y1 ~= 0 and rclip_y2 ~= 0 
		then l.text = text end
		subtitles[i] = l
	end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, tr"Adds khung tags to all selected lines", add_khung)
