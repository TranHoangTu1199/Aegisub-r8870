-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

include("karaskel.lua");
local tr = aegisub.gettext

tool_name = tr"Cmy - Fx To Tags"
tool_description = tr"Cmy's Tool"
tool_author = "Cmy草莓"
tool_version = "1.5"

local haveDepCtrl,DependencyControl,depRec=pcall(require,"l0.DependencyControl")
re=require'aegisub.re'

function BC(subs,sel)
	for z, i in ipairs(sel) do
	local l = subs[i]
	local shtext = "{%s}" .. l.text
	if l.text:match("|") and (l.effect ~= "")
	    then l.text = l.text:gsub("|","{" .. l.effect .. "}"):gsub("}{","")
	elseif l.effect ~= ""
	    then l.text = shtext:format(l.effect):gsub("}{","")
	end
	subs[i] = l
	end
end

function apply_tags(subs,sel)
    BC(subs,sel)
    aegisub.set_undo_point(tool_name)
    return sel
end

if haveDepCtrl then depRec:registerMacro(apply_tags) else aegisub.register_macro(tool_name,tool_description,apply_tags) end
