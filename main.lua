--[[--
This is a plugin to use Whitaker's Words inside of KOReader.

@module koplugin.WhitakersWords
--]]--

local Dispatcher = require("dispatcher")  -- luacheck:ignore
local InfoMessage = require("ui/widget/infomessage")
local UIManager = require("ui/uimanager")
local UI = require("apps/reader/readerui")
local ButtonDialog = require("ui/widget/buttondialog")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local ReaderHighlight = require("apps/reader/modules/readerhighlight")
local _ = require("gettext")
local Trapper = require("ui/trapper")

local WW = WidgetContainer:extend{
    name = "whitakers_words_plugin",
    is_doc_only = true,
}

function WW:init()
    self.ui.menu:registerToMainMenu(self)
    self:onDispatcherRegisterActions()
end

--This puts a button in the first menu of the overhead menu (The one with the bookmark)
function WW:addToMainMenu(menu_items)
    menu_items.ww = {
        text = _("Whitaker's Words 1"),
        callback = function()
            UIManager:show(InfoMessage:new{
                text = _("Test 1"),
            })
        end,
    }
end

--This puts the button in the dictionary/highlight menu with a selected word
function WW:onDictButtonsReady(dict_popup, buttons)
    table.insert(buttons, 1, {{
        id = "ww_caller",
        text = _("Whitaker's Words 2"),
        font_bold = true,
        callback = function()
                local selection = self.ui.highlight.selected_text.text
                Trapper:wrap(function()
                        local ran, out = Trapper:dismissablePopen("cd ./plugins/whitakers_words.koplugin/ && ./words "..selection, "Testing...")
                        UIManager:show(InfoMessage:new{
                                text = _(out),
                        })

                end)
        end,
    }})
end


function WW:onDispatcherRegisterActions()
    Dispatcher:registerAction("show_ww",
        {category="none", event="ShowWW", title=_("Launch Whitaker's Words"), general=true, separator=true})
end

return WW

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

