syn match  insInsTag  "<ins>\|<\/ins>" contained
syn match  insSTag    "<s>\|<\/s>"
syn region insString  start="<ins>" end="<\/ins>" keepend contains=insInsTag

hi link insString String
hi link insSTag   Statement
hi link insInsTag Statement
