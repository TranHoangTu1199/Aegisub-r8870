-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

local tr = aegisub.gettext

script_name = tr"Templater Strawberry"
script_description = tr"Macro and export filter to apply karaoke effects using the template language"
script_author = "Cmy草莓"
script_version = "3.0"


include("karaskel.lua")
CD = interpolate
vc_cl = "\\%dvc(%s,%s,%s,%s)"
setw_char = aegisub.text_extents

-- Find and parse/prepare all karaoke template lines
function parse_templates(meta, styles, subs)
	local templates = { once = {}, line = {}, syl = {}, char = {}, furi = {}, styles = {} }
	local i = 1
	while i <= #subs do
		aegisub.progress.set((i-1) / #subs * 100)
		local l = subs[i]
		i = i + 1
		if l.class == "dialogue" and l.comment then
			local fx, mods = l.effect:headtail()
			fx = fx:lower()
			if fx == "code" then
				parse_code(meta, styles, l, templates, mods)
			elseif fx == "template" then
				parse_template(meta, styles, l, templates, mods)
			end
			templates.styles[l.style] = true
		elseif l.class == "dialogue" and l.effect == "fx" then
			-- this is a previously generated effect line, remove it
			i = i - 1
			subs.delete(i)
		end
	end
	aegisub.progress.set(100)
	return templates
end

function parse_code(meta, styles, line, templates, mods)
	local template = {
		code = line.text:gsub("$l_","line."):gsub("$s_","syl."):gsub("$w_","string.word."):gsub("$c_","string.char."):gsub("@%(([^\\}]+),([^\\}]+)%)","_st.revalue(%1,%2)"),
		loops = 1,
		style = line.style
	}
	local inserted = false

	local rest = mods
	while rest ~= "" do
		local m, t = string.headtail(rest)
		rest = t
		m = m:lower()
		if m == "once" then
			aegisub.debug.out(5, "Found run-once code line: %s\n", line.text)
			table.insert(templates.once, template)
			inserted = true
		elseif m == "line" then
			aegisub.debug.out(5, "Found per-line code line: %s\n", line.text)
			table.insert(templates.line, template)
			inserted = true
		elseif m == "syl" then
			aegisub.debug.out(5, "Found per-syl code line: %s\n", line.text)
			table.insert(templates.syl, template)
			inserted = true
		elseif m == "furi" then
			aegisub.debug.out(5, "Found per-syl code line: %s\n", line.text)
			table.insert(templates.furi, template)
			inserted = true
		elseif m == "all" then
			template.style = nil
		elseif m == "noblank" then
			template.noblank = true
		elseif m == "repeat" or m == "loop" then
			local times, t = string.headtail(rest)
			template.loops = tonumber(times)
			if not template.loops then
				aegisub.debug.out(3, "Failed reading this repeat-count to a number: %s\nIn template code line: %s\nEffect field: %s\n\n", times, line.text, line.effect)
				template.loops = 1
			else
				rest = t
			end
		else
			aegisub.debug.out(3, "Unknown modifier in code template: %s\nIn template code line: %s\nEffect field: %s\n\n", m, line.text, line.effect)
		end
	end
	
	if not inserted then
		aegisub.debug.out(5, "Found implicit run-once code line: %s\n", line.text)
		table.insert(templates.once, template)
	end
end

-- List of reserved words that can't be used as "line" template identifiers
template_modifiers = {
	"pre-line", "line", "syl", "furi", "char", "all", "repeat", "loop",
	"notext", "keeptags", "noblank", "multi", "fx", "fxgroup"
}

function parse_template(meta, styles, line, templates, mods)
	local template = {
		t = "",
		pre = "",
		style = line.style,
		loops = 1,
		layer = line.layer,
		addtext = true,
		keeptags = false,
		fxgroup = nil,
		fx = nil,
		multi = false,
		isline = false,
		perchar = false,
		noblank = false
	}
	local inserted = false
	
	local rest = mods
	while rest ~= "" do
		local m, t = string.headtail(rest)
		rest = t
		m = m:lower()
		if (m == "pre-line" or m == "line") and not inserted then
			aegisub.debug.out(5, "Found line template '%s'\n", line.text)
			-- should really fail if already inserted
			local id, t = string.headtail(rest)
			id = id:lower()
			-- check that it really is an identifier and not a keyword
			for _, kw in pairs(template_modifiers) do
				if id == kw then
					id = nil
					break
				end
			end
			if id == "" then
				id = nil
			end
			if id then
				rest = t
			end
			-- get old template if there is one
			if id and templates.line[id] then
				template = templates.line[id]
			elseif id then
				template.id = id
				templates.line[id] = template
			else
				table.insert(templates.line, template)
			end
			inserted = true
			template.isline = true
			-- apply text to correct string
			if m == "line" then
				template.t = template.t .. line.text
			else -- must be pre-line
				template.pre = template.pre .. line.text
			end
		elseif m == "syl" and not template.isline then
			table.insert(templates.syl, template)
			inserted = true
		elseif m == "furi" and not template.isline then
			table.insert(templates.furi, template)
			inserted = true
		elseif (m == "pre-line" or m == "line") and inserted then
			aegisub.debug.out(2, "Unable to combine %s class templates with other template classes\n\n", m)
		elseif (m == "syl" or m == "furi") and template.isline then
			aegisub.debug.out(2, "Unable to combine %s class template lines with line or pre-line classes\n\n", m)
		elseif m == "all" then
			template.style = nil
		elseif m == "repeat" or m == "loop" then
			local times, t = string.headtail(rest)
			template.loops = tonumber(times)
			if not template.loops then
				aegisub.debug.out(3, "Failed reading this repeat-count to a number: %s\nIn template line: %s\nEffect field: %s\n\n", times, line.text, line.effect)
				template.loops = 1
			else
				rest = t
			end
		elseif m == "notext" then
			template.addtext = false
		elseif m == "keeptags" then
			template.keeptags = true
		elseif m == "multi" then
			template.multi = true
		elseif m == "char" then
			template.perchar = true
		elseif m == "noblank" then
			template.noblank = true
		elseif m == "fx" then
			local fx, t = string.headtail(rest)
			if fx ~= "" then
				template.fx = fx
				rest = t
			else
				aegisub.debug.out(3, "No fx name following fx modifier\nIn template line: %s\nEffect field: %s\n\n", line.text, line.effect)
				template.fx = nil
			end
		elseif m == "fxgroup" then
			local fx, t = string.headtail(rest)
			if fx ~= "" then
				template.fxgroup = fx
				rest = t
			else
				aegisub.debug.out(3, "No fxgroup name following fxgroup modifier\nIn template linee: %s\nEffect field: %s\n\n", line.text, line.effect)
				template.fxgroup = nil
			end
		else
			aegisub.debug.out(3, "Unknown modifier in template: %s\nIn template line: %s\nEffect field: %s\n\n", m, line.text, line.effect)
		end
	end
	
	if not inserted then
		table.insert(templates.syl, template)
	end
	if not template.isline then
		template.t = line.text
	end
end

-- Iterator function, return all templates that apply to the given line
function matching_templates(templates, line, tenv)
	local lastkey = nil
	local function test_next()
		local k, t = next(templates, lastkey)
		lastkey = k
		if not t then
			return nil
		elseif (t.style == line.style or not t.style) and
				(not t.fxgroup or
				(t.fxgroup and tenv.fxgroup[t.fxgroup] ~= false)) then
			return t
		else
			return test_next()
		end
	end
	return test_next
end

-- Iterator function, run a loop using tenv.j and tenv.maxj as loop controllers
function template_loop(tenv, initmaxj)
	local oldmaxj = initmaxj
	tenv.maxj = initmaxj
	tenv.j = 0
	local function itor()
		if tenv.j >= tenv.maxj or aegisub.progress.is_cancelled() then
			return nil
		else
			tenv.j = tenv.j + 1
			if oldmaxj ~= tenv.maxj then
				aegisub.debug.out(5, "Number of loop iterations changed from %d to %d\n", oldmaxj, tenv.maxj)
				oldmaxj = tenv.maxj
			end
			return tenv.j, tenv.maxj
		end
	end
	return itor
end

-- Function Strawberry
_st = {}
_st.AscByChar = "function char(ref) ci[ref] = ci[ref]+1 ; return '' end ; ci = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}  return char, ci"
_st.delay = {}
_st.revalue = function(name, v) _st.delay[name] = v return v end

function _st.ReLineAndFxGr(add_dieuchinh, line) 
    align = line.styleref.align   
	width = line.width    
	left = line.left    
	right = line.right    
	center = line.center     
	middle = line.middle    
	text = line.text
	if not line_i then line_i = line.i end  
	line.i = line.i - line_i + 1
	if ((li or 1) >= line.i ) then li = (line.effect == "text code" and 0 or line.style ~= line.styleref.name and 0 or 1) 
	elseif line.effect ~= "text code" and line.style == line.styleref.name then li = li + 1 end
	if not line_start_time or line_start_time > line.end_time then line_start_time = line.start_time  line.start_prav = line.start_time 
	    else line.start_prav = line_start_time  line_start_time = line.start_time  end
	if not line_end_time or line_end_time > line.end_time then line_end_time = line.end_time  line.end_prav = line.end_time 
	    else line.end_prav = line_end_time  line_end_time = line.end_time  end
	if not line_dur_time or line_end_time > line.end_time then line_dur_time = line.duration  line.dur_prav = line.duration
	    else line.dur_prav = line_dur_time  line_dur_time = line.duration  end
	if line.i == 1 and line.effect ~= "text code" then textcode = "" 
	elseif line.i == 1 and line.effect == "text code" then textcode = line.text
	elseif line.effect == "text code" then textcode = (textcode .. " " or "") .. line.text end
	line.allcode = " li = " .. li .. "  dur = " .. line.duration .. "  " .. (textcode or "")
	line.showtags = (line.text .. add_dieuchinh):gsub("!(.-)!",function(b) return loadstring(string.format("maxi = %s  i = %s  %s return (%s)", unicode.len(line.text), 1, line.allcode, b))() end)
	if align%3 == 1  
	    then posw = width/2 
	elseif align%3 == 0 
	    then posw = -width/2
	else posw = 0 
	end         
	if line.showtags:match("\\pos%(([%d%.%-]+),([%d%.%-]+)%)") 
	    then center, middle = line.showtags:match("\\pos%(([%d%.%-]+),([%d%.%-]+)%)") 
	end     
	if line.showtags:match("\\pos%(([%d%.%-]+),([%d%.%-]+)%)")  
	    then center = center+posw end; 
	left = center-width/2     
	right = center+width/2        
	NgangDoc = 0     
	if line.showtags:match('\\dn') and (line.showtags:match('\\dn([%d])') or 0)%2 == 1 
	    then NgangDoc = 1  
	else NgangDoc = 0  
	end                  
	ngang = (NgangDoc == 0 and line.effect ~= "text code" and line.text ~= "") and true or false    
	doc = (NgangDoc == 1 and line.effect ~= "text code" and line.text ~= "") and true or false
	run = (ngang == true or doc == true) and true or false
	line.center = center
	line.middle = middle
	line.left = left
	line.right = right
	
	if not line_left then line_left = line.left  line.left_prav = line.left else line.left_prav = line_left  line_left = line.left  end
	if not line_middle then line_middle = line.middle  line.middle_prav = line.middle else line.middle_prav = line_middle  line_middle = line.middle  end
    if not line_width then line_width = line.width  line.width_prav = line.width else line.width_prav = line_width  line_width = line.width  end
	if not line_text then line_text = line.text  line.text_prav = line.text else line.text_prav = line_text  line_text = line.text  end
	if not line_text_stripped then line_text_stripped = line.text_stripped  line.text_stripped_prav = line.text_stripped 
	    else line.text_stripped_prav = line_text_stripped  line_text_stripped = line.text_stripped  end
	line._i = li
    line.right_prav = line.left_prav + line.width_prav	
	line.center_prav = line.left_prav + line.width_prav / 2
	return  ngang, doc, run
end


function  string.CharText(text)
    a_char = {} 
	for i = 1, unicode.len(text) do 
	    for alp in unicode.chars(text) do 
		a_char[i] = alp  
		end 
		if text == "" 
		    then  break 
		end 
		text = text:sub(1,-#a_char[i]-1)  
	end;   
	a_t = ""     
	for z = 1,#a_char do 	  
		ci = #a_char-z+1		
		local sett = ""	
		for i = 1,z do	    
		    if a_char[#a_char-i+1] == "{" 	    
			    then sett = sett .. "1"	
			elseif a_char[#a_char-i+1] == "}"          
			    then sett = sett .. "2"		
			else sett = sett .. ""	 
			end 
		end    
		local sett2 = sett:sub(-1)	  
		if sett2 == "1" and a_char[#a_char-z+1] == " " 
		    then a_t = a_t .. "<range>"		
		elseif sett2 == "1" or a_char[#a_char-z+1] == "}"   
		    then a_t = a_t .. a_char[#a_char-z+1]		
		elseif a_char[#a_char-z+1] == " " 
		    then a_t = a_t .. "<range2> " 
		else  a_t = a_t .. a_char[#a_char-z+1] .. " "		
		end	
	end;              
	a_char2 = {}     
	for i = 1, unicode.len(a_t) do 
		for chart in string.words(a_t) do  
		a_char2[i] = chart  
		end  
			if a_t == "" 
			then  break 
			end 
		a_t = a_t:sub(1,-#a_char2[i]-2)  
	end ;    
	char_text = {} 
	for i = 1, #a_char2 do 
		char_text[i] = a_char2[#a_char2-(i-1)]:gsub("<range2>",""):gsub("<range>"," ")
	end 	
	return char_text
end

function string.ReadTags(textset,n,tags,gttv,LLt,l)
    if type(gttv) == "string" 
	    then gttv = gttv:gsub("!(.-)!",function(b) return loadstring(string.format("maxi = %s  i = %s  %s return (%s)", #textset, n, l.allcode, b))() end) end
    local LL, vtt 
	if LLt%2 == 1 
	    then LL = tags 
	else LL = "" 
	end 
	text = {}
	for k = 1, #textset do
	    text[k] = textset[k]:gsub("!(.-)!",function(b) return loadstring(string.format("maxi = %s  i = %s  %s return (%s)", #textset, n, l.allcode, b))() end)
	end
	local dd = "" 
	for i = 1, n do 
	text[n] = (text[n] or ""):gsub("([^\\]+){\\([^\\]+)}","%1")    
	    if text[n-i+1]:match(tags .. "([^\\}]+)") 
	        then dd, vtt = dd .. text[n-i+1], n-i+1 break 
	    else dd, vtt = dd .. text[n-i+1], 0  
	    end 
	end  
	if dd:match(tags .. "([^\\}]+)") 
	    then dd = LL .. dd:match(tags .. "([^\\}]+)")    
	else dd = gttv
	end   
	return string.format("%s",dd), vtt 
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

function float(val)
    val = ('%s') : format(val) 
    local set_val = ""  
	for i = 1, val : len() do 
	    if setnb(val : sub(i, i)) ~= "1" 
		    then set_val = set_val .. "1" break 
		else set_val = set_val .. "" end 
		end ; 
		if set_val == "1" 
		    then return 0 
		else return ('%s') : format(val) end 
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

function _st.RGB_to_HSV(RGB) 
    RGB = RGB:gsub("&H(%x%x)(%x%x)(%x%x)&","%1%2%3"):gsub("&H(%x%x)(%x%x)(%x%x)(%x%x)&","%2%3%4") 
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

function string.Char(add_dieuchinh,r,syl,line,char_text)
    add_dieuchinh = add_dieuchinh:gsub("!(.-)!",function(b) return loadstring(string.format("maxi = %s  i = %s  %s return (%s)", #char_text, r, line.allcode, b))() end) 
    posx = line.center-line.width/2     
	chtl = string.ReadTags(char_text,r,"\\tl",100,0,line)/100    
	rcx, ttrcx = string.ReadTags(char_text,r,"\\x",0,0,line)   
	string.char = {
	text = char_text ;
	tlxy = chtl ; 
	x = (posx/chtl+posx)/2+rcx+syl.center*chtl ; 
	y = line.middle+string.ReadTags(char_text,r,"\\y",0,0,line) ; 
	pre = string.ReadTags(char_text,r,"\\pre",add_dieuchinh:match("\\pre([^\\}*]+)") or 0,0,line)*100 ; 
	post = string.ReadTags(char_text,r,"\\post",add_dieuchinh:match("\\post([^\\}*]+)") or 0,0,line)*100 ; 
	vtpre = string.ReadTags(char_text,r,"\\vtpre",add_dieuchinh:match("\\vtpre([^\\}*]+)") or 1,0,line) ; 
	vtpost = string.ReadTags(char_text,r,"\\vtpost",add_dieuchinh:match("\\vtpost([^\\}*]+)") or 1,0,line)
}  ; 
	return "" 
end 

function string.Word(add_dieuchinh,n,line)
    text2 = "" 
	for z = 1,#a_char do  	
	    local seta = ""	
	    for i = 1,z do	    
	        if a_char[#a_char-i+1] == "{"	    
	            then seta = seta .. "1"	
	        elseif a_char[#a_char-i+1] == "}"          
	            then seta = seta .. "2"		
	        else seta = seta .. ""	 
	        end 
		end    
	    local seta2 = seta:sub(-1)        
	    if seta2 == "1" and a_char[#a_char-z+1] == " " 
	        then text2 = text2 .. "<range>" 
	    elseif unicode.codepoint(a_char[#a_char-z+1]) > 11903 
	        then text2 = text2 .. a_char[#a_char-z+1] .. " " 
	    else text2 = text2 .. a_char[#a_char-z+1] 
		end 
	end;  
	text2 = text2:gsub("  "," ")
	w = {} 
	w2 = {} 
	for i = 1, unicode.len(text2) do 
	    for word in string.words(text2) do 
	        w[i] = word  
	    end  
	    if text2 == "" 
	        then  break 
	    end 
	    text2 = text2:sub(1,-#w[i]-2)  
	end ; 
	for z = 1,#w do 
	    w2[z] = w[#w-z+1]:gsub("<range>"," ")
	end ;     
	add_dieuchinh = add_dieuchinh:gsub("!(.-)!",function(b) return loadstring(string.format("maxi = %s  i = %s  %s return (%s)", #w, n, line.allcode, b))() end)
	string.word = {n = #w2; 
	text2 = w2; 
	text = (w2[n] or ""):gsub("{([^\\-*]+)}",""):gsub("\\n","") ; 
	pre = string.ReadTags(w2,n,"\\pre",add_dieuchinh:match("\\pre([^\\}*]+)") or 0,0,line)*100 ; 
	post = string.ReadTags(w2,n,"\\post",add_dieuchinh:match("\\post([^\\}*]+)") or 0,0,line)*100 ; 
	height = line.height*(string.ReadTags(w2,n,"\\tl",100,0,line)/100)+line.styleref.spacing*(line.height/10)  ; 
	vtpre = string.ReadTags(w2,n,"\\vtpre",add_dieuchinh:match("\\vtpre([^\\}*]+)") or 1,0,line) ; 
	vtpost = string.ReadTags(w2,n,"\\vtpost",add_dieuchinh:match("\\vtpost([^\\}*]+)") or 1,0,line) ; 
	tlxy = string.ReadTags(w2,n,"\\tl",100,0,line)/100 } 
	for i = 1, n do 
	    if math.floor(string.word.height) ~= math.floor(line.height*(string.ReadTags(w2,CD(n-i,1,n-i),"\\tl",100,0,line)/100)) 
	        then string.word.h_prav = line.height*(string.ReadTags(w2,CD(n-i,1,n-i),"\\tl",100,0,line)/100) 
		    break 
	    else string.word.h_prav = string.word.height 
	    end 
	end       
	xx = string.ReadTags(w2,n,"\\x",0,0,line)     
	yy, ttyy = string.ReadTags(w2,n,"\\y",0,0,line)   
	yy, ttyy = yy-(string.word.height-string.word.h_prav), ttyy or 0       
	if line.styleref.align%3 == 1 
	    then string.word.x = (line.center-line.width/2)+xx 
	elseif line.styleref.align%3 == 2 
	    then string.word.x = line.center+xx 
	else string.word.x = (line.center+line.width/2)+xx 
	end    
	if math.ceil(line.styleref.align/3) == 1 
	    then string.word.y = line.middle+(n-string.word.n)*string.word.height+yy 
	elseif math.ceil(line.styleref.align/3) == 2 
	    then string.word.y = line.middle+(n-string.word.n/2-0.5)*string.word.height+yy
	else string.word.y = line.middle+(n-1)*string.word.height+yy
	end 
	return ""
end

function string.combo_tags(add_dieuchinh, text, j,line)
    add_dieuchinh = add_dieuchinh:gsub("!(.-)!",function(b) return loadstring(string.format("maxi = %s  i = %s  %s return (%s)", #text, j, line.allcode, b))() end)
    tags = {
	r = string.ReadTags(text,j,"\\r","",0,line) 
}   
	for i = 1, j do 
	    add_dieuchinh:Word(i,line)  
	    if string.word.text2[1] == text[1] 
	        then setr = "word" 
	    else setr = "char" 
	    end 
	    ws = "" 
	    for i2 = 1, i do 
		    ws = ws .. (string.word.text2[i2] or "")
		end 
		ts = "" 
		for i3 = 1, j do 
		    ts = ts .. (text[i3] or "")
		end  
		if #ws >= #ts 
		    then j2 = i break 
		else j2 = 1 
		end  
	end  
	m1 = {}  
	m2 = {}  
	color = {} 
	vt = {} 
	cs = {}  
	h1 ={}   
	s1 = {} 
	v1 = {} 
	h2 ={}   
	s2 = {} 
	v2 = {} 
	for i = 1, 4 do             
	tags["c" .. i], vt["c" .. i] = string.ReadTags(text,j,"\\" .. CD(i-1,"",i) .. "c","",1,line)           
	tags["vc" .. i], vt["vc" .. i] = string.ReadTags(text,j,"\\" .. i .. "vc","",1,line)       
	tags["colors" .. i], vt["colors" .. i] = string.ReadTags(text,j,"\\" .. i .. "cs","",0,line)      
	tags["img" .. i], vt["img" .. i] = string.ReadTags(text,j,"\\" .. i .. "img","",1,line)       
	tags["svc" .. i], vt["svc" .. i] = string.ReadTags(text,j,"\\" .. i .. "svc","",0,line)            
	    if tags["colors" .. i]~="" 
		    then tags["cs" .. i] = tags["colors" .. i]:gsub("%(",""):gsub("%)","") 
		elseif add_dieuchinh:match("\\" .. i .. "cs") 
		    then tags["cs" .. i] = add_dieuchinh:match("\\" .. i .. "cs([^)]+)"):gsub("%(","") 
		else tags["cs" .. i] = "" 
		end  
		cs["cl" .. i] = {} 
		for z = 1, 100 do 
		    if tags["cs" .. i] and tags["cs" .. i] ~= "" 
		        then cs["cl" .. i][z] = tags["cs" .. i]:match("([^;)*]+)") 
		    else break 
		    end 
			tags["cs" .. i] = (tags["cs" .. i]):sub(#cs["cl" .. i][z]+2) 
		end               
		if tags["svc" .. i] ~= "" 
		    then m1[i], m2[i] = tags["svc" .. i]:match("%(&H([%x.%-]+)&,&H([%x.%-]+)&") 
		elseif add_dieuchinh:match("\\" .. i .. "svc") 
		    then m1[i], m2[i] = add_dieuchinh:match("\\" .. i .. "svc%(&H([%x.%-]+)&,&H([%x.%-]+)&%)") 
		else m1[i], m2[i] = "", "" 
		end      
		if m1[i] ~= "" 
		    then h1[i], s1[i], v1[i] = _st.RGB_to_HSV(m1[i]) 
		end          
		if m2[i] ~= "" 
		    then h2[i], s2[i], v2[i] = _st.RGB_to_HSV(m2[i]) 
		end           
		if vt["svc" .. i] >= vt["colors" .. i] 
		and vt["svc" .. i] >= vt["img" .. i] 
		and vt["svc" .. i] >= vt["c" .. i] 
		and vt["svc" .. i] >= vt["vc" .. i]  
		and m1[i] ~= "" 
		and m2[i] ~= "" 
		and setr == "word" 
		    then color[i] = vc_cl:format(i,ass_color(HSV_to_RGB((360/(#text-vt["svc" .. i])*((j-vt["svc" .. i])-1)+h1[i])%360, s1[i], v1[i])),ass_color(HSV_to_RGB((360/(#text-vt["svc" .. i])*((j-vt["svc" .. i])-1)+h2[i])%360, s2[i], v2[i])),ass_color(HSV_to_RGB((360/(#text-vt["svc" .. i])*(j-vt["svc" .. i])+h1[i])%360, s1[i], v1[i])),ass_color(HSV_to_RGB((360/(#text-vt["svc" .. i])*(j-vt["svc" .. i])+h2[i])%360, s2[i], v2[i]))) 
		elseif vt["svc" .. i] >= vt["colors" .. i] 
		and vt["svc" .. i] >= vt["img" .. i] 
		and vt["svc" .. i] >= vt["c" .. i] 
		and vt["svc" .. i] >= vt["vc" .. i] 
		and m1[i] ~= "" 
		and m2[i] ~= "" 
		    then color[i] = vc_cl:format(i,ass_color(HSV_to_RGB((360/(#text-vt["svc" .. i])*((j-vt["svc" .. i])-1)+h1[i])%360, s1[i], v1[i])),ass_color(HSV_to_RGB((360/(#text-vt["svc" .. i])*(j-vt["svc" .. i])+h1[i])%360, s1[i], v1[i])),ass_color(HSV_to_RGB((360/(#text-vt["svc" .. i])*((j-vt["svc" .. i])-1)+h2[i])%360, s2[i], v2[i])),ass_color(HSV_to_RGB((360/(#text-vt["svc" .. i])*(j-vt["svc" .. i])+h2[i])%360, s2[i], v2[i]))) 
		elseif vt["colors" .. i] >= vt["img" .. i]
		and vt["colors" .. i] >= vt["c" .. i] 
		and vt["colors" .. i] >= vt["vc" .. i] 
		and cs["cl" .. i][1] 
		and #(cs["cl" .. i][(j2-1)%(#cs["cl" .. i])+1]) <10 
		    then color[i] =  "\\" .. CD(i-1,"",i) .. "c" .. cs["cl" .. i][(j2-1)%(#cs["cl" .. i])+1] 
		elseif vt["colors" .. i] >= vt["img" .. i] 
		and vt["colors" .. i] >= vt["c" .. i] 
		and vt["colors" .. i] >= vt["vc" .. i] 
		and cs["cl" .. i][1] 
		and #(cs["cl" .. i][(j2-1)%(#cs["cl" .. i])+1]) >10 
		and (cs["cl" .. i][(j2-1)%(#cs["cl" .. i])+1]):match("&") 
		    then color[i] =  "\\" .. i .. "vc(" .. cs["cl" .. i][(j2-1)%(#cs["cl" .. i])+1] .. ")" 
		elseif vt["colors" .. i] >= vt["img" .. i] 
		and vt["colors" .. i] >= vt["c" .. i] 
		and vt["colors" .. i] >= vt["vc" .. i] 
		and cs["cl" .. i][1] 
		and #(cs["cl" .. i][(j2-1)%(#cs["cl" .. i])+1]) >10 
		    then color[i] =  "\\" .. i .. "img(" .. cs["cl" .. i][(j2-1)%(#cs["cl" .. i])+1] .. ")" 
		elseif vt["c" .. i] >= vt["vc" .. i] 
		and vt["c" .. i] >= vt["img" .. i] 
		and tags["c" .. i] ~= "" 
		    then color[i] = tags["c" .. i] 
		elseif vt["vc" .. i] >= vt["img" .. i] 
		and tags["vc" .. i] ~= "" 
		    then color[i] = tags["vc" .. i] 
		elseif tags["img" .. i] ~= "" 
		    then color[i] = tags["img" .. i] 
		elseif add_dieuchinh:match("\\" .. CD(i-1,"",i) .. "c") 
		    then color[i] = "\\" .. CD(i-1,"",i) .. "c" .. add_dieuchinh:match("\\" .. CD(i-1,"",i) .. "c([^\\}]+)") 
		elseif add_dieuchinh:match("\\" .. i .. "vc") 
		    then color[i] = "\\" .. i .. "vc" .. add_dieuchinh:match("\\" .. i .. "vc([^\\}]+)") 
		elseif add_dieuchinh:match("\\" .. i .. "img") 
		    then color[i] = "\\" .. i .. "img" .. add_dieuchinh:match("\\" .. i .. "img([^\\}]+)") 
		else color[i] = "" 
		end   
	end  
	if tags.r ~= "" then line.style = tags.r end
	return  color[1] .. color[2] .. color[3] .. color[4] 
end

_st.set_n_string = function(cbkt, ktcl) 
    cmkt = "" 
	for i = 1, #cbkt do 
	    if cbkt:sub(i, #ktcl+(i-1)) == ktcl 
	        then cmkt = cmkt .. "1" 
		end 
	end 
	return #cmkt 
end

_st.set_vt_string = function(cbtext, ttyc, ktyc) 
    cmkt = ""  
	vt = 0 
	for i = 1, #cbtext do 
	    if #cmkt == ttyc 
	        then break 
	    elseif cbtext[i]:match(ktyc) 
	        then cmkt = cmkt .. "1"  vt = i 
	    end 
	end 
	return vt 
end

-- Apply the templates
function apply_templates(meta, styles, subs, templates)
	-- the environment the templates will run in
	local tenv = {
		meta = meta,
		-- put in some standard libs
		string = string,
		math = math,
		_G = _G,
		_st = _st
	}
	tenv._tp = templates
	tenv.revalue = _st.revalue
	tenv.delay = _st.delay
	tenv.Hex = Hex
	tenv.int = int
	tenv.float = float
	tenv.HexToRef = HexToRef
	tenv.AscByChar = _st.AscByChar
	tenv.RGB_to_HSV = _st.RGB_to_HSV
	tenv.ReadTags = string.ReadTags
	tenv.Word = string.Word
	tenv.CD = CD
	tenv.setw_char = setw_char
	tenv.tenv = tenv
	
	-- Define helper functions in tenv
	
	tenv.retime = function(mode, addstart, addend)
		local line, syl = tenv.line, tenv.syl
		local newstart, newend = line.start_time, line.end_time
		addstart = addstart or 0
		addend = addend or 0
		if mode == "syl" then
			newstart = line.start_time + syl.start_time + addstart
			newend = line.start_time + syl.end_time + addend
		elseif mode == "presyl" then
			newstart = line.start_time + syl.start_time + addstart
			newend = line.start_time + syl.start_time + addend
		elseif mode == "postsyl" then
			newstart = line.start_time + syl.end_time + addstart
			newend = line.start_time + syl.end_time + addend
		elseif mode == "line" then
			newstart = line.start_time + addstart
			newend = line.end_time + addend
		elseif mode == "preline" then
			newstart = line.start_time + addstart
			newend = line.start_time + addend
		elseif mode == "postline" then
			newstart = line.end_time + addstart
			newend = line.end_time + addend
		elseif mode == "start2syl" then
			newstart = line.start_time + addstart
			newend = line.start_time + syl.start_time + addend
		elseif mode == "syl2end" then
			newstart = line.start_time + syl.end_time + addstart
			newend = line.end_time + addend
		elseif mode == "set" or mode == "abs" then
			newstart = addstart
			newend = addend
		elseif mode == "sylpct" then
			newstart = line.start_time + syl.start_time + addstart*syl.duration/100
			newend = line.start_time + syl.start_time + addend*syl.duration/100
		-- wishlist: something for fade-over effects,
		-- "time between previous line and this" and
		-- "time between this line and next"
		end
		line.start_time = newstart
		line.end_time = newend
		line.duration = newend - newstart
		return ""
	end
	
	tenv.fxgroup = {}
	
	tenv.relayer = function(layer)
		tenv.line.layer = layer
		return ""
	end
	
	tenv.restyle = function(style)
		tenv.line.style = style
		tenv.line.styleref = styles[style]
		return ""
	end
	
	tenv.maxloop = function(newmaxj)
		tenv.maxj = newmaxj
		return ""
	end
	tenv.maxloops = tenv.maxloop
	tenv.loopctl = function(newj, newmaxj)
		tenv.j = newj
		tenv.maxj = newmaxj
		return ""
	end
	
	tenv.recall = {}
	setmetatable(tenv.recall, {
		decorators = {},
		__call = function(tab, name, default)
			local decorator = getmetatable(tab).decorators[name]
			if decorator then
				name = decorator(tostring(name))
			end
			aegisub.debug.out(5, "Recalling '%s'\n", name)
			return tab[name] or default
		end,
		decorator_line = function(name)
			return string.format("_%s_%s", tostring(tenv.orgline), name)
		end,
		decorator_syl = function(name)
			return string.format("_%s_%s", tostring(tenv.syl), name)
		end,
		decorator_basesyl = function(name)
			return string.format("_%s_%s", tostring(tenv.basesyl), name)
		end
	})
	tenv.remember = function(name, value, decorator)
		getmetatable(tenv.recall).decorators[name] = decorator
		if decorator then
			name = decorator(tostring(name))
		end
		aegisub.debug.out(5, "Remembering '%s' as '%s'\n", name, tostring(value))
		tenv.recall[name] = value
		return value
	end
	tenv.remember_line = function(name, value)
		return tenv.remember(name, value, getmetatable(tenv.recall).decorator_line)
	end
	tenv.remember_syl = function(name, value)
		return tenv.remember(name, value, getmetatable(tenv.recall).decorator_syl)
	end
	tenv.remember_basesyl = function(name, value)
		return tenv.remember(name, value, getmetatable(tenv.recall).decorator_basesyl)
	end
	tenv.remember_if = function(name, value, condition, decorator)
		if condition then
			return tenv.remember(name, value, decorator)
		end
		return value
	end
	
	-- run all run-once code snippets
	for k, t in pairs(templates.once) do
		assert(t.code, "WTF, a 'once' template without code?")
		run_code_template(t, tenv)
	end
	
	-- start processing lines
	local i, n = 0, #subs
	while i < n do
		aegisub.progress.set(i/n*100)
		i = i + 1
		local l = subs[i]
		if l.class == "dialogue" and ((l.effect == "" and not l.comment) or l.effect:match("[Kk]araoke") or l.effect:match("text code")) then
			l.i = i
			l.comment = false
			karaskel.preproc_line(subs, meta, styles, l)
			if apply_line(meta, styles, subs, l, templates, tenv) then
				-- Some templates were applied to this line, make a karaoke timing line of it
				l.comment = true
				l.effect = "karaoke"
				subs[i] = l
			end			
		end
	end
end

function set_ctx_syl(varctx, line, syl)
	varctx.sstart = syl.start_time
	varctx.send = syl.end_time
	varctx.sdur = syl.duration
	varctx.skdur = syl.duration / 10
	varctx.smid = syl.start_time + syl.duration / 2
	varctx["start"] = varctx.sstart
	varctx["end"] = varctx.send
	varctx.dur = varctx.sdur
	varctx.kdur = varctx.skdur
	varctx.mid = varctx.smid
	varctx.si = syl.i
	varctx.i = varctx.si
	varctx.sleft = math.floor(line.left + syl.left+0.5)
	varctx.scenter = math.floor(line.left + syl.center+0.5)
	varctx.sright = math.floor(line.left + syl.right+0.5)
	varctx.swidth = math.floor(syl.width + 0.5)
	if syl.isfuri then
		varctx.sbottom = varctx.ltop
		varctx.stop = math.floor(varctx.ltop - syl.height + 0.5)
		varctx.smiddle = math.floor(varctx.ltop - syl.height/2 + 0.5)
	else
		varctx.stop = varctx.ltop
		varctx.smiddle = varctx.lmiddle
		varctx.sbottom = varctx.lbottom
	end
	varctx.sheight = syl.height
	if line.halign == "left" then
		varctx.sx = math.floor(line.left + syl.left + 0.5)
	elseif line.halign == "center" then
		varctx.sx = math.floor(line.left + syl.center + 0.5)
	elseif line.halign == "right" then
		varctx.sx = math.floor(line.left + syl.right + 0.5)
	end
	if line.valign == "top" then
		varctx.sy = varctx.stop
	elseif line.valign == "middle" then
		varctx.sy = varctx.smiddle
	elseif line.valign == "bottom" then
		varctx.sy = varctx.sbottom
	end
	varctx.left = varctx.sleft
	varctx.center = varctx.scenter
	varctx.right = varctx.sright
	varctx.width = varctx.swidth
	varctx.top = varctx.stop
	varctx.middle = varctx.smiddle
	varctx.bottom = varctx.sbottom
	varctx.height = varctx.sheight
	varctx.x = varctx.sx
	varctx.y = varctx.sy
end

function apply_line(meta, styles, subs, line, templates, tenv)
	-- Tell whether any templates were applied to this line, needed to know whether the original line should be removed from input
	local applied_templates = false
	
	-- General variable replacement context
	local varctx = {
		layer = line.layer,
		lstart = line.start_time,
		lend = line.end_time,
		ldur = line.duration,
		lmid = line.start_time + line.duration/2,
		style = line.style,
		actor = line.actor,
		margin_l = ((line.margin_l > 0) and line.margin_l) or line.styleref.margin_l,
		margin_r = ((line.margin_r > 0) and line.margin_r) or line.styleref.margin_r,
		margin_t = ((line.margin_t > 0) and line.margin_t) or line.styleref.margin_t,
		margin_b = ((line.margin_b > 0) and line.margin_b) or line.styleref.margin_b,
		margin_v = ((line.margin_t > 0) and line.margin_t) or line.styleref.margin_t,
		syln = line.kara.n,
		li = line.i,
		lleft = math.floor(line.left+0.5),
		lcenter = math.floor(line.left + line.width/2 + 0.5),
		lright = math.floor(line.left + line.width + 0.5),
		lwidth = math.floor(line.width + 0.5),
		ltop = math.floor(line.top + 0.5),
		lmiddle = math.floor(line.middle + 0.5),
		lbottom = math.floor(line.bottom + 0.5),
		lheight = math.floor(line.height + 0.5),
		lx = math.floor(line.x+0.5),
		ly = math.floor(line.y+0.5)
	}
	
	tenv.orgline = line
	tenv.line = nil
	tenv.syl = nil
	tenv.basesyl = nil

	-- Apply all line templates
	aegisub.debug.out(5, "Running line templates\n")
	for t in matching_templates(templates.line, line, tenv) do
		if aegisub.progress.is_cancelled() then break end
		
		-- Set varctx for per-line variables
		varctx["start"] = varctx.lstart
		varctx["end"] = varctx.lend
		varctx.dur = varctx.ldur
		varctx.kdur = math.floor(varctx.dur / 10)
		varctx.mid = varctx.lmid
		varctx.i = varctx.li
		varctx.left = varctx.lleft
		varctx.center = varctx.lcenter
		varctx.right = varctx.lright
		varctx.width = varctx.lwidth
		varctx.top = varctx.ltop
		varctx.middle = varctx.lmiddle
		varctx.bottom = varctx.lbottom
		varctx.height = varctx.lheight
		varctx.x = varctx.lx
		varctx.y = varctx.ly
		
		for j, maxj in template_loop(tenv, t.loops) do
			if t.code then
				aegisub.debug.out(5, "Code template, %s\n", t.code)
				tenv.line = line
				-- Although run_code_template also performs template looping this works
				-- by "luck", since by the time the first loop of this outer loop completes
				-- the one run by run_code_template has already performed all iterations
				-- and has tenv.j and tenv.maxj in a loop-ending state, causing the outer
				-- loop to only ever run once.
				run_code_template(t, tenv)
			else
				aegisub.debug.out(5, "Line template, pre = '%s', t = '%s'\n", t.pre, t.t)
				applied_templates = true
				local newline = table.copy(line)
				tenv.line = newline
				newline.layer = t.layer
				newline.text = ""
				if t.pre ~= "" then
					newline.text = newline.text .. run_text_template(t.pre, tenv, varctx)
				end
				if t.t ~= "" then
					for i = 1, line.kara.n do
						local syl = line.kara[i]
						tenv.syl = syl
						tenv.basesyl = syl
						set_ctx_syl(varctx, line, syl)
						newline.text = newline.text .. run_text_template(t.t, tenv, varctx)
						if t.addtext then
							if t.keeptags then
								newline.text = newline.text .. syl.text
							else
								newline.text = newline.text .. syl.text_stripped
							end
						end
					end
				else
					-- hmm, no main template for the line... put original text in
					if t.keeptags then
						newline.text = newline.text .. line.text
					else
						newline.text = newline.text .. line.text_stripped
					end
				end
				newline.effect = "fx"
				subs.append(newline)
			end
		end
	end
	aegisub.debug.out(5, "Done running line templates\n\n")
	
	-- Loop over syllables
	for i = 0, line.kara.n do
		if aegisub.progress.is_cancelled() then break end
		local syl = line.kara[i]
		
		aegisub.debug.out(5, "Applying templates to syllable: %s\n", syl.text)
		if apply_syllable_templates(syl, line, templates.syl, tenv, varctx, subs) then
			applied_templates = true
		end
	end
	
	-- Loop over furigana
	for i = 1, line.furi.n do
		if aegisub.progress.is_cancelled() then break end
		local furi = line.furi[i]
		
		aegisub.debug.out(5, "Applying templates to furigana: %s\n", furi.text)
		if apply_syllable_templates(furi, line, templates.furi, tenv, varctx, subs) then
			applied_templates = true
		end
	end
	
	return applied_templates
end

function run_code_template(template, tenv)
	local f, err = loadstring(template.code, "template code")
	if not f then
		aegisub.debug.out(2, "Failed to parse Lua code: %s\nCode that failed to parse: %s\n\n", err, template.code)
	else
		local pcall = pcall
		setfenv(f, tenv)
		for j, maxj in template_loop(tenv, template.loops) do
			local res, err = pcall(f)
			if not res then
				aegisub.debug.out(2, "Runtime error in template code: %s\nCode producing error: %s\n\n", err, template.code)
			end
		end
	end
end

function run_text_template(template, tenv, varctx)
	local res = template
	aegisub.debug.out(5, "Running text template '%s'\n", res)
	
	-- Replace the variables in the string (this is probably faster than using a custom function, but doesn't provide error reporting)
	if varctx then
		aegisub.debug.out(5, "Has varctx, replacing variables\n")
		local function var_replacer(varname)
			varname = string.lower(varname)
			aegisub.debug.out(5, "Found variable named '%s', ", varname)
			if varctx[varname] ~= nil then
				aegisub.debug.out(5, "it exists, value is '%s'\n", varctx[varname])
				return varctx[varname]
			else
				aegisub.debug.out(5, "doesn't exist\n")
				aegisub.debug.out(2, "Unknown variable name: %s\nIn karaoke template: %s\n\n", varname, template)
				return "$" .. varname
			end
		end
		res = res:gsub("$w_([%a_]+)","string.word.%1"):gsub("$c_([%a_]+)","string.char.%1"):gsub("$([%a_]+)", var_replacer)
		aegisub.debug.out(5, "Done replacing variables, new template string is '%s'\n", res)
	end
	
	-- Function for evaluating expressions
	local function expression_evaluator(expression)
		f, err = loadstring(string.format("return (%s)", expression))
		if (err) ~= nil then
			aegisub.debug.out(2, "Error parsing expression: %s\nExpression producing error: %s\nTemplate with expression: %s\n\n", err, expression, template)
			return "!" .. expression .. "!"
		else
			setfenv(f, tenv)
			local res, val = pcall(f)
			if res then
				return val
			else
				aegisub.debug.out(2, "Runtime error in template expression: %s\nExpression producing error: %s\nTemplate with expression: %s\n\n", val, expression, template)
				return "!" .. expression .. "!"
			end
		end
	end
	-- Find and evaluate expressions
	aegisub.debug.out(5, "Now evaluating expressions\n")
	res = res:gsub("!(.-)!",function(a) return "!" .. a:gsub("@%(([^\\}]+),([^\\}]+)%)","_st.revalue(%1,%2)") .. "!" end)
	res = res:gsub("!(.-)!", expression_evaluator)
	aegisub.debug.out(5, "After evaluation: %s\nDone handling template\n\n", res)
	
	return res
end

function apply_syllable_templates(syl, line, templates, tenv, varctx, subs)
	local applied = 0
	
	-- Loop over all templates matching the line style
	for t in matching_templates(templates, line, tenv) do
		if aegisub.progress.is_cancelled() then break end
		
		tenv.syl = syl
		tenv.basesyl = syl
		set_ctx_syl(varctx, line, syl)
		
		applied = applied + apply_one_syllable_template(syl, line, t, tenv, varctx, subs, false, false)
	end
	
	return applied > 0
end

function is_syl_blank(syl)
	if syl.duration <= 0 then
		return true
	end
	
	-- try to remove common spacing characters
	local t = syl.text_stripped
	if t:len() <= 0 then return true end
	t = t:gsub("[ \t\n\r]", "") -- regular ASCII space characters
	t = t:gsub("　", "") -- fullwidth space
	return t:len() <= 0
end

function apply_one_syllable_template(syl, line, template, tenv, varctx, subs, skip_perchar, skip_multi)
	if aegisub.progress.is_cancelled() then return 0 end
	local t = template
	local applied = 0
	
	aegisub.debug.out(5, "Applying template to one syllable with text: %s\n", syl.text)
	
	-- Check for right inline_fx
	if t.fx and t.fx ~= syl.inline_fx then
		aegisub.debug.out(5, "Syllable has wrong inline-fx (wanted '%s', got '%s'), skipping.\n", t.fx, syl.inline_fx)
		return 0
	end
	
	if t.noblank and is_syl_blank(syl) then
		aegisub.debug.out(5, "Syllable is blank, skipping.\n")
		return 0
	end
	
	-- Recurse to per-char if required
	if not skip_perchar and t.perchar then
		aegisub.debug.out(5, "Doing per-character effects...\n")
		local charsyl = table.copy(syl)
		tenv.syl = charsyl
		
		local left, width = syl.left, 0
		for c in unicode.chars(syl.text_stripped) do
			charsyl.text = c
			charsyl.text_stripped = c
			charsyl.text_spacestripped = c
			charsyl.prespace, charsyl.postspace = "", "" -- for whatever anyone might use these for
			width = aegisub.text_extents(syl.style, c)
			charsyl.left = left
			charsyl.center = left + width/2
			charsyl.right = left + width
			charsyl.prespacewidth, charsyl.postspacewidth = 0, 0 -- whatever...
			left = left + width
			set_ctx_syl(varctx, line, charsyl)
			
			applied = applied + apply_one_syllable_template(charsyl, line, t, tenv, varctx, subs, true, false)
		end
	
		return applied
	end
	
	-- Recurse to multi-hl if required
	if not skip_multi and t.multi then
		aegisub.debug.out(5, "Doing multi-highlight effects...\n")
		local hlsyl = table.copy(syl)
		tenv.syl = hlsyl
		
		for hl = 1, syl.highlights.n do
			local hldata = syl.highlights[hl]
			hlsyl.start_time = hldata.start_time
			hlsyl.end_time = hldata.end_time
			hlsyl.duration = hldata.duration
			set_ctx_syl(varctx, line, hlsyl)
			
			applied = applied + apply_one_syllable_template(hlsyl, line, t, tenv, varctx, subs, true, true)
		end
	
		return applied
	end

	-- Regular processing
	if t.code then
		aegisub.debug.out(5, "Running code line\n")
		tenv.line = line
		run_code_template(t, tenv)
	else
		aegisub.debug.out(5, "Running %d effect loops\n", t.loops)
		for j, maxj in template_loop(tenv, t.loops) do
			local newline = table.copy(line)
			newline.styleref = syl.style
			newline.style = syl.style.name
			newline.layer = t.layer
			tenv.line = newline
			newline.text = run_text_template(t.t, tenv, varctx)
			if t.keeptags then
				newline.text = newline.text .. syl.text
			elseif t.addtext then
				newline.text = newline.text .. syl.text_stripped
			end
			newline.effect = "fx"
			aegisub.debug.out(5, "Generated line with text: %s\n", newline.text)
			subs.append(newline)
			applied = applied + 1
		end
	end
	
	return applied
end


-- Main function to do the templating
function filter_apply_templates(subs, config)
	aegisub.progress.task("Collecting header data...")
	local meta, styles = karaskel.collect_head(subs, true)
	
	aegisub.progress.task("Parsing templates...")
	local templates = parse_templates(meta, styles, subs)
	
	aegisub.progress.task("Applying templates...")
	apply_templates(meta, styles, subs, templates)
end

function macro_apply_templates(subs, sel)
	filter_apply_templates(subs, {ismacro=true, sel=sel})
	aegisub.set_undo_point("apply karaoke template")
end

function macro_can_template(subs)
	-- check if this file has templates in it, don't allow running the macro if it hasn't
	local num_dia = 0
	for i = 1, #subs do
		local l = subs[i]
		if l.class == "dialogue" then
			num_dia = num_dia + 1
			-- test if the line is a template
			if (l.effect:headtail()):lower() == "template" then
				return true
			end
			-- don't try forever, this has to be fast
			if num_dia > 50 then
				return false
			end
		end
	end
	return false
end

aegisub.register_macro(tr"Apply karaoke strawberry", tr"Applies karaoke effects from templates", macro_apply_templates, macro_can_template)
aegisub.register_filter(script_name, tr"Apply karaoke effect templates to the subtitles.\n\nSee the help file for information on how to use this.", 2000, filter_apply_templates)
