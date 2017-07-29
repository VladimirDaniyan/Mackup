" ------
" Vundle
" ------

" git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" vim +PluginInstall +qall
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" Better JSON for Vim https://github.com/elzr/vim-json
Plugin 'elzr/vim-json'
" NerdTree https://github.com/scrooloose/nerdtree
Plugin 'scrooloose/nerdtree'
" Vim-fugitive = git wrapper https://github.com/tpope/vim-fugitive
Plugin 'tpope/vim-fugitive'
" Surround.vim https://github.com/tpope/vim-surround
Plugin 'tpope/vim-surround'
" vim-auto-save Automatically save changes to disk
Plugin 'vim-scripts/vim-auto-save'
" Run commands in Tmux
Plugin 'benmills/vimux'
" Plugin for stripping whitespace
Plugin 'ntpeters/vim-better-whitespace'
" Docker syntax
Plugin 'ekalinin/Dockerfile.vim'
" Command-line fuzzy finder (fzf)
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
" Ansible specific highlighting for vim
Plugin 'chase/vim-ansible-yaml'
" Jinja2 syntax highlighting
Plugin 'Glench/Vim-Jinja2-Syntax'
" Nginx conf syntax highlighting from http://vim-scripts.org/vim/scripts.html
Plugin 'nginx.vim'
" Vim plugin for the_silver_searcher, 'ag'
Plugin 'rking/ag.vim'
" Plugin for editing fish scripts
Plugin 'dag/vim-fish'
" Plugin for terraform syntax highlighting
Plugin 'hashivim/vim-terraform'
" Plugin for Python PEP8 syntax
Plugin 'nvie/vim-flake8'
" Plugin for Python Linting
Plugin 'vim-syntastic/syntastic'
" Plugin for autocompletion
Plugin 'Valloric/YouCompleteMe'
" Plugin for TOML file syntax highlighting
Plugin 'cespare/vim-toml'
" Plugin for managing three-way merges
Plugin 'sjl/splice.vim'
" Groovy syntax highlighting
Plugin 'modille/groovy.vim'
" Jenkinsfile syntax highligting
Plugin 'martinda/Jenkinsfile-vim-syntax'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" --------
" NERDTree
" --------

" Open NERDTree if no files specified on vim open
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Map NERDTree to C-n
:map <C-n> :NERDTreeToggle<CR>
:map <C-h> :set hlsearch!<CR>


" ---------------
" Colors & Themes
" ---------------

" Powerline theme
set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim

" colorscheme
set term=screen-256color
set background=light
syntax on

if &diff
    colorscheme monokai
endif

set nocompatible              " be iMproved, required
filetype on                  " required
set number

" show statusline always
set laststatus=2


" ----------
" Formatting
" ----------

" splits - open new buffer right or under
set splitright
set splitbelow

" tabbing
set tabstop=4
set shiftwidth=4
set expandtab

" searching
set ignorecase
set smartcase
hi Search ctermbg=008
" search for visually selected text
vnoremap // y/<C-R>"<CR>

" backspacing
set backspace=2 " make backspace work like most other apps

" editing
set ruler

" Delete whitespace on save
autocmd FileType * autocmd BufWritePre <buffer> StripWhitespace

" 80 column width
highlight ColorColumn ctermbg=DarkYellow
call matchadd('ColorColumn', '\%80v', 100)


" -----------
" FZF configs
" -----------

" Use fuzzy search to open files in new tab
set rtp+=/usr/local/opt/fzf
nnoremap <silent> <Leader>f :FZF<CR>

let g:fzf_command_prefix = 'Z'
nmap <Leader>ag :call SilverSearch()<CR>
nmap <Leader>tt :ZTags<CR>

" --------------------
" AG - Silver Searcher
" --------------------
"
" start searching from your project root instead of the cwd
let g:ag_working_path_mode="r"

function! SilverSearch()
    call inputsave()
    let search_string = input('Enter search string: ')
    call inputrestore()
    execute "ZAg! ".search_string
endfunction


" ---
" Git
" ---
nmap <leader>gs :!tig status<CR>
nmap <leader>gf :ZGFiles?<CR>
nmap <leader>ga :Git add %<CR>


" -------------
" Vimux configs
" -------------

let g:VimuxHeight = "30"

" run tox
nmap <leader>mx :call VimuxRunCommand("clear; and tox ")<CR>
" run shellcheck
nmap <Leader>msc :VimuxRunCommand("clear; and shellcheck " . bufname("%"))<CR>
" prompt for command
nmap <Leader>mc :VimuxPromptCommand<CR>
" prompt for command against current file
nmap <leader>mf :VimuxPromptCommand("clear; " . bufname("%"))<CR>
" close tmux runner
nmap <Leader>mq :VimuxCloseRunner<CR>
" run the last command
nmap <Leader>ml :VimuxRunLastCommand<CR>
" move into the tmux runner pane
nmap <Leader>mi :VimuxInspectRunner<CR>

" Terraform plan
nmap <leader>mtp :call VimuxPromptCommand("clear; terraform plan")<CR>
" Terraform plan with get
nmap <leader>mtg :call VimuxPromptCommand("clear; terraform get -update; terraform plan")<CR>

" Ansible
" run playbook
nmap <leader>map :VimuxPromptCommand("clear; ansible-playbook -i hosts/qa/main -D " . bufname("%"))<CR>
" open the vault
nmap <leader>mav :VimuxPromptCommand("clear; ansible-vault view private_vars/prod-secret-vars.yml")<CR>


" Terraform
" format
nmap <leader>mtf :TerraformFmt<CR>

" Python
" prompt for python command against current file
nmap <leader>mfp :VimuxPromptCommand("clear; python " . bufname("%"))<CR>


" -------------
" YouCompleteMe
" -------------
let g:ycm_autoclose_preview_window_after_completion=1
nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>


" --------
" Behavior
" --------

" paste mode
set pastetoggle=<F10>

" Autoload modifed file
set autoread

" auto pair symbols
ino " ""<left>
ino ' ''<left>
ino ( ()<left>
ino [ []<left>
ino { {}<left>
ino {<CR> {<CR>}<ESC>O

" vertical to horizontal ( | -> -- )
noremap <C-w>=  <C-w>t<C-w>K
" horizontal to vertical ( -- -> | )
noremap <C-w>/ <C-w>t<C-w>H

" syntastic linter
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode = 'passive'
" mappings
nmap <F8> :SyntasticCheck<CR>
nmap <leader>ss :SyntasticToggleMode<CR>
" set python checker
let g:syntastic_python_checkers = ['pylint']


" move swap, back and undo
" double slash for name-collision prevention
set backupdir=~/.vim/backup_files//
set directory=~/.vim/swap_files//
set undodir=~/.vim/undo_files//

" rename tmux window based on vim filename
autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%:t"))
let cwd = fnamemodify(getcwd(), ':t')
autocmd VimLeave * call system("tmux rename-window " . shellescape(cwd))

" toggle set paste automatically
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" POSIX compatible shell
if &shell =~# 'fish$'
    set shell=bash
endif

" html5
let g:html5_event_handler_attributes_complete = 0
