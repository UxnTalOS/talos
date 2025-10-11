(
@|repl/routines )

@REPL ( -> )
	(
	@|Read )
	.Console/read DEI
	( <\n>
	;&in-csi LDA phex/byte <\n> DUP phex/byte LIT ": \emit <\s> )
	[ LIT &comment 01 ] ?{
		DUP #29 NEQ ?{ #01 ;&comment STA }
		\emit BRK }

	DUP #28 NEQ ?{
		#00 ;&comment STA \emit BRK }

	DUP #7f NEQ ?{    ( DELETE )
		;input ;input-ptr LDA2 NEQ2 ?{
			#0718 DEO POP BRK }

		#08 \emit
		<\s>
		#08 \emit
		;input-ptr LDA2 #0001 SUB2 DUP2
		#00 ROT ROT STA
		;input-ptr STA2
		POP BRK }

	( \CSI 201~  ^[[201~   End of braketed paste off )
	DUP LIT "~ NEQ  [ LIT &in-csi-201 01 ] ORA ?{
			;&multiline LDA #00 EQU ;&multiline STA
			#01 ,&in-csi-201 STR
			POP BRK }

	( \CSI 201  ^[[201   Stage 3 of braketed paste off )
	DUP LIT "1 NEQ  ,&in-csi-20 LDR ORA ?{
			#00 ,&in-csi-201 STR
			#01 ,&in-csi-20 STR
			POP BRK }

	( \CSI 200~  ^[[200~   End of braketed paste on )
	DUP LIT "~ NEQ  [ LIT &in-csi-200 01 ] ORA ?{
			;&multiline LDA #00 EQU ;&multiline STA
			#01 ,&in-csi-200 STR
			POP BRK }

	( \CSI 200  ^[[200   Stage 3 of braketed paste on )
	DUP LIT "0 NEQ  [ LIT &in-csi-20 01 ] ORA ?{
			#00 ,&in-csi-200 STR
			#01 ,&in-csi-20 STR
			POP BRK }

	( \CSI 20  ^[[20   Stage 2 of braketed paste )
	DUP LIT "0 NEQ  [ LIT &in-csi-2 01 ] ORA ?{
			#00 ,&in-csi-20 STR
			#01 ,&in-csi-2 STR
			POP BRK }

	[ LIT &in-csi 01 ] ?{
		#01 ,&in-csi STR

		DUP LIT "2 NEQ ?{    ( \CSI 2  ^[[2   Start of braketed paste )
			#00 ,&in-csi-2 STR
			POP BRK }

		DUP LIT "A NEQ ?{    ( \CSI 41  ^[[A   UP )
			pstr: \console-cursor-up \0
			POP BRK }

		DUP LIT "B NEQ ?{    ( \CSI 42  ^[[B   DOWN )
			pstr: \console-cursor-down \0
			POP BRK }

		DUP LIT "C NEQ ?{   ( \CSI 43  ^[[D   RIGHT )
			pstr: \console-cursor-right \0
			POP BRK }

		DUP LIT "D NEQ ?{    ( \CSI 44  ^[[C   LEFT )
			pstr: \console-cursor-left \0
			POP BRK } }

	DUP #5b NEQ  ;&in-esc LDA ORA ?{    ( \CSI  ^[[   CSI )
		#00 ;&in-csi STA
		#01 ;&in-esc STA
		POP BRK }

	DUP #1b NEQ ?{    ( 1b  \e  ^[  ^3  ESC -> ESCAPE )
		#00 ;&in-esc STA
		POP BRK }

	( DUP SP NEQ ?{ POP BRK ( ignore ) } )

	DUP #03 NEQ ?{    ( 03  ^C -> ETX  END-OF-TEXT )
		#01 exit }

	DUP #04 NEQ ?{    ( 04  ^D -> EOT  END-OF-TRANSMIT )
		bye }

	DUP #0c NEQ ?{    ( 0c  ^L -> FF  FORM-FEED )
		pstr: \clear-console-screen \reset-console-cursor \0
		<print-pre-prompt>
		POP BRK }

	DUP #13 NEQ ?{    ( 0c  ^S -> DEVICE-CONTROL-3 )
		pstr: \reset-console-style \bg-0 \fg-2 \bold \0
		POP #010e DEO
		pstr: \reset-console-style \bg-0 \fg-1 \0
		LIT \n }

	DUP #0e NEQ ?{    ( 0c  ^N -> SO  SHIFT-OUT )
		;&shell-mode LDA #00 EQU ;&shell-mode STA POP

		;&shell-mode LDA ?{
			;shell-prompt pstr
			BRK }

		;prompt pstr
		BRK }

	DUP LIT "@ NEQ ?{ #01 ;&expression STA }

	[ LIT &in-esc 01 ] ?{
		#01 ,&in-esc STR

		DUPk LIT \r NEQ SWP LIT \n NEQ AND ?{
			,&multiline LDR #00 EQU ,&multiline STR } }

	DUPk LIT \r NEQ SWP LIT \n NEQ AND ?{
		[ LIT &multiline 01 ] ?{
			pstr: \reset-console-style \bold \bg-0 \fg-3 \0
			~logger/info/multiline-prompt.tal
			;multiline-prompt

			&multiline-continue ( -- )
				pstr
				pstr: \reset-console-style \bg-0 \fg-1 \0
				!&multiline-end }

			#01 ,&break STR
			POP LIT \0 }

	DUP \emit

	&multiline-end
		;input-ptr LDA2 STA
		;input-ptr LDA2 INC2 ;input-ptr STA2

		[ LIT &break 00 ] ?{ BRK }
		#00 ,&break STR

		#0000 ;length STA2
		~debugger/routines/before-eval.tal

	POP ( consume newline )

	(
	@|Eval )
	[ LIT &shell-mode 01 ] ?{
		#01 ,&shell-mode STR
		;input syscall-sync

		POP !&shell-return }

	;head-ptr LDA2 DUP2 ;prev-head STA2 STH2 ( | +prev-head* )
	<assemble> ;abort LDA ?&expr-abort
	~logger/info/summary.tal


	[ LIT &expression $1 ] ?{
		( assemble expr return jump )
		;head-ptr LDA2 STH2 ( | prev-head* +head* )
		[ LIT LIT2 ] STH2kr STA ( | prev-head* head* )
		;REPL/expr-return STH2kr INC2 STA2 ( | prev-head* -head* )
		[ LIT JMP2 ] STH2r INC2 INC2 INC2 STA ( | prev-head* )
		( reset head-ptr )
		STH2kr ;head-ptr STA2 ( | prev-head* )
		;&on-eval .Console/vector DEO2
		STH2r JMP2 } ( | -prev-head* )

	POP2r ( | -prev-head* )

	&expr-return ( -- )
		;REPL .Console/vector DEO2
		#00 ,&expression STR

	&shell-return
		#0400 #0000 ;input mzero

	(
	@|Print )
	<print-post-prompt>
	~debugger/routines/after-eval.tal
	~logger/info/stacks.tal

	(
	@|Loop )
	<print-pre-prompt> BRK

&expr-abort ( | prev-head* -- )
	~logger/warn/abort.tal
	( POP2r ( | -prev-head* ) )
	<>!
	#00 ;abort STA
	!REPL/expr-return

&on-eval ( -! )
	.Console/read DEI LIT \r NEQ ?{
		[ LIT &count $1 ] INCk ,&count STR ( +count | )

		#02 NEQ ?{ ( -count | )
			#00 ,&count STR
			!&expr-abort }

		BRK }
	( reset ) #00 ,&count STR
	BRK

@<print-pre-prompt> ( -- )
	;REPL/shell-mode ?{

	JMP2r }

	{% if ansi_escapes %}
		pstr: \CSI "m \bold \bg-0 \fg-3 \0
	{% endif %}

	( ;input ;input-ptr LDA2 NEQ2 ?{
		pstr: \console-cursor-up \0 } )

	;&prompt-start pstr
	~logger/info/prompt.tal
	;&prompt-end pstr
	
	{% if ansi_escapes %}
		pstr: \CSI "m \CSI "48;2;51;00;34m \CSI "38;2;170;170;170m \0
	{% endif %}
	
	JMP2r

	{% if ansi_escapes %}
	    &prompt-start [ "փ \s \0 ]
	{% else %}
	    &prompt-start [ "uxn \0 ]
	{% endif %}
	
	&prompt-end   [ "> \s \0 ]

@<print-post-prompt> ( -- )
	;ok !pstr

@<print-banner>
	;banner !pstr

@help ( -- )

@toogle-shell ( -- )

@syscall-sync ( cmd* -- )
	.Console/addr DEO2
	#01 .Console/exec DEO

	&sync
		.Console/live DEI #ff NEQ ?&sync
		JMP2r
