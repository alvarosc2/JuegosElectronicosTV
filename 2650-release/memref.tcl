#==============================================================================
# ==========================================
# memref.tcl - utility relative and absolute
# memory reference calculation procedures
# ==========================================

# Copyright 2005 (C) Peter Linich

#==============================================================================
# ==========================================
# PushStack - pushes a return address on the
# stack. Requires instruction length
# ==========================================

proc PushStack {iar instlen} {

	set sp [GetPSW sp]
	set sp [expr {($sp + 1) & 0x07}]
	SetPSW sp $sp
	SetStack $sp [IncrPage $iar $instlen]
}

#==============================================================================
# ==============================================
# SubroutineRelative - is called to implement a
# relative call to a subroutine. It does the
# stack magic and then returns the new execution
# (IAR) address
# ==============================================

proc SubroutineRelative iar {

	PushStack $iar 2
	return [BranchRelative $iar]
}

#==============================================================================
# ==============================================
# SubroutineAbsolute - is called to implement an
# absolute call to a subroutine. It does the
# stack magic and then returns the new execution
# (IAR) address
# ==============================================

proc SubroutineAbsolute iar {

	PushStack $iar 3
	return [BranchAbsolute $iar]
}

#==============================================================================
# ================================================
# BranchRelative - fetches, processes and branches
# to a one-byte relative address
# ================================================

proc BranchRelative iar {

	set a [ReadMemory [IncrPage $iar]]
	set indirect [expr {$a & 0x80}]
	if {[set a [expr {$a & 0x7f}]] > 63} {incr a -128}
	set addr [IncrPage [IncrPage $iar 2] $a]
	if {$indirect == 0} {return $addr}

	set a [ReadMemory $addr]
	set addr [IncrPage $addr]
	return [expr {(($a << 8) + [ReadMemory $addr]) & 0x7fff}]
}

#==============================================================================
# ================================================
# BranchAbsolute - fetches, processes and branches
# to a two-byte absolute address
# ================================================

proc BranchAbsolute iar {

	set a1 [ReadMemory [IncrPage $iar]]
	set a2 [ReadMemory [IncrPage $iar 2]]
	set indirect [expr {$a1 & 0x80}]
	set addr [expr {($a1 & 0x7f) << 8 | $a2}]
	if {$indirect == 0} {return $addr}

	set a [ReadMemory $addr]
	set addr [expr {($addr + 1) & 0x7fff}]
	return [expr {(($a << 8) + [ReadMemory $addr]) & 0x7fff}]
}

#==============================================================================
# =================================================
# LookupRelative - determines the effective address
# from the relative argument byte following the
# opcode of the current instruction
# =================================================

proc LookupRelative iar {

	# ----------------------------------
	# Get the memory reference parameter
	# ----------------------------------
	set a [ReadMemory [IncrPage $iar]]

	# ------------------------
	# Extract the bits we need
	# ------------------------
	set indirect [expr {$a & 0x80}]
	set addr [expr {$a & 0x7f}]
	if {$addr >= 64} {incr addr -128}

	# ----------------------------------
	# Calculate the non-indirect address
	# ----------------------------------
	set addr [IncrPage [IncrPage $iar 2] $addr]
	if {$indirect == 0} {return $addr}

	# --------------------
	# Get indirect address
	# --------------------
	set a [ReadMemory $addr]
	return [expr {(($a << 8) | [ReadMemory [IncrPage $addr 1]]) & 0x7fff}]
}

#==============================================================================
# ====================================================
# LookupAbsolute - this procedure takes a register ID
# and the two argument bytes from the current
# instruction, and calculates the effective address,
# taking into account the indirect flag and the index
# control bits. The address is returned, as well as
# the register on which to operate
# ====================================================

proc LookupAbsolute {iar reg} {

	upvar $reg r

	# -----------------------------------
	# Get the memory reference parameters
	# -----------------------------------
	set a1 [ReadMemory [IncrPage $iar]]
	set a2 [ReadMemory [IncrPage $iar 2]]

	# --------------------------------------------
	# Extract the bits we need from the parameters
	# --------------------------------------------
	set indirect [expr {$a1 & 0x80}]
	set index_control [expr {$a1 & 0x60}]
	set addr [expr {(($a1 & 0x1f) << 8) | $a2}]

#puts "a1=[format "%02x" $a1] a2=[format "%02x" $a2] indirect=$indirect r=$r index_control=[format "%02x" $index_control] addr=[format "%04x" $addr] r0=[format "%02x" [GetRegister8 0]] r1=[format "%02x" [GetRegister8 1]] r2=[format "%02x" [GetRegister8 2]] r3=[format "%02x" [GetRegister8 3]]"

	# ---------------------
	# Indirect or absolute?
	# ---------------------
	if {$indirect != 0} {

		# ========
		# Indirect
		# ========

		# ------------------------------------
		# Get the indirect address from memory
		# ------------------------------------
		set a1 [ReadMemory $addr]
		set a2 [ReadMemory [IncrPage $addr]]

		set addr [expr {($a1 << 8) + $a2}]
	}

	# --------
	# Indexed?
	# --------
	if {$index_control != 0} {

		# =======
		# Indexed
		# =======

		# ---------------------------------------
		# Get and update the index register value
		# ---------------------------------------
		set i [GetRegister8 $r]
#puts "+++ r=$r, i=$i"
		switch -exact -- $index_control {

			32 {
				# 01 - indexed with auto-increment
				set i [expr {($i + 1) & 0xff}]
				SetRegister8 $r $i 0
			}
			64 {
				# 10 - indexed with auto-decrement
				set i [expr {($i - 1) & 0xff}]
				SetRegister8 $r $i 0
			}
		}

		# ----------------------------------
		# Force the action register to be R0
		# ----------------------------------
		set r 0

		# -------------------------------------
		# Add the index to the absolute address
		# -------------------------------------
		incr addr $i
	}

	# -----------------------------------
	# Return the effective memory address
	# -----------------------------------
#puts "addr final = [format "%04x" [expr {$addr & 0x7fff}]]"
	return [expr {$addr & 0x7fff}]
}

#==============================================================================
