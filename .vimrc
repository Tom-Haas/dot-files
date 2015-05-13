" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set number             "line numbers are good
colorscheme desert     "syntax highlighting

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" CTRL-U / CTRL-W in insert mode delete text.  Use CTRL-G u to put deletion 
" into a separate undo, so that you can undo them after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
":set nocursorline
":set nocursorcolumn
"syntax sync minlines=256

set wrap               "wrap words visually
set linebreak          "only wrap at a character in 'breakat' option

" easier to exit insert-mode
inoremap jk <ESC>

" fix my common typo
nnoremap :Q :q

set backup		" keep a backup file
set backupdir=~/.vim/backup,.  "put the backup ~ files here

set directory=~/.vim/swap,.    "put the .swp files here

function! TabComplete()
  let line = getline('.')                      "grab current line.
  let substr = strpart(line, 0, col('.') - 1)  "grab line up to cursor.
  let substr = matchstr(substr, "[^ \t]*$")    "grab all non-space and tab
                                               "characters at the end.
  if (strlen(substr)==0)                       "if preceeding characters are blank,
    return "\<TAB>"                            "insert a <tab>.
  endif
  if (pumvisible() != 0)                       "if there's a popup on screen,
    return "\<C-N>"                            "cycle through popup options (<C-N>).
  endif
  let has_slash = match(substr, '\/') != -1    "match() returns -1 if no match.
  if (has_slash)                               "if there's a preceeding slash,
    return "\<C-X>\<C-F>"                      "do a file-complete.
  else
    return "\<C-N>"                            "if no preceeding slash, just do a
  endif                                        "keyword complete.
endfunction

"map <TAB> to TabComplete() function
inoremap <TAB> <C-R>=TabComplete()<CR>

"for filename-completions without a preceeding slash
inoremap <S-TAB> <C-X><C-F>
