-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

script_name = "Cmy - Clip To Moves 1.0"
script_description = "Converts clip to moves"
script_author = "Cmy草莓"
script_version = "1.0"
include("karaskel.lua")

function ClipToMoves(l, ms)
	local text = l.text
	local x, y = text:match("\\pos%(([%d]+),([%d]+)%)")
	x, y = x or l.center, y or l.middle
	local clipvl = text:match("\\clip%(m(.-)%)")
	local tbs1, tbs2 = "\\fsp" .. ms .. "\\fsvp0", "\\fsp" .. ms
	local i = 0
	local _x, _y
	local frame = 42*(l.effect:match("([%d]+)") or 1)
	tm1, tm2 = "\\t(%d,%d,\\fsp%d\\fsvp%d)", "\\t(%d,%d,\\fsp%d)"
	for clip_x, clip_y in clipvl:gmatch("([%d]+)%s([%d]+)") do
		if i == 0 then
			_x = x - clip_x 
			_y = y - clip_y
		else
			tbs1 = tbs1 .. tm1:format((i-1)*frame, i*frame, (clip_x-x+_x)*2+ms, y-clip_y-_y)
			tbs2 = tbs2 .. tm2:format((i-1)*frame, i*frame, (clip_x-x+_x)*2+ms)
		end
		i = i + 1
	end
	text = text:gsub("\\clip%(m(.-)%)", ""):gsub("\\N", "\\N{" .. tbs2 .. "\\alphaHFF}|{\\fsp0\\alpha}")
	text = ("{" .. tbs1 .. "\\alphaHFF}|{\\fsp0\\alpha}" .. text):gsub("}{", "")
	l.text = text
end

function apply(subs, sel)
	for z, i in ipairs(sel) do
		local l = subs[i]
		meta, styles = karaskel.collect_head(subs)
		karaskel.preproc_line(subs, meta, styles, l)
		if l.text:match("\\clip%(m(.-)%)") then ClipToMoves(l, aegisub.text_extents(l.kara[1].style, "|")) end
		subs[i] = l
	end
end

aegisub.register_macro(script_name, script_description, apply)