--------------------------------
-- MapPin Announce
--
-- Creates a Map Pin and then announces it in a chat channel
--
-- Author: Rohan Verghese
-- Email: rverghes@gmail.com
--------------------------------
local ADDON_NAME,MapPinAnnounce = ...
local MA = MapPinAnnounce

-- Slash commands
SLASH_MapPinAnnounce1 = '/pin'
function SlashCmdList.MapPinAnnounce(msg, editbox)
	if UnitExists("target") then
		MA.AnnouncePinForTarget()
	else
		MA.AnnouncePinForPlayer()
	end
end

function MA.AnnouncePinForTarget()
	local uiMapPoint = MA.GetUnitPosition("target")
	if uiMapPoint then
		C_Map.SetUserWaypoint(uiMapPoint)
		local targetName = UnitName("target")
		local hyperlink = C_Map.GetUserWaypointHyperlink()
		local x = uiMapPoint.position.x*100
		local y = uiMapPoint.position.y*100
		local coordText = string.format("(%d,%d)", x, y)
		local announcement = targetName .. " - " .. hyperlink .. " - " .. coordText
		print(announcement)
	end
end

function MA.AnnouncePinForPlayer()
	local uiMapPoint = MA.GetUnitPosition("player")
	if uiMapPoint then
		C_Map.SetUserWaypoint(uiMapPoint)
		local hyperlink = C_Map.GetUserWaypointHyperlink()
		print("[MapPinAnnounce] "..hyperlink)
	end
end

function MA.GetUnitPosition(unitId)
	local uiMapID = C_Map.GetBestMapForUnit("player")
	if uiMapID then
		local position = C_Map.GetPlayerMapPosition(uiMapID, "player")
		if position then
			local uiMapPoint = UiMapPoint.CreateFromVector2D(uiMapID, position)
			return uiMapPoint
		end
	end
end
