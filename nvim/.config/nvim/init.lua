-- Set the leader before anything else is!
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- Explicit is better than implicit
vim.g.loaded_python3_provider = '/usr/bin/python'


--[[ ----------preferences------------------------------------------------ ]]--

-- mostly set the order of things here to match jonhoo...helps me compare
-- what I've changed and if he adds something new that I might want.
-- never ever folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 99
-- keep more context on screen when scrolling
vim.opt.scrolloff = 5
-- never show line breaks that are not there
vim.opt.wrap = false
-- always draw the sign column
vim.opt.signcolumn = 'yes'
-- relative line numbers...
vim.opt.relativenumber = true
-- ...and show the absolute number for current line
vim.opt.number = true
-- keep current content top+left when splitting
vim.opt.splitright = true
vim.opt.splitbelow = true
-- infinite undo (writes to ~/.local/state/nvim/undo)
vim.opt.undofile = true
-- Decent wildmenu
-- in completion, when more than one match
-- list all matches, only complete to the longest common match
vim.opt.wildmode = 'list:longest'
-- when opening a file with a command (like :e)
-- don't suggest files like these:
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.giv,*.min.js,*.swp,*.o,vendor,dist,_site'
-- tabs
vim.opt.shiftwidth=4
vim.opt.softtabstop=0
vim.opt.tabstop=8
vim.opt.smarttab=true
vim.opt.expandtab=true
-- case-insensitve search/replace
vim.opt.ignorecase = true
-- unless uppercase in search term
vim.opt.smartcase = true
-- no beeps needed
vim.opt.vb = true
-- more useful diffs (nvim -d)
-- by ignoring whitespace
vim.opt.diffopt:append('iwhite')
--- and using a smarter algorithm
--- https://vimways.org/2018/the-power-of-diff/
--- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
--- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')
-- Rulers (default to 80,120)
vim.api.nvim_set_option_value('colorcolumn', "80,120", {})
-- Language specific: Rust (set to 100)
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })
-- Language specific: Lua (just 120)
vim.api.nvim_create_autocmd('Filetype', { pattern = 'lua', command = 'set colorcolumn=120' })
-- show more hidden characters
-- also, show tabs nicer
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'
-- end of jonhoo order
-- vim.opt.laststatus=2 -- [default]
vim.g.backspace=indent,eol,start


--[[ ----------hotkeys---------------------------------------------------- ]]--

-- Use doublebackslash to clear highlighting
vim.api.nvim_set_keymap('n', '\\', ':noh<CR>', { noremap = true, silent = true })
-- <leader><leader> toggles between buffers
vim.keymap.set('n', '<leader><leader>', '<c-^>')
-- <leader>, shows hidden characters
vim.keymap.set('n', '<leader>,', ':set invlist<cr>')
-- always center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })


--[[ ----------autocommands----------------------------------------------- ]]--

--highlight yanked text
vim.api.nvim_create_autocmd(
    'TextYankPost',
    {
        pattern = '*',
        command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
    }
)
-- jump to last edit position on opening file
vim.api.nvim_create_autocmd(
    'BufReadPost',
    {
        pattern = '*',
        callback = function(ev)
            if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
                -- except for in git commit messages
                -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
                if not vim.fn.expand('%:p'):find('.git', 1, true) then
                    vim.cmd('exe "normal! g\'\\""')
                end
            end
        end
    }
)
-- prevent accidental writes to buffers that shouldn't be edited
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.ORI', command = 'set readonly' })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.ori', command = 'set readonly' })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.orig', command = 'set readonly' })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.BACK', command = 'set readonly' })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.SAVE', command = 'set readonly' })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.pacnew', command = 'set readonly' })
-- leave paste mode when leaving insert mode (if it was on)
vim.api.nvim_create_autocmd('InsertLeave', { pattern = '*', command = 'set nopaste' })
-- help filetype detection (add as needed)
--vim.api.nvim_create_autocmd('BufRead', { pattern = '*.ext', command = 'set filetype=someft' })


-- lazy.nvim bootstrap...
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath) 
-- ...and lazy setup (get them plugins)
require("lazy").setup({
    -- main color scheme
    {
        "wincent/base16-nvim",
        lazy = false, -- load at start, part of UI
        priority = 1000, -- load first
        config = function()
            -- TODO: blah, blah, blah (testing colors)

            -- Base color theme
            vim.cmd([[colorscheme base16-gruvbox-dark-hard]])
            vim.o.background = 'dark'
            -- Make comments more prominent -- they are important
            vim.api.nvim_set_hl(0, 'Comment', { ctermfg=112 })
            -- Make it clearly visible which argument we're at.
            local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
            vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })
            -- ruler and numbers colors
            vim.api.nvim_set_hl(0, 'ColorColumn', { ctermbg=235, bg=235 })
            vim.api.nvim_set_hl(0, 'CursorLine', { ctermbg=235, bg=235 }) 
            vim.api.nvim_set_hl(0, 'SignColumn', { ctermbg=235, bg=235 }) 
            vim.api.nvim_set_hl(0, 'LineNrAbove', { ctermfg=232, ctermbg=238, bold=true })
            vim.api.nvim_set_hl(0, 'LineNrBelow', { ctermfg=232, ctermbg=238, bold=true })
            vim.api.nvim_set_hl(0, 'LineNr', { ctermfg=238, ctermbg=232, bold=true })
            -- vim-matchup colors more during matchup, need more contrast
            vim.api.nvim_set_hl(0, 'MatchParen', { ctermfg=0, ctermbg=4 })
            vim.api.nvim_set_hl(0, 'Todo', { ctermfg=0, ctermbg=2 })
            -- affects popup windows (lazy, matchup when other end off screen, ...)
            vim.api.nvim_set_hl(0, 'Pmenu', { ctermfg=0, ctermbg=236 })
            vim.api.nvim_set_hl(0, 'Search', { ctermfg=0, ctermbg=120 })
        end
    },
    -- nice bar at the bottom
    {
        'itchyny/lightline.vim',
        lazy = false, -- also load at start since it's UI
        config = function()
            -- no need to also show mode in cmd line when we have bar
            vim.o.showmode = false
            vim.g.lightline = {
                active = {
                    left = {
                        { 'mode', 'paste' },
                        { 'readonly', 'filename', 'modified' }
                    },
                    right = {
                        { 'lineinfo' },
                        { 'percent' },
                        { 'fileencoding', 'filetype' }
                    },
                },
                component_function = {
                    filename = 'LightlineFilename'
                },
            }
            function LightlineFilenameInLua(opts)
                if vim.fn.expand('%:t') == '' then
                    return '[No Name]'
                else
                    return vim.fn.getreg('%')
                end
            end
            -- https://github.com/itchyny/lightline.vim/issues/657
            vim.api.nvim_exec(
                [[
                function! g:LightlineFilename()
                    return v:lua.LightlineFilenameInLua()
                endfunction
                ]],
                true
            )
        end
    },
    -- quick navigation
    {
        'ggandor/leap.nvim',
        config = function()
            require('leap').create_default_mappings()
        end
    },
    -- better % and marking of open-close things
    {
        'andymass/vim-matchup',
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end
    },
    -- auto-cd to root of git project
    {
        'notjedi/nvim-rooter.lua',
        config = function()
            require('nvim-rooter').setup()
        end
    },
    -- fzf support for ^p
    {
        'junegunn/fzf.vim',
        dependencies = {
            { 'junegunn/fzf' } -- , dir = '~/.fzf', build = './install --all' },
        },
        config = function()
            -- stop putting a giant window over my editor
            vim.g.fzf_layout = { down = '~20%' }
            -- when using :Files, pass the file list through
            -- https://github.com/jonhoo/proximity-sort
            -- to prefer files closer to the current file
            function list_cmd()
                local base = vim.fn.fnamemodify(vim.fn.expand('%'), ':h:.:S')
                if base == '.' then
                    -- if there is no current file,
                    -- proximity-sort can't do its thing
                    return 'fd --type file --follow'
                else
                    return vim.fn.printf('fd --type file --follow | proximity-sort %s', vim.fn.shellescape(vim.fn.expand('%')))
                end
            end
            vim.api.nvim_create_user_command('Files', function(arg)
                vim.fn['fzf#vim#files'](arg.quargs, { source = list_cmd(), options = '--tiebreak=index' }, arg.bang)
            end, { bang = true, nargs = '?', complete = "dir" })
        end
    },
    -- LSP
    {
        'neovim/nvim-lspconfig',
        config = function()
            -- Setup language servers.
            local lspconfig = require('lspconfig')

            -- Rust
            lspconfig.rust_analyzer.setup {
                -- Server-specific settings. See `:help lspconfig-setup`
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        imports = {
                            group = {
                                enable = false,
                            },
                        },
                        completion = {
                            postfix = {
                                enable = false,
                            },
                        },
                    },
                },
            }

            -- Bash LSP
            local configs = require 'lspconfig.configs'
            if not configs.bash_lsp and vim.fn.executable('bash-language-server') == 1 then
                configs.bash_lsp = {
                    default_config = {
                        cmd = { 'bash-language-server', 'start' },
                        filetypes = { 'sh' },
                        root_dir = require('lspconfig').util.find_git_ancestor,
                        init_options = {
                            settings = {
                                args = {}
                            }
                        }
                    }
                }
            end
            if configs.bash_lsp then
                lspconfig.bash_lsp.setup {}
            end

            -- Global mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)

                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    -- When https://neovim.io/doc/user/lsp.html#lsp-inlay_hint stabilizes
                    -- *and* there's some way to make it only apply to the current line.
                    -- if client.server_capabilities.inlayHintProvider then
                    --     vim.lsp.inlay_hint(ev.buf, true)
                    -- end

                    -- None of this semantics tokens business.
                    -- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
                    client.server_capabilities.semanticTokensProvider = nil
                end,
            })
        end
    },
    -- LSP-based code-completion
    {
        "hrsh7th/nvim-cmp",
        -- load cmp on InsertEnter
        event = "InsertEnter",
        -- these dependencies will only be loaded when cmp loads
        -- dependencies are always lazy-loaded unless specified otherwise
        dependencies = {
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
        },
        config = function()
            local cmp = require'cmp'
            cmp.setup({
                snippet = {
                    -- REQUIRED by nvim-cmp. get rid of it once we can
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    -- Accept currently selected item.
                    -- Set `select` to `false` to only confirm explicitly selected items.
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                },{
                    { name = 'path' },
                }),
                experimental = {
                    ghost_text = true,
                },
            })

            -- Enable completing paths in :
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources({
                    { name = 'path' }
                })
            })
        end
    },
    -- inline function signatures
    {
        'ray-x/lsp_signature.nvim',
        event = 'VeryLazy',
        opts = {},
        config = function(_, opts)
            -- Get signatures (and _only_ signatures) when in argument lists.
            require 'lsp_signature'.setup({
                doc_lines = 0,
                handler_opts = {
                    border = 'none'
                },
            })
        end
    },
    -- language support
    -- toml
    'cespare/vim-toml',
    -- yaml
    {
        'cuducos/yaml.nvim',
        ft = { 'yaml' },
        dependencies = {
            'nvim-treesitter/nvim-treesitter'
        },
    },
    -- rust
    {
        'rust-lang/rust.vim',
        ft = { 'rust' },
        config = function()
            vim.g.rustfmt_autosave = 1
            vim.g.rustfmt_emit_files = 1
            vim.g.rustfmt_fail_silently = 0
            vim.g.rust_clip_command = 'wl-copy'
        end
    },
    -- fish
    'khaveesh/vim-fish-syntax',
    -- markdown
    {
        'plasticboy/vim-markdown',
        ft = { 'markdown' },
        dependencies = {
            'godlygeek/tabular',
        },
        config = function()
            -- never ever fold!
            vim.g.vim_markdown_folding_disabled = 1
            -- support front-matter in .md files
            vim.g.vim_markdown_frontmatter = 1
            -- 'o' on list item should insert at same level
            vim.g.vim_markdown_new_list_item_indent = 0
            -- don't add bullets when wrapping:
            -- https://github.com/preservim/vim-markdown/issues/232
            vim.g.vim_markdown_auto_insert_bullets = 0
        end
    },
})

--[[
Large and small parts of this configuration stolen from all over.
Doubt I'll have references for everything, but here's where some of it came
from (and a little bit of I just wrote).

https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.lua
]]--
