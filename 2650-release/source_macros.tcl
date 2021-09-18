#==============================================================================
# ===========================================================
# source_macros.tcl - contains MacroLoad, which pre-processes
# TCL source before eval'ing it. It implements condition
# directives, a bit like C, #if and #endif
# ===========================================================

# Copyright 2005 (C) Peter Linich

#==============================================================================
# =========================================================
# MacroLoad - loads a file, ala` "source", with conditional
# inclusion of source based on the value of a global
# variable. This is done via #if and #endif directives
# =========================================================

proc MacroLoad filename {

	global macro_filename
	set macro_filename $filename

	namespace eval :: {

		# -------------
		# Open the file
		# -------------
		if {[catch {set fd [open $macro_filename "r"]} err]} {
			puts stderr $err
			exit 1
		}

		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		# Loop through the file one line at a time
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		for {set s ""; set iflevel 0; set ifpresent 1} {[gets $fd ln] != -1} {} {

			# ---------------------------------------------
			# Look for an #if followed by a global variable
			# ---------------------------------------------
			if {[regexp -- {^[[:space:]]*#if(.*?)[[:space:]]+([_A-Za-z][_A-Za-z]*)[[:space:]]*$} $ln dummy iftype ifvar]} {

				# -----------------------------
				# Get the global variable value
				# and convert into a true or
				# false in v
				# -----------------------------
				global $ifvar
				if {![info exists $ifvar]} {
					puts stderr "#if variable \"$ifvar\" does not exist"
					exit 1
				}
				eval set v \$$ifvar
				if {$v != 0} {set v 1} else {set v 0}

				# -----------------
				# What type of #if?
				# -----------------
				switch -exact -- $iftype {
					"" {
					}
					"not" {
						set v [expr {1 - $v}]
					}
					default {
						puts stderr "Unrecognised #if: \"[string trim $ln]\""
						exit 1
					}
				}

				# ------------------------------------------------------------
				# Push the old include flag onto a stack and set the new value
				# ------------------------------------------------------------
				set ifstack($iflevel) $ifpresent
				incr iflevel
				set ifpresent $v
				continue
			}

			# -------------------
			# Check for an #endif
			# -------------------
			if {[regexp -- {^[[:space:]]*#endif[[:space:]]*$} $ln]} {

				# -----------------------------------------
				# Pop previous include value from the stack
				# -----------------------------------------
				if {$iflevel > 0} {
					incr iflevel -1
					set ifpresent $ifstack($iflevel)
				} else {
					puts stderr "Too many #endif directives found"
					exit 1
				}
				continue
			}

			# ------------------------------------------------------
			# Include the present line in the source to be processed
			# ------------------------------------------------------
			if {$ifpresent != 0} {

				# ------------------------------
				# Check if the line is a #define
				# ------------------------------
				if {[regexp -- {^[[:space:]]*#define[[:space:]]*$} $ln]} {

					# -------------------
					# Not yet implemented
					# -------------------
				}

				# ----------------------------------------------------------------
				# Otherwise, this is a line to be processed by the TCL interpreter
				# ----------------------------------------------------------------
				append s "$ln\n"
			}
		}

		# -----------------
		# Close file at EOF
		# -----------------
		close $fd

		# ----------------------------
		# Check the #if/#endif nesting
		# ----------------------------
		if {$iflevel != 0} {
			puts stderr "Too few #endif directives found"
			exit 1
		}

		# ------------------------
		# Process the saved source
		# ------------------------
		eval $s
	}
}

#==============================================================================
