#!/usr/bin/env bash
#
# inputs/以下を消す
# execution/以下には消すべきものなし
# 以下は全サンプル共通で一度で何回も消そうとしてしまう
# - cromwell-executions/humanwgs_family/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
# - cromwell-executions/humanwgs_family/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
set -euo pipefail
step02_uuid=$1 
cohort_id=$2 
sample_id=$3
uuid=$4


#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-bam_stats/inputs/*/${sample_id}.GRCh38.haplotagged.bam
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-bam_stats/inputs/*/${sample_id}.GRCh38.haplotagged.bam.bai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-bcftools_stats_roh_small_variants/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-bcftools_stats_roh_small_variants/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-bcftools_stats_roh_small_variants/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-coverage_dropouts/inputs/*/${sample_id}.GRCh38.haplotagged.bam
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-coverage_dropouts/inputs/*/${sample_id}.GRCh38.haplotagged.bam.bai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-coverage_dropouts/inputs/*/trgt.bed
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-cpg_pileup/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-cpg_pileup/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-cpg_pileup/inputs/*/${sample_id}.GRCh38.haplotagged.bam
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-cpg_pileup/inputs/*/${sample_id}.GRCh38.haplotagged.bam.bai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.vcf.gz.tbi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.structural_variants.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.structural_variants.vcf.gz.tbi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.GRCh38.bam
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.GRCh38.bam.bai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.GRCh38.trgt.sorted.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.GRCh38.trgt.sorted.vcf.gz.tbi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-methbat/inputs/*/cpgIslandExt.sorted.hg38.tsv
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-methbat/inputs/*/${sample_id}.GRCh38.cpg_pileup.combined.bed.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-methbat/inputs/*/${sample_id}.GRCh38.cpg_pileup.hap1.bed.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-methbat/inputs/*/${sample_id}.GRCh38.cpg_pileup.hap2.bed.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.vcf.gz.tbi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.structural_variants.phased.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.structural_variants.phased.vcf.gz.tbi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.GRCh38.haplotagged.bam
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.GRCh38.haplotagged.bam.bai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-filter_preprocessed_vcf/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-filter_preprocessed_vcf/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.preprocessed.vcf.bgz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-filter_preprocessed_vcf/inputs/*/${sample_id}.GRCh38.haplotagged.bam
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-filter_preprocessed_vcf/inputs/*/${sample_id}.GRCh38.haplotagged.bam.bai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/pharmcat_positions.uniallelic.vcf.bgz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/pharmcat_positions.uniallelic.vcf.bgz.csi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/pharmcat_positions_2.15.4.vcf.bgz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/pharmcat_positions_2.15.4.vcf.bgz.csi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.vcf.gz.tbi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-run_pharmcat/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.preprocessed.filtered.vcf
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-run_pharmcat/inputs/*/${sample_id}.pharmcat.tsv
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-sv_stats/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.structural_variants.phased.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-glnexus/inputs/*/${sample_id}.GRCh38.small_variants.g.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-glnexus/inputs/*/${sample_id}.GRCh38.small_variants.g.vcf.gz.tbi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/${sample_id}.GRCh38.bam
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/${sample_id}.GRCh38.bam.bai
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/${sample_id}.tar
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-split_glnexus/inputs/*/${cohort_id}.joint.GRCh38.small_variants.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-split_glnexus/inputs/*/${cohort_id}.joint.GRCh38.small_variants.vcf.gz.tbi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-split_sawfish/inputs/*/${cohort_id}.joint.GRCh38.structural_variants.vcf.gz
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-split_sawfish/inputs/*/${cohort_id}.joint.GRCh38.structural_variants.vcf.gz.tbi
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#ls -l cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai


#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-bam_stats/inputs/*/${sample_id}.GRCh38.haplotagged.bam
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-bam_stats/inputs/*/${sample_id}.GRCh38.haplotagged.bam.bai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-bcftools_stats_roh_small_variants/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-bcftools_stats_roh_small_variants/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-bcftools_stats_roh_small_variants/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.vcf.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-coverage_dropouts/inputs/*/${sample_id}.GRCh38.haplotagged.bam
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-coverage_dropouts/inputs/*/${sample_id}.GRCh38.haplotagged.bam.bai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-coverage_dropouts/inputs/*/trgt.bed
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-cpg_pileup/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-cpg_pileup/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-cpg_pileup/inputs/*/${sample_id}.GRCh38.haplotagged.bam
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-cpg_pileup/inputs/*/${sample_id}.GRCh38.haplotagged.bam.bai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.vcf.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.vcf.gz.tbi
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.structural_variants.vcf.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.structural_variants.vcf.gz.tbi
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.GRCh38.bam
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.GRCh38.bam.bai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.GRCh38.trgt.sorted.vcf.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-hiphase/inputs/*/${sample_id}.GRCh38.trgt.sorted.vcf.gz.tbi
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-methbat/inputs/*/cpgIslandExt.sorted.hg38.tsv
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-methbat/inputs/*/${sample_id}.GRCh38.cpg_pileup.combined.bed.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-methbat/inputs/*/${sample_id}.GRCh38.cpg_pileup.hap1.bed.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-methbat/inputs/*/${sample_id}.GRCh38.cpg_pileup.hap2.bed.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.vcf.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.vcf.gz.tbi
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.structural_variants.phased.vcf.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.structural_variants.phased.vcf.gz.tbi
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.GRCh38.haplotagged.bam
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pbstarphase_diplotype/inputs/*/${sample_id}.GRCh38.haplotagged.bam.bai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-filter_preprocessed_vcf/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-filter_preprocessed_vcf/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.preprocessed.vcf.bgz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-filter_preprocessed_vcf/inputs/*/${sample_id}.GRCh38.haplotagged.bam
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-filter_preprocessed_vcf/inputs/*/${sample_id}.GRCh38.haplotagged.bam.bai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/pharmcat_positions.uniallelic.vcf.bgz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/pharmcat_positions.uniallelic.vcf.bgz.csi
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/pharmcat_positions_2.15.4.vcf.bgz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/pharmcat_positions_2.15.4.vcf.bgz.csi
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.vcf.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-pharmcat_preprocess/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.vcf.gz.tbi
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-run_pharmcat/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.small_variants.phased.preprocessed.filtered.vcf
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-pharmcat/pharmcat/*/call-run_pharmcat/inputs/*/${sample_id}.pharmcat.tsv
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-downstream/shard-*/downstream/${uuid}/call-sv_stats/inputs/*/${sample_id}.${cohort_id}.joint.GRCh38.structural_variants.phased.vcf.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-glnexus/inputs/*/${sample_id}.GRCh38.small_variants.g.vcf.gz
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-glnexus/inputs/*/${sample_id}.GRCh38.small_variants.g.vcf.gz.tbi
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/${sample_id}.GRCh38.bam
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/${sample_id}.GRCh38.bam.bai
#rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/${sample_id}.tar
##rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-split_glnexus/inputs/*/${cohort_id}.joint.GRCh38.small_variants.vcf.gz
##rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-split_glnexus/inputs/*/${cohort_id}.joint.GRCh38.small_variants.vcf.gz.tbi
##rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-split_sawfish/inputs/*/${cohort_id}.joint.GRCh38.structural_variants.vcf.gz
##rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-split_sawfish/inputs/*/${cohort_id}.joint.GRCh38.structural_variants.vcf.gz.tbi
##rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/human_GRCh38_no_alt_analysis_set.fasta
##rm cromwell-executions/humanwgs_family_02/${step02_uuid}/call-joint/joint/*/call-sawfish_call/inputs/*/human_GRCh38_no_alt_analysis_set.fasta.fai
