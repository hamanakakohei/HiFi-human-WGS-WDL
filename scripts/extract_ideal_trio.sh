awk -F"\t" '
NR==FNR {
  phe[$1, $2] = $6
  next
}
{
  fam = $1
  fa  = $3
  mo  = $4
  phe_child = $6

  if (phe_child == 2 && fa != 0 && mo != 0 && fa != "" && mo != "") {
    if (phe[fam, fa] == 1 && phe[fam, mo] == 1) {
      print fam
    }
  }
}
' ped.txt ped.txt | sort -u

