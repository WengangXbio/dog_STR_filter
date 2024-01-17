FNR==NR{
  a[$1]=$1
  next
}
{ if ($5 in a) {print $0, "KP"} else {print $0, "RM"} }
