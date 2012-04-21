" TODO
" 日時の判断
" ベースディレクトリの設定
" 2ペインで起動するオプション
" 作業内容を記憶しておくコマンド

" 設定
:let g:vim_diary_debug = 0
:let g:vim_diary_basedir = expand("~/Dropbox/diary/")
:let g:vim_diary_pattern = "**/*.txt"
:let g:vim_diary_time_delay_hour = 6

:let default_template_file = "./0000-00-00.txt"

" コマンド登録
command! Diary :call  Diary()

  "strftime("%Y-%m-%d %H:%M:%S",localtime())

function! Diary()
  let today = GetTodayDiary()
  let last = GetLastDiary()
  execute (":vnew ".today)
  if(last != today)
    call ReadTemplate(last)
  endif
endfunction


function! GetTodayDiary()
  let time = localtime() - 6*60*60
  return (g:vim_diary_basedir . strftime("%Y/%m/%Y-%m-%d.txt", time))
endfunction

function! GetLastDiary()
  let query = g:vim_diary_basedir . g:vim_diary_pattern
  let filelist = expand(query)
  let files = split(filelist, "\n")

  if len(files) == 0
    return default_template_file
  endif

  return files[len(files)-1]
endfunction

" テンプレート読み込み
function! ReadTemplate(file)
  " カーソル位置保存
  let pos = getpos(".")
  let state = 0

  let array = []
  for line in readfile(a:file)
    if line =~ "^##"
      let state = 2
      call add(array, "")
      call add(array, line)

    elseif line =~ "^#"
      let state = 1
      call add(array, "")
      call add(array, line)

    elseif state != 1
      "call PrintLn(line)
      call add(array, line)
    endif
  endfor

  let text =  join(array, "\n")
  execute "normal i".text

  " カーソル位置復元
  call setpos(".",pos)
endfunction


" 保存時にファイルがなければ作成
" http://vim-users.jp/2011/02/hack202/
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}


