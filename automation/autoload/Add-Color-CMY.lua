-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

include("karaskel.lua");
local tr = aegisub.gettext

script_name = tr"Add Màu Đặc Biệt"
script_description = tr"Cmy's add color"
script_author = "Cmy草莓"
script_version="2.0"

function string.vl(gt, ref)
    local vl = ""  
	for i = 1, ref do 
	    vl = vl .. gt end 
	return vl 
end 

Hex = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}

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
	
function HexToRef(hex)
    local htr = "" 
	for i = 1, 16 do 
	if hex == Hex[i] 
	    then htr = htr .. i-1 
	else htr = htr .. "" end 
	end 
	return htr 
end                                        

function RGB_to_HSV(RGB)  
    local B, G, R = int(HexToRef(RGB:sub(1,1)))*16+int(HexToRef(RGB:sub(2,2))), int(HexToRef(RGB:sub(3,3)))*16+int(HexToRef(RGB:sub(4,4))), int(HexToRef(RGB:sub(5,5)))*16+int(HexToRef(RGB:sub(6,6)))  
	local V = math.max(R,G,B) 
	local V2 = V-math.min(R,G,B)   
	local H, S   
	if V ~= 0 
	    then S = V2/V 
	else S = 0 end   
	if V == R 
	    then H = 60*(G-B)/V2 
	elseif V == G 
	    then H = 120+60*(B-R)/V2 
	else H = 240+60*(R-G)/V2 end 
	if H < 0 
	    then H = H+360 
	else H = H end 
	if RGB == '000000' 
	    then return 60,1,0 
	elseif RGB == 'FFFFFF' 
	    then return 0,0,1 
	else return H, S, V/255 end
end            

function Delete_tags(st, l)
    if st == "1" then sc = "" else sc = st end  
    text = l.text : gsub("\\" .. st .."vc%(&H([%x%.%-]+)&,&H([%x%.%-]+)&,&H([%x%.%-]+)&,&H([%x%.%-]+)&%)","") 
	: gsub("\\" .. st .."va%(&H([%x%.%-]+)&,&H([%x%.%-]+)&,&H([%x%.%-]+)&,&H([%x%.%-]+)&%)","")
	: gsub("\\".. sc .."c&H([%x%.%-]+)&","") 
	: gsub("\\".. st .."a&H(%x%x)&","")
	: gsub("(\\" .. st .."img[^\\]+)%)","")
	return text : gsub("{}", "") 
end

function SevenColor(l,text, ttm, stcl1, stcl2) 
	local h1, s1, v1 = RGB_to_HSV(stcl1)  
	local h2, s2, v2 = RGB_to_HSV(stcl2) 
	local runtext = text
	local svcl = "{\\%svc(%s,%s,%s,%s)}" 
	a = {} 
	a2 = {} 
	for i = 1, unicode.len(text) do 
	    for alp in unicode.chars(text) do 
		    a[i] = alp  
		end 
		if text == "" 
			then  break 
		end 
		text = text:sub(1,-#a[i]-1)  
	end;
	local text2 = "" 
	for z = 1,#a do 
	    ci = #a-z+1
		local sett = ""
		for i = 1,z do
		    if a[#a-i+1] == "{" 
			    then sett = sett .. "1"
			elseif a[#a-i+1] == "}"
                then sett = sett .. "2"
			else sett = sett .. ""	
			end
		end	
		local tpv = ""
		for i3 = 1,z do
			tpv = tpv .. a[#a-i3+1]
		end	
		tpv = tpv:gsub("{\\([^\\]+)}","")
		if tpv:match("{") then tpv = tpv:gsub("{\\([^\\]+)","") end
		local sett2 = sett:sub(-1)
		local ci2 = unicode.len(tpv)
		runtext = runtext:gsub("{\\([^\\]+)}","")
		maxt = unicode.len(l.text:gsub("{\\([^\\]+)}",""))
	    if sett2 == "1"  or a[ci] == "}" or a[ci] == "\\"
            then text2 = text2 .. a[ci]
		else text2 = text2 .. svcl:format(ttm, 
		ass_color(HSV_to_RGB((360/maxt*ci2+h1)%360, s1, v1)), 
		ass_color(HSV_to_RGB((360/maxt*(ci2+0.5)+h1)%360, s1, v1)), 
		ass_color(HSV_to_RGB((360/maxt*ci2+h2)%360, s2, v2)), 
		ass_color(HSV_to_RGB((360/maxt*(ci2+0.5)+h2)%360, s2, v2))) 
		.. a[ci] 
		end
	end;
	return text2
end ;

function add_tags(subs,sel)
    ADD=aegisub.dialog.display
    meta, styles = karaskel.collect_head(subs)
	for z, i in ipairs(sel) do
	l=subs[i]
    karaskel.preproc_line(subs, meta, styles, l) 	
menu1 = { 
    {x = 0, y = 0, width = 5, height = 1, class = "label", label = "Code by Cmy - 草莓Dâu Tây"}, 
	{x = 0, y = 1, width = 8, height = 1, class = "label", label = ('_'):vl(60)},
	{x = 0, y = 2, width = 1, height = 1, class = "label", label = "to. "},
	{x = 1, y = 2, width = 3, height = 1, class = "dropdown", name = "cl", items = {1,2,3,4}, value = 1, hint = "1. màu chữ\n2. màu sau\n3. màu viền\n4. màu bóng"},
	{x = 4, y = 2, width = 2, height = 1, class = "label", label = "kiểu màu. "},
	{x = 6, y = 2, width = 3, height = 1, class = "dropdown", name = "km", items = {"loang màu","7 màu","Màu nền png","Xóa tags màu"}, value = "loang màu", hint = "chọn kiểu màu"},
}  
    P1, res1 = ADD(menu1)
	
    if res1.km == "Màu nền png" and P1 then filename = aegisub.dialog.open('Chọn ảnh', '', '','(.png)|*.png', false, true) end
	if res1.cl == "1" then sc = "" else sc = res1.cl end  
	if l.text : match("\\".. sc .."c&H") then readc1 = l.text : match("\\".. sc .."c&H([%x%.%-]+)") else readc1 = (l.styleref['color'..res1.cl]):gsub("&H(%x%x)(%x%x)(%x%x)(%x%x)&","%2%3%4") end
	local readvc1, readvc2, readvc3, readvc4 = l.text:match("\\".. res1.cl .."vc%(&H([%x%.%-]+)&,&H([%x%.%-]+)&,&H([%x%.%-]+)&,&H([%x%.%-]+)")	
	if readvc1 and readvc2 and readvc3 and readvc4 
	    then readvc1, readvc2, readvc3, readvc4 = readvc1 : gsub("(%x%x)(%x%x)(%x%x)","#%3%2%1FF"), readvc2 : gsub("(%x%x)(%x%x)(%x%x)","#%3%2%1FF"), readvc3 : gsub("(%x%x)(%x%x)(%x%x)","#%3%2%1FF"), readvc4 : gsub("(%x%x)(%x%x)(%x%x)","#%3%2%1FF") 
	else readvc1, readvc2, readvc3, readvc4 = readc1 : gsub("(%x%x)(%x%x)(%x%x)","#%3%2%1FF"), readc1 : gsub("(%x%x)(%x%x)(%x%x)","#%3%2%1FF"), readc1 : gsub("(%x%x)(%x%x)(%x%x)","#%3%2%1FF"), readc1 : gsub("(%x%x)(%x%x)(%x%x)","#%3%2%1FF") 
	end

menu2 = { 
    {x = 0, y = 0, width = 1, height = 2, class = "label", label = "color 1."},
	{x = 1, y = 0, width = 2, height = 2, class = "coloralpha", name = "color1", value = readvc1, hint = "chọn màu góc trái trên"},
	{x = 4, y = 0, width = 1, height = 2, class = "label", label = "color 2."},
	{x = 5, y = 0, width = 2, height = 2, class = "coloralpha", name = "color2", value = readvc2, hint = "chọn màu góc phải trên"},
	{x = 0, y = 2, width = 1, height = 2, class = "label", label = "color 3."},
	{x = 1, y = 2, width = 2, height = 2, class = "coloralpha", name = "color3", value = readvc3, hint = "chọn màu góc trái dưới"},
	{x = 4, y = 2, width = 1, height = 2, class = "label", label = "color 4."},
	{x = 5, y = 2, width = 2, height = 2, class = "coloralpha", name = "color4", value = readvc4, hint = "chọn màu góc phải dưới"},
}

    if P1 and res1.km ~= "Xóa tags màu" and res1.km ~= "Màu nền png" then P, res = ADD(menu2) end 

    add_color = "{\\%dvc(%s,%s,%s,%s)}"  
    add_alpha =	"{\\%dva(%s,%s,%s,%s)}"
	local runcl, runalpha
	if P1 and res1.km ~= "Xóa tags màu" and res1.km ~= "Màu nền png" then runcl, runalpha = add_color:format(res1.cl,
	res.color1:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%3%2%1&"),
	res.color2:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%3%2%1&"),
	res.color3:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%3%2%1&"),
	res.color4:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%3%2%1&"))
	, add_alpha:format(res1.cl,
	res.color1:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&"),
	res.color2:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&"),
	res.color3:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&"),
	res.color4:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&")) 
	else runcl = "" end
	if P1 and res1.km ~= "Màu nền png" 
	and res.color1:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&") == res.color2:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&") 
	and res.color2:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&") == res.color3:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&")
	and res.color3:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&") == res.color4:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&")
	then runalpha = ("{\\%da%s}"):format(res1.cl,res.color1:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","&H%4&")) end
	if filename then runpngcl = ("{\\%dimg(%s,0,0)}"):format(res1.cl,filename:gsub("\\","/")) else runpngcl = "" end
	
		if P and P1 and res1.km == "loang màu" 
		    then l.text = (runcl .. runalpha .. Delete_tags(res1.cl, l)):gsub("}{","") 
		elseif P and P1 and res1.km == "7 màu" 
		    then l.text = (runalpha .. SevenColor(l, Delete_tags(res1.cl, l), res1.cl, res.color1:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","%3%2%1"), res.color3:gsub("#(%x%x)(%x%x)(%x%x)(%x%x)","%3%2%1"))):gsub("}{","") 
		elseif P1 and res1.km == "Màu nền png" 
		    then l.text = (runpngcl .. Delete_tags(res1.cl, l)):gsub("}{","") 
		elseif P1 
		    then l.text = Delete_tags(res1.cl, l):gsub("}{","") end
		subs[i] = l
	end
end

aegisub.register_macro(script_name,script_description,add_tags)