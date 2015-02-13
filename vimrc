set nocompatible

" Let pathogen import all plugins in the bundle folder
set sessionoptions-=options
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

" Some decent defaults for windows
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin
set selection=inclusive

" Store all swap files in this folder
set directory=C:\\Users\\Magnus\\vimswp//

colorscheme wombat
set guifont=consolas:h10
set encoding=utf-8

set winminheight=0
set winminwidth=0
"set winheight=999
"set winwidth=999
set scrolloff=2

set nobk
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Use one space after '.' when joining lines, not two.
set nojoinspaces

nnoremap <F5> :GundoToggle<CR>

au BufNewFile,BufRead *.json set filetype=json
" Recalculate syntax highlighting from start of file when pressing <C-l>.
autocmd BufEnter * :syntax sync fromstart

" Use rope for omni-completion in python files
autocmd FileType python setlocal omnifunc=RopeCompleteFunc

" Decent fallback foldsettings for python files
set fdm=indent
set foldnestmax=2
" More subtle folds
set fcs=fold:\ 

" Window rearrangement shortcuts.
if version >= 700
    function! HOpen(dir,what_to_open)
        let [type,name] = a:what_to_open
    
        if a:dir=='left' || a:dir=='right'
            vsplit
        elseif a:dir=='up' || a:dir=='down'
            split
        end
    
        if a:dir=='down' || a:dir=='right'
            exec "normal! \<c-w>\<c-w>"
        end
    
        if type=='buffer'
            exec 'buffer '.name
        else
            exec 'edit '.name
        end
    endfunction
    
    function! HYankWindow()
        let g:window = winnr()
        let g:buffer = bufnr('%')
        let g:bufhidden = &bufhidden
    endfunction
    
    function! HDeleteWindow()
        call HYankWindow()
        set bufhidden=hide
        close
    endfunction
    
    function! HPasteWindow(direction)
        let old_buffer = bufnr('%')
        call HOpen(a:direction,['buffer',g:buffer])
        let g:buffer = old_buffer
        let &bufhidden = g:bufhidden
    endfunction
    
    noremap <c-w>d :call HDeleteWindow()<cr>
    noremap <c-w>y :call HYankWindow()<cr>
    noremap <c-w>p<up> :call HPasteWindow('up')<cr>
    noremap <c-w>p<down> :call HPasteWindow('down')<cr>
    noremap <c-w>p<left> :call HPasteWindow('left')<cr>
    noremap <c-w>p<right> :call HPasteWindow('right')<cr>
    noremap <c-w>pk :call HPasteWindow('up')<cr>
    noremap <c-w>pj :call HPasteWindow('down')<cr>
    noremap <c-w>ph :call HPasteWindow('left')<cr>
    noremap <c-w>pl :call HPasteWindow('right')<cr>
    noremap <c-w>pp :call HPasteWindow('here')<cr>
    noremap <c-w>P :call HPasteWindow('here')<cr>
endif

" Don't know where this comes from.
set diffexpr=MyDiff()
function MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
           let cmd = '""' . $VIMRUNTIME . '\diff"'
           let eq = '"'
        else
           let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
    else
        let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
