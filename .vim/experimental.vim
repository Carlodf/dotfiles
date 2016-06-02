nnoremap <leader>z :call <SID>FunctionIndent()<cr>

function! s:FunctionIndent()
    "Save search history
    let s:saved_search_history=@/
    "Save cursor position
    let s:l = line(".")
    let s:c = col(".")
    "Save registers content
    let s:saved_b_register=@b
    let s:saved_e_register=@e
    let s:saved_unnamed_register=@@
    "Go to beginning of line
    :execute "normal! ^\<cr>"
    "Move to first argument in function and save position
    :execute ":silent normal! /(\<cr>"
    :execute "normal! wmb"
    "Go to closing parenthesis and save position
    :execute ":silent normal! " . '/\v\)\s*(const)?\s*$' . "\<cr>"
    :execute "normal! me"
    "Yank list of arguments
    :execute "normal! `bv`ey"
    :let s:string=@@
    :echo split(s:string, '\W\+,')
    "Bring cursor back to initial position
    call cursor(s:l, s:c)
endfunction
