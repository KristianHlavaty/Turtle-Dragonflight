local _G = tDFUI.GetGlobalEnv()
local T = tDFUI.T

local module = tDFUI:register({
  title = T["Movable Unit Frames Extended"],
  description = T["mufe_desc"],
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = T["Unit Frames"],
  enabled = true,
})

local movables = { 
  "PartyMemberFrame1",
  "PartyMemberFrame2",
  "PartyMemberFrame3",
  "PartyMemberFrame4"
}

local nonmovables = {
  -- "tDFmicrobutton", -- Removed - doesn't support movable API properly
  "MyCustomMinimap", -- minimap
  "tDFbagMain", -- bags bar
  "BuffButton0", -- buffrow1
  "BuffButton8", -- buffrow2
  "BuffButton16", -- debuffs
  "TempEnchant1", -- weapon buffs
  "xpbar",
  "tDFquestwatchframe",
  "tDFDurability",
  "MiniMapMailFrame",
  "repbar"
}

module.enable = function(self)
  tDFUI_config = tDFUI_config or {}
  tDFUI_config["MoveUnitframesExtended"] = tDFUI_config["MoveUnitframesExtended"] or {}
  local movedb = tDFUI_config["MoveUnitframesExtended"]

  local unlocker = CreateFrame("Frame", nil, UIParent)
  unlocker:SetAllPoints(UIParent)
  unlocker.movable = nil

  -- Function to safely get a frame
  local function GetFrameSafely(frameName)
    if not frameName or frameName == "" then return nil end
    return _G[frameName]
  end

  -- Function to safely check if frame supports SetUserPlaced
  local function SupportsUserPlaced(frame)
    return frame.SetUserPlaced ~= nil
  end

  -- Function to make a frame movable
  local function MakeMovable(frame, frameName)
    if not frame then return end
    
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function() this:StartMoving() end)
    frame:SetScript("OnDragStop", function() 
      this:StopMovingOrSizing()
      -- Only call SetUserPlaced if the frame supports it
      if SupportsUserPlaced(this) then
        this:SetUserPlaced(true)
      end
    end)
  end

  -- Function to save frame position
  local function SavePosition(frame, frameName)
    if not frame then return end
    
    local left = frame:GetLeft()
    local top = frame:GetTop()
    
    if left and top then
      local name = frame:GetName() or frameName
      if name then
        movedb[name] = {left, top}
        -- Debug output
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Saved position for " .. name .. " at " .. left .. ", " .. top)
      end
    end
  end

  -- Function to disable movability
  local function DisableMovable(frame, frameName)
    if not frame then return end
    
    frame:SetScript("OnDragStart", function() end)
    frame:SetScript("OnDragStop", function() end)
    frame:StopMovingOrSizing()
    
    -- Save position when disabling movement mode
    SavePosition(frame, frameName)
  end

  -- Special handling for minimap
  local function HandleMinimap(enable)
    local minimap = GetFrameSafely("MyCustomMinimap")
    if not minimap then return end
    
    if enable then
      minimap:SetMovable(true)
      minimap:EnableMouse(true)
      minimap:RegisterForDrag("LeftButton")
      minimap:SetScript("OnDragStart", function() this:StartMoving() end)
      minimap:SetScript("OnDragStop", function() 
        this:StopMovingOrSizing()
        -- Only call SetUserPlaced if the frame supports it
        if SupportsUserPlaced(this) then
          this:SetUserPlaced(true)
        end
      end)
    else
      minimap:SetScript("OnDragStart", function() end)
      minimap:SetScript("OnDragStop", function() end)
      minimap:StopMovingOrSizing()
      
      -- Save minimap position
      SavePosition(minimap, "MyCustomMinimap")
    end
  end

  unlocker:SetScript("OnUpdate", function()
    if IsShiftKeyDown() and IsControlKeyDown() then
      if not unlocker.movable then
        -- Make party frames movable
        for _, frameName in pairs(movables) do
          local frame = GetFrameSafely(frameName)
          if frame then
            -- Only call SetUserPlaced if the frame supports it
            if SupportsUserPlaced(frame) then
              frame:SetUserPlaced(true)
            end
            MakeMovable(frame, frameName)
          end
        end

        -- Make other frames movable
        for _, frameName in pairs(nonmovables) do
          if frameName == "MyCustomMinimap" then
            HandleMinimap(true)
          else
            local frame = GetFrameSafely(frameName)
            if frame then
              MakeMovable(frame, frameName)
            end
          end
        end

        unlocker.movable = true
        if unlocker.grid then
          unlocker.grid:Show()
        end
      end
    elseif unlocker.movable then
      -- Disable movability for party frames
      for _, frameName in pairs(movables) do
        local frame = GetFrameSafely(frameName)
        if frame then
          DisableMovable(frame, frameName)
        end
      end

      -- Disable movability for other frames
      for _, frameName in pairs(nonmovables) do
        if frameName == "MyCustomMinimap" then
          HandleMinimap(false)
        else
          local frame = GetFrameSafely(frameName)
          if frame then
            DisableMovable(frame, frameName)
          end
        end
      end

      unlocker.movable = nil
      if unlocker.grid then
        unlocker.grid:Hide()
      end
    end
  end)

  -- Create the grid
  unlocker.grid = CreateFrame("Frame", nil, WorldFrame)
  unlocker.grid:SetAllPoints(WorldFrame)
  unlocker.grid:Hide()

  local size = 1
  local line = {}

  local width = GetScreenWidth()
  local height = GetScreenHeight()

  local ratio = width / GetScreenHeight()
  local rheight = GetScreenHeight() * ratio

  local wStep = width / 64
  local hStep = rheight / 64

  -- vertical lines
  for i = 0, 64 do
    if i == 64 / 2 then
      line = unlocker.grid:CreateTexture(nil, 'BORDER')
      line:SetTexture(.8, .6, 0)
    else
      line = unlocker.grid:CreateTexture(nil, 'BACKGROUND')
      line:SetTexture(0, 0, 0, .2)
    end
    line:SetPoint("TOPLEFT", unlocker.grid, "TOPLEFT", i*wStep - (size/2), 0)
    line:SetPoint('BOTTOMRIGHT', unlocker.grid, 'BOTTOMLEFT', i*wStep + (size/2), 0)
  end

  -- horizontal lines
  for i = 1, floor(height/hStep) do
    if i == floor(height/hStep / 2) then
      line = unlocker.grid:CreateTexture(nil, 'BORDER')
      line:SetTexture(.8, .6, 0)
    else
      line = unlocker.grid:CreateTexture(nil, 'BACKGROUND')
      line:SetTexture(0, 0, 0, .2)
    end

    line:SetPoint("TOPLEFT", unlocker.grid, "TOPLEFT", 0, -(i*hStep) + (size/2))
    line:SetPoint('BOTTOMRIGHT', unlocker.grid, 'TOPRIGHT', 0, -(i*hStep + size/2))
  end

  -- Function to restore positions with error handling
  local function RestorePositions()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Attempting to restore positions...")
    
    for _, frameName in pairs(nonmovables) do
      -- Wrap each frame restoration in pcall to prevent errors from stopping the process
      local success, errorMsg = pcall(function()
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Checking frame: " .. frameName)
        
        local frame = GetFrameSafely(frameName)
        if frame then
          local name = frame:GetName() or frameName
          DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Frame exists, name: " .. (name or "nil"))
          
          if name and movedb[name] then
            local savedPos = movedb[name]
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Found saved position: " .. (savedPos[1] or "nil") .. ", " .. (savedPos[2] or "nil"))
            
            if savedPos and savedPos[1] and savedPos[2] then
              DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Applying position to " .. name)
              frame:ClearAllPoints()
              frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", savedPos[1], savedPos[2])
              
              -- Only call SetUserPlaced if the frame supports it, with extra safety
              if frameName ~= "MyCustomMinimap" and SupportsUserPlaced(frame) then
                local userPlacedSuccess = pcall(function() frame:SetUserPlaced(true) end)
                if not userPlacedSuccess then
                  DEFAULT_CHAT_FRAME:AddMessage("|cffff0000tDF Debug:|r SetUserPlaced failed for " .. name .. ", but continuing...")
                end
              end
              
              DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Successfully restored " .. name .. " to " .. savedPos[1] .. ", " .. savedPos[2])
            end
          else
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r No saved position for " .. (name or frameName))
          end
        else
          DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Frame not found: " .. frameName)
        end
      end)
      
      if not success then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000tDF Debug:|r Error restoring " .. frameName .. ": " .. (errorMsg or "unknown error") .. " - continuing with other frames...")
      end
    end
  end
  
  -- Restore positions with multiple delays to ensure proper timing
  local restoreFrame = CreateFrame("Frame")
  restoreFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  restoreFrame:SetScript("OnEvent", function()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r PLAYER_ENTERING_WORLD - starting restore sequence")
    
    -- First immediate restore
    RestorePositions()
    
    -- Delayed restore after 1 frame
    CreateFrame("Frame"):SetScript("OnUpdate", function()
      DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r First delayed restore")
      RestorePositions()
      this:SetScript("OnUpdate", nil)
    end)
    
    -- Additional delayed restore after addon loading is complete
    local finalRestore = CreateFrame("Frame")
    finalRestore.timer = GetTime() + 3 -- Wait 3 seconds for all frames to be created
    finalRestore:SetScript("OnUpdate", function()
      if GetTime() > this.timer then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Final delayed restore (3 seconds)")
        RestorePositions()
        this:SetScript("OnUpdate", nil)
      end
    end)

    -- Extra restore specifically for buff buttons that might be created even later
    local buffRestore = CreateFrame("Frame")
    buffRestore.timer = GetTime() + 5 -- Wait 5 seconds
    buffRestore:SetScript("OnUpdate", function()
      if GetTime() > this.timer then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Buff-specific restore (5 seconds)")
        -- Only restore buff buttons
        local buffFrames = {"BuffButton0", "BuffButton8", "BuffButton16", "TempEnchant1"}
        for _, frameName in pairs(buffFrames) do
          local success, errorMsg = pcall(function()
            local frame = GetFrameSafely(frameName)
            if frame then
              local name = frame:GetName() or frameName
              if name and movedb[name] then
                local savedPos = movedb[name]
                if savedPos and savedPos[1] and savedPos[2] then
                  DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Late restoring " .. name .. " to " .. savedPos[1] .. ", " .. savedPos[2])
                  frame:ClearAllPoints()
                  frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", savedPos[1], savedPos[2])
                  if SupportsUserPlaced(frame) then
                    pcall(function() frame:SetUserPlaced(true) end)
                  end
                end
              end
            end
          end)
          if not success then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000tDF Debug:|r Late restore error for " .. frameName .. ": " .. (errorMsg or "unknown"))
          end
        end
        this:SetScript("OnUpdate", nil)
      end
    end)
    
    this:UnregisterEvent("PLAYER_ENTERING_WORLD")
  end)

  -- Debug command to check saved positions
  SLASH_TDFDEBUG1 = "/tdfdebug"
  SlashCmdList["TDFDEBUG"] = function(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Saved positions:")
    for name, pos in pairs(movedb) do
      if pos and pos[1] and pos[2] then
        DEFAULT_CHAT_FRAME:AddMessage("  " .. name .. ": " .. pos[1] .. ", " .. pos[2])
      end
    end
  end

  -- Debug command to manually restore positions
  SLASH_TDFREST1 = "/tdfrestore" 
  SlashCmdList["TDFREST"] = function(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Manual restore triggered")
    RestorePositions()
  end

  -- Debug command to check buff button existence
  SLASH_TDFCHECK1 = "/tdfcheck"
  SlashCmdList["TDFCHECK"] = function(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Checking buff button frames...")
    local buffFrames = {"BuffButton0", "BuffButton8", "BuffButton16", "TempEnchant1"}
    for _, frameName in pairs(buffFrames) do
      local frame = GetFrameSafely(frameName)
      if frame then
        local name = frame:GetName() or frameName
        local left, top = frame:GetLeft(), frame:GetTop()
        DEFAULT_CHAT_FRAME:AddMessage("  " .. frameName .. " -> " .. (name or "nil") .. " at " .. (left or "nil") .. ", " .. (top or "nil"))
        if movedb[name] then
          DEFAULT_CHAT_FRAME:AddMessage("    Has saved position: " .. (movedb[name][1] or "nil") .. ", " .. (movedb[name][2] or "nil"))
        else
          DEFAULT_CHAT_FRAME:AddMessage("    No saved position")
        end
      else
        DEFAULT_CHAT_FRAME:AddMessage("  " .. frameName .. " -> NOT FOUND")
      end
    end
  end

  -- Debug command to force save current positions
  SLASH_TDFSAVE1 = "/tdfsave"
  SlashCmdList["TDFSAVE"] = function(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00tDF Debug:|r Manual save triggered")
    for _, frameName in pairs(nonmovables) do
      local frame = GetFrameSafely(frameName)
      if frame then
        SavePosition(frame, frameName)
      end
    end
  end
end