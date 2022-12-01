local lspconfig = require('lspconfig')
local python_root_files = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
}

return {
    root_dir = lspconfig.util.root_pattern(unpack(python_root_files)),
    settings = {
        python = {
            analytics = {
                autoSearchPaths = true,
                --[[ diagnosticMode = "workspace", ]]
                useLibraryCodeForTypes = false,
                typeCheckingMode = "basic",
                autoImportCompletions = true,
            }
        }
    }
}
