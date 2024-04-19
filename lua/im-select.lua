local M = {}

M.closed = false

-- local config
local default_config = {
  -- Restore the default input method state when the following events are triggered
  set_default_events  = { "InsertLeave" },
  -- Restore the previous used input method state when the following events are triggered
  set_previous_events = { "InsertEnter" },
  -- Async run `set_mode_command` to switch IM or not
  async_switch_im     = true,
  -- Default params for set_mode_command
  default_mode        = "b true",
  -- Command to get current input method mode
  get_mode_command    = "busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 IsAsciiMode",
  -- Command to set input method
  set_mode_command    = "busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode",
}

local function get_im_mode()
  return vim.fn.system(M.config.get_mode_command)
end

local function set_im_mode(mode)
  local command = M.config.set_mode_command .. " " .. mode
  local cmd, args = command:match("(%S+)%s(.*)")
  local arg_list = {}
  for arg in string.gmatch(args, "%S+") do
    table.insert(arg_list, arg)
  end
  -- print(vim.inspect(arg_list))

  local handle
  handle, _ = vim.loop.spawn(
    cmd,
    { args = arg_list, detach = true },
    vim.schedule_wrap(function(_, _)
      if handle and not handle:is_closing() then
        handle:close()
      end
      M.closed = true
    end)
  )

  if not handle then
    vim.api.nvim_err_writeln(
      [[[im-select]: The command execution failed, please make sure it can run successfully in the terminal first. Command: ]] ..
      cmd .. args)
  end

  if not M.config.async_switch_im then
    vim.wait(5000, function()
      return M.closed
    end, 200)
  end
end

local function restore_default_im()
  local current = get_im_mode()
  vim.api.nvim_set_var("im_select_saved_state", current)

  if current ~= M.config.default_mode then
    set_im_mode(M.config.default_mode)
  end
end

local function restore_previous_im()
  local current = get_im_mode()
  local saved = vim.g["im_select_saved_state"]

  if current ~= saved and saved ~= nil then
    set_im_mode(saved)
  end
end

M.setup = function(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", default_config, opts)
  -- set autocmd
  local group_id = vim.api.nvim_create_augroup("im-select", { clear = true })

  -- InsertEnter
  if #M.config.set_previous_events > 0 then
    vim.api.nvim_create_autocmd(M.config.set_previous_events, {
      callback = restore_previous_im,
      group = group_id,
    })
  end

  -- InsertLeave
  if #M.config.set_default_events > 0 then
    vim.api.nvim_create_autocmd(M.config.set_default_events, {
      callback = restore_default_im,
      group = group_id,
    })
  end
end

return M
