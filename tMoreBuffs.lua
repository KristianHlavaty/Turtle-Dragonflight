local lOriginal_TargetDebuffButton_Update = nil;
local TARGETFRAMEBUFF_MAX_TARGET_DEBUFFS = 16;
local TARGETFRAMEBUFF_MAX_TARGET_BUFFS = 16;

-- configurable sizing helpers
local function tdf_get_config(key, default)
    if tDFUI_config and tDFUI_config[key] ~= nil then
        return tDFUI_config[key]
    end
    return default
end

local function tdf_target_aura_settings()
    local size = tdf_get_config("Target Aura Size", 21)
    local spacing = tdf_get_config("Target Aura Spacing", 3)
    local vspacing = tdf_get_config("Target Aura V Spacing", 2)
    local border = size + 2
    return size, border, spacing, vspacing
end


-- hook original update-function
function TargetFrameBuff_OnLoad()
	lOriginal_TargetDebuffButton_Update	= TargetDebuffButton_Update;
	TargetDebuffButton_Update = TargetFrameBuff_Update;
	
	lOriginal_TargetDebuffButton_Update()
	TargetFrameBuff_Restore();
end


-- use extended update-function (original code from FrameXML/TargetFrame.lua)
function TargetFrameBuff_Update()
	
	local num_buff = 0;
	local num_debuff = 0;
	local button, buff;
	for i=1, TARGETFRAMEBUFF_MAX_TARGET_BUFFS do
		buff = UnitBuff("target", i);
		button = getglobal("TargetFrameBuff"..i);
		if (buff) then
			getglobal("TargetFrameBuff"..i.."Icon"):SetTexture(buff);
			button:Show();
			button.id = i;
			num_buff = i;
		else
			button:Hide();
		end
	end

	local debuff, debuffApplication, debuffCount;
	for i=1, TARGETFRAMEBUFF_MAX_TARGET_DEBUFFS do
		debuff, debuffApplications = UnitDebuff("target", i);
		button = getglobal("TargetFrameDebuff"..i);
		if (debuff) then
			debuffCount = getglobal("TargetFrameDebuff"..i.."Count");
			if (debuffApplications > 1) then
				debuffCount:SetText(debuffApplications);
				debuffCount:Show();
			else
				debuffCount:Hide();
			end
			getglobal("TargetFrameDebuff"..i.."Icon"):SetTexture(debuff);
			button:Show();
			button.id = i;
			num_debuff = i;
		else
			button:Hide();
		end
	end
	
	-- Position buffs depending on whether the targeted unit is friendly or not
	local _, _, hspacing, vspacing = tdf_target_aura_settings()
	if (UnitIsFriend("player", "target")) then
		TargetFrameBuff1:ClearAllPoints();
		TargetFrameBuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32);
		TargetFrameDebuff1:ClearAllPoints();
		TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrameBuff"..TargetFrameBuff_Anchor(num_buff), "BOTTOMLEFT", 0, -vspacing);
	else
		TargetFrameDebuff1:ClearAllPoints();
		TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32);
		TargetFrameBuff1:ClearAllPoints();
		TargetFrameBuff1:SetPoint("TOPLEFT", "TargetFrameDebuff"..TargetFrameBuff_Anchor(num_debuff), "BOTTOMLEFT", 0, -vspacing);
	end

end


function TargetFrameBuff_Anchor(num)
	if (num > 5) then
		return 6;
	end
	return 1;
end


function TargetFrameBuff_Restore()
	local size, border, hspacing, vspacing = tdf_target_aura_settings()
	TargetFrameDebuff6:ClearAllPoints();
	TargetFrameDebuff6:SetPoint("TOPLEFT", "TargetFrameDebuff1", "BOTTOMLEFT", 0, -vspacing);
	TargetFrameDebuff7:ClearAllPoints();
	TargetFrameDebuff7:SetPoint("LEFT", "TargetFrameDebuff6", "RIGHT", hspacing, 0);
	TargetFrameDebuff11:ClearAllPoints();
	TargetFrameDebuff11:SetPoint("LEFT", "TargetFrameDebuff10", "RIGHT", hspacing, 0);

	-- Resize debuffs to configured size
	local button, debuffFrame;
	for i=1, TARGETFRAMEBUFF_MAX_TARGET_DEBUFFS do
		button = getglobal("TargetFrameDebuff"..i);
		debuffFrame = getglobal("TargetFrameDebuff"..i.."Border");
		if button then
			button:SetWidth(size);
			button:SetHeight(size);
		end
		if debuffFrame then
			debuffFrame:SetWidth(border);
			debuffFrame:SetHeight(border);
		end
		if i > 1 and button then
			local prev = getglobal("TargetFrameDebuff"..(i-1))
			button:ClearAllPoints()
			if i == 6 or i == 11 then
				button:SetPoint("TOPLEFT", getglobal("TargetFrameDebuff"..(i == 6 and 1 or 6)), "BOTTOMLEFT", 0, -vspacing)
			else
				button:SetPoint("LEFT", prev, "RIGHT", hspacing, 0)
			end
		end
	end

	-- Resize buffs to configured size
	for i=1, TARGETFRAMEBUFF_MAX_TARGET_BUFFS do
		local b = getglobal("TargetFrameBuff"..i)
		if b then
			b:SetWidth(size)
			b:SetHeight(size)
		end
	end
end

-- In-UI resizing: Hold CTRL and use mouse wheel over the TargetFrame to resize target auras
function tDFUI.ApplyTargetAuraSize()
	-- refresh sizes/anchors
	TargetFrameBuff_Restore()
	TargetFrameBuff_Update()
end

-- Mouse wheel resizing removed to avoid interfering with scrolling; use DF Options sliders instead