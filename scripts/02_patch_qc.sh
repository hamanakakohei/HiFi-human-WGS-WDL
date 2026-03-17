#!/bin/bash
set -euo pipefail

uuid_stem=$1
outdir="results/02_patch_qc/"
mkdir -p "$outdir"


## 0. データ（サンプル重複あり）の一覧を見て重複サンプルの古いデータは消したい
# --> 必要なし


## 1. cromwellログ
# --> 必要なし


# 2以降の準備
cd "$outdir"
PREFIX="../../cromwell-executions/humanwgs_family_02patch/${uuid_stem}/"


## 2. サンプルとdownstreamタスクのUUIDのマッピングを作成
#MAP_FILE="sample_uuid_map.tsv"
#> "$MAP_FILE"

declare -A UUIDs
#for bam in ${PREFIX}call-downstream/shard-*/downstream/*/call-hiphase/inputs/*/*.GRCh38.bam; do
for shard in $(seq 0 23); do
    #uuid=$(echo "$bam" | awk -F'/' '{print $(NF-4)}')
    #sample=$(basename "$bam" | cut -d. -f1)
    #UUIDs[$uuid]=$sample
    UUIDs[$shard]=$shard
    #echo -e "$sample\t$uuid" >> "$MAP_FILE"
done


# 3-1. 全タスクの成功したかの一覧を得る
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

echo -e "uuid\t\
sv_subset\t\
sv_vep" > qc_simple_sv.out

for uuid in a; do
    sample=sv
    printf "%s\t%s" "$uuid" "$sample"
    printf "\t"; collect_rc "${PREFIX}call-sv_subset/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-sv_vep/execution/rc"
    printf "\n"
done >> qc_simple_sv.out


# 3-2. 全uuid x 全downstreamタスクの成功したかの一覧を得る
echo -e "uuid\tsample\t\
subset_vcf_by_chr\t\
subset_vcf_by_sample\t\
make_site_vcf\t\
normalize_vcf\t\
vep_vcf" > qc_simple_snv.out

for uuid in "${!UUIDs[@]}"; do
    sample=${UUIDs[$uuid]}
    printf "%s\t%s" "$uuid" "$sample"
    printf "\t"; collect_rc "${PREFIX}call-subset_vcf_by_chr/shard-${uuid}/execution/rc"      
    printf "\t"; collect_rc "${PREFIX}call-subset_vcf_by_sample/shard-${uuid}/execution/rc" 
    printf "\t"; collect_rc "${PREFIX}call-make_site_vcf/shard-${uuid}/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-normalize_vcf/shard-${uuid}/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-vep_vcf/shard-${uuid}/execution/rc"
    printf "\n"
done >> qc_simple_snv.out


# 4. 各タスクの細かいログを全サンプル分得る
log_types=(
    stderr.submit
    stdout.submit
    stderr.qsub
    stdout.qsub
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
  [subset_vcf_by_chr]="${PREFIX}call-subset_vcf_by_chr/shard-{uuid}/execution/{log}"      
  [subset_vcf_by_sample]="${PREFIX}call-subset_vcf_by_sample/shard-{uuid}/execution/{log}" 
  [make_site_vcf]="${PREFIX}call-make_site_vcf/shard-{uuid}/execution/{log}"
  [normalize_vcf]="${PREFIX}call-normalize_vcf/shard-{uuid}/execution/{log}"
  [vep_vcf]="${PREFIX}call-vep_vcf/shard-{uuid}/execution/{log}"
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
