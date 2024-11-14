local map = vim.keymap.set

-- Basic
map("x", "X", '"+x')
map("x", "Y", '"+y')
map("x", "d", '"_d')

map("i", "<C-v>", "<C-g>u<C-r><C-o>+")
map("c", "<C-v>", "<C-r>+")

map("", "<tab>", "%", { remap = true })
map("", "<S-tab>", "g%", { remap = true })
map("", "<C-i>", "<C-i>")

map("n", "<BS>", "<C-^>")
-- map({ "n", "i" }, "<C-s>", "<cmd>update<cr>", { desc = "Save File" })

map("!", "<C-a>", "<Home>")
map("!", "<C-e>", "<End>")
map("!", "<C-f>", "<Right>")
map("!", "<C-b>", "<Left>")
map("!", "<A-f>", "<S-Right>")
map("!", "<A-b>", "<S-Left>")
map("!", "<C-d>", "<Del>")

map("n", "<C-q>", "<cmd>copen<cr>")
map("n", "<C-z>", "<cmd>lopen<cr>")

map("t", "JK", "<C-\\><C-n>")

map("c", "<A-n>", "<Down>")
map("c", "<A-p>", "<Up>")

-- Advanced
map("n", [[\\]], "<C-W>s", { desc = "Split window below", remap = true })
map("n", [[||]], "<C-W>v", { desc = "Split window right", remap = true })

vim.cmd [[
command! QuitWindowOrBuffer cclose | lclose | try | close | catch /E444/ | bd | endtry
]]
map("n", [[\q]], "<cmd>QuitWindowOrBuffer<cr>")
map("n", [[\Q]], "<cmd>q<cr>")

map("n", [[\w]], "<cmd>update<cr>")
map("n", [[\W]], "<cmd>wa<cr>")

map("n", [[\z]], "<cmd>stop<cr>")

map({ "n", "x" }, [[\s]], ":so<cr>")

map("x", [[\p]], function()
  local text = require("util").get_visual_selection()
  vim.fn.feedkeys(vim.keycode "<Esc>" .. ":=" .. text, "n")
end, { desc = "Inspect (=)" })
map("x", [[\l]], function()
  local text = require("util").get_visual_selection()
  vim.fn.feedkeys(vim.keycode "<Esc>" .. ":lua " .. text, "n")
end, { desc = "Inspect (lua)" })

-- Leader
map("n", "<leader>`", "<cmd>intro<cr>") -- TODO: Bug report
map("n", "<leader><cr>", "<cmd>message<cr>")

map("n", "<leader>vi", "<cmd>Inspect<cr>")
map("n", "<leader>vI", "<cmd>InspectTree<cr>")

-- abbreviations only expand when you are typing a command and press space
local function command_alias(abbr, expansion)
  vim.keymap.set("ca", abbr, function()
    local cmdline = vim.fn.getcmdline()
    local first_word = cmdline:match "%S+"
    local typing_command = vim.fn.getcmdtype() == ":" and vim.fn.getcmdpos() == (#first_word + 1)
    if not typing_command then return abbr end
    if type(expansion) == "function" then return expansion() or abbr end
    return expansion
  end, { remap = false, expr = true })
end

command_alias("ev", "e $VIMRUNTIME/")
command_alias("evv", "e $VIMRUNTIME/lua/vim/")
command_alias("evp", "e $VIMRUNTIME/plugin/")
command_alias("evP", "e $VIMRUNTIME/pack/dist/opt/")
command_alias("eva", "e $VIMRUNTIME/autoload/")
command_alias("evf", "e $VIMRUNTIME/ftplugin/")
command_alias("evi", "e $VIMRUNTIME/indent/")
command_alias("evs", "e $VIMRUNTIME/syntax/")
command_alias("evc", "e $VIMRUNTIME/colors/")
command_alias("evd", "e $VIMRUNTIME/doc/")
command_alias("evC", "e $VIMRUNTIME/compiler/")
command_alias("evk", "e $VIMRUNTIME/keymap/")
command_alias("evS", "e $VIMRUNTIME/spell/")
command_alias("evm", "e $VIMRUNTIME/macros/")
command_alias("evt", "e $VIMRUNTIME/tutor/")
command_alias("evT", "e $VIMRUNTIME/tools/")

command_alias("=", "lua")
-- command_alias("h", "vert h")
command_alias("!", "terminal")

command_alias("git", "Git")
command_alias("man", "Man")
