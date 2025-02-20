local wezterm = require("wezterm")

local gigavolt_base16 = wezterm.get_builtin_color_schemes()["Gigavolt (base16)"]
local github_base16 = wezterm.get_builtin_color_schemes()["Github (base16)"]

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Hardcore"
	else
		return "Github (base16)"
	end
end

local config = {
	font_size = 14.0,
	window_background_opacity = 0.99,
	macos_window_background_blur = 0,
	initial_cols = 120,
	initial_rows = 39,
	enable_tab_bar = false,
	color_schemes = {
		["Gigavolt (base16)"] = gigavolt_base16,
		["Github (base16)"] = github_base16,
	},
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	window_decorations = "TITLE | RESIZE",
	keys = {
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
