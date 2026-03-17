#!/usr/bin/env bash
set -euo pipefail


# 1-1
source /path/to/env.sh
SAMPLE_HIFI_BAM=inputs/01/sample_hifiReadsBam.txt
SAMPLE_FAIL_BAM=inputs/01/sample_failReadsBam.txt
PED=inputs/01/samples.ped

python3 scripts/01_make_input_json_of_each_sample.upstream.py \
    --hifi_bam_map $SAMPLE_HIFI_BAM \
    --fail_bam_map $SAMPLE_FAIL_BAM \
    --ped $PED \
    --preemptible \
    --out_prefix results/01/ \
    > logs/01/log 2>&1

find $PWD/results/01/ -name "*.json" > results/01/json.list


# 1-2
INPUT_JSON_LIST=results/01/json.list
WDL=workflows/family.edit4cohort.01.wdl

STA=1
END=$(wc -l < $INPUT_JSON_LIST)
#END=1

qsub -t ${STA}-${END}:1 -tc 1 \
    qsubs/01_hifi_upstream.qsub \
    $WDL \
    $INPUT_JSON_LIST


# 1-3 後始末（QC、リンク外し、不要ファイル消し、次で使うファイルリスト作り
# to do: 01_cleanup_after_wdl.shのno_fail_bam ver.はややこしいから統一したい、で最後にtreeとかで残っているbamをちょっと見れば良い
bash scripts/01_qc.sh
find cromwell-executions/humanwgs_family_01 -type l | xargs -I{} unlink {}

join <(
        awk -F"\t" '{
            n = split($2, a, ";")
            out = ""
            for(i=1; i<=n; i++){
                if(a[i] == "") continue
                sub(".*/", "", a[i])
                split(a[i], b, ".")
                out = out (out ? ";" : "") b[1]
            }
            print $1 "\t" out
        }' inputs/01/sample_hifiReadsBam.txt \
        | sort
    ) \
    <( sort results/01_qc/sample_uuid_map.tsv ) \
    > results/01/sample_movie_uuid.txt 

while read -r SAMPLE MOVIE UUID; do
    #bash scripts/01_cleanup_after_wdl.sh $SAMPLE $MOVIE $UUID
    bash scripts/01_cleanup_after_wdl_no_fail_bam.sh $SAMPLE $MOVIE $UUID
done < results/01/sample_movie_uuid.txt

find `pwd`/cromwell-executions/ -name "Sample_*.GRCh38.small_variants.g.vcf.gz" | grep "call-deepvariant_postprocess_variants\/execution" | awk -F"/" '{split($NF,A,"."); print A[1]"\t"$0}' > results/02/sample_SnvGvcf.txt
find `pwd`/cromwell-executions/ -name "Sample_*.tar"                            | grep "call-sawfish_discover\/execution"                 | awk -F"/" '{split($NF,A,"."); print A[1]"\t"$0}' > results/02/sample_DiscoverTar.txt
find `pwd`/cromwell-executions/ -name "Sample_*.GRCh38.bam"                     | grep "call-merge_hifi_bams\/execution"                  | awk -F"/" '{split($NF,A,"."); print A[1]"\t"$0}' > results/02/sample_OutBam.txt
find `pwd`/cromwell-executions/ -name "Sample_*.GRCh38.trgt.sorted.vcf.gz"      | grep "call-trgt\/execution"                             | awk -F"/" '{split($NF,A,"."); print A[1]"\t"$0}' > results/02/sample_TrgtVcf.txt

join -1 2 -2 1 \
    <(sort -k2,2 results/01_qc/sample_uuid_map.tsv) \
    <(
        ls cromwell-executions/humanwgs_family_01/*/call-upstream/shard-0/upstream/*/call-mosdepth/execution/inferred_sex.txt \
        | xargs -I{} bash -c '\
            echo {} | cut -d"/" -f3 | tr "\n" " "; \
            cat {}' \
        | sort
    ) \
    > results/02/sample_inferredSex.txt


# 2-1
source /path/to/env.sh
SNV_GVCF_MAP=results/02/sample_SnvGvcf.txt
TAR_MAP=results/02/sample_DiscoverTar.txt
OUT_BAM_MAP=results/02/sample_OutBam.txt
TRGT_VCF_MAP=results/02/sample_TrgtVcf.txt

PED=inputs/02/samples.ped
TRGT_CATALOG=inputs/02/trgt.bed

for FILES in $SNV_GVCF_MAP $TAR_MAP $OUT_BAM_MAP $TRGT_VCF_MAP; do
    cat \
        ../batch1/$FILES \
        ../batch2/$FILES \
        ../batch3/$FILES \
        > $FILES
done

python3 scripts/02_make_input_json.joint_downstream.py \
    --small_variant_gvcf_map $SNV_GVCF_MAP \
    --discover_tar_map $TAR_MAP \
    --out_bam_map $OUT_BAM_MAP \
    --trgt_vcf_map $TRGT_VCF_MAP \
    --ped $PED \
    --trgt_catalog $(realpath $TRGT_CATALOG) \
    --title 322samples \
    --preemptible \
    --out_prefix results/02/322samples \
    > logs/02/2-1.322samples.log 2>&1


# 2-2
WDL=workflows/family.edit4cohort.02.wdl
INPUT_JSON=results/02/322samples.json

qsub \
    qsubs/02_hifi_joint_downstream.qsub \
    $WDL \
    $INPUT_JSON


# 2-2 (downstream only)
WDL=workflows/family.edit4cohort.02.downstream_only.wdl
INPUT_JSON=results/02_downstream_only/322samples.json

qsub \
    -N hifi_02_downstream_only \
    -l s_vmem=128G \
    -o logs/02_downstream_only/2samples.o.log \
    -e logs/02_downstream_only/2samples.e.log \
    qsubs/cromwell.qsub \
    $WDL \
    $INPUT_JSON


# 2-3 後始末（QC、リンク外し、不要ファイル消し、次で使うファイルリスト作り
uuid_stem=6660c3b9-2d17-42d6-b6bf-4dad4390e910
bash scripts/02_qc.sh $uuid_stem
find cromwell-executions/humanwgs_family_02 -type l | xargs -I{} unlink {}

step02_uuid=6660c3b9-2d17-42d6-b6bf-4dad4390e910
cohort_id=322samples
while read -r SAMPLE UUID; do
    bash scripts/02_cleanup_after_wdl.sh $step02_uuid $cohort_id $SAMPLE $UUID
done < results/02_qc/sample_uuid_map.tsv


# 2-patch vep & AC
WDL=workflows/family.edit4cohort.02patch.wdl
INPUT_JSON=inputs/02patch/family.edit4cohort.02patch.inputs.json

qsub \
    -N hifi_02_patch \
    -l s_vmem=384G \
    -o logs/02_patch/322samples.o.log \
    -e logs/02_patch/322samples.e.log \
    qsubs/cromwell.qsub \
    $WDL \
    $INPUT_JSON


# 2-patch 後始末
uuid_stem=ef7ade3f-37a8-447a-9963-ba4740d1216b
cohort_id=322samples
#bash scripts/02_patch_qc.sh $uuid_stem
bash scripts/02patch_cleanup_after_wdl.sh $uuid_stem $cohort_id


# 3-1
UUID=a77bf520-961c-4752-a510-6fdad77475b1
find `pwd`/cromwell-executions/humanwgs_family/${UUID} -name "Sample_*.joint.GRCh38.small_variants.phased.vcf.gz"      | grep "call-hiphase\/execution" | awk -F"/" '{split($NF, A, "."); print A[1]"\t"$0}' > results/03/sample_PhasedSnvVcf.txt
find `pwd`/cromwell-executions/humanwgs_family/${UUID} -name "Sample_*.joint.GRCh38.structural_variants.phased.vcf.gz" | grep "call-hiphase\/execution" | awk -F"/" '{split($NF, A, "."); print A[1]"\t"$0}' > results/03/sample_PhasedSvVcf.txt
find `pwd`/cromwell-executions/humanwgs_family/${UUID} -name "Sample_*.GRCh38.trgt.sorted.phased.vcf.gz"               | grep "call-hiphase\/execution" | awk -F"/" '{split($NF, A, "."); print A[1]"\t"$0}' > results/03/sample_PhasedTrgtVcf.txt
join \
    <(cat \
        <(ls ../batch1/cromwell-executions/humanwgs_family_01/*/call-upstream/*/upstream/*/call-mosdepth/execution/*.GRCh38.depth_distribution.png) \
        <(ls ../batch2/cromwell-executions/humanwgs_family_01/*/call-upstream/*/upstream/*/call-mosdepth/execution/*.GRCh38.depth_distribution.png) \
        <(ls ../batch3/cromwell-executions/humanwgs_family_01/*/call-upstream/*/upstream/*/call-mosdepth/execution/*.GRCh38.depth_distribution.png) \
        | xargs -I{} bash -c 'dirname {} | tr "\n" " "; basename {} | cut -d"." -f1' | sort
    ) \
    <(cat \
        <(ls ../batch1/cromwell-executions/humanwgs_family_01/*/call-upstream/*/upstream/*/call-mosdepth/execution/inferred_sex.txt) \
        <(ls ../batch2/cromwell-executions/humanwgs_family_01/*/call-upstream/*/upstream/*/call-mosdepth/execution/inferred_sex.txt) \
        <(ls ../batch3/cromwell-executions/humanwgs_family_01/*/call-upstream/*/upstream/*/call-mosdepth/execution/inferred_sex.txt) \
        | xargs -I{} bash -c 'dirname {} | tr "\n" " "; cat {}'                      | sort
    ) \
    | awk '{print $2"\t"$3}' \
    > results/03/sample_inferredSex.txt


# 3-2
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


# 3-3
WDL=workflows/family.edit4cohort.03.wdl
INPUT_JSON_LIST=inputs/03/input_json.list

STA=171
END=$(wc -l < $INPUT_JSON_LIST)
END=171

qsub -t ${STA}-${END}:1 -tc 1 \
    -N hifi_03 \
    -l s_vmem=256G \
    -o 'logs/03/322samples.$TASK_ID.o.log' \
    -e 'logs/03/322samples.$TASK_ID.e.log' \
    qsubs/cromwell_array.qsub \
    $WDL \
    $INPUT_JSON_LIST
    #qsubs/03_hifi.qsub \


# 3-4 後始末
cohort_id=322samples

bash scripts/03_qc_incl._sv.sh 

while read -r SAMPLE UUID; do
    bash scripts/03_cleanup_after_wdl.sh $UUID $SAMPLE $cohort_id
done < results/03_qc_incl._sv/sample_uuid_map.tsv
