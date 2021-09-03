-- Copyright (c) 2020-2021 shadmansaleh
-- MIT license, see LICENSE for more details.
local FileName = require('lualine.component'):new()

local default_options = {
  symbols = {modified = '[+]', readonly = '[-]'},
  file_status = true,
  path = 0,
  shorting_target = 40,
}

local function count(base, pattern)
  return select(2, string.gsub(base, pattern, ''))
end

local function shorten_path(path, sep)
  -- ('([^/])[^/]+%/', '%1/', 1)
  return path:gsub(
             string.format('([^%s])[^%s]+%%%s', sep, sep, sep), '%1' .. sep, 1)
end

FileName.new = function(self, options, child)
  local new_instance = self._parent:new(options, child or FileName)
  new_instance.options = vim.tbl_deep_extend('keep',
                                         new_instance.options or {},
                                         default_options)
  return new_instance
end

FileName.update_status = function(self)
  local data
  if self.options.path == 1 then
    -- relative path
    data = vim.fn.expand('%:~:.')
  elseif self.options.path == 2 then
    -- absolute path
    data = vim.fn.expand('%:p')
  else
    -- just filename
    data = vim.fn.expand('%:t')
  end

  if data == '' then data = '[No Name]' end

  if self.options.shorting_target ~= 0 then
    local windwidth = vim.fn.winwidth(0)
    local estimated_space_available = windwidth - self.options.shorting_target

    local path_separator = package.config:sub(1, 1)
    for _ = 0, count(data, path_separator) do
      if windwidth <= 84 or #data > estimated_space_available then
        data = shorten_path(data, path_separator)
      end
    end
  end

  if self.options.file_status then
    if vim.bo.modified then
      data = data .. self.options.symbols.modified
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
      data = data .. self.options.symbols.readonly
    end
  end
  return data
end

return FileName
