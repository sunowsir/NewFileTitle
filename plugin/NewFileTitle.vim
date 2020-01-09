" This is sunow's vim plug for show clip string.

" 防止重复载入插件
if exists("g:loaded_NewFileTitle")
	finish
endif

" ===================================

" start flag
let g:loaded_NewFileTitle	= 1

let g:NFT_author			= ""
let g:NFT_Mail				= ""

let s:NFT_support_type_Dic	= {
			\ 'c'		: ['c'],
			\ 'cpp'		: ['cpp', 'cxx'], 
			\ 'go'		: ['go'],
			\ 'sh'		: ['sh'], 
			\ 'python'	: ['py'], 
			\ 'lua'		: ['lua'], 
			\}


" ===================================

" 标记是否支持该语言
let s:is_support_type		= 0

let s:file_string			= "File      : ".expand("%")
let s:author_string			= "Author    : ".g:NFT_author
let s:mail_string			= "Mail      : ".g:NFT_Mail
let s:creation_string		= "Creation  : ".strftime("%c")

" ===================================

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

function! SetContainsTitleInfo(CommentFalgl, CommentFalgr, StartRowNum)
	let l:insert_list = []
	let l:loop_start = 0
	let l:list_index = 1

	call add(l:insert_list, a:CommentFalgl)
	call add(l:insert_list, "	* ".s:file_string)
	call add(l:insert_list, "	* ".s:author_string)
	call add(l:insert_list, "	* ".s:mail_string)
	call add(l:insert_list, "	* ".s:creation_string)
	call add(l:insert_list, a:CommentFalgr)
	call add(l:insert_list, "")

	if a:StartRowNum == 0
		call setline(1, get(l:insert_list, 0)) 
	else 
		call append(line(".")+a:StartRowNum, get(l:insert_list, 0))
		let l:loop_start = a:StartRowNum + 1
	endif

	for i in range(l:loop_start, l:loop_start + 5)
		call append(line(".")+i, get(l:insert_list, l:list_index))
		let l:list_index = l:list_index + 1
	endfor

	return 
endfunction

function! SetRowByLineTitleInfo(CommentFlag, StartRowNum) 
	let l:insert_list	= []
	let l:row_num		= a:StartRowNum

	call add(l:insert_list, a:CommentFlag." ".s:file_string)
	call add(l:insert_list, a:CommentFlag." ".s:author_string)
	call add(l:insert_list, a:CommentFlag." ".s:mail_string)
	call add(l:insert_list, a:CommentFlag." ".s:creation_string)
	call add(l:insert_list, "")

	for i in range(0, 4)
		call append(line(".")+l:row_num, get(l:insert_list, i))
		let l:row_num = l:row_num + 1
	endfor

	return 
endfunction 

function! SetFileTitle()
	if &filetype == 'c' 
		call SetContainsTitleInfo("/*", "*/", 0)
		call append(line(".")+6, "#include <stdio.h>")
		call append(line(".")+7, "")
	elseif &filetype == 'cpp'
		call SetContainsTitleInfo("/*", "*/", 0)
		call append(line(".")+6, "#include <iostream>")
		call append(line(".")+7, "")
	elseif expand("%:e") == 'h'
		call SetContainsTitleInfo("/*", "*/", 0)
 		call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
 		call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
 		call append(line(".")+8, "#endif")
	elseif &filetype == 'go' 
		call SetContainsTitleInfo("/*", "*/", 0)
	elseif &filetype == 'python'  
        call setline(1,"#!/bin/python")
        call append(line("."),"# coding=utf-8")
		call append(line(".")+1, "") 
		call SetRowByLineTitleInfo("#", 2)
	elseif &filetype == 'sh'
 		call setline(1,"#!/bin/bash") 
 		call append(line("."), "") 
		call SetRowByLineTitleInfo("#", 1)
	elseif &filetype == 'lua'
 		call setline(1,"#!/bin/lua") 
 		call append(line("."), "") 
		call SetContainsTitleInfo("--[[", "  ]]", 1)
	endif

	return 
endfunction


function! Main()
	if SetFileType() == 1
		echo "NewFileTitle : Support file type list is empty."
		return 1
	endif

	if s:is_support_type == 0 
		echo "NewFileTitle : Don\'t support file type."
		return 2
	endif

	call SetFileTitle()
	
	return 0
endfunction

" ===================================

command! -nargs=0 NewFileTitle call Main()

autocmd BufNewFile * exec ": NewFileTitle"
autocmd BufNewFile * normal G

