#==============================================================================
# ===========================================
# init.tcl - final initialisation and startup
# ===========================================

# Copyright 2005 (C) Peter Linich

#==============================================================================
# ===============================
# Load the op-code dispatch table
# ===============================

foreach i $RAW_DISPATCH {

	set proc [lindex $i 0]
	set n [lindex $i 1]
	set opdispatch($n) $proc
}

#==============================================================================
# =============
# Build the GUI
# =============

# -----------------------------------
# Create and position the PSW display
# -----------------------------------
#if debug_gui
	frame .psw
	psw::Initialise .psw
	grid .psw -row 0 -column 0 -sticky ew
	grid rowconfigure . 0 -weight 0
#endif
#ifnot debug_gui
	psw::Initialise
#endif

# ----------------------------------------------------------
# Now the panel to contain the text window and the registers
# ----------------------------------------------------------
frame .x -borderwidth 1 -relief groove
grid .x -row 1 -column 0 -sticky news
grid rowconfigure . 1 -weight 1
grid columnconfigure . 0 -weight 1

# --------------------------
# Create the terminal window
# --------------------------
frame .x.term
terminal::Initialise .x.term
grid .x.term -row 0 -column 0 -rowspan 2 -sticky news
grid rowconfigure .x 0 -weight 1
grid columnconfigure .x 0 -weight 1

# -----------------
# Now the registers
# -----------------
#if debug_gui
	frame .x.reg
	register8::Initialise .x.reg
	register16::Initialise .x.reg
	grid .x.reg -row 0 -column 1 -sticky new
#endif
#ifnot debug_gui
	register8::Initialise
	register16::Initialise
#endif

# ------------------------------------
# Now the run, reset and step controls
# ------------------------------------
#if debug_gui
	frame .x.controls
	controls::Initialise .x.controls
	grid .x.controls -row 1 -column 1 -sticky sew
#endif
#ifnot debug_gui
	frame .x.term.controls
	controls::Initialise .x.term.controls
	terminal::PositionControls .x.term.controls
	raise .x.term.controls
#endif

# ----------------------
# Now the memory display
# ----------------------
#if debug_gui
	frame .mem
	memory::Initialise .mem
	grid .mem -row 2 -column 0 -sticky ew
	grid rowconfigure . 2 -weight 0
#endif
#ifnot debug_gui
	memory::Initialise
#endif

#==============================================================================
# =============================
# Set up the keyboard processor
# =============================

bind . <KeyPress> {

	# -------------------------------------------
	# Filter so that we look like a dumb keyboard
	# -------------------------------------------
	switch -exact -- "%K" {

		"Delete" -
		"BackSpace" {
			set b 127
		}
		"Return" {
			set b 13
		}
		default {
			set c %A
			if {$c == {}} break
			binary scan $c c b
			if {($b < 32 || $b >= 127) && $b != 10} break
		}
	}

	# ---------------------------------------
	# Check if processor is waiting for a key
	# ---------------------------------------
	if {[info exists io_register]} {

		# -----------------------------------
		# Yes. Give it the keystroke directly
		# -----------------------------------
		SetRegister8 $io_register $b
		unset io_register
		set io_pending 0
		SetIAR [IncrPage [GetIAR] 2]
		after idle Run

	} else {

		# -------------------------------------------------------------
		# No. Queue the character for the next time the processor looks
		# -------------------------------------------------------------
		set key_present 1
		set key_buffer $b
	}

	# ----
	# Done
	# ----
	break
}

#==============================================================================
# ===
# Run
# ===

# -------------------
# Reset the processor
# -------------------
set stop 0
set io_pending 0
Reset

# ---------------------------
# Start the processor running
# ---------------------------
#ifnot debug_gui
	after idle Run
#endif

#==============================================================================
