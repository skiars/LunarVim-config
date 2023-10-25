local Preview = require("neo-tree.sources.common.preview")
local Commands = require("neo-tree.sources.common.commands")

local C = {}

function C.auto_cancel(state)
  if Preview.is_active() or state.current_position == "float" then
    Commands.cancel()
  else
    vim.api.nvim_input("<C-w><C-p>")
  end
end

local options = {
  close_if_last_window = true,
  use_default_mappings = false,
  commands = C,
  window = {
    width = 30,
    mappings = {
      ["?"] = "show_help",
      ["<esc>"] = "auto_cancel",
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["o"] = "open",
      ["h"] = "close_node",
      ["l"] = "toggle_node",
      ["P"] = { "toggle_preview", config = { use_float = true } },
      ["R"] = "refresh",
      ["a"] = {
        "add",
        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
        config = {
          show_path = "none", -- "none", "relative", "absolute"
        }
      },
      ["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
      ["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
      ["e"] = "toggle_auto_expand_width",
      ["q"] = "close_window",
      ["<"] = "prev_source",
      [">"] = "next_source",
    }
  },
  buffers = {
    follow_current_file = { enabled = true },
  },
  filesystem = {
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        "node_modules"
      },
      never_show = {
        ".DS_Store",
        "thumbs.db"
      },
    },
    window = {
      mappings = {
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
        ["f"] = "filter_on_submit",
        ["<C-x>"] = "clear_filter",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
        ["i"] = "show_file_details",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gA"] = "git_add_all",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
      fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
        ["<down>"] = "move_cursor_down",
        ["<C-n>"] = "move_cursor_down",
        ["<up>"] = "move_cursor_up",
        ["<C-p>"] = "move_cursor_up",
      },
    }
  },
}

return {
  setup = function()
    require("neo-tree").setup(options)
  end
}
