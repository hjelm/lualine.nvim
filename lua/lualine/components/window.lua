-- Copyright (c) 2020-2021 Daniel Hjelm (github.com/hjelm)
-- MIT license, see LICENSE for more details.
local function window()
  return vim.api.nvim_win_get_number(0)
end

return window
