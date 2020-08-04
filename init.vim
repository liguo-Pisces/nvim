" _ _                           _
"| (_) __ _ _   _  ___   __   _(_)_ __ ___  _ __ ___
"| | |/ _` | | | |/ _ \  \ \ / / | '_ ` _ \| '__/ __|
"| | | (_| | |_| | (_) |  \ V /| | | | | | | | | (__
"|_|_|\__, |\__,_|\___/    \_/ |_|_| |_| |_|_|  \___|
"     |___/
"

" Author: @liguo

" Environment {

	" Auto load for first time uses
	if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
                                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
	endif

" }

" General {
	
	syntax on	" Syntax highlighting
	scriptencoding utf-8

	set spell
	set hidden
" }

" Vim UI {
    set tabpagemax=15
    set showmode

    set cursorline

    set number
" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current

" }

" Key (re)Mappings {

	" Set <LEADER> as <SPACE>
	let mapleader=' '

	" Open the vimrc file anytime
	noremap <LEADER>rc :e ~/.config/nvim/init.vim<CR>

	" Save & Quit
	noremap Q :q<CR>
	noremap <C-q> :qa<CR>
	noremap S :w<CR>

	noremap j gj
	noremap k gk
" }

" Cursor Movement {

	" Command mode cursor movement
	cnoremap <C-a> <Home>
	cnoremap <C-e> <End>
	cnoremap <C-p> <Up>
	cnoremap <C-n> <Down>
	cnoremap <C-b> <Left>
	cnoremap <C-f> <Right>
	cnoremap <M-b> <S-Left>
	cnoremap <M-w> <S-Right>

" }

" Plugins {

	call plug#begin('~/.vim/plugged')

	" File navigation
	Plug 'junegunn/fzf.vim'
	Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}

    " Auto Complete
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

	call plug#end()

	" FZF {
		set rtp+=/usr/bin/fzf
        noremap <C-p> :Files<CR>
        noremap <C-f> :Rg<CR>
        noremap <C-h> :History<CR>
        "noremap <C-t> :BTags<CR>
        noremap <C-l> :Lines<CR>
        noremap <C-w> :Buffers<CR>
        noremap <leader>; :History:<CR>

        let g:fzf_preview_window = 'right:60%'
        let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

        function! s:list_buffers()
          redir => list
          silent ls
          redir END
          return split(list, "\n")
        endfunction

        function! s:delete_buffers(lines)
          execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
        endfunction

        command! BD call fzf#run(fzf#wrap({
          \ 'source': s:list_buffers(),
          \ 'sink*': { lines -> s:delete_buffers(lines) },
          \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
        \ }))

        noremap <c-d> :BD<CR>

        let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
	" }
	
	" Rnvimr {
		" Make Ranger replace Netrw and be the file explorer
		let g:rnvimr_enable_ex = 1

		" Make Ranger to be hidden after picking a file
		let g:rnvimr_enable_picker = 1

		" Disable a border for floating window
		let g:rnvimr_draw_border = 0

		" Hide the files included in gitignore
		let g:rnvimr_hide_gitignore = 1

		" Change the border's color
		let g:rnvimr_border_attr = {'fg': 14, 'bg': -1}

		" Make Neovim wipe the buffers corresponding to the files deleted by Ranger
		let g:rnvimr_enable_bw = 1

		" Set up only two columns in miller mode and draw border with both
		let g:rnvimr_ranger_cmd = 'ranger --cmd="set column_ratios 1,1"
					\ --cmd="set draw_borders both"'

		" Link CursorLine into RnvimrNormal highlight in the Floating window
		highlight link RnvimrNormal CursorLine

		nnoremap <silent> <M-o> :RnvimrToggle<CR>
		tnoremap <silent> <M-o> <C-\><C-n>:RnvimrToggle<CR>

		" Resize floating window by all preset layouts
		tnoremap <silent> <M-i> <C-\><C-n>:RnvimrResize<CR>

		" Resize floating window by special preset layouts
		tnoremap <silent> <M-l> <C-\><C-n>:RnvimrResize 1,8,9,11,5<CR>

		" Resize floating window by single preset layout
		tnoremap <silent> <M-y> <C-\><C-n>:RnvimrResize 6<CR>

		" Map Rnvimr action
		let g:rnvimr_action = {
					\ '<C-t>': 'NvimEdit tabedit',
					\ '<C-x>': 'NvimEdit split',
					\ '<C-v>': 'NvimEdit vsplit',
					\ 'gw': 'JumpNvimCwd',
					\ 'yw': 'EmitRangerCwd'
					\ }

		" Customize the initial layout
		let g:rnvimr_layout = { 'relative': 'editor',
					\ 'width': float2nr(round(0.6 * &columns)),
					\ 'height': float2nr(round(0.6 * &lines)),
					\ 'col': float2nr(round(0.2 * &columns)),
					\ 'row': float2nr(round(0.2 * &lines)),
					\ 'style': 'minimal' }

		" Customize multiple preset layouts
		" '{}' represents the initial layout
		let g:rnvimr_presets = [
					\ {},
					\ {'width': 0.700, 'height': 0.700},
					\ {'width': 0.800, 'height': 0.800},
					\ {'width': 0.950, 'height': 0.950},
					\ {'width': 0.500, 'height': 0.500, 'col': 0, 'row': 0},
					\ {'width': 0.500, 'height': 0.500, 'col': 0, 'row': 0.5},
					\ {'width': 0.500, 'height': 0.500, 'col': 0.5, 'row': 0},
					\ {'width': 0.500, 'height': 0.500, 'col': 0.5, 'row': 0.5},
					\ {'width': 0.500, 'height': 1.000, 'col': 0, 'row': 0},
					\ {'width': 0.500, 'height': 1.000, 'col': 0.5, 'row': 0},
					\ {'width': 1.000, 'height': 0.500, 'col': 0, 'row': 0},
					\ {'width': 1.000, 'height': 0.500, 'col': 0, 'row': 0.5}]
	" }
" }
