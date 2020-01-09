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

  > The currently supported languages are: c、c++、go、bash、python、lua、vimscript

  eg.

  ```vim
  let g:NFT_support_type_Dic	= {
  			\ 'c'		: ['c'],
  			\ 'cpp'		: ['cpp', 'cxx'], 
  			\ 'python'	: ['py'], 
  			\}
  ```

## Show

![c](./1.png)



---

> Reference

* [ma6174](https://github.com/ma6174/vim)