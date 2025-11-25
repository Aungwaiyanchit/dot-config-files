---@type vim.lsp.Config
return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php', 'blade' },
  root_markers = { '.git', 'composer.json' },
}
