#==============================================================================
# ===========================================
# op_branch.tcl - contains the various branch
# and return instructions
# ===========================================

# Copyright 2005 (C) Peter Linich

#==============================================================================
# ====================================
# Bxa - implements the BXA instruction
# ====================================

proc Bxa {iar opcode} {

	set a1 [ReadMemory [IncrPage $iar]
	set a2 [ReadMemory [IncrPage $iar 2]
	set indirect [expr {$a1 & 0x80}]
	set addr [expr {(($a1 & 0x7f) << 8) | $a2}]

	if {$indirect != 0} {

		set a1 [ReadMemory $addr]
		set a2 [ReadMemory [expr {($addr + 1) & 0x7fff}]]
		set addr [expr {($a1 << 8) | $a2}]
	}

	return [expr {($addr + [GetRegister8 3]) & 0x7fff}]
}

#==============================================================================
# ======================================
# Bsxa - implements the BSXA instruction
# ======================================

proc Bsxa {iar opcode} {

	PushStack $iar 3
	return [Bxa $iar $opcode]
}

#==============================================================================
# ======================================
# Zbrr - implements the ZBRR instruction
# ======================================

proc Zbrr {iar opcode} {

	set a [ReadMemory $iar]
	set indirect [expr {$a & 0x80}]
	set addr [expr {$a & 0x7f}]
	if {$addr > 63} {set addr [expr {($addr - 128) & 0x1fff}]}
	if {$indirect == 0} {return $addr}

	return [expr {(([ReadMemory $addr] << 8) | [ReadMemory [IncrPage $addr]]) & 0x7fff}]
}

#==============================================================================
# ======================================
# Zbsr - implements the ZBSR instruction
# ======================================

proc Zbsr {iar opcode} {

	PushStack $iar 2
	return [Zbrr $iar $opcode]
}

#==============================================================================
# ======================================
# Birr - implements the BIRR instruction
# ======================================

proc Birr {iar opcode} {

	set opregister [expr {$opcode & 3}]
	SetRegister8 $opregister [set r [expr {([GetRegister8 $opregister] + 1) & 0xff}]] 0

	if {$r != 0} {
		return [BranchRelative $iar]
	} else {
		return [IncrPage $iar 2]
	}
}

#==============================================================================
# ======================================
# Bira - implements the BIRA instruction
# ======================================

proc Bira {iar opcode} {

	set opregister [expr {$opcode & 3}]
	SetRegister8 $opregister [set r [expr {([GetRegister8 $opregister] + 1) & 0xff}]] 0

	if {$r != 0} {
		return [BranchAbsolute $iar]
	} else {
		return [IncrPage $iar 3]
	}
}

#==============================================================================
# ======================================
# Bdrr - implements the BDRR instruction
# ======================================

proc Bdrr {iar opcode} {

	set opregister [expr {$opcode & 3}]
	SetRegister8 $opregister [set r [expr {([GetRegister8 $opregister] - 1) & 0xff}]] 0

	if {$r != 0} {
		return [BranchRelative $iar]
	} else {
		return [IncrPage $iar 2]
	}
}

#==============================================================================
# ======================================
# Bdra - implements the BDRA instruction
# ======================================

proc Bdra {iar opcode} {

	set opregister [expr {$opcode & 3}]
	SetRegister8 $opregister [set r [expr {([GetRegister8 $opregister] - 1) & 0xff}]] 0

	if {$r != 0} {
		return [BranchAbsolute $iar]
	} else {
		return [IncrPage $iar 2]
	}
}

#==============================================================================
# ======================================
# Bsnr - implements the BSNR instruction
# ======================================

proc Bsnr {iar opcode} {

	if {[GetRegister8 [expr {$opcode & 3}]] != 0} {
		return [SubroutineRelative $iar]
	} else {
		return [IncrPage $iar 2]
	}
}

#==============================================================================
# ======================================
# Bsna - implements the BSNA instruction
# ======================================

proc Bsna {iar opcode} {

	if {[GetRegister8 [expr {$opcode & 3}]] != 0} {
		return [SubroutineAbsolute $iar]
	} else {
		return [IncrPage $iar 3]
	}
}

#==============================================================================
# ======================================
# Brnr - implements the BRNR instruction
# ======================================

proc Brnr {iar opcode} {

	if {[GetRegister8 [expr {$opcode & 3}]] != 0} {
		return [BranchRelative $iar]
	} else {
		return [IncrPage $iar 2]
	}
}

#==============================================================================
# ======================================
# Brna - implements the BRNA instruction
# ======================================

proc Brna {iar opcode} {

	if {[GetRegister8 [expr {$opcode & 3}]] != 0} {
		return [BranchAbsolute $iar]
	} else {
		return [IncrPage $iar 3]
	}
}

#==============================================================================
# ======================================
# Bctr - implements the BCTR instruction
# ======================================

proc Bctr {iar opcode} {

	set check [expr {$opcode & 3}]
	if {$check == 3 || $check == [GetPSW cc]} {
		return [BranchRelative $iar]
	} else {
		return [IncrPage $iar 2]
	}
}

#==============================================================================
# ======================================
# Bcta - implements the BCTA instruction
# ======================================

proc Bcta {iar opcode} {

	set check [expr {$opcode & 3}]
	if {$check == 3 || $check == [GetPSW cc]} {
		return [BranchAbsolute $iar]
	} else {
		return [IncrPage $iar 3]
	}
}

#==============================================================================
# ======================================
# Bcfr - implements the BCFR instruction
# ======================================

proc Bcfr {iar opcode} {

	set check [expr {$opcode & 3}]
	if {$check != [GetPSW cc]} {
		return [BranchRelative $iar]
	} else {
		return [IncrPage $iar 2]
	}
}

#==============================================================================
# ======================================
# Bcfa - implements the BCFA instruction
# ======================================

proc Bcfa {iar opcode} {

	set check [expr {$opcode & 3}]
	if {$check != [GetPSW cc]} {
		return [BranchAbsolute $iar]
	} else {
		return [IncrPage $iar 3]
	}
}

#==============================================================================
# ======================================
# Bsta - implements the BSTA instruction
# ======================================

proc Bsta {iar opcode} {

	set check [expr {$opcode & 3}]
	if {$check == 3 || $check == [GetPSW cc]} {
		return [SubroutineAbsolute $iar]
	} else {
		return [IncrPage $iar 3]
	}
}

#==============================================================================
# ======================================
# Bstr - implements the BSTR instruction
# ======================================

proc Bstr {iar opcode} {

	set check [expr {$opcode & 3}]
	if {$check == 3 || $check == [GetPSW cc]} {
		return [SubroutineRelative $iar]
	} else {
		return [IncrPage $iar 2]
	}
}

#==============================================================================
# ======================================
# Bsfa - implements the BSFA instruction
# ======================================

proc Bsfa {iar opcode} {

	set check [expr {$opcode & 3}]
	if {$check != [GetPSW cc]} {
		return [SubroutineAbsolute $iar]
	} else {
		return [IncrPage $iar 3]
	}
}

#==============================================================================
# ======================================
# Bsfr - implements the BSFR instruction
# ======================================

proc Bsfr {iar opcode} {

	set check [expr {$opcode & 3}]
	if {$check != [GetPSW cc]} {
		return [SubroutineRelative $iar]
	} else {
		return [IncrPage $iar 2]
	}
}

#==============================================================================
# =======================================
# Return - is called as part of a return
# from a subroutine. It does the required
# stack magic and returns the new exec-
# -ution (IAR) address
# =======================================

proc Return {} {

	set sp [GetPSW sp]
	SetPSW sp [expr {($sp - 1) & 0x07}]
	return [GetStack $sp]
}

#==============================================================================
# ======================================
# Retc - implements the RETC instruction
# ======================================

proc Retc {iar opcode} {

	set check [expr {$opcode & 3}]
	if {$check == 3 || $check == [GetPSW cc]} {
		return [Return]
	} else {
		return [IncrPage $iar]
	}
}

#==============================================================================
# ======================================
# Rete - implements the RETE instruction
# ======================================

proc Rete {iar opcode} {

	set check [expr {$opcode & 3}]
	if {$check == 3 || $check == [GetPSW cc]} {
		SetPSW ii 0
		return [Return]
	} else {
		return [IncrPage $iar]
	}
}

#==============================================================================
