function ale_linters#cpp#clangtidy_h#GetCommand(buffer)
  if expand('#' . a:buffer) =~# '\v\.(h|hpp)$'
    return ''
  endif

  return ale_linters#cpp#clangtidy#GetCommand(a:buffer) . ' -extra-arg=-D__clang_analyzer__'
endfunction

call ale#linter#Define('cpp', {
      \   'name': 'clangtidy_h',
      \   'output_stream': 'stdout',
      \   'executable_callback': 'ale_linters#cpp#clangtidy#GetExecutable',
      \   'command_callback': 'ale_linters#cpp#clangtidy_h#GetCommand',
      \   'callback': 'ale#handlers#gcc#HandleGCCFormat',
      \   'lint_file': 1,
      \})
