proc diffCol {s1 s2} {
	set minLength [string length $s1]
	set s2length  [string length $s2]

	set sameLength [expr {$minLength == $s2length}]

	if {$s2length < $minLength} {
		set minLength $s2length
	}

	for {set i 0} {$i < $minLength} {incr i} {
		if {[string index $s1 $i] ne [string index $s2 $i]} {
			return [expr {$i+1}]
		}
	}

	if {$sameLength && $i == $minLength} {
		return 0
	}

	return [expr {$i+1}]
}

proc isDoNothingLine {l} {
	set firstChar [string index $l 0]

	# whitespace is ok
	if {[regexp {^[-+]$} $l]} {
		return 1
	}

	# comments is ok
	if {[regexp {^[-+][ \t]*//} $l]} {
		return 1
	}

	return 0
}

proc earlyOut {b l cur {col 0}} {
	if {[isDoNothingLine $cur]} {
		$b delete $l
	} elseif {$col == 0} {
		# move to next section
		set firstChar [string index $cur 0]
		if {$firstChar eq "+"} {
			set next "-"
		} elseif {$firstChar eq "-"} {
			set next "+"
		} else {
			# move down one
			::vim::command {normal j}
			return
		}

		set r [subst {^\[ $next\]}]
		::vim::command "call search('$r', 'W')"
	} else {
		# move to column with the difference
		::vim::command [format {normal 0%d } $col]
	}
}

proc collapseDiff {} {
	set b $::vim::current(buffer)
	set l $::vim::range(begin)
	# Ned, check end==begin
	set origL $l

	# get first line
	set cur [$b get $l]
	# find the other line, start with next
	set nextLine [$b get [expr $l+1]]
	set prevLine [$b get [expr $l-1]]

	# what type of line are we on
	set firstChar [string index $cur 0]
	if {$firstChar eq " "} {
		# matching line
		$b delete $l
		return
	}

	set prevFirstChar [string index $prevLine 0]
	# if diff marker (not true diff)
	if {$firstChar eq "@"} {
		# if line above is also diff, delete it instead
		if {$prevFirstChar eq "@"} {
			$b delete [expr $l - 1]
		} else {
			$b delete $l
		}
		return
	}

	set oth $nextLine

	# is current + or -
	if {$firstChar eq "+"} {
		# look for -
		if {[string index $nextLine 0] ne "-"} {
			# not found, look at prev
			if {[string index $prevLine 0] ne "-"} {
				earlyOut $b $l $cur
				return ;# not found
			}
			set oth $prevLine
			incr l -1
		}
	} else {
		if {$firstChar ne "-"} { return } ;# something horribly wrong

		if {[string index $nextLine 0] ne "+"} {
			if {[string index $prevLine 0] ne "+"} {
				earlyOut $b $l $cur
				return
			}
			set oth $prevLine
			incr l -1
		}
	}

	# retrieve current and other source line (strip lead char)
	set curTxt [string range $cur 1 end]
	set r1 "-1 -1"
	regexp -indices {^[ \t]+} $curTxt r1

	set curT   [string replace $curTxt [lindex $r1 0] [lindex $r1 1]]
	set nxtTxt [regsub {^[ \t]+} [string range $oth 1 end] ""]

	# compare
	set col [diffCol $curT $nxtTxt]
	if {$col != 0} {
		earlyOut $b $origL $cur [expr {[lindex $r1 1] + 1 + $col}]
		return ;# different, leave intact
	}
	# else, merge

	$b delete $l
	$b set $l " $curTxt"
}

