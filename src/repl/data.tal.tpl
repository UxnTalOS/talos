(
@|repl/data )

{% if ansi_escapes %}
	@banner [
		\bold \bg-1 \fg-0 MARGIN \n

		\s \s \bg-2 \s \s \s \underline "/ \s \reset-console-style \bold \bg-1 \fg-0
		\s \s \bg-3 \fg-1 \s \s "⋃ \s "⨉ \s "⋂ \s \s \bg-0 \fg-3 \s \s NAME \s
		\s \bg-2 \fg-0 \s \s "v VERSION \s 28 DATE 29 \s \s \bg-1 \fg-0 \s \s \n

		\s \s \bg-2 \underline "/ \s \reset-console-style \bold \bg-2 \fg-0 "/ \s "/
		\bg-1 \s \s \s \s \s "©2024 \s AUTHOR \s \s \s \s \s \n

		\s \s \bg-2 \s "/ \s \s \s \bg-1 \s \s \s \s "Type \s \bold \italic \fg-3 "help
		\reset-console-style \bold \bg-1 \fg-0 \s "for \s "more \s "information. \s \s
		\s \s \n

		MARGIN \n

		\reset-console-style \bg-0 \fg-1 \0 ]

	@ok [ ( \underline \fg-3 ) \n \n \0 ]

	@shell-prompt [
		\r \s \s \s \s \s \s \s \s \s \r \bg-0 \fg-2 \bold "sh \s "> \s
		\reset-console-style \bg-0 \fg-1 \0 ]

	@prompt [
		\r \s \s \s \s \r \bg-0 \fg-3 \bold "փ \s "> \s
		\reset-console-style \bg-0 \fg-1 \0 ]

	@prompt-start [ "փ \s \0 ]
	@multiline-prompt [ \n "... \s \0 ]
{% else %}
	@banner [
		\n \s \s \s \s \s "/_ \s \s "UXN \s \s \s \s \s NAME \s \s \s \s 
		\s "v VERSION \s 28 DATE 29 \n

		\s \s "/_/ \s "/ \s \s "(c)2024 \s AUTHOR \n

		\s \s \s "/ \s \s \s \s \s "Type \s "help \s "for \s "more \s 
		"information. \n \n \0 ]

	@ok [ \n \n \0 ]	

	@shell-prompt \n \n "sh \s "> \s \0

	@prompt [ "uxn \s "> \s \0 ]
	@prompt-start [ "uxn \0 ]
	@multiline-prompt [ \n \s "... \s \0 ]
{% endif %}

@prompt-end   [ "> \s \0 ]
