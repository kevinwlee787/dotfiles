return {
  'EdenEast/nightfox.nvim',
  'bluz71/vim-moonfly-colors',
  'bluz71/vim-nightfly-guicolors',
  'rebelot/kanagawa.nvim',
  'navarasu/onedark.nvim',

  {
    'rose-pine/neovim',
    name = 'rose-pine',
    opts = {
      highlight_groups = {
        ["@variable"] = { italic = false },
        ["@property"] = { italic = false },
      }
    }
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    -- Nvim 0.12 bundles its own colors/catppuccin.vim. lazy.nvim skips loading
    -- a colorscheme's plugin when the name already completes, so that bundled
    -- scheme wins and none of the plugin integration highlights get defined.
    -- Loading eagerly puts this plugin's colors/catppuccin.lua on the rtp first.
    lazy = false,
    priority = 1000,
    opts = {
      integrations = {
        dap = {
          enabled = true,
          enable_ui = true,
        },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        notify = true,
      },
      custom_highlights = function(colors)
        return {
          ['@property.cpp'] = { link = '@property' },
          ['@lsp.typemod.parameter.reference'] = {
            fg = require('catppuccin.utils.colors').lighten(colors.maroon, 0.75),
          },
        }
      end
    }
  },

  {
    'folke/tokyonight.nvim',
    opts = {
      style = 'night',
      on_highlights = function(hl, c)
        hl['@lsp.typemod.parameter.reference'] = {
          fg = require('tokyonight.util').lighten(c.yellow, 0.45)
        }
        hl['FzfLuaDirPart'] = {
          link = 'Comment',
        }
      end,
      plugins = {
        cmp = true,
      }
    }
  },

  {
    'Mofiqul/dracula.nvim',
    priority = 1000,
    opts = {
      overrides = function(colors)
        local darken = require('tokyonight.util').darken
        return {
          LspReferenceRead = { link = 'CursorLine' },
          LspReferenceWrite = { link = 'CursorLine' },
          LspReferenceText = { link = 'CursorLine' },
          DiffFile = { link = 'Directory', },
          DiffAdd = { bg = darken(colors.bright_green, 0.35) },
          DiffDelete = { bg = darken(colors.red, 0.15) },
          DiffChange = { bg = darken(colors.cyan, 0.15) },
          DiffText = { bg = darken(colors.cyan, 0.35) },
          ['@lsp.type.typeParameter'] = { link = '@type' },
        }
      end,
    }
  },

}
