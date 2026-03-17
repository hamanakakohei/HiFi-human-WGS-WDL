#!/usr/bin/env bash
#
set -euo pipefail
uuid=$1 
sample_id=$2 
cohort_id=$3

#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-add_anno_by_id/inputs/*/${cohort_id}.joint.GRCh38.structural_variants.control.vep.info_fields.tsv || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-add_anno_by_id/execution/tmp.vcf || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-bcftools_norm/inputs/*/${sample_id}*oint.GRCh38.small_variants.phased.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-bcftools_norm/inputs/*/human_GRCh38_no_alt_analysis_set.fasta || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/inputs/*/${sample_id}*oint.GRCh38.small_variants.phased.norm.vcfanno.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/inputs/*/CoLoRSdb.GRCh38.v1.2.0.deepvariant.glnexus.zip || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/inputs/*/gnomad.hg38.v4.1.custom.v1.zip || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/inputs/*/ensembl.GRCh38.101.reformatted.gff3.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/inputs/*/human_GRCh38_no_alt_analysis_set.fasta || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-svpack_filter_annotated/inputs/*/CoLoRSdb.GRCh38.v1.2.0.pbsv.jasmine.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-svpack_filter_annotated/inputs/*/gnomad.v4.1.sv.sites.pass.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-svpack_filter_annotated/inputs/*/${sample_id}*oint.GRCh38.structural_variants.phased.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-svpack_filter_annotated/inputs/*/ensembl.GRCh38.101.reformatted.gff3.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-vcfanno/inputs/*/merged.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-vcfanno/inputs/*/${sample_id}*oint.GRCh38.small_variants.phased.norm.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-trgt_merge/inputs/*/${sample_id}.GRCh38.trgt.sorted.phased.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-trgt_merge/inputs/*/human_GRCh38_no_alt_analysis_set.fasta || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-merge_sv_vcfs/inputs/*/${sample_id}*oint.GRCh38.structural_variants.phased.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-merge_small_variant_vcfs/inputs/*/${sample_id}*oint.GRCh38.small_variants.phased.vcf.gz || true
#ls -l cromwell-executions/humanwgs_family_03/${uuid}/call-merge_small_variant_vcfs/inputs/*/*.concat.vcf.gz || true

#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-add_anno_by_id/inputs/*/${cohort_id}.joint.GRCh38.structural_variants.control.vep.info_fields.tsv || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-add_anno_by_id/execution/tmp.vcf || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-bcftools_norm/inputs/*/${sample_id}*oint.GRCh38.small_variants.phased.vcf.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-bcftools_norm/inputs/*/human_GRCh38_no_alt_analysis_set.fasta || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/inputs/*/${sample_id}*oint.GRCh38.small_variants.phased.norm.vcfanno.vcf.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/inputs/*/CoLoRSdb.GRCh38.v1.2.0.deepvariant.glnexus.zip || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/inputs/*/gnomad.hg38.v4.1.custom.v1.zip || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/inputs/*/ensembl.GRCh38.101.reformatted.gff3.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-slivar_small_variant/inputs/*/human_GRCh38_no_alt_analysis_set.fasta || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-svpack_filter_annotated/inputs/*/CoLoRSdb.GRCh38.v1.2.0.pbsv.jasmine.vcf.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-svpack_filter_annotated/inputs/*/gnomad.v4.1.sv.sites.pass.vcf.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-svpack_filter_annotated/inputs/*/${sample_id}*oint.GRCh38.structural_variants.phased.vcf.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-svpack_filter_annotated/inputs/*/ensembl.GRCh38.101.reformatted.gff3.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-vcfanno/inputs/*/merged.vcf.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-tertiary_analysis/tertiary_analysis/*/call-vcfanno/inputs/*/${sample_id}*oint.GRCh38.small_variants.phased.norm.vcf.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-trgt_merge/inputs/*/${sample_id}.GRCh38.trgt.sorted.phased.vcf.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-trgt_merge/inputs/*/human_GRCh38_no_alt_analysis_set.fasta || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-merge_sv_vcfs/inputs/*/${sample_id}*oint.GRCh38.structural_variants.phased.vcf.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-merge_small_variant_vcfs/inputs/*/${sample_id}*oint.GRCh38.small_variants.phased.vcf.gz || true
#rm cromwell-executions/humanwgs_family_03/${uuid}/call-merge_small_variant_vcfs/inputs/*/*.concat.vcf.gz || true
