-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

include("karaskel.lua");
local tr = aegisub.gettext

script_name = tr"Điều Chỉnh Tags Thông Minh"
script_description = tr"Cmy's add tags"
script_author = "Cmy草莓"
script_version = "1.5"
re=require'aegisub.re'

function RunTags(subs,sel)
    for z, i in ipairs(sel) do
		aegisub.progress.task("Apply to ... " .. z .. "/" .. #sel)
		line = subs[i]
		if P and res.lc == "Thêm tags" 
			then line.text = ("{" .. res.tags .. "}" .. line.text) : gsub("}{", "")
		elseif P and res.lc == "Xóa tags"
			then line.text = line.text : gsub(res.tags:gsub("%(", "%%(") : gsub("%)","%%)"), "") : gsub("{}", "")
		elseif P and res.lc == "Xóa tags + giá trị"
			then line.text = line.text : gsub(res.tags.."([^\\}*]+)", "") : gsub("{}", "")
		elseif P and res.lc == "Thay thế tags"
			then line.text = line.text : gsub(res.tags : gsub("%(", "%%(") : gsub("%)", "%%)"), res2.tags)
		end
		subs[i] = line
    end
end

function BC(subs,sel)
	menu = {
    {x = 0, y = 0, width = 8, height = 1, class = "label", label = "Code by Cmy - 草莓Dâu Tây"}, 
	{x = 0, y = 1, width = 15, height = 1, class = "dropdown", name = "lc", items = {"Thêm tags","Xóa tags","Xóa tags + giá trị","Thay thế tags"}, value = "Thêm tags", hint = "Chọn kiểu hoạt động"}, 
	{x = 0, y = 2, width = 15, height = 1, class = "edit", name = "tags", hint = "Điền tags vào đây"}, 
}
    menu2 = {
    {x = 0, y = 0, width = 8, height = 1, class = "label", label = "Nhập tags cần thay thế vào đây:"}, 
	{x = 0, y = 1, width = 15, height = 1, class = "edit", name = "tags", hint = "Nhập tags cần thay thế vào đây"}, 
}
	P, res = ADD(menu)
	if P and res.lc == "Thay thế tags" then P2,res2=ADD(menu2) end
	if P then RunTags(subs,sel) 
	end
end

function apply_tags(subs,sel)
    ADD=aegisub.dialog.display
    ADP=aegisub.decode_path
    ak=aegisub.cancel
    BC(subs,sel)
    aegisub.set_undo_point(script_name)
    return sel
end

aegisub.register_macro(script_name, script_description, apply_tags)
