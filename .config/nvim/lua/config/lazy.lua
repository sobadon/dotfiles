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
      tag = "v0.9.3",
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
      tag = "2.0.0",
      config = function()
        vim.g.bullets_enabled_file_types = {'markdown'}
      end
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      tag = "v8.2.0",
      opts = {},
      dependencies = {
        { 'nvim-treesitter/nvim-treesitter' },
        { 'echasnovski/mini.nvim', tag = "v0.15.0" },
      },
      config = function()
        vim.api.nvim_set_hl(0, 'RenderMarkdownCode', {bg = '#333333'})
        vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', {bg = '#333333'})

        local configs = require("render-markdown")
        configs.setup({
          win_options = {
            conceallevel = {
              default = 2,  -- Adjust the value as per your requirement
              rendered = 0,  -- Ensures backticks are displayed in rendered mode
            },
            concealcursor = {
              default = 'nc',  -- Adjust the value as per your requirement
              rendered = '',  -- Ensures concealed text is shown in all modes
            },
          },
          -- Enables rendering in each mode
          render_modes = {
            'n',
            'i',
            'v',
            'V',
            'no', -- y だけ入力したときにもレンダリングさせる
          },

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
          },

        })
      end
    },
    {
      "hedyhli/outline.nvim",
      commit = "ae473fb51b7b6086de0876328c81a63f9c3ecfef", -- 2025/04/05 main latest
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
    -- {
    --   "echasnovski/mini.surround",
    --   -- TODO: config?
    -- },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      dependencies = {
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          commit = "1f08ed60cafc8f6168b72b80be2b2ea149813e55",
          build = 'cmake -S. -Bbuild -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
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
      tag = "v4.9.1",
      -- TODO: config?
      dependencies = {
        { 'nvim-tree/nvim-web-devicons', commit = "4c3a5848ee0b09ecdea73adcd2a689190aeb728c" },
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
      tag = "nvim-tree-v1.11.0",
      config = function()
        require("nvim-tree").setup {
          update_focused_file = {
            enable = true,
          },
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
    {
      "jiangmiao/auto-pairs",
      commit = "39f06b873a8449af8ff6a3eee716d3da14d63a76",
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false },
})
