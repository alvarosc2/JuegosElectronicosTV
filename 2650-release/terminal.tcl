#==============================================================================
# ==================================================
# terminal.tcl - interfaces to the terminal emulator
# ==================================================

# Copyright 2005 (C) Peter Linich

namespace eval terminal {

	#==============================================================================
	# =============
	# Configuration
	# =============

	variable FONT			[font create -family courier -size 12]

	variable TERM_COLUMNS		80
	variable TERM_ROWS		25

	variable CLEAR_COLOUR		black
	variable TEXT_COLOUR		green
	variable DIAGNOSTIC_COLOUR	red

	variable BORDER_WIDTH		10

	#==============================================================================
	# ========================================================
	# Initialise - create and initialise the terminal emulator
	# ========================================================

	proc Initialise f {

		variable FONT
		variable TEXT_COLOUR
		variable CLEAR_COLOUR
		variable TERM_ROWS
		variable TERM_COLUMNS
		variable BORDER_WIDTH

		variable char_width
		variable char_height

		variable canvas

		variable cursor

		variable lookupx
		variable lookupy

		variable x
		variable y

		variable draw_colour

		# ---------------------------------
		# Determine the font size in pixels
		# ---------------------------------
		set char_width [font measure $FONT "W"]
		set char_height [font metrics $FONT -linespace]

		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		# Determine the row and column positions in pixels
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		for {set x 0; set i $BORDER_WIDTH} {$x < $TERM_COLUMNS} {incr x; incr i $char_width} {
			set lookupx($x) $i
		}
		for {set y 0; set i $BORDER_WIDTH} {$y < $TERM_ROWS} {incr y; incr i $char_height} {
			set lookupy($y) $i
		}

		# ----------------------------------------------------------------------
		# Create the canvas on which the characters and the cursor will be drawn
		# ----------------------------------------------------------------------
		set canvas $f.c
		canvas $canvas								\
			-highlightthickness	0					\
			-borderwidth		$BORDER_WIDTH				\
			-background		$CLEAR_COLOUR				\
			-width			[expr {$char_width * $TERM_COLUMNS}]	\
			-height			[expr {$char_height * $TERM_ROWS}]

		# -----------------------------------------------
		# Position the canvas itself and set its geometry
		# -----------------------------------------------
		grid $canvas -row 0 -column 0
		grid rowconfigure $f 0 -weight 1
		grid columnconfigure $f 0 -weight 1

		# ------------------------------------
		# Create and position the block cursor
		# ------------------------------------
		label $canvas.cursor				\
			-padx			0		\
			-pady			0		\
			-width			1		\
			-font			$FONT		\
			-background		$TEXT_COLOUR	\
			-borderwidth		0		\
			-highlightthickness	0
		set cursor [$canvas create window 0 0 -window $canvas.cursor -anchor nw]
		PositionCursor [set x 0] [set y 0]

		# ----------------------------
		# Save the colour for new text
		# ----------------------------
		set draw_colour $TEXT_COLOUR
	}

	#==============================================================================
	# =============================================
	# PositionControls - for the non-debug GUI this
	# procedure places the reset control at the top
	# right of the terminal window
	# =============================================

	proc PositionControls f {

		variable BORDER_WIDTH

		place $f -relx 1.0 -x -$BORDER_WIDTH -y $BORDER_WIDTH -anchor ne
	}

	#==============================================================================
	# ===========================================================
	# PositionCursor - places the cursor at the given coordinates
	# ===========================================================

	proc PositionCursor {x y} {

		variable canvas
		variable cursor
		variable lookupx
		variable lookupy

		$canvas coords $cursor $lookupx($x) $lookupy($y)
	}

	#==============================================================================
	# ==================================================
	# DrawChar - draws a character at the given position
	# ==================================================

	proc DrawChar {x y c} {

		variable char
		variable canvas

		# --------------------------------------------------------------
		# If overwriting an already-extant character at this position...
		# --------------------------------------------------------------
		if {[info exists char($x,$y)]} {
			$canvas delete $char($x,$y)
			unset char($x,$y)
		}

		# ----------------------------------
		# Do nothing more if this is a space
		# ----------------------------------
		if {$c == " "} return

		# ------------------------------------
		# Now draw the character on the canvas
		# ------------------------------------
		variable FONT
		variable draw_colour
		variable lookupx
		variable lookupy
		set char($x,$y) \
		[$canvas create text $lookupx($x) $lookupy($y) -font $FONT -fill $draw_colour -anchor nw -text $c]
	}

	#==============================================================================
	# ====================================================
	# ScrollUp - scrolls the text on the canvas up one row
	# after first removing the top row
	# ====================================================

	proc ScrollUp {} {

		variable TERM_ROWS
		variable TERM_COLUMNS

		variable char
		variable canvas
		variable lookupx
		variable lookupy

		# $$$$$$$$$$$$$$$$$$
		# Delete the top row
		# $$$$$$$$$$$$$$$$$$
		foreach c [array names char "*,0"] {
			set x [lindex [split $c ","] 0]
			$canvas delete $char($x,0)
			unset char($x,0)
		}

		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		# Loop through the remaining rows and move them up
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		for {set y 1; set yy 0} {$y < $TERM_ROWS} {incr y; incr yy} {
			foreach c [array names char "*,$y"] {
				set x [lindex [split $c ","] 0]
				$canvas coords [set tag $char($x,$y)] $lookupx($x) $lookupy($yy)
				unset char($x,$y)
				set char($x,$yy) $tag
			}
		}
	}

	#==============================================================================
	# =============================================
	# WriteTerminal - writes a string of characters
	# to the terminal emulator window
	# =============================================

	proc WriteTerminal s {

		variable TERM_ROWS
		variable TERM_COLUMNS

		variable x
		variable y

		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		# Split the string into characters,
		# and then for each character...
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		foreach c [split $s ""] {

			# ----------------------------------
			# If it's a displayable character...
			# ----------------------------------
			if {$c >= " " && $c < "~"} {

				# --------------------------------
				# Draw the character on the canvas
				# --------------------------------
				DrawChar $x $y $c

				# ---------------------
				# Move the cursor along
				# ---------------------
				incr x
				if {$x >= $TERM_COLUMNS} {
					set x 0
					if {[expr {$y + 1}] >= $TERM_ROWS} {
						ScrollUp
					} else {
						incr y
					}
				}
			} else {

				# ---------------------------
				# It's a control character...
				# ---------------------------
				switch -exact -- $c {
					"\r" {
						set x 0
					}
					"\n" {
						if {[expr {$y + 1}] >= $TERM_ROWS} {
							ScrollUp
						} else {
							incr y
						}
					}
					"\x7f" {
						if {$x > 0} {incr x -1}
					}
				}
			}
		}

		# -----------------------------------
		# Draw the cursor in its new position
		# -----------------------------------
		PositionCursor $x $y
	}

	#==============================================================================
	# =================================================
	# WriteDiagnostic - writes a diagnostic line to the
	# terminal emulator window and tags it with the
	# preset diagnostic colour
	# =================================================

	proc WriteDiagnostic ln {

		variable TEXT_COLOUR
		variable DIAGNOSTIC_COLOUR
		variable draw_colour

		set draw_colour $DIAGNOSTIC_COLOUR
		WriteTerminal "$ln\r\n"
		set draw_colour $TEXT_COLOUR
	}

	#==============================================================================

	namespace export WriteTerminal
	namespace export WriteDiagnostic
}

#==============================================================================

namespace import terminal::WriteTerminal
namespace import terminal::WriteDiagnostic

#==============================================================================
