" This is sunow's vim plug for show clip string.

" 防止重复载入插件
if exists("g:loaded_NewFileTitle")
	finish
endif

" ===================================

" start flag
let g:loaded_NewFileTitle		= 1

" author string
if !exists("g:NFT_author") 
	let g:NFT_author			= ""
endif

" mail string
if !exists("g:NFT_Mail")
	let g:NFT_Mail				= ""
endif

if !exists("g:file_title")
	let g:file_title			= "	* File      : "
endif
if !exists("g:author_title")
	let g:author_title			= "	* Author    : "
endif
if !exists("g:mail_title")
	let g:mail_title			= "	* Mail      : "
endif
if !exists("g:creation_title")
	let g:creation_title		= "	* Creation  : "
endif

" support language dictionary
if !exists("g:NFT_support_type_Dic")
	let g:NFT_support_type_Dic	= {
			\ 'c'		: ['c'],
			\ 'cpp'		: ['cpp', 'cxx'], 
			\ 'go'		: ['go'],
			\ 'sh'		: ['sh'], 
			\ 'python'	: ['py'], 
			\ 'lua'		: ['lua'], 
			\}
endif


" ===================================

" 标记是否支持该语言
let s:is_support_type		= 0

let s:insert_list			= []
call add(s:insert_list, g:file_title.expand("%"))
call add(s:insert_list, g:author_title.g:NFT_author)
call add(s:insert_list, g:mail_title.g:NFT_Mail)
call add(s:insert_list, g:creation_title.strftime("%c"))


" ===================================

function! SetFileType()
	if empty(g:NFT_support_type_Dic)
		return 1
	endif

	for [key, values] in items(g:NFT_support_type_Dic)
		if key == &filetype
			let s:is_support_type = 1
		endif
		for suffix in values
			au BufRead,BufNewFile *.key set filetype=suffix
		endfor
	endfor

	return 0
endfunction

function! SetTitleInfo(StartLineNum, ...) 
	let l:index = a:StartLineNum - 2

	if a:0 == 1 || a:0 == 2 
		let l:Comment_Symbol_1 = a:1
		if a:0 == 2
			let l:Comment_Symbol_2 = a:2
		endif
	else 
		echo "NewFileTitle.vim : SetTitleInfo args number error."
		return 1
	endif
	
	if l:index == -1 
		call setline(1, l:Comment_Symbol_1)
	else 
		call append(line(".") + l:index, l:Comment_Symbol_1)
	endif
	let l:index += 1

	for i in s:insert_list
		if a:0 == 1
			call append(line(".") + l:index, l:Comment_Symbol_1.i)
		else 
			call append(line(".") + l:index, i)
		endif
		let l:index += 1
	endfor

	if a:0 == 2
		call append(line(".") + l:index, l:Comment_Symbol_2)
	endif
	call append(line(".") + l:index + 1, "")

	return 
endfunction


function! SetFileTitle()
	if &filetype == 'c' 
		call SetTitleInfo(1, "/*", "*/")
		call append(line(".")+6, "#include <stdio.h>")
		call append(line(".")+7, "")
	elseif &filetype == 'cpp'
		call SetTitleInfo(1, "/*", "*/")
		call append(line(".")+6, "#include <iostream>")
		call append(line(".")+7, "")
	elseif expand("%:e") == 'h'
		call SetTitleInfo(1, "/*", "*/")
 		call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
 		call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
 		call append(line(".")+8, "#endif")
	elseif &filetype == 'go' 
		call SetTitleInfo(1, "/*", "*/")
	elseif &filetype == 'python'  
        call setline(1,"#!/bin/python")
        call append(line("."),"#coding=utf-8")
		call SetTitleInfo(3, "#")
	elseif &filetype == 'sh'
 		call setline(1,"#!/bin/bash") 
		call SetTitleInfo(2, "#")
	elseif &filetype == 'lua'
 		call setline(1,"#!/bin/lua") 
 		call append(line("."), "") 
		call SetTitleInfo(3, "--[[", "  ]]")
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

