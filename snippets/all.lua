local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

local function git_name()
  return vim.fn.system('git config user.name'):gsub('\n', '')
end

local function git_email()
  return vim.fn.system('git config user.email'):gsub('\n', '')
end

return {
  s({trig = 'sob', desc = 'Signed-off-by'}, {
    t 'Signed-off-by: ',
    f(git_name),
    t ' <',
    f(git_email),
    t '>',
  }),
  s({trig = 'sby', desc = 'Signed-off-by'}, {
    t 'Signed-off-by: ',
    f(git_name),
    t ' <',
    f(git_email),
    t '>',
  }),
  s({trig = 'rev', desc = 'Reviewed-by'}, {
    t 'Reviewed-by: ',
    f(git_name),
    t ' <',
    f(git_email),
    t '>',
  }),
  s({trig = 'rby', desc = 'Reviewed-by'}, {
    t 'Reviewed-by: ',
    f(git_name),
    t ' <',
    f(git_email),
    t '>',
  }),
  s({trig = 'ack', desc = 'Acked-by'}, {
    t 'Acked-by: ',
    f(git_name),
    t ' <',
    f(git_email),
    t '>',
  }),
  s({trig = 'aby', desc = 'Acked-by'}, {
    t 'Acked-by: ',
    f(git_name),
    t ' <',
    f(git_email),
    t '>',
  }),
  s({trig = 'tby', desc = 'Tested-by'}, {
    t 'Tested-by: ',
    f(git_name),
    t ' <',
    f(git_email),
    t '>',
  }),
  s({trig = 'sug', desc = 'Suggested-by'}, {
    t 'Suggested-by: ',
    f(git_name),
    t ' <',
    f(git_email),
    t '>',
  }),
  s({trig = 'suby', desc = 'Suggested-by'}, {
    t 'Suggested-by: ',
    f(git_name),
    t ' <',
    f(git_email),
    t '>',
  }),
  s({trig = 'me', desc = 'Me!'}, {
    f(git_name),
  }),
}
