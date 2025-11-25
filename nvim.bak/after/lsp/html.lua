return {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = {
        "blade",
        "php"
    },
    root_markers = { "index.html", ".git" },
    init_options = { provideFormatter = true },
}
