--//-----------------------------------------------\\
--||   Project      : Applefarm like GTAV FiveM
--||   Author       : DORTEY#5702
--\\-----------------------------------------------//

local FarmTable={}
local FarmStatusTable={}
local FarmTimer=5;

local Marker={
	--x,y,z,type,size,r,g,b,a,int,dim
	{-648.2,-2098,27,"cylinder",4,200,0,0,120,0,0},
}
local Blips={
	--x,y,z,blipID,blipSIZE,R,G,B
	{-648.2,-2098,27,0,3,200,0,0},
}

local function startFarm(elem)
	if(elem and isElement(elem)and getElementType(elem)=="player")then
		if(getElementDimension(elem)==0 and getElementInterior(elem)==0)then
			if(FarmStatusTable[elem]==nil)then
				outputChatBox("[JOB]: Press 'E' to stop farming!",elem,0,200,0);
				FarmTable[elem]=setTimer(function()
					if(getElementType(elem)=="player")then
						AppleAmount=math.random(1,3);
						
						setPedAnimation(elem,"BOMBER","BOM_Plant_Loop")
						givePlayerMoney(elem,AppleAmount);----change this to your  value example: setElementData(player,"Apple",getElementData(player,"Apple")+AppleAmount)
						triggerClientEvent(elem,"Render->Job->UI",elem,"Apple",AppleAmount);
					end
				end,FarmTimer*1000,0);
				FarmStatusTable[elem]=true;
				setElementFrozen(elem,true);
			elseif(FarmStatusTable[elem]==true)then
				outputChatBox("[JOB]: Farming stopped!",elem,200,0,0);
				setElementFrozen(elem,false);
				setPedAnimation(elem);
				if(isTimer(FarmTable[elem]))then
					killTimer(FarmTable[elem]);
					FarmTable[elem]=nil;
					FarmStatusTable[elem]=nil;
				end
			end
		end
	end
end

addEventHandler("onResourceStart",resourceRoot,function()
	--Create Marker at start
	for i,v in ipairs(Marker)do
		Marker[i]=createMarker(v[1],v[2],v[3],v[4],v[5],v[6],v[7],v[8],v[9]);
		
		setElementInterior(Marker[i],v[10]);
		setElementDimension(Marker[i],v[11]);
		
		addEventHandler("onMarkerHit",Marker[i],function(elem,dim)
			if(elem and isElement(elem)and getElementType(elem)=="player")then
				if(not(isPedInVehicle(elem)))then
					if(getElementInterior(elem)==v[10] and getElementDimension(elem)==v[11])then
						outputChatBox("[JOB]: Press 'E' to farm Apple's",elem,200,0,0);
						if(isTimer(FarmTable[elem]))then
							killTimer(FarmTable[elem]);
							FarmTable[elem]=nil;
							FarmStatusTable[elem]=nil;
						end
						setPedAnimation(elem);
						if(not isKeyBound(elem,"E","down",startFarm))then
							bindKey(elem,"E","down",startFarm);
						end
					end
				end
			end
		end)
		addEventHandler("onMarkerLeave",Marker[i],function(elem,dim)
			if(isTimer(FarmTable[elem]))then
				killTimer(FarmTable[elem]);
				FarmTable[elem]=nil;
				FarmStatusTable[elem]=nil;
				outputChatBox("[JOB]: Farming stopped!",elem,200,0,0);
			end
			setPedAnimation(elem);
			if(isKeyBound(elem,"E","down",startFarm))then
				unbindKey(elem,"E","down",startFarm);
			end
		end)
	end
	
	--Create Blips at start
	for i,v in ipairs(Blips)do
		Blips[i]=createBlip(v[1],v[2],v[3],v[4],v[5],v[6],v[7],v[8]);
	end
end)


local function destroyElementsAfterQuitDead(player)
	if(isTimer(FarmTable[player]))then
		killTimer(FarmTable[player]);
		FarmTable[player]=nil;
		FarmStatusTable[player]=nil;
	end
end
addEventHandler("onPlayerQuit",root,function()
	destroyElementsAfterQuitDead(source);
end)
addEventHandler("onPlayerWasted",root,function()
	destroyElementsAfterQuitDead(source);
end)