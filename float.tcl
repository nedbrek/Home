#!/usr/bin/env wish

proc cvtFloat {hex_val} {
	set bin [binary format H* $hex_val]
	binary scan $bin R ret
	return $ret
}

proc cvtDbl {hex_val} {
	set bin [binary format H* $hex_val]
	binary scan $bin Q ret
	return $ret
}

proc go {} {
	set val [.fVal.eVal get]
	if {$val eq ""} {
		return
	}

	if {$::val_sz == 4} {
		.fOutput.tOut insert end "[cvtFloat $val]\n"
	} elseif {$::val_sz == 8} {
		.fOutput.tOut insert end "[cvtDbl $val]\n"
	}
}

pack [frame .fVal] -side top
pack [label .fVal.lVal -text "Hex Value"] -side left
pack [entry .fVal.eVal] -side left

set val_sz 4
pack [frame .fSize] -side top
pack [radiobutton .fSize.rbFloat -text "Float (4B)" -value 4 -variable val_sz] -side left
pack [radiobutton .fSize.rbDouble -text "Double (8B)" -value 8 -variable val_sz] -side left

pack [frame .fButtons] -side top
pack [button .fButtons.bGo -text "Go" -command go] -side left

pack [frame .fOutput] -side top
pack [text .fOutput.tOut] -side left

