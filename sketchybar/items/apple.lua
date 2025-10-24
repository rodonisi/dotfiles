local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", { width = 5 })

local apple = sbar.add("item", {
	icon = {
		font = { size = 16.0 },
		string = icons.apple,
		padding_right = 11,
		padding_left = 11,
	},
	label = { drawing = false },
	padding_left = 1,
	padding_right = 1,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

-- Padding item required because of bracket
sbar.add("item", { width = 7 })

local menu_watcher = sbar.add("item", {
	drawing = false,
	updates = false,
})

local max_items = 15
local menu_items = {}
for i = 1, max_items, 1 do
	local menu = sbar.add("item", "menu." .. i, {
		padding_left = settings.paddings,
		padding_right = settings.paddings,
		drawing = false,
		icon = { drawing = false },
		label = {
			font = {
				style = settings.font.style_map[i == 1 and "Heavy" or "Semibold"],
			},
			padding_left = 6,
			padding_right = 6,
		},
		click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s " .. i,
	})

	menu_items[i] = menu
end

local menus = sbar.add("bracket", { apple.name, "/menu\\..*/" }, {
	background = {
		color = colors.bar.overlay,
		border_color = colors.black,
		border_width = 1,
		height = settings.bar.height,
	},
})

-- Double border for apple using a single item bracket
local border = sbar.add("bracket", { apple.name, "/menu\\..*/" }, {
	background = {
		color = colors.transparent,
		height = settings.bar.height,
		border_color = colors.bar.border,
	},
})

local menu_padding = sbar.add("item", "menu.padding", {
	drawing = false,
	width = 5,
})

local hovering = false

local function update_menus(_)
	sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -l", function(m)
		sbar.set("/menu\\..*/", { drawing = false })
		menu_padding:set({ drawing = true })
		local id = 1
		for menu in string.gmatch(m, "[^\r\n]+") do
			if id < max_items then
				menu_items[id]:set({ label = menu, drawing = true })
			else
				break
			end
			id = id + 1
		end
	end)
end

menu_watcher:subscribe("front_app_switched", update_menus)

local function show_menu()
	if not hovering then
		hovering = true
		menu_watcher:set({ updates = true })
		sbar.set("front_app", { drawing = false })
		update_menus()
	end
end

local function hide_menu_delayed()
	hovering = false
	sbar.delay(0.5, function()
		if not hovering then
			menu_watcher:set({ updates = false })
			sbar.set("/menu\\..*/", { drawing = false })
			sbar.set("front_app", { drawing = true })
		end
	end) -- 100ms delay
end

apple:subscribe("mouse.entered", function(_)
	show_menu()
end)

apple:subscribe("mouse.exited", function(_)
	hide_menu_delayed()
end)

menus:subscribe("mouse.entered", function(_)
	show_menu()
end)

menus:subscribe("mouse.exited", function(_)
	hide_menu_delayed()
end)

border:subscribe("mouse.entered", function(_)
	show_menu()
end)

border:subscribe("mouse.exited", function(_)
	hide_menu_delayed()
end)

for i = 1, max_items, 1 do
	menu_items[i]:subscribe("mouse.entered", function(_)
		show_menu()
	end)
	menu_items[i]:subscribe("mouse.exited", function(_)
		hide_menu_delayed()
	end)
end

return menu_watcher
