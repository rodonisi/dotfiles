local colors = require("colors")
local settings = require("settings")
sbar.add("item", { width = 5, position = "right" })

sbar.add("item", "widgets.padding.start", {
	position = "right",
	width = 16,
})

sbar.add("item", { width = 5 })
local widgets = {
	require("items.widgets.calendar"),
	require("items.widgets.battery"),
	require("items.widgets.volume"),
	require("items.widgets.wifi"),
	require("items.widgets.cpu"),
}
sbar.add("item", "widgets.padding.end", {
	position = "right",
})

sbar.add("bracket", { "/widgets\\..*/" }, {}, {
	blur_radius = settings.bar.blur_radius,
	background = {
		color = colors.bar.bg,
		border_color = colors.bar.bg,
		height = settings.bar.height,
		corner_radius = settings.bar.corner_radius,
		y_offset = settings.bar.y_offset,
	},
})

for _, widget in ipairs(widgets) do
	local items = {}
	for _, item in ipairs(widget) do
		table.insert(items, item.name)
	end
	sbar.add("bracket", items, {
		background = {
			color = colors.bar.overlay,
			height = settings.overlay.height,
			y_offset = settings.bar.y_offset,
		},
	})
end
