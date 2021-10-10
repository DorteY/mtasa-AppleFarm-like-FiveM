--//-----------------------------------------------\\
--||   Project      : Applefarm like GTAV FiveM
--||   Author       : DORTEY#5702
--\\-----------------------------------------------//

X,Y=guiGetScreenSize();
Gsx=X/1920;
Gsy=Y/1080;


addEvent("Render->Job->UI",true)
addEventHandler("Render->Job->UI",root,function(typ,amount)
	FarmItem=typ;
	FarmAmount=amount;
	
	addEventHandler("onClientRender",root,renderAmount)
	setTimer(function()
		removeEventHandler("onClientRender",root,renderAmount)
	end,2*1000,1)
end)

function renderAmount()
	dxDrawText("+"..FarmAmount.." "..FarmItem,2100*Gsx,1040*Gsy,1588*Gsx,30*Gsy,tocolor(255,255,225,255),2.2*Gsx,"default-bold","center",_,_,_,false,_,_)
end