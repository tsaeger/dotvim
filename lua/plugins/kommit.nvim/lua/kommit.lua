local M = {}

M.config = {
  diff = {
    max_bytes = 512 * 1024,
    max_lines = 5000,
    timeout_ms = 5000,
  },
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

local function positive_integer(value, fallback)
  value = tonumber(value)
  if value and value > 0 then
    return math.floor(value)
  end
  return fallback
end

local function diff_limits()
  local defaults = {
    max_bytes = 512 * 1024,
    max_lines = 5000,
    timeout_ms = 5000,
  }
  local configured = M.config.diff or {}
  return {
    max_bytes = positive_integer(configured.max_bytes, defaults.max_bytes),
    max_lines = positive_integer(configured.max_lines, defaults.max_lines),
    timeout_ms = positive_integer(configured.timeout_ms, defaults.timeout_ms),
  }
end

local function nth_newline(text, count)
  local pos = 0
  for _ = 1, count do
    pos = text:find("\n", pos + 1, true)
    if not pos then
      return nil
    end
  end
  return pos
end

local function show_diff(commit_win, text, notice)
  local lines = vim.split(text, "\n", { plain = true })
  if lines[#lines] == "" then
    table.remove(lines)
  end
  if #lines == 0 then
    lines = { "No staged changes." }
  end
  if notice then
    vim.list_extend(lines, { "", ("[Kommit: %s]"):format(notice) })
  end

  local target_win = vim.api.nvim_win_is_valid(commit_win) and commit_win or vim.api.nvim_get_current_win()
  vim.api.nvim_win_call(target_win, function()
    vim.cmd("vnew")
    local bufnr = vim.api.nvim_get_current_buf()
    vim.bo[bufnr].buftype = "nofile"
    vim.bo[bufnr].bufhidden = "wipe"
    vim.bo[bufnr].swapfile = false
    vim.api.nvim_buf_set_name(bufnr, ("kommit://staged-diff/%d"):format(bufnr))
    vim.bo[bufnr].filetype = "diff"
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.bo[bufnr].readonly = true
    vim.bo[bufnr].modifiable = false
  end)
end

-- Auto-open right-hand vsplit with staged diff when editing COMMIT_EDITMSG.
local function open_diff_split()
  if vim.fn.expand("%:t") ~= "COMMIT_EDITMSG" then
    return
  end
  local commit_win = vim.api.nvim_get_current_win()
  local limits = diff_limits()
  local chunks = {}
  local byte_count = 0
  local newline_count = 0
  local stderr = {}
  local finished = false
  local stopped = false
  local truncated_by
  local job_id

  local function stop(reason)
    if stopped or finished then
      return
    end
    stopped = true
    truncated_by = reason
    if job_id and job_id > 0 then
      vim.fn.jobstop(job_id)
    end
  end

  job_id = vim.fn.jobstart({ "git", "--no-pager", "diff", "--staged", "--no-ext-diff", "--no-textconv" }, {
    stdout_buffered = false,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if stopped or not data then
        return
      end
      local chunk = table.concat(data, "\n")
      if chunk == "" then
        return
      end

      local byte_remaining = limits.max_bytes - byte_count
      if #chunk > byte_remaining then
        chunk = chunk:sub(1, byte_remaining)
        truncated_by = "size"
      end

      local line_remaining = limits.max_lines - newline_count
      local newline_pos = nth_newline(chunk, line_remaining)
      if newline_pos and (line_remaining == 0 or newline_pos < #chunk) then
        chunk = chunk:sub(1, newline_pos)
        truncated_by = truncated_by or "line count"
      end

      table.insert(chunks, chunk)
      byte_count = byte_count + #chunk
      local _, added_newlines = chunk:gsub("\n", "")
      newline_count = newline_count + added_newlines

      if truncated_by then
        stop(truncated_by)
      end
    end,
    on_stderr = function(_, data)
      if data then
        local message = table.concat(data, "\n")
        table.insert(stderr, message:sub(1, 8192))
      end
    end,
    on_exit = function(_, exit_code)
      finished = true
      vim.schedule(function()
        local notice
        if truncated_by == "size" then
          notice = ("diff truncated at %d bytes; configure require('kommit').setup({ diff = { max_bytes = ... } })"):format(
            limits.max_bytes
          )
        elseif truncated_by == "line count" then
          notice = ("diff truncated at %d lines; configure require('kommit').setup({ diff = { max_lines = ... } })"):format(
            limits.max_lines
          )
        elseif truncated_by == "timeout" then
          notice = ("diff command stopped after %d ms; configure require('kommit').setup({ diff = { timeout_ms = ... } })"):format(
            limits.timeout_ms
          )
        elseif exit_code ~= 0 then
          local message = table.concat(stderr, "\n"):gsub("%s+$", "")
          notice = message ~= "" and ("git diff failed: " .. message) or ("git diff exited with status " .. exit_code)
        end
        show_diff(commit_win, table.concat(chunks), notice)
      end)
    end,
  })

  if job_id <= 0 then
    show_diff(commit_win, "", "could not start git diff")
    return
  end

  vim.defer_fn(function()
    if not finished then
      stop("timeout")
    end
  end, limits.timeout_ms)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*COMMIT_EDITMSG",
  callback = open_diff_split,
})

-- In-commit editor quit behavior: make :q[all][!] abort commit via :cq (non-zero exit)
-- This affects only the gitcommit filetype and only exact commands typed.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.cmd([[
      " Redirect common quit commands to :cq so Git sees non-zero exit code
      cnoreabbrev <expr> <buffer> q     (getcmdtype() == ':' && getcmdline() == 'q')     ? 'cq' : 'q'
      cnoreabbrev <expr> <buffer> q!    (getcmdtype() == ':' && getcmdline() == 'q!')    ? 'cq' : 'q!'
      cnoreabbrev <expr> <buffer> qa    (getcmdtype() == ':' && getcmdline() == 'qa')    ? 'cq' : 'qa'
      cnoreabbrev <expr> <buffer> qa!   (getcmdtype() == ':' && getcmdline() == 'qa!')   ? 'cq' : 'qa!'
      cnoreabbrev <expr> <buffer> qall  (getcmdtype() == ':' && getcmdline() == 'qall')  ? 'cq' : 'qall'
      cnoreabbrev <expr> <buffer> qall! (getcmdtype() == ':' && getcmdline() == 'qall!') ? 'cq' : 'qall!'
    ]])
  end,
})

-- Manually open the diff split (for troubleshooting)
vim.api.nvim_create_user_command("KommitOpenDiff", function()
  open_diff_split()
end, {})

-- Helpers for Reviewed-by sources and caching

local function config_dir()
  local xdg = os.getenv("XDG_CONFIG_HOME")
  if xdg and #xdg > 0 then
    return xdg .. "/kommit"
  end
  local home = os.getenv("HOME")
  if home and #home > 0 then
    return home .. "/.config/kommit"
  end
  return nil
end

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function reviewers_from_toml()
  local dir = config_dir()
  if not dir then
    return {}
  end
  local path = dir .. "/reviewers.toml"
  if vim.fn.filereadable(path) == 0 then
    return {}
  end
  local lines = vim.fn.readfile(path)
  local items = {}
  for _, line in ipairs(lines) do
    for m in string.gmatch(line, [["([^"]+)"]]) do
      table.insert(items, m)
    end
  end
  return items
end

local function recent_from_json()
  local dir = config_dir()
  if not dir then
    return {}
  end
  local path = dir .. "/recent_reviewers.json"
  if vim.fn.filereadable(path) == 0 then
    return {}
  end
  local ok, data = pcall(function()
    return vim.fn.json_decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  if not ok or type(data) ~= "table" then
    return {}
  end
  local items = {}
  for _, v in ipairs(data) do
    if type(v) == "string" then
      table.insert(items, v)
    end
  end
  return items
end

local function git_authors()
  local lines = vim.fn.systemlist({ "git", "log", "-n", "200", "--format=%aN <%aE>" })
  local counts = {}
  for _, l in ipairs(lines) do
    local t = trim(l)
    if #t > 0 then
      counts[t] = (counts[t] or 0) + 1
    end
  end
  local items = {}
  for name, _ in pairs(counts) do
    table.insert(items, name)
  end
  table.sort(items, function(a, b)
    local ca, cb = counts[a] or 0, counts[b] or 0
    if ca ~= cb then
      return ca > cb
    end
    return a < b
  end)
  return items
end

local function dedup(list)
  local seen = {}
  local out = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(out, v)
      seen[v] = true
    end
  end
  return out
end

local function save_recent(choice)
  local dir = config_dir()
  if not dir then
    return
  end
  vim.fn.mkdir(dir, "p")
  local path = dir .. "/recent_reviewers.json"
  local current = recent_from_json()
  local new = { choice }
  for _, v in ipairs(current) do
    if v ~= choice then
      table.insert(new, v)
    end
  end
  while #new > 20 do
    table.remove(new)
  end
  local json = vim.fn.json_encode(new)
  local f = io.open(path, "w")
  if f then
    f:write(json)
    f:close()
  end
end

-- Common commit trailers used in Linux kernel and elsewhere
local TRAILERS = {
  "Signed-off-by",
  "Reviewed-by",
  "Acked-by",
  "Tested-by",
  "Reported-by",
  "Co-developed-by",
  "Suggested-by",
  "Cc",
}

-- Aggregate candidate people from multiple sources
local function candidate_people()
  local items = {}
  for _, v in ipairs(recent_from_json()) do
    table.insert(items, v)
  end
  for _, v in ipairs(reviewers_from_toml()) do
    table.insert(items, v)
  end
  for _, v in ipairs(git_authors()) do
    table.insert(items, v)
  end
  items = dedup(items)
  if #items == 0 then
    items = { "you@example.com", "Alice <alice@example.com>", "Bob <bob@example.com>" }
  end
  return items
end

function M.pick_signer(label)
  local items = candidate_people()
  table.insert(items, 1, "Manual entry…")

  local function on_pick(val)
    if not val then
      return
    end
    vim.api.nvim_put({ (label .. ": " .. val) }, "l", true, true)
    save_recent(val)
  end

  local ok, _ = pcall(require, "telescope")
  if ok then
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers
      .new({}, {
        prompt_title = label,
        finder = finders.new_table({ results = items }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          local function commit_selection()
            local picker = action_state.get_current_picker(prompt_bufnr)
            local multi = picker and picker:get_multi_selection() or {}
            actions.close(prompt_bufnr)
            if multi and #multi > 0 then
              local had_manual = false
              for _, sel in ipairs(multi) do
                local val = sel and (sel.value or sel[1])
                if val == "Manual entry…" then
                  had_manual = true
                else
                  on_pick(val)
                end
              end
              if had_manual then
                vim.ui.input(
                  { prompt = label .. ": ", default = (vim.fn.getreg and vim.fn.getreg("+") or "") },
                  function(input)
                    if input and trim(input) ~= "" then
                      on_pick(trim(input))
                    end
                  end
                )
              end
            else
              local selection = action_state.get_selected_entry()
              local val = selection and (selection.value or selection[1])
              if val == "Manual entry…" then
                vim.ui.input(
                  { prompt = label .. ": ", default = (vim.fn.getreg and vim.fn.getreg("+") or "") },
                  function(input)
                    if input and trim(input) ~= "" then
                      on_pick(trim(input))
                    end
                  end
                )
              elseif val then
                on_pick(val)
              end
            end
          end
          map("i", "<CR>", commit_selection)
          map("n", "<CR>", commit_selection)
          return true
        end,
      })
      :find()
  else
    vim.ui.select(items, { prompt = label }, on_pick)
  end
end

function M.pick_signature_type(cb)
  local labels = TRAILERS

  local function on_label(label)
    if not label then
      return
    end
    if cb then
      cb(label)
    end
  end

  local ok, _ = pcall(require, "telescope")
  if ok then
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers
      .new({}, {
        prompt_title = "Commit trailer",
        finder = finders.new_table({ results = labels }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          local function commit_selection()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            local val = selection and (selection.value or selection[1])
            on_label(val)
          end
          map("i", "<CR>", commit_selection)
          map("n", "<CR>", commit_selection)
          return true
        end,
      })
      :find()
  else
    vim.ui.select(labels, { prompt = "Commit trailer" }, on_label)
  end
end

-- Add any commit trailer by name, or pick interactively if omitted
vim.api.nvim_create_user_command("KommitAddTrailer", function(opts)
  local label = trim(opts.args or "")
  if label ~= "" then
    M.pick_signer(label)
  else
    M.pick_signature_type(function(chosen)
      M.pick_signer(chosen)
    end)
  end
end, {
  nargs = "?",
  complete = function(ArgLead, _, _)
    local out = {}
    local lead = (ArgLead or ""):lower()
    for _, t in ipairs(TRAILERS) do
      if lead == "" or t:lower():sub(1, #lead) == lead then
        table.insert(out, t)
      end
    end
    return out
  end,
})

vim.api.nvim_create_user_command("KommitReviewedBy", function()
  M.pick_signer("Reviewed-by")
end, {})

-- my Signed-off-by
vim.api.nvim_create_user_command("KommitSignoff", function()
  local name = (vim.fn.systemlist({ "git", "config", "user.name" })[1] or ""):gsub("%s+$", "")
    or os.getenv("GIT_AUTHOR_NAME")
    or os.getenv("USER")
    or "Your Name"
  local email = (vim.fn.systemlist({ "git", "config", "user.email" })[1] or ""):gsub("%s+$", "")
    or os.getenv("GIT_AUTHOR_EMAIL")
    or (os.getenv("USER") or "user") .. "@localhost"
  local line = ("Signed-off-by: %s <%s>"):format(name, email)
  vim.api.nvim_put({ line }, "l", true, true)
  save_recent(("%s <%s>"):format(name, email))
end, {})

return M
