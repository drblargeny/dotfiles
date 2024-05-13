function! SBC() 
	%g/^$/d
	%s/,//ge
	%s/\s\+//ge
	%s/^\(.*\)/public static final String \1 = "\1"; public static final String \1_ASC = \1 + ASC; public static final String \1_DESC = \1 + DESC;/g
endfunction

command! SBC :<line1>,<line2>call SBC()
