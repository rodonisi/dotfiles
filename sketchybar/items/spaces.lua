local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

-- Aerospace workspaces
local workspace_names = {}

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

-- Function to update workspace info
local function update_workspace_info()
	-- First, get the current workspace to ensure we don't hide it
	sbar.exec("aerospace list-workspaces --focused", function(current_result)
		local current_workspace = current_result:gsub("%s+", "")

		for _, workspace_name in ipairs(workspace_names) do
			local space = spaces[workspace_name]
			if space then
				-- Get apps in this workspace directly with aerospace command
				sbar.exec(
					"aerospace list-windows --workspace "
						.. workspace_name
						.. " --format '%{app-name}' 2>/dev/null | sort | uniq -c",
					function(result)
						local icon_line = ""
						local no_app = true
						local is_empty = false
						local is_current = workspace_name == current_workspace

						-- Check if workspace is empty
						if result == "" or result:match("^%s*$") then
							icon_line = "—"
							is_empty = true
						else
							-- Parse the aerospace output directly
							for line in result:gmatch("[^\r\n]+") do
								local _, app = line:match("(%d+)%s+(.+)")
								if app then
									no_app = false
									local lookup = app_icons[app]
									local icon = ((lookup == nil) and app_icons["Default"] or lookup)
									icon_line = icon_line .. icon
								end
							end

							if no_app then
								icon_line = "—"
								is_empty = true
							end
						end

						sbar.animate("tanh", 5, function()
							-- Always show current workspace, hide empty non-current workspaces
							local should_show = not is_empty or is_current

							space:set({
								label = icon_line,
								drawing = should_show,
							})

							-- Also hide/show the bracket and padding
							if space.bracket then
								space.bracket:set({ drawing = should_show })
							end

							-- Find and hide/show the corresponding padding item
							local padding_item = sbar.query("space.padding." .. workspace_name)
							if padding_item then
								sbar.set("space.padding." .. workspace_name, { drawing = should_show })
							end
						end)
					end
				)
			end
		end
	end)
end

-- Function to update current workspace highlighting
local function update_current_workspace(env)
	-- Try to get focused workspace from environment variable first (faster)
	local current_workspace = env and env.FOCUSED_WORKSPACE

	if current_workspace then
		-- Use the provided workspace info
		for _, workspace_name in ipairs(workspace_names) do
			local space = spaces[workspace_name]
			if space then
				local selected = workspace_name == current_workspace

				space:set({
					icon = { highlight = selected },
					label = { highlight = selected },
					background = { border_color = selected and colors.black or colors.bg2 },
				})
				if space.bracket then
					space.bracket:set({
						background = { border_color = selected and colors.grey or colors.bg2 },
					})
				end
			end
		end
	else
		-- Fallback to querying aerospace directly
		sbar.exec("aerospace list-workspaces --focused", function(result)
			current_workspace = result:gsub("%s+", "")

			for _, workspace_name in ipairs(workspace_names) do
				local space = spaces[workspace_name]
				if space then
					local selected = workspace_name == current_workspace

					space:set({
						icon = { highlight = selected },
						label = { highlight = selected },
						background = { border_color = selected and colors.black or colors.bg2 },
					})
					if space.bracket then
						space.bracket:set({
							background = { border_color = selected and colors.grey or colors.bg2 },
						})
					end
				end
			end
		end)
	end
end

sbar.exec("aerospace list-workspaces --all", function(result)
	for line in result:gmatch("[^\r\n]+") do
		local workspace_name = line:match("^%s*(%S+)%s*$")
		if workspace_name then
			table.insert(workspace_names, workspace_name)

			local space = sbar.add("item", "space." .. workspace_name, {
				icon = {
					font = { family = settings.font.numbers },
					string = workspace_name,
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
				popup = { background = { border_width = 5, border_color = colors.black } },
			})

			spaces[workspace_name] = space -- Also store by name for easy lookup

			-- Single item bracket for space items to achieve double border on highlight
			local space_bracket = sbar.add("bracket", { space.name }, {
				background = {
					color = colors.transparent,
					border_color = colors.bg2,
					height = 28,
					border_width = 2,
				},
			})

			-- Padding space
			sbar.add("item", "space.padding." .. workspace_name, {
				script = "",
				width = settings.group_paddings,
			})

			local space_popup = sbar.add("item", {
				position = "popup." .. space.name,
				padding_left = 5,
				padding_right = 0,
				background = {
					drawing = true,
					image = {
						corner_radius = 9,
						scale = 0.2,
					},
				},
			})

			-- Store the bracket for later use in updates
			space.bracket = space_bracket

			space:subscribe("mouse.clicked", function(env)
				if env.BUTTON == "other" then
					space_popup:set({ background = { image = "space." .. workspace_name } })
					space:set({ popup = { drawing = "toggle" } })
				else
					if env.BUTTON == "right" then
						-- Right click: close workspace (aerospace doesn't have destroy, so we'll move all windows and close)
						sbar.exec(
							"aerospace workspace " .. workspace_name .. " && aerospace close-all-windows-but-current"
						)
					else
						-- Left click: focus workspace
						sbar.exec("aerospace workspace " .. workspace_name)
					end
				end
			end)

			space:subscribe("mouse.exited", function(_)
				space:set({ popup = { drawing = false } })
			end)
		end
	end
	require("items.front_app")
end)

-- Set up event handlers for workspace changes
space_window_observer:subscribe("aerospace_workspace_change", function(env)
	update_workspace_info()
	update_current_workspace(env)
end)

space_window_observer:subscribe("front_app_switched", function(env)
	update_workspace_info()
	update_current_workspace(env)
end)
