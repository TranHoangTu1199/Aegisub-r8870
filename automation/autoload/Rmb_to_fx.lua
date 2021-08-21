-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

include'karaskel.lua'
local tr = aegisub.gettext

script_name = tr"Cmy - Remember To Fx"
script_description = "Cmy's Tool Remember To Fx"
script_author = "Cmy草莓"
script_version = "1.5"
link1 = aegisub.decode_path("?user") .. "/RememberCmy.lua"
link2 = aegisub.decode_path("?data") .. "/RememberCmy.lua"

if (io.open(link1, "a+")) then link = link1 elseif (io.open(link12)) then link = link2 else link = false end

function ReadFile()
    local file = io.open(link,"a+")   		
    rtext = file : read("*a")		
	file : close()
	return rtext
end

function Apply(subs, sel)
	if link then
		file_text = ReadFile()
	else
		file_text = ""
	end
	Rmb = {}
	f, err = loadstring(file_text .. "return Rmb")
	if not f then
		aegisub.debug.out(1, "%s", err)
	else
		Rmb = f()
	end
	for _, i in ipairs(sel) do
		l = subs[i]
		local rtext = Rmb[l.effect] or ""
		
		if rtext : match("$char$(.-)$") then
			Char()
		else
			Default()
		end
		
		subs[i] = l
	end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, Apply)
