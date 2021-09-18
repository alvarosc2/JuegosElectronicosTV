#==============================================================================
# =====================================================================
# psw.tcl - interfaces to the emulated 2650's PSW (Program Status Word)
# =====================================================================

# Copyright 2005 (C) Peter Linich

namespace eval psw {

	#==============================================================================
	# =============
	# Configuration
	# =============

	variable PSW_BIT_LIST	{
					{ c		1 }
					{ com		1 }
					{ ovf		1 }
					{ wc		1 }
					{ rs		1 }
					{ idc		1 }
					{ cc		2 }
					{ sp		3 }
					{ unused	2 }
					{ ii		1 }
					{ f		1 }
					{ s		1 }
				}

	#==============================================================================
	# ==================================================
	# Initialise - optionally create the PSW display and
	# initialise the PSW register bits to zero
	# ==================================================

	#ifnot debug_gui
	proc Initialise {{f {}}} {

		variable PSW_BIT_LIST
		variable psw

		foreach r $PSW_BIT_LIST {
			set name [lindex $r 0]
			set psw($name) 0
		}
	}
	#endif

	#if debug_gui
	proc Initialise f {

		variable PSW_BIT_LIST
		variable psw
		variable psw_len
		variable psw_pos
		variable psw_value
		variable psw_display_bit

		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		# Create the rows of bits with their
		# indices as labels above the values
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		for {set n 0} {$n < 16} {incr n} {

			set grid_column [expr {15 - $n}]

			label $f.n${n} -text [expr {$n & 7}] -borderwidth 1
			grid $f.n${n} -row 1 -column $grid_column -sticky ew

			set psw_display_bit($n) 0
			entry $f.e${n}						\
				-width			1			\
				-textvariable		psw::psw_display_bit($n)
			grid $f.e${n} -row 2 -column $grid_column -sticky ew

			grid columnconfigure $f $grid_column -weight 1 -uniform psw
		}

		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		# Now add the bit names and initialise the bit
		# values and tie the values to the display
		# so that they auto-update
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		set n 0
		foreach r $PSW_BIT_LIST {

			# -------------------------------
			# Get PSW name and number of bits
			# -------------------------------
			set name [lindex $r 0]
			set len [lindex $r 1]

			# -----------------------
			# Initialise the register
			# -----------------------
			set psw($name) 0
			set psw_value($name) 0

			# --------------------------------
			# Save the field position and size
			# --------------------------------
			set psw_pos($name) $n
			set psw_len($name) $len

			# ----------------------------------------------
			# Display the title above the values and indices
			# ----------------------------------------------
			label $f.t${n} -text [string toupper $name] -borderwidth 2 -relief groove
			set grid_column [expr {15 - $n - ($len - 1)}]
			grid $f.t${n} -row 0 -column $grid_column -columnspan $len -sticky ew

			# ------------------------
			# Move on to the next name
			# ------------------------
			incr n $len
		}
	}
	#endif

	#==============================================================================
	# =====================================
	# GetPSW - returns a field from the PSW
	# =====================================

	proc GetPSW r {

		variable psw
		return $psw($r)
	}

	#==============================================================================
	# =====================================================
	# SetPSW - sets a field in the PSW and either displays,
	# or queues for display, the new value
	# =====================================================

	proc SetPSW {r v} {

		variable psw
		set psw($r) $v

		#if debug_gui
		UpdatePSWField $r
		#endif
	}

	#==============================================================================
	# =============================================
	# Get8BitPSU - returns the 8-bit representation
	# of the upper half of the PSW
	# =============================================

	proc Get8BitPSU {} {

		return [expr {([GetPSW s] << 7) | ([GetPSW f] << 6) | ([GetPSW ii] << 5) | [GetPSW sp]}]
	}

	#==============================================================================
	# =============================================
	# Get8BitPSL - returns the 8-bit representation
	# of the lower half of the PSW
	# =============================================

	proc Get8BitPSL {} {

		return [expr ([GetPSW cc] << 6) | ([GetPSW idc] << 5) | ([GetPSW rs] << 4) | \
		([GetPSW wc] << 3) | ([GetPSW ovf] << 2) | ([GetPSW com] << 1) | [GetPSW c]]
	}

	#==============================================================================
	# =====================================
	# Set8BitPSU - stores the 8-bit value r
	# into the upper 8-bits of the PSW
	# =====================================

	proc Set8BitPSU r {

		SetPSW f [expr {($r & 0x40) != 0}]
		SetPSW ii [expr {($r & 0x20) != 0}]
		SetPSW sp [expr {$r & 0x07}]
	}

	#==============================================================================
	# =====================================
	# Set8BitPSL - stores the 8-bit value r
	# into the lower 8-bits of the PSW
	# =====================================

	proc Set8BitPSL r {

		SetPSW cc [expr {($r & 0xc0) >> 6}]
		SetPSW idc [expr {($r & 0x20) != 0}]
		SetPSW rs [expr {($r & 0x10) != 0}]
		SetPSW wc [expr {($r & 0x08) != 0}]
		SetPSW ovf [expr {($r & 0x04) != 0}]
		SetPSW com [expr {($r & 0x02) != 0}]
		SetPSW c [expr {($r & 0x01) != 0}]
	}

	#==============================================================================
	# ==================================================
	# UpdatePSWField - updates the value of the given
	# PSW field on the display. No actual change is made
	# if the displayed value is already correct
	# ==================================================

	#if debug_gui
	proc UpdatePSWField r {

		# ----------------------------------
		# Get the new value, and if the same
		# as the old value, do nothing
		# ----------------------------------
		variable psw
		variable psw_value
		set v $psw($r)
		if {$v == $psw_value($r)} return

		# ------------------
		# Save the new value
		# ------------------
		set psw_value($r) $v

		# -----------------------
		# Do the on-screen update
		# -----------------------
		variable psw_pos
		variable psw_len
		variable psw_display_bit
		set pos $psw_pos($r)
		set len $psw_len($r)
		if {$len == 1} {

			# ================
			# Single-bit value
			# ================

			set psw_display_bit($pos) $v

		} else {

			# ===============
			# Multi-bit value
			# ===============

			for {set n 0} {$n < $len} {incr n} {
				set psw_display_bit($pos) [expr {$v & 1}]
				incr pos
				set v [expr {$v >> 1}]
			}
		}
	}
	#endif

	#==============================================================================

	namespace export GetPSW
	namespace export SetPSW
	namespace export Get8BitPSU
	namespace export Get8BitPSL
	namespace export Set8BitPSU
	namespace export Set8BitPSL
}

#==============================================================================

namespace import psw::GetPSW
namespace import psw::SetPSW
namespace import psw::Get8BitPSU
namespace import psw::Get8BitPSL
namespace import psw::Set8BitPSU
namespace import psw::Set8BitPSL

#==============================================================================
