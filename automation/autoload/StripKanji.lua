-- 草莓Dâu Tây 's Type Fx Vert
-- Edit by Effector Cmy

include("karaskel.lua")

script_name = "Xóa Kanji"
script_description = "Strip Kanji"
script_author = "草莓Dâu Tây 's tool"
script_version = "1"

function notd(t)
	cbd = {',', '.', '?', '/', '<', '>', ':', ';', '\'', '"', '{', '}', '[', ']', '\\', '|', '!', '@', '#', '%', '￥', '$', '^', '&', '*', '(', ')', '_', '+', '-', '=', '`', '~', ' '}
	sd = true
	for i = 1, #cbd do
		if t == cbd[i] then
			sd = false
			break
		end
	end
	return sd
end

function StripKanji(l)
	local text = l.text
	local ntext, set = "", true
	for char in unicode.chars(text) do
		if unicode.codepoint(char) > 11903 then
			set = false
		end
		if unicode.codepoint(char) < 11904 and notd(char) then
			set = true
		end
		if set then ntext = ntext .. char end
	end
	return ntext
end
	
function Apply(subs, sel)
	for z, i in ipairs(sel) do
		local l = subs[i]
		l.text = StripKanji(l)
		subs[i] = l
	end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, "Strip Kanji tags to all selected lines", Apply)