version 1.0

struct Sample {
  String sample_id
  String inferred_sex

  String? sex
  Boolean affected

  Array[File] hifi_reads
  Array[File]? fail_reads

  String? father_id
  String? mother_id
}

struct Family {
  String family_id
  Array[Sample] samples
}

struct Upstream_outs {
  Array[File] small_variant_gvcf
  Array[File] small_variant_gvcf_index
  Array[File]? small_variant_vcf
  Array[File]? small_variant_vcf_index
  Array[File] discover_tar
  Array[File] out_bam
  Array[File] out_bam_index
  Array[File] sv_vcf
  Array[File] sv_vcf_index
  Array[File] trgt_vcf
  Array[File] trgt_vcf_index
}

struct Process_trgt_catalog_outs {
  File full_catalog
}

struct Joint_outs {
  Array[File] split_joint_small_variant_vcfs
  Array[File] split_joint_small_variant_vcf_indices
  Array[File] split_joint_structural_variant_vcfs
  Array[File] split_joint_structural_variant_vcf_indices
}

struct Downstream_outs {
  Array[File] phased_small_variant_vcf
  Array[File] phased_small_variant_vcf_index
  Array[File] phased_sv_vcf
  Array[File] phased_sv_vcf_index
  Array[File] phased_trgt_vcf
  Array[File] phased_trgt_vcf_index
}
