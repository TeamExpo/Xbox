local SelectionBox = Instance.new("SelectionBox",workspace)
SelectionBox.LineThickness = 0.02
SelectionBox.Transparency = 0.1

local LPlayer = game.Players.LocalPlayer
local mouse = LPlayer:GetMouse()
local selectedfire
local aimbotenabled = false
local aimbottarget
local UIS = game:GetService("UserInputService")
function notification(text)
	game.StarterGui:SetCore("SendNotification", {
    Title = "XBOX SYSTEM";
    Text = text;
    Icon = "rbxassetid://2633653902";
    Duration = 1;
    })
end
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
print'new'
UIS.InputBegan:Connect(function(input,proc)
if input.KeyCode == Enum.KeyCode.ButtonL2 then
			local plr = ms2plr()
			if plr and plr ~= LPlayer then
				aimbottarget = plr
				notification("Target: "..plr.Name)
				if plr.Character then
					if plr.Character:FindFirstChild("Torso") then
						SelectionBox.Adornee = plr.Character.Torso
					end
				end
				local connection = {}
				table.insert(connection,plr.CharacterAdded:Connect(function(ch)
					wait(0.1)
					if plr.Character:FindFirstChild("Torso") then
						SelectionBox.Adornee = plr.Character.Torso
					end
				end))
				spawn(function()
					repeat wait() until aimbottarget ~= plr
					connection[1]:Disconnect()
				end)
			end
		end


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
	end)

LPlayer.CharacterAdded:Connect(function(character)
	character.ChildAdded:Connect(function(child)
	    if child:IsA("Tool") then
	        local fire = child:FindFirstChild("Fire")
	        if fire then
	            child:FindFirstChild("LocalScript").Disabled = true
	            selectedfire = child.Fire
	            local idle = character.Humanoid:LoadAnimation(child.Idle)
	            idle:Play()
	            local connection = {}
	            table.insert(connection,child.Unequipped:Connect(function()
	                idle:Stop()
	                selectedfire = nil
	                for i,v in pairs(connection) do v:Disconnect() end
	            end))
	        end
	    end
	end)
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

local counter = 0
function zigzag(X) return math.acos(math.cos(X*math.pi))/math.pi end
game:GetService("RunService").Stepped:Connect(function()
	pcall(function()
		counter = counter+0.001
		SelectionBox.Color3 = Color3.fromHSV(zigzag(counter),1,1)
	end)
end)

