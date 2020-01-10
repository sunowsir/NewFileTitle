" Add a title to new file for vim plugin

" 防止重复载入插件
if exists("g:loaded_NewFileTitle")
	finish
endif

" ===================================

" start flag
let g:loaded_NewFileTitle			= 1

" author string
if !exists("g:NFT_author") 
	let g:NFT_author				= ""
endif

" mail string
if !exists("g:NFT_Mail")
	let g:NFT_Mail					= ""
endif

" shell interpreter 
if !exists("g:NFT_shell_interpreter")
	let g:NFT_shell_interpreter	= "/bin/bash"
endif

" python interpreter
if !exists("g:NFT_python_interpreter")
	let g:NFT_python_interpreter	= "/bin/python"
endif

" python coding
if !exists("g:NFT_python_coding")
	let g:NFT_python_coding			= "utf-8"
endif

" lua interpreter
if !exists("g:NFT_lua_interpreter")
	let g:NFT_lua_interpreter	= "/bin/lua"
endif

" support language dictionary
if !exists("g:NFT_support_type_Dic")
	let g:NFT_support_type_Dic		= {
			\ 'c'			: ['c'],
			\ 'cpp'			: ['cpp', 'cxx'], 
			\ 'go'			: ['go'],
			\ 'sh'			: ['sh'], 
			\ 'python'		: ['py'], 
			\ 'lua'			: ['lua'], 
			\ 'vim'			: ['vim'], 
			\ 'html'		: ['html'], 
			\ 'javascript'	: ['js'], 
			\ 'css'			: ['css'], 
			\ 'php'			: ['php'], 
			\}
endif


" ===================================

" 标记是否支持该语言
let s:is_support_type		= 0

" title information list
" You can change the list to DIY new file title.
let s:insert_list			= []
call add(s:insert_list, "	* File      : ".expand("%"))
call add(s:insert_list, "	* Author    : ".g:NFT_author)
call add(s:insert_list, "	* Mail      : ".g:NFT_Mail)
call add(s:insert_list, "	* Creation  : ".strftime("%c"))


" ===================================

function! s:SetFileType()
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

	return 
endfunction


function! s:SetFileTitle()
	if &filetype == 'c' 
		call s:SetTitleInfo(1, "/*", "*/")
		call append(line(".")+6, "#include <stdio.h>")
		call append(line(".")+7, "")
	elseif &filetype == 'cpp'
		call s:SetTitleInfo(1, "/*", "*/")
		call append(line(".")+6, "#include <iostream>")
		call append(line(".")+7, "")
	elseif expand("%:e") == 'h'
		call s:SetTitleInfo(1, "/*", "*/")
 		call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
 		call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
 		call append(line(".")+8, "#endif")
	elseif &filetype == 'go' 
		call s:SetTitleInfo(1, "/*", "*/")
	elseif &filetype == 'python'  
        call setline(1,"#!".g:NFT_python_interpreter)
        call append(line("."),"#coding=".g:NFT_python_coding)
 		call append(line(".") + 1, "#") 
		call s:SetTitleInfo(4, "#")
	elseif &filetype == 'sh'
 		call setline(1,"#!".g:NFT_shell_interpreter) 
 		call append(line("."), "#") 
		call s:SetTitleInfo(3, "#")
	elseif &filetype == 'lua'
 		call setline(1,"#!".g:NFT_lua_interpreter) 
 		call append(line("."), "") 
		call s:SetTitleInfo(3, "--[[", "  ]]")
	elseif &filetype == 'vim'
		call s:SetTitleInfo(1, "\"")
	elseif &filetype == 'html' 
 		call setline(1,"<!doctype html>") 
 		call append(line("."), "<html lang=\"zh-N\">") 
		call s:SetTitleInfo(3, "<!--", "-->")
	elseif &filetype == 'javascript' 
		call s:SetTitleInfo(1, "/*", "*/")
	elseif &filetype == 'css' 
		call s:SetTitleInfo(1, "/*", "*/")
	elseif &filetype == 'php' 
		call s:SetTitleInfo(1, "/*", "*/")
	endif

	return 
endfunction


function! s:NewFileTitleMain()
	if s:SetFileType() == 1
		echo "NewFileTitle : Support file type list is empty."
		return 1
	endif

	if s:is_support_type == 0 
		echo "NewFileTitle : Don\'t support file type."
		return 2
	endif

	call s:SetFileTitle()
	exec 'normal G'
	
	return 0
endfunction

" ===================================


autocmd BufNewFile * call s:NewFileTitleMain()



