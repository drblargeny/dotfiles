function! Sql() range
	" Scan the range to see if this looks like Java, e.g. var.append(
	let s:fromJava = 0
	for s:i in range(a:firstline, a:lastline)
		let s:line = getline(s:i)
		if match(s:line, "\\.append\\(ln\\)\\?(") >= 0
			let s:fromJava = 1
			break
		endif
	endfor

	" Setup buffers
	" Original - current file
	let s:orig = bufnr("%")

	" Temp - for processing the data
	new sql_temp
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
	let s:temp = bufnr("sql_temp")

	echo "Orig:" s:orig "Temp:" s:temp "From Java:" s:fromJava

	" Copy original into temp buffer
	let s:failed = append(1, getbufline(s:orig, a:firstline, a:lastline))
	silent! 1,1d

	" Perform operations in temp buffer
	if s:fromJava == 0
		" Convert from SQL to Java
		silent! %g/^.\+\/\*[^+].*\*\/\s*$/s/\/\*/\/*/ge
		silent! %s/^\s\+//e
		" Split baan tables
		silent! %s/\(baan\.t[a-z]\{5\}\d\{3}\)\(\d\{3}\)\s*\n\?/\1\r\2\r /ige
		silent! %s/\\/\\\\/ge
		silent! %s/"/\\"/ge
		silent! %g!/^\/\*[^+]/s/^/sql.append("/e
		silent! g!/\c\(^\|\s\|baan.t[a-z]\{5}\d\{3}\)$/s/$/ /e
		silent! %g!/^\/\*/s/$/");/e
		silent! %s/--/\/\//e
	else
		" Convert from Java to SQL
		" 0. Convert SqlBuilderUtils.appendColumnValueConstraints() into SQL
		silent! %s/SqlBuilderUtils\.appendColumnValueConstraints([^,]\+,[^,]\+,\([^,]\+\),\([^,]\+\),\([^,]\+\),[^,]\+);/\=substitute(submatch(1), "^\\s*\"\\s*\\|\\s*\"\\s*$", "", "g")." = :".substitute(submatch(2), "^\\s*\"\\s*\\|\\s*\"\\s*$", "", "g")." ".substitute(submatch(3), "^\\s*\"\\s*\\|\\s*\"\\s*$", "", "g")." ".substitute(submatch(1), "^\\s*\"\\s*\\|\\s*\"\\s*$", "", "g")." = :".substitute(submatch(2), "^\\s*\"\\s*\\|\\s*\"\\s*$", "", "g")."1"/eg
		" 1. Remove preceding space
		silent! %s/^\s\+//e
		" 2. Remove sql.append(
		silent! %s/^\s*\w\+\(\s\|\n\)*\.append\(ln\)\?('\?//e
		" 3. Remove ); but leave trailing comments behind
		silent! %s/\s*'\?)\s*;\s*\(\/\/.*\)\?$/\1/e
		" 4. Remove starting "
		silent! %s/^"//e
		" 5. Remove ending ' but leave trailing comments behind
		silent! %s/"\s*\(\/\/.*\)\?$/\1/e
		" 6. Unescape double quotes
		silent! %s/\\"/"/eg
		" 7. Remove blank lines
		silent! %g/^\s*$/d
		" 8. Convert // comments to -- comments
		silent! %s/\/\//--/e
		" 9. Remove references to SqlConstants.
		silent! %s/SqlConstants\.//ge
		" 10. Convert _ to space in INNER_JOIN and OUTER_JOIN
		silent! %s/\<\(INNER\|OUTER\)_JOIN\>/\1 JOIN/ge
		" 11. Convert Baan tables 
		silent! %s/\(baan\.t[a-z]\{5}\d\{3}\)\n\(\d\{3}\)/\1\2/ige
		silent! %s/\(baan\.t[a-z]\{5}\d\{3}\)\n\([^0-9&:]\)/\1\&\&\2/ige
	endif

	" Copy temp back to original
	exec "b ".s:orig
	let s:failed = append(a:lastline, getbufline(s:temp, 1, "$"))
	exec a:firstline "," a:lastline "d"

	" Always destroy the temp buffer
	exec "b ".s:temp
	bd

endfunction

command! -range=% Sql :<line1>,<line2>call Sql()
