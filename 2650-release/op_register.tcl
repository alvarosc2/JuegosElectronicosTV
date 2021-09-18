#==============================================================================
# ====================================================================
# op_register.tcl - implements the register operations excelt for STRx
# ====================================================================

# Copyright 2005 (C) Peter Linich

#==============================================================================
# ====================================================
# RegisterOp - is called to handle LOD, EOR, AND, IOR,
# ADD, SUB and COM instructions
# ====================================================

proc RegisterOp {iar opcode} {

	# ---------------------------
	# Get the primary register ID
	# ---------------------------
	set opregister [expr {$opcode & 0x03}]

	# -------------------------------
	# Fetch the second argument value
	# -------------------------------
	switch -exact -- [expr {$opcode & 0x0c}] {

		0 {
			# r - register
			set v [GetRegister8 $opregister]
			set opregister 0
			set iar [IncrPage $iar]
		}

		4 {
			# v - immediate value
			set v [ReadMemory [IncrPage $iar]]
			set iar [IncrPage $iar 2]
		}

		8 {
			# (*)a - relative memory
			set v [ReadMemory [LookupRelative $iar]]
			set iar [IncrPage $iar 2]
		}

		12 {
			# (*a),X - absolute memory
			set v [ReadMemory [LookupAbsolute $iar opregister]]
			set iar [IncrPage $iar 3]
		}
	}

	# --------------------
	# Now do the operation
	# --------------------
	switch -exact -- [expr {$opcode & 0xf0}] {

		0 {
			# LOD 0000
			SetRegister8 $opregister $v
		}
	
		32 {
			# EOR 0010
			SetRegister8 $opregister [expr {[GetRegister8 $opregister] ^ $v}]
		}

		64 {
			# AND 0100
			SetRegister8 $opregister [expr {[GetRegister8 $opregister] & $v}]
		}

		96 {
			# IOR 0110
			SetRegister8 $opregister [expr {[GetRegister8 $opregister] | $v}]
		}

		128 {
			# ADD 1000
			SetRegister8 $opregister [Add [GetRegister8 $opregister] $v]
		}

		160 {
			# SUB 1010
			SetRegister8 $opregister [Subtract [GetRegister8 $opregister] $v]
		}

		224 {
			# COM 1110
			Compare [GetRegister8 $opregister] $v
		}
	}

	# --------------------
	# Return new IAR value
	# --------------------
	return $iar
}

#==============================================================================
