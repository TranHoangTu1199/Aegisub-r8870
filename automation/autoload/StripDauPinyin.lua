-- 草莓Dâu Tây 's Type Fx Vert
-- Edit by Effector Cmy

local tr = aegisub.gettext
include("karaskel.lua")

script_name = tr"Xóa dấu pinyin"
script_description = tr"A demo macro showing how to do simple line modification in Automation 4"
script_author = "Niels Martin Hansen"
script_version = "1"

local pinyin = {"á", "ǎ", "à", "ā", "ò", "ó", "ǒ", "ō", "ì", "í", "ǐ", "ī", "ù", "ú", "ǔ", "ū", "é", "è", "ē", "ě", "ü", "ǘ", "ǜ", "ǖ", "ǚ", "Á", "Ǎ", "À", "Ā", "Ò", "Ó", "Ǒ", "Ō", "Ì", "Í", "Ǐ", "Ī", "Ù", "Ú", "Ǔ", "Ū", "É", "È", "Ē", "Ě", "Ü", "Ǘ", "Ǜ", "Ǖ", "Ǚ"}                         

function SETPY(text_once)  
    local setpy = ""          
	for i = 1, #pinyin do   
	    if text_once == pinyin[i]:sub(1, 1) or text_once == pinyin[i]:sub(2, 2) 
		    then setpy = setpy .. "1" break 
		else setpy = setpy .. "" end end 
		return setpy end    
		
function PinyinToLatin(tex)         
    if tex == pinyin[1] or tex == pinyin[2] or tex == pinyin[3] or tex == pinyin[4] 
	    then return "a" 
	elseif tex == pinyin[5] or tex == pinyin[6] or tex == pinyin[7] or tex == pinyin[8] 
	    then return "o" 
	elseif tex == pinyin[9] or tex == pinyin[10] or tex == pinyin[11] or tex == pinyin[12] 
	    then return "i" 
	elseif tex == pinyin[13] or tex == pinyin[14] or tex == pinyin[15] or tex == pinyin[16] 
	    then return "u" 
	elseif tex == pinyin[17] or tex == pinyin[18] or tex == pinyin[19] or tex == pinyin[20] 
	    then return "e" 
	elseif tex == pinyin[21] or tex == pinyin[22] or tex == pinyin[23] or tex == pinyin[24] or tex == pinyin[25] 
	    then return "u" 
	elseif tex == pinyin[26] or tex == pinyin[27] or tex == pinyin[28] or tex == pinyin[29] 
	    then return "A" 
	elseif tex == pinyin[30] or tex == pinyin[31] or tex == pinyin[32] or tex == pinyin[33] 
	    then return "O" 
	elseif tex == pinyin[34] or tex == pinyin[35] or tex == pinyin[36] or tex == pinyin[37] 
	    then return "I" 
	elseif tex == pinyin[38] or tex == pinyin[39] or tex == pinyin[40] or tex == pinyin[41] 
	    then return "U" 
	elseif tex == pinyin[42] or tex == pinyin[43] or tex == pinyin[44] or tex == pinyin[45] 
	    then return "E" 
	elseif tex == pinyin[46] or tex == pinyin[47] or tex == pinyin[48] or tex == pinyin[49] or tex == pinyin[50] 
	    then return "U" 
	else return "" end 
	
end                                  

function StripPinyin(l)     
    local SPY = ""    
	for i = 1, string.len(l.text) do 
	    if SETPY(l.text:sub(i, i)) == "1" 
		    then SPY = SPY .. PinyinToLatin(l.text:sub(i, i+1)) 
			else SPY = SPY .. l.text:sub(i, i) end end 
		return SPY end
	
function RunT(subtitles, selected_lines, active_line)
	for z, i in ipairs(selected_lines) do
		local l = subtitles[i]
		l.text = StripPinyin(l)
		subtitles[i] = l
	end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, tr"Strip Pinyin tags to all selected lines", RunT)
