--------------------------------
-- MapPin Announce
--
-- Creates a Map Pin and then announces it in the General chat channel
--
-- Author: Rohan Verghese
-- Email: rverghes@gmail.com
--------------------------------
local ADDON_NAME,MapPinAnnounce = ...
local MA = MapPinAnnounce
local GENERAL_CHANNEL = 1

-- Slash commands
SLASH_MapPinAnnounce1 = '/pin'
function SlashCmdList.MapPinAnnounce(msg, editbox)
	local uiMapPoint = MA.FindMapPoint()
	local message = MA.FindMessage(msg)
	local announcement = MA.CreateWaypointAndAnnouncement(uiMapPoint, message)
	if announcement then
		SendChatMessage(announcement, "CHANNEL", nil, GENERAL_CHANNEL)
	end
end

-- Map functions only work for the player
function MA.FindMapPoint()
	local uiMapID = C_Map.GetBestMapForUnit("player")
	if uiMapID then
		local position = C_Map.GetPlayerMapPosition(uiMapID, "player")
		if position then
			local uiMapPoint = UiMapPoint.CreateFromVector2D(uiMapID, position)
			return uiMapPoint
		end
	end
end

function MA.FindMessage(msg)
	if string.len(msg) > 0 then
		return msg
	elseif UnitExists("target") then
		return UnitName("target")
	else
		return "My location"
	end
end

function MA.CreateWaypointAndAnnouncement(uiMapPoint, message)
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

