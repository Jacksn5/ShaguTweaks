local module = ShaguTweaks:register({
    title = "Restyle UI",
    description = "Restyles supported addons and the minimap. Changes fonts for units, buffs, buttons & chat.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    local _G = ShaguTweaks.GetGlobalEnv()

    local function addons()
        --[[
            Supported Addons:
            SP_SwingTimer
        ]]

        if IsAddOnLoaded("SP_SwingTimer") then
            local o,e,i = 2,10,4
            local f = CreateFrame("Frame", nil, SP_ST_Frame)
            f:SetPoint("TOPLEFT", f:GetParent(), "TOPLEFT", -o, o)
            f:SetPoint("BOTTOMRIGHT", f:GetParent(), "BOTTOMRIGHT", o, -o)
            f:SetBackdrop({
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                edgeSize = e,
                insets = { left = i, right = i, top = i, bottom = i },
            })

            local f = CreateFrame("Frame", nil, SP_ST_FrameOFF)
            f:SetPoint("TOPLEFT", f:GetParent(), "TOPLEFT", -o, o)
            f:SetPoint("BOTTOMRIGHT", f:GetParent(), "BOTTOMRIGHT", o, -o)
            f:SetBackdrop({
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                edgeSize = e,
                insets = { left = i, right = i, top = i, bottom = i },
            })
        end
    end

    local function buffs()
        -- Buff font
        local font, size, outline = "Fonts\\FRIZQT__.TTF", 9, "OUTLINE"
        local yoffset = -5
        local f = CreateFrame("Frame", nil, GryllsMinimap)
        f:SetFrameStrata("HIGH")

        local function buffText(buffButton)
            -- remove spaces from buff durations
            local duration = getglobal(buffButton:GetName().."Duration");
            local durationtext = duration:GetText()
            if durationtext ~= nil then
                local timer = string.gsub(durationtext, "%s+", "")
                duration:SetText(timer)
            end
        end

        for i = 0, 2 do
            for _, v in pairs(
                    {
                    _G['TempEnchant'..i..'Duration'],
                }
            ) do
                local b = _G['TempEnchant'..i]
                v:SetFont(font, size, outline)
                v:ClearAllPoints()
                v:SetPoint("CENTER", b, "BOTTOM", 0, yoffset)
                v:SetParent(f)            

                local f = CreateFrame("Frame", nil, b)
                f:SetScript("OnUpdate", function()
                    buffText(b)
                end)
            end
        end

        for i = 0, 23 do
            for _, v in pairs(
                    {
                    _G['BuffButton'..i..'Duration'],
                }
            ) do
                local b = _G['BuffButton'..i]
                v:SetFont(font, size, outline)
                v:ClearAllPoints()
                v:SetPoint("CENTER", b, "BOTTOM", 0, yoffset)
                v:SetParent(f)            

                local f = CreateFrame("Frame", nil, b)
                f:SetScript("OnUpdate", function()
                    buffText(b)
                end)
            end
        end
    end

    local function buttons()
        local function restyle(button)
            if not button then return end        

            local hotkey = _G[button:GetName().."HotKey"]
            if hotkey then
                local font, size, outline = "Fonts\\frizqt__.TTF", 12, "OUTLINE"
                hotkey:SetFont(font, size, outline)
            end

            local macro = _G[button:GetName().."Name"]  
            if macro then
                local font, size, outline = "Fonts\\skurri.TTF", 12, "OUTLINE"
                macro:SetFont(font, size, outline)   
            end

            local count = _G[button:GetName()..'Count']
            if count then
                local font, size, outline = "Fonts\\frizqt__.TTF", 14, "OUTLINE"
                count:SetFont(font, size, outline)   
            end

        end
        
        for i = 1, 24 do
            local button = _G['BonusActionButton'..i]
            if button then
                restyle(button)
            end
        end

        for i = 1, 12 do
            for _, button in pairs(
                    {
                    _G['ActionButton'..i],
                    _G['MultiBarRightButton'..i],
                    _G['MultiBarLeftButton'..i],
                    _G['MultiBarBottomLeftButton'..i],
                    _G['MultiBarBottomRightButton'..i],
                }
            ) do
                restyle(button)
            end        
        end 

        for i = 1, 10 do
            for _, button in pairs(
                {
                    _G['ShapeshiftButton'..i],
                    _G['PetActionButton'..i]
                }
            ) do
                restyle(button)
            end
        end
    end

    local function minimap()
        -- Move minimap elements
        local styleFrame = CreateFrame("Frame", nil, MinimapCluster)
        styleFrame:SetPoint("CENTER", Minimap, "BOTTOM")
        styleFrame:SetHeight(16)
        styleFrame:SetWidth(Minimap:GetWidth())

        -- Zone Text
        MinimapZoneText:ClearAllPoints()
        MinimapZoneText:SetPoint("TOP", Minimap, 0, 13)
        MinimapZoneText:SetFont("Fonts\\skurri.TTF", 14, "OUTLINE")
        MinimapZoneText:SetDrawLayer("OVERLAY", 7)        
        MinimapZoneText:SetParent(styleFrame)

        local function removeBackdrop(frame)
            frame:SetBackdropBorderColor(0,0,0,0)
            frame:SetBackdropColor(0,0,0,0)
        end

        local function lock(frame)
            frame.ClearAllPoints = function() end
            frame.SetAllPoints = function() end
            frame.SetPoint = function() end
            -- frame.SetWidth = function() end
            -- feame.SetHeight = function() end
            -- feame.SetScale = function() end            
        end

        -- ShaguTweaks clock
        if MinimapClock then
            -- removeBackdrop(MinimapClock)
            MinimapClock:ClearAllPoints()
            MinimapClock:SetPoint("CENTER", styleFrame, "CENTER", -1, 0)
            -- lock(MinimapClock)
        end

        -- ShaguTweaks-Mods timer
        if MinimapTimer then
            -- removeBackdrop(MinimapTimer)
            MinimapTimer:ClearAllPoints()
            MinimapTimer:SetPoint("TOP", styleFrame, "BOTTOM")
        end

        -- ShaguTweaks-Mods fps
        if MinimapFPS then
            -- removeBackdrop(MinimapFPS)
            MinimapFPS:ClearAllPoints()
            MinimapFPS:SetPoint("LEFT", styleFrame, "LEFT")
        end

        -- ShaguTweaks-Mods ms
        if MinimapMS then
            -- removeBackdrop(MinimapMS)
            MinimapMS:ClearAllPoints()
            MinimapMS:SetPoint("RIGHT", styleFrame, "RIGHT")
        end

        if Minimap.border then -- if using square minimap
            -- Tracking
            MiniMapTrackingFrame:ClearAllPoints()
            MiniMapTrackingFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -2, 1)
            MiniMapTrackingFrame:SetScale(0.9)
            MiniMapTrackingBorder:SetTexture(nil)

            -- Mail
            MiniMapMailFrame:ClearAllPoints()
            MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 4, 2)
            MiniMapMailFrame:SetScale(1.2)
            MiniMapMailBorder:SetTexture(nil)

            -- PVP
            MiniMapBattlefieldFrame:ClearAllPoints()
            MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, 8)
        end

        -- MinimapButtonFrame    
        if MBB_MinimapButtonFrame then
            -- reposition MBB to the bottom of the styleFrame (under the minimap)
            -- show the button OnEnter and hide when OnLeave
            
            if IsAddOnLoaded("MinimapButtonBag-TurtleWoW") then
                MBB_MinimapButtonFrame_Texture:SetTexture("Interface\\Icons\\Inv_misc_bag_10_green")
            else
                MBB_MinimapButtonFrame_Texture:SetTexture("Interface\\Icons\\Inv_misc_bag_10")
            end            

            MBB_MinimapButtonFrame:ClearAllPoints()
            MBB_MinimapButtonFrame:SetPoint("CENTER", Minimap, "BOTTOMLEFT", 0, 0)
            lock(MBB_MinimapButtonFrame)           
            
            local function showButton(button)
                button:SetAlpha(1)
            end

            local function hideButton(button)
                button:SetAlpha(0)  
            end            

            hideButton(MBB_MinimapButtonFrame)
            local hide = CreateFrame("BUTTON", nil, MBB_MinimapButtonFrame)
            hide:SetAllPoints(hide:GetParent())

            hide:SetScript("OnEnter", function()
                showButton(MBB_MinimapButtonFrame)
            end)

            hide:SetScript("OnLeave", function()
                hide.timer = GetTime() + 6
                hide:SetScript("OnUpdate", function()            
                    if (GetTime() > hide.timer) then
                        MBB_HideButtons() -- MBB function to hide buttons
                        hideButton(MBB_MinimapButtonFrame)
                        hide:SetScript("OnUpdate", nil)
                    end
                end)
            end)
            
            hide:RegisterForClicks("LeftButtonDown","RightButtonDown")
            hide:SetScript("OnClick", function()
                MBB_OnClick(arg1)
            end)
        end
    end

    local function names()
        local function nameFont(name)
            local font, size, outline = "Fonts\\frizqt__.TTF", 12, "OUTLINE"
            name:SetFont(font, size, outline)
        end

        nameFont(PlayerFrame.name)
        nameFont(PetName)
        nameFont(TargetFrame.name)
        nameFont(TargetofTargetName)
        nameFont(PartyMemberFrame1.name)
        nameFont(PartyMemberFrame2.name)
        nameFont(PartyMemberFrame3.name)
        nameFont(PartyMemberFrame4.name)
        nameFont(PartyMemberFrame1PetFrame.name)
        nameFont(PartyMemberFrame2PetFrame.name)
        nameFont(PartyMemberFrame3PetFrame.name)
        nameFont(PartyMemberFrame4PetFrame.name)
    end

    local function font()
        local chatframes = { ChatFrame1, ChatFrame2, ChatFrame3 }

        for _, chatframe in pairs(chatframes) do
            local _, size = chatframe:GetFont()
            local font = "Fonts\\frizqt__.TTF"
            chatframe:SetFont(font, size-2)
        end
    end

    local events = CreateFrame("Frame", nil, UIParent)	
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        addons()
        buffs()
        buttons()
        minimap()
        names()
        font()
    end)
end
