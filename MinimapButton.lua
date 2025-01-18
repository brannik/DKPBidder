-- Function to toggle the main UI visibility and position it near the cursor's bottom side
function ToggleMainUI()
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
        end
    else
        print("Error: SubMenu frame not found. Make sure it's correctly defined.")
    end
end

-- Access the frame defined in XML using _G["MinimapButton"]
local minimapButton = _G["MinimapButton"]
if not minimapButton then
    print("Error: MinimapButton frame not found.")
    return
end

-- Since the texture is already defined in XML, we just need to access it
local minimapButtonTexture = minimapButton:CreateTexture(nil, "BACKGROUND")
minimapButtonTexture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
minimapButtonTexture:SetAllPoints(minimapButton)  -- Make the texture fill the button

-- Function to toggle the main UI visibility when the button is clicked
minimapButton:SetScript("OnClick", function()
    ToggleSubMenu()  -- Call the ToggleMainUI function
end)

-- Mouseover effects for the button
minimapButton:SetScript("OnEnter", function()
    minimapButtonTexture:SetAlpha(0.8)  -- Change texture alpha on mouseover
end)

minimapButton:SetScript("OnLeave", function()
    minimapButtonTexture:SetAlpha(1)  -- Restore texture alpha on mouse leave
end)

-- Make the Minimap button draggable
minimapButton:SetMovable(true)
minimapButton:EnableMouse(true)
minimapButton:RegisterForDrag("LeftButton")
minimapButton:SetScript("OnDragStart", minimapButton.StartMoving)
minimapButton:SetScript("OnDragStop", minimapButton.StopMovingOrSizing)

-- Show the button
minimapButton:Show()
