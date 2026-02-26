return function(playerName: string?)
	local name = playerName or "Player"
	return `Welcome to Coin Collector, {name}!`
end
