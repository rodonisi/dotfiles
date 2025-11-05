local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
-- sbar.add("item", { width = 5 })

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

local end_padding = sbar.add("item", "menu.padding.end", {
	width = 1,
	drawing = false,
})

sbar.add("bracket", { apple.name, "/menu\\..*/" }, {
	background = {
		color = colors.bar.overlay,
		border_color = colors.black,
		border_width = 1,
		height = settings.bar.height,
		y_offset = settings.bar.y_offset,
	},
})

-- spacing for next bar
local menu_padding = sbar.add("item", {
	width = 30,
	drawing = false,
})

-- Double border for apple using a single item bracket
local border = sbar.add("bracket", { apple.name, "/menu\\..*/" }, {
	background = {
		color = colors.transparent,
		height = settings.bar.height,
		border_color = colors.bar.border,
		y_offset = settings.bar.y_offset,
	},
})

local function update_menus(_)
	sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -l", function(m)
		sbar.set("/menu\\..*/", { drawing = false })
		end_padding:set({ drawing = true })
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

local hovering = false
local toggle = false

local function set_visibility(visibility)
	menu_watcher:set({ updates = visibility })
	menu_padding:set({ drawing = visibility })
	if visibility then
		update_menus()
	else
		sbar.set("/menu\\..*/", { drawing = visibility })
	end
end

local toggle_menu = function()
	toggle = not toggle
	if not hovering then
		set_visibility(toggle)
	end
end

local function show_menu()
	if not hovering and not toggle then
		hovering = true
		set_visibility(true)
	end
end

local function hide_menu_delayed()
	hovering = false
	sbar.delay(0.5, function()
		if not hovering and not toggle then
			set_visibility(false)
		end
	end) -- 100ms delay
end

apple:subscribe("mouse.entered", function(_)
	show_menu()
end)

apple:subscribe("mouse.exited", function(_)
	hide_menu_delayed()
end)

apple:subscribe("mouse.clicked", function(env)
	if env.BUTTON == "left" then
		sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -s 0")
	end
	if env.BUTTON == "right" then
		toggle_menu()
	end
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
