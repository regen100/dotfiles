if did_filetype()
  finish
endif
let s:line = getline(1)
if s:line =~? '//.*-\*- C++ -\*-'
  setfiletype cpp
endif
