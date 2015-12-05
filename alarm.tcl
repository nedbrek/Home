package require Tk
package require snack

set dl ""
set al ""

proc tformat {t} {
	set ret ""
	set neg 0
	if {$t < 0} {
		set t [expr -$t]
		set neg 1
	}

	if {$t > 3600} {
		set h [expr $t / 3600]
		append ret "$h h "
		incr t [expr -3600 * $h]
	}

	if {$t > 60} {
		set m [expr $t / 60]
		append ret "$m m "
		incr t [expr -60 * $m]
	} elseif {$ret ne ""} {
		append ret "0 m "
	}

	append ret "[format %02d $t] s"

	if {$neg} {
		return "-$ret"
	}
	return $ret
}

set lastSound 0
proc playSound {} {
	set t [clock seconds]
	if {$t >= $::lastSound+5} {
		set vol [snack::audio play_gain]
		snack::audio play_gain 60
		s play
		snack::audio play_gain $vol
	}

	raise .tMain
	set ::lastSound $t
}

proc decList {il} {
	upvar $il l
	foreach iu $l {
		upvar $iu i
		incr i -1

		.tMain.l$iu configure -text [tformat $i]

		if {$i == 0} {
			set idx [lsearch $l $iu]
			set l [lreplace $l $idx $idx]
		   after 1000 ".tMain.lT$iu configure -fg #008800"
		   after 5000 ".tMain.lT$iu configure -fg #000000"
			playSound
		}
	}
}

proc addLine {var tm tx} {
	set $var $tm
	lappend ::dl $var
	lappend ::al $var

	pack [frame .tMain.f$var] -side top -expand 1 -fill x
	pack [label .tMain.lT$var -text $tx] -in .tMain.f$var -side left
	pack [label .tMain.l$var] -in .tMain.f$var -side right
}

proc u {} {
	set t [expr [clock milliseconds] + 1000]
	decList ::dl
	after [expr $t - [clock milliseconds]] u
}
u

wm withdraw .
toplevel .tMain

addLine ::l1 [expr 2*3600] "Session"
addLine ::ts  3600 "Show"
addLine ::zr  7200 "Zero"
addLine ::gv  7200 "Give"
addLine ::b1  1800 "B1"
addLine ::b2  1800 "B2"
addLine ::b3  1800 "B3"
addLine ::b4  1800 "B4"

proc changeSet {n1 n2 op} {
	.tMain.fCalc.l configure -text [expr $::setH*3600 + $::setM*60 + $::setS]
}

set setH 0
set setM 0
set setS 0
trace add variable setH write changeSet
trace add variable setM write changeSet
trace add variable setS write changeSet

proc setTm {} {
	set v [.tMain.fCalc.cb get]
	set $v [.tMain.fCalc.l cget -text]
	if {[lsearch $::dl $v] == -1} {
		lappend ::dl $v
	}
}

proc up {} {
	set v [.tMain.fCalc.cb get]
	pack configure .tMain.f$v -after .tMain.f::l1
}

pack [frame .tMain.fCalc] -side top
pack [ttk::combobox .tMain.fCalc.cb -state readonly -width 8 -values $al
] -side left
pack [entry .tMain.fCalc.eh -width 3 -textvariable setH] -side left
pack [entry .tMain.fCalc.em -width 3 -textvariable setM] -side left
pack [entry .tMain.fCalc.es -width 3 -textvariable setS] -side left
pack [label .tMain.fCalc.l -text "0"] -side left
pack [button .tMain.fCalc.bS -text "Set" -command setTm] -side left
pack [button .tMain.fCalc.bU -text "Up" -command up] -side left

snack::sound s -load c:/ned/media/wav/Notify.wav

