Version 1/130823 of Menus by Dannii Willis begins here.

"Display full-screen menus defined by tables"

Use authorial modesty.

Include Basic Screen Effects by Emily Short.



Part - Tables

[ Define the column types for Menus. The old column names will still work. ]

Table of Menu column definitions
title	text	description	submenu	subtable	rule	toggle
""	""	""	a table-name	a table-name	a rule	a rule

[ These tables define how the status bar is shown in menus ]

Table of Shallow Menu Status
left	central	right
""	"[current menu title]"	""

Table of Deep Menu Status
left	central	right
""	"[current menu title]"	""
""	""	""
" Select a number"	""	"Esc/Q = Back "

[ This table stores the history of menus considered. Essentially we push/pop to it. ]

Table of Menu history
title (text)	submenu (table-name)
with 10 blank rows



Part - Menus [Variables]

The current menu is a table-name variable. The current menu is Table of Menu column definitions.
The current menu title is a text variable. The current menu title is "Instructions".

Section - unindexed

Menu header is a table-name variable. The menu header is Table of Deep Menu Status.

Menu depth is a number variable. Menu depth is 0.


Part - Menu labels

[ This Part can be replaced to allow more/different labels to be printed and accepted ]

[ We support 1-9 and A-P by default. This phrase is for your code to check - the extension does not use it. ]
To decide which number is the maximum number of menu labels:
	decide on 25;

Section - unindexed

To say menu character number (x - a number):
	(- print (char) ({x} + 55); -).

To say menu label (x - a number):
	if x < 10:
		say x;
	otherwise:
		say menu character number x;

[ -1 = Go back, 0 = invalid, 1+ = menu choice (but the menu must be checked to see if the row even exists!) ]
To decide what number is the chosen menu option for (x - a number):
	[ Esc/Q ]
	if x is -8 or x is 27 or x is 81 or x is 113:
		decide on -1;
	if x > 48 and x < 58:
		decide on x - 48;
	if x > 64 and x < 81:
		decide on x - 55;
	if x > 96 and x < 113:
		decide on x - 87;
	decide on 0;



Part - Interface phrases unindexed

[ Wait for a safe non navigating key. The user might press Down/PgDn or use the mouse scroll wheel when reading a menu page, so we will stop those key codes from returning to the menu. ]
To wait for any non navigating key:
	while 1 is 1:
		let key be the chosen letter;
		[ Exclude Up/Down/PgUp/PgDn and ? which Gargoyle+Bocfel returns for unknown keys such as PgDn/Mouse scroll. Both Z-Machine and Glulx key codes are handled ]
		if key is 63 or key is 129 or key is 130:
			next;
		if key < 0:
			if key is -8 or key is -6:
				stop;
			next;
		stop;

Section - Clearing the main menu window unindexed

[ TODO: In Glulx hide the main window rather than clearing ]

To clear the main menu window:
	clear the screen;



Part - Displaying a menu

Displaying is an activity.

The displaying a menu rules are a rulebook.

To display the/-- (t - a table-name) menu with title (x - text):
	blank out the whole of Table of Menu history;
	choose row 1 in Table of Menu history;
	now the title entry is x;
	now the submenu entry is t;
	carry out the displaying activity;

[ Support the old Menus way of running the displaying activity directly ]
First before displaying rule (this is the fix the Table of Menu history rule):
	choose row 1 in Table of Menu history;
	if there is no title entry or the title entry is "":
		now the title entry is the current menu title;
		now the submenu entry is the current menu;
	now menu depth is the number of filled rows in Table of Menu history;

Rule for displaying (this is the display a menu rule):
	while menu depth > 0:
		consider the displaying a menu rules;



Chapter - Clearing the screen

Before displaying (this is the clear the window before displaying rule):
	clear the main menu window;

After displaying (this is the clear the window after displaying rule):
	clear the main menu window;



Chapter - Displaying one single menu

Displaying a menu rule (this is the main menu display rule):
	clear the main menu window;
	let count be 1;
	let my menu be the submenu in row menu depth of Table of Menu history;
	repeat through my menu:
		say line break;
		[ Blank rows are okay! ]
		if there is no title entry or the title entry is "":
			next;
		[ Say the menu entry label only if there's something to do ]
		say fixed letter spacing;
		if there is a text entry or there is a description entry or there is a submenu entry or there is a subtable entry or there is a rule entry or there is a toggle entry:
			say " [menu label count]  ";
			increment count;
		otherwise:
			say "    ";
		say "[variable letter spacing][title entry]";
	say run paragraph on;



Chapter - The menu's status line unindexed

To redraw status line:
	(- DrawStatusLine(); -).

Displaying a menu rule (this is the force a status line refresh rule):
	let temp menu title be the current menu title;
	now the current menu title is the title in row menu depth of Table of Menu history;
	redraw status line;
	now the current menu title is the temp menu title;

Rule for constructing the status line while displaying (this is the constructing status line while displaying rule):  
	fill status bar with the Menu header;
	rule succeeds;



Chapter - Process a command unindexed

To decide whether processing menu option (x - a number) is valid:
	let count be 1;
	let my menu be the submenu in row menu depth of Table of Menu history;
	repeat through my menu:
		if there is no title entry or the title entry is "":
			next;
		if there is a text entry or there is a description entry or there is a submenu entry or there is a subtable entry or there is a rule entry or there is a toggle entry:
			if count is x:
				if there is a rule entry:
					consider the rule entry;
					decide yes;
				if there is a toggle entry:
					consider the toggle entry;
					decide yes;
				if there is a submenu entry:
					show submenu submenu entry with title title entry;
					decide yes;
				if there is a subtable entry:
					show submenu subtable entry with title title entry;
					decide yes;
				if there is a description entry:
					show menu page description entry with title title entry;
					decide yes;
				if there is a text entry:
					show menu page text entry with title title entry;
					decide yes;
			increment count;
	decide no;

To show submenu (m - a table-name) with title (t - a text):
	increment menu depth;
	choose row menu depth in Table of Menu history;
	now the title entry is t;
	now the submenu entry is m;

To show menu page (page - a text) with title (t - a text):
	clear the main menu window;
	say "[line break][page][paragraph break][italic type]Press a key to go back.[roman type]";
	now the menu header is Table of Shallow Menu Status;
	let temp menu title be the current menu title;
	now the current menu title is t;
	redraw status line;
	now the current menu title is the temp menu title;
	now the menu header is Table of Deep Menu Status;
	wait for any non navigating key;
	clear the main menu window;

Displaying a menu rule (this is the process a menu command rule):
	while 1 is 1:
		let key be the chosen letter;
		let command be the chosen menu option for key;
		if command is -1:
			choose row menu depth in Table of Menu history;
			blank out the whole row;
			decrement menu depth;
			stop;
		if command is 0:
			next;
		[ We have a menu choice! ]
		if processing menu option command is valid:
			stop;



Menus ends here.
