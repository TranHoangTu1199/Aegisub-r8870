-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

include("karaskel.lua")
local tr = aegisub.gettext

script_name = tr"Cmy - Remember 1.5"
script_description = "Cmy's Tool Remember"
script_author = "Cmy草莓"
script_version = "1.5"
link1 = aegisub.decode_path("?user") .. "/RememberCmy.lua"
link2 = aegisub.decode_path("?data") .. "/RememberCmy.lua"

if (io.open(link1, "a+")) then link = link1 else link = link2 end

Credit =  function(r) return string.rep("-", r) .. " CODE BY CMY - 草莓 Dâu Tây " .. string.rep("-", r) end

SaveKey = tr"Save"
OpenKey = tr"Open File"
DelKey = tr"Delete"
DelAllKey = DelKey .. " " ..  tr"All"
AddRmb = tr"Add"
AppKey = tr"Apply"
CloseKey = tr"Close"

function SaveFile(text, fname)
    local file = io.open(fname,"w")
    file : write(text)		
	file : close()
end 

function ApplyText(subs, sel, applytext)
	for z, i in ipairs(sel) do
		local l = subs[i]
		if l.text:match("`") then
			l.text = l.text:gsub("`", applytext) : gsub("}{","")
		else
			l.text = (applytext .. l.text) : gsub("}{","")
		end
		subs[i] = l
	end
end

function ReadFile()
    local file = io.open(link,"a+")   		
    rtext = file : read("*a")		
	file : close()
	return rtext
end

function Remember(subs, sel)
	local file = io.open(link)    
	setfile = (file and true or false)		
	if file then file:close() end  
	if not setfile then
		SaveFile("Rmb = {}", link)
	end
	rfile = ReadFile() or ""
	if not (rfile : match("Rmb = {}")) then rfile = "Rmb = {}\n" .. rfile end
	Rmb = loadstring(rfile .. " return Rmb")()
	repeat
	local RmbName = {}
	local i = 0
	for name, _ in pairs(Rmb) do
		i = i + 1
		RmbName[i] = name
	end
	table.sort(RmbName)
	if #RmbName < 1 then 
		menu = {
			{x = 0, y = 0, width = 10, height = 2, class = "label", label = Credit(20)};
			{x = 0, y = 2, width = 2, height = 1, class = "label", label = tr"Name" .. ": "}; 
	        {x = 2, y = 2, width = 8, height = 1, class = "edit", name = "remember_name", value = Name_n or "", hint = "Nhập tên khay nhớ tại đây"}; 
	        {x = 0, y = 3, width = 2, height = 1, class = "label", label = tr"Value" .. ": "}; 
	        {x = 2, y = 3, width = 8, height = 1, class = "edit", name = "remember_text", value = Value_n or "", hint = "Nhập giá trị cần ghi nhớ"}
		}
		P, res = ADD(menu, {AddRmb, OpenKey, CloseKey}, {ok = AddRmb, cancel = CloseKey})
		if not P then stop = true else stop = false end
	else menu = {
			{x = 0, y = 0, width = 18, height = 2, class = "label", label = Credit(45)}; 
	        {x = 0, y = 2, width = 3, height = 1, class = "label", label = tr"Name" .. ": "}; 
	        {x = 3, y = 2, width = 7, height = 1, class = "edit", name = "remember_name", value = Name_n or "", hint = "Nhập tên khay nhớ tại đây"}; 
			{x = 10, y = 2, width = 7, height = 1, class = "dropdown", items = RmbName, name = "remember_type", value = RmbName[1], hint = "Chọn khay nhớ cần chạy"};
			{x = 17, y = 2, width = 1, height = 1, class = "label", label = "  -- " .. #RmbName .. " --"};
	        {x = 0, y = 3, width = 3, height = 1, class = "label", label = tr"Value" .. ": "}; 
	        {x = 3, y = 3, width = 15, height = 1, class = "edit", name = "remember_text", value = Value_n or "", hint = "Nhập giá trị cần ghi nhớ"}
		}
		P, res = ADD(menu, {AppKey, AddRmb, SaveKey, DelKey, DelAllKey, OpenKey, CloseKey}, {ok = AppKey, cancel = CloseKey})
		if not P or (P == AppKey) then stop = true else stop = false end
	end
		Name_n, Value_n = res.remember_name, res.remember_text
		if P == AddRmb and (Value_n ~= "" and Name_n ~= "") then
			Rmb[Name_n] = Value_n
			Name_n, Value_n = "", ""
		elseif P == DelKey then
		    ttRmb = {}
			for i = 1, #RmbName do
				if RmbName[i] ~= res.remember_type then ttRmb[RmbName[i]] = Rmb[RmbName[i]] end
			end
			Rmb = ttRmb
		elseif P == DelAllKey then
			Rmb = {}
		elseif P == OpenKey then
			local filename = OPEN('Chọn File', '', '', '(.lua)|*.lua', false, true)
	        if filename then 
				file = assert(io.open(filename))    
		        filetext = file:read("*a")
			    file:close()
				f, err = loadstring(filetext)
				if not err then 
					ttrmb = loadstring(filetext .. " return ttrmb ")()
					for name, vl in pairs(ttrmb) do
						Rmb[name] = vl
					end
				end
			end
		elseif P == SaveKey then
		    local sfile = "ttrmb = {\n"
			for name, vl in pairs(Rmb) do
				sfile = sfile .. "\t[\"" .. name .. "\"] = \"" .. vl .. "\";\n"
			end
			sfile = sfile:gsub("\\","\\\\") .. "}"
			local file_name = SAVE('Nhập tên', 'File-Remember', '', '(.lua)|*.lua', true)
			if file_name then SaveFile(sfile, file_name) end
		end
	until stop
	if P == AppKey then ApplyText(subs, sel, Rmb[res.remember_type]) end
	local savermb = "Rmb = {\n"
	for name, vl in pairs(Rmb) do
		savermb = savermb .. "\t[\"" .. name .. "\"] = \"" .. vl .. "\";\n"
	end
	savermb = savermb : gsub("\\","\\\\") .. "}"
	SaveFile(savermb, link)
end

function apply_remember(subs,sel)
    ADD=aegisub.dialog.display
    ADP=aegisub.decode_path
	SAVE=aegisub.dialog.save
	OPEN=aegisub.dialog.open
    ak=aegisub.cancel
	Remember(subs, sel)
    aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, apply_remember)
