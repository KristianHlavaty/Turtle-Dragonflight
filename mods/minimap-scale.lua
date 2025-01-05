local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Bigger Minimap"],
    description = T["Bigger Minimap"],
    expansions = { ["vanilla"] = true, ["tbc"] = true },
    category = T["World & MiniMap"],
    enabled = nil,
})

ShaguTweaks_config = ShaguTweaks_config or {}

module.enable = function(self)
    local tMinimap = Minimap
    local scaletMiniMap = 1.75
    local scaletMinimapZoomInOut = 1.35

    MyCustomMinimap:SetWidth(150*scaletMiniMap)
    MyCustomMinimap:SetHeight(150*scaletMiniMap)

    tMinimap:SetWidth(131*scaletMiniMap)
    tMinimap:SetHeight(131*scaletMiniMap)

    BorderFrameForZoneText:SetWidth(151*scaletMiniMap)
    BorderFrameForZoneText:SetHeight(34)
    BorderFrameForZoneText:SetPoint("CENTER", MyCustomMinimap, 0, 135)

    MinimapZoneText:SetPoint("LEFT", BorderFrameForZoneText, "LEFT", 7, 7)    

    MiniMapMailFrame:SetPoint("TOPRIGHT", tMinimap, "TOPRIGHT", -200, -200)

    if ShaguTweaks_config["MiniMap Square"] == 0 then
        tMinimapZoomIn:SetPoint("TOPRIGHT", MinimapZoneText, "TOPLEFT", 165*scaletMinimapZoomInOut, -170*scaletMinimapZoomInOut)
        tMinimapZoomOut:SetPoint("TOPRIGHT", MinimapZoneText, "TOPLEFT", 150*scaletMinimapZoomInOut, -182*scaletMinimapZoomInOut)
    else
        tMinimapZoomIn:SetPoint("TOPRIGHT", MinimapZoneText, "TOPLEFT", 175*scaletMinimapZoomInOut, -210*scaletMinimapZoomInOut)
        tMinimapZoomOut:SetPoint("TOPRIGHT", MinimapZoneText, "TOPLEFT", 160*scaletMinimapZoomInOut, -210*scaletMinimapZoomInOut)
    end

    MinimapClock:SetPoint("TOPRIGHT", Minimap, 25, 42)
end