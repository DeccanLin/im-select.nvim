# im-select.nvim

> CREDIT:
> It is a fork from the brilliant [keaising/im-select.nvim: Switch Input Method automatically depends on Neovim's edit mode](https://github.com/keaising/im-select.nvim). Since I change too much of it, So I make a new repo to develop it.

Automatically change input method for you, works for all platforms.

## Install

> [im-select](https://github.com/daipeihust/im-select)

`im-select.nvim` use external tools to switch IM, you need to:

1. Install binary tools on different OS;
2. Make sure the commands of get and set input commands works in the terminal first;
2. Add *im-select.nvim* to your package manager config file;

*For [folke/lazy.nvim: 💤 A modern plugin manager for Neovim](https://github.com/folke/lazy.nvim)*

```lua
{
    "DeccanLin/im-select.nvim",
    config = function()
        require("im_select").setup({})
    end,
}
```

*For [wbthomason/packer.nvim: A use-package inspired plugin manager for Neovim. Uses native packages, supports Luarocks dependencies, written in Lua, allows for expressive config](https://github.com/wbthomason/packer.nvim)*

```lua
use 'DeccanLin/cmake-tools.nvim'
```

*For [junegunn/vim-plug: :hibiscus: Minimalist Vim Plugin Manager](https://github.com/junegunn/vim-plug)*

```vimscript
Plug 'DeccanLin/cmake-tools.nvim'
```

## Configuration

For different platforms with different input methods:

|                         | default_mode                | get_mode_command                                             | set_mode_command                                             |
| ----------------------- | --------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Windows                 | `1033`                    | `im-select.exe`                                            | `im-select.exe`                                            |
| macOS                   | `com.apple.keylayout.ABC` | `im-select`                                                | `im-select`                                                |
| Linux-Fcitx             | `-c`                        | `fcitx-remote -o`                                            | `fcitx-remote`                                               |
| Linux-Fcitx5            | `keyboard-us`               | `fcitx5-remote -n`                                           | `fcitx5-remote`                                              |
| Linux-IBUS              | `xkb:us::eng`               | `ibus engine`                                                | `ibus`                                                       |
| Linux-Linux-Fcitx5-Rime | `b true`                    | `busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 IsAsciiMode` | `busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode` |

**Example**

```lua
{
    "keaising/im-select.nvim",
    config = function()
        require('im_select').setup({
			-- Restore the default input method state when the following events are triggered
            set_default_events  = { "InsertLeave" },
            -- Restore the previous used input method state when the following events are triggered
            set_previous_events = { "InsertEnter" },
            -- Async run `set_mode_command` to switch IM or not
            async_switch_im     = true,
            -- Default params for set_mode_command
            default_mode        = "-c",
            -- Command to get current input method mode
            get_mode_command    = "fcitx5-remote -n",
            -- Command to set input method
            set_mode_command    = "fcitx5-remote",
        })
    end,
}
```

## TODO

- Add help info;
- Add health check;
