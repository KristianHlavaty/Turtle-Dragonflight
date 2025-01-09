local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
  title = T["Turtle Dragonflight (default)"],
  description = T["Turtle Dragonflight Unitframes. Uncheck this if you want to use the other Unit Frame options."],
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = T["Unit Frames"],
  enabled = true,
})

local addonpath
local tocs = { "", "-master", "-tbc", "-wotlk" }
for _, name in pairs(tocs) do
  local current = string.format("ShaguTweaks%s", name)
  local _, title = GetAddOnInfo(current)
  if title then
    addonpath = "Interface\\AddOns\\" .. current
    break
  end
end

module.enable = function(self)
--abbrev Names
function abbreviateName(name)
  if name and string.len(name) > 16 then
      return string.sub(name, 1, 13) .. "..."
  elseif name then
      return name
  else
      return "No target"
  end
end
--end abbrev

-- DF Texture

--Player Frame
PlayerFrameTexture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\new-unitframes\\UI-TargetingFrameDF.blp")
PlayerStatusTexture:SetTexture[[Interface\Addons\Turtle-Dragonflight\img\UI-Player-Status]]
PlayerFrameHealthBar:SetWidth(130)
PlayerFrameHealthBar:SetHeight(30)
PlayerFrameManaBar:SetWidth(125)
PlayerFrameHealthBar:SetPoint("TOPLEFT", 100, -29)
PlayerFrameManaBar:SetPoint("TOPLEFT", 103, -53)
PlayerStatusTexture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\UI-Player-Status")
PlayerFrameHealthBar:SetStatusBarTexture([[Interface\Addons\Turtle-Dragonflight\img\new-unitframes\healthDF2.tga]])               
PlayerFrameManaBar:SetStatusBarTexture([[Interface\Addons\Turtle-Dragonflight\img\Unitframe\UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Status.tga]])
--Player Frame Background Texture
PlayerFrameBackground:SetWidth(256)
PlayerFrameBackground:SetHeight(128)
PlayerFrameBackground:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\new-unitframes\\UI-TargetingFrameDF-Background.blp")
PlayerFrameBackground:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 0, 0)

--Move playername
local playerName = PlayerFrame.name
-- Adjust the position of the name text
playerName:ClearAllPoints()
playerName:SetPoint("CENTER", PlayerFrame, "CENTER", 22, 25)
-- Move player level text
local playerLevelText = PlayerLevelText
-- Adjust the position of the level text
playerLevelText:ClearAllPoints()
playerLevelText:SetPoint("CENTER", PlayerFrame, "CENTER", 102, 25)
--Resize Player portrait
local playerPortrait = PlayerFrame.portrait
playerPortrait:SetHeight(62)
playerPortrait:SetWidth(62)

--[[
------------------------RESTED NON-ANIMATION ------------------------
-- Create a frame for the overlay if it doesn't already exist
PlayerRestIcon:SetTexture("")
PlayerRestIcon:ClearAllPoints()
PlayerRestIcon:SetPoint("TOPLEFT", PlayerFrame, -3000, 0)
local overlay = CreateFrame("Frame", "overlay", UIParent)
overlay:SetHeight(64)
overlay:SetWidth(64)
overlay:SetPoint("CENTER", PlayerFrame, "CENTER", -20, 30) -- Position the NEW RESTED icon

-- Create a texture for the overlay
local overlayTexture = overlay:CreateTexture(nil, "BACKGROUND")
overlayTexture:SetAllPoints(overlay)
overlayTexture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\Unitframe\\flipbookrested.tga")
overlayTexture:SetTexCoord(100/512, 120/512, 34/64, 57/64)

-- Show the overlay when the player is in a rested zone
overlay:RegisterEvent("PLAYER_UPDATE_RESTING")
overlay:SetScript("OnEvent", function(self, event)
    if IsResting() then
        this:Show()
    else
        this:Hide()
    end
end)
------------------------RESTED------------------------
]]

-----Reskins the zzz-----
-- Create a new frame
--local overlay = CreateFrame("Frame", nil, PlayerRestIcon:GetParent())
local overlay = CreateFrame("Frame", "overlay", UIParent)
overlay:SetWidth(24)
overlay:SetHeight(24)
overlay:SetPoint("CENTER", PlayerFrame, "CENTER", -20, 30) -- Position the NEW RESTED icon

--remove the original blizzard zzz
PlayerRestIcon:SetTexture("")
PlayerRestIcon:ClearAllPoints()
PlayerRestIcon:SetPoint("TOPLEFT", PlayerFrame, -3000, 0)

-- Set the frame strata to be higher than PlayerRestIcon
--overlay:SetFrameStrata("DIALOG")

-- Set the size and position of the overlay to match PlayerRestIcon
--overlay:SetWidth(PlayerRestIcon:GetWidth())
--overlay:SetHeight(PlayerRestIcon:GetHeight())
--overlay:SetPoint("CENTER", PlayerRestIcon, "CENTER")

-- Set the texture for the overlay
overlay.texture = overlay:CreateTexture()
overlay.texture:SetAllPoints()
overlay.texture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\Unitframe\\UIUnitFrameRestingFlipbook.tga")
--overlay.texture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\Unitframe\\flipbookrested-animation.tga")
overlay.texture:SetTexCoord(0/512, 60/512, 0/512, 60/512)
-----Reskins the zzz-----

----------------ANIMATION----------------
-- Define the TexCoords for each frame of the animation
local texCoords = {
  --x changes by 60 y changes by 60
  -- (1)512 (x)    x    512 (y)      (2)512 (x)    x    512 (y)      (3)512 (x)    x    512 (y)       (4)512 (x)    x    512 (y)       (5)512 (x)    x    512 (y)       (6)512 (x)    x    512 (y)
  {0/512, 60/512, 0/512, 60/512}, {60/512, 120/512, 0/512, 60/512}, {120/512, 180/512, 0/512, 60/512}, {180/512, 240/512, 0/512, 60/512}, {240/512, 300/512, 0/512, 60/512}, {300/512, 360/512, 0/512, 60/512}, --z
  {0/512, 60/512, 60/512,120/512}, {60/512, 120/512, 60/512, 120/512}, {120/512, 180/512, 60/512, 120/512}, {180/512, 240/512, 60/512, 120/512}, {240/512, 300/512, 60/512, 120/512}, {300/512, 360/512, 60/512, 120/512}, --zz
  {0/512, 60/512, 120/512, 180/512}, {60/512, 120/512, 120/512, 180/512}, {120/512, 180/512, 120/512, 180/512}, {180/512, 240/512, 120/512, 180/512}, {240/512, 300/512, 120/512, 180/512}, {300/512, 360/512, 120/512, 180/512}, --zz
  {0/512, 60/512, 180/512, 240/512}, {60/512, 120/512, 180/512, 240/512}, {120/512, 180/512, 180/512, 240/512}, {180/512, 240/512, 180/512, 240/512}, {240/512, 300/512, 180/512, 240/512}, {300/512, 360/512, 180/512, 240/512}, --zzz
  {0/512, 60/512, 240/512, 300/512}, {60/512, 120/512, 240/512, 300/512}, {120/512, 180/512, 240/512, 300/512}, {180/512, 240/512, 240/512, 300/512}, {240/512, 300/512, 240/512, 300/512}, {300/512, 360/512, 240/512, 300/512}, --zzz
  {0/512, 60/512, 300/512, 360/512}, {60/512, 120/512, 300/512, 360/512}, {120/512, 180/512, 300/512, 360/512}, {180/512, 240/512, 300/512, 360/512}, {240/512, 300/512, 300/512, 360/512}, {300/512, 360/512, 300/512, 360/512}, --zzz
  --{0/512, 60/512, 360/512, 410/512}, {60/512, 120/512, 360/512, 410/512}, {120/512, 180/512, 360/512, 410/512}, {180/512, 240/512, 360/512, 410/512}, {240/512, 300/512, 360/512, 410/512}, {300/512, 360/512, 360/512, 410/512}, --zzz

}
--[[
-- Define the TexCoords for each frame of the animation
local texCoords = {
  -- 512 is the x, 64 is the y
  {100/512, 120/512, 34/64, 57/64}, --z
  {163/512, 200/512, 19/64, 57/64}, --zz
  {227/512, 280/512, 4/64, 57/64}, --zzz
  {302/512, 344/512, 3/64, 46/64}, --zz
  {379/512, 408/512, 3/64, 36/64}, --z

}
]]

-- Function to update the texture coordinates
local currentFrame = 1
local function UpdateTexCoords()
  local coords = texCoords[currentFrame]
  overlay.texture:SetTexCoord(unpack(coords))
  currentFrame = currentFrame + 1
  if currentFrame > table.getn(texCoords) then
      currentFrame = 1
  end
end

-- OnUpdate script to change the TexCoords every 0.1 seconds
local timeSinceLastUpdate = 0
local updateInterval = .05 -- .1 default - Adjust this to change the speed of the animation
overlay:SetScript("OnUpdate", function(self, elapsed)
  local elapsed = arg1 or 0
  timeSinceLastUpdate = timeSinceLastUpdate + elapsed
  if timeSinceLastUpdate > updateInterval then
      timeSinceLastUpdate = 0
      UpdateTexCoords()
  end
end)
----------------ANIMATION----------------

----------------SHOW/HIDE ANIMATION----------------
overlay:Hide()

-- Function to check and update the resting state
local function UpdateRestingState()
    if IsResting() then
        overlay:Show()
    else
        overlay:Hide()
    end
end

-- Register the event
overlay:RegisterEvent("PLAYER_UPDATE_RESTING")
overlay:RegisterEvent("PLAYER_ENTERING_WORLD") -- Add this event to check on login
overlay:SetScript("OnEvent", UpdateRestingState)

-- Initial check when the addon is loaded
UpdateRestingState()

----------------SHOW/HIDE ANIMATION----------------

--Target Frame
TargetFrameTexture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\new-unitframes\\UI-TargetingFrameDF1.blp")
TargetFrameHealthBar:SetPoint("TOPRIGHT", -100, -29)
TargetFrameHealthBar:SetWidth(130)
TargetFrameHealthBar:SetHeight(31)
TargetFrameHealthBar:SetStatusBarTexture([[Interface\Addons\Turtle-Dragonflight\img\new-unitframes\healthDF2.tga]]) 
TargetFrameManaBar:SetPoint("TOPRIGHT", -95, -53)
TargetFrameManaBar:SetWidth(132)
TargetFrameManaBar:SetStatusBarTexture([[Interface\Addons\Turtle-Dragonflight\img\Unitframe\UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Status.blp]])
--Target Frame Background Texture
TargetFrameBackground:SetWidth(256)
TargetFrameBackground:SetHeight(128)
TargetFrameBackground:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\new-unitframes\\UI-TargetingFrameDF1-Background.blp")
TargetFrameBackground:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", 0, 0)

-- Move Target level text
local targetLevelText = TargetLevelText
-- Adjust the position of the level text
targetLevelText:ClearAllPoints()
targetLevelText:SetPoint("CENTER", TargetFrame, "CENTER", -106, 25)
  --Move Targetname
local targetName = TargetFrame.name
-- Adjust the position of the name text
targetName:ClearAllPoints()
targetName:SetPoint("CENTER", targetLevelText, "CENTER", 60, 0)

--Resize Target portrait
local targetPortrait = TargetFrame.portrait
targetPortrait:SetHeight(61)
targetPortrait:SetWidth(61)

--DF Texture ends

--PLAYERS TARGETS ALL GREEN
-- enable class color backgrounds
local original = TargetFrame_CheckFaction
function TargetFrame_CheckFaction(self)
  original(self)

  local reaction = UnitReaction("target", "player")

  if UnitIsPlayer("target") then
    local _, class = UnitClass("target")
    local class = { r = 0, g = 1, b = 0, a = 1 }
    TargetFrameNameBackground:SetVertexColor(class.r, class.g, class.b, 1)
    TargetFrameNameBackground:Show()
  elseif reaction and reaction > 4 then
    TargetFrameNameBackground:Hide()
  else
    TargetFrameNameBackground:Show()
  end
end
local _, class = UnitClass("player")
local class = { r = 0, g = 1, b = 0, a = 1 }
--END PLAYER TARGETS ALL GREEN

--DF Pet
-- Hook the PetFrame_Update function
  local new_PetFrame_Update = PetFrame_Update
  local new_PetFrame = PetFrame
  PetFrame_Update = function()
    -- Call the original function
    new_PetFrame_Update()
    PetFrameTexture:SetTexture("Interface\\Addons\\Turtle-Dragonflight\\img\\pet")
    PetFrameTexture:SetDrawLayer("BACKGROUND") -- Set the draw layer of the texture
    PetFrame:ClearAllPoints()
    PetFrame:SetPoint("BOTTOM", PlayerFrame, -10, -30)
    -- Change the frame strata of the HealthBar and ManaBar

    --PetFrameHealthBar:SetFrameStrata("MEDIUM")
    PetFrameHealthBar:SetStatusBarTexture([[Interface\Addons\Turtle-Dragonflight\img\Unitframe\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health]])
      -- Adjust the position of the PetFrameHealthBar
    PetFrameHealthBar:SetHeight(13)
    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint("CENTER", PetFrame, "CENTER", 15, 3)
    --PetFrameManaBar:SetFrameStrata("MEDIUM")
    local class = UnitClass("player")
    if class == "Hunter" then
      PetFrameManaBar:SetStatusBarTexture([[Interface\Addons\Turtle-Dragonflight\img\Unitframe\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Focus]])
    else
      PetFrameManaBar:SetStatusBarTexture([[Interface\Addons\Turtle-Dragonflight\img\Unitframe\UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Mana]])
    end
    -- Adjust the position of the PetFrameManaBar
    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint("CENTER", PetFrame, "CENTER", 15, -7)
    -- Adjust the position of the PetName
    PetName:ClearAllPoints()
    PetName:SetPoint("CENTER", PetFrame, "CENTER", 5, 16)
  end 
--DF Pet ends

local original = TargetFrame_CheckClassification
function TargetFrame_CheckClassification()
  local classification = UnitClassification("target")
  if ( classification == "worldboss" ) then
    TargetFrameTexture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\new-unitframes\\UI-TargetingFrame-Boss.blp")
  elseif ( classification == "rareelite"  ) then
    TargetFrameTexture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\new-unitframes\\UI-TargetingFrame-RareElite.blp")
  elseif ( classification == "elite"  ) then
    TargetFrameTexture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\new-unitframes\\UI-TargetingFrame-Elite.blp")
  elseif ( classification == "rare"  ) then
    TargetFrameTexture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\new-unitframes\\UI-TargetingFrame-Rare.blp")
  else
    TargetFrameTexture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\new-unitframes\\UI-TargetingFrameDF1.blp")
    --TargetFrameTexture:SetTexture("Interface\\AddOns\\Turtle-Dragonflight\\img\\UI-TargetingFrame2")
  end
end

local wait = CreateFrame("Frame")
wait:RegisterEvent("PLAYER_ENTERING_WORLD")
wait:SetScript("OnEvent", function()
  if ShaguTweaks.DarkMode then
    PlayerFrameTexture:SetVertexColor(.3,.3,.3,.9)
    TargetFrameTexture:SetVertexColor(.3,.3,.3,.9)
  end

-- adjust healthbar colors to frame colors
local original = TargetFrame_CheckFaction
  function TargetFrame_CheckFaction(self)
    original(self)

    if TargetFrameHealthBar._SetStatusBarColor then
      local r, g, b, a = TargetFrameNameBackground:GetVertexColor()
      TargetFrameHealthBar:_SetStatusBarColor(r, g, b, a)
    end
  end
end)

  -- delay to first draw
  wait:SetScript("OnUpdate", function()
    -- move text strings a bit higher
    if PlayerFrameHealthBar.TextString then
      PlayerFrameHealthBar.TextString:SetPoint("TOP", PlayerFrameHealthBar, "BOTTOM", 0, 32)
    end

    if TargetFrameHealthBar.TextString then
      TargetFrameHealthBar.TextString:SetPoint("TOP", TargetFrameHealthBar, "BOTTOM", 2, 32)
    end

    -- use class color for player (if enabled)
    if PlayerFrameNameBackground then
      -- disable vanilla ui color restore functions
      PlayerFrameHealthBar._SetStatusBarColor = PlayerFrameHealthBar.SetStatusBarColor
      PlayerFrameHealthBar.SetStatusBarColor = function() return end

      -- set player healthbar to class color
      local r, g, b, a = PlayerFrameNameBackground:GetVertexColor()
      PlayerFrameHealthBar:_SetStatusBarColor(r, g, b, a)

      -- hide status textures
      PlayerFrameNameBackground:Hide()
      PlayerFrameNameBackground.Show = function() return end
    end

    -- use frame color for target frame
    if TargetFrameNameBackground then
      -- disable vanilla ui color restore functions
      TargetFrameHealthBar._SetStatusBarColor = TargetFrameHealthBar.SetStatusBarColor
      TargetFrameHealthBar.SetStatusBarColor = function() return end

      -- hide status textures
      TargetFrameNameBackground.Show = function() return end
      TargetFrameNameBackground:Hide()
    end

    TargetFrame_CheckFaction(PlayerFrame)
    wait:UnregisterAllEvents()
    wait:Hide()

  -- Party space fix with pet
  if PetFrame:IsVisible() then
    if PartyMemberFrame1:IsVisible() then
      --PartyMemberFrame1:ClearAllPoints()
      --PartyMemberFrame1:SetPoint("TOPLEFT", UIParent, 30, -150)
    else
      --print("partyMember1 does not exist")
    end
  else
      --PartyMemberFrame1:ClearAllPoints()
      --PartyMemberFrame1:SetPoint("TOPLEFT", UIParent, 30, -150)
  end

  end)
end