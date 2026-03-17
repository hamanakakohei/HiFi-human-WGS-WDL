#!/usr/bin/env bash
set -euo pipefail
sample_id=$1 #m84166_241123_213735_s1
movie_ids=$2 
uuid=$3 #d17c4cd9-1817-41f1-ad75-98a7dfe2ec72

IFS=';' read -ra arr <<< $movie_ids


## inputs/
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-process_trgt_catalog/process_trgt_catalog/*/call-subset_reference/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
##ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-align_captured_fail_reads/shard-*/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_call_variants_cpu/inputs/*/${sample_id}.*.example_tfrecords.tar.gz
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_make_examples/shard-*/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_make_examples/shard-*/inputs/*/${sample_id}.GRCh38.bam
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_postprocess_variants/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_postprocess_variants/inputs/*/${sample_id}.*.example_tfrecords.tar.gz
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_postprocess_variants/inputs/*/${sample_id}.GRCh38.call_variants_output.tar.gz
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-mitorsaw/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-mitorsaw/inputs/*/${sample_id}.GRCh38.bam
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-mosdepth/inputs/*/${sample_id}.GRCh38.bam
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-paraphase/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-paraphase/inputs/*/${sample_id}.GRCh38.bam
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-pbmm2_align_wgs/shard-*/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-sawfish_discover/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-sawfish_discover/inputs/*/${sample_id}.GRCh38.bam
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-sawfish_discover/inputs/*/${sample_id}.GRCh38.small_variants.vcf.gz
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-trgt/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-trgt/inputs/*/${sample_id}.GRCh38.bam
#
## inputs/ & movie_id
#for movie_id in ${arr[@]}; do
#    #ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-align_captured_fail_reads/shard-*/inputs/*/${sample_id}.${movie_id}.fail_reads.*bait_ref.aligned.bam
#    #ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-bait_fail_reads/shard-*/inputs/*/${movie_id}.fail_reads.*bam
#    ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-merge_hifi_bams/inputs/*/${sample_id}.${movie_id}.hifi_reads.*.GRCh38.aligned.bam
#    #ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-merge_hifi_fail_bams/inputs/*/${sample_id}.${movie_id}.hifi_reads.*GRCh38.aligned.bam
#    ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-pbmm2_align_wgs/shard-*/inputs/*/${movie_id}.hifi_reads.*.bam
#    ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/inputs/*/${movie_id}.hifi_reads.*bam
#    #ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/inputs/*/${movie_id}.hifi_reads.bam.pbi
#    #ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-subset_bam/shard-*/inputs/*/${sample_id}.${sample_id}.${movie_id}.fail_reads.*bait_ref.aligned.GRCh38.aligned.bam
#done
#
## execution/
#ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_make_examples/shard-*/execution/${sample_id}.*.example_tfrecords.tar.gz
#
## execution/ & movie_id
#for movie_id in ${arr[@]}; do
#    ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-pbmm2_align_wgs/shard-*/execution/${sample_id}.${movie_id}.hifi_reads.*.GRCh38.aligned.bam
#    ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/execution/glob-*/${movie_id}.hifi_reads*.bam
#    ls -l cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/execution/${movie_id}.hifi_reads*.bam
#done


# inputs/
rm cromwell-executions/humanwgs_family_01/${uuid}/call-process_trgt_catalog/process_trgt_catalog/*/call-subset_reference/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-align_captured_fail_reads/shard-*/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_call_variants_cpu/inputs/*/${sample_id}.*.example_tfrecords.tar.gz
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_make_examples/shard-*/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_make_examples/shard-*/inputs/*/${sample_id}.GRCh38.bam
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_postprocess_variants/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_postprocess_variants/inputs/*/${sample_id}.*.example_tfrecords.tar.gz
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_postprocess_variants/inputs/*/${sample_id}.GRCh38.call_variants_output.tar.gz
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-mitorsaw/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-mitorsaw/inputs/*/${sample_id}.GRCh38.bam
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-mosdepth/inputs/*/${sample_id}.GRCh38.bam
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-paraphase/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-paraphase/inputs/*/${sample_id}.GRCh38.bam
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-pbmm2_align_wgs/shard-*/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-sawfish_discover/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-sawfish_discover/inputs/*/${sample_id}.GRCh38.bam
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-sawfish_discover/inputs/*/${sample_id}.GRCh38.small_variants.vcf.gz
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-trgt/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-trgt/inputs/*/${sample_id}.GRCh38.bam

# inputs/ & movie_id
for movie_id in ${arr[@]}; do
    #rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-align_captured_fail_reads/shard-*/inputs/*/${sample_id}.${movie_id}.fail_reads.*bait_ref.aligned.bam
    #rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-bait_fail_reads/shard-*/inputs/*/${movie_id}.fail_reads.*bam
    rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-merge_hifi_bams/inputs/*/${sample_id}.${movie_id}.hifi_reads.*.GRCh38.aligned.bam
    #rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-merge_hifi_fail_bams/inputs/*/${sample_id}.${movie_id}.hifi_reads.*GRCh38.aligned.bam
    rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-pbmm2_align_wgs/shard-*/inputs/*/${movie_id}.hifi_reads.*.bam
    rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/inputs/*/${movie_id}.hifi_reads.*bam
    #rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/inputs/*/${movie_id}.hifi_reads.bam.pbi
    #rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-*/upstream/*/call-subset_bam/shard-*/inputs/*/${sample_id}.${sample_id}.${movie_id}.fail_reads.*bait_ref.aligned.GRCh38.aligned.bam
done

# execution/
rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-0/upstream/*/call-deepvariant/deepvariant/*/call-deepvariant_make_examples/shard-*/execution/${sample_id}.*.example_tfrecords.tar.gz

# execution/ & movie_id
for movie_id in ${arr[@]}; do
    rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-pbmm2_align_wgs/shard-*/execution/${sample_id}.${movie_id}.hifi_reads.*.GRCh38.aligned.bam
    rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/execution/glob-*/${movie_id}.hifi_reads*.bam
    rm cromwell-executions/humanwgs_family_01/${uuid}/call-upstream/shard-0/upstream/*/call-pbmm2/shard-*/pbmm2/*/call-split_input_bam/execution/${movie_id}.hifi_reads*.bam
done
