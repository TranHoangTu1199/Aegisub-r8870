-- 草莓Dâu Tây 's Type Fx Vert
-- Code by Effector Cmy

include("karaskel.lua");
local tr = aegisub.gettext

script_name = tr"Simple Type Fx"
script_description = tr"Cmy's add type effect"
script_author = "Cmy草莓"
script_version="2.0"

local haveDepCtrl,DependencyControl,depRec=pcall(require,"l0.DependencyControl")
re=require'aegisub.re'
--style effect
local Allfx = {"Default","Fade","Zoom +","Zoom -","Fade Zoom +","Fade Zoom -","Zoom X+","Zoom Y+","Zoom X-","Zoom Y-",
               "Turn X-","Turn Y-","Turn Z-","Turn X+","Turn Y+","Turn Z+","Jump +","Jump -",
               "Char","Char DHV","Char Fade ->","Char Fade <-","Char Fade <>","Char Fade ><","Char Fade Random",
			   "Char Fog ->","Char Fog <-","Char Fog <>","Char Fog ><","Char Fog Random",
			   "Char Fade -> move bottom to top","Char Fade <- move bottom to top","Char Fade <> move bottom to top","Char Fade >< move bottom to top","Char Fade Random move bottom to top",
			   "Char Fade -> move top to bottom","Char Fade <- move top to bottom","Char Fade <> move top to bottom","Char Fade >< move top to bottom","Char Fade Random move top to bottom",
			   "Char Turn","Random Turn 1","Random Turn 2"}
--char effect
function CharFx(l, linetext, m) 
    text = linetext
	a = {}  
	for i = 1, unicode.len(text) do 
	    for alp in unicode.chars(text) do 
		    a[i] = alp  
		end 
		if text == "" 
			then  break 
		end 
		text = text:sub(1,-#a[i]-1)  
	end;   
	local text2 = "" 
	for z = 1,#a do 
	    ci = #a-z+1
		local sett = ""
		for i = 1,z do
		    if a[#a-i+1] == "{" 
			    then sett = sett .. "1"
			elseif a[#a-i+1] == "}"
                then sett = sett .. "2"
			else sett = sett .. ""	
			end
		end	
		local tpv = ""
		for i3 = 1,z do
			tpv = tpv .. a[#a-i3+1]
		end	
		tpv = tpv:gsub("{[^}]+}",""):gsub("\\N",""):gsub("\\h","")
		len = unicode.len
		local sett2 = sett:sub(-1)
		local ci2 = len(tpv)-1
		local maxt = len(linetext:gsub("{[^}]+}",""):gsub("\\N",""):gsub("\\h",""))	
		local maxpre, maxpost, maxpre2, maxpost2 = res.pret/maxt, res.postt/maxt, (res.pret/2)/maxt, (res.postt/2)/maxt
		local rsize, rcolor1, rcolor3, rcolor4, rbord, rshad, rblur, rdtime1, rdtime2 = 
		linetext:match("\\fs([^\\}]+)") or l.styleref.fontsize, 
		linetext:match("\\c([^\\}]+)") or l.styleref.color1, 
		linetext:match("\\3c([^\\}]+)") or l.styleref.color3, 
		linetext:match("\\4c([^\\}]+)") or l.styleref.color4, 
		linetext:match("\\bord([^\\}]+)") or l.styleref.outline, 
		linetext:match("\\shad([^\\}]+)") or l.styleref.shadow,
		linetext:match("\\blur([^\\}]+)") or 0,
		math.random(0,-200), math.random(100,-100)
		-- add start char tags
        if res.prefx == "Char"
            then chtags_pre = ("\\alpha&HFF&\\t(%d,%d,\\alpha&H00&)"):format(ci2*maxpre,ci2*maxpre+1)
		elseif res.prefx == "Char DHV"
            then chtags_pre = ("\\xshad35\\fscx1\\fscy1\\t(%d,%d,\\fscx100\\fscy100\\xshad0.5)"):format(ci2*maxpre,ci2*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade ->"
            then chtags_pre = ("\\alpha&HFF&\\t(%d,%d,\\alpha&H00&)"):format(ci2*maxpre,ci2*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade <-"
            then chtags_pre = ("\\alpha&HFF&\\t(%d,%d,\\alpha&H00&)"):format((maxt-ci2)*maxpre,(maxt-ci2)*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade <>"
            then chtags_pre = ("\\alpha&HFF&\\t(%d,%d,\\alpha&H00&)"):format(math.abs(maxt/2-ci2)*maxpre,math.abs(maxt/2-ci2)*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade ><"
            then chtags_pre = ("\\alpha&HFF&\\t(%d,%d,\\alpha&H00&)"):format((maxt/2-math.abs(maxt/2-ci2))*maxpre,(maxt/2-math.abs(maxt/2-ci2))*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade Random"
            then chtags_pre = ("\\alpha&HFF&\\t(%d,%d,\\alpha&H00&)"):format(res.pret/2+(rdtime1*(res.pret/2))/200,res.pret*1.5+(rdtime1*(res.pret/2))/200)
		elseif res.prefx == "Char Fog ->"
            then chtags_pre = ("\\alpha&HFF&\\bord%d\\blur%d\\t(%d,%d,\\alpha&H00&)\\t(%d,%d,\\bord%d\\blur%d)"):format(rsize/2,rsize/2,ci2*maxpre,ci2*maxpre+1,ci2*maxpre,ci2*maxpre+maxpre*10,rbord,rblur)
		elseif res.prefx == "Char Fog <-"
            then chtags_pre = ("\\alpha&HFF&\\bord%d\\blur%d\\t(%d,%d,\\alpha&H00&)\\t(%d,%d,\\bord%d\\blur%d)"):format(rsize/2,rsize/2,(maxt-ci2)*maxpre,(maxt-ci2)*maxpre+1,(maxt-ci2)*maxpre,(maxt-ci2)*maxpre+maxpre*10,rbord,rblur)
		elseif res.prefx == "Char Fog <>"
            then chtags_pre = ("\\alpha&HFF&\\bord%d\\blur%d\\t(%d,%d,\\alpha&H00&)\\t(%d,%d,\\bord%d\\blur%d)"):format(rsize/2,rsize/2,math.abs(maxt/2-ci2)*maxpre,math.abs(maxt/2-ci2)*maxpre+1,math.abs(maxt/2-ci2)*maxpre,math.abs(maxt/2-ci2)*maxpre+maxpre*10,rbord,rblur)
		elseif res.prefx == "Char Fog ><"
            then chtags_pre = ("\\alpha&HFF&\\bord%d\\blur%d\\t(%d,%d,\\alpha&H00&)\\t(%d,%d,\\bord%d\\blur%d)"):format(rsize/2,rsize/2,(maxt/2-math.abs(maxt/2-ci2))*maxpre,(maxt/2-math.abs(maxt/2-ci2))*maxpre+1,(maxt/2-math.abs(maxt/2-ci2))*maxpre,(maxt/2-math.abs(maxt/2-ci2))*maxpre+maxpre*10,rbord,rblur)
		elseif res.prefx == "Char Fog Random"
            then chtags_pre = ("\\alpha&HFF&\\bord%d\\blur%d\\t(%d,%d,\\alpha&H00&)\\t(%d,%d,\\bord%d\\blur%d)"):format(rsize/2,rsize/2,res.pret/2+(rdtime1*(res.pret/2))/200,res.pret*0.8+(rdtime1*(res.pret/2))/200,res.pret/2+(rdtime1*(res.pret/2))/200,res.pret*1.5+(rdtime1*(res.pret/2))/200,rbord,rblur)
		elseif res.prefx == "Char Fade -> move bottom to top"
            then chtags_pre = ("\\alpha&HFF&\\fsvp%d\\fsp%d\\t(%d,%d,\\alpha&H00&\\fsvp0\\fsp0)"):format(-rsize,rsize/2,ci2*maxpre,ci2*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade <- move bottom to top"
            then chtags_pre = ("\\alpha&HFF&\\fsvp%d\\fsp%d\\t(%d,%d,\\alpha&H00&\\fsvp0\\fsp0)"):format(-rsize,rsize/2,(maxt-ci2)*maxpre,(maxt-ci2)*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade <> move bottom to top"
            then chtags_pre = ("\\alpha&HFF&\\fsvp%d\\fsp%d\\t(%d,%d,\\alpha&H00&\\fsvp0\\fsp0)"):format(-rsize,rsize/2,math.abs(maxt/2-ci2)*maxpre,math.abs(maxt/2-ci2)*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade >< move bottom to top"
            then chtags_pre = ("\\alpha&HFF&\\fsvp%d\\fsp%d\\t(%d,%d,\\alpha&H00&\\fsvp0\\fsp0)"):format(-rsize,rsize/2,(maxt/2-math.abs(maxt/2-ci2))*maxpre,(maxt/2-math.abs(maxt/2-ci2))*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade Random move bottom to top"
            then chtags_pre = ("\\alpha&HFF&\\fsvp%d\\fsp%d\\t(%d,%d,\\alpha&H00&\\fsvp0\\fsp0)"):format(-rsize,rsize/2,res.pret/2+(rdtime1*(res.pret/2))/200,res.pret*1.5+(rdtime1*(res.pret/2))/200)
			elseif res.prefx == "Char Fade -> move top to bottom"
            then chtags_pre = ("\\alpha&HFF&\\fsvp%d\\fsp%d\\t(%d,%d,\\alpha&H00&\\fsvp0\\fsp0)"):format(rsize,rsize/2,ci2*maxpre,ci2*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade <- move top to bottom"
            then chtags_pre = ("\\alpha&HFF&\\fsvp%d\\fsp%d\\t(%d,%d,\\alpha&H00&\\fsvp0\\fsp0)"):format(rsize,rsize/2,(maxt-ci2)*maxpre,(maxt-ci2)*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade <> move top to bottom"
            then chtags_pre = ("\\alpha&HFF&\\fsvp%d\\fsp%d\\t(%d,%d,\\alpha&H00&\\fsvp0\\fsp0)"):format(rsize,rsize/2,math.abs(maxt/2-ci2)*maxpre,math.abs(maxt/2-ci2)*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade >< move top to bottom"
            then chtags_pre = ("\\alpha&HFF&\\fsvp%d\\fsp%d\\t(%d,%d,\\alpha&H00&\\fsvp0\\fsp0)"):format(rsize,rsize/2,(maxt/2-math.abs(maxt/2-ci2))*maxpre,(maxt/2-math.abs(maxt/2-ci2))*maxpre+maxpre*10)
		elseif res.prefx == "Char Fade Random move top to bottom"
            then chtags_pre = ("\\alpha&HFF&\\fsvp%d\\fsp%d\\t(%d,%d,\\alpha&H00&\\fsvp0\\fsp0)"):format(rsize,rsize/2,res.pret/2+(rdtime1*(res.pret/2))/200,res.pret*1.5+(rdtime1*(res.pret/2))/200)
		elseif res.prefx == "Char Turn"
            then chtags_pre = ("\\frs-45\\fscx1\\fscy1\\fsvp-20\\t(%d,%d,\\frs40\\fscx200\\fscy200\\fsvp20)\\t(%d,%d,\\frs0\\fscx100\\fscy100\\fsvp0)"):format(ci2*maxpre,ci2*maxpre+(maxpre*10)*0.5,ci2*maxpre+(maxpre*10)*0.5,ci2*maxpre+maxpre*10)
		elseif res.prefx == "Random Turn 1"
            then chtags_pre = ("\\frs%d\\fsvp%d\\alpha&HFF&\\t(%d,%d,\\frs0\\fsvp0\\alpha&H00&)"):format(math.random(-10,10),math.random(-40,50),ci2*maxpre,ci2*maxpre+maxpre*10)
		elseif res.prefx == "Random Turn 2"
            then chtags_pre = ("\\frs%d\\fsvp%d\\alpha&HFF&\\t(%d,%d,\\frs0\\fsvp0)\\t(%d,%d,\\alpha&H00&)"):format(math.random(-10,10),math.random(-40,50),ci2*maxpre,ci2*maxpre+maxpre*20,ci2*maxpre,ci2*maxpre+maxpre*10)
		else chtags_pre = ""
        end			
		-- add end char tags
        if res.postfx == "Char"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&"), ("\\t(%d,%d,\\alpha&HFF&)"):format((l.duration-maxpost*maxt)+ci2*maxpost-1,(l.duration-maxpost*maxt)+ci2*maxpost)
		elseif res.postfx == "Char Fade ->"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&"), ("\\t(%d,%d,\\alpha&HFF&)"):format((l.duration-maxpost*maxt)+ci2*maxpost-maxpost*10,(l.duration-maxpost*maxt)+ci2*maxpost)
		elseif res.postfx == "Char Fade <-"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&"), ("\\t(%d,%d,\\alpha&HFF&)"):format((l.duration-maxpost*maxt)+(maxt-ci2)*maxpost-maxpost*10,(l.duration-maxpost*maxt)+(maxt-ci2)*maxpost)
		elseif res.postfx == "Char Fade <>"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&"), ("\\t(%d,%d,\\alpha&HFF&)"):format((l.duration-maxpost*(maxt/2))+math.abs(maxt/2-ci2)*maxpost-maxpost*10,(l.duration-maxpost*(maxt/2))+math.abs(maxt/2-ci2)*maxpost)
		elseif res.postfx == "Char Fade ><"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&"), ("\\t(%d,%d,\\alpha&HFF&)"):format((l.duration-maxpost*(maxt/2))+(maxt/2-math.abs(maxt/2-ci2))*maxpost-maxpost*10,(l.duration-maxpost*(maxt/2))+(maxt/2-math.abs(maxt/2-ci2))*maxpost)
		elseif res.postfx == "Char Fade Random"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&"), ("\\t(%d,%d,\\alpha&HFF&)"):format(l.duration-res.pret*1.5+(rdtime1*(res.pret/2))/200,l.duration-res.pret*0.5+(rdtime1*(res.pret/2))/200)
		elseif res.postfx == "Char Fog ->"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\bord") and "" or "\\bord" .. rbord) .. (chtags_pre:match("\\blur") and "" or "\\blur" .. rblur), ("\\t(%d,%d,\\bord%d\\blur%d)\\t(%d,%d,\\alpha&HFF&)"):format((l.duration-maxpost*maxt)+ci2*maxpost-maxpost*10,(l.duration-maxpost*maxt)+ci2*maxpost,rsize/2,rsize/2,(l.duration-maxpost*maxt)+ci2*maxpost-1,(l.duration-maxpost*maxt)+ci2*maxpost)
		elseif res.postfx == "Char Fog <-"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\bord") and "" or "\\bord" .. rbord) .. (chtags_pre:match("\\blur") and "" or "\\blur" .. rblur), ("\\t(%d,%d,\\bord%d\\blur%d)\\t(%d,%d,\\alpha&HFF&)"):format((l.duration-maxpost*maxt)+(maxt-ci2)*maxpost-maxpost*10,(l.duration-maxpost*maxt)+(maxt-ci2)*maxpost,rsize/2,rsize/2,(l.duration-maxpost*maxt)+(maxt-ci2)*maxpost-1,(l.duration-maxpost*maxt)+(maxt-ci2)*maxpost)
		elseif res.postfx == "Char Fog <>"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\bord") and "" or "\\bord" .. rbord) .. (chtags_pre:match("\\blur") and "" or "\\blur" .. rblur), ("\\t(%d,%d,\\bord%d\\blur%d)\\t(%d,%d,\\alpha&HFF&)"):format((l.duration-maxpost*(maxt/2))+math.abs(maxt/2-ci2)*maxpost-maxpost*10,(l.duration-maxpost*(maxt/2))+math.abs(maxt/2-ci2)*maxpost,rsize/2,rsize/2,(l.duration-maxpost*(maxt/2))+math.abs(maxt/2-ci2)*maxpost-1,(l.duration-maxpost*(maxt/2))+math.abs(maxt/2-ci2)*maxpost)
		elseif res.postfx == "Char Fog ><"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\bord") and "" or "\\bord" .. rbord) .. (chtags_pre:match("\\blur") and "" or "\\blur" .. rblur), ("\\t(%d,%d,\\bord%d\\blur%d)\\t(%d,%d,\\alpha&HFF&)"):format((l.duration-maxpost*(maxt/2))+(maxt/2-math.abs(maxt/2-ci2))*maxpost-maxpost*10,(l.duration-maxpost*(maxt/2))+(maxt/2-math.abs(maxt/2-ci2))*maxpost,rsize/2,rsize/2,(l.duration-maxpost*(maxt/2))+(maxt/2-math.abs(maxt/2-ci2))*maxpost-1,(l.duration-maxpost*(maxt/2))+(maxt/2-math.abs(maxt/2-ci2))*maxpost)
		elseif res.postfx == "Char Fog Random"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\bord") and "" or "\\bord" .. rbord) .. (chtags_pre:match("\\blur") and "" or "\\blur" .. rblur), ("\\t(%d,%d,\\bord%d\\blur%d)\\t(%d,%d,\\alpha&HFF&)"):format(l.duration-res.pret*1.5+(rdtime1*(res.pret/2))/200,l.duration-res.pret*0.5+(rdtime1*(res.pret/2))/200,rsize/2,rsize/2,l.duration-res.pret*0.8+(rdtime1*(res.pret/2))/200,l.duration-res.pret*0.5+(rdtime1*(res.pret/2))/200)
		elseif res.postfx == "Char Fade -> move bottom to top"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\fsp") and "" or "\\fsp0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\fsvp%d\\fsp%d)"):format((l.duration-maxpost*maxt)+ci2*maxpost-maxpost*10,(l.duration-maxpost*maxt)+ci2*maxpost,rsize/2,rsize/2)
		elseif res.postfx == "Char Fade <- move bottom to top"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\fsp") and "" or "\\fsp0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\fsvp%d\\fsp%d)"):format((l.duration-maxpost*maxt)+(maxt-ci2)*maxpost-maxpost*10,(l.duration-maxpost*maxt)+(maxt-ci2)*maxpost,rsize/2,rsize/2)
		elseif res.postfx == "Char Fade <> move bottom to top"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\fsp") and "" or "\\fsp0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\fsvp%d\\fsp%d)"):format((l.duration-maxpost*(maxt/2))+math.abs(maxt/2-ci2)*maxpost-maxpost*10,(l.duration-maxpost*(maxt/2))+math.abs(maxt/2-ci2)*maxpost,rsize/2,rsize/2)
		elseif res.postfx == "Char Fade >< move bottom to top"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\fsp") and "" or "\\fsp0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\fsvp%d\\fsp%d)"):format((l.duration-maxpost*(maxt/2))+(maxt/2-math.abs(maxt/2-ci2))*maxpost-maxpost*10,(l.duration-maxpost*(maxt/2))+(maxt/2-math.abs(maxt/2-ci2))*maxpost,rsize/2,rsize/2)
		elseif res.postfx == "Char Fade Random move bottom to top"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\fsp") and "" or "\\fsp0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\fsvp%d\\fsp%d)"):format(l.duration-res.pret*1.5+(rdtime1*(res.pret/2))/200,l.duration-res.pret*0.5+(rdtime1*(res.pret/2))/200,rsize/2,rsize/2)
		elseif res.postfx == "Char Fade -> move top to bottom"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\fsp") and "" or "\\fsp0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\fsvp%d\\fsp%d)"):format((l.duration-maxpost*maxt)+ci2*maxpost-maxpost*10,(l.duration-maxpost*maxt)+ci2*maxpost,-rsize/2,rsize/2)
		elseif res.postfx == "Char Fade <- move top to bottom"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\fsp") and "" or "\\fsp0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\fsvp%d\\fsp%d)"):format((l.duration-maxpost*maxt)+(maxt-ci2)*maxpost-maxpost*10,(l.duration-maxpost*maxt)+(maxt-ci2)*maxpost,-rsize/2,rsize/2)
		elseif res.postfx == "Char Fade <> move top to bottom"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\fsp") and "" or "\\fsp0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\fsvp%d\\fsp%d)"):format((l.duration-maxpost*(maxt/2))+math.abs(maxt/2-ci2)*maxpost-maxpost*10,(l.duration-maxpost*(maxt/2))+math.abs(maxt/2-ci2)*maxpost,-rsize/2,rsize/2)
		elseif res.postfx == "Char Fade >< move top to bottom"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\fsp") and "" or "\\fsp0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\fsvp%d\\fsp%d)"):format((l.duration-maxpost*(maxt/2))+(maxt/2-math.abs(maxt/2-ci2))*maxpost-maxpost*10,(l.duration-maxpost*(maxt/2))+(maxt/2-math.abs(maxt/2-ci2))*maxpost,-rsize/2,rsize/2)
		elseif res.postfx == "Char Fade Random move top to bottom"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\fsp") and "" or "\\fsp0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\fsvp%d\\fsp%d)"):format(l.duration-res.pret*1.5+(rdtime1*(res.pret/2))/200,l.duration-res.pret*0.5+(rdtime1*(res.pret/2))/200,-rsize/2,rsize/2)
		elseif res.postfx == "Char Turn"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\frs") and "" or "\\frs0") .. (chtags_pre:match("\\fscx") and "" or "\\fscx100") .. (chtags_pre:match("\\fscy") and "" or "\\fscy100") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\frs40\\fscx200\\fscy200\\fsvp20)\\t(%d,%d,\\frs-45\\fscx1\\fscy1\\fsvp-20)"):format((l.duration-maxpost*maxt)+ci2*maxpost-maxpost*10,(l.duration-maxpost*maxt)+ci2*maxpost-maxpost*5,(l.duration-maxpost*maxt)+ci2*maxpost-maxpost*5,(l.duration-maxpost*maxt)+ci2*maxpost)
		elseif res.postfx == "Random Turn 1"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\frs") and "" or "\\frs0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&\\frs%d\\fsvp%d)"):format((l.duration-maxpost*maxt)+ci2*maxpost-maxpost*10,(l.duration-maxpost*maxt)+ci2*maxpost,math.random(-10,10),math.random(-40,50))
		elseif res.postfx == "Random Turn 2"
            then chtags_pre2, chtags_post = (chtags_pre:match("\\alpha") and "" or "\\alpha&H00&") .. (chtags_pre:match("\\frs") and "" or "\\frs0") .. (chtags_pre:match("\\fsvp") and "" or "\\fsvp0"), ("\\t(%d,%d,\\alpha&HFF&)\\t(%d,%d,\\frs%d\\fsvp%d)"):format((l.duration-maxpost*maxt)+ci2*maxpost-maxpost*10,(l.duration-maxpost*maxt)+ci2*maxpost,(l.duration-maxpost*maxt)+ci2*maxpost-maxpost*20,(l.duration-maxpost*maxt)+ci2*maxpost,math.random(-10,10),math.random(-40,50))
		else chtags_pre2, chtags_post = "", ""	
        end			
		--show char effect
	    if sett2 == "1" or a[ci] == "}" or a[ci+(ci >= #a and 0 or 1)] .. a[ci] == "\\N" or a[ci+(ci >= #a and 0 or 1)] .. a[ci] == "\\h"
            then text2 = text2 .. a[ci]
		else text2 = text2 .. '{\\st1' .. chtags_pre .. chtags_pre2 .. chtags_post .. '\\end1}' .. a[ci] 
		end
	end;
	return text2
end ;

function RunFx(subs,sel)
    meta, styles = karaskel.collect_head(subs, generate_furigana)
    for z,i in ipairs(sel) do
	aegisub.progress.task("Running "..z.."/"..#sel)
	line=subs[i]
	karaskel.preproc_line(subs, meta, styles, line) 
	if line.text:match("\\pos") 
	    then xx,yy=line.text:match("\\pos%(([%d%.%-]+),([%d%.%-]+)%)") 
	else xx,yy=line.center,line.middle
	end
	--line start effect
    if res.prefx == Allfx[1]
        then LineFx_pre = "}{"
    elseif res.prefx == Allfx[2]
        then LineFx_pre = "}{"
	elseif res.prefx == Allfx[3]
        then LineFx_pre = ("\\fscx1\\fscy1\\t(0,%d,\\fscx100\\fscy100)"):format(res.pret)
	elseif res.prefx == Allfx[4]
        then LineFx_pre = ("\\fscx250\\fscy250\\t(0,%d,\\fscx100\\fscy100)"):format(res.pret)
	elseif res.prefx == Allfx[5]
        then LineFx_pre = ("\\alpha&HFF&\\fscx1\\fscy1\\t(0,%d,\\fscx100\\fscy100\\alpha&H00&)"):format(res.pret)
	elseif res.prefx == Allfx[6]
        then LineFx_pre = ("\\alpha&HFF&\\fscx250\\fscy250\\t(0,%d,\\fscx100\\fscy100\\alpha&H00&)"):format(res.pret)
	elseif res.prefx == Allfx[7]
        then LineFx_pre = ("\\fscx1\\t(0,%d,\\fscx100)"):format(res.pret)
	elseif res.prefx == Allfx[8]
        then LineFx_pre = ("\\fscy1\\t(0,%d,\\fscy100)"):format(res.pret)
	elseif res.prefx == Allfx[9]
        then LineFx_pre = ("\\fscx250\\t(0,%d,\\fscx100)"):format(res.pret)
	elseif res.prefx == Allfx[10]
        then LineFx_pre = ("\\fscy250\\t(0,%d,\\fscy100)"):format(res.pret)
	elseif res.prefx == Allfx[11]
        then LineFx_pre = ("\\frx90\\t(0,%d,\\frx0)"):format(res.pret)
	elseif res.prefx == Allfx[12]
        then LineFx_pre = ("\\fry90\\t(0,%d,\\fry0)"):format(res.pret)
	elseif res.prefx == Allfx[13]
        then LineFx_pre = ("\\frz%d\\fscx1\\fscy1\\t(0,%d,\\frz0\\fscx100\\fscy100)"):format(res.pret,res.pret)
	elseif res.prefx == Allfx[14]
        then LineFx_pre = ("\\frx-90\\t(0,%d,\\frx0)"):format(res.pret)
	elseif res.prefx == Allfx[15]
        then LineFx_pre = ("\\fry-90\\t(0,%d,\\fry0)"):format(res.pret)
	elseif res.prefx == Allfx[16]
        then LineFx_pre = ("\\frz-%d\\fscx1\\fscy1\\t(0,%d,\\frz0\\fscx100\\fscy100)"):format(res.pret,res.pret)
	elseif res.prefx == Allfx[17]
        then LineFx_pre = ("\\alpha&HFF&\\fscx20\\fsp20\\fscy20\\t(0,%d,\\fscx150\\fsp-10\\fscy150\\alpha&H00&)\\t(%d,%d,\\fscx100\\fsp0\\fscy100)"):format(res.pret*0.6,res.pret*0.6,res.pret)
	elseif res.prefx == Allfx[18]
        then LineFx_pre = ("\\alpha&HFF&\\fscx200\\fsp-10\\fscy200\\t(0,%d,\\fscx50\\fsp20\\fscy50\\alpha&H00&)\\t(%d,%d,\\fscx100\\fsp0\\fscy100)"):format(res.pret*0.6,res.pret*0.6,res.pret)
	else LineFx_pre = ""	
    end
	--line end effect
    if res.postfx == Allfx[1]
        then LineFx_post = "}{"
    elseif res.postfx == Allfx[2]
        then LineFx_post = "}{"
	elseif res.postfx == Allfx[3]
        then LineFx_post = ("\\t(%d,%d,\\fscx250\\fscy250)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[4]
        then LineFx_post = ("\\t(%d,%d,\\fscx1\\fscy1)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[5]
        then LineFx_post = ("\\t(%d,%d,\\fscx250\\fscy250\\alpha&HFF&)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[6]
        then LineFx_post = ("\\t(%d,%d,\\fscx1\\fscy1\\alpha&HFF&)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[7]
        then LineFx_post = ("\\t(%d,%d,\\fscx250)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[8]
        then LineFx_post = ("\\t(%d,%d,\\fscy250)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[9]
        then LineFx_post = ("\\t(%d,%d,\\fscx1)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[10]
        then LineFx_post = ("\\t(%d,%d,\\fscy1)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[11]
        then LineFx_post = ("\\t(%d,%d,\\frx-90)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[12]
        then LineFx_post = ("\\t(%d,%d,\\fry-90)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[13]
        then LineFx_post = ("\\t(%d,%d,\\frz-%d\\fscx1\\fscy1"):format(line.duration-res.postt,line.duration,res.postt)
	elseif res.postfx == Allfx[14]
        then LineFx_post = ("\\t(%d,%d,\\frx90)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[15]
        then LineFx_post = ("\\t(%d,%d,\\fry90)"):format(line.duration-res.postt,line.duration)
	elseif res.postfx == Allfx[16]
        then LineFx_post = ("\\t(%d,%d,\\frz%d\\fscx1\\fscy1)"):format(line.duration-res.postt,line.duration,res.postt)
	elseif res.postfx == Allfx[17]
        then LineFx_post = ("\\t(%d,%d,\\fscx50\\fsp20\\fscy50)\\t(%d,%d,\\fscx200\\fsp-10\\fscy200\\alpha&HFF&)"):format(line.duration-res.postt,line.duration-res.postt*0.4,line.duration-res.postt*0.4,line.duration)
	elseif res.postfx == Allfx[18]
        then LineFx_post = ("\\t(%d,%d,\\fscx200\\fsp-10\\fscy200)\\t(%d,%d,\\fscx50\\fsp20\\fscy50\\alpha&HFF&)"):format(line.duration-res.postt,line.duration-res.postt*0.4,line.duration-res.postt*0.4,line.duration)
	else LineFx_post = ""	
    end
	local stripText = line.text:gsub("\\st1([^}*]+)\\end1",""):gsub("\\st2([^}*]+)\\end2",""):gsub("{}","")
	
	if res.prefx == "Fade" and res.postfx ~= "Fade" then antags = ("\\fad(%d,0)"):format(res.pret) 
	elseif res.prefx == "Fade" and res.postfx == "Fade" then antags = ("\\fad(%d,%d)"):format(res.pret,res.postt)
    elseif res.postfx == "Fade"	then antags = ("\\fad(0,%d)"):format(res.postt)
	else antags = "" end
	if LineFx_post ~= "" and LineFx_pre ~= "" then showtext = stripText else showtext = CharFx(line,stripText,meta) end
	if res.prefx == Allfx[1] and res.postfx == Allfx[1] then fxname = "" else fxname = ("name[%s;%s;%d;%d]"):format(res.prefx,res.postfx,res.pret,res.postt) end
	rltags = (antags .. LineFx_pre .. LineFx_post):gsub("}{","")
	if rltags ~= "" then rltags = "{\\st2" .. rltags .. "\\end2}" end
	local text = ("%s%s"):format(rltags,showtext)
	text = text:gsub("(\\r[^\\}]+)","%1\\st2"..LineFx_pre..LineFx_post.."\\end2")
	text = text:gsub("}{","")
	line.effect = fxname
	line.text = text
	subs[i]=line
    end
end

function BC(subs,sel)
    for _, i in ipairs(sel) do
        local line = subs[i]
        stname, endname, sttime, endtime = line.effect:match("name%[([^\\*]+);([^\\*]+);([^\\*]+);([^\\*]+)%]")
        subs[i] = line
    end
    
	menu = {
    {x = 0, y = 0, width = 8, height = 1, class = "label", label = "Code by Cmy - 草莓Dâu Tây"}, 
	{x = 0, y = 1, width = 2, height = 1, class = "label", label = "Start."}, 
	{x = 2, y = 1, width = 7, height = 1, class = "dropdown", name = "prefx", items = Allfx, value = stname or Allfx[1], hint = "chọn hiệu ứng xuất hiện"}, 
	{x = 9, y = 1, width = 1, height = 1, class = "intedit", name = "pret", value = (sttime or 400), min = 0, hint = "nhập thời gian xuất hiện"}, 
	{x = 0, y = 2, width = 2, height = 1, class = "label", label = "End."}, 
	{x = 2, y = 2, width = 7, height = 1, class = "dropdown", name = "postfx", items = Allfx, value = endname or Allfx[1], hint = "chọn hiệu ứng kết thúc"}, 
	{x = 9, y = 2, width = 1, height = 1, class = "intedit", name = "postt", value = (endtime or 400), min = 0, hint = "nhập thời gian kết thúc"},
}
	P,res=ADD(menu)
	fr2ms=aegisub.ms_from_frame
	ms2fr=aegisub.frame_from_ms
	faded=true
	if P then RunFx(subs,sel) 
	end
end

function apply_fx(subs,sel)
    ADD=aegisub.dialog.display
    ADP=aegisub.decode_path
    ak=aegisub.cancel
    BC(subs,sel)
    aegisub.set_undo_point(script_name)
    return sel
end

if haveDepCtrl then depRec:registerMacro(apply_fx) else aegisub.register_macro(script_name,script_description,apply_fx) end