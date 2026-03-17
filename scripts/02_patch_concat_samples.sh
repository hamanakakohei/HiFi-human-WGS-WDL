#!/usr/bin/env bash
#
# IN_VCF_LISTは染色体順にするのが大事かも
set -euo pipefail
PER_CHR_VCF_LIST=$1
OUT_VCF=$2
THREAD=$3

export PATH=$PATH:/path/to/bcftools-1.22/bin/

bcftools concat \
  --threads $THREAD \
  -Oz \
  -o $OUT_VCF \
  $(tr '\n' ' ' < $PER_CHR_VCF_LIST)

bcftools index -t $OUT_VCF
