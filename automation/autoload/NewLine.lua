-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

include("karaskel.lua");
local tr = aegisub.gettext

script_name = tr"Cmy - New line"
script_description = "to new line"
script_author = "Cmy草莓"
script_version = "1.0"

function apply(subs, sel)
    for _, i in ipairs(sel) do
		aegisub.progress.set(i / #subs * 100)
		local l = subs[i]
		text = l.text
		newline = {}
		local z = 1
		local oldtext = ""
		newline[1] = ""
		if text then
			for chtext in unicode.chars(text) do
				if (oldtext .. chtext) == "\\N" then
					newline[z] = newline[z] : sub(1, -2)
					z = z + 1
					newline[z] = ""
				else
					newline[z] = newline[z] .. chtext
				end
				oldtext = chtext
			end
			if #newline > 0 then
				for j = 1, #newline do
					l.text = newline[j]
					subs.append(l)
				end
			else
				subs.append(l)
			end
		end
		l.comment = true
		subs[i] = l
	end
	for _, i in ipairs(sel) do
		local l = subs[i]
		if l.comment then subs.delete(i) end
	end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, apply)