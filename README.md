# whitakers_words.koplugin
A little plugin for KOReader to use Whitaker's Words in texts: highlight a Latin word and have its inflection and definition returned.

Whitaker's Words is a program that takes as input a Latin word and outputs likely definitions and inflections. This is especially useful for people learning to read Latin. This plugin gives a way to use Whitaker's Words from within KOReader: simply highlight the word and press the appropriate button in the Highlight menu. This will open a pop-up with Whitaker's Words's output. I will also add a separate button that allows for text input.

To use this plugin, have KOReader installed on your Kobo, and drag the files into the plugins file.

The original program was written by Whitaker and his code, written in Ada, is hosted here: https://github.com/mk270/whitakers-words

This plugin is still a work in progress, and any feedback is appreciated.

Please note that this plugin makes use of the "words" program compiled for Kobo (arm-linux-gnueabihf). It will only function on this architecture for now. To make it truly portable, I plan to rewrite this program in Lua and include it in the plugin. In the meantime, users who want to use this plugin on other systems must compile Whitaker's Words for their target system. I have appended some notes on the modifications to the original source code that I took to successfully cross-compile.


Notes on compilation:
To cross-compile the original program, I needed to adjust the Makefile and shared.gpr that can be found in the original repository.

Makefile 
In "GPRBUILD_OPTIONS" I added the flag "--target=arm-linux-gnueabihf".

I also replaced line 40 with "$(GPRBUILD) -p $(GPRBUILD_OPTIONS) commands.gpr -largs -Wl,-rpath,../../lib -static". This ensures static compilation, and clearly -rpath should point to wherever the static libraries are stored.

Finally, since we are cross-compiling, the various program calls (now compiled for arm) starting from line 58 onward must be replaced with calls to programs already compiled for our host system. Thus I changed eg line 59 from "echo g | bin/wakedict $<" to "echo g | bin-host/wakedict $<", and in general whoever compiles should make sure to point to the same programs compiled for the host machine.

shared.gpr
I changed the flag on line 9 from "-gnatwae" to "-gnatwa". This makes it so that warnings are no longer treated as errors, and the compilation continues (otherwise the compilation was stopping on I think an extra parenthesis).
