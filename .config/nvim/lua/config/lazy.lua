-- https://lazy.folke.io/installation
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
          ensure_installed = { "markdown" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    },
    {
      "bullets-vim/bullets.vim",
      config = function()
        vim.g.bullets_enabled_file_types = {'markdown'}
      end
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {},
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
      -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
      -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
      config = function()
        local configs = require("render-markdown")
        configs.setup({
          heading = {
            enabled = false,
          },
          quote = {
            repeat_linebreak = true,
          },
          checkbox = {
            unchecked = { icon = '✘ ' },
            checked = { icon = '✔ ' },
          },
          code = {
            enabled = true,
            -- enabled = false,
            sign = false,
            style = 'normal',
            position = 'left',
            -- disable_background = { 'diff' },
            width = 'full',
            left_pad = 0,
            right_pad = 0,
            min_width = 0,
            -- border = 'thin',
            border = 'tick',
            above = '▄',
            below = '▀',
            -- highlight = 'RenderMarkdownCode',
            -- highlight_inline = 'RenderMarkdownCodeInline',
          },

        })
      end
    },
    {
      "hedyhli/outline.nvim",
      -- config = function()
      --   -- Example mapping to toggle outline
      --   vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>",
      --     { desc = "Toggle Outline" })
    
      --   require("outline").setup {
      --     -- Your setup opts here (leave empty to use defaults)
      --   }
      -- end,
      lazy = true,
      cmd = { "Outline", "OutlineOpen" },
      keys = {
        { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
      },
      opts = {
        outline_window = {
          position = 'left',
          auto_jump = true,
          auto_close = true,
          wrap = true,
        },
        symbol_folding = {
          autofold_depth = 3,
        },
      },
    },
    {
      "echasnovski/mini.surround",
      -- TODO: config?
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
        },
      },
      config = function()
        require('telescope').setup {
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            }
          }
        }
        require('telescope').load_extension('fzf')

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      end,
    },
    -- {
    --   "vim-airline/vim-airline",
    --   dependencies = {
    --     'vim-airline/vim-airline-themes',
    --   },
    --   config = function()
    --     vim.g['airline#extensions#tabline#formatter'] = 'default'
    --     vim.g['airline#extensions#tabline#enabled'] = 1
    --     vim.g['airline#extensions#tabline#show_tabs'] = 10
    --     vim.g['airline#extensions#bufferline#enabled'] = 1
    --     vim.g['airline_statusline_ontop'] = 1
    --   end,
    -- },
    {
      "akinsho/bufferline.nvim",
      -- TODO: config?
      dependencies = {
        'nvim-tree/nvim-web-devicons',
      },
      config = function()
        vim.opt.termguicolors = true
        local bufferline = require('bufferline')
        bufferline.setup {
          options = {
            mode = "buffers",
            style_preset = bufferline.style_preset.minimal,
            show_buffer_icons = false,
            truncate_names = false,
            name_formatter = function(buf)
              local filename = vim.fn.fnamemodify(buf.path, ":t")
              local parent_dir = vim.fn.fnamemodify(buf.path, ":h:t")
              if filename == "README.md" then
                return parent_dir
              end
              return filename
            end,
          },
        }
      end
    },
    {
      "nvim-tree/nvim-tree.lua",
      config = function()
        require("nvim-tree").setup {
          view = {
            centralize_selection = true,
            float = {
              enable = true,
              quit_on_focus_loss = true,
              open_win_config = {
                relative = "editor",
                border = "rounded",
                width = 120,
                height = 120,
                row = 1,
                col = 1,
              },
            },
          },
        }
        vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
      end
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
