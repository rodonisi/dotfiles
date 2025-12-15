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
	sbar.exec(settings.spaces.command .. " list-workspaces --json --monitor all", function(workspaces)
		for _, v in pairs(workspaces) do
			local workspace = v["workspace"]
			sbar.exec(settings.spaces.command .. " list-windows --json --workspace " .. workspace, function(result)
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
						background = { border_color = selected and colors.teal or colors.bar.overlay },
					})

					if space.bracket then
						space.bracket:set({
							drawing = show,
							background = { border_color = selected and colors.grey or colors.bar.overlay },
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

sbar.exec(settings.spaces.command .. " list-workspaces --json --all", function(result)
	sbar.add("item", "space.padding.start", { width = 24 })

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
				color = colors.bar.overlay,
				border_width = 1,
				height = 26,
				border_color = colors.black,
				y_offset = settings.bar.y_offset,
			},
		})

		spaces[workspace] = space

		-- Single item bracket for space items to achieve double border on highlight
		space.bracket = sbar.add("bracket", { space.name }, {
			drawing = false, -- default to hidden to avoid flickering
			background = {
				color = colors.transparent,
				border_color = colors.bar.overlay,
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
			sbar.exec(settings.spaces.command .. " workspace " .. workspace)
		end)
	end

	require("items.front_app")
	sbar.add("item", "space.padding.end", { width = 0, padding_right = 0 })
	sbar.add("bracket", { "/space\\..*/", "front_app" }, {
		blur_radius = settings.bar.blur_radius,
		background = {
			color = colors.bar.bg,
			border_color = colors.bar.bg,
			height = settings.bar.height,
			corner_radius = settings.bar.corner_radius,
			y_offset = settings.bar.y_offset,
		},
	})
end)

-- Set up event handlers for workspace changes
space_window_observer:subscribe("aerospace_workspace_change", function(env)
	update_current_workspace(env)
end)

space_window_observer:subscribe("front_app_switched", function(_)
	update_workspaces()
end)
