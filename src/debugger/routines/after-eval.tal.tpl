(
@|debugger/after-eval )

{% if logger.level == "debug" %}
.LOG-LEVEL .Logger/warn GTH NOT ?{
	pstr: \reset-console-style \bg-0 \fg-2 \0

	.DEBUG-HEAD-PTR ?{
		{ "DEBUG: \s "head-ptr \s "after \s "eval: \s \0 }  STH2r pstr
		;head-ptr LDA2 phex <\n> }

	.DEBUG-HEAD ?{
		{ "DEBUG: \s "heap \s "after \s "eval: \n \0 }
		;heap pobj }

	.DEBUG-TAIL-PTR ?{
		{ "DEBUG: \s "tail-ptr \s "after \s "eval: \s \0 }  STH2r pstr
		;tail-ptr LDA2 phex <\n> }

	.DEBUG-TAIL ?{
		{ "DEBUG: \s "symbols \s "after \s "eval: \n \0 }
		;tail-ptr LDA2 pobj }

	.DEBUG-LENGTH ?{
		{ \n "DEBUG: \s "length \s "after \s "eval: \s \0 } STH2r pstr
		;length LDA2 pdec <\n> }

	pstr: \reset-console-style \bg-0 \fg-1 \0 }
{% endif %}
