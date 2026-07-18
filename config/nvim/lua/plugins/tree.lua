return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    view = { width = 32 },
    renderer = {
      group_empty = true,
      icons = { show = { git = true, folder = true, file = true, folder_arrow = true } },
    },
    filters = { dotfiles = false },
    git = { enable = true },
    actions = {
      open_file = { quit_on_open = false },
    },
  },
}
