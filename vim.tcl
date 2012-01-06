proc collapseDiff {} {
   set b $::vim::current(buffer)
   set l $::vim::range(begin)
   # Ned, check end==begin

   # retrieve current and next line
   set curLine [string range [$b get $l] 1 end]
   set nxtLine [string range [$b get [expr $l+1]] 1 end]

   # compare
   if {$curLine ne $nxtLine} {
   return ;# different, leave intact
   }
   # else, merge

   $b delete $l
   $b set $l " $curLine"
}

