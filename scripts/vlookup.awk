FNR==NR{
  a[$1]=$1
  next
}
{ if ($4 in a) {print $0, "RM"} else {print $0, "KP"} }
