local SelectionBox = Instance.new("SelectionBox",workspace)
SelectionBox.LineThickness = 0.02
SelectionBox.Transparency = 0.1
function notification(text)
	game.StarterGui:SetCore("SendNotification", {
    Title = "XBOX SYSTEM";
    Text = text;
    Icon = "rbxassetid://2633653902";
    Duration = 1;
    })
end
local LPlayer = game.Players.LocalPlayer
local mouse = LPlayer:GetMouse()
local aimbotenabled = false
local aimbottarget
local UIS = game:GetService("UserInputService")
local visible = false
local gui = script.Parent
function ms2plr()
	local ms = LPlayer:GetMouse()
	local plr
    local closest = 25
    for i,v in pairs(game.Players:GetPlayers()) do
		if v.Character then
			local root = v.Character:FindFirstChild("HumanoidRootPart") or v.Character:FindFirstChild("Torso")
			if root then
				if (root.Position - Vector3.new(ms.Hit.X,ms.Hit.Y,ms.Hit.Z)).Magnitude < closest then
					closest = (root.Position - Vector3.new(ms.Hit.X,ms.Hit.Y,ms.Hit.Z)).Magnitude
					plr = v
				end
			end
		end
    end
	return plr
end
UIS.InputBegan:Connect(function(input,proc)
	
		if input.KeyCode == Enum.KeyCode.ButtonX then
			aimbotenabled = not aimbotenabled
			notification("Aimbot: "..tostring(aimbotenabled))
			local tool = LPlayer.Character:FindFirstChildOfClass("Tool")
			if tool then
		        local fire = tool:FindFirstChild("Fire")
		        if fire then
		            tool:FindFirstChild("LocalScript").Disabled = true
		            selectedfire = tool.Fire
		            local idle = LPlayer.Character.Humanoid:LoadAnimation(tool.Idle)
		            idle:Play()
		            local connection = {}
		            table.insert(connection,tool.Unequipped:Connect(function()
		                idle:Stop()
		                selectedfire = nil
		                for i,v in pairs(connection) do v:Disconnect() end
		            end))
		        end
		    end
		end
	
	
	
		if input.KeyCode == Enum.KeyCode.ButtonL2 then
		local plr = ms2plr()
			if plr and plr ~= LPlayer then
				aimbottarget = plr
				notification("Target: "..plr.Name)
				if plr.Character.Torso then
						SelectionBox.Adornee = plr.Character.Torso
				end
				local connection = {}
				table.insert(connection,plr.CharacterAdded:Connect(function(ch)
					wait(0.1)
						SelectionBox.Adornee = plr.Character.Torso
				end))
				spawn(function()
					repeat wait() until aimbottarget ~= plr
					connection[1]:Disconnect()
				end)
			end	
end
end)
local held = false
mouse.Button1Down:Connect(function()
    if selectedfire then
		held = true
		if not aimbotenabled then
	        repeat wait() selectedfire:FireServer(mouse.Hit) until not held
		elseif aimbottarget then
			local root = aimbottarget.Character:FindFirstChild("HumanoidRootPart") or aimbottarget.Character:FindFirstChild("Torso")
			if root then
			repeat wait() selectedfire:FireServer(root.CFrame+root.Velocity/5) until not held
			end
		end
	end
end)
mouse.Button1Up:Connect(function()
    held = false
end)
