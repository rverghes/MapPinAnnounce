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
	local unit, message = MA.FindUnitAndMessage(msg)
	local announcement = MA.CreateAnnouncement(unit, message)
	if announcement then
		SendChatMessage(announcement, "CHANNEL", nil, 1)
	end
end

function MA.FindUnitAndMessage(msg)
	local unit, defaultMessage = MA.FindUnitAndDefaultMessage()
	if string.len(msg) > 0 then
		return unit, msg
	else
		return unit, defaultMessage
	end
end

function MA.FindUnitAndDefaultMessage()
	if UnitExists("target") then
		local targetMessage = UnitName("target")
		return "target", targetMessage
	else
		local playerMessage = "My location"
		return "player", playerMessage
	end
end

function MA.CreateAnnouncement(unit, message)
	local uiMapPoint = MA.GetUnitPosition(unit)
	if uiMapPoint then
		C_Map.SetUserWaypoint(uiMapPoint)
		local hyperlink = C_Map.GetUserWaypointHyperlink()
		local x = uiMapPoint.position.x*100
		local y = uiMapPoint.position.y*100
		local coordText = string.format("(%d,%d)", x, y)
		local announcement = message .. " - " .. hyperlink .. " - " .. coordText
		return announcement
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
