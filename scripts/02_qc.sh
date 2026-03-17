#!/bin/bash
set -euo pipefail

uuid_stem=$1
outdir="results/02_qc/"
mkdir -p "$outdir"


## 0. データ（サンプル重複あり）の一覧を見て重複サンプルの古いデータは消したい
# --> 必要なし


## 1. cromwellログ
# --> 必要なし


# 2以降の準備
cd "$outdir"
#PREFIX="../../cromwell-executions/humanwgs_family_02/${uuid_stem}/"
PREFIX="../../cromwell-executions/humanwgs_family/${uuid_stem}/"


# 2. サンプルとdownstreamタスクのUUIDのマッピングを作成
MAP_FILE="sample_uuid_map.tsv"
> "$MAP_FILE"

declare -A UUIDs
for bam in ${PREFIX}call-downstream/shard-*/downstream/*/call-hiphase/inputs/*/*.GRCh38.bam; do
    uuid=$(echo "$bam" | awk -F'/' '{print $(NF-4)}')
    sample=$(basename "$bam" | cut -d. -f1)
    UUIDs[$uuid]=$sample
    echo -e "$sample\t$uuid" >> "$MAP_FILE"
done


# 3-1. 全jointタスクの成功したかの一覧を得る
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
joint:glnexus\t\
joint:sawfish_call\t\
joint:split_glnexus\t\
joint:split_sawfish" > qc_simple_joint.out

for uuid in a; do
    sample=joint
    printf "%s\t%s" "$uuid" "$sample"
    printf "\t"; collect_rc "${PREFIX}call-joint/joint/*/call-glnexus/execution/rc"      
    printf "\t"; collect_rc "${PREFIX}call-joint/joint/*/call-sawfish_call/execution/rc" 
    printf "\t"; collect_rc "${PREFIX}call-joint/joint/*/call-split_glnexus/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-joint/joint/*/call-split_sawfish/execution/rc"
    printf "\n"
done >> qc_simple_joint.out


# 3-2. 全uuid x 全downstreamタスクの成功したかの一覧を得る
echo -e "uuid\tsample\t\
downstream:hiphase\t\
downstream:bam_stats\t\
downstream:coverage_dropouts\t\
downstream:bcftools_stats_roh_small_variants\t\
downstream:sv_stats\t\
downstream:cpg_pileup\t\
downstream:methbat\t\
downstream:pbstarphase_diplotype\t\
downstream:pharmcat:pharmcat_preprocess\t\
downstream:pharmcat:filter_preprocessed_vcf\t\
downstream:pharmcat:run_pharmcat" > qc_simple_downstream.out

for uuid in "${!UUIDs[@]}"; do
    sample=${UUIDs[$uuid]}
    printf "%s\t%s" "$uuid" "$sample"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-hiphase/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-bam_stats/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-coverage_dropouts/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-bcftools_stats_roh_small_variants/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-sv_stats/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-cpg_pileup/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-methbat/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-filter_preprocessed_vcf/execution/rc"
    printf "\t"; collect_rc "${PREFIX}call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-run_pharmcat/execution/rc"
    printf "\n"
done >> qc_simple_downstream.out


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
  [downstream:hiphase]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-hiphase/execution/{log}"
  [downstream:bam_stats]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-bam_stats/execution/{log}"
  [downstream:coverage_dropouts]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-coverage_dropouts/execution/{log}"
  [downstream:bcftools_stats_roh_small_variants]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-bcftools_stats_roh_small_variants/execution/{log}"
  [downstream:sv_stats]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-sv_stats/execution/{log}"
  [downstream:cpg_pileup]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-cpg_pileup/execution/{log}"
  [downstream:methbat]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-methbat/execution/{log}"
  [downstream:pbstarphase_diplotype]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-pbstarphase_diplotype/execution/{log}"
  [downstream:pharmcat:pharmcat_preprocess]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/execution/{log}"
  [downstream:pharmcat:filter_preprocessed_vcf]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-pharmcat/pharmcat/*/call-filter_preprocessed_vcf/execution/{log}"
  [downstream:pharmcat:run_pharmcat]="${PREFIX}call-downstream/shard-*/downstream/{uuid}/call-pharmcat/pharmcat/*/call-run_pharmcat/execution/{log}"
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
