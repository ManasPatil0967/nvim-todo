# nvim-todo
An extremely simple To-Do list plugin for Neovim. \
I made this plugin for the sole purpose of understanding UIs for plugins in Neovim as also Lua syntax. \
You can use this plugin directly in Neovim using Packer as
```lua
use {
    'ManasPatil0967/nvim-todo',
    requires = {
    { 'MunifTanjim/nui.nvim' }
    }
}
```
Thereafter simply run the Set_keymaps function to set keymaps as I've coded them. \
```lua 
local todo = require('nvim-todo')
todo.Set_keymaps()
```
Run the following command to source, don't run :so \
```lua
luafile %
```

# To Do 
1. Add date and time wise reminder feature using rcarriga/nvim-notify plugin.
2. Write a blogpost about it at [My Blog](https://manaspatil.me/blog)
