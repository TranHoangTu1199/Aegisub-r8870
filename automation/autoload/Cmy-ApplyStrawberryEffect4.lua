-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

script_name = "Apply Strawberry Effect 4.0 new"
script_name1 = script_name .. "/Edit"
script_name2 = script_name .. "/Apply"
script_description = "Cmy's Tool"
script_author = "Cmy 草莓"
script_version = "4.0"

include "karaskel.lua"
Yutils = include "Yutils.lua"
local MHtext = loadstring "LJ 27? \r \n8r )    T?4    >5 'n?T?5 '? 4 2  >2 4  7'\a 4\b \b\b > <  '  '\a I\v?\n 7\t4\v 7\v\v6\f\b\f\f\f\f\f\f>\v =\tK?  T\t?4\a \a 7\b> =   T\a\b?H T?4\t   \b 7\a\b>\a =G  WriteFile\bstrloadstring\tchar\vstring\vinsert\tbyte\nclass\ttext\rReadFile?????                                                        link  9str  9ts 7ntext \r*textb \t!\f \f \fi \nf err    "

function class(strtb)
	local sefl = table : copy()
	if type(strtb) == "string" then
		for t in unicode.chars(str) do
			sefl : insert(t)
		end
	elseif type(strtb) == "table" then
		for i, v in ipairs(strtb) do
			sefl[i] = v
		end
		for k, v in pairs(strtb) do
			sefl[k] = v
		end
	end
	-- add
	sefl.add = function(sefl, atb, k)
		if not k or (k and k ~= "key") then
			local n = sefl : maxn()
			for i, v in ipairs(atb) do
				sefl : insert(v)
			end
		end
		if not k or (k and k ~= "index") then
			for k, v in pairs(atb) do
				if type(k) ~= "number" then
					sefl[k] = v
				end
			end
		end
		return sefl
	end
	-- do class
	sefl.do_class = function(sefl, fntb, i, j)
		for z = (i or 1), (j or sefl : maxn()) do
			if type(fntb) == "table" then
				sefl[z] = fntb[sefl[z]]
			elseif type(fntb) == "function" then
				sefl[z] = fntb(sefl[z])
			end
		end
		return sefl
	end
	-- cut
	sefl.cut = function(sefl, tbi, tbj, ctb) 
		local ntb = (ctb or Class({}))
		for i = tbi, tbj do
			ntb : insert(sefl[tbi])
			sefl : remove(tbi)
		end
		return ntb
	end
	-- random
	sefl.rand = function(sefl) return sefl[random(1, sefl : maxn())] end
	-- strip class
	sefl.del = function(sefl, tbi, tbj)
		if tbj then
			for i = tbi, tbj do
				sefl : remove(tbi)
			end
		else
			sefl : remove(tbi)
		end
		return sefl
	end
	-- class to string
	sefl.str = function(sefl, mode, i, j) 
		local apply = ""
		for z, v in ipairs(sefl) do
			if z >= (i or 1) and z <= (j or sefl : maxn()) then
				apply = apply .. tostring(v) .. (z < (j or sefl : maxn()) and (mode or "") or "")
			end
		end
		return apply
	end
	-- reverse class
	sefl.rev = function(sefl) 
		local ntb = sefl : copy() 
		for i = 1, sefl : maxn() do 
			ntb[i] = sefl[sefl : maxn() - i + 1] 
		end  
		sefl = ntb : copy()
		return sefl
	end
	return sefl
end

local __recode__ = function(cod)
	cod = cod 
		: gsub(" & ", " and ")
		: gsub(" | ", " or ")
		: gsub("&([%a_])", "_G.%1")
		: gsub("%.%%", ": u_format")
		: gsub("::s", ": u_sub")
		: gsub("::n", ": u_len()")
		: gsub("::u", ": u_upper()")
		: gsub("::l", ": u_lower()")
		: gsub("::x", ": hex()")
		: gsub("::h", ": hex(true)")
		: gsub("::b", ": bina()") 
		: gsub("::f", ": fload()")
		: gsub("::d", ": dec()")
		: gsub("0b([01]+)", "Binary_To_Dec(%1)")
		: gsub("~", " not ") : gsub("not =", "~=")
		: gsub("?(.-)%(", "RMB('%1',")
		: gsub("@(.-)%.", "rcall['%1']")
		: gsub("@([%w_]+)", "unpack_newline(%1)")
		: gsub("$%.(.-) do ([^\n]+)", "__ImportLybrary__([[%1]]).%2")
		: gsub("$%.([^\n]+)", "__ImportLybrary__([[%1]])")
		: gsub("$(.-)\n", "$%1    --code\n")
	return cod
end

rcall = {}

function RMB(key, value)
	rcall[key] = value
	return value
end

function GetCodeText(text)
	local str, show, appl = "", "", ""
	local set, set2, set3, set5, rl
	for t in unicode.chars(text) do
		if not set and t == "{" then t = "({" elseif not set and t == "}" then t = "})" end
		if not set3 then appl = appl .. t end
		if not set and t == "$" then set5 = true elseif (t == "?" or t == "\n" or t == "!") then set5 = false end
		if not set3 and (not set5) and not set and (t == "\"" or t == "'" or (appl : sub(-2)) == "[[") then 
			if (t == "\"" or t == "'") then setst = t else setst = "]]" end
			set = true
			show = show .. __recode__(appl)
			set2 = true
			appl = ""
			t = ""
		end
		str = str .. t
		
		if not set and (str : sub(-2) == "--") then set3 = true  set4 = "\n" appl = appl : sub(1, -3) end
		if set3 and (str : sub(-2) == "[[") then set4 = "]]" end
		if set3 and (str : sub(-#set4) == set4) then set3 = false if set4 == "\n" then appl = appl .. "\n" end end
		if (set and str : sub(-#setst) == setst) then 
			if (show : sub(-(#setst + 1))) == "r" .. (setst : gsub("%]", "[")) then rl = true else rl = false end
			if rl then
				show = show : sub(1, -(#setst + 2)) .. "(" .. (setst : gsub("%]", "[")) .. appl : gsub("\\", "\\\\") .. ")"
				rl = false
				set = false 
				appl = ""
			elseif str : sub(-3, -2) == "\\\\" or str : sub(-2, -2) ~= "\\" then
				show = show : sub(1, -(#setst + 1)) .. "(" .. (setst : gsub("%]", "[")) .. appl .. ")"
				set = false 
				rl = false
				appl = ""
			end
		end
	end
	if not set2 or (set2 and not set) then show = show .. __recode__(appl) end
	return show : gsub("\n\n", "\n \n")
end

for k, v in pairs(math) do
	_G[k] = v
end

function int(val)
	if tonumber(val) == nil then 
		return 0 
	else 
		return math.floor(val + 0.5)
	end 
end

Binary_To_Dec = function(bin)
	local bina = tonumber(bin)
	local i = 0
	local dec = 0
	while (bina > 0) do
		dec = dec + (bina % 10) * pow(2, i)
		i = i + 1
		bina = floor(bina / 10)
	end
	return dec
end

Dec_To_Binary = function(dec)
	local bin = 0
	local i = 0
	while dec > 0 do
		bin = bin + (dec % 2) * pow(10, i)
		i = i + 1
		dec = floor(dec / 2)
	end
	return bin
end

Hex_To_Dec = function(hex)
	local dec = loadstring("return 0x" .. hex)()
	return dec
end

function string.u_sub(str, ts1, ts2)
	local char_list = {}
	local ci = 1
	local intext, outtext
	if ts1 and ts1 > 0 then intext = ts1 elseif ts1 and ts1 < 0 then intext = unicode.len(str) + ts1 + 1 else intext = 1 end
	if ts2 and ts2 > 0 then outtext = ts2 elseif ts2 and ts2 < 0 then outtext = unicode.len(str) + ts2 + 1 else outtext = unicode.len(str) end
	local applytext = ""
	for ch in unicode.chars(str) do
		if ci >= intext and ci <= outtext then
			applytext = applytext .. ch
		elseif ci > outtext then
			break
		end
		ci = ci + 1
	end
	return applytext
end

lower_list = {"è","é","ẻ","ẽ","ẹ","ê","ề","ế","ể","ễ","ệ","ỳ","ý","ỷ","ỹ","ỵ","ù","ú","ủ","ũ","ụ","ư","ừ","ứ","ử","ữ","ự","ì","í","ỉ","ĩ","ị","ò","ó","ỏ","õ","ọ","ô","ồ","ố","ổ","ỗ","ộ","ơ","ờ","ớ","ở","ỡ","ợ","à","á","ả","ã","ạ","ă","ằ","ắ","ẳ","ẵ","ặ","â","ầ","ấ","ẩ","ẫ","ậ","đ"}      
upper_list = {'È','É','Ẻ','Ẽ','Ẹ','Ê','Ề','Ế','Ể','Ễ','Ệ','Ỳ','Ý','Ỷ','Ỹ','Ỵ','Ù','Ú','Ủ','Ũ','Ụ','Ư','Ừ','Ứ','Ử','Ữ','Ự','Ì','Í','Ỉ','Ĩ','Ị','Ò','Ó','Ỏ','Õ','Ọ','Ô','Ồ','Ố','Ổ','Ỗ','Ộ','Ơ','Ờ','Ớ','Ở','Ỡ','Ợ','À','Á','Ả','Ã','Ạ','Ă','Ằ','Ắ','Ẳ','Ẵ','Ặ','Â','Ầ','Ấ','Ẩ','Ẫ','Ậ','Đ'} 
local lower2upper = {}
local upper2lower = {}
for i = 1, #lower_list do
	lower2upper[lower_list[i]] = upper_list[i]
	upper2lower[upper_list[i]] = lower_list[i]
end

function string.u_lower(s)
	local str = ""
	for c in unicode.chars(s) do
		str = str .. (upper2lower[c] or c : lower())
	end
	return str
end

function string.u_upper(s)
	local str = ""
	for c in unicode.chars(s) do
		str = str .. (lower2upper[c] or c : upper())
	end
	return str
end

function string.u_len(s)
	return unicode.len(s)
end
	
function string.dec(r)
	local vl = tostring(r)
	if vl : match("B([01]+)") == vl : sub(2) then
		return Binary_To_Dec(vl : sub(2))
	elseif vl : match("H([%x]+)") == vl : sub(2) then
		return Hex_To_Dec(vl : sub(2))
	elseif type(r) == "number" then
		return int(r)
	else
		return unicode.codepoint(vl)
	end
end

function string.fload(r)
	local vl = tostring(r)
	if type(r) == "number" then
		return (vl : match("%.") and vl or vl .. ".0")
	else
		return (vl : match("%.") and unicode.codepoint(vl) or unicode.codepoint(vl) .. ".0")
	end
end

function string.hex(r, set)
	r = string.dec(r)
	local key
	if set then key = "%x" else key = "%X" end
	return key : format(r)
end

function string.bina(r)
	r = string.dec(r)
	return Dec_To_Binary(r)
end

function string.u_format(strvl, ...)
	local ds = {...}
	
	local to_ceil = function(r)
		if int(r) == 0 then
			return 0
		else
			return math.ceil(r)
		end
	end
	
	local to_floor = function(r)
		if int(r) == 0 then
			return 0
		else
			return math.floor(r)
		end
	end
	
	local get_text = function(ts1, ts2, ref)
		local vl = ds[tonumber(ts1) or 1]
		if (ts2 == "s" and ref) then
			return (vl .. (" ") : rep(tonumber(ref))) : sub(1, tonumber(ref))
		elseif not ts2 or ts2 == "s" then
			return vl
		elseif (ts2 == "i" and ref) then
			return (("0") : rep(tonumber(ref)) .. int(vl)) : sub(-tonumber(ref))
		elseif ts2 == "i" then
			return int(vl)
		elseif (ts2 == "d" and ref) then
			return (("0") : rep(tonumber(ref)) .. string.dec(vl)) : sub(-tonumber(ref))
		elseif ts2 == "d" then
			return string.dec(vl)
		elseif (ts2 == "f" and ref) then
			local ref1, ref2 = tostring(ref) : match("([%d-]+)%.([%d-]+)")
			if not ref1 then ref1 = ref end
			return (("0") : rep(tonumber(ref1)) .. string.fload(vl) .. (ref2 and ("0") : rep(tonumber(ref2)) or "")) : gsub("([%d-]+)%.([%d-]+)", function(pn, tp) pn = pn : sub(-ref1) if ref2 then tp = tp : sub(1, ref2) end return pn .. "." .. tp end)
		elseif ts2 == "f" then
			return string.fload(vl)
		elseif (ts2 == "x" and ref) then
			return (("0") : rep(tonumber(ref)) .. string.hex(vl)) : sub(-tonumber(ref))
		elseif ts2 == "x" then
			return string.hex(vl)
		elseif (ts2 == "h" and ref) then
			return (("0") : rep(tonumber(ref)) .. string.hex(vl, true)) : sub(-tonumber(ref))
		elseif ts2 == "h" then
			return string.hex(vl, true)
		elseif (ts2 == "b" and ref) then
			return (("0") : rep(tonumber(ref)) .. string.bina(vl)) : sub(-tonumber(ref))
		elseif ts2 == "b" then
			return string.bina(vl)
		elseif (ts2 == "l" and ref) then
			return (string.u_lower(vl) .. (" ") : rep(-tonumber(ref))) : sub(1, tonumber(ref))
		elseif ts2 == "l" then
			return string.u_lower(vl)
		elseif (ts2 == "u" and ref) then
			return (string.u_upper(vl) .. (" ") : rep(-tonumber(ref))) : sub(1, tonumber(ref))
		elseif ts2 == "u" then
			return string.u_upper(vl)
		elseif (ts2 == "<" and ref) then
			return (("0") : rep(tonumber(ref)) .. to_floor(vl)) : sub(-tonumber(ref))
		elseif ts2 == "<" then
			return to_floor(vl)
		elseif (ts2 == ">" and ref) then
			return (("0") : rep(tonumber(ref)) .. to_ceil(vl)) : sub(-tonumber(ref))
		elseif ts2 == ">" then
			return to_ceil(vl)
		end
	end
	
	local rttext = strvl : gsub("%%([%d]+)([sdfixluhb<>])([%d.-]+);", get_text) 
		: gsub("%%([%d]+)([sdfixluhb<>]);", get_text) : gsub("%%([%d]+);", get_text) 
		: gsub("%%([%d]+)([sdfixluhb<>])([%d.-]+)", get_text) 
		: gsub("%%([%d]+)([sdfixluhb<>])", get_text) : gsub("%%([%d]+)", get_text)
		
	return rttext
end

function RGB_to_HSV(RGB)  
    local B, G, R = Hex_To_Dec(RGB : sub(1, 2)), Hex_To_Dec(RGB : sub(3, 4)), Hex_To_Dec(RGB : sub(5, 6))
	local V = math.max(R, G, B) 
	local V2 = V - math.min(R, G, B)   
	local H, S   
	if V ~= 0 then 
		S = V2 / V 
	else 
		S = 0 
	end   
	if V == R then 
		H = 60 * (G - B) / V2 
	elseif V == G then 
		H = 120 + 60 * (B-R) / V2 
	else 
		H = 240 + 60 * (R - G) / V2 
	end 
	if H < 0 then 
		H = H + 360 
	else 
		H = H 
	end 
	if RGB == '000000' then 
		return 0, 1, 0 
	elseif RGB == 'FFFFFF' then 
		return 0, 0, 1 
	else 
		return H, S, V / 255 
	end
end

RememberTextList = {}

function toPixel(tb, rsizebool)
	local myClass = {}
	local s = table.copy(tb.s)
	if rsizebool then s.fontsize = rsizebool end
	local set_style = ("%s:%s:%s:%s:%s:%s:%s") : format(s.fontname, s.bold, s.italic, s.underline, s.strikeout, s.fontsize, tb.text_stripped)
	if tb.text_stripped ~= " " and not RememberTextList[set_style] then
		local shape = Yutils.decode.create_font(s.fontname, s.bold, s.italic, s.underline, s.strikeout, s.fontsize).text_to_shape(c.text_stripped) : gsub(" c", "")
		myClass.shape = function(rfn)
			if type(rfn) == "function" then
				return shape : gsub("([%d.-]+) ([%d.-]+)", rfn)
			else
				return shape : gsub("([%d.-]+)", int)
			end
		end
		local _width, _height = 0, 0
		shape : gsub("([%d.-]+) ([%d.-]+)", function(x, y) _width = max(_width, x) _height = max(_height, y)  return x .. y end )
		local testtb = Yutils.shape.to_pixels(shape)
		myClass.pxlist = testtb
		local str_text = "{\\p1}"
		local oldx, oldy = 0, 0
		local setalpha = ""
		--local _width, _height = tb.width * (rsizebool and rsizebool / tb.s.fontsize or 1), tb.height * (rsizebool and rsizebool / tb.s.fontsize or 1)
		local shapepx = ("m 0 0 l %1i 0 %1i 1 0 1") : u_format(_width)
		for i = 1, #testtb do
			local px = testtb[i]
			if px.y > oldy then
				str_text = str_text .. "{\\alpha&HFF&}"
				if oldx < _width then str_text = str_text .. ("m 0 0 l %1i 0 %1i 1 0 1") : u_format(_width - oldx) end
				str_text = str_text .. "{\\p0}\\N{\\p1}"
				if px.y - oldy > 1 then
					str_text = str_text .. string.rep(shapepx .. "{\\p0}\\N{\\p1}", px.y - oldy - 1)
				end
				setalpha = "\\alpha&H00&"
				oldy = px.y
				oldx = 0
			end
			if px.x - oldx > 1 then str_text = str_text .. ("{\\alpha&HFF&}m 0 0 l %d 0 %d 1 0 1") : format(px.x - oldx, px.x - oldx) setalpha = "\\alpha&H00&" end
			oldx = px.x
			str_text = str_text .. ("{%4\\x%1\\y%2\\al%3}m 0 0 l 1 0 1 1 0 1") : u_format(px.x, px.y, px.alpha, setalpha)
			setalpha = ""
		end
		if _height > oldy then 
			str_text = str_text .. "{\\alpha&HFF&}"
			if oldx < _width then str_text = str_text .. ("m 0 0 l %1i 0 %1i 1 0 1") : u_format(_width - oldx) end
			str_text = str_text .. string.rep("{\\p0}\\N{\\p1}" .. shapepx, _height - oldy) 
		end
		myClass.pixel = function(rtags)
			if type(rtags) == "function" then
				return str_text : gsub("\\x([%d.-]+)\\y([%d.-]+)\\al([%d.-]+)", rtags)
			else
				return str_text : gsub("\\x([%d.-]+)\\y([%d.-]+)\\al([%d.-]+)", "\\")
			end
		end
		RememberTextList[set_style] = {}
		RememberTextList[set_style].shape = myClass.shape
		RememberTextList[set_style].pixel = myClass.pixel
		RememberTextList[set_style].pxlist = myClass.pxlist
	elseif RememberTextList[set_style] then
		myClass.shape = RememberTextList[set_style].shape
		myClass.pixel = RememberTextList[set_style].pixel
		myClass.pxlist = RememberTextList[set_style].pxlist
	else
		myClass.shape = function() return "" end
		myClass.pixel = function() return "" end
		myClass.pxlist = {}
	end
	return myClass
end

function ReadFile(link)
	local file = io.open(link) 
	if file then
		local filetext = file : read("*a")
		file : close()
		return filetext
	else
		return "", "#" .. link .. "\n>>> does not exist\n\n"
	end
end

function WriteFile(link, text)
	local file = io.open(link, "w") 
	file : write(text)
	file : close()
end

function ScreenShow(sname, svalue, slist, set)
	local screen
	if not set then
		screen = display({
			{x = 0, y = 0, width = 20, height = 1, class = "label", label = sname};
			{x = 0, y = 1, width = 20, height = 1, class = "label", label = ("_") : rep(200)};
			{x = 0, y = 2, width = 20, height = 20, class = "textbox", text= svalue};
		}, slist)
	else
		screen = display({
			{x = 0, y = 0, width = 3, height = 1, class = "label", label = sname};
			{x = 0, y = 1, width = 3, height = 1, class = "label", label = ("_") : rep(100)};
			{x = 0, y = 2, width = 3, height = 2, class = "label", label = svalue};
		}, slist)
	end
	return screen
end

local function loadfn(code, mode)
	if code ~= "" then
		return ("cpm.%s = function() %s end\n") : format(mode, code)
	else
		return ""
	end
end

function Turn(ox, oy, width, g)
	local rdx, rdy = g * 0.0174533, (90 - g) * 0.0174533
	local rx, ry = ox - width * cos(rdx), oy + width * cos(rdy)
	return rx, ry
end

local rmbseting = {
	rstyle = true,
	layer = 0,
	loop = 0,
	effect = "-- no effect",
	fxlist = {"-- no effect"},
	stlist = {"-- only choosing line"},
	filelist = {},
	applyline = {}
}

local function SetAllTable(set, l, li)
	local char = {}
	local word = {}
	local kara = l.kara
	l.tags = ((l.text : match("{(.-)}") or "") .. set.edit)
	if l.tags : match("\\r([^\\]+)") then l.style = l.tags : match("\\r([^\\]+)") end
	l.s = styles[l.style]
	-- load tags pos/
	if l.tags : match("\\pos%(([%d.-]+),([%d.-]+)%)") then
		local x, y = l.tags : match("\\pos%(([%d.-]+),([%d.-]+)%)")
		if l.s.align % 3 == 1 then
			l.center = x + l.width/2
		elseif l.s.align % 3 == 2 then
			l.center = x
		else
			l.center = x - l.width/2
		end
		if l.s.align < 4 then
			l.middle = y - l.height / 2
		elseif l.s.align < 7 then
			l.middle = y
		else
			l.middle = y + l.height / 2
		end
		l.top = l.middle - l.height/2
		l.bottom = l.middle + l.height/2
		l.left = l.center - l.width/2
		l.right = l.left + l.width
	end
	l.x = l.center
	l.y = l.middle
	-- multi fx
	local mi = 0
	local multi = {}
	start_time = 0
	for wt, _ in (l.text : gsub("}{", "") : gsub("!(.-)!", "")) : gmatch("{(.-)}(.-)") do
		if wt : match("\\k([%d.]+)") then 
			mi = mi + 1 
			multi[mi] = {}
			multi[mi].start_time = start_time 
			multi[mi].duration = wt : match("\\k([%d.]+)") * 10
			multi[mi].end_time = multi[mi].start_time + multi[mi].duration
			start_time = multi[mi].end_time
		end
	end
	local ki, mi = 0, 0
	for i = 1, #multi do
		if kara[ki + 1] and multi[i].start_time >= kara[ki + 1].start_time then 
			ki = ki + 1 
			mi = 1 
		end
		if not kara[ki].multi then kara[ki].multi = {} end
		kara[ki].multi[mi] = multi[i]
		mi = mi + 1
	end
	-- loadtags
	local loadtags = function(ct, ci, li, wi, wn, cn, c, k)
		_tagcode = table.copy(_G)
		_tagcode.li = li
		_tagcode.ci = ci
		_tagcode.wi = wi
		_tagcode.ki = ki
		_tagcode.wn = wn
		_tagcode.cn = cn
		_tagcode.k = k
		_tagcode.c = c
		_tagcode.l = l
		local tagsl = ""
		local f, err = loadstring(GetCodeText(("%s\n return (%s)") : format(set.code, ct)))
		if err ~= nil then
			tagsl = ("<Error: %s : %s>") : format(ct, err)
		else
			setfenv(f, _tagcode)
			local res, val = pcall(f)
			if res then
				tagsl = val
			else
				tagsl = ("<Error: %s : %s>") : format(ct, val : gsub(":(%d):", function(r) return (r == "1" and " : line add code : " or " : line text : ") end))
			end
		end
		return tagsl
	end
	-- load color
	local setcolor = function(tagsraw, oldcl, tags)
	    local allcolor = {'', '', '', ''}
	    for i = 1, 4 do
	        if tagsraw : match("\\" .. (i == 1 and "c" or i .. "c") .."&([^\\]+)&") and tags[i == 1 and "c" or i .. "c"] then
	            allcolor[i] = "\\" .. (i == 1 and "c&" or i .. "c&") .. tags[i == 1 and "c" or i .. "c"] .. "&"
	        elseif tagsraw : match("\\" .. i .. "vc([^\\]+)") and tags[i .. "vc"] then
	            allcolor[i] = "\\" .. (i .. "vc") .. tags[i .. "vc"]
			elseif tagsraw : match("\\" .. i .. "img([^\\]+)") and tags[i .. "img"] then
	            allcolor[i] = "\\" .. (i .. "img") .. tags[i .. "img"]
			elseif oldcl : match("\\" .. (i == 1 and "c" or i .. "c") .."&([^\\]+)&") and tags[i == 1 and "c" or i .. "c"] then
	            allcolor[i] = "\\" .. (i == 1 and "c&" or i .. "c&") .. tags[i == 1 and "c" or i .. "c"] .. "&"
	        elseif oldcl : match("\\" .. i .. "vc([^\\]+)") and tags[i .. "vc"] then
	            allcolor[i] = "\\" .. (i .. "vc") .. tags[i .. "vc"]
			elseif oldcl : match("\\" .. i .. "img([^\\]+)") and tags[i .. "img"] then
	            allcolor[i] = "\\" .. (i .. "img") .. tags[i .. "img"]
			end
	    end
		return allcolor[1] .. allcolor[2] .. allcolor[3] .. allcolor[4], allcolor
	end
	local tagsallcolor
	-- set magic tags
	local mgstring = (l.tags : match("\\clip%((.-)%)") or "") .. " "
	-- table char
	local ci, olctext = 1, ""
	local wi, wn = 0, 1
	local setc = 0
	for chtext in unicode.chars(l.text : gsub("}#(.-){", "") : gsub("}{", "")) do
		olctext = olctext .. chtext
		if chtext == "{" then setc = setc + 1 end
		if setc == 0 then
			char[ci] = {}
			char[ci].text = olctext
			char[ci].text_stripped = char[ci].text : gsub("{(.*)}", "")
			if (ci > 1) and ((char[ci-1].text_stripped == " ") or (unicode.codepoint(char[ci-1].text_stripped) > 11903 )) then
				if (unicode.codepoint(char[ci].text_stripped) <= 11903 
				and unicode.codepoint(ci > 2 and char[ci-2].text_stripped or "a") > 11903 
				and char[ci-1].text_stripped == " ") then
					wn = wn - 1
				end
				wn = wn + 1
			end
			char[ci].wi = wn
			if not word[wn] then word[wn] = {} end
			word[wn].text = (word[wn].text or "") .. char[ci].text
			word[wn].text_stripped = word[wn].text : gsub("{(.-)}", "")
			if mgstring : match("([%d.-]+)%s([%d.-]+)") and wn > wi then
				word[wn].x, word[wn].y = mgstring : match("([%d.-]+)%s([%d.-]+)")
				local inset, outset = mgstring : find("([%d.-]+)%s([%d.-]+)")
				mgstring = mgstring : sub(outset + 1)
			end
			olctext = ""
			ci = ci + 1
			wi = wn
		end
		if chtext == "}" then setc = setc - 1 end
	end
	
	local settagspos = (word[1].text .. set.edit) : gsub("{(.-)}(.-)", "{%1}") : match("\\dn(%d)")
	local set_tags_h = (l.tags : match("\\h([%d]+)") or 100) / 100
	if settagspos and (settagspos % 2 == 1) then
		if l.s.align < 4 then
			l.y = l.middle - wn * (l.height * set_tags_h)
		elseif l.s.align < 7 then
			l.y = l.middle - (wn / 2 - 0.5) * (l.height * set_tags_h)
		else
			l.y = l.middle - (l.height * set_tags_h)
		end
		if l.s.align % 3 == 1 then
			l.x = l.left
		elseif l.s.align % 3 == 0 then
			l.x = l.right
		end
	else
		l.x = l.left
		l.y = l.middle
	end
	
	local alltags, wi, char_right = set.edit, 1, 0
	setstyle = {}
	l.tag = {}
	local old_wordx, old_wordr, old_wordy = l.x, l.left, l.y
	local wheight = 0
	local setwi
	local setwi
	local tlsize_x, tlsize_y = 1, 1
	local loadaddedit = alltags : gsub("!(.-)!", function(ct) return loadtags(ct, 1, li, 1, wn, #char, char, word) end)
	if loadaddedit : match("\\fsc([%d]+)") then
		tlsize_x = loadaddedit : match("\\fsc([%d]+)") / 100 
		tlsize_y = loadaddedit : match("\\fsc([%d]+)") / 100 
	else
		if loadaddedit : match("\\fscx([%d]+)") then tlsize_x = loadaddedit : match("\\fscx([%d]+)") / 100 end
		if loadaddedit : match("\\fscy([%d]+)") then tlsize_y = loadaddedit : match("\\fscy([%d]+)") / 100 end
	end
	for ci = 1, #char do
		local wi = char[ci].wi
		alltags = (char[ci].text : match("{(.*)}") or "") .. alltags
		if ci == 1 then ki = 1 elseif char[ci].text : match("\\k") then ki = ki + 1 end
		
		local onlychartags = (char[ci].text : match("{(.-)}") or "") : gsub("!(.-)!", function(ct) return loadtags(ct, ci, li, wi, wn, #char, char, word) end) .. "\\"
		local settags_r = onlychartags : match("\\r([^\\]+)") or onlychartags : match("\\r\\")
		if settags_r then
			local tags_rpos = onlychartags : find(settags_r) or #alltags
			if tags_rpos < (alltags : find("\\fs([%d.]+)") or 0) then alltags = alltags : gsub("\\fs([%d.]+)", "") set.edit = set.edit : gsub("\\fs([%d.]+)", "") end
			if tags_rpos < (alltags : find("\\fn([^\\]+)") or 0) then alltags = alltags : gsub("\\fn([^\\]+)", "") set.edit = set.edit : gsub("\\fn([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\fscy([%d.]+)") or 0) then alltags = alltags : gsub("\\fscy([%d.]+)", "") set.edit = set.edit : gsub("\\fscy([%d.]+)", "") end
			if tags_rpos < (alltags : find("\\fscx([%d.]+)") or 0) then alltags = alltags : gsub("\\fscx([%d.]+)", "") set.edit = set.edit : gsub("\\fscx([%d.]+)", "") end
			if tags_rpos < (alltags : find("\\fsp([%d.]+)") or 0) then alltags = alltags : gsub("\\fsp([%d.]+)", "") set.edit = set.edit : gsub("\\fsp([%d.]+)", "") end
			if tags_rpos < (alltags : find("\\frz([%d.-]+)") or 0) then alltags = alltags : gsub("\\frz([%d.-]+)", "") set.edit = set.edit : gsub("\\frz([%d.-]+)", "") end
			if tags_rpos < (alltags : find("\\c([^\\]+)") or 0) then alltags = alltags : gsub("\\c([^\\]+)", "") set.edit = set.edit : gsub("\\c([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\2c([^\\]+)") or 0) then alltags = alltags : gsub("\\2c([^\\]+)", "") set.edit = set.edit : gsub("\\2c([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\3c([^\\]+)") or 0) then alltags = alltags : gsub("\\3c([^\\]+)", "") set.edit = set.edit : gsub("\\3c([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\4c([^\\]+)") or 0) then alltags = alltags : gsub("\\4c([^\\]+)", "") set.edit = set.edit : gsub("\\4c([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\1vc([^\\]+)") or 0) then alltags = alltags : gsub("\\1vc([^\\]+)", "") set.edit = set.edit : gsub("\\1vc([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\2vc([^\\]+)") or 0) then alltags = alltags : gsub("\\2vc([^\\]+)", "") set.edit = set.edit : gsub("\\2vc([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\3vc([^\\]+)") or 0) then alltags = alltags : gsub("\\3vc([^\\]+)", "") set.edit = set.edit : gsub("\\3vc([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\4vc([^\\]+)") or 0) then alltags = alltags : gsub("\\4vc([^\\]+)", "") set.edit = set.edit : gsub("\\4vc([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\1img([^\\]+)") or 0) then alltags = alltags : gsub("\\1img([^\\]+)", "") set.edit = set.edit : gsub("\\1img([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\2img([^\\]+)") or 0) then alltags = alltags : gsub("\\2img([^\\]+)", "") set.edit = set.edit : gsub("\\2img([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\3img([^\\]+)") or 0) then alltags = alltags : gsub("\\3img([^\\]+)", "") set.edit = set.edit : gsub("\\3img([^\\]+)", "") end
			if tags_rpos < (alltags : find("\\4img([^\\]+)") or 0) then alltags = alltags : gsub("\\4img([^\\]+)", "") set.edit = set.edit : gsub("\\4img([^\\]+)", "") end
		end
	
		char[ci].tags = alltags : gsub("!(.-)!", function(ct) return loadtags(ct, ci, li, wi, wn, #char, char, word) end)
		word[wi].tags = char[ci].tags
		kara[ki].tags = char[ci].tags
		char[ci].tag = {}
		for key, mode in pairs(gettags) do
			if not ((char[ci].tags .. "\\") : match("\\" .. key .. "\\") and (char[ci].tags .. "\\") : find("\\" .. key .. "\\") < (char[ci].tags : match("\\" .. key .. mode) and char[ci].tags : find("\\" .. key .. mode) or #char[ci].tags)) then
				local value = table.concat({char[ci].tags : match("\\" .. key .. mode)})
				char[ci].tag[key] = (value ~= "" and value or false)
			end
		end
		for key, mode in pairs(getlinetags) do
			if not l.tag[key] then l.tag[key] = class() end
			if (char[ci].text : match("{(.-)}") or "") : match("\\" .. key .. mode) then
				l.tag[key] : insert{
					pos = ci;
					vl = table.concat({char[ci].text : match("{(.-)}") : match("\\" .. key .. mode)})
				}
			end
		end
		word[wi].tag = char[ci].tag
		kara[ki].tag = char[ci].tag
		if not tagsallcolor then tagsallcolor, char[ci]._color = setcolor(set.edit, "", char[ci].tag) end
		local tagsonlycolor
		tagsonlycolor, char[ci]._color = setcolor(char[ci].text, tagsallcolor, char[ci].tag)
		tagsallcolor = (tagsonlycolor or "") : gsub("(%x%x)(%x%x)(%x%x)(%x%x)", "%2%3%4")
		char[ci].allcolor = tagsallcolor
		word[wi].allcolor = tagsallcolor
		kara[ki].allcolor = tagsallcolor
		word[wi]._color = char[ci]._color
		kara[ki]._color = char[ci]._color
		char[ci].allgettags = ((char[ci].tag.r and "\\r" .. char[ci].tag.r or "") .. (char[ci].tag.fs and "\\fs" .. char[ci].tag.fs or "") .. (char[ci].tag.fn and "\\fn" .. char[ci].tag.fn or "") .. (char[ci].tag.frz and "\\frz" .. char[ci].tag.frz or "") .. (char[ci].tag.b and "\\b" .. char[ci].tag.b or "") .. (char[ci].tag.u and "\\u" .. char[ci].tag.u or "") .. (char[ci].tag.i and "\\i" .. char[ci].tag.i or "") .. (char[ci].tag.blur and "\\blur" .. char[ci].tag.blur or "") .. (char[ci].tag.bord and "\\bord" .. char[ci].tag.bord or "") .. (char[ci].tag.xbord and "\\xbord" .. char[ci].tag.xbord or "") .. (char[ci].tag.ybord and "\\ybord" .. char[ci].tag.ybord or "") .. (char[ci].tag.shad and "\\shad" .. char[ci].tag.shad or "") .. (char[ci].tag.xshad and "\\xshad" .. char[ci].tag.xshad or "") .. (char[ci].tag.yshad and "\\yshad" .. char[ci].tag.yshad or "")) : gsub("clip%(([^\\]+)%)", "")
		char[ci].text_tags = "{" .. char[ci].allgettags .. "}" .. char[ci].text_stripped
		
		char[ci].s = table.copy(styles[(char[ci].tag.r or l.style)])
		if char[ci].tag.fs then char[ci].s.fontsize = tonumber(char[ci].tag.fs) end
		if char[ci].tag.fn then char[ci].s.fontname = char[ci].tag.fn end
		if char[ci].tag.fscx then char[ci].s.scale_x = tonumber(char[ci].tag.fscx) end
		if char[ci].tag.fscy then char[ci].s.scale_y = tonumber(char[ci].tag.fscy) end
		if char[ci].tag.fsp then char[ci].s.spacing = char[ci].tag.fsp end
		if char[ci].tag.frz then char[ci].s.angle = char[ci].tag.frz end
		
		if onlychartags : match("\\fsc([%d]+)") then
			tlsize_x = char[ci].tag.fsc / 100 
			tlsize_y = char[ci].tag.fsc / 100 
		else
			if onlychartags : match("\\fscx([%d]+)") then tlsize_x = char[ci].tag.fscx / 100 end
			if onlychartags : match("\\fscy([%d]+)") then tlsize_y = char[ci].tag.fscy / 100 end
		end
		
		char[ci].width = (aegisub.text_extents(char[ci].s, char[ci].text_stripped)) * tlsize_x
		local setwtext
		if char[ci].tag.dn and char[ci].tag.dn % 2 == 1 then setwtext = word[wi].text_stripped : gsub(" ", "") else setwtext = word[wi].text_stripped end
		word[wi].width = (aegisub.text_extents(char[ci].s, setwtext)) * tlsize_x
		local char_x, char_y = 0, 0
		if word[wi].x and word[wi].y then
			if setwi ~= wi then
				char_x, char_y = (char[ci].tag.x or 0), (char[ci].tag.y or 0)
				word[wi].ci = ci
				word[wi].allgettags = char[ci].allgettags
				word[wi].text_tags = "{" .. char[ci].allgettags .. "}" .. word[wi].text_stripped
				old_wordx, old_wordr, old_wordy = word[wi].x, word[wi].x + word[wi].width / 2, word[wi].y
				word[wi].x = word[wi].x + char_x
				word[wi].y = word[wi].y + char_y
				word[wi].s = char[ci].s
				word[wi].height = char[ci].s.fontsize * tlsize_y
				word[wi].left = word[wi].x - word[wi].width / 2
				word[wi].right = word[wi].x + word[wi].width / 2
				word[wi].center = word[wi].x - l.left
				word[wi].middle = word[wi].y - l.top
				word[wi].top = word[wi].y - word[wi].height / 2
				word[wi].bottom = word[wi].y + word[wi].height / 2
				char_right = 0
			end
			char[ci].height = char[ci].s.fontsize * tlsize_y
			char_right = char_right + char[ci].width
			char[ci].right = word[wi].left + char_right
			char[ci].left = char[ci].right - char[ci].width
			char[ci].x = char[ci].right - char[ci].width / 2
			char[ci].center = char[ci].x - l.left
			char[ci].y = word[wi].y
			char[ci].middle = char[ci].y - l.top
			char[ci].top = char[ci].y - char[ci].height / 2
			char[ci].bottom = char[ci].y + char[ci].height / 2
		else
			if setwi ~= wi then
				char_x, char_y = (char[ci].tag.x or 0), (char[ci].tag.y or 0)
				word[wi].s = char[ci].s
				word[wi].ci = ci
				word[wi].allgettags = char[ci].allgettags
				word[wi].text_tags = "{" .. char[ci].allgettags .. "}" .. word[wi].text_stripped
				word[wi].height = char[ci].s.fontsize * tlsize_y
				if char[ci].tag.dn and char[ci].tag.dn % 2 == 1 then
					word[wi].x = old_wordx + char_x
					word[wi].y = old_wordy + (word[wi].height * set_tags_h) + char_y
					old_wordx, old_wordr, old_wordy = old_wordx, old_wordx + word[wi].width / 2, old_wordy + (word[wi].height * set_tags_h) + char_y
				else
					word[wi].x = old_wordr + word[wi].width / 2 + char_x
					word[wi].y = old_wordy + char_y
					old_wordx, old_wordr, old_wordy = old_wordr + word[wi].width / 2, old_wordr + word[wi].width, old_wordy
				end
				word[wi].left = word[wi].x - word[wi].width / 2
				word[wi].right = word[wi].x + word[wi].width / 2
				word[wi].center = word[wi].x - l.left
				word[wi].middle = word[wi].y - l.top
				word[wi].top = word[wi].y - word[wi].height / 2
				word[wi].bottom = word[wi].y + word[wi].height / 2
				char_right = 0
			end
			char[ci].height = char[ci].s.fontsize * tlsize_y
			char_right = char_right + char[ci].width
			char[ci].right = word[wi].left + char_right
			char[ci].left = char[ci].right - char[ci].width
			char[ci].x = char[ci].right - char[ci].width / 2
			char[ci].center = char[ci].x - l.left
			char[ci].y = word[wi].y
			char[ci].middle = char[ci].y - l.top
			char[ci].top = char[ci].y - char[ci].height / 2
			char[ci].bottom = char[ci].y + char[ci].height / 2
		end
		
		char[ci].ki = ki
		kara[ki].wi = wi
		word[wi].ki = ki
		setwi = wi
	end
	-- return all table
	l.char = char
	l.word = word
	l.kara = kara
	l.text_tags = l.text
	return l
end

local function PasteCode(mode)
	rmbseting.decode_dll = false
	local fncode = rmbseting.filelist[rmbseting.effect][mode]
	local lbr = table.copy(_G)
	if type(fncode) == "string" then
		local fc, err = loadstring(fncode, "$" .. mode)
		if not fc then
			local setlinecode = {err : match("%[(.-)%]:([%d]+):(.*)")}
			local erri
			if setlinecode[1] : match(mode) then erri = rmbseting.filelist[rmbseting.effect]["_" .. mode][int(setlinecode[2])] or "?" else erri = setlinecode[2] end
			aegisub.debug.out(2, "#%s \n#line: %s\n>>> %s\n\n", setlinecode[1], erri, setlinecode[3])
			ak()
		else
			setfenv(fc, lbr)
			local res, err = pcall(fc)
			if not res then
				local setlinecode = {err : match("%[(.-)%]:([%d]+):(.*)")}
				local erri
				if setlinecode[1] : match(mode) then erri = rmbseting.filelist[rmbseting.effect]["_" .. mode][int(setlinecode[2])] or "?" else erri = setlinecode[2] end
				aegisub.debug.out(2, "#%s\n#line: %s\n>>> %s\n\n", setlinecode[1], erri, setlinecode[3])
				ak()
			elseif err then
				rmbseting.decode_dll = true
			end
		end
	elseif type(fncode) == "function" then
		setfenv(fncode, lbr)
		local res, err = pcall(fncode)
		if not res then
			local setlinecode = {err : match("%[(.-)%]:([%d]+):(.*)")}
			aegisub.debug.out(2, "#%s \n#line: %s\n>>> %s\n\n", setlinecode[1], setlinecode[2], setlinecode[3])
			ak()
		end
	end
	return lbr
end

local function setting_and_stripline(subs)
	local P, res
	local Note = "Exit"
	if rmbseting.menu then		
		rmbseting.stlist = {"-- only choosing line"}
		for k in pairs(styles) do
			if type(k) == "string" and k ~= "n" then
			    table.insert(rmbseting.stlist, k)
		    end
	    end
		repeat
		local menu = {
			{x = 0, y = 0, width = 3, height = 2, class = "label", label = "Effect:"}; 
			{x = 3, y = 0, width = 11, height = 2, class = "dropdown", items = rmbseting.fxlist, name = "effect", value = rmbseting.effect, hint = "Chọn effect"}; 
			{x = 14, y = 0, width = 3, height = 2, class = "label", label = "-- " .. #rmbseting.fxlist - 1 .. " effect --"}; 
			{x = 0, y = 2, width = 3, height = 2, class = "label", label = "Style:"}; 
			{x = 3, y = 2, width = 11, height = 2, class = "dropdown", items = rmbseting.stlist, name = "style", value = rmbseting.style, hint = "Chọn style"};
			{x = 14, y = 2, width = 3, height = 2, class = "label", label = "-- " .. #rmbseting.stlist - 1 .. " style --"};
			{x = 0, y = 4, width = 3, height = 2, class = "label", label = "Mượn shape: "};
			{x = 3, y = 4, width = 4, height = 2, class = "intedit", min = 0, name = "loop", value = rmbseting.loop, hint = "Mượn shape"};
			{x = 8, y = 4, width = 3, height = 2, class = "label", label = "Tăng layer: "};
			{x = 11, y = 4, width = 4, height = 2, class = "intedit", min = 0, name = "layer", rmbseting.layer, hint = "Tăng layer"};
		}
		P, res = display(menu, {"Apply", "Add Effect", "Note", "Close"}, {ok = "Apply", cancel = "Close"})
		if res.style == "-- only choosing line" then rmbseting.rstyle = false else rmbseting.rstyle = true end
		rmbseting.style = res.style
		rmbseting.effect = res.effect
		rmbseting.layer = res.layer
		rmbseting.loop = res.loop
		if P == "Add Effect" then
			local filename = aegisub.dialog.open('Chọn File', '', '', '', true, true)
			if filename then
				for k, v in pairs(filename) do
					local fxname = v : gsub("(.-)\\", "")
					if fxname : match("%.lua") then
						local ftext = GetCodeText(ReadFile(v))
						local note = ""
						local setnote
						for lcode in ftext : gmatch("([^\n]+)") do
							if lcode : match "$note " and lcode : match "%-%-code" then 
								setnote = true 
							elseif lcode : match "$(.-) " and lcode : match "%-%-code" then 
								setnote = false
							elseif setnote then
								note = note .. lcode .. "\n"
							end
						end
						rmbseting.effect = fxname
						table.insert(rmbseting.fxlist, fxname)
						rmbseting.filelist[fxname] = {
							link = v;
							note = note
						}
					elseif fxname : match("%.dll") then
						rmbseting.effect = fxname
						table.insert(rmbseting.fxlist, fxname)
						rmbseting.filelist[fxname] = {
							link = v;
							note = MHtext(v)()
						}
					end
				end
			end
		elseif P == "Note" then
			if rmbseting.filelist[rmbseting.effect] and rmbseting.filelist[rmbseting.effect].note : gsub("%s", "") ~= "" then
				Note = ScreenShow(rmbseting.effect, rmbseting.filelist[rmbseting.effect].note, {"Later", "Exit"})
			else
				Note = ScreenShow(rmbseting.effect, "~ This effect has no notes", {"Later", "Exit"}, true)
			end
		end
		until (P ~= "Add Effect" and (P ~= "Note" or Note == "Exit"))
	else
		P = "Apply"
	end
	
	local newcodedll
	
	if P == "Apply" then
		if rmbseting.filelist[rmbseting.effect] then
			if rmbseting.effect : match ".lua" then
				local ftext = GetCodeText(ReadFile(rmbseting.filelist[rmbseting.effect].link))
				local note, all, line, chart, word = "", "", "", "", ""
				local alli, linei, wordi, chari = 0, 0, 0, 0
				local _all, _line, _word, _char = {}, {}, {}, {}
				local setc
				local li = 0
				for lcode in ftext : gmatch("([^\n]+)") do
					if lcode : match "$note " and lcode : match "%-%-code" then
						setc = "note"
					elseif lcode : match "$all " and lcode : match "%-%-code" then
						setc = "all"
					elseif lcode : match "$line " and lcode : match "%-%-code" then
						setc = "line"
					elseif lcode : match "$word " and lcode : match "%-%-code" then
						setc = "word"
					elseif lcode : match "$char " and lcode : match "%-%-code" then
						setc = "char"
					else
						if setc == "note" then
							note = note .. "\n" .. lcode
						elseif setc == "all" then
							all = all .. "\n\t"  .. lcode
							alli = alli + 1
							_all[alli] = li
						elseif setc == "line" then
							line = line .. "\n\t"  .. lcode
							linei = linei + 1
							_line[linei] = li
						elseif setc == "word" then
							word = word .. "\n\t"  .. lcode
							wordi = wordi + 1
							_word[wordi] = li
						elseif setc == "char" then
							chart = chart .. "\n\t"  .. lcode
							chari = chari + 1
							_char[chari] = li
						end
					end
					li = li + 1
				end
				rmbseting.filelist[rmbseting.effect].note = note
				newcodedll = ("local cpm = {note = [[%s]]}\n%s%s%s%s\nreturn cpm") : format(note, loadfn(all, "all"), loadfn(line, "line"), loadfn(word, "word"), loadfn(chart, "char"))
				rmbseting.filelist[rmbseting.effect].note = note
				rmbseting.filelist[rmbseting.effect].all = all
				rmbseting.filelist[rmbseting.effect].line = line
				rmbseting.filelist[rmbseting.effect].word = word
				rmbseting.filelist[rmbseting.effect].char = chart
				rmbseting.filelist[rmbseting.effect]._all = _all
				rmbseting.filelist[rmbseting.effect]._line = _line
				rmbseting.filelist[rmbseting.effect]._word = _word
				rmbseting.filelist[rmbseting.effect]._char = _char
			else
				local link = rmbseting.filelist[rmbseting.effect].link
				rmbseting.filelist[rmbseting.effect] = MHtext(rmbseting.filelist[rmbseting.effect].link)()
				rmbseting.filelist[rmbseting.effect].link = link
			end
			function __ImportLybrary__(mod)
				local flink = rmbseting.filelist[rmbseting.effect].link : gsub(rmbseting.effect, mod .. ".lua")
				local ftext = GetCodeText(ReadFile(flink))
				local nlink = rmbseting.filelist[rmbseting.effect].link : gsub(rmbseting.effect, mod .. ".dll")
				if ftext ~= "" then
					MHtext(nlink, ftext)
				elseif ReadFile(nlink) == "" then
					return error("The lybrary " .. mod .. "do not exist\n")
				end
				local lybrary = MHtext(nlink)
				local tenv = table.copy(_G)
				setfenv(lybrary, tenv)
				local fc, err = pcall(lybrary)
				if not fc then 
					local erlist = {err : match(":([%d]+):(.*)")}
					return error("lybrary <" .. mod .. ">\n>>> line: " .. erlist[1] .. "\n>>> error: " .. erlist[2]) 
				end
				return tenv
			end
		end
		local style_string, i = "", 1
		local startd, endd
		local striplist = {}
		local stdel
		local addcode, addedit = "", ""
		local li = 0
		if rmbseting.effect ~= "-- no effect" then 
			gettags = {dn = "(%d)", r = "([^\\]+)", fs = "([%d.]+)", fsc = "([%d.]+)", fscx = "([%d.]+)", fscy = "([%d.]+)", fsp = "([%d.]+)", fn = "([^\\]+)",
			c = "&([^\\]+)&", ["2c"] = "&([^\\]+)&", ["3c"] = "&([^\\]+)&", ["4c"] = "&([^\\]+)&",
			["1img"] = "([^\\]+)", ["2img"] = "([^\\]+)", ["3img"] = "([^\\]+)", ["4img"] = "([^\\]+)", 
			["1vc"] = "([^\\]+)", ["2vc"] = "([^\\]+)", ["3vc"] = "([^\\]+)", ["4vc"] = "([^\\]+)", 
			shad = "([%d.-]+)", xshad = "([%d.-]+)", yshad = "([%d.-]+)", bord = "([%d.-]+)", xbord = "([%d.-]+)", ybord = "([%d.-]+)", blur = "([%d.-]+)", 
			i = "(%d)", be = "d.-]+)", b = "(%d)", u = "(%d)",s = "(%d)", x = "([%d.-]+)", y = "([%d.-]+)", frx = "([%d.-]+)", fry = "([%d.-]+)", frz = "([%d.-]+)", frs = "([%d.-]+)",
			prefx = "([%u%[])([^\\]+)", postfx = "([%u%[])([^\\]+)", pre = "([%d.-]+)", post = "([%d.-]+)", infx = "([^\\]+)"}
			getlinetags = {}
			all = PasteCode "all" 
			if rmbseting.decode_dll and newcodedll then MHtext(rmbseting.filelist[rmbseting.effect].link : gsub("%.lua", ".dll"), newcodedll) end
		end
		aegisub.progress.task("Strip Oldline ...")
		local oldseti = 5
		local cancelled
		while i <= #subs do
			local seti = math.floor((i - 1) / #subs * 100)
			if seti > oldseti then
				aegisub.progress.set(seti)
				cancelled = aegisub.progress.is_cancelled()
				oldseti = oldseti + 5
			end
			if cancelled then ak() break end
			local l = table.copy(subs[i])
			if l.class == "style" then style_string = style_string .. l.raw .. "\n" end
			if rmbseting.style == l.style and l.effect == "code" then
				addcode = addcode .. l.text
			elseif rmbseting.style == l.style and l.effect == "edit" then
				addedit = l.text .. addedit
			end
			if rmbseting.style == "-- only choosing line" then
				if rmbseting.choosing[i] and (l.effect : match("raw.([%x]+)") or l.class == "dialogue" and l.effect == "") then
					local hex = l.effect : match("raw.([%x]+)") or string.hex(os.time() + li % 32000000, true)
					striplist[hex] = true
					if rmbseting.effect ~= "-- no effect" then
						l.comment = true
						li = li + 1
						l.set = addedit .. " , " .. addcode .. " , " .. l.raw
						l.effect = "raw." .. hex
						l.i = li
						l.mode = hex
						if (not rmbseting.applyline[hex]) or (l.set ~= rmbseting.applyline[hex].set) or style_string ~= rmbseting.oldstylelist then 
							karaskel.preproc_line(subs, meta, styles, l)
							l = SetAllTable({code = addcode, edit = addedit}, l, li)
							rmbseting.applyline[hex] = table.copy(l)
							rmbseting.applyline[li] = table.copy(l)
						else 
							rmbseting.applyline[hex].i = li
							rmbseting.applyline[li] = table.copy(rmbseting.applyline[hex])
						end
					else
						l.comment = false
						l.effect = ""
					end
					subs[i] = l
				elseif l.class == "dialogue" and striplist[l.effect : match("fx.([%x]+)") or ""] then
					local _, fxmode = l.effect : match("fx.([%x]+).([%d]+)")
					if rmbseting.loop < 1 then
						if not stdel then stdel = i end
					elseif rmbseting.loop == tonumber(fxmode) then
						if not stdel then stdel = i end
					end
				elseif stdel then
					subs.deleterange(stdel, i - 1)
					i = i - (i - stdel)
					stdel = false
				end
			elseif rmbseting.style ~= "-- only choosing line" and l.style == rmbseting.style and (l.effect : match("raw.([%x]+)") or l.class == "dialogue" and l.effect == "") then
				local hex = l.effect : match("raw.([%x]+)") or string.hex(os.time() + li % 32000000, true)
				striplist[hex] = true
				if rmbseting.effect ~= "-- no effect" then
					l.comment = true
					li = li + 1
					l.i = li
					l.effect = "raw." .. hex
					l.set = addedit .. " , " .. addcode .. " , " .. l.raw
					l.mode = hex
					if (not rmbseting.applyline[hex]) or (l.set ~= rmbseting.applyline[hex].set) or style_string ~= rmbseting.oldstylelist then 
						karaskel.preproc_line(subs, meta, styles, l)
						l = SetAllTable({code = addcode, edit = addedit}, l, li)
						rmbseting.applyline[hex] = table.copy(l)
						rmbseting.applyline[li] = table.copy(l)
					else 
						rmbseting.applyline[hex].i = li
						rmbseting.applyline[li] = table.copy(rmbseting.applyline[hex])
					end
				else
					l.comment = false
					l.effect = ""
				end
				subs[i] = l
			elseif rmbseting.style ~= "-- only choosing line" and l.class == "dialogue" and striplist[l.effect : match("fx.([%x]+)") or ""] then
				local _, fxmode = l.effect : match("fx.([%x]+).([%d]+)")
				if rmbseting.loop < 1 then
					if not stdel then stdel = i end
				elseif rmbseting.loop == tonumber(fxmode) then
					if not stdel then stdel = i end
				end
			elseif stdel then
				subs.deleterange(stdel, i - 1)
				i = i - (i - stdel)
				stdel = false
			end
			if stdel and i == #subs then subs.deleterange(stdel, i) end
			i = i + 1
		end
		rmbseting.apply = true
		rmbseting.oldstylelist = style_string
	end
end

local function apply_effect(subs)
	rstyle = rmbseting.style
	reffect = rmbseting.effect
	-- retime
	local rtime = function(sefl, addstart, addend, mode)
		local newstart, newend = l.start_time, l.end_time
		addstart = addstart or 0
		addend = addend or 0
		if mode == "preline" then
		    newstart = l.start_time + addstart
			newend = l.start_time + addend
		elseif mode == "postline" then
		    newstart = l.end_time + addstart
			newend = l.end_time + addend
		elseif mode == "kara" then
		    newstart = l.start_time + mul.start_time + addstart
			newend = l.start_time + mul.end_time + addend
		elseif mode == "prekara" then
		    newstart = l.start_time + mul.start_time + addstart
			newend = l.start_time + mul.start_time + addend
		elseif mode == "postkara" then
		    newstart = l.start_time + mul.end_time + addstart
			newend = l.start_time + mul.end_time + addend
		elseif mode == "start_kara" then
		    newstart = l.start_time + addstart
			newend = l.start_time + mul.start_time + addend
		elseif mode == "end_kara" then
		    newstart = l.start_time + mul.end_time + addstart
			newend = l.end_time + addend
		elseif mode == "time" then
		    newstart = 0
			newend = 0
		else
		    newstart = l.start_time + addstart
			newend = l.end_time + addend
		end
		sefl.start_time = newstart
		sefl.end_time = newend
		sefl.duration = newend - newstart
		return sefl
	end
	local rtext = function(sefl, ...)
		local list = class {...}
		if list[1] == 1 then
			if #list > 2 then sefl.text = list : str("", 2) elseif #list == 2 then sefl.text = list[2] end
		elseif list[1] == 2 then
			if #list > 2 then sefl.text = list : str("", 2) .. sefl.text_tags elseif #list == 2 then sefl.text = list[2] .. sefl.text_tags end
		elseif type(list[1]) == "number" then
			if #list > 2 then sefl.text = list : str("", 2) .. sefl.text_stripped elseif #list == 2 then sefl.text = list[2] .. sefl.text_stripped end
		else
			if #list > 1 then sefl.text = list : str("") .. sefl.text_stripped elseif #list == 1 then sefl.text = list[1] .. sefl.text_stripped end
		end
		sefl.text = tostring(sefl.text) :gsub("}{", "")
		return sefl
	end
	local rlayer = function(sefl, nlayer)
		sefl.layer = sefl.layer + nlayer
		return sefl
	end
	local apply = function(sefl)
		subs.append(sefl)
		return sefl
	end
	-- abs and dl
	DL = function(n, i) 
		return n - math.abs((i - n / 2)) - n / 2 + (i > n / 2 and 1 or 0)
	end
	-- set width
	setwidth = function(text, stname)
	    if stname then
    		setstyle = styles[stname] 
		else 
		    setstyle = styles[rstyle] 
		end
		return aegisub.text_extents(setstyle, text)
	end
	-- unpack newline
	unpack_newline = function(list)
		local list_n = #list
		if list_n < 4001 then
			subs.append(unpack(list))
		elseif list_n < 8001 then
			subs.append(unpack(list, 1, 4000))
			subs.append(unpack(list, 4001, list_n))
		elseif list_n < 12001 then
			subs.append(unpack(list, 1, 4000))
			subs.append(unpack(list, 4001, 8000))
			subs.append(unpack(list, 8001, list_n))
		else
			subs.append(unpack(list, 1, 4000))
			subs.append(unpack(list, 4001, 8000))
			subs.append(unpack(list, 8001, 12000))
			subs.append(unpack(list, 12001, list_n))
		end
		return list_n
	end
	aegisub.progress.task("Apply Newline ...") 
	aegisub.progress.set(0)
	local cancelled, seti
	local oldseti = 5
	_line = table.copy(rmbseting.applyline)
	ln = #rmbseting.applyline
	local loadchar = 100 / ln
	for li, l in ipairs(_line) do
		_G.li = li
		_G.l = l
		seti = math.floor((li - 1) / ln * 100)
		if seti > oldseti then
			aegisub.progress.set(seti)
			cancelled = aegisub.progress.is_cancelled()
			oldseti = oldseti + 5
		end
		if cancelled then ak() break end
		newline = table.copy(l)
		newline.copy = table.copy
		newline.layer = rmbseting.layer
		newline.comment = false
		newline.effect = "fx." .. l.mode .. "." .. rmbseting.loop
		newline.rtime = rtime
		newline.rtext = rtext
		newline.rlayer = rlayer
		newline.apply = apply
		newline.start_time = l.start_time
		newline.end_time = l.end_time
		s = l.s
		_char = l.char
		_word = l.word
		_kara = l.kara
		cn = #_char
		wn = #_word
		kn = #_kara
		t = table.copy(l.tag)
		line = PasteCode "line"
		local cload = loadchar / cn
		if rmbseting.filelist[rmbseting.effect].word or rmbseting.filelist[rmbseting.effect].char then
			for wi = 1, wn do
				w = _word[wi]
				_G.wi = wi
				ki = w.ki
				k = _kara[ki]
				s = w.s
				t = table.copy(w.tag)
				newline.text = w.text
				newline.text_tags = w.text_tags
				newline.text_stripped = w.text_stripped
				newline.start_time = l.start_time
				newline.end_time = l.end_time
				if k.multi then
					for muli = 1, #k.multi do
						mul = k.multi[i]
						mi = muli
						word = PasteCode "word"
					end
				else
					word = PasteCode "word"
				end
				if rmbseting.filelist[rmbseting.effect].char then
					ci = w.ci
					for a = 1, w.text_stripped : u_len() do
						seti = floor(seti + cload * ci)
						if seti > oldseti then
							aegisub.progress.set(seti)
							cancelled = aegisub.progress.is_cancelled()
							oldseti = oldseti + 5
						end
						if cancelled then ak() break end
						c = _char[ci]
						ki = c.ki
						k = _kara[ki]
						s = c.s
						t = table.copy(c.tag)
						newline.text = c.text
						newline.text_tags = c.text_tags
						newline.text_stripped = c.text_stripped
						newline.start_time = l.start_time
						newline.end_time = l.end_time
						if k.multi then
							for muli = 1, #k.multi do
								mul = k.multi[i]
								mi = muli
								PasteCode "char"
							end
						else
							--aegisub.debug.out(rmbseting.filelist[rmbseting.effect].chart)
							PasteCode "char"
						end
						ci = ci + 1
					end
				end
			end
		end
		table.remove(rmbseting.applyline)
	end
end

local function ApplyFx(subs, sel, setmn)
	rmbseting.choosing = {}
	rmbseting.apply = false
	for z, a in ipairs(sel) do
		if z == 1 and rmbseting.rstyle then rmbseting.style = subs[a].style end
		rmbseting.choosing[a] = true
	end
	rmbseting.menu = setmn
    display = aegisub.dialog.display
    ak = aegisub.cancel
    meta, styles = karaskel.collect_head(subs)
	setting_and_stripline(subs)	
	if rmbseting.effect ~= "-- no effect" and rmbseting.apply then apply_effect(subs) end
	aegisub.set_undo_point(script_name)
end 

aegisub.register_macro(script_name1, script_description, function(subs, sel) ApplyFx(subs, sel, true) end, true)
aegisub.register_macro(script_name2, script_description, function(subs, sel) ApplyFx(subs, sel) end, true)
aegisub.register_filter(script_name, script_description, 2021, function(subs, sel) ApplyFx(subs, sel, true) end)