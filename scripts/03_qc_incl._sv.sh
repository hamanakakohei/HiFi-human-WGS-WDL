#!/bin/bash
set -euo pipefail

outdir="results/03_qc_incl._sv/"
mkdir -p "$outdir"


## 0. データ（サンプル重複あり）の一覧を見て重複サンプルの古いデータは消したい
#ls -lrt cromwell-executions/humanwgs_family_03/*/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/execution/*.joint.GRCh38.small_variants.phased.norm.vcfanno.norm.slivar.compound_hets.tsv


# 1. cromwellログ
ls -l logs/03/*.e.log > ${outdir}1.log
ls -l logs/03/*.o.log | sort -k5,5n > ${outdir}2.log
ls logs/03/*.o.log | xargs -I{} bash -c 'echo -n {}" "; grep -e ucceed {} || true; echo -e ""' > ${outdir}3.log


# 2以降の準備
cd "$outdir"
PREFIX="../../cromwell-executions/humanwgs_family_03/"


# 2. サンプルとUUIDのマッピングを作成
MAP_FILE="sample_uuid_map.tsv"
> "$MAP_FILE"

declare -A UUIDs
for bam in ${PREFIX}*/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/execution/*.joint.GRCh38.small_variants.phased.norm.vcfanno.norm.slivar.compound_hets.tsv; do
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
    # inputsディレクトリ数でrcファイル数の期待値としているが、inputsがないタスクもある、、その時は0/0とかって出ちゃう
    local rc_files=()
    for f in $exec_glob; do
        if [[ -f "$f" ]]; then
            rc_files+=( "$f" )
        fi
    done
    local input_dirs=()
    for d in $input_glob; do
        [[ -d "$d" ]] && input_dirs+=( "$d" )
    done
    #local rc_files=( $exec_glob )
    #local input_dirs=( $input_glob )

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
merge_small_variant_vcfs\t\
merge_sv_vcfs\t\
trgt_merge\t\
tertiary_analysis:bcftools_norm\t\
tertiary_analysis:vcfanno\t\
tertiary_analysis:write_phrank\t\
tertiary_analysis:split_gnotate_files\t\
tertiary_analysis:split_gnotate_prefixes\t\
tertiary_analysis:slivar_small_variant\t\
tertiary_analysis:split_sv_vcfs\t\
tertiary_analysis:split_sv_vcf_indices\t\
tertiary_analysis:svpack_filter_annotated\t\
tertiary_analysis:add_anno_by_id\t\
tertiary_analysis:slivar_svpack_tsv" > qc_simple.out

for uuid in "${!UUIDs[@]}"; do
    sample=${UUIDs[$uuid]}
    printf "%s\t%s" "$uuid" "$sample"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-merge_small_variant_vcfs/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-merge_sv_vcfs/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-trgt_merge/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-bcftools_norm/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-vcfanno/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-write_phrank/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-split_gnotate_files/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-split_gnotate_prefixes/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-split_sv_vcfs/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-split_sv_vcf_indices/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-svpack_filter_annotated/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-add_anno_by_id/execution/rc"
    printf "\t"; collect_rc "${PREFIX}/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_svpack_tsv/execution/rc"
    printf "\n"
done >> qc_simple.out


## 4. 各タスクの細かいログを全サンプル分得る
#log_types=(
#    stderr.submit
#    stdout.submit
#    stderr.slurm
#    stdout.slurm
#    stderr
#    stdout
#)
#
#collect_logs() {
#    local log_glob="$1"
#
#    shopt -s nullglob
#    local logs=( $log_glob )
#    shopt -u nullglob
#
#    if (( ${#logs[@]} > 0 )); then
#        for f in "${logs[@]}"; do
#            echo "### $(basename "$f")"
#            cat "$f"
#            echo
#        done
#    else
#        echo "### NO LOG FILES"
#    fi
#}
#
#declare -A TASK_LOG_GLOBS=(
#  [process_trgt_catalog:subset_reference]="${PREFIX}/{uuid}/call-process_trgt_catalog/process_trgt_catalog/*/call-subset_reference/execution/{log}"
#  [process_trgt_catalog:filter_trgt_catalog]="${PREFIX}/{uuid}/call-process_trgt_catalog/process_trgt_catalog/*/call-filter_trgt_catalog/execution/{log}"
#
#  [upstream:pbmm2:pbmm2_align_wgs]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-pbmm2_align_wgs/shard-*/execution/{log}"
#  [upstream:pbmm2:split_input_bam]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/execution/{log}"
#
#  [upstream:bait_fail_reads]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-bait_fail_reads/shard-*/execution/{log}"
#  [upstream:align_captured_fail_reads]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-align_captured_fail_reads/shard-*/execution/{log}"
#  [upstream:subset_bam]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-subset_bam/shard-*/execution/{log}"
#  [upstream:merge_hifi_bams]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-merge_hifi_bams/execution/{log}"
#  [upstream:mosdepth]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-mosdepth/execution/{log}"
#
#  [upstream:deepvariant:deepvariant_make_examples]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_make_examples/shard-*/execution/{log}"
#  [upstream:deepvariant:deepvariant_call_variants_cpu]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_call_variants_cpu/execution/{log}"
#  [upstream:deepvariant:deepvariant_postprocess_variants]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_postprocess_variants/execution/{log}"
#
#  [upstream:sawfish_discover]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-sawfish_discover/execution/{log}"
#  [upstream:paraphase]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-paraphase/execution/{log}"
#  [upstream:mitorsaw]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-mitorsaw/execution/{log}"
#  [upstream:merge_hifi_fail_bams]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-merge_hifi_fail_bams/execution/{log}"
#  [upstream:trgt]="${PREFIX}/{uuid}/call-upstream/shard-0/upstream/*/call-trgt/execution/{log}"
#)
#
#mkdir -p qc_details
#for task in "${!TASK_LOG_GLOBS[@]}"; do
#    for log in "${log_types[@]}"; do
#        outfile="qc_details/${task}_${log}.out"
#        : > "$outfile"
#
#        for uuid in "${!UUIDs[@]}"; do
#            sample=${UUIDs[$uuid]}
#
#            echo "# Sample: ${sample} (uuid=${uuid})" >> "$outfile"
#
#            pattern="${TASK_LOG_GLOBS[$task]}"
#            pattern="${pattern/\{uuid\}/$uuid}"
#            pattern="${pattern/\{log\}/$log}"
#
#            collect_logs "$pattern" >> "$outfile"
#            echo >> "$outfile"
#        done
#    done
#done
