#==============================================================================
# ==================================================
# arith.tcl - utility procedures for 8-bit addition,
# subtraction and comparison
# ==================================================

# Copyright 2005 (C) Peter Linich

#==============================================================================
# ================================================
# Add - adds two 8-bit values and sets the various
# bits (except for the Condition Code) according
# to the progress and result of the operation
# ================================================

proc Add {a b} {

	# ----l----------------------
	# Add - optionally with carry
	# ---------------------------
	set sum [expr {$a + $b}]
	if {[GetPSW wc] && [GetPSW c]} {incr sum}

	# ---------------------------
	# Set or reset the carry flag
	# ---------------------------
	SetPSW c [expr {$sum > 255}]

	# -------------------------------
	# Set/reset the inter-digit carry
	# -------------------------------
	set axorb [expr {$a ^ $b}]
	SetPSW idc [expr {(($axorb ^ $sum) & 0x10) != 0}]

	# -----------------------------------
	# Set/reset the signed-8-bit overflow
	# -----------------------------------
	SetPSW ovf [expr {($axorb & 0x80) ? 0 : (($a ^ $sum) & 0x80) != 0}]

	# -----------------------
	# Return the 8-bit result
	# -----------------------
	return [expr {$sum & 0xff}]
}

#==============================================================================
# ==========================================================
# Subtract - subtracts two 8-bit values and sets the various
# bits (except for the Condition Code) according to the
# progress and result of the operation
# ==========================================================

proc Subtract {a b} {

	# --------------------------------
	# Subtract - optionally with carry
	# --------------------------------
	set diff [expr {(256 + $a) - $b}]
	if {[GetPSW wc] && [GetPSW c]} {incr diff -1}

	# ---------------------------
	# Set or reset the carry flag
	# ---------------------------
	SetPSW c [expr {$diff > 255}]

	# -------------------------------
	# Set/reset the inter-digit carry
	# -------------------------------
	set axorb [expr {$a ^ $b}]
	SetPSW idc [expr {(($axorb ^ $diff) & 0x10) != 0}]

	# -----------------------------------
	# Set/reset the signed-8-bit overflow
	# -----------------------------------
	SetPSW ovf [expr {($axorb & 0x80) ? 0 : (($a ^ $diff) & 0x80) != 0}]

	# -----------------------
	# Return the 8-bit result
	# -----------------------
	return [expr {$diff & 0xff}]
}

#==============================================================================
# =================================================
# Compare - compares two 8-bit values (as signed or
# unsigned depending on COM) and sets the Condition
# Code accordingly
# =================================================

proc Compare {a b} {

	if {[GetPSW com] == 0} {
		if {$a > 127} {incr a -128}
		if {$b > 127} {incr b -128}
	}

	if {$a > $b} {
		SetPSW cc 1
	} else {
		if {$a < $b} {
			SetPSW cc 2
		} else {
			SetPSW cc 0
		}
	}
}

#==============================================================================
