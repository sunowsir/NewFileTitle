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

* Setup author : `let g:NFT_author = "author"`

* Setup Mail : `let g:NFT_Mail = "mail"`

* Add python's coding: `let g:NFT_python_coding = "utf-8"`

* Add some languages interpreter :

  >   Only setting shell、python and lua are supported.

  *   eg. 

      ```vim
      let g:NFT_shell_interpreter		= "/bin/bash"
      let g:NFT_python_interpreter	= "/bin/python"
      let g:NFT_lua_interpreter		= "/bin/lua"
      ```

      

  

  

* Set some languages you need to support : 

  > The currently supported languages are:  c、c++、go、shell、python、lua、vimscript、html、css、javascript、php

  * let g:NFT_support_type_Dic   =   ['language file type' :  ['suffix'],  ]

  * eg.

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