local wezterm = require("wezterm")

local neosolarized_dark = {
	background = "#001217",
	foreground = "#708183",
	cursor_bg = "#708183",
	selection_bg = "#fcf4dc",
	selection_fg = "#001e26",
	ansi = { "#002b36", "#dc322f", "#859900", "#b58900", "#268bd2", "#d33682", "#2aa198", "#e9e2cb" },
	brights = { "#001e26", "#cb4b16", "#465a61", "#52676f", "#708183", "#6c71c4", "#81908f", "#fcf4dc" },
	tab_bar = {
		background = "#073642",
		active_tab = {
			fg_color = "#181926",
			bg_color = "#268bd2",
		},
		inactive_tab = {
			fg_color = "#CAD3F5",
			bg_color = "#586e75",
		},
	},
}

local neosolarized_light = {
	background = "#fcf4dc",
	foreground = "#002b36",
	cursor_bg = "#708183",
	selection_bg = "#52676f",
	selection_fg = "#001e26",
	ansi = { "#002b36", "#dc322f", "#859900", "#b58900", "#268bd2", "#d33682", "#2aa198", "#e9e2cb" },
	brights = { "#001e26", "#cb4b16", "#465a61", "#52676f", "#708183", "#6c71c4", "#81908f", "#fcf4dc" },
	tab_bar = {
		background = "#073642",
		active_tab = {
			fg_color = "#181926",
			bg_color = "#cad3f5",
		},
		inactive_tab = {
			fg_color = "#586e75",
			bg_color = "#cad3f5",
		},
	},
}

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "NeoSolarized Dark"
	else
		return "NeoSolarized Light"
	end
end

local config = {
	font_size = 14.0,
	window_background_opacity = 0.96,
	macos_window_background_blur = 0,
	initial_cols = 120,
	initial_rows = 39,
	enable_tab_bar = false,
	color_schemes = {
		["NeoSolarized Dark"] = neosolarized_dark,
		["NeoSolarized Light"] = neosolarized_light,
	},
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	window_padding = {
		left = 2,
		right = 2,
		top = 2,
		bottom = 2,
	},
	window_decorations = "RESIZE",
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
