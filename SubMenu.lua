function ToggleSubMenu()
    if SubMenu then
        if SubMenu:IsShown() then
            SubMenu:Hide()  -- Hide the main UI frame
        else
            SubMenu:Show()  -- Show the main UI frame

            -- Get the cursor's current position
            local cursorX, cursorY = GetCursorPosition()

            -- Convert the cursor position from screen to UI scale
            local scale = UIParent:GetScale()
            cursorX, cursorY = cursorX / scale, cursorY / scale

            -- Position the SubMenu below the cursor
            SubMenu:ClearAllPoints()  -- Clear any previous anchors
            SubMenu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", cursorX - 30, cursorY - 30)  -- Adjust as needed

            -- Define the OnClick handler for all buttons
            local function ButtonClickTest(buttonName)
                
                if buttonName == "DKPUIButton" then
                    if DKPUI:IsShown() then
                        DKPUI:Hide()
		            else
                        DKPUI:Show()
                    end
				end
                if buttonName == "OptionsButton" then
                    if DKPConfig:IsShown() then
                        DKPConfig:Hide()
		            else
                        DKPConfig:Show()
                    end
				end
                if buttonName == "RollUIButton" then
                    if roll:IsShown() then
                        roll:Hide()
		            else
                        roll:Show()
                    end
				end
                if buttonName == "ItemsUIButton" then
                    if ItemPrices:IsShown() then
                        ItemPrices:Hide()
		            else
                        ItemPrices:Show()
                    end
				end
                if buttonName == "ManualRequestDKP" then
                    DKP_CORE.GatherDKP(true)
				end
                if buttonName == "MsChangeButton" then
                    if SpecSelect:IsShown() then
                        SpecSelect:Hide()
		            else
                        SpecSelect:Show()
                    end
				end
                
                if buttonName == "RoosterButton" then
                    if RoosterFrame:IsShown() then
                        RoosterFrame:Hide()
		            else
                        RoosterFrame:Show()
                    end
				end
                if buttonName == "ManualRequestDKP" then
                    DKP_CORE.GatherDKP(true)
				end
                SubMenu:Hide()
            end

            -- Set OnClick for each button in SubMenu
            local buttons = {
                "DKPUIButton", "RollUIButton", "ItemsUIButton",
                "ManualRequestDKP", "OptionsButton","MsChangeButton","RoosterButton"
            }

            -- Iterate over the buttons and set the OnClick script
            for _, buttonName in ipairs(buttons) do
                local button = _G[buttonName]
                if button then
                    button:SetScript("OnClick", function()
                        ButtonClickTest(buttonName)  -- Call the function when clicked
                    end)
                else
                    print(buttonName .. " not found.")
                end
            end
        end
    else
        print("Error: SubMenu frame not found. Make sure it's correctly defined.")
    end
end

function Init()
    if SubMenu then
        if SubMenu:IsShown() then
            SubMenu:Hide()  -- Hide the main UI frame
        end
    end
end
Init()
