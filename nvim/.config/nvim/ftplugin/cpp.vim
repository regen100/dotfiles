" find build dir
let s:root_dir = getcwd()
while 1
  if filereadable(s:root_dir . '/CMakeLists.txt')
    let s:found = 0
    for s:build_dir in [s:root_dir . '/build', s:root_dir . '/../build']
      if isdirectory(s:build_dir)
        let g:build_dir = fnamemodify(s:build_dir, ':p:h')
        let &l:makeprg = 'cmake --build ' . shellescape(g:build_dir) . ' --target'
        let s:found = 1
        break
      endif
    endfor
    if s:found | break | endif
  endif
  if s:root_dir ==? '/' | break | endif
  let s:root_dir  = fnamemodify(s:root_dir, ':h')
endwhile
