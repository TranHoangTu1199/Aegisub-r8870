-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

include("karaskel.lua");
local tr = aegisub.gettext

script_name = tr"Add Ảnh"
script_description = tr"Cmy's add png"
script_author = "Cmy草莓"
script_version = "1.5"

function add_tags(subs,sel)
    meta, styles = karaskel.collect_head(subs, generate_furigana)
    ADD = aegisub.dialog.display
	for z, i in ipairs(sel) do
		local l = subs[i]
    karaskel.preproc_line(subs, meta, styles, l) 	
	
	filename = aegisub.dialog.open('Chọn ảnh', '', '',
                               '(.png)|*.png', false, true)
    if not filename then aegisub.cancel() end
	    
menu = {
    {x = 0, y = 0, width = 5, height = 1, class = "label", label = "Code by Cmy - 草莓Dâu Tây"}, 
	{x = 0, y = 1, width = 3, height = 1, class = "label", label = "Size ảnh x :"},
	{x = 3, y = 1, width = 1, height = 1, class = "intedit", name = "size_x", value = meta.res_x, min = 0, hint = "nhập size ảnh trục x"}, 
	{x = 0, y = 2, width = 3, height = 1, class = "label", label = "Size ảnh y :"},
	{x = 3, y = 2, width = 1, height = 1, class = "intedit", name = "size_y", value = meta.res_y, min = 0, hint = "nhập size ảnh trục y"}, 
}
	if filename then P,res = ADD(menu) end
	local fname = filename:gsub("\\","/")
	if l.text:match("\\pos") then xx, yy = l.text:match("\\pos%(([%d%.%-]+),([%d%.%-]+)%)") else xx, yy = l.center, l.middle end
	if xx and yy then pos = "\\pos(" .. xx .. "," .. yy .. ")" else pos = "" end
	showtext = "{\\p1\\an7\\fscx100\\fscy100\\bord0\\shad0\\1img(%s,0,0)%s}m %d %d l %d %d l %d %d l %d %d "
	
		if P then l.text = showtext:format(fname, pos, -res.size_x/2, -res.size_y/2, res.size_x/2, -res.size_y/2, res.size_x/2, res.size_y/2, -res.size_x/2, res.size_y/2) end	
		subs[i] = l
	end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, add_tags)
