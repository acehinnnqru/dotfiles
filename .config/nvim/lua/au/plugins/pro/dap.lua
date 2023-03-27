return {
    "mfussenegger/nvim-dap",
    dependencies = {
        { "rcarriga/nvim-dap-ui", config = true },
        { "theHamsta/nvim-dap-virtual-text", config = true },
        { "jbyuki/one-small-step-for-vimkind", config = false },
        { "williamboman/mason.nvim", event = "VeryLazy" },
        { "jay-babu/mason-nvim-dap.nvim", event = "VeryLazy", config = true, opts = { ensure_installed = {} } },
    },
    config = function(_, _)
        vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "dap-repl",
            callback = function()
                require("dap.ext.autocompl").attach()
            end,
        })

        local dap = require("dap")
        dap.configurations.lua = {
            {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance",
            },
        }

        dap.adapters.nlua = function(callback, config)
            callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end

        local dapui = require("dapui")
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
        end
    end,
    keys = {
        { "<leader>rb", '<cmd>lua require("dap.breakpoints").clear()<cr>', desc = "Remove All Breakpoints" },
        { "<leader>sdb", "<cmd>Telescope dap list_breakpoints<cr>", desc = "Show All Breakpoints" },
        { "<leader>db", '<cmd>lua require("dap").toggle_breakpoint()<cr>', desc = "Toggle Breakpoint" },
        { "<leader>dc", '<cmd>lua require("dap").continue()<cr>', desc = "Continue" },
        {
            "<leader>dw",
            '<cmd>lua require("dap.ui.widgets").hover(nil, { border = "none" })<cr>',
            desc = "Evaluate Expression",
            mode = { "n", "v" },
        },
        { "<leader>dp", '<cmd>lua require("dap").pause()<cr>', desc = "Pause" },
        { "<leader>sdc", "<cmd>Telescope dap configurations<cr>", desc = "Run" },
        { "<F7>", '<cmd>lua require("dap").step_into()<cr>', desc = "step Into" },
        { "<F8>", '<cmd>lua require("dap").step_over()<cr>', desc = "Step Over" },
        { "<F9>", '<cmd>lua require("dap").step_out()<cr>', desc = "Step Out" },
        { "<leader>dx", '<cmd>lua require("dap").terminate()<cr>', desc = "Terminate" },
        {
            "<leader>dvf",
            function()
                require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames, { border = "none" })
            end,
            desc = "Show Frames",
        },
        {
            "<leader>dvr",
            function()
                require("dap").repl.open(nil, "20split")
            end,
            desc = "Show Repl",
        },
        {
            "<leader>dvs",
            function()
                require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes, { border = "none" })
            end,
            desc = "Show Scopes",
        },
        {
            "<leader>dvt",
            function()
                require("dap.ui.widgets").centered_float(require("dap.ui.widgets").threads, { border = "none" })
            end,
            desc = "Show Threads",
        },

        { "<leader>dr", '<cmd>lua require("dap").repl.open()<cr>', desc = "Repl" },
        { "<leader>du", '<cmd>lua require("dapui").toggle()<cr>', desc = "Dap UI" },
        { "<leader>dd", '<cmd>lua require("osv").run_this()<cr>', desc = "Launch Lua Debugger" },
        { "<leader>ds", '<cmd>lua require("osv").launch({ port = 8086 })<cr>', desc = "Launch Lua Debugger Server" },
    },
}
