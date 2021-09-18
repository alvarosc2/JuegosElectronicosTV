# ===================================================
# register16.tcl - interfaces to the 16-bit registers
# in the emulated 2650
# ===================================================

# Copyright 2005 (C) Peter Linich

namespace eval register16 {

	#==============================================================================
	# ======================================================
	# Initialise - create and display the 16-bit registers,
	# ie. the stack and the IAR
	# ======================================================

	proc Initialise {{f {}}} {

		variable reg16

		#if debug_gui
		variable reg16_value
		variable reg16_display
		#endif

		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		# Create, initialise and display the reg16
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		for {set n 0} {$n < 8} {incr n} {

			# -------------------------
			# Set reg16 register number
			# -------------------------
			set rnum [expr {7 - $n}]

			# ---------------------------
			# Create display and register
			# ---------------------------
			#if debug_gui
			entry $f.e16${rnum}						\
				-width			4				\
				-textvariable		register16::reg16_display($rnum)
			grid $f.e16${rnum} -row $n -column 1
			#endif

			# -----------------------
			# Initialise the register
			# -----------------------
			set reg16($rnum) 0
			#if debug_gui
			set reg16_value($rnum) 0
			set reg16_display($rnum) "0000"
			#endif

			# ------------------------------
			# Now display the register label
			# ------------------------------
			#if debug_gui
			label $f.n16${rnum} -text "S${rnum}"
			grid $f.n16${rnum} -row $n -column 2
			#endif
		}

		# --------------------------------------
		# Create, initialise and display the IAR
		# --------------------------------------
		#if debug_gui
		entry $f.e16iar						\
			-width			4			\
			-textvariable		register16::reg16_display(iar)
		incr n
		grid $f.e16iar -row $n -column 1
		label $f.n16iar -text "IAR"
		grid $f.n16iar -row $n -column 2
		#endif

		# ------------------
		# Initialise the IAR
		# ------------------
		set reg16(iar) 0
		#if debug_gui
		set reg16_value(iar) 0
		set reg16_display(iar) "0000"
		#endif
	}

	#==============================================================================
	# ========================================================
	# GetStack - returns the value of the given stack register
	# ========================================================

	proc GetStack n {

		variable reg16
		return $reg16($n)
	}

	#==============================================================================
	# ==============================================
	# GetIAR - returns the value of the IAR register
	# ==============================================

	proc GetIAR {} {

		variable reg16
		return $reg16(iar)
	}

	#==============================================================================
	# =============================================
	# SetStack - sets the value of the given 16-bit
	# register, and then either displays or queues
	# for display, the changed value
	# =============================================

	proc SetStack {n v} {

		# ------------------
		# Save the new value
		# ------------------
		variable reg16
		set reg16($n) $v

		# -----------------------------
		# Update or queue value display
		# -----------------------------
		#if debug_gui
			UpdateDisplay $n
		#endif
	}

	#==============================================================================
	# =================================================
	# SetIAR - sets the value of the IAR register using
	# the SetStack interface
	# =================================================

	proc SetIAR v {

		SetStack iar $v
	}

	#==============================================================================
	# ==================================================
	# UpdateDisplay - updates the display with the value
	# of the given 16-bit register (0-7=stack, iar=iar).
	# If there is no change no update is performed
	# ==================================================

	#if debug_gui
	proc UpdateDisplay n {

		# -----------------------------------------
		# Check for value change and return if none
		# -----------------------------------------
		variable reg16
		variable reg16_value
		set v $reg16($n)
		if {$v == $reg16_value($n)} return

		# -------------------------
		# Update with the new value
		# -------------------------
		variable reg16_display
		set reg16_value($n) $v
		set reg16_display($n) [format "%04x" $v]
	}
	#endif

	#==============================================================================

	namespace export GetStack
	namespace export GetIAR
	namespace export SetStack
	namespace export SetIAR
}

#==============================================================================

namespace import register16::GetStack
namespace import register16::GetIAR
namespace import register16::SetStack
namespace import register16::SetIAR

#==============================================================================
