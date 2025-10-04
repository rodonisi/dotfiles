local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

-- Aerospace workspaces
local workspace_names = {}

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

local function update_workspaces()
	sbar.exec("aerospace list-workspaces --json --monitor all", function(result)
		for _, v in pairs(result) do
			local workspace = v["workspace"]
			sbar.exec("aerospace list-windows --json --workspace " .. workspace, function(result)
				local icon_line = ""
				local empty = true
				for _, app in pairs(result) do
					local app_name = app["app-name"]
					local icon = app_icons[app_name] or app_icons["Default"]
					icon_line = icon_line .. icon
				end

				if icon_line == "" then
					empty = false
					icon_line = "—"
				end

				sbar.animate("tanh", 1, function()
					local space = spaces[workspace]

					local selected = workspace == (spaces.current or false)
					local show = selected or empty

					space:set({
						drawing = show,
						icon = { highlight = selected },
						label = { string = icon_line, highlight = selected },
						background = { border_color = selected and colors.black or colors.bg2 },
					})

					if space.bracket then
						space.bracket:set({
							drawing = show,
							background = { border_color = selected and colors.grey or colors.bg2 },
						})
					end

					if space.padding then
						space.padding:set({ drawing = show })
					end
				end)
			end)
		end
	end)
end

local function update_current_workspace(env)
	local current_workspace = env and env.FOCUSED_WORKSPACE
	spaces.current = current_workspace
	update_workspaces()
end

sbar.exec("aerospace list-workspaces --json --all", function(result)
	for _, v in pairs(result) do
		local workspace = v["workspace"]

		table.insert(workspace_names, workspace)

		local space = sbar.add("item", "space." .. workspace, {
			drawing = false, -- default to hidden to avoid flickering
			icon = {
				font = { family = settings.font.numbers },
				string = workspace,
				padding_left = 15,
				padding_right = 8,
				color = colors.white,
				highlight_color = colors.teal,
			},
			label = {
				padding_right = 20,
				color = colors.grey,
				highlight_color = colors.white,
				font = "sketchybar-app-font:Regular:16.0",
				y_offset = -1,
			},
			padding_right = 1,
			padding_left = 1,
			background = {
				color = colors.bg1,
				border_width = 1,
				height = 26,
				border_color = colors.black,
			},
		})

		spaces[workspace] = space

		-- Single item bracket for space items to achieve double border on highlight
		space.bracket = sbar.add("bracket", { space.name }, {
			drawing = false, -- default to hidden to avoid flickering
			background = {
				color = colors.transparent,
				border_color = colors.bg2,
				height = 28,
				border_width = 2,
			},
		})

		-- Padding space
		space.padding = sbar.add("item", "space.padding." .. workspace, {
			drawing = false, -- default to hidden to avoid flickering
			width = settings.group_paddings,
		})

		space:subscribe("mouse.clicked", function()
			sbar.exec("aerospace workspace " .. workspace)
		end)
	end
	require("items.front_app")
end)

-- Set up event handlers for workspace changes
space_window_observer:subscribe("aerospace_workspace_change", function(env)
	update_current_workspace(env)
end)

space_window_observer:subscribe("front_app_switched", function(env)
	update_workspaces()
end)
