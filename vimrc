" Settings {{{
" Use vim, not vi api
set nocompatible
" Switch syntax highlighting on, when the terminal has colors
syntax on
" No backup files
set nobackup
" No write backup
set nowritebackup
" No swap file
set noswapfile
" Command history
set history=100
" Always show cursor
set ruler
" Show incomplete commands
set showcmd
" Incremental searching (search as you type)
set incsearch
" Highlight search matches
set hlsearch
" Ignore case in search
set smartcase
" Make sure any searches /searchPhrase doesn't need the \c escape character
set ignorecase
" Set language spelling check
set spell spelllang=en
" A buffer is marked as ‘hidden’ if it has unsaved changes, and it is
" not currently loaded in a window if you try and quit Vim while there
" are hidden buffers, you will raise an error:
" E162: No write since last change for buffer “a.txt”
set hidden
" Turn word wrap off
set nowrap
" Allow backspace to delete end of line, indent and start of line characters
set backspace=indent,eol,start
" Convert tabs to spaces
set expandtab
" Set tab size in spaces (this is for manual indenting)
set tabstop=4
" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=4
" Turn on line numbers
set number
" Highlight tailing whitespace
" See issue: https://github.com/Integralist/ProVim/issues/4
set list listchars=tab:\ \ ,trail:·
" Get rid of the delay when pressing O (for example)
" http://stackoverflow.com/questions/2158516/vim-delay-before-o-opens-a-new-line
set timeout timeoutlen=1000 ttimeoutlen=100
" Always show status bar
set laststatus=2
" Set the status line to something useful
set statusline=%f\ %=L:%l/%L\ %c\ (%p%%)
" Hide the toolbar
set guioptions-=T
" UTF encoding
set encoding=utf-8
" Autoload files that have changed outside of vim
set autoread
" Use system clipboard
" http://stackoverflow.com/questions/8134647/copy-and-paste-in-vim-via-keyboard-between-different-mac-terminals
set clipboard+=unnamed
" Don't show intro
set shortmess+=I
" Better splits (new windows appear below and to the right)
set splitbelow
set splitright
" Ensure Vim doesn't beep at you every time you make a mistype
set visualbell
" Visual autocomplete for command menu (e.g. :e ~/path/to/file)
set wildmenu
" redraw only when we need to (i.e. don't redraw when executing a macro)
set lazyredraw
" highlight a matching [{()}] when cursor is placed on start/end character
set showmatch
" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_liststyle=3
let g:python_highlight_all = 1
" Always highlight column 72 so it's easier to see where
" cutoff appears on longer screens
autocmd BufWinEnter * highlight ColorColumn ctermbg=darkred
set colorcolumn=72
" Highlight the current line
set cursorline
hi CursorLine cterm=bold ctermbg=242
hi CursorLineNr cterm=bold ctermbg=242
" Fold method
set foldmethod=marker
" }}}

" Set leader
let mapleader = "\<Space>"

" vim-plug {{{
call plug#begin()
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    " Plug 'jreybert/vimagit'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-commentary'
    Plug 'ervandew/supertab'
    Plug 'dominikduda/vim_current_word'
    Plug 'tpope/vim-abolish'
    Plug 'dpelle/vim-LanguageTool'
    Plug 'preservim/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'gerw/vim-latex-suite'
    Plug 'tlhr/anderson.vim'
    Plug 'chrisbra/csv.vim'
    Plug 'godlygeek/tabular'
    Plug 'tpope/vim-surround'
    Plug 'vim-airline/vim-airline'
    Plug 'lervag/vimtex'
    Plug 'jiangmiao/auto-pairs'
    Plug 'mbbill/undotree'
    Plug 'glepnir/dashboard-nvim'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'ap/vim-css-color'
    Plug 'PatrBal/vim-textidote'
call plug#end()
" }}}

" Colors {{{
set termguicolors
colorscheme anderson
" }}}

" Functions {{{
" Update plugin base {{{
function! UpdateBase()
    PlugUpdate
    PlugUpgrade
endfunction
" }}}
" Delete trailing white space {{{
fun! StripTrailingWhitespace()
  " don't strip on these filetypes
  if &ft =~ 'markdown'
    return
  endif
  %s/\s\+$//e
endfun
autocmd BufWritePre * call StripTrailingWhitespace()
" }}}
" Create a 'scratch buffer' which is a temporary buffer Vim wont ask to save  {{{
" http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
    if part[0] =~ '\v[%#<]'
      let expanded_part = fnameescape(expand(part))
      let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
    endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction
" }}}
" Make Latex {{{
function! MakeLatex()
    " Get file name
    let fname = expand('%:r')
    " Remove old secondary files
    let cmd_remove_old = fname . '.aux ' . fname . '.bbl ' . fname . '.blg ' . fname . '.log ' . fname . '.out ' . fname . '.spl ' . fname . '.nav ' . fname . '.snm ' . fname . '.toc ' . '*-eps-converted-to.pdf'
    exec '!rm -f ' . cmd_remove_old
    " pdflatex and bibtex execution names
    let pdflatexExe = 'pdflatex -interaction=nonstopmode -halt-on-error -synctex=0 -shell-escape -file-line-error ' . fname
    let bibtexExe = 'bibtex ' . fname
    " Recommended execution: 1 pdflatex >> 1 bibtex >> 2 pdflatex
    let recoExe = '!' . pdflatexExe . ' | ' . bibtexExe . ' | ' . pdflatexExe . ' | ' . pdflatexExe
    exec recoExe
    " Relocate
    exec '!mkdir -p build | mv ' . fname . '.pdf build/'
endfunction
" }}}
" Execute run.sh of latex files {{{
let runLatex = "run.sh"
function! ExecuteRunShLatex(shFile)
    exe "!sh " . a:shFile
endfunction
" }}}
" Arrange sentence {{{
function ArrangeSentence(line_start, line_end)
    " Select sentence
    " let save_cursor = getpos('.')
    " normal! vis
    " Get sentence lines
    " let line_start = getpos("'<")[1]
    " let line_end = getpos("'>")[1]
    let senteceLines = getline(a:line_start, a:line_end)
    " call setpos('.', save_cursor)
    " Get sentence in a line
    let sentence = senteceLines[0]
    for line in senteceLines[1:]
        let sentence .= " " . line
    endfor
    let sentence .= " "
    " Find white spaces
    let lenSentence = len(sentence)
    let whitespace_pos = []
    for k1 in range(lenSentence)
        if sentence[k1] == " "
            call add(whitespace_pos, k1)
        endif
    endfor
    " Split sentence
    let numWhiteSpaces = len(whitespace_pos)
    let maxPos = &textwidth - 1
    let newLines = []
    let ncoli = 0
    for k1 in range(1, numWhiteSpaces - 1)
        if whitespace_pos[k1] > maxPos
            let ncolf = whitespace_pos[k1 - 1] - 1
            call add(newLines, sentence[ncoli: ncolf])
            let ncoli = ncolf + 2
            let maxPos = ncoli + &textwidth
        endif
    endfor
    call add(newLines, sentence[ncoli:-2])
    " Delete lines
    let deleteString = string(a:line_start) .. "," .. string(a:line_end) .. "d"
    exec deleteString
    " Set new lines
    call append(a:line_start - 1, newLines)
endfunction
" }}}
" Arrange current sentence {{{
function ArrangeCurrentSentece()
    exec "normal $("
    let save_pos = getpos('.')
    let line_start = save_pos[1]
    exec "normal )"
    let line_end = getpos('.')[1] - 1
    call ArrangeSentence(line_start, line_end)
    call setpos('.', save_pos)
endfunction
" }}}
" Get start and end lines {{{
function GetStartAndEndLines()
    let line_start = getpos("'<")[1]
    let line_end = getpos("'>")[1]
    let line_limits = [line_start, line_end]
    echom line_limits
    return line_limits
endfunction
" }}}
" Restore session {{{
" From https://stackoverflow.com/questions/5142099/how-to-auto-save-vim-session-on-quit-and-auto-reload-on-start-including-split-wi
fu! RestoreSess()
if filereadable(getcwd() . '/.session.vim')
    execute 'so ' . getcwd() . '/.session.vim'
endif
endfunction
" }}}
" }}}

" Set mappings {{{
" Update Base
map <leader>up :call UpdateBase()<cr>
" NERDTree
map <leader>' :NERDTreeToggle<cr>
" Move text up and down in visual mode
vnoremap <A-k> :m-2<CR>gv=gv
vnoremap <A-j> :m'>+<CR>gv=gv
vnoremap <A-Up> :m-2<CR>gv=gv
vnoremap <A-Down> :m'>+<CR>gv=gv
" Resize
nnoremap <A-Up>    :resize +2<CR>
nnoremap <A-Down>  :resize -2<CR>
nnoremap <A-Left>  :vertical resize +2<CR>
nnoremap <A-Right> :vertical resize -2<CR>
" Latex execute run.sh
nnoremap <leader>el :call ExecuteRunShLatex(runLatex)<cr><cr>
" fzf-vim maps
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>rg :Rg<cr>
" Quit and save
nnoremap <leader>ww :w<cr>
nnoremap <leader>qq :q<cr>
" New tab
nnoremap <leader>tt :tabnew<cr>
" Source vimrc
nnoremap <leader>so :source ~/.vim/vimrc<cr>
" Arrange current sentence
nnoremap <leader>ss :call ArrangeCurrentSentece()<cr>
" Undo tree toggle
nnoremap <leader>ut :UndotreeToggle<cr>
" Git gutter
nmap <leader>gn <Plug>(GitGutterNextHunk)
nmap <leader>gp <Plug>(GitGutterPrevHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
" Tabular
nmap <Leader>t= :Tabularize /=<CR>
vmap <Leader>t= :Tabularize /=<CR>
nmap <Leader>t: :Tabularize /:\zs<CR>
vmap <Leader>t: :Tabularize /:\zs<CR>
nmap <Leader>t, :Tabularize /,/r0l1<CR>
vmap <Leader>t, :Tabularize /,/r0l1<CR>
"}}}

" Plugin settings {{{
" Configuration of git gutter {{{
set signcolumn=yes
highlight! link SignColumn LineNr
let g:gitgutter_sign_allow_clobber = 1
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
autocmd BufWritePost * GitGutter
" }}}

" Commentary settings {{{
filetype plugin indent on
" }}}

" Current word settings {{{
hi CurrentWord guifg=#ffffff gui=underline
hi CurrentWordTwins guifg=#ffffff gui=bold,underline cterm=underline,bold
" }}}

" vim latex suite {{{
" Close all folds when opening a new buffer
autocmd BufRead * setlocal foldmethod=marker
autocmd BufRead * normal zM
" }}}

" Language settings {{{
let g:languagetool_jar='$HOME/opt/languagetool/languagetool-commandline.jar'
let g:languagetool_disable_rules='COMMA_PARENTHESIS_WHITESPACE,EN_QUOTES,EN_UNPAIRED_BRACKETS,WORD_CONTAINS_UNDERSCORE,CURRENCY,WHITESPACE_RULE,DASH_RULE,UNIT_SPACE'

let g:textidote_jar = '$HOME/opt/textidote/textidote.jar'
" }}}

" csv settings {{{
let g:csv_delim=','
let g:csv_strict_columns = 1
hi CSVColumnEven term=bold ctermbg=4 guibg=DarkBlue
hi CSVColumnOdd  term=bold ctermbg=5 guibg=DarkMagenta
let g:csv_start = 1
let g:csv_end = 100
" }}}

" Undo tree settings {{{
let g:undotree_SetFocusWhenToggle = 1
" }}}
" }}}

" File Format line width {{{
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd Filetype tex setlocal spell textwidth=72
" }}}

" File types {{{
" Code aster files: .comm and .dumm {{{
augroup comm_ft
  au!
  autocmd BufNewFile,BufRead *.comm setfiletype python
augroup END

augroup dumm_ft
  au!
  autocmd BufNewFile,BufRead *.dumm setfiletype python
augroup END
" }}}

" For fortran files {{{
let s:extfname = expand("%:e")
if s:extfname ==? "for"
  let fortran_fixed_source = 1
elseif s:extfname ==? "f"
  let fortran_fixed_source = 1
else
  let fortran_free_source = 1
endif
" }}}
" }}}

" Template {{{
autocmd BufNewFile *.tex 0r ~/.vim/templates/elarticle.tex
" }}}

" Spelling highlight {{{
hi SpellBad guibg=DarkRed guifg=White cterm=nocombine
" }}}

" Autogroups {{{
" LaTeX settengs
augroup TexSettings
    autocmd!
    " To avoid slowing down of auto complete.
    autocmd Filetype tex setlocal complete-=i
    autocmd Filetype tex call IUNMAP("FEM", "tex")
    autocmd Filetype tex call IUNMAP("{{", "tex")
augroup END
" }}}

" Auto commands {{{
autocmd VimEnter * call RestoreSess()
" }}}
