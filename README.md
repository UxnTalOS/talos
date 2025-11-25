# TalOS — Version 0.11 (18P07) ![example branch parameter](https://github.com/Ismael-VC/talos/actions/workflows/makefile.yml/badge.svg?branch=main)

## Theme

| # |     Name     |     RGB      |     Decimal     |          Use           |
|---|--------------+--------------|-----------------|------------------------|
| 0 | Dark Purple  | #302 #330022 | (51,  0,   34 ) | Background Dark Theme  |
| 1 | Light Grey   | #cbb #ccbbbb | (204, 187, 187) | Foreground             |
| 2 | Light Orange | #e75 #ee7755 | (238, 119, 55 ) | High Emphasis          |
| 3 | Light Purple | #959 #995599 | (153, 85,  153) | Normal Emphasis        |
| 4 | Mid Purple   | #424 #442244 | (68,  34,  68 ) | Background Light Theme |

## Tested Environments

| **Android 13** | Status | Issues |
|----------------|--------|--------|
| Termux         | ✅     |        |

| **Ubuntu (WSL2)** | Status | Issues                                            |
|-------------------|--------|---------------------------------------------------|
| XTerm             | ✅     | 🛈 TrueType Fonts need to be enabled for unicode. |
| Cool Retro Term   | ✅     |                                                   |

| **Windows 11**   | Status | Issues                                            |
|------------------|----|-------------------------------------------------------|
| Alacritty        | ✅ | 🚩 Pasting multiple lines inserts extra white space. |
| VSCode Terminal  | ✅ | ⚠️ Sometimes deleting multiple characters rapidly while holding `Del` breaks the line editor. |
| Windows Terminal | ✅ |                                                      |

## Varavara's UxnTal Operating System

Memory is organized as follows:

```
               #ffff
         +----------------+
         |  Input Buffer  |  ( 1 Kb )
         +----------------+
   G     | Kernel Buffers |
   R  +--+======@pit======+  #fc00
   O  |  |  Symbols List  |
   W  |  |----------------*-->@pit-ptr
   T  |  |                |
   H  ⋁  |                |
         |                |
   D     |  Free Memory   |
   I     |                |
   R  ⋀  |                |
   E  |  |                |
   C  |  |----------------*-->@heap-ptr
   T  |  |   User Code    |
   I  +--+=====@heap======+
   O     |     Kernel     |
   N     +----------------+  #0100
         |   Zero Page    |  ( 256 B )
         +----------------+
               #0000
```
# Hosts

- Windows 11/WSL2
  * Linux 5.15.153.1-microsoft-standard-WSL2 #1 SMP x86_64 GNU/Linux
- Windows 11/MSYS2
  * MINGW64_NT-10.0-22631 3.5.4-0bc1222b.x86_64 x86_64 Msys
- Android 13/Termux
  * Linux 4.14.186-27210951 #1 SMP PREEMPT armv8l Android
- Android Go
  * Linux 4.14.193-ab21113 #1 SMP PREEMPT armv7l Android

# Operator Interaction

![image](https://github.com/user-attachments/assets/8e2a198a-2a02-4326-a43e-6d7b68e4e10a)

```

     /_    ⋃ ⨉ ⋂    TalOS    v0.10 (18P02)
  /_/ /     ©2024 Ismael Venegas Castelló
   /       Type help for more information.

56664 bytes free.

փ > #2a18 DEO
*
փ > @star #2a18 DEO JMP2r

փ > star
*
փ >
```

## Under the Hood

A parent label starts assembly mode, this will do the following:

1. Assemble the input buffer and place the code after the current position
   of `@here`, and update the `@here` pointer.
2. Add an entry to the "dictionary" ("header" format still under design) and
   update it's pointer.

**Note**: `[` and `]` allow multiline input.

```
փ > @star ( -- )
...   [ LIT2 "* -Console/write ] DEO
...   JMP2r

փ > star
*

փ >
```

**Doubts**:
* `star` JSI semantics (but not syntax) will need to be adapted to jump
to an absolute address in REPL mode?
* How to allow multiline input without using `[ ]`?

### `@heap`

The assembled code area will be concatenated as if assembling Uxntal normally.

```
| @heap-ptr ( 1337 )
| a0 2a 18 17 6c  ( #2a18 DEO JMP2r )
|
∨ @heap-ptr ( 133c )
```

### `@pit`

The dictionary will grow in the contrary direction at a constant size for each
entry. Instead of a linked list in tipycal Threaded Interpretive Languages
(TILs), concatenating in inverse order to an array. When searching for a routine
searching from **last entry** to first as done by TILs is accomplished by
starting the search from the "physical beginning" of the array, where the
current `@pit-ptr` points to.

```
∧ @pit-ptr ( ????-n entry bytes )
|
| identifier                           addr
| s  t  a  r  ( pad to n max bytes )   1337
| 73 74 61 72 00 00 00 00 00 00 00 00  13 37
| @pit ( ???? )
```

## ANSI Control Codes

| Feature             | Code |
|---------------------|------|
| bold                |   1  |
| Secondary color     |   2  |
| Itallic             |   3  |
| Underline           |   4  |
| Blinking            |   5  |
| Inverted background |   7  |
| Hidden              |   8  |
| Striked through     |   9  |

### Support

|             Environment               | 1 | 2 | 3 | 4 | 5 | 7 | 8 | 9 |
|---------------------------------------|---|---|---|---|---|---|---|---|
| *Windows 11 (__22631.3880__)</br> Windows Terminal (__1.20.11781.0__) </br> WSL2 (__2.2.4.0__) </br> Ubuntu (__22.04.4 LTS__) </br> dash (__0.5.11+git20210903+057cd650a4ed-3build1__)* | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| *Windows 11 (__22631.3880__) </br> Chrome Browser (__126.0.6478.182__) </br> Developer Tools*     | :x: | :x: | :heavy_check_mark: | :heavy_check_mark: | :x: | :heavy_check_mark: | :x: | :heavy_check_mark: |


## Reasoning

Concatenating instead of threading the routines allows for the usage of Uxntal
and not another Uxntal like language with new or different syntax though some
semantics may need to be adapted.

```
փ > :paste
INFO: Multiline paste mode enabled.

փ > @<pdec> ( dec* -- )
...   DUP #64 DIV <pnum>/try
...   DUP #0a DIV <pnum>/try
...   ( >> )
...
... @<pnum> ( num* -- )
...   #0a MOD [ LIT "0 ] ADD .Console/write DEO
...   JMP2r
...
...   &try ( num* -- )
...     DUP ?<pnum>
...     POP JMP2r
... ( Alt+Enter: Evaluate multiline input )

փ > :paste
INFO: Multiline paste mode disabled.

փ > #002a pdec  ( Enter: Evaluate line input )
42

փ >
```

In this case calling `<pdec>` would fall through to `<pnum>` body as in normal
Uxntal, something that would not be possible with a tipical threaded
implementation.

# Drifblim VS drifloon

## Zero Page
- Drifblim uses Console and File, drifloon only Console.
- loon uses `@token $2` while blim uses `@token $1 buf $30`.

## on-init
- loon uses `<assemble>` and `<read>`.
- blim uses only `<assemble>` on files.

## TODO

- [x] Return to repl when when evaluating break `BRK` expression, by pressing
      Enter 3 times.
- [x] `#foo!` should be a Number error (fixed in drifblim).
- [x] Fix `key` routine.
- [x] Reinstate include rune.
- [x] Refactor into something better the file hierarchy.
- [x] Implement log level.
- [x] Fix lambda syms, not being the same as with uxnasm.
- [x] Implement library path. (not possible due to sandbox)
- [x] Make rom smaller (no unused space in between code/data).
- [x] Make multiline more robust.
- [ ] Reset symbols and heap after expression evaluation.
- [ ] Fix memory usage.
- [ ] Add print strings with underscore as spaces routine.
- [ ] Clear heap and symbols after error.
- [ ] Reset PC after absolute padding expression.
- [ ] Keep trak of ZP pointer.
- [ ] Check memory limits ZP, input buffer, head and tail, before writing.
- [ ] Log session.
- [ ] Make multiline more robust with rlwrap.
- [ ] Use walkcomment and allow nesting.
- [ ] Make `pmem` take the lenght to dump.
- [ ] Make symbols store code length.
- [ ] Implement macros.
- [ ] Make logging toggleable.
- [ ] `[]`, `{}`, `()` parse these correctly. (take strings into account.)
- [ ] Comment out debugging for release.
- [ ] Remove uneeded experiments.
- [ ] Integrate disassembler.
- [ ] Restore stacks without `:!` when aborting from all errors!
- [ ] Fix: abort early.
- [ ] add a console vector when syscall awaiting to kill child process??
- [ ] Crear destroys previoszshell log history instead of just "advancing" the screen
- [ ] translate tabs to n spaces.
- [ ] make shell mode a config option so as not to have to recover 
from BRK if not using uxn11's uxncli extension.
- [ ] allow capturing syscall output out/err or ignore it.
- [ ] fix unable to delete in comment CRITICAL!!!
- [ ] get exit code of child
- [ ] during syscall signals are ignored because talos starts in raw
tty mode, probably solved by saving tty settisgs, setting stty sane, and then restoring the tty settings in uxn11's uxncli...

...exiting htop is possible in the following command with ^C but it exits talos as well, need to test if passing through signals while awaiting the child process to finish, would kill talos as well or just the child as desired.
```
sh > STTY=$(stty -g) && stty sane && htop && stty "$STTY"
```
but wait I can exit
```
փ [140e]> snathoue
ERROR: Unknown reference: snathoue in expression.
ERROR: Aborting...
INFO: Assembled expression in 3 bytes.
WST 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00|<
RST 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00|<

փ [140e]> #23434
ERROR: Number #23434 in expression.
ERROR: Number #23434 in expression.
ERROR: Aborting...
INFO: Assembled expression in 1 bytes.
WST 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00|<
RST 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00|<
```

- [ ] Show length of padding as well:


```
փ [13fc]> @foo $1
WST 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00|<
RST 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00|<

փ [13fd]> @bar #01 ,foo STR JMP2r
Assembled bar in 6 bytes.
WST 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00|<
RST 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00|<
```
- [ ] print own symbols
- [ ] Enable switching in and out of evaluation/caching modes when typing an expression or including a file.
- [ ] `DUP LIT 28 NEQ ?{ #00 ,&comment STR POP BRK }this_is_valid_uxntal!!!!`
- [ ] shouldn't be allowed (leading / creates invalid definition):

```
@/MOD ( a b -- a/b a%b ) [
  DIVk STHk MUL SUB STHr SWP JMP2r
]
  ok
```

## Rom Visualization

![talos.rom.bmp](etc/assets/talos.rom.bmp)

## Repository Tree

```
.
|
├── bak
├── bin
├── build.sh
├── config
│   ├── buffers.tal
│   ├── constants.tal
│   ├── data.tal
│   ├── macros.tal
│   ├── options.tal
│   ├── routines.tal
│   ├── startup.tal
│   └── symbols.tal
├── doc
├── etc
├── lib
│   ├── audio
│   │   └── routines.tal
│   ├── console
│   │   └── macros.tal
│   ├── constants.tal
│   ├── control
│   │   └── routines.tal
│   ├── datetime
│   │   └── routines.tal
│   ├── file
│   │   └── routines.tal
│   ├── macros.tal
│   ├── memory
│   │   └── routines.tal
│   ├── mouse
│   │   └── routines.tal
│   ├── ops
│   │   └── macros.tal
│   ├── routines.tal
│   ├── screen
│   │   ├── data.tal
│   │   └── routines.tal
│   ├── signed
│   │   └── routines.tal
│   ├── string
│   │   ├── macros.tal
│   │   └── routines.tal
│   └── system
│       └── routines.tal
├── rom
├── src
│   ├── assembler
│   │   ├── buffers.tal
│   │   ├── data.tal
│   │   ├── generics.tal
│   │   ├── helpers.tal
│   │   ├── primitives.tal
│   │   └── routines.tal
│   ├── debugger
│   │   ├── macros.tal
│   │   └── routines
│   │       ├── after-eval.tal
│   │       └── before-eval.tal
│   ├── lexer
│   │   ├── data.tal
│   │   └── routines.tal
│   ├── logger
│   │   ├── constants.tal
│   │   ├── data.tal
│   │   ├── error
│   │   │   └── abort.tal
│   │   ├── info
│   │   │   ├── multiline-prompt.tal
│   │   │   ├── prompt.tal
│   │   │   ├── stacks.tal
│   │   │   └── summary.tal
│   │   ├── macros.tal
│   │   ├── routines.tal
│   │   └── warn
│   │       └── redefinition.tal
│   ├── talos
│   │   ├── buffers.tal
│   │   ├── data.tal
│   │   ├── includes.tal
│   │   ├── macros.tal
│   │   └── main.tal
│   ├── repl
│   │   ├── buffers.tal
│   │   ├── data.tal
│   │   ├── macros.tal
│   │   ├── routines.tal
│   │   └── symbols.tal
│   └── tokenizer
│       ├── buffers.tal
│       └── routines.tal
└── test
    ├── macros.tal
    ├── opctest.tal
    ├── routines.tal
    └── script.tal
```

sudo apt install deepin-terminal eterm foot gnome-terminal gnome-console kgx kitty konsole lxterminal mate-terminal mlterm opencu pterm qterminal rxvt-unicode s3dvt sakura stterm terminal.app terminology termit tilda tilix yakuake zutty


https://www.eddymens.com/blog/creating-a-browser-based-interactive-terminal-using-xtermjs-and-nodejs

https://superuser.com/questions/413073/windows-console-with-ansi-colors-handling/1050078#1050078

https://stackoverflow.com/questions/44447473/how-to-make-xterm-js-accept-input

https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011
