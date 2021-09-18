#==============================================================================
# ===========================================
# op_store.tcl - implements STRx instructions
# ===========================================

# Copyright 2005 (C) Peter Linich

#==============================================================================
# =========================================
# StoreOp - implements the STR instructions
# =========================================

proc StoreOp {iar opcode} {

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
			SetRegister8 $opregister [GetRegister8 0]
			set iar [IncrPage $iar]
		}

		8 {
			# (*)a - relative memory
			WriteMemory [LookupRelative $iar] [GetRegister8 $opregister]
			set iar [IncrPage $iar 2]
		}

		12 {
			# (*a),X - absolute memory
			set addr [LookupAbsolute $iar opregister]
			WriteMemory $addr [GetRegister8 $opregister]
			set iar [IncrPage $iar 3]
		}
	}

	# --------------------
	# Return new IAR value
	# --------------------
	return $iar
}

#==============================================================================
