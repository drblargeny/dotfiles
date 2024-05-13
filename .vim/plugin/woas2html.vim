function! Woas2Html() range
	" Remove TOC entries
	%s/\[\[Special::TOC\]\]//ge

	" heading substitutions
	%s/^=====\s\?\(.*\)/<h5>\1<\/h5>/e
	%s/^====\s\?\(.*\)/<h4>\1<\/h4>/e
	%s/^===\s\?\(.*\)/<h3>\1<\/h3>/e
	%s/^==\s\?\(.*\)/<h2>\1<\/h2>/e
	%s/^=\s\?\(.*\)/<h1>\1<\/h1>/e

	" Pre-formatted text substitutions
	%s/\(<pre>\|<code>\){{{/\1/eg
	%s/}}}\(<\/pre>\|<\/code>\)/\1/eg
	%s/{{{\([^}]\+\)}}}/<code>\1<\/code>/eg
	%s/{{{/<pre>/eg
	%s/}}}/<\/pre>/eg
	%s/\(<pre>\|<code>\){{{/\1/e
	
	" list handling
	" TODO There's a bug in this somewhere
	%s/^\([^#].*\)\n#/\1<ol>#/e
	%s/^\([^*].*\)\n\*/\1<ul>\*/e

	%s/^\(#.*\)\n\([^#]\|$\)/\1<\/ol>\2/e
	%s/^\(\*.*\)\n\([^*]\|$\)/\1<\/ul>\2/e

	%s/^\(#*\)#\s\?\(.*\)/\1<li>\2<\/li>/e
	%s/^\(\**\)\*\s\?\(.*\)/\1<li>\2<\/li>/e

	" second-level list handling
	for i in [0,1,2,3,4]
		%s/^\(<li>.*\)<\/li>\n#/\1<ol>#/e
		%s/^\(#.*<\/li>\)\n\([^#]\|$\)/\1<\/ol><\/li>\2/e
		%s/^#\(#*<li>.*\)/\1/e

		%s/^\(<li>.*\)<\/li>\n\*/\1<ul>#/e
		%s/^\(\*.*<\/li>\)\n\([^*]\|$\)/\1<\/ul><\/li>\2/e
		%s/^\*\(\**<li>.*\)/\1/e
	endfor

	" entity replacement
	%s/&/&amp;/ge
	%s/\%U2018/\&lsquo;/ge
	%s/\%U2019/\&rsquo;/ge

	" hyperlink replacement
	%s/\[\[\([^|]\+\)|\([^\]]\+\)\]\]/<a href="\1">\2<\/a>/ge
	%s/\[\[\([^\]]\+\)\]\]/<a href="\1">\1<\/a>/ge

	" Table replacement
	%s/^{|\s*$/<table>/e
	%s/^|}\s*$/<\/table>/e
	:try
		%g/^|\s\+/s/||/<\/td><td>/ge
	:endtry
	%s/^|\s\+\(.*\)/<tr><td>\1<\/td><\/tr>/e
	%s/<td>\s*\*\([^*]\+\)\*\s*<\/td>/<th>\1<\/th>/ge
endfunction

command! -range=% Woas2Html :<line1>,<line2>call Woas2Html()
