#!/usr/bin/env bash
#
# 1: 2用のinput.jsonを作る
# 2: joint
#
# HiFi-Human-WGS-WDLのやり方でjoint vcfをsingle sample vcfにすると時間がかかりすぎるのと、
# (cromwell通しても通さなくても)qsub時に同時に開けるファイル数の制限にかかったので、localでbcftools splitする：
# - 2-1-1 ver1: joint vcfをchr毎に分けて、sample毎に分けるのを1回でやる
# - 2-1-1 ver2: joint vcfをchr毎に分けて、sample毎に分けるのを2回でやる 
# - 2-1-2: chr毎のvcfをconcatしてsample毎のvcfを作る
#
# 2-2: joint vcfをvepする & ctrl_AC/AN計算
# 3-1: 3-2用のinput.jsonを全家系分作る
# 3-2: 各家系でtertiary解析する
# 3-3: QCと後始末
# 3-4: 家系毎のレアデノボを数える
# 3-5: 全サンプルのレアデノボ表を結合する
#
# to do: cromwell qsubスクリプト全て同じでよい
set -euo pipefail


# 1
source /path/to/env.sh
python3 scripts/01_make_input_json_of_cohort.py \
  --title 3431samples \
  --bam inputs/01/3434samples_bamPath.list \
  --gvcf inputs/01/3434samples_gvcfPath.list \
  --ped inputs/01/samples.ped \
  --preemptible \
  --out_prefix results/01/3431samples.input \
  > logs/01/log 2>&1


# 2
qsub qsubs/02_hifi_joint_small_variants_only.qsub \
  workflows/family.edit4cohort.02.small_variants_only.wdl \
  results/01/3431samples.input.json


## 2-1-1 ver1. 
## split by chr & sample
#JOINT_VCF=cromwell-executions/humanwgs_family/72e72164-bd66-45d7-9b89-7f3253875ea2/call-joint/joint/2f2e07bb-17b9-48a6-bc0d-a8e24f25f0c2/call-glnexus/execution/3431samples.joint.GRCh38.small_variants.vcf.gz
#CHRS=inputs/02patch/chrs.txt
#STA=1
#END=24
#
#qsub -t ${STA}-${END}:1 -tc 1 \
#  qsubs/02_patch_split_by_chr_and_sample.qsub \
#  $JOINT_VCF \
#  $CHRS


# 2-1-1 ver2. 
# split by chr
JOINT_VCF=cromwell-executions/humanwgs_family/72e72164-bd66-45d7-9b89-7f3253875ea2/call-joint/joint/2f2e07bb-17b9-48a6-bc0d-a8e24f25f0c2/call-glnexus/execution/3431samples.joint.GRCh38.small_variants.vcf.gz
CHRS=inputs/02patch/chrs.txt
STA=1
END=24

qsub -t ${STA}-${END}:1 -tc 1 \
  qsubs/02_patch_split_by_chr_and_sample.qsub \
  $JOINT_VCF \
  $CHRS

# split by sample
OUT_DIR=results/02patch_split/

for CHR in `seq 1 22` X Y; do
  CHR=chr$CHR
  PER_CHR_VCF=${OUT_DIR}3431samples.joint.GRCh38.small_variants.${CHR}.vcf.gz
  mkdir ${OUT_DIR}$CHR

  bcftools +split \
    -W=tbi -Oz -o ${OUT_DIR}$CHR \
    ${PER_CHR_VCF}
done


# 2-1-2 
# concat samples
SAMPLE_AND_PER_CHR_VCF_LIST=inputs/02patch/per_chr_vcf_lists.txt
STA=1
END=$(wc -l < $SAMPLE_AND_PER_CHR_VCF_LIST)
END=2

qsub -t ${STA}-${END}:1 -tc 2 \
  qsubs/02_patch_concat_samples.qsub \
  $SAMPLE_AND_PER_CHR_VCF_LIST


# 2-2 vep & AC
WDL=workflows/family.edit4cohort.02patch.wdl
INPUT_JSON=inputs/02patch/family.edit4cohort.02patch.inputs.json

qsub \
    qsubs/02_hifi_patch.qsub \
    $WDL \
    $INPUT_JSON


uuid_stem=e163e001-98c9-4ff9-a4ec-470d8dc11c3e
cohort_id=3431samples
#bash scripts/02_patch_qc.sh $uuid_stem
bash scripts/02patch_cleanup_after_wdl.sh $uuid_stem $cohort_id



# 3-1
PHASED_SNV_VCF_MAP=results/03/sample_PhasedSnvVcf.txt
PHASED_SV_VCF_MAP=results/03/sample_PhasedSvVcf.txt
PHASED_TRGT_VCF_MAP=results/03/sample_PhasedTrgtVcf.txt
SEX_MAP=results/03/sample_inferredSex.txt
PED=inputs/03/samples.ped
TERTIARY_MAP=`pwd`/inputs/03/GRCh38.tertiary_map.v3p1p0.edit.tsv

python3 scripts/03_make_input_json_of_each_family.merge_tertiary.py \
    --phased_snv_vcf_map $PHASED_SNV_VCF_MAP \
    --phased_sv_vcf_map $PHASED_SV_VCF_MAP \
    --phased_trgt_vcf_map $PHASED_TRGT_VCF_MAP \
    --sex_map $SEX_MAP \
    --ped $PED \
    --tertiary_map $TERTIARY_MAP \
    --preemptible \
    --out_prefix results/03/ \
    > logs/03/3-1.log 2>&1


# 3-2
WDL=workflows/family.edit4cohort.03.small_variants_only.wdl
INPUT_JSON_LIST=inputs/03/input_json.list

STA=2
END=$(wc -l < $INPUT_JSON_LIST)
#END=1

qsub -t ${STA}-${END}:1 -tc 10 \
    qsubs/03_hifi_tertiary.qsub \
    $WDL \
    $INPUT_JSON_LIST


# 3-3
cohort_id=blank

bash scripts/03_qc.sh

while read -r SAMPLE UUID; do
    bash scripts/03_cleanup_after_wdl.sh $UUID $SAMPLE $cohort_id
done < results/03_qc/sample_uuid_map.tsv


# 3-4
ls cromwell-executions/humanwgs_family_03/*/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/execution/*.joint.GRCh38.small_variants.phased.norm.vcfanno.norm.slivar.tsv > results/03/slivar_tsv.list

while read -r TSV; do
    SAMPLE=$(basename $TSV)

    N_DOM=$(    awk '$1=="dominant"          ' $TSV | wc -l)
    N_DOM_AC0=$(awk '$1=="dominant" && $12==0' $TSV | wc -l)
    N_DOM_AC1=$(awk '$1=="dominant" && $12==1' $TSV | wc -l)
    
    echo $SAMPLE $N_DOM $N_DOM_AC0 $N_DOM_AC1 
done < results/03/slivar_tsv.list \
> results/03/slivar_tsv_count.txt


# 3-5
SLIVAR_TSV_LIST=results/03/slivar_tsv.list

EXCL_FILES=(
    aaa.joint.GRCh38.small_variants.phased.norm.vcfanno.norm.slivar.tsv
    bbb.joint.GRCh38.small_variants.phased.norm.vcfanno.norm.slivar.tsv
)

cat \
    <(
        head -n1 $(head -n1 $SLIVAR_TSV_LIST)
    ) \
    <(
        # 12列目がycu_ctrl_acと想定している
        grep -v $(printf -- '-e %s ' "${EXCL_FILES[@]}") $SLIVAR_TSV_LIST \
            | xargs -r -I{} tail -n+2 "{}" \
            | awk -F"\t" '$1=="dominant" && $12==0'
    ) \
    | awk -F'\t' 'BEGIN{OFS="\t"}{
        # 20列目がVEP CSQと想定している
        gsub("/", OFS, $20)
        print
    }' \
    > results/03/slivar_tsv_merged.txt

awk -F"\t" '
        NR==1 || 
        $17=="01_splice_acceptor" || 
        $17=="02_splice_donor" || 
        $17=="03_stop_gained" || 
        $17=="05_frameshift" || 
        $17=="06_stop_lost" || 
        $17=="07_start_lost" || 
        $17=="12_inframe_insertion" || 
        $17=="13_inframe_deletion" || 
        $17=="14_missense" || 
        $17=="20_splice_region" || 
        $17=="25_stop_retained" || 
        $17=="30_synonymous" || 
        $17=="33_mature_mirna" || 
        $17=="35_5_prime_utr" || 
        $17=="36_3_prime_utr" || 
        $17=="38_splice_donor_5th_base" || 
        $17=="39_splice_polypyrimidine_tract" || 
        $17=="40_splice_donor_region" || 
        $17=="42_non_coding_transcript_exon" || 
        $17=="64_regulatory_region"
    ' results/03/slivar_tsv_merged.txt \
    > results/03/slivar_tsv_merged_filtered.txt
