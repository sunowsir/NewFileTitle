" This is sunow's vim plug for show clip string.

" 防止重复载入插件
if exists("g:loaded_NewFileTitle")
	finish
endif

" ===================================

" start flag
let g:loaded_NewFileTitle	= 1

let g:NFT_author			= "sunowsir"
let g:NFT_Mail				= "sunowsir@163.com"

let s:is_support_type		= 0
let s:NFT_support_type_Dic	= {
			\ 'c'		: ['c'],
			\ 'cpp'		: ['cpp', 'cxx'], 
			\ 'sh'		: ['sh'], 
			\ 'python'	: ['py'], 
			\ 'lua'		: ['lua'], 
			\}




" ===================================
"

function! SetFileType()
	
	if empty(s:NFT_support_type_Dic)
		return 1
	endif

	for [key, values] in items(s:NFT_support_type_Dic)
		if key == &filetype
			let s:is_support_type = 1
		endif
		for suffix in values
			au BufRead,BufNewFile *.key set filetype=suffix
		endfor
	endfor

	return 0
endfunction

function! SetContainsTitleInfo(CommentFalgl, CommentFalgr)
		call setline(1, a:CommentFalgl) 
		call append(line("."), "	* File      : ".expand("%")) 
		call append(line(".")+1, "	* Author    : ".g:NFT_author) 
		call append(line(".")+2, "	* Mail      : ".g:NFT_Mail) 
		call append(line(".")+3, "	* Creation  : ".strftime("%c")) 
		call append(line(".")+4, a:CommentFalgr) 
		call append(line(".")+5, "")
endfunction

function! SetFileTitle()

	if &filetype == 'c' 
		call SetContainsTitleInfo("/*", "*/")
		call append(line(".")+6, "#include <stdio.h>")
		call append(line(".")+7, "")
	elseif &filetype == 'cpp'
		call SetContainsTitleInfo("/*", "*/")
		call append(line(".")+6, "#include <iostream>")
		call append(line(".")+7, "")
	elseif expand("%:e") == 'h'
		call SetContainsTitleInfo("/*", "*/")
 		call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
 		call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
 		call append(line(".")+8, "#endif")
	elseif &filetype == 'python'  
        call setline(1,"#!/bin/python")
        call append(line("."),"# coding=utf-8")
		call append(line(".")+1, "") 
	elseif &filetype == 'sh'
 		call setline(1,"#!/bin/bash") 
 		call append(line("."), "") 
	elseif &filetype == 'lua'
 		call setline(1,"#!/bin/lua") 
 		call append(line("."), "") 
	endif
endfunction


function! Main()

	if SetFileType() == 1
		echo "NewFileTitle : support file type list is empty."
		return 1
	endif

	if s:is_support_type == 0 
		echo "NewFileTitle : don\'t support is type."
		return 2
	endif

	call SetFileTitle()
	
	return 0
endfunction

" ===================================

command! -nargs=0 NewFileTitle call Main()

autocmd BufNewFile * exec ": NewFileTitle"
autocmd BufNewFile * normal G

