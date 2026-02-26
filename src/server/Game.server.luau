local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared:WaitForChild("GameConfig"))

local randomGenerator = Random.new()

local arenaFolder = Instance.new("Folder")
arenaFolder.Name = "Arena"
arenaFolder.Parent = workspace

local coinsFolder = Instance.new("Folder")
coinsFolder.Name = "Coins"
coinsFolder.Parent = arenaFolder

local function randomPosition()
	local halfSize = GameConfig.ArenaHalfSize
	local x = randomGenerator:NextNumber(-halfSize, halfSize)
	local z = randomGenerator:NextNumber(-halfSize, halfSize)
	return Vector3.new(x, 2, z)
end

local function createLeaderstats(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local score = Instance.new("IntValue")
	score.Name = "Score"
	score.Value = 0
	score.Parent = leaderstats
end

local function moveCoin(coin)
	coin.Position = randomPosition()
	coin.Transparency = 0
	coin.CanTouch = true
end

local function createCoin(index)
	local coin = Instance.new("Part")
	coin.Name = `Coin_{index}`
	coin.Shape = Enum.PartType.Cylinder
	coin.Material = Enum.Material.Neon
	coin.Color = Color3.fromRGB(255, 221, 0)
	coin.Size = GameConfig.CoinSize
	coin.Anchored = true
	coin.CanCollide = false
	coin.CanQuery = false
	coin.TopSurface = Enum.SurfaceType.Smooth
	coin.BottomSurface = Enum.SurfaceType.Smooth
	coin.CFrame = CFrame.new(randomPosition()) * CFrame.Angles(0, 0, math.rad(90))
	coin.Parent = coinsFolder

	local onCooldown = false

	coin.Touched:Connect(function(hit)
		if onCooldown then
			return
		end

		local character = hit.Parent
		if not character then
			return
		end

		local player = Players:GetPlayerFromCharacter(character)
		if not player then
			return
		end

		local leaderstats = player:FindFirstChild("leaderstats")
		local score = leaderstats and leaderstats:FindFirstChild("Score")
		if not score then
			return
		end

		onCooldown = true
		score.Value += GameConfig.CoinValue
		coin.Transparency = 1
		coin.CanTouch = false

		task.delay(GameConfig.CoinRespawnSeconds, function()
			moveCoin(coin)
			onCooldown = false
		end)
	end)
end

Players.PlayerAdded:Connect(createLeaderstats)
for _, player in Players:GetPlayers() do
	createLeaderstats(player)
end

for index = 1, GameConfig.CoinCount do
	createCoin(index)
end

print("Coin Collector is running. Collect coins to increase your score.")
