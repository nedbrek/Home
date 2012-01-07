proc collapseDiff {} {
	set b $::vim::current(buffer)
	set l $::vim::range(begin)
	# Ned, check end==begin

	# check that current line is a diff
	set cur [$b get $l]
	set firstChar [string index $cur 0]
	if {$firstChar eq " "} {
		return ;# not a diff line
	}

	# find the other line, start with next
	set oth [$b get [expr $l+1]]

	if {$firstChar eq "+"} {
		# should be -
		if {[string index $oth 0] ne "-"} {
			incr l -1
			set oth [$b get $l]
			if {[string index $oth 0] ne "-"} {
				return
			}
		}
	} else {
		if {$firstChar ne "-"} { return } ;# something horribly wrong

		if {[string index $oth 0] ne "+"} {
			incr l -1
			set oth [$b get $l]
			if {[string index $oth 0] ne "+"} {
				return
			}
		}
	}

	# retrieve current and other source line (strip lead char)
	set curLine [string range $cur 1 end]
	set nxtLine [string range $oth 1 end]

	# compare
	if {$curLine ne $nxtLine} {
		return ;# different, leave intact
	}
	# else, merge

	$b delete $l
	$b set $l " $curLine"
}

