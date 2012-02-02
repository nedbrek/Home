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

proc collapseDiff {} {
	set b $::vim::current(buffer)
	set l $::vim::range(begin)
	# Ned, check end==begin
	set origL $l

	# check that current line is a diff
	set cur [$b get $l]
	set firstChar [string index $cur 0]
	if {$firstChar eq " " || $firstChar eq "@"} {
		# diff markers (not true diff)
		$b delete $l
		return
	}

	# find the other line, start with next
	set nextLine [$b get [expr $l+1]]
	set prevLine [$b get [expr $l-1]]
	set oth $nextLine

	# is current + or -
	if {$firstChar eq "+"} {
		# look for -
		if {[string index $nextLine 0] ne "-"} {
			# not found, look at prev
			if {[string index $prevLine 0] ne "-"} {
				if {[isDoNothingLine $cur]} {
					$b delete $l
				}
				return ;# not found
			}
			set oth $prevLine
			incr l -1
		}
	} else {
		if {$firstChar ne "-"} { return } ;# something horribly wrong

		if {[string index $nextLine 0] ne "+"} {
			if {[string index $prevLine 0] ne "+"} {
				if {[isDoNothingLine $cur]} {
					$b delete $l
				}
				return
			}
			set oth $prevLine
			incr l -1
		}
	}

	# retrieve current and other source line (strip lead char)
	set curTxt [string range $cur 1 end]
	set nxtTxt [string range $oth 1 end]

	# compare
	if {$curTxt ne $nxtTxt} {
		if {[isDoNothingLine $cur]} {
			$b delete $origL
		}
		return ;# different, leave intact
	}
	# else, merge

	$b delete $l
	$b set $l " $curTxt"
}

