-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.normal_mode["\\"] = ":vsplit<CR>"
lvim.keys.normal_mode["-"] = ":split<CR>"
lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"
lvim.keys.normal_mode["<S-h>"] = ":bprev<CR>"
lvim.keys.normal_mode["<S-l>"] = ":bnext<CR>"
-- 在 lazygit 中禁用按键绑定避免冲突
lvim.keys.term_mode["<C-h>"] = false
lvim.keys.term_mode["<C-j>"] = false
lvim.keys.term_mode["<C-k>"] = false
lvim.keys.term_mode["<C-l>"] = false

vim.opt.wrap = true

-- 仅用于 Windows 的配置
if jit.os == 'Windows' then
  lvim.builtin.terminal.shell = "pwsh -nologo"
end

-- use treesitter folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldnestmax = 5
vim.wo.foldminlines = 1
vim.wo.foldlevel = 1
vim.opt.foldenable = false -- 不自动折叠

lvim.plugins = {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  {
    "keaising/im-select.nvim",
    config = function()
      if jit.os == 'Linux' then
        require("im_select").setup({})
      end
    end
  },
  { "tpope/vim-surround" },
  {
    "Zeioth/markmap.nvim",
    build = "yarn global add markmap-cli",
    cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
    opts = {
      html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
      hide_toolbar = false,              -- (default)
      grace_period = 3600000             -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
    },
    config = function(_, opts) require("markmap").setup(opts) end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "3.10",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("local.neo-tree").setup()
    end
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  }
}

table.insert(lvim.builtin.alpha.dashboard.section.buttons.entries, 6,
  { "s", "󰁯  Open Last Session", "<cmd>lua require('persistence').load()<cr>" })

lvim.builtin.treesitter.incremental_selection = {
  enable = true,
  keymaps = {
    init_selection = "<CR>",
    node_incremental = "<CR>",
    scope_incremental = "<Tab>",
    node_decremental = "<S-Tab>",
  },
}

lvim.builtin.nvimtree.active = false -- NOTE: using neo-tree
lvim.builtin.which_key.mappings["e"] = {
  "<cmd>Neotree<cr>", "Explorer"
}
lvim.builtin.bufferline.options.offsets = {
  {
    filetype = "neo-tree",
    text = "Explorer",
    highlight = "Directory",
    separator = true
  }
}

require("lvim.lsp.manager").setup("marksman")

lvim.autocommands = {
  {
    { "BufEnter", "BufWinEnter" },
    {
      group = "lvim_user",
      pattern = "*.md",
      command = "set shiftwidth=2"
    }
  },
  {
    { "BufEnter", "BufWinEnter" },
    {
      group = "lvim_user",
      pattern = "*.ux",
      command = "set filetype=html"
    }
  }
}

-- toggleterm
lvim.builtin.terminal.winbar = { enabled = true }
lvim.keys.term_mode["<C-x>"] = "<cmd>lua require('local.term-select').prev()<cr>"
lvim.builtin.which_key.mappings["t"] = {
  name = "Terminal",
  t = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
  s = { "<cmd>lua require('local.term-select').show()<cr>", "Select Terminal" },
  n = { "<cmd>lua require('local.term-select').new()<cr>", "New Session" }
}
