" TODO
" 日時の判断
" ベースディレクトリの設定
" 2ペインで起動するオプション
" 作業内容を記憶しておくコマンド


:let g:vim_diary_debug = 1
:let g:vim_diary_basedir = "~/Dropbox/diary"

command! Test :call TestFunc()

function! TestFunc()
  :let dir = expand(g:vim_diary_basedir)
  :echo system("ls")
endfunction

" TODO 実際はテンプレートは前の日の日記にしたい
if !exists('g:vim_diary_template_file')
  :let g:vim_diary_template_file = "./00.txt"
endif

" これ絶対他に方法あるはず
function! PrintLn(line)
  if g:vim_diary_debug
    :echo a:line
    return
  endif

  execute "normal i" . a:line
  execute "normal o"
endfunction

" テンプレート読み込み
function! ReadTemplate(file)
  " カーソル位置保存
  :let pos = getpos(".")
  :let state = 0

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

