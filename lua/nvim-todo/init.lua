local Input = require('nui.input')
local Popup = require('nui.popup')
local Layout = require('nui.layout')
local debug = require('debug')
local current_path = debug.getinfo(1).source:match("@?(.*/)")
local nvim_todo = {}

TodoList = {
    add = function(self, text)
        table.insert(self, text)
    end,
    remove = function(self, index)
        table.remove(self, index)
    end,
    get = function(self, index)
        return self[index]
    end,
    set = function(self, index, text)
        self[index] = text
    end,
    count = function(self)
        return #self
    end,
    print = function(self)
        for i, v in ipairs(self) do
            print(i .. ": " .. v)
        end
    end,
}

local input = Input({
    position = "50%",
    size = {
        width = 50,
    },
    border = {
        style = "rounded",
        text = {
            top = "ToDo",
            top_align = "center",
        },
    },
    win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
}, {
    prompt = "> ",
    on_close = function()
        print("Closed")
    end,
    on_submit = function(text)
        TodoList:add(text)
        local file = io.open(current_path .. "todo.txt", "a+")
        if file == nil then
            print("File not found")
            return
        end
        file:seek("end")
        file:write(text .. "\n")
        file:close()
        print("Submitted: " .. text)
    end,
})

local popup = Popup({
    enter = true,
    focusable = true,
    border = {
        style = "rounded",
        text = {
            top = "ToDo",
            top_align = "center",
        },
    },
    position = "50%",
    size = {
        width = 50,
        height = 10,
    },
})

function nvim_todo.Add_to_list()
    input:mount()
end

function nvim_todo.Close_input()
    input:unmount()
end

function nvim_todo.Close_popup()
    popup:unmount()
end

function nvim_todo.Read_list()
    Todo = {}
    local file = io.open(current_path .. "todo.txt", "a+")
    if file == nil then
        print("96: File not found")
        return
    end
    for line in file:lines() do
        table.insert(Todo, line)
    end
    popup:mount()
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, Todo)
    file:close()
end

local popup_remove = Popup({
    enter = true,
    focusable = true,
    border = {
        style = "rounded",
        text = {
            top = "ToDo",
            top_align = "center",
        },
    },
    position = "50%",
    size = {
        width = 50,
        height = 10,
    },
})

local input_remove = Input({
    position = "50%",
    size = {
        width = 50,
    },
    border = {
        style = "rounded",
        text = {
            top = "ToDo",
            top_align = "center",
        },
    },
    win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
}, {
    prompt = "> ",
    on_close = function()
        print("Closed")
    end,
    on_submit = function(text)
        local a = {}
        for i in string.gmatch(text, "%S+") do
            table.insert(a, tonumber(i))
        end
        local file1 = io.open(current_path .. "todo.txt", "a+")
        local lines = {}
        if file1 == nil then
            print("163: File not found")
            return
        end
        for line in file1:lines() do
            table.insert(lines, line)
        end
        file1:close()
        for i, v in ipairs(a) do
            table.remove(lines, v)
        end
        local file2 = io.open(current_path .. "todo.txt", "w+")
        if file2 == nil then
            print("175: File not found")
            return
        end
        for i, v in ipairs(lines) do
            file2:write(v .. "\n")
        end
        file2:close()
    end,
})
local popups = {
    popup_remove,
    input_remove,
}

local layout = Layout({
    relative = "editor",
    position = "50%",
    size = {
        width = 50,
        height = 10,
    },
    win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
    },

}, Layout.Box({
    Layout.Box(popups[1], {
        size = "50%"
    }),
    Layout.Box(popups[2], {
        size = "50%"
    }),
}))
function nvim_todo.Remove_from_list()
    local todoList = {}

    local file_name = io.open(current_path .. "todo.txt", "a+")
    if file_name == nil then
        print("127: File not found")
        return
    end

    for line in file_name:lines() do
        table.insert(todoList, line)
    end

    vim.api.nvim_buf_set_lines(popup_remove.bufnr, 0, 1, false, todoList)
    file_name:close()
    layout:mount()
    local win_ids = {}
    for _, pop in ipairs(popups) do
        table.insert(win_ids, pop.win_id)
    end
    local bufnr = popups[1].bufnr
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>', '', {noremap = true, silent = true})
end

function nvim_todo.Close_remove()
    layout:unmount()
end

function nvim_todo.Set_keymaps()
    vim.api.nvim_set_keymap('n', '<leader>ta', ':lua require("nvim-todo").Add_to_list()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>tr', ':lua require("nvim-todo").Remove_from_list()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<CR>', ':lua require("nvim-todo").Close_input()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<Esc>', ':lua require("nvim-todo").Close_popup()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>tl', ':lua require("nvim-todo").Read_list()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<CR>', ':lua require("nvim-todo").Close_remove()<CR>', {noremap = true, silent = true})
end

nvim_todo.Set_keymaps()

return nvim_todo
