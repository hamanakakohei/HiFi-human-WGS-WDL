#!/usr/bin/env bash
#
# 1: 染色体ごとのVCFをつくる
# 2: サンプルごとにわけて、染色体名のディレクトリに入れる
#
# 注意点：OUT_DIRは最後にスラッシュをつける
set -euo pipefail
VCF=$1
CHR=$2
OUT_DIR=$3
THREAD=$4

VCF_BASENAME=`basename $VCF .vcf.gz`
PER_CHR_VCF=${OUT_DIR}${VCF_BASENAME}.${CHR}.vcf.gz

export PATH=$PATH:/path/to/bcftools-1.22/bin/


# 1
bcftools view \
  --threads $THREAD \
  -r $CHR \
  -Oz \
  -o ${PER_CHR_VCF} \
  ${VCF}

bcftools index -t ${PER_CHR_VCF}


# 2
mkdir ${OUT_DIR}$CHR

bcftools +split \
  -W=tbi -Oz -o ${OUT_DIR}$CHR \
  ${PER_CHR_VCF}
