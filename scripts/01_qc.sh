#!/bin/bash
set -euo pipefail

outdir="results/01_qc/"
mkdir -p "$outdir"


## 0. データ（サンプル重複あり）の一覧を見て重複サンプルの古いデータは消したい
#ls -lrt cromwell-executions/humanwgs_family_01/*/call-upstream/shard-0/upstream/*/call-pbmm2/shard-0/pbmm2/*/call-pbmm2_align_wgs/shard-0/execution/Sample_*.hifi_reads*.GRCh38.aligned.bam
## 一度消してしまったらこっちを使う：
#ls -lrt cromwell-executions/humanwgs_family_01/*/call-upstream/shard-0/upstream/*/call-merge_hifi_bams/execution/Sample_*.GRCh38.bam


# 1. cromwellログ
ls -l logs/01/*.e.log > ${outdir}1.log
ls -l logs/01/*.o.log | sort -k5,5n > ${outdir}2.log
ls logs/01/*.o.log | xargs -I{} bash -c 'echo -n {}" "; grep -e ucceed {} || true; echo -e ""' > ${outdir}3.log


# 2以降の準備
cd "$outdir"
PREFIX="../../cromwell-executions/humanwgs_family_01/"
#PREFIX="../../cromwell-executions/humanwgs_family/"


# 2. サンプルとUUIDのマッピングを作成
MAP_FILE="sample_uuid_map.tsv"
> "$MAP_FILE"

declare -A UUIDs
#for bam in ${PREFIX}*/call-upstream/shard-0/upstream/*/call-pbmm2/shard-0/pbmm2/*/call-pbmm2_align_wgs/shard-0/execution/Sample_*.hifi_reads*.GRCh38.aligned.bam; do
## 一度消してしまったらこっちを使う：
for bam in ${PREFIX}*/call-upstream/shard-0/upstream/*/call-merge_hifi_bams/execution/Sample_*.GRCh38.bam; do
    uuid=$(echo "$bam" | awk -F'/' '{print $5}')
    sample=$(basename "$bam" | cut -d. -f1)
    UUIDs[$uuid]=$sample
    echo -e "$sample\t$uuid" >> "$MAP_FILE"
done


# 3. 全uuid x 全タスクの成功したかの一覧を得る
collect_rc() {
    local exec_glob="$1"
    local input_glob="${exec_glob/execution\/rc/inputs}"

    shopt -s nullglob

    # rc ファイルを配列で取得
    local rc_files=( $exec_glob )
    local input_dirs=( $input_glob )

    shopt -u nullglob

    local n_expected=${#input_dirs[@]}
    local n_found=${#rc_files[@]}

    if (( n_found > 0 )); then
        local vals=()
        for rc in "${rc_files[@]}"; do
            vals+=( "$(tr -d '\n' < "$rc")" )
        done
        printf "%s/%d" "$(IFS=';'; echo "${vals[*]}")" "$n_expected"
    else
        printf "NA/%d" "$n_expected"
    fi
}

echo -e "uuid\tsample\t\
process_trgt_catalog:subset_reference\t\
process_trgt_catalog:filter_trgt_catalog\t\
upstream:pbmm2:pbmm2_align_wgs\t\
upstream:pbmm2:split_input_bam\t\
upstream:bait_fail_reads\t\
upstream:align_captured_fail_reads\t\
upstream:subset_bam\t\
upstream:merge_hifi_bams\t\
upstream:mosdepth\t\
upstream:deepvariant:deepvariant_make_examples\t\
upstream:deepvariant:deepvariant_call_variants_cpu\t\
upstream:deepvariant:deepvariant_postprocess_variants\t\
upstream:sawfish_discover\t\
upstream:paraphase\t\
upstream:mitorsaw\t\
upstream:merge_hifi_fail_bams\t\
upstream:trgt" > qc_simple.out

for uuid in "${!UUIDs[@]}"; do
    sample=${UUIDs[$uuid]}
    printf "%s\t%s" "$uuid" "$sample"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-process_trgt_catalog/process_trgt_catalog/*/call-subset_reference/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-process_trgt_catalog/process_trgt_catalog/*/call-filter_trgt_catalog/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-pbmm2_align_wgs/shard-*/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-bait_fail_reads/shard-*/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-align_captured_fail_reads/shard-*/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-subset_bam/shard-*/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-merge_hifi_bams/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-mosdepth/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_make_examples/shard-*/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_call_variants_cpu/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_postprocess_variants/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-sawfish_discover/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-paraphase/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-mitorsaw/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-merge_hifi_fail_bams/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-upstream/shard-0/upstream/*/call-trgt/execution/rc"
    printf "\n"
done >> qc_simple.out


# 4. 各タスクの細かいログを全サンプル分得る
log_types=(
    stderr.submit
    stdout.submit
    stderr.slurm
    stdout.slurm
    stderr
    stdout
)

collect_logs() {
    local log_glob="$1"

    shopt -s nullglob
    local logs=( $log_glob )
    shopt -u nullglob

    if (( ${#logs[@]} > 0 )); then
        for f in "${logs[@]}"; do
            echo "### $(basename "$f")"
            cat "$f"
            echo
        done
    else
        echo "### NO LOG FILES"
    fi
}

declare -A TASK_LOG_GLOBS=(
  [process_trgt_catalog:subset_reference]="${PREFIX}/{uuid}/call-process_trgt_catalog/process_trgt_catalog/*/call-subset_reference/execution/{log}"
  [process_trgt_catalog:filter_trgt_catalog]="${PREFIX}/{uuid}/call-process_trgt_catalog/process_trgt_catalog/*/call-filter_trgt_catalog/execution/{log}"

  [upstream:pbmm2:pbmm2_align_wgs]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-pbmm2_align_wgs/shard-*/execution/{log}"
  [upstream:pbmm2:split_input_bam]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/execution/{log}"

  [upstream:bait_fail_reads]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-bait_fail_reads/shard-*/execution/{log}"
  [upstream:align_captured_fail_reads]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-align_captured_fail_reads/shard-*/execution/{log}"
  [upstream:subset_bam]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-subset_bam/shard-*/execution/{log}"
  [upstream:merge_hifi_bams]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-merge_hifi_bams/execution/{log}"
  [upstream:mosdepth]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-mosdepth/execution/{log}"

  [upstream:deepvariant:deepvariant_make_examples]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_make_examples/shard-*/execution/{log}"
  [upstream:deepvariant:deepvariant_call_variants_cpu]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_call_variants_cpu/execution/{log}"
  [upstream:deepvariant:deepvariant_postprocess_variants]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_postprocess_variants/execution/{log}"

  [upstream:sawfish_discover]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-sawfish_discover/execution/{log}"
  [upstream:paraphase]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-paraphase/execution/{log}"
  [upstream:mitorsaw]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-mitorsaw/execution/{log}"
  [upstream:merge_hifi_fail_bams]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-merge_hifi_fail_bams/execution/{log}"
  [upstream:trgt]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-trgt/execution/{log}"
)

mkdir -p qc_details
for task in "${!TASK_LOG_GLOBS[@]}"; do
    for log in "${log_types[@]}"; do
        outfile="qc_details/${task}_${log}.out"
        : > "$outfile"

        for uuid in "${!UUIDs[@]}"; do
            sample=${UUIDs[$uuid]}

            echo "# Sample: ${sample} (uuid=${uuid})" >> "$outfile"

            pattern="${TASK_LOG_GLOBS[$task]}"
            pattern="${pattern/\{uuid\}/$uuid}"
            pattern="${pattern/\{log\}/$log}"

            collect_logs "$pattern" >> "$outfile"
            echo >> "$outfile"
        done
    done
done
