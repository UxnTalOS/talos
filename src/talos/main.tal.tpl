(
@|talos/main )

@Main ( -> )
	(
	@|setup )

	(
	&|metadata )
	;meta #06 DEO2

	(
	&|symbols )
	( Move the symbols before the input buffer. )
	;tail/end ;tail SUB2 STH2k #0000 ;head #0000 ( | len* )
	;syms STH2kr SUB2 STH2k mcpyl ( | len* dst* )
	SWP2r STH2r #0000 ;head mzero ( | dst* )

	(
	&|pointers )
	STH2r ;tail-ptr STA2 ( | )
	;head ;head-ptr STA2
	;input ;input-ptr STA2

	(
	&|theme )
	\RED   .System/r DEO2
	\GREEN .System/g DEO2
	\BLUE  .System/b DEO2

	{% if ansi_escapes %}
		pstr: [
			\bg-0 \fg-1 \clear-console-screen-right  \n \n \n \n \n \n
			\console-cursor-up \console-cursor-up \console-cursor-up
			\console-cursor-up \console-cursor-up \console-cursor-up \0 ]
	{% endif %}
	
	(
	@|startup )
	.PRINT-BANNER ?{
		<print-banner> }
		
		{% if ansi_escapes %}
			pstr: \italic \underline \bold \fg-3 \0
		{% endif %}
		
		free

		{% if ansi_escapes %}
			pstr: \reset-console-style \bg-0 \fg-1 \n \0
		{% endif %}

		~../config/startup.tal
		<print-pre-prompt>

	&no-first-prompt
		{% if ansi_escapes %}
			pstr: \enable-braketed-paste \0
		{% endif %}
		;REPL .Console/vector DEO2
		BRK
