return {
  "hrsh7th/nvim-cmp",
  requires = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
  },
  config = function()
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0
        and vim.api
            .nvim_buf_get_lines(0, line - 1, line, true)[1]
            :sub(col, col)
            :match "%s"
          == nil
    end

    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(key, true, true, true),
        mode,
        true
      )
    end

    local cmp = require "cmp"
    cmp.setup {
      snippet = {
        expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
      },
      window = {
        documentation = cmp.config.window.bordered(),
      },
      sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "buffer" },
        { name = "path" },
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Cr>"] = cmp.mapping.confirm { select = true },

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn["vsnip#available"](1) == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
          elseif has_words_before() then
            cmp.complete()
          else
            fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
          end
        end, { "i", "s" }),
      },
      formatting = {
        fields = {
          "kind",
          "abbr",
          "menu",
        },
        format = function(entry, vim_item)
          vim_item.menu = ({
            vsnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
            lsp = "[LSP]",
          })[entry.source.name]
          return vim_item
        end,
      },
    }

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources {
        { name = "cmdline" },
      },
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })
  end,
}
