" Run a test tool with the current file and line number
" The test tool is run in the last Terminal window
let g:LastTestCommand = ""
function! RunTestTool(tool_cmd)
  let dir = system('pwd | tr -d "\n"')
  let applescript = "osascript -e '".'tell application "Terminal"'
  let applescript .= "\n"
  let applescript .= 'do script "cd '.dir.' && '.a:tool_cmd.'" in last window'
  let applescript .= "\n"
  let applescript .= 'end tell'."'"
  let g:LastTestCommand = applescript
  let foo = system(applescript)
endfunction

command! RunLastTestCommand :call RunLastTestCommand()
function! RunLastTestCommand()
  let foo = system(g:LastTestCommand)
endfunction

" If the file ends with _spec.rb, RunTestTool with rspec
" If the file ends with .feature, RunTestTool with cuke
command! RunFocusedTest :call RunFocusedTest()
function! RunFocusedTest()
  let filename = expand("%")
  if filename =~ '_spec\.rb$'
    call RunTestTool("vim_auto_rspec ".expand("%").":".line("."))
  endif
  if filename =~ '\.feature$'
    call RunTestTool("vim_auto_cucumber ".expand("%").":".line("."))
  endif
endfunction

command! RunTests :call RunTests()
function! RunTests()
  let filename = expand("%")
  if filename =~ '_spec\.rb$'
    call RunTestTool("vim_auto_rspec ".expand("%"))
  endif
  if filename =~ '\.feature$'
    call RunTestTool("vim_auto_cucumber ".expand("%"))
  endif
endfunction
