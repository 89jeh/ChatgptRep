print("Hello world, from server!")

local part = Instance.new("Part")
part.Name = "CodexPart"
part.Size = Vector3.new(6, 1, 6)
part.Position = Vector3.new(0, 5, 0)
part.Anchored = true
part.Color = Color3.fromRGB(255, 170, 0)
part.Material = Enum.Material.Neon
part.Parent = workspace
