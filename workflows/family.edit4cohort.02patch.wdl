version 1.0

import "wdl-common/wdl/structs.wdl"
import "wdl-common/wdl/workflows/backend_configuration/backend_configuration.wdl" as BackendConfiguration

workflow humanwgs_family_02patch {

  input {
    File  joint_vcf
    File  joint_vcf_index
    File?  sv_joint_vcf
    File?  sv_joint_vcf_index
    File  control_sample_list
 
    File ref_map_file
	File tertiary_map_file

    # Backend configuration
    String backend
    String sge_queue
    String? zones
    String? cpuPlatform
    String? gpuType
    String? container_registry

    Boolean preemptible = true

    String? debug_version
  }

  call BackendConfiguration.backend_configuration {
    input:
      backend            = backend,
      sge_queue          = sge_queue,
      zones              = zones,
      cpuPlatform        = cpuPlatform,
      gpuType            = gpuType,
      container_registry = container_registry
  }

  RuntimeAttributes default_runtime_attributes = if preemptible then backend_configuration.spot_runtime_attributes else backend_configuration.on_demand_runtime_attributes

  Map[String, String] ref_map      = read_map(ref_map_file)
  Map[String, String] tertiary_map = read_map(tertiary_map_file)

  Array[String] chroms = [
    "chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10",
    "chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20",
    "chr21","chr22",
    "chrX","chrY"
  ]

  scatter (chr in chroms) {
    call subset_vcf_by_chr {
      input:
        vcf                = joint_vcf,
        vcf_index          = joint_vcf_index,
        chr                = chr,
        runtime_attributes = default_runtime_attributes
    }

    call subset_vcf_by_sample {
      input:
        vcf                = subset_vcf_by_chr.one_chr_vcf,
        vcf_index          = subset_vcf_by_chr.one_chr_vcf_index,
        sample_list        = control_sample_list,
        runtime_attributes = default_runtime_attributes
    }

    call make_site_vcf {
      input:
        vcf                = subset_vcf_by_sample.subset_vcf,
        vcf_index          = subset_vcf_by_sample.subset_vcf_index,
        runtime_attributes = default_runtime_attributes
    }

    call normalize_vcf {
      input:
        vcf                = make_site_vcf.site_vcf,
        vcf_index          = make_site_vcf.site_vcf_index,
        reference          = ref_map["fasta"],
        reference_index    = ref_map["fasta_index"],
        runtime_attributes = default_runtime_attributes
    }

    call vep_vcf {
      input:
        vcf                = normalize_vcf.normed_vcf,
        vcf_index          = normalize_vcf.normed_vcf_index,
        vep_fa             = tertiary_map["vep_fa"],
        vep_fa_index       = tertiary_map["vep_fa_idx"],
        cache_tar          = tertiary_map["vep_cache_tar"],
        plugin_tar         = tertiary_map["vep_plugin_tar"],
        vep_flags          = "--pick",
        runtime_attributes = default_runtime_attributes
    }

    #call update_vcf_csq {
    #  input:
    #    vcf                = vep_vcf.vepped_vcf,
    #    vcf_index          = vep_vcf.vepped_vcf_vcf_index,
    #    update_csq_py      = tertiary_map["update_csq_py"],
    #    runtime_attributes = default_runtime_attributes
    #}
  }

  # 4. concat
  call concat_vcfs {
    input:
      #vcfs               = update_vcf_csq.updated_vcf,
      vcfs               = vep_vcf.vepped_vcf,
      runtime_attributes = default_runtime_attributes
  }

  # 5. sv 
  if (defined(sv_joint_vcf)) {
    call subset_vcf_by_sample as sv_subset {
      input:
        vcf                = select_first([sv_joint_vcf]),
        vcf_index          = select_first([sv_joint_vcf_index]),
        sample_list        = control_sample_list,
        runtime_attributes = default_runtime_attributes
    }
    
    # ここでvepが特殊なcontigのバリアントをvcfから落とすことがあるが、
    # 断端先がnormal contigの場合はそっちが元側の場合の行で（アノテーションはないが）落としはしないので問題なし
    # ただ両側が特殊だと落とす 
    call vep_vcf as sv_vep {
      input:
        vcf                = sv_subset.subset_vcf,
        vcf_index          = sv_subset.subset_vcf_index,
        vep_fa             = tertiary_map["vep_fa"],
        vep_fa_index       = tertiary_map["vep_fa_idx"],
        cache_tar          = tertiary_map["vep_cache_tar"],
        plugin_tar         = tertiary_map["vep_plugin_tar"],
        vep_flags          = "--per_gene",
        runtime_attributes = default_runtime_attributes
    }

    #call make_info_tsv {
    #  input:
    #    vcf                = sv_vep.vepped_vcf,
    #    runtime_attributes = default_runtime_attributes
    #}
  }

  output {
    File final_vcf    = concat_vcfs.all_chr_vcf
    File final_sv_vcf = select_first([sv_vep.vepped_vcf])
  }
}

task subset_vcf_by_chr {
  input {
    File   vcf
    File   vcf_index
    String chr
    RuntimeAttributes runtime_attributes
  }

  String vcf_basename = basename(vcf, ".vcf.gz")
  Int threads   = 12
  Int memory    = 8

  command <<<
    bcftools view \
      --threads ~{threads - 1} \
      -r ~{chr} \
      -Oz \
      -o ~{vcf_basename}.~{chr}.vcf.gz \
      ~{vcf}

    bcftools index -t ~{vcf_basename}.~{chr}.vcf.gz
  >>>

  output {
    File one_chr_vcf       = "~{vcf_basename}.~{chr}.vcf.gz"
    File one_chr_vcf_index = "~{vcf_basename}.~{chr}.vcf.gz.tbi"
  }

  runtime {
    docker: "betelgeuse:5000/~{runtime_attributes.container_registry}/slivar:sha256f71a27f756e2d69ec30949cbea97c54abbafde757562a98ef965f21a28aa8eaa"
    cpu: threads
    memory: "${memory}GB"
    sge_queue: runtime_attributes.sge_queue 
  }
}

task subset_vcf_by_sample {
  input {
    File vcf
    File vcf_index
    File sample_list
    RuntimeAttributes runtime_attributes
  }

  String vcf_basename = basename(vcf, ".vcf.gz")
  Int threads   = 8
  Int memory    = 4

  command <<<
    bcftools view \
      -S ~{sample_list} \
      -Oz \
      -o ~{vcf_basename}.control.vcf.gz \
      ~{vcf}

    bcftools index -t ~{vcf_basename}.control.vcf.gz
  >>>

  output {
    File subset_vcf       = "~{vcf_basename}.control.vcf.gz"
    File subset_vcf_index = "~{vcf_basename}.control.vcf.gz.tbi"
  }

  runtime {
    docker: "betelgeuse:5000/~{runtime_attributes.container_registry}/slivar:sha256f71a27f756e2d69ec30949cbea97c54abbafde757562a98ef965f21a28aa8eaa"
    cpu: threads
    memory: "${memory}GB"
    sge_queue: runtime_attributes.sge_queue 
  }
}

task make_site_vcf {
  input {
    File vcf
    File vcf_index
    RuntimeAttributes runtime_attributes
  }

  String vcf_basename = basename(vcf, ".vcf.gz")
  Int threads   = 8
  Int memory    = 4

  command <<<
    bcftools view -G \
      -Oz \
      -o ~{vcf_basename}.site.vcf.gz \
      ~{vcf}

    bcftools index -t ~{vcf_basename}.site.vcf.gz
  >>>

  output {
    File site_vcf       = "~{vcf_basename}.site.vcf.gz"
    File site_vcf_index = "~{vcf_basename}.site.vcf.gz.tbi"
  }

  runtime {
    docker: "betelgeuse:5000/~{runtime_attributes.container_registry}/slivar:sha256f71a27f756e2d69ec30949cbea97c54abbafde757562a98ef965f21a28aa8eaa"
    cpu: threads
    memory: "${memory}GB"
    sge_queue: runtime_attributes.sge_queue 
  }
}

task normalize_vcf {
  input {
    File   vcf
    File   vcf_index
    File   reference
    File   reference_index
    RuntimeAttributes runtime_attributes
  }

  String vcf_basename = basename(vcf, ".vcf.gz")
  Int threads   = 12
  Int memory    = 8

  command <<<
    bcftools norm \
      --threads ~{threads - 1} \
      --multiallelics \
      - \
      --output-type b \
      --fasta-ref ~{reference} \
      ~{vcf} \
    | bcftools sort \
      --output-type z \
      --output ~{vcf_basename}.norm.vcf.gz

    bcftools index -t ~{vcf_basename}.norm.vcf.gz
  >>>

  output {
    File normed_vcf       = "~{vcf_basename}.norm.vcf.gz"
    File normed_vcf_index = "~{vcf_basename}.norm.vcf.gz.tbi"
  }

  runtime {
    docker: "betelgeuse:5000/~{runtime_attributes.container_registry}/slivar:sha256f71a27f756e2d69ec30949cbea97c54abbafde757562a98ef965f21a28aa8eaa"
    cpu: threads
    memory: "${memory}GB"
    sge_queue: runtime_attributes.sge_queue 
  }
}

task vep_vcf {
  input {
    File   vcf
    File   vcf_index
    File   vep_fa
    File   vep_fa_index
    File   cache_tar
    File   plugin_tar
    String vep_flags
    RuntimeAttributes runtime_attributes
  }

  String vcf_basename = basename(vcf, ".vcf.gz")
  Int threads   = 12
  Int memory    = 4

  command <<<
    tar xzvf ~{cache_tar}
    tar xvf ~{plugin_tar}
    mv homo_sapiens_merged homo_sapiens
    
    vep \
      --cache \
      --offline \
      --verbose \
      --vcf \
      --fork ~{threads} \
      --assembly GRCh38 \
      --dir_cache ./ \
      --fasta ~{vep_fa} \
      --input_file ~{vcf} \
      --output_file ~{vcf_basename}.vep.vcf.gz \
      --compress_output bgzip \
      --everything \
      --clin_sig_allele 0 \
      --max_sv_size 300000000 \
      --plugin AlphaMissense,file=plugins_resource/AlphaMissense/AlphaMissense_hg38.tsv.gz \
      --plugin REVEL,file=plugins_resource/REVEL/new_tabbed_revel_grch38.tsv.gz \
      --plugin SpliceAI,snv=plugins_resource/SpliceAI/spliceai_scores.raw.snv.hg38.vcf.gz,indel=plugins_resource/SpliceAI/spliceai_scores.raw.indel.hg38.vcf.gz \
      --plugin UTRAnnotator,file=plugins_resource/UTRAnnotator/uORF_5UTR_GRCh38_PUBLIC.txt \
      --plugin RiboseqORFs,file=plugins_resource/RiboseqORFs/Ribo-seq_ORFs.bed.gz \
      ~{vep_flags} \
      #--pick \

    tabix ~{vcf_basename}.vep.vcf.gz
  >>>

  output {
    File vepped_vcf       = "~{vcf_basename}.vep.vcf.gz"
    File vepped_vcf_index = "~{vcf_basename}.vep.vcf.gz.tbi"
  }

  runtime {
    docker: "betelgeuse:5000/ensemblorg/ensembl-vep:release_115.1"
    cpu: threads
    memory: "${memory}GB"
    sge_queue: runtime_attributes.sge_queue 
  }
}

task make_info_tsv {
  input {
    File   vcf
    RuntimeAttributes runtime_attributes
  }

  String vcf_basename = basename(vcf, ".vcf.gz")
  Int threads   = 1
  Int memory    = 8

  command <<<
    awk '
    BEGIN {
        FS=OFS="\t"
        print "ID","AC","AN","CSQ"
    }
    /^#/ { next }
    {
        id = $3
        ac = an = csq = "."
    
        n = split($8, info_fields, ";")
        for (i=1; i<=n; i++) {
            split(info_fields[i], kv, "=")
            key = kv[1]
            val = kv[2]
    
            if (key=="AC")  ac = val
            if (key=="AN")  an = val
            if (key=="CSQ") csq = val
        }
        print id, ac, an, csq
    }
    ' ~{vcf} > ~{vcf_basename}.info_fields.tsv
  >>>

  output {
    File info_tsv = "~{vcf_basename}.info_fields.tsv"
  }

  runtime {
    docker: "betelgeuse:5000/ensemblorg/ensembl-vep:release_115.1"
    cpu: threads
    memory: "${memory}GB"
    sge_queue: runtime_attributes.sge_queue 
  }
}

#task update_vcf_csq {
#  input {
#    File vcf
#    File vcf_index
#    File update_csq_py
#    RuntimeAttributes runtime_attributes
#  }
#
#  String vcf_basename = basename(vcf, ".vcf.gz")
#  Int threads   = 1
#  Int memory    = 64
#
#  command <<<
#    set -euo pipefail
#
#    echo -e "CHROM\tPOS\tREF\tALT\t$(bcftools +split-vep -l ~{vcf} | cut -f2 | tr '\n' '\t' | sed 's/\t$//')" > csq_header.txt
#
#    # ここで数字の最後の0が消えたり、=が%3Dに変わったりする
#    bcftools +split-vep \
#      -A tab -d \
#      -f '%CHROM\t%POS\t%REF\t%ALT\t%CSQ\n' \
#      ~{vcf} \
#    > csq_content.tsv
#
#    cat csq_header.txt csq_content.tsv > csq.tsv
#    
#    python3 ~{update_csq_py} csq.tsv csq_updated.tsv
#    bgzip csq_updated.tsv
#    tabix -s1 -b2 -e2 csq_updated.tsv.gz
#
#    bcftools annotate \
#      -a csq_updated.tsv.gz \
#      -c CHROM,POS,REF,ALT,INFO/CSQ \
#      -Oz \
#      -o ~{vcf_basename}.updated.vcf.gz \
#      ~{vcf}
#
#    tabix ~{vcf_basename}.updated.vcf.gz 
#  >>>
#
#  output {
#    File updated_vcf     = "~{vcf_basename}.updated.vcf.gz"
#    File updated_vcf_tbi = "~{vcf_basename}.updated.vcf.gz.tbi"
#  }
#
#  runtime {
#    docker: "betelgeuse:5000/~{runtime_attributes.container_registry}/slivar:sha256f71a27f756e2d69ec30949cbea97c54abbafde757562a98ef965f21a28aa8eaa"
#    cpu: threads
#    memory: "${memory}GB"
#    sge_queue: runtime_attributes.sge_queue
#  }
#}

task concat_vcfs {
  input {
    Array[File] vcfs
    RuntimeAttributes runtime_attributes
  }

  Int threads   = 8
  Int memory    = 4

  command <<<
    bcftools concat \
      --threads ~{threads - 1} \
      -Oz \
      -o merged.vcf.gz \
      ~{sep=' ' vcfs}
    bcftools index -t merged.vcf.gz
  >>>

  output {
    File all_chr_vcf = "merged.vcf.gz"
  }

  runtime {
    docker: "betelgeuse:5000/~{runtime_attributes.container_registry}/slivar:sha256f71a27f756e2d69ec30949cbea97c54abbafde757562a98ef965f21a28aa8eaa"
    cpu: threads
    memory: "${memory}GB"
    sge_queue: runtime_attributes.sge_queue 
  }
}
