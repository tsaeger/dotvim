lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('dap-python').test_method()<cr>", "Test Method" }
lvim.builtin.which_key.mappings["df"] = { "<cmd>lua require('dap-python').test_class()<cr>", "Test Class" }
lvim.builtin.which_key.vmappings["d"] = {
  name = "Debug",
  s = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug Selection" },
}

lvim.builtin.which_key.mappings["j"] = {
  name = "Jupyter",
  i = { "<Cmd>MagmaInit<CR>", "Init Magma" },
  d = { "<Cmd>MagmaDeinit<CR>", "Deinit Magma" },
  e = { "<Cmd>MagmaEvaluateLine<CR>", "Evaluate Line" },
  r = { "<Cmd>MagmaReevaluateCell<CR>", "Re evaluate cell" },
  D = { "<Cmd>MagmaDelete<CR>", "Delete cell" },
  s = { "<Cmd>MagmaShowOutput<CR>", "Show Output" },
  R = { "<Cmd>MagmaRestart!<CR>", "Restart Magma" },
  S = { "<Cmd>MagmaSave<CR>", "Save" },
}

lvim.builtin.which_key.vmappings["j"] = {
  name = "Jupyter",
  e = { "<esc><cmd>MagmaEvaluateVisual<cr>", "Evaluate Highlighted Line" },
}

lvim.builtin.which_key.mappings["C"] = {
  name = "Python",
  i = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Pick Env" },
  d = { "<cmd>lua require('swenv.api').get_current_venv()<cr>", "Show Env" },
}
