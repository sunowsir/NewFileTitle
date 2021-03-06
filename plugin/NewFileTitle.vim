" Add a title to new file for vim plugin

" ===================================

" 防止重复载入插件
if exists("g:loaded_NewFileTitle")
	finish
else 
    " start flag
    let g:loaded_NewFileTitle			= 1
endif


" default code.
if !exists("g:NFT_default_code") 
	let g:NFT_default_code = {
		\ 'c'		: ['#include <stdio.h>', ''], 
		\ 'cpp'		: ['#include <iostream>', ''], 
		\ 'h'		: [ 
						\ "#ifndef _" . toupper(expand("%:r")) . "_H", 
						\ "#define _" . toupper(expand("%:r")) . "_H", 
						\ "#endif", 
						\ ], 
		\ 'sh'		: ['#!/bin/bash', '#'], 
		\ 'python'	: ['#!/bin/python', '#coding=utf-8', '#'], 
		\ 'lua'		: ['#!/bin/lua', ''], 
		\}
endif

" show informaion list
if !exists("g:NFT_normal_info") 
	let g:NFT_normal_info = [
		\ "\t* File     : " . expand("%s"), 
		\ "\t* Author   : *", 
		\ "\t* Mail     : *", 
		\ "\t* Creation : " . strftime("%c"), 
		\ ]
endif

" support language dictionary
if !exists("g:NFT_support_type")
	let g:NFT_support_type = {
		\ 'c'			: ['c'],
		\ 'cpp'			: ['cpp', 'cxx'], 
		\ 'go'			: ['go'],
		\ 'sh'			: ['sh'], 
		\ 'python'		: ['py'], 
		\ 'lua'			: ['lua'], 
		\ 'vim'			: ['vim'], 
		\}
endif


" ===================================

" 标记是否支持该语言
let s:is_support_type		= 0

" title information list
let s:insert_list = g:NFT_normal_info

" 默认代码列表
let s:default_list = g:NFT_default_code

" 文件后缀支持列表
let s:support_list = g:NFT_support_type


" ===================================


"让vim识别新文件后缀。
function! s:SetFileType()
	if empty(s:support_list)
		return 1
	endif

	for [key, values] in items(s:support_list)
		if key == &filetype
			let s:is_support_type = 1
		endif
		for suffix in values
			au BufRead,BufNewFile *.key set filetype=suffix
		endfor
	endfor

	return 0
endfunction


" 从第StartLineNum行开始使用指定注释符号插入标题信息。
function! s:SetTitleInfo(StartLineNum, ...) 
	let l:index = a:StartLineNum - 2

	if a:0 == 1 || a:0 == 2 
		let l:Comment_Symbol_1 = a:1
		if a:0 == 2
			let l:Comment_Symbol_2 = a:2
		endif
	else 
		return 1
	endif

	if a:0 == 2 
		if l:index == -1 
			call setline(1, l:Comment_Symbol_1) 
		else 
			call append(line(".") + l:index, l:Comment_Symbol_1)
		endif
		let l:index += 1
	endif

	for i in s:insert_list
		let l:add_str = a:0 == 1 ? l:Comment_Symbol_1.i : i
		if l:index == -1 
			call setline(1, l:add_str) 
		else 
			call append(line(".") + l:index, l:add_str)
		endif
		let l:index += 1
	endfor

	if a:0 == 2
		call append(line(".") + l:index, l:Comment_Symbol_2)
	endif
	call append(line(".") + l:index + 1, "")

	return l:index + 2
endfunction


" 为filetype类型文件从start_index行开始插入默认代码。
function! s:Add_default_code(filetype, start_index)
	if !has_key(s:default_list, a:filetype)
		return 
	endif

	let l:index = a:start_index
	for def_code in s:default_list[a:filetype]
		if l:index == -1
			call setline(1, def_code)
		else 
			call append(line(".") + l:index, def_code)
		endif
		let l:index += 1
	endfor
endfunction


" Set new file title according to different types of files.
function! s:SetFileTitle()
	if expand("%:e") == 'h'
		let line = s:SetTitleInfo(1, "/*", "*/")
		call s:Add_default_code(expand("%:e"), line)
	elseif &filetype == 'c' 
		let line = s:SetTitleInfo(1, "/*", "*/")
		call s:Add_default_code(&filetype, line)
	elseif &filetype == 'cpp'
		let line = s:SetTitleInfo(1, "/*", "*/")
		call s:Add_default_code(&filetype, line)
	elseif &filetype == 'go' 
		let line = s:SetTitleInfo(1, "/*", "*/")
		call s:Add_default_code(&filetype, line)
	elseif &filetype == 'python'  
		call s:Add_default_code(&filetype, -1)
		call s:SetTitleInfo(4, "#")
	elseif &filetype == 'sh'
		call s:Add_default_code(&filetype, -1)
		call s:SetTitleInfo(3, "#")
	elseif &filetype == 'lua'
		call s:Add_default_code(&filetype, -1)
		call s:SetTitleInfo(3, "--[[", "  ]]")
	elseif &filetype == 'vim'
		let line = s:SetTitleInfo(1, "\"")
		call s:Add_default_code(&filetype, line)
	elseif &filetype == 'html'
		call s:Add_default_code(&filetype, -1)
		call s:SetTitleInfo(3, "<!--", "-->")
	endif
	
	return 
endfunction


" Main function.
function! s:NewFileTitleMain()
	call s:SetFileTitle()

	" 插入标题信息和默认代码之后，跳转到最后一行。
	exec 'normal G'
	
	return 0
endfunction


" ===================================


"当打开新文件的时候，调用NewFileTitleMain()主函数。
autocmd BufNewFile * call s:NewFileTitleMain()



