-- ~/.config/nvim/lua/core.lua

--------------------------------------------------
-- Basic options
--------------------------------------------------
vim.opt.smartcase = true
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.opt.shiftwidth = 4
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wildmode = "longest,list"
vim.opt.tw = 80
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.encoding = "utf-8"
vim.opt.signcolumn = "yes"


vim.cmd("colorscheme desert")
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

vim.opt.mouse = "a"

-- 'y' will copy to clipboard
vim.opt.clipboard:append({ "unnamedplus" })

-- use mouse left button release to copy the selected text.
local map = vim.keymap.set
map("v", "<LeftRelease>", '"*y', { noremap = true, silent = true })

vim.filetype.plug = true
vim.api.nvim_set_hl(0, "CursorLine", {
    underline = true,
    bg = "#262626",
    ctermbg = 235,
})

--------------------------------------------------
-- Leader key
--------------------------------------------------
vim.g.mapleader = ";"

--------------------------------------------------
-- Keymaps
--------------------------------------------------
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>h", ":nohlsearch<CR>")

--------------------------------------------------
-- Plugin manager: vim-plug (simple & stable)
--------------------------------------------------
local plug_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
if vim.fn.empty(vim.fn.glob(plug_path)) > 0 then
    vim.fn.system({
        "sh", "-c",
        "curl -fLo " .. plug_path ..
        " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    })
end

vim.cmd([[
  call plug#begin(stdpath('data') . '/plugged')

  " Core
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'nvim-lua/plenary.nvim'

  " UI
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-tree/nvim-web-devicons'

  " Git
  Plug 'tpope/vim-fugitive'

  " Cscope
  " Optional pickers
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'ibhagwan/fzf-lua'
  Plug 'dhananjaylatkar/cscope_maps.nvim'

  call plug#end()
]])


--------------------------------------------------
-- Nvim-tree (file explorer)
--------------------------------------------------
require("nvim-tree").setup({
    hijack_directories = { enable = false },
    hijack_netrw = false,
})
map("n", "<leader>t", ":NvimTreeToggle<CR>", { silent = true })

--------------------------------------------------
-- Coc.nvim keymaps
--------------------------------------------------
map("n", "gd", "<Plug>(coc-definition)", { silent = true })
map("n", "gy", "<Plug>(coc-definition)", { silent = true })
map("n", "gr", "<Plug>(coc-references)", { silent = true })
map("n", "gI", "<Plug>(coc-implementation)", { silent = true })
map("n", "K", ":call CocActionAsync('doHover')<CR>", { silent = true })
map("n", "<leader>f", "<Plug>(coc-format)", { silent = true })
map("v", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
map("n", "[c", "<Plug>(coc-diagnostic-prev)", { silent = true })
map("n", "]c", "<Plug>(coc-diagnostic-next)", { silent = true })

-- coc-git
map("n", "<leader>gn", ":CocCommand git.nextChunk<CR>", { silent = true })
map("n", "<leader>gi", ":CocCommand git.chunkInfo<CR>", { silent = true })
map("n", "<leader>gu", ":CocCommand git.chunkUndo<CR>", { silent = true })
map("n", "<leader>ga", ":CocCommand git.chunkStage<CR>", { silent = true })
map("n", "<leader>gU", ":CocCommand git.chunkUnstage<CR>", { silent = true })
map("n", "<leader>gs", ":CocCommand git.showCommit<CR>", { silent = true })
map("n", "<leader>gf", ":CocCommand git.flodUnchanged<CR>", { silent = true })
map("n", "<leader>gd", ":CocCommand git.diffCached<CR>", { silent = true })
map("n", "<leader>gt", ":CocCommand git.toggleGutters<CR>", { silent = true })

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
map("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<CR>"]], { expr = true })

-- Cscope
require('cscope_maps').setup({})

-- Auto-load cscope database:
-- 1. Prefer ./cscope.out
-- 2. Fallback to $CSCOPE_DB
local function load_cscope_db()
  local local_db = vim.fn.getcwd() .. "/cscope.out"
  local env_db = vim.env.CSCOPE_DB

  -- Case 1: ./cscope.out exists
  if vim.fn.filereadable(local_db) == 1 then
    vim.notify("cscope: loading local DB → " .. local_db)
    vim.cmd("Cs db add " .. local_db)
    return
  end

  -- Case 2: $CSCOPE_DB exists and is readable
  if env_db and vim.fn.filereadable(env_db) == 1 then
    vim.notify("cscope: loading CSCOPE_DB → " .. env_db)
    vim.cmd("Cs db add " .. env_db)
    return
  end

  -- Case 3: nothing found
  vim.notify("cscope: no database found", vim.log.levels.WARN)
end

-- Run automatically when opening Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = load_cscope_db,
})

-- Cscope shortcuts (leader + c + key)
map('n', '<C-\\>s', ':Cs find f <C-R><C-W><CR>', { desc = 'Find symbol' })
map('n', '<C-\\>g', ':Cs find g <C-R><C-W><CR>', { desc = 'Find definition' })
map('n', '<C-\\>t', ':Cs find t <C-R><C-W><CR>', { desc = 'Find text' })
map('n', '<C-\\>c', ':Cs find c <C-R><C-W><CR>', { desc = 'Find callers' })
map('n', '<C-\\>d', ':Cs find d <C-R><C-W><CR>', { desc = 'Find callees' })
map('n', '<C-\\>f', ':Cs find e <C-R><C-W><CR>', { desc = 'Find files' })
map('n', '<C-\\>i', ':Cs find i <C-R><C-W><CR>', { desc = 'Find includes' })

-- Database management
map('n', '<C-\\>B', ':Cs db build<CR>', { desc = 'Build cscope DB' })
map('n', '<C-\\>A', ':Cs db add ', { desc = 'Add cscope.out' })

-- Jump to next quickfix item
vim.keymap.set('n', '<C-j>', function()
  vim.cmd('cnext')
  vim.cmd('copen')
end, { desc = 'Quickfix: next item' })

-- Jump to previous quickfix item
vim.keymap.set('n', '<C-k>', function()
  vim.cmd('cprev')
  vim.cmd('copen')
end, { desc = 'Quickfix: previous item' })


