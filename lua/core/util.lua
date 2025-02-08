local _M = {}

local uv = (vim.uv or vim.loop)

_M.path_sep = uv.os_uname().version:match 'Windows' and '\\' or '/'
---Join input path segments
---@return string
_M.path_join = function(...)
  local result = table.concat({ ... }, _M.path_sep)
  return result
end

--- Checks if given path exists and is a directory
--@param path (string) path to check
--@returns (bool)
_M.is_directory = function(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == 'directory' or false
end

--- Checks if given path exists and is a file
--@param path (string) path to check
--@returns (bool)
_M.is_file = function(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == 'file' or false
end

return _M
