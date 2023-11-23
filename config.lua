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
  },
  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require('telescope').load_extension('media_files')
    end
  },
  { "nvim-lua/plenary.nvim" },
  { "m00qek/baleia.nvim" },
  {
    "skiars/chafa.nvim",
    config = function()
      require("chafa").setup({
        render = {
          min_padding = 5,
          show_label = true,
        },
        events = {
          update_on_nvim_resize = true,
        },
      })
    end
  },
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

lvim.builtin.which_key.mappings["f"] = {
  "<cmd>Telescope find_files idden=true<cr>",
  "Find File"
}
lvim.builtin.which_key.mappings["sm"] = {
  "<cmd>Telescope media_files hidden=true<cr>",
  "Media File"
}
lvim.builtin.which_key.mappings["st"] = {
  function()
    require("telescope.builtin").live_grep {
      additional_args = function(args)
        return vim.list_extend(args, {
          "--hidden"
        })
      end,
    }
  end,
  "Text in files",
}

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
lvim.keys.term_mode["<C-n>"] = "<C-\\><C-n>"
lvim.builtin.terminal.winbar = { enabled = true }
lvim.keys.term_mode["<C-x>"] = "<cmd>lua require('local.term-select').next()<cr>"
lvim.builtin.which_key.mappings["t"] = {
  name = "Terminal",
  t = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
  s = { "<cmd>lua require('local.term-select').show()<cr>", "Select Terminal" },
  n = { "<cmd>lua require('local.term-select').new()<cr>", "New Session" }
}

require("lvim.lsp.manager").setup("pylsp")
require("lvim.lsp.manager").setup("marksman")
