# NewFileTitle

> Add title to a new file for vim plug

## installation

* Install with the `vim-plug` tool : 

  ```vim
  call plug#begin('~/.vim/plugged')
  Plug 'sunowsir/NewFileTitle'  
  call plug#end()
  ```

## Setup

* Set up author : `let g:NFT_author	= "author"`

* Set up Mail : `let g:NFT_Mail = "mail"`

* Set some languages you need to support : 

  eg.

  ```vim
  let g:NFT_support_type_Dic	= {
  			\ 'c'		: ['c'],
  			\ 'cpp'		: ['cpp', 'cxx'], 
  			\ 'go'		: ['go'],
  			\ 'sh'		: ['sh'], 
  			\ 'python'	: ['py'], 
  			\ 'lua'		: ['lua'], 
  			\}
  ```

## Show

![c](./1.png)



---

> Reference

* [ma6174](https://github.com/ma6174/vim)