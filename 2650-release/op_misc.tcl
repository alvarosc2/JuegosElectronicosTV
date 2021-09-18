#==============================================================================
# ===================================================
# op_misc.tcl - implements miscellaneous instructions
# ===================================================

# Copyright 2005 (C) Peter Linich

#==============================================================================
# ======================================
# Halt - implements the HALT instruction
# ======================================

proc Halt {iar opcode} {

	global stop
	set stop 1
	return [IncrPage $iar]
}

#==============================================================================
# ====================================
# Nop - implements the NOP instruction
# ====================================

proc Nop {iar opcode} {

	return [IncrPage $iar]
}

#==============================================================================
# ====================================
# Dar - implements the DAR instruction
# ====================================

proc Dar {iar opcode} {

	switch -exact -- [expr {([GetPSW c] << 1) | [GetPSW idc]}] {
		0 {
			SetRegister8 [expr {[GetRegister8 [expr {$opcode & 3}]] + 0xaa}] 0
		}
		1 {
			SetRegister8 [expr {[GetRegister8 [expr {$opcode & 3}]] + 0xa0}] 0
		}
		2 {
			SetRegister8 [expr {[GetRegister8 [expr {$opcode & 3}]] + 0x0a}] 0
		}
	}
	return [IncrPage $iar]
}

#==============================================================================
# ====================================
# Rrl - implements the RRL instruction
# ====================================

proc Rrl {iar opcode} {

	set opregister [expr {$opcode & 3}]
	set r [GetRegister8 $opregister]
	if {[GetPSW wc] == 0} {
		set rnew [expr {(($r + $r) & 0xfe) | (($r & 0x80) >> 7)}]
	} else {
		set rnew [expr {(($r + $r) & 0xfe) | [GetPSW c]}]
		SetPSW c [expr {$r > 127}]
		SetPSW idc [expr {($r & 0x10) != 0}]
	}
	SetPSW ovf [expr {(($r ^ $rnew) & 0x80) != 0}]
	SetRegister8 $opregister $rnew
	return [IncrPage $iar]
}

#==============================================================================
# ====================================
# Rrr - implements the RRR instruction
# ====================================

proc Rrr {iar opcode} {

	set opregister [expr {$opcode & 3}]
	set r [GetRegister8 $opregister]
	if {[GetPSW wc] == 0} {
		set rnew [expr {($r >> 1) + (($r & 0x01) ? 0x80 : 0)}]
	} else {
		set rnew [expr {($r >> 1) + ([GetPSW c] ? 0x80 : 0)}]
		SetPSW c [expr {$r & 1}]
		SetPSW idc [expr {($r & 0x40) != 0}]
	}
	SetPSW ovf [expr {(($r ^ $rnew) & 0x80) != 0}]
	SetRegister8 $opregister $rnew
	return [IncrPage $iar]
}

#==============================================================================
# ====================================
# Tmi - implements the TMI instruction
# ====================================

proc Tmi {iar opcode} {

	set opregister [expr {$opcode & 3}]
	set v [ReadMemory [IncrPage $iar]
	SetPSW cc [expr {([GetRegister8 $opregister] & $v) == $v ? 0 : 2}]
	return [IncrPage $iar 2]
}

#==============================================================================
