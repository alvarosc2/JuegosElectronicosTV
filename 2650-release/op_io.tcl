#==============================================================================
# ===========================================
# op_io.tcl - implements the I/O instructions
# ===========================================

# Copyright 2005 (C) Peter Linich

#==============================================================================
# ======================================
# Wrte - implements the WRTE instruction
# ======================================

proc Wrte {iar opcode} {

	# -----------------------------------
	# Switch according to the output port
	# -----------------------------------
	switch -exact -- [ReadMemory [IncrPage $iar]] {
		1 {
			# ---------------------------------------------------
			# Output port #1
			# Write a character at pseudo-110-baud to the console
			# ---------------------------------------------------
			global io_pending io_byte io_after
			set io_byte [GetRegister8 [expr {$opcode & 3}]]
			set io_pending 1
			set io_after [after 90 WriteCout]
			return $iar
		}
		default {
			# ------------------------
			# Unknown ports do nothing
			# ------------------------
		}
	}
	return [IncrPage $iar 2]
}

#------------------------------------------------------------------------------
# ===============================================
# WriteCout - write the buffered character to the
# terminal and then restart the processor. Ignore
# non-printing characters
# ===============================================

proc WriteCout {} {

	global io_pending io_byte io_after
	unset io_after
	set io_pending 0
	WriteTerminal [binary format c $io_byte]
	SetIAR [IncrPage [GetIAR] 2]
	Run
}

#==============================================================================
# ======================================
# Wrtc - implements the WRTC instruction
# ======================================

proc Wrtc {iar opcode} {

	return [IncrPage $iar]
}

#==============================================================================
# ======================================
# Wrtd - implements the WRTD instruction
# ======================================

proc Wrtd {iar opcode} {

	return [IncrPage $iar]
}

#==============================================================================
# ======================================
# Rede - implements the REDE instruction
# ======================================

proc Rede {iar opcode} {

	# ------------------------
	# Get the operand register
	# ------------------------
	set op_register [expr {$opcode & 0x03}]

	# ----------------------------------
	# Switch according to the input port
	# ----------------------------------
	switch -exact -- [ReadMemory [IncrPage $iar]] {
		1 {
			# ---------------------------------
			# Read a character from the console
			# ---------------------------------
			global key_present
			if {$key_present != 0} {
				# ------------------
				# Already available!
				# ------------------
				global key_buffer
				SetRegister8 $op_register $key_buffer
				set key_present 0
			} else {
				# --------------------
				# Wait for a keystroke
				# --------------------
				global io_pending io_register
				set io_register $op_register
				set io_pending 1
				return $iar
			}
		}
		default {
			# -------------------------------
			# Unknown ports always read as FF
			# -------------------------------
			SetRegister8 $op_register 0xff
		}
	}
	return [IncrPage $iar 2]
}

#==============================================================================
# ======================================
# Redc - implements the REDC instruction
# ======================================

proc Redc {iar opcode} {

	SetRegister8 [expr {$opcode & 3}] 255
	return [IncrPage $iar]
}

#==============================================================================
# ======================================
# Redd - implements the REDD instruction
# ======================================

proc Redd {iar opcode} {

	SetRegister8 [expr {$opcode & 3}] 255
	return [IncrPage $iar]
}

#==============================================================================
