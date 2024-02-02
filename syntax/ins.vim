syn match  insInsTag  "<ins>\|<\/ins>" contained
syn match  insSTag    "<s>\|<\/s>"
syn region insString  start="<ins>" end="<\/ins>" keepend contains=insInsTag
syn region insComment start="<!--" end="-->"

hi link insString  String
hi link insSTag    Statement
hi link insInsTag  Statement
hi link insComment Comment
