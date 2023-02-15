local awful = require("awful")
local gears = require("gears")
local gfs = gears.filesystem
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
------------------------------------

local get_taglist = function(s)
    -- Taglist buttons
    local taglist_buttons = gears.table.join(
                                awful.button({}, 1,
                                             function(t) t:view_only() end),
                                awful.button({modkey}, 1, function(t)
            if client.focus then client.focus:move_to_tag(t) end
        end), awful.button({}, 3, awful.tag.viewtoggle),
                                awful.button({modkey}, 3, function(t)
            if client.focus then client.focus:toggle_tag(t) end
        end), awful.button({}, 4, function(t)
            awful.tag.viewnext(t.screen)
        end), awful.button({}, 5, function(t)
            awful.tag.viewprev(t.screen)
        end))
----------------------------------------------------------------------
----------------------------------------------------------------------
    local unfocus_icon = gears.surface.load_uncached(
                    gfs.get_configuration_dir() .. "emerald_chip_30x30.png")
    -- local unfocus_icon = gears.color.recolor_image(unfocus, "#C2CFDB")
    local empty_icon = gears.surface.load_uncached(
                    gfs.get_configuration_dir() .. "empty_sphere_30x30.png")
    -- local empty_icon = gears.color.recolor_image(empty, "#4C6070")
    local focus_icon = gears.surface.load_uncached(
                    gfs.get_configuration_dir() .. "emerald_chip_infused_30x30.png")
    -- local focus_icon = gears.color.recolor_image(focus, "#f76a65")

----------------------------------------------------------------------
----------------------------------------------------------------------

    -- Function to update the tags
    update_tags = function(self, c3)
        local tagicon = self:get_children_by_id('icon_role')[1]
        if c3.selected then
            tagicon.image = focus_icon
        elseif #c3:clients() == 0 then
            tagicon.image = empty_icon
        else
            tagicon.image = unfocus_icon
        end
	self:emit_signal("timeout")
    end
    
----------------------------------------------------------------------
----------------------------------------------------------------------

    local icon_taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = {spacing = 0, layout = wibox.layout.fixed.horizontal},
        widget_template = {
            {
                {id = 'icon_role', widget = wibox.widget.imagebox},
                id = 'margin_role',
                top = dpi(0),
                bottom = dpi(0),
                left = dpi(2),
                right = dpi(2),
                widget = wibox.container.margin
            },
            id = 'background_role',
	    bg = beautiful.bg_normal,
            widget = wibox.container.background,
            create_callback = function(self, c3, index, objects)
		update_tags(self, c3)
		-- c3.connect_signal("property::selected", function(c)
		--     update_tags(self, c3)
		-- end)
                client.connect_signal("manage", function(c)
		    update_tags(self, c3)
	        end)
                client.connect_signal("unmanage", function(c)
		    update_tags(self,c3)
		end)
	    end,

            update_callback = function(self, c3, index, objects)
                update_tags(self, c3)
            end
        },
        buttons = taglist_buttons
    }
    return icon_taglist
end

return get_taglist
