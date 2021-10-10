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

local function startFarm(player)
	if(FarmStatusTable[player]==nil)then
		outputChatBox("[JOB]: Press 'E' to stop farming!",player,0,200,0);
		FarmTable[player]=setTimer(function()
			AppleAmount=math.random(1,3);
			
			setPedAnimation(player,"BOMBER","BOM_Plant_Loop")
			givePlayerMoney(player,AppleAmount);----change this to your  value example: setElementData(player,"Apple",getElementData(player,"Apple")+AppleAmount)
			triggerClientEvent(player,"Render->Job->UI",player,"Apple",AppleAmount);
		end,FarmTimer*1000,0);
		FarmStatusTable[player]=true;
		setElementFrozen(player,true);
	elseif(FarmStatusTable[player]==true)then
		outputChatBox("[JOB]: Farming stopped!",player,200,0,0);
		setElementFrozen(player,false);
		setPedAnimation(player);
		if(isTimer(FarmTable[player]))then
			killTimer(FarmTable[player]);
			FarmTable[player]=nil;
			FarmStatusTable[player]=nil;
		end
	end
end

addEventHandler("onResourceStart",resourceRoot,function()
	--Create Marker at start
	for i,v in ipairs(Marker)do
		Marker[i]=createMarker(v[1],v[2],v[3],v[4],v[5],v[6],v[7],v[8],v[9]);
		
		setElementInterior(Marker[i],v[10]);
		setElementDimension(Marker[i],v[11]);
		
		addEventHandler("onMarkerHit",Marker[i],function(player,dim)
			if(not(isPedInVehicle(player)))then
				if(getElementInterior(player)==v[10] and getElementDimension(player)==v[11])then
					outputChatBox("[JOB]: Press 'E' to farm Apple's",player,200,0,0);
					if(isTimer(FarmTable[player]))then
						killTimer(FarmTable[player]);
						FarmTable[player]=nil;
						FarmStatusTable[player]=nil;
					end
					setPedAnimation(player);
					if(not isKeyBound(player,"E","down",startFarm))then
						bindKey(player,"E","down",startFarm);
					end
				end
			end
		end)
		addEventHandler("onMarkerLeave",Marker[i],function(player,dim)
			if(isTimer(FarmTable[player]))then
				killTimer(FarmTable[player]);
				FarmTable[player]=nil;
				FarmStatusTable[player]=nil;
				outputChatBox("[JOB]: Farming stopped!",player,200,0,0);
			end
			setPedAnimation(player);
			if(isKeyBound(player,"E","down",startFarm))then
				unbindKey(player,"E","down",startFarm);
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