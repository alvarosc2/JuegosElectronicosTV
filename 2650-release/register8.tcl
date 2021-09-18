#==============================================================================
# =======================================
# register8.tcl - interfaces to the 8-bit
# registers of the emulated 2650
# =======================================

# Copyright 2005 (C) Peter Linich

namespace eval register8 {

	#==============================================================================
	# ===================================================
	# Initialise - create and display the 8-bit registers
	# ===================================================

	proc Initialise {{f {}}} {

		variable r0
		variable reg8

		#if debug_gui
		variable r0_value
		variable r0hex
		variable reg8_value
		variable reg8hex
		#endif

		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		# Do R1-R3 and the alternate set of R1-R3
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		#if debug_gui
		set n 0
		#endif
		for {set rs 1} {$rs >= 0} {incr rs -1} {
			#if debug_gui
			if {$rs != 0} {set rsuf "'"} else {set rsuf ""}
			#endif
			for {set r 3} {$r >= 1} {incr r -1} {

				set rid "$rs.$r"

				#if debug_gui
					set rnum [expr {7 - $n}]
					entry $f.e8${rnum}					\
						-width			2			\
						-textvariable		register8::reg8hex($rid)
					grid $f.e8${rnum} -row $n -column 4
					label $f.n8${rnum} -text "R${r}${rsuf}"
					grid $f.n8${rnum} -row $n -column 5
				#endif

				set reg8($rid) 0

				#if debug_gui
					set reg8_value($rid) 0
					set reg8hex($rid) "00"

					incr n
				#endif
			}
			#if debug_gui
				incr n
			#endif
		}

		# -------------
		# Now create R0
		# -------------
		#if debug_gui
			entry $f.e80					\
				-width			2		\
				-textvariable		register8::r0hex
			incr n
			grid $f.e80 -row $n -column 4
			label $f.n80 -text "R0"
			grid $f.n80 -row $n -column 5
		#endif

		set r0 0

		#if debug_gui
			set r0_value 0
			set r0hex "00"
		#endif
	}

	#==============================================================================
	# ==============================================
	# DisplayRegister8 - updates the displayed value
	# for the given 8-bit register
	# ==============================================

	#if debug_gui
	proc DisplayRegister8 r {

		if {$r == 0} {

			# --
			# R0
			# --
			variable r0
			variable r0_value
			if {$r0 == $r0_value} return
			variable r0hex
			set r0hex [format "%02x" [set r0_value $r0]]

		} else {

			# -------
			# R1 - R3
			# -------
			variable reg8
			variable reg8_value
			set v $reg8($r)
			if {$v == $reg8_value($r)} return
			variable reg8hex
			set reg8hex($r) [format "%02x" [set reg8_value($r) $v]]
		}
	}
	#endif

	#==============================================================================
	# ========================================
	# SetRegister8 - writes the given value to
	# the selected register and updates the CC
	# in the PSW (if cc_update is non-zero)
	# ========================================

	proc SetRegister8 {r v {cc_update 1}} {

		# -------------------------
		# Change the register value
		# -------------------------
		if {$r == 0} {

			# --
			# R0
			# --
			variable r0
			set r0 $v

		} else {

			# -------
			# R1 - R3
			# -------
			variable reg8
			set rs [GetPSW rs]
			set reg8([set r "$rs.$r"]) $v
		}

		# --------------------------------------
		# Update the display or queue the update
		# --------------------------------------
		#if debug_gui
			DisplayRegister8 $r
		#endif

		# ---------------------------------------------
		# Now update the Condition Code bits in the PSW
		# ---------------------------------------------
		if {$cc_update != 0} {
			if {$v == 0} {
				SetPSW cc 0x00
			} else {
				if {[expr {$v & 0x80}] != 0} {
					SetPSW cc 0x02
				} else {
					SetPSW cc 0x01
				}
			}
		}
	}

	#==============================================================================
	# ================================
	# GetRegister8 - reads and returns
	# the value of the given register
	# ================================

	proc GetRegister8 r {

		if {$r == 0} {
			variable r0
			return $r0
		} else {
			variable reg8
			set rs [GetPSW rs]
			return $reg8($rs.$r)
		}
	}

	#==============================================================================

	namespace export SetRegister8
	namespace export GetRegister8
}

#==============================================================================

namespace import register8::SetRegister8
namespace import register8::GetRegister8

#==============================================================================
