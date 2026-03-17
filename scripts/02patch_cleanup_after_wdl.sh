#!/usr/bin/env bash
#
set -euo pipefail
step02patch_uuid=$1 
cohort_id=$2 


#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-subset_vcf_by_chr/shard-*/inputs/*/${cohort_id}.joint.GRCh38.small_variants.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-subset_vcf_by_chr/shard-*/execution/${cohort_id}.joint.GRCh38.small_variants.chr*.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-subset_vcf_by_sample/shard-*/inputs/*/${cohort_id}.joint.GRCh38.small_variants.chr*.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-subset_vcf_by_sample/shard-*/execution/${cohort_id}.joint.GRCh38.small_variants.chr*.control.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-make_site_vcf/shard-*/inputs/*/${cohort_id}.joint.GRCh38.small_variants.chr*.control.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-make_site_vcf/shard-*/execution/${cohort_id}.joint.GRCh38.small_variants.chr*.control.site.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-normalize_vcf/shard-*/inputs/*/${cohort_id}.joint.GRCh38.small_variants.chr*.control.site.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-normalize_vcf/shard-*/inputs/*/human_GRCh38_no_alt_analysis_set.fasta || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/inputs/*/${cohort_id}.joint.GRCh38.small_variants.chr*.control.site.norm.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/inputs/*/Homo_sapiens.GRCh38.dna.toplevel.fa || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/inputs/*/homo_sapiens_merged_vep_115_GRCh38.tar.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/inputs/*/plugins_resource.tar || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/execution/homo_sapiens || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/execution/plugins_resource || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-concat_vcfs/inputs/*/${cohort_id}.joint.GRCh38.small_variants.chr*.control.site.norm.vep.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_subset/inputs/*/${cohort_id}.joint.GRCh38.structural_variants.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/inputs/*/${cohort_id}.joint.GRCh38.structural_variants.control.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/inputs/*/Homo_sapiens.GRCh38.dna.toplevel.fa || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/inputs/*/homo_sapiens_merged_vep_115_GRCh38.tar.gz || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/inputs/*/plugins_resource.tar || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/execution/plugins_resource || true
#ls -l cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/execution/homo_sapiens || true

rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-subset_vcf_by_chr/shard-*/inputs/*/${cohort_id}.joint.GRCh38.small_variants.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-subset_vcf_by_chr/shard-*/execution/${cohort_id}.joint.GRCh38.small_variants.chr*.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-subset_vcf_by_sample/shard-*/inputs/*/${cohort_id}.joint.GRCh38.small_variants.chr*.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-subset_vcf_by_sample/shard-*/execution/${cohort_id}.joint.GRCh38.small_variants.chr*.control.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-make_site_vcf/shard-*/inputs/*/${cohort_id}.joint.GRCh38.small_variants.chr*.control.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-make_site_vcf/shard-*/execution/${cohort_id}.joint.GRCh38.small_variants.chr*.control.site.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-normalize_vcf/shard-*/inputs/*/${cohort_id}.joint.GRCh38.small_variants.chr*.control.site.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-normalize_vcf/shard-*/inputs/*/human_GRCh38_no_alt_analysis_set.fasta || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/inputs/*/${cohort_id}.joint.GRCh38.small_variants.chr*.control.site.norm.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/inputs/*/Homo_sapiens.GRCh38.dna.toplevel.fa || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/inputs/*/homo_sapiens_merged_vep_115_GRCh38.tar.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/inputs/*/plugins_resource.tar || true
rm -r cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/execution/homo_sapiens || true
rm -r cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-vep_vcf/shard-*/execution/plugins_resource || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-concat_vcfs/inputs/*/${cohort_id}.joint.GRCh38.small_variants.chr*.control.site.norm.vep.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_subset/inputs/*/${cohort_id}.joint.GRCh38.structural_variants.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/inputs/*/${cohort_id}.joint.GRCh38.structural_variants.control.vcf.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/inputs/*/Homo_sapiens.GRCh38.dna.toplevel.fa || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/inputs/*/homo_sapiens_merged_vep_115_GRCh38.tar.gz || true
rm cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/inputs/*/plugins_resource.tar || true
rm -r cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/execution/plugins_resource || true
rm -r cromwell-executions/humanwgs_family_02patch/${step02patch_uuid}/call-sv_vep/execution/homo_sapiens || true
