syn include @markdown syntax/markdown.vim
syn match  insTag     "<ins>\|<\/ins>" contained
syn match  insTag     "<s>\|<\/s>" contained
syn match  insTag     "<res>\|<\/res>" contained
syn region insResult  start="<res>" end="<\/res>" keepend contains=insTag,@markdown contained
syn region insString  start="<ins>" end="<\/ins>" keepend contains=insTag contained
syn region insSession start="<s>" end="<\/s>\ze" contains=insTag,insString,insResult,@markdown
syn region insComment start="<!--" end="-->"

hi link insString     String
hi link insTag        Statement
hi link insComment    Comment
