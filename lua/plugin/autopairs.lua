return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  init = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.setup({})

    -- Align closing bracket with the line indentation, place the cursor
    -- between brackets and indent it one level:
    --
    -- if <smth>:
    --     mydict = {|}
    --
    -- Typing <CR> produces:
    --
    -- if <smth>:
    --     mydict = {
    --         |
    --     }
    --
    -- This is a crutchy fix for the very annoying misindentation problem:
    --
    -- if <smth>:
    --     mydict = {|}
    --
    -- Typing <CR> produces:
    --
    -- if <smth>:
    --     mydict = {
    --             |
    --             }
    --
    -- TODO: determine whether the problem arises in the first place, or
    -- find a way to speed up this solution.

    local function fix_indent(opts)
      local line_indent = string.match(opts.line, "^(%s*)")
      local inner_indent = line_indent .. "    "
      return string.format(
        "<cr><esc>0dwi%s<cr><esc>0dwi%s<esc>kA",
        inner_indent,
        line_indent
      )
    end

    npairs.add_rules({
      Rule("{", "", "python")
        :use_key("<cr>")
        :with_pair(cond.after_text("}"))
        :replace_endpair(fix_indent),
      Rule("(", "", "python")
        :use_key("<cr>")
        :with_pair(cond.after_text(")"))
        :replace_endpair(fix_indent),
      Rule("[", "", "python")
        :use_key("<cr>")
        :with_pair(cond.after_text("]"))
        :replace_endpair(fix_indent)
    })
  end,
}
