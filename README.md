# Project.lua.nvim

Another `configure vim on a per project basis using a file in the project` plugin.

## Why?


### The existing ones didn't give me as much freedom as i needed.

An example: i want to specify the max line-length for the ruff linter
(which is running within null-ls).  
With existing projects you had no easy way to accomplish it.

### The existing projects are big and complex

Plugin | code lines (excluding comments, empty lines, etc)
------ | -----------------------------------------------------
`project.lua.nvim`    | ~50 lua
`project-config.nvim` | ~3060 lua
`nlsp-settings.nvim`  | ~1560 lua + ~22310 json + other languages
`vim-projectionist`   | ~1060 vimscript

It should be easier to learn:
1. define a default via setup argument: `require('project-lua').setup({YOUR_VARIABLE = 5,})`
2. use `require('project-lua').config.YOUR_VARIABLE` anywhere
3. override it in a `.project.lua`: `return {YOUR_VARIABLE = 10,}`

## Example

Nvim config:
```lua
-- add it to your pluginmanager (lazy.nvim lazy-loading is supported)
{ 'jan9103/project.lua.nvim',
  config = function()
    require('project-lua').setup({
      -- default values:
      python = {
        max_line_length = 120,
        ignore = "E501",
      },
      tabexpand = false,
      on_enter = '',
    })
  end,
}

local pl = require('project-lua').config

vim.o.expandtab = pl.tabexpand

-- this is not a good idea in terms of security, but its an option
vim.cmd(pl.on_enter)

-- … null-ls-setup

ruff.with(args = {
  '--max-line-length', pl.python.max_line_length,
  '--ignore', pl.python.ignore,
})

```

`.project.lua`:
```lua
return {
  python = {
      max_line_length = 80,
  },
  on_enter = [[
    set ft=python
  ]]
}
```

## Safety

The `project.lua` is sandboxed and has no access to imports, vim variables, etc.  
All it can do is return variables.

## Planned Features

- [ ] allow defining the default at the `get` instead of the `setup`.

## Goals and non Goals

- It is not meant to be used as a "team" config. If you want a multi-person config use something like `editorconfig` (additionally).
- Keep it simple and universal
  - No plugin/… specific features
- Fix bugs
