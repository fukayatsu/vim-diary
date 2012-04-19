" デバッグ用
if !exists(g:vim_diary_template_file)
  :let g:vim_diary_template_file = "00.txt"
endif

function! PrintLn(line)
  execute "normal i" . a:line
  execute "normal o"
endfunction

" テンプレート読み込み
function! ReadTemplate(file)
  " カーソル位置保存
  :let pos = getpos(".")
  :let state = 0

  " 1行ごとに処理して追加
  " TODO なんか遅いので他にちゃんとした方法があるはず
  for line in readfile(a:file)
    if line =~ "^##"
      :let state = 2
      :call PrintLn(line)

    elseif line =~ "^#"
      :let state = 1
      :call PrintLn(line)

    elseif state != 1
      :call PrintLn(line)
    endif
  endfor

  " カーソル位置復元
  :call setpos(".",pos)
endfunction

" コマンド登録
command! Diary :call ReadTemplate(g:vim_diary_template_file)

