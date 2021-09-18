#==============================================================================
# ============================================================
# controls.tcl - interfaces to the on-screen emulator controls
# ============================================================

# Copyright 2005 (C) Peter Linich

namespace eval controls {

	#==============================================================================
	# =====================================================
	# Initialise - creates the run, stop, etc. controls
	# on the display
	# =====================================================

	proc Initialise f {

		variable fcontrols
		set fcontrols $f

		#if debug_gui
		button $fcontrols.run -text "Run" -command Run
		grid $fcontrols.run -row 0 -column 0 -sticky ew
		#endif

		button $fcontrols.reset -text "Reset" -command Reset
		#ifnot debug_gui
			$fcontrols.reset configure		\
				-activebackground	#101010	\
				-background		#202020	\
				-activeforeground	red	\
				-foreground		red	\
				-borderwidth		0	\
				-highlightthickness	0
		#endif
		grid $fcontrols.reset -row 1 -column 0 -sticky ew

		#if debug_gui
		global stop
		checkbutton $fcontrols.step -text "Step" -variable stop -onvalue 1 -offvalue 0
		grid $fcontrols.step -row 2 -column 0 -sticky ew
		#endif

		grid columnconfigure $fcontrols 0 -weight 1
	}

	#==============================================================================

	proc EnableRunTimeControls {} {

		#if debug_gui
		variable fcontrols

		$fcontrols.run configure -state normal
		#endif
	}

	#==============================================================================

	proc DisableRunTimeControls {} {

		#if debug_gui
		variable fcontrols

		$fcontrols.run configure -state disabled
		#endif
	}

	#==============================================================================

	namespace export EnableRunTimeControls
	namespace export DisableRunTimeControls
}

namespace import controls::EnableRunTimeControls
namespace import controls::DisableRunTimeControls

#==============================================================================
