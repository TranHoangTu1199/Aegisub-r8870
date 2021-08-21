-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

include("karaskel.lua");

script_name = "Cmy Viet Hoa"
script_description = "tự động viết hoa đầu câu hoặc sau dấu chấm(.), chấm hỏi(?), chấm than(!), chấm phẩy(;) và dấu hai chấm(:)"
script_author = "Cmy草莓"
script_version = "2.0" 

Aph1 = {"è","é","ẻ","ẽ","ẹ","ê","ề","ế","ể","ễ","ệ","ỳ","ý","ỷ","ỹ","ỵ","ù","ú","ủ","ũ","ụ","ư","ừ","ứ","ử","ữ","ự","ì","í","ỉ","ĩ","ị","ò","ó","ỏ","õ","ọ","ô","ồ","ố","ổ","ỗ","ộ","ơ","ờ","ớ","ở","ỡ","ợ","à","á","ả","ã","ạ","ă","ằ","ắ","ẳ","ẵ","ặ","â","ầ","ấ","ẩ","ẫ","ậ","đ"}      
Aph2={'È','É','Ẻ','Ẽ','Ẹ','Ê','Ề','Ế','Ể','Ễ','Ệ','Ỳ','Ý','Ỷ','Ỹ','Ỵ','Ù','Ú','Ủ','Ũ','Ụ','Ư','Ừ','Ứ','Ử','Ữ','Ự','Ì','Í','Ỉ','Ĩ','Ị','Ò','Ó','Ỏ','Õ','Ọ','Ô','Ồ','Ố','Ổ','Ỗ','Ộ','Ơ','Ờ','Ớ','Ở','Ỡ','Ợ','À','Á','Ả','Ã','Ạ','Ă','Ằ','Ắ','Ẳ','Ẵ','Ặ','Â','Ầ','Ấ','Ẩ','Ẫ','Ậ','Đ'}                                 

function CH(text) 
    vltext = ""  
    for i = 1, #Aph1 do 
        if text == Aph1[i] then 
            vltext = vltext .. Aph2[i] 
            break 
        else vltext = vltext .. "" 
        end 
    end 
    if vltext ~= "" then 
        return vltext 
    else return text
    end 
end

function VH(text) 
    text2 = text  
	a = {} 
	for i = 1, unicode.len(text) do 
	    for alp in unicode.chars(text) do 
		    a[i] = alp  
		end 
		if text == "" then  
		    break 
		end 
		text = text:sub(1,-#a[i]-1)  
	end;   
	a_t = ""     
	for z = 1,#a do 	  
	    ci = #a-z+1		
		local sett = ""	
		for i = 1,z do	    
		    if a[#a-i+1] == "{" then 
			    sett = sett .. "1"	
			elseif a[#a-i+1] == "}" then 
			    sett = sett .. "2"		
			else sett = sett .. ""	 
			end 
		end    
		local sett2 = sett:sub(-1)	  
		if a[#a-z+1] == " " then 
		    a_t = a_t .. "/_/ " 
		elseif sett2 == "1" or a[#a-z+1] == "}" then 
		    a_t = a_t .. a[#a-z+1]		
		else  a_t = a_t .. a[#a-z+1] .. " "		
		end	
	end;              
	a2 = {}     
	for i = 1, unicode.len(a_t) do 
	    for chart in string.words(a_t) do  
	        a2[i] = chart  
		end  
	    if a_t == "" then  
	        break 
	    end 
	    a_t = a_t:sub(1,-#a2[i]-2)  
	end ;    
	char_text = {} 
	for i = 1, #a2 do 
		char_text[i] = a2[#a2-i+1]:gsub("/_/","") 
	end 
    local only_t = ""	
	if CH(char_text[1]) ~= char_text[1] then 
		only_t = CH(char_text[1]) 
    else only_t = char_text[1]:upper()  
    end  
	return only_t .. text2:sub(#only_t+1) 
end

function Apply(subs, sel)
    for z, i in ipairs(sel) do
        local l = subs[i]
		l.text = VH(l.text:gsub("%.%s([^.]+)",function(a) return ". " .. VH(a) end):gsub("%?%s([^?]+)",function(a) return "? " .. VH(a) end):gsub("!%s([^!]+)",function(a) return "! " .. VH(a) end):gsub(";%s([^;]+)",function(a) return "; " .. VH(a) end):gsub(":%s([^:]+)",function(a) return ": " .. VH(a) end)) 
		subs[i] = l
	end
end

aegisub.register_macro(script_name, script_description, Apply)