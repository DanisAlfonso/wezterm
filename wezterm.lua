local wezterm = require("wezterm")

-- Function to determine color scheme based on system appearance
local function scheme_for_appearance(appearance)
	if appearance:find("duckbones") then
		return "Dark" -- Replace with your preferred dark mode scheme
	else
		return "Molokai" -- Replace with your preferred light mode scheme
	end
end

local config = {
	font_size = 15.0, -- Set your desired font size here
	window_background_opacity = 0.98, -- Set your desired opacity level here
	initial_cols = 120, -- Set your desired number of columns here
	initial_rows = 39, -- Set your desired number of rows here
	enable_tab_bar = false, -- Disable the tab bar

	-- Set the initial color scheme based on the current appearance
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),

	-- Key bindings
	keys = {
		-- Toggle full screen
		{
			key = "F",
			mods = "CTRL|CMD",
			action = wezterm.action.ToggleFullScreen,
		},
	},
}

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

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
