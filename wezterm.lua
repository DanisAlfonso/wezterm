local wezterm = require("wezterm")

-- Function to determine color scheme based on system appearance
local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Colorful Colors (terminal.sexy)" -- Replace with your preferred dark mode scheme
	else
		return "Catppuccin Latte (Gogh)" -- Replace with your preferred light mode scheme
	end
end

local config = {
	font_size = 14.0, -- Set your desired font size here
	window_background_opacity = 0.90, -- Set your desired opacity level here
	initial_cols = 120, -- Set your desired number of columns here
	initial_rows = 39, -- Set your desired number of rows here

	-- Set the initial color scheme based on the current appearance
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
}

-- Event listener to reload the configuration when the system appearance changes
wezterm.on("window-config-reloaded", function(window)
	local overrides = window:get_config_overrides() or {}
	local appearance = wezterm.gui.get_appearance()
	local scheme = scheme_for_appearance(appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end)

return config
