return {
	paddings = 3,
	group_paddings = 5,
	bar = {
		height = 36,
		corner_radius = 32,
		blur_radius = 10,
		y_offset = -1,
	},
	overlay = {
		height = 26,
	},

	icons = "sf-symbols", -- alternatively available: NerdFont

	-- This is a font configuration for SF Pro and SF Mono (installed manually)
	font = require("helpers.default_font"),

	-- Alternatively, this is a font config for JetBrainsMono Nerd Font
	-- font = {
	--   text = "JetBrainsMono Nerd Font", -- Used for text
	--   numbers = "JetBrainsMono Nerd Font", -- Used for numbers
	--   style_map = {
	--     ["Regular"] = "Regular",
	--     ["Semibold"] = "Medium",
	--     ["Bold"] = "SemiBold",
	--     ["Heavy"] = "Bold",
	--     ["Black"] = "ExtraBold",
	--   },
	-- },
}
