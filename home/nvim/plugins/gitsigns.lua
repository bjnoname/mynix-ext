local gitsigns = require('gitsigns')

gitsigns.setup{
  on_attach = function(bufnr)

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git stage hunk" })
    map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git unstage hunk" })
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git reset hunk" })
    map("v", "<leader>hs", function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Git stage hunk" })
    map("v", "<leader>hr", function() gitsigns.reset_hunk {vim.fn.line("."), vim.fn.line('v')} end, { desc = "Git reset hunk" })
    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git stage buffer" })
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git reset buffer" })
    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git preview hunk stage" })
    map("n", "<leader>hb", function() gitsigns.blame_line{full=true} end, { desc = "Git blame line" })
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Git toggle blame line" })
    map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git diff" })
    map("n", "<leader>hD", function() gitsigns.diffthis('~') end, { desc = "Git diff" })
    map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Git toggle deleted" })

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
