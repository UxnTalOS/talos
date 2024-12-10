{% if print_banner %}ENABLE{% else %}DISABLE{% endif %} @PRINT-BANNER

( GUI )
%\RED   { #{{ theme.gui.red }} }
%\GREEN { #{{ theme.gui.green }} }
%\BLUE  { #{{ theme.gui.blue }} }

( TUI )
%\BACKGROUND { "{{ theme.tui.red.background }};  "{{ theme.tui.green.background }}; "{{ theme.tui.blue.background }}  }
%\FOREGROUND { "{{ theme.tui.red.foreground }}; "{{ theme.tui.green.foreground }}; "{{ theme.tui.blue.foreground }} }
%\EMPHASIS   { "{{ theme.tui.red.emphasis }}; "{{ theme.tui.green.emphasis }}; "{{ theme.tui.blue.emphasis }}  }
%\ERROR      { "{{ theme.tui.red.error }}; "{{ theme.tui.green.error }}; "{{ theme.tui.blue.error }} }

( LOGGER )
{{ logger.level | upper }} @LOG-LEVEL 

( INFO )
{% if logger.info.stacks %}ENABLE{% else %}DISABLE{% endif %} @INFO-STACKS
{% if logger.info.prompt %}ENABLE{% else %}DISABLE{% endif %} @INFO-PROMPT
{% if logger.info.summary %}ENABLE{% else %}DISABLE{% endif %} @INFO-SUMMARY 

( WARN )
{% if logger.warn.abort %}ENABLE{% else %}DISABLE{% endif %} @WARN-ABORT
{% if logger.warn.redef %}ENABLE{% else %}DISABLE{% endif %} @WARN-REDEF
{% if logger.level == "debug" %}
( DEBUG )
{% if logger.debug.length %}ENABLE{% else %}DISABLE{% endif %} @DEBUG-LENGTH
{% if logger.debug.head_ptr %}ENABLE{% else %}DISABLE{% endif %} @DEBUG-HEAD-PTR
{% if logger.debug.tail_ptr %}ENABLE{% else %}DISABLE{% endif %} @DEBUG-TAIL-PTR
{% if logger.debug.input %}ENABLE{% else %}DISABLE{% endif %} @DEBUG-INPUT 
{% if logger.debug.heap %}ENABLE{% else %}DISABLE{% endif %} @DEBUG-HEAD
{% if logger.debug.symbols %}ENABLE{% else %}DISABLE{% endif %} @DEBUG-TAIL
{% endif %}