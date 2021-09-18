#==============================================================================
# ============================================
# op_psw.tcl - implements the PSW instructions
# ============================================

# Copyright 2005 (C) Peter Linich

# 05/Nov/2005	- Inserted missing ":" in both Tpsu and Tpsl

#==============================================================================
# ======================================
# Lpsl - implements the LPSL instruction
# ======================================

proc Lpsl {iar opcode} {

	Set8BitPSL [GetRegister8 0]
	return [IncrPage $iar]
}

#==============================================================================
# ======================================
# Lpsu - implements the LPSU instruction
# ======================================

proc Lpsu {iar opcode} {

	Set8BitPSU [GetRegister8 0]
	return [IncrPage $iar]
}

#==============================================================================
# ======================================
# Cpsl - implements the CPSL instruction
# ======================================

proc Cpsl {iar opcode} {

	set v [ReadMemory [IncrPage $iar]]
	set psl [Get8BitPSL]
	Set8BitPSL [expr {$psl & ~$v}]
	return [IncrPage $iar 2]
}

#==============================================================================
# ======================================
# Cpsu - implements the CPSU instruction
# ======================================

proc Cpsu {iar opcode} {

	set v [ReadMemory [IncrPage $iar]]
	set psl [Get8BitPSU]
	Set8BitPSU [expr {$psl & ~$v}]
	return [IncrPage $iar 2]
}

#==============================================================================
# ======================================
# Ppsl - implements the PPSL instruction
# ======================================

proc Ppsl {iar opcode} {

	set v [ReadMemory [IncrPage $iar]]
	set psl [Get8BitPSL]
	Set8BitPSL [expr {$psl | $v}]
	return [IncrPage $iar 2]
}

#==============================================================================
# ======================================
# Ppsu - implements the PPSU instruction
# ======================================

proc Ppsu {iar opcode} {

	set v [ReadMemory [IncrPage $iar]]
	set psu [Get8BitPSU]
	Set8BitPSU [expr {$psu | $v}]
	return [IncrPage $iar 2]
}

#==============================================================================
# ======================================
# Spsu - implements the SPSU instruction
# ======================================

proc Spsu {iar opcode} {

	SetRegister8 0 [Get8BitPSU]
	return [IncrPage $iar]
}

#==============================================================================
# ======================================
# Spsl - implements the SPSL instruction
# ======================================

proc Spsl {iar opcode} {

	SetRegister8 0 [Get8BitPSL]
	return [IncrPage $iar]
}

#==============================================================================
# ======================================
# Tpsu - implements the TPSU instruction
# ======================================

proc Tpsu {iar opcode} {

	set v [ReadMemory [IncrPage $iar]]
	set psu [Get8BitPSU]
	SetPSW cc [expr {($psu & $v) == $v ? 0 : 2}]
	return [IncrPage $iar 2]
}

#==============================================================================
# ======================================
# Tpsl - implements the TPSL instruction
# ======================================

proc Tpsl {iar opcode} {

	set v [ReadMemory [IncrPage $iar]]
	set psl [Get8BitPSL]
	SetPSW cc [expr {($psl & $v) == $v ? 0 : 2}]
	return [IncrPage $iar 2]
}

#==============================================================================
