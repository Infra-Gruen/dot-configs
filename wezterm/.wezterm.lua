local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font_size = 16

function brew_prefix()
	local success, stdout, stderr = wezterm.run_child_process({ "brew", "--prefix" })
	if success then
		-- strip trailing newline off `brew --prefix` output
		return stdout:gsub("%s+", "")
	end
end

function brew_paths()
	local prefix = brew_prefix()
	if prefix then
		return { prefix .. "/bin", prefix .. "/sbin" }
	end
	return {}
end

function compute_path()
	local path = os.getenv("PATH")
	for _, dir in ipairs(brew_paths()) do
		path = path .. ":" .. dir
	end
	return path
end

local fish = "fish"

if wezterm.target_triple == "aarch64-apple-darwin" then
	-- this is where brew installs on my M1 mac
	fish = "/opt/homebrew/bin/fish"
elseif wezterm.target_triple == "x86_64-apple-darwin" then
	fish = "/usr/local/bin/fish" -- or wherever it is on your intel mac
end

config.default_prog = { fish, "-l" }
config.exit_behavior = "CloseOnCleanExit"

return config

