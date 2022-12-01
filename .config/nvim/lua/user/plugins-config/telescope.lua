require('project_nvim').setup {}
require('telescope').setup {
    extensions = {
        file_browser = {
            theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
        },
    },
    defaults = {
        file_ignore_patterns = { "node_modules", "venv" }
    },
    pickers = {
        find_files = {
            hidden = true
        },
        live_grep = {
            additional_args = function(opts)
                return { '--hidden' }
            end
        },
    }
}

require('telescope').load_extension('projects')
require('telescope').load_extension('file_browser')
