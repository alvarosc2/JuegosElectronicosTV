#==============================================================================
# =======================================
# memory.tcl - interfaces to the emulated
# development board ROM and RAM
# =======================================

# Copyright 2005 (C) Peter Linich

namespace eval memory {

	#==============================================================================
	# =============
	# Configuration
	# =============

							# Must be multiple of 16
	variable MEMORY_DISPLAY_SIZE			64

	variable RAM_START				1024
	variable RAM_END				1535

	#==============================================================================
	# ====================================================
	# LoadROM - loads the ROM values into the memory array
	# ====================================================

	proc LoadROM {} {

		global ROM

		variable mem
		variable rom_top

		set rom_top 0
		foreach chunk $ROM {
			set xofs [lindex $chunk 0]
			if {[string length $xofs] != 4 || [scan $xofs "%x%c" ofs dummy] != 1} {
				WriteDiagnostic "Bad ROM offset: $xofs"
				return
			}
			if {$rom_top != $ofs} {
				WriteDiagnostic "ROM discontinuity: expected [format "%04x" $rom_top], saw $xofs"
				return
			}
			set n [llength $chunk]
			for {set i 1} {$i < $n} {incr i} {
				set xb [lindex $chunk $i]
				if {[string length $xb] != 2 || [scan $xb "%x%c" b dummy] != 1} {
					WriteDiagnostic "Bad ROM byte value: $xb @ [format "%04x" $rom_top]"
					return
				}
				set mem($rom_top) $b
				incr rom_top
			}
		}
#		WriteDiagnostic "$rom_top byte(s) of ROM loaded..."
	}

	#==============================================================================
	# ================================================
	# CreateMemoryDisplay - creates the initial memory
	# display panel and the up and down buttons
	# ================================================

	#if debug_gui
	proc CreateMemoryDisplay f {

		variable memdisp
		variable memdisp_value
		variable MEMORY_DISPLAY_SIZE

		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		# Create the memory array and the row address labels
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		for {set i 0; set n 0; set y 0} {$i < $MEMORY_DISPLAY_SIZE} {incr i 16} {
			entry $f.r${y} -width 4 -textvariable memory::memdisp(ofs.$i)
			grid $f.r${y} -row $y -column 0
			for {set x 1} {$x <= 16} {incr x; incr n} {
				entry $f.e${n} -width 2 -textvariable memory::memdisp($n)
				grid $f.e${n} -row $y -column $x
				set memdisp_value($n) ""
			}
			incr y
		}
		for {set x 1} {$x <= 16} {incr x} {
			grid columnconfigure $f $x -weight 1 -uniform mem
		}

		# ----------------------------------
		# Now create the up and down buttons
		# ----------------------------------
		set d [expr {$MEMORY_DISPLAY_SIZE / 16 / 2}]
		button $f.up -text "Up" -command {
			namespace eval memory {
				SetMemoryDisplayOffset \
				[expr {($memory_display_first + $MEMORY_DISPLAY_SIZE) & 0x7fff}]
			}
		}
		button $f.dn -text "Down" -command {
			namespace eval memory {
				SetMemoryDisplayOffset \
				[expr {($memory_display_first - $MEMORY_DISPLAY_SIZE) & 0x7fff}]
			}
		}
		grid $f.up -row 0 -column 17 -sticky news -rowspan $d
		grid $f.dn -row $d -column 17 -sticky news -rowspan $d
	}
	#endif

	#==============================================================================
	# =========================================================
	# SetMemoryDisplayOffset - set the offset of the first byte
	# of the memory display panel and update the display to
	# reflect the new offset
	# =========================================================

	#if debug_gui
	proc SetMemoryDisplayOffset ofs {

		variable MEMORY_DISPLAY_SIZE
		variable mem
		variable memdisp
		variable memory_display_first
		variable memory_display_last

		# -------------------------------------------------------------
		# Calculate start and end addresses for the auto-update routine
		# -------------------------------------------------------------
		set memory_display_first $ofs
		set memory_display_last [expr {$ofs + $MEMORY_DISPLAY_SIZE - 1}]

		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		# Now write the values in the displayed range to the display
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		for {set i 0} {$i < $MEMORY_DISPLAY_SIZE} {} {
			set memdisp(ofs.$i) [format "%04x" $ofs]
			for {set x 1} {$x <= 16} {incr x; incr i; incr ofs} {
				DisplayMemoryByte $ofs $i
			}
		}
	}
	#endif

	#==============================================================================
	# ================================================
	# DisplayMemoryByte - writes the byte at the given
	# address to the memory display position #n. n
	# will be determined if not provided. The write
	# will only occur if the presently-displayed value
	# is not correct
	# ================================================

	#if debug_gui
	proc DisplayMemoryByte {addr {n {}}} {

		if {$n == {}} {
			variable memory_display_first
			variable memory_display_last
			if {$addr < $memory_display_first || $addr > $memory_display_last} return
			set n [expr {$addr - $memory_display_first}]
		}

		variable memdisp_value
		set b [ReadMemory $addr]
		if {$memdisp_value($n) == $b} return
		variable memdisp
		set memdisp_value($n) $b
		set memdisp($n) [format "%02x" $b]
	}
	#endif

	#==============================================================================
	# ===============================================
	# ReadMemory - returns the byte at the given address
	# in ROM or RAM, or 0xff if not in ROM or RAM
	# ===============================================

	proc ReadMemory addr {

		variable mem
		return $mem($addr)

#		variable RAM_START
#		variable RAM_END
#		variable rom_top
#
##puts "Reading memory @ [format "%04x" $addr]"
#
#		if {$addr < $rom_top || ($addr >= $RAM_START && $addr <= $RAM_END)} {
#			variable mem
#			return $mem($addr)
#		} else {
#			return 255
#		}
	}

	#==============================================================================
	# ==========================================================
	# WriteMemory - writes the byte b at the given address. This
	# only does something if the given address in in RAM space.
	# The changed value is then displayed or queued for display
	# ==========================================================

	proc WriteMemory {addr b} {

		variable RAM_START
		variable RAM_END

#puts "WriteMemory @ [format "%04x" $addr] : [format "%02x" $b]"

		# -----------------
		# Proceed if in RAM
		# -----------------
		if {$addr >= $RAM_START && $addr <= $RAM_END} {

			# -------------
			# Update memory
			# -------------
			variable mem
			set mem($addr) $b

			# ------------------
			# Update the display
			# ------------------
			#if debug_gui
			DisplayMemoryByte $addr
			#endif
		}
	}

	#==============================================================================
	# =========================================
	# Initialise - creates our ROM and RAM, and
	# then builds the memory display GUI
	# =========================================

	proc Initialise {{f {}}} {

		variable mem
		variable RAM_START

		# $$$$$$$$$$$$$$$$$$$$$$$$$
		# Initialise/create our RAM
		# $$$$$$$$$$$$$$$$$$$$$$$$$
		for {set n 0} {$n <= 32767} {incr n} {set mem($n) 255}

		# ------------------
		# Initialise the ROM
		# ------------------
		LoadROM

		# ---------------------------------
		# Initialise the GUI memory display
		# ---------------------------------
		#if debug_gui
		CreateMemoryDisplay $f
		SetMemoryDisplayOffset $RAM_START
		#endif
	}

	#==============================================================================

	namespace export ReadMemory
	namespace export WriteMemory
}

#==============================================================================

namespace import memory::ReadMemory
namespace import memory::WriteMemory

#==============================================================================
