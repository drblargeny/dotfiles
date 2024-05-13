function! Pre() range
	" Replace non-html characters
	silent! execute a:firstline.','.a:lastline.'!xmlstarlet escape'

	" Wrap selection in <pre> tag suitable for inclusion in HD calls
	let s:failed = append(a:lastline, "</pre>")
	let s:failed = append(a:firstline - 1, "<pre style=\"font-size: 8pt; width=80em; white-space: pre-wrap; \">")

	" TODO Consider doing HTML escaping
endfunction

command! -range=% Pre :<line1>,<line2>call Pre()
