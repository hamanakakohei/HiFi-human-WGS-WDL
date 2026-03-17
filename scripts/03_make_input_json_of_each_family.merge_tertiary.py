#!/usr/bin/env python3
#
# PED内の全ての家族毎にinput jsonを作る
# phased snv, sv, trgt mapファイル内にあるサンプルのみ出力する（father, mother idの欄も）
import json
import argparse
from typing import Dict, List


def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument("--phased_snv_vcf_map", required=True, help="ヘッダーなし、タブ区切り、サンプルIDとvcfパスの2列のファイル。例：call-hiphase/execution/xxx.joint.GRCh38.small_variants.phased.vcf.gz。インデックスは同じパスで.tbiだとみなしている。")
    p.add_argument("--phased_sv_vcf_map", required=True, help="ヘッダーなし、タブ区切り、サンプルIDとvcfパスの2列のファイル。例：call-hiphase/execution/xxx.joint.GRCh38.structural_variants.phased.vcf.gz。インデックスは同じパスで.tbiだとみなしている。")
    p.add_argument("--phased_trgt_vcf_map", required=True, help="ヘッダーなし、タブ区切り、サンプルIDとvcfパスの2列のファイル。例：call-hiphase/execution/xxx.GRCh38.trgt.sorted.phased.vcf.gz。インデックスは同じパスで.tbiだとみなしている。")
    p.add_argument("--sex_map", required=True, help="ヘッダーなし、タブ区切り、サンプルIDとInferred sex (MALE or FEMALE)の2列のファイル。")
    p.add_argument("--ped", required=True, help="ヘッダーなし、父母のIDは0, ., 空白ならいないとみなす。sex, affectedは1 or 2でなければ勝手に女、非罹患とみなす。")
    p.add_argument("--ref_map", type=str, default="/path/to/HiFi-human-WGS-WDL-3.1.0/GRCh38.ref_map.v3p1p0.tsv")
    p.add_argument("--tertiary_map", type=str, default="/path/to/GRCh38.tertiary_map.v3p1p0.edit.tsv")
    p.add_argument("--backend", type=str, default="HPC")
    p.add_argument("--sge_queue", type=str, default="your.q")
    p.add_argument("--preemptible", action="store_true")
    p.add_argument("--out_prefix", required=True)
    return p.parse_args()


def read_map(map_path: str) -> Dict[str, List[str]]:
    '''
        mapファイルをkeyがサンプル名でvalueがファイルパスの辞書にする、ファイルパスはサンプルにつき一つの場合
    '''
    file_dict = {}
    with open(map_path) as f:
        for line in f:
            sid, file_path = line.rstrip().split("\t")
            file_dict[sid] = file_path
    return file_dict


def is_missing_parent(x: str) -> bool:
    return x in {"0", ".", ""}


def read_ped(path: str) -> Dict[str, Dict[str, dict]]:
    fam_dict = {}
    with open(path) as f:
        for line in f:
            fam, sid, fa, mo, sex, aff = line.rstrip("\n").split("\t")

            fam_dict.setdefault(fam, {})[sid] = {
                "father_id": "" if is_missing_parent(fa) else fa,
                "mother_id": "" if is_missing_parent(mo) else mo,
                "sex": sex,
                "affected": aff,
            }
    return fam_dict


def main():
    args = parse_args()

    snv_dict  = read_map(args.phased_snv_vcf_map)
    sv_dict   = read_map(args.phased_sv_vcf_map)
    trgt_dict = read_map(args.phased_trgt_vcf_map)
    sex_dict  = read_map(args.sex_map)

    # ---------- PED ----------
    ped_fams = read_ped(args.ped)

    # ---------- sample intersection ----------
    valid_samples = sorted(
        set(snv_dict.keys()) &
        set(sv_dict.keys()) &
        set(trgt_dict.keys()) &
        set(sex_dict.keys()) &
        set([sid for fam in ped_fams.values() for sid in fam])
    )
    print(f"[INFO] {len(valid_samples)} samples will be wrote")
    with open(f"{args.out_prefix}.list", "w") as f:
        for x in valid_samples:
            f.write(f"{x}\n")
    
    for fam_id, members in ped_fams.items():
    
        samples = []
        snv_paths = []
        snv_index_paths = []
        sv_paths = []
        sv_index_paths = []
        trgt_paths = []
        trgt_index_paths = []
    
        for sid, ped in members.items():
    
            # --- sample がすべての map に存在するか ---
            if sid not in valid_samples:
                print(f"[WARN] skip {sid} (missing vcf)")
                continue
    
            # sex
            if ped["sex"] == "1":
                sex = "MALE"
            elif ped["sex"] == "2":
                sex = "FEMALE"
            else:
                print(f"[WARN] unknown sex for sample {sid}, set to FEMALE")
                sex = "FEMALE"
    
            # affected
            if ped["affected"] == "2":
                affected = True
            elif ped["affected"] == "1":
                affected = False
            else:
                print(f"[WARN] unknown affected status for sample {sid}, set to affected")
                affected = True
    
            # samples
            samples.append({
                "sample_id": sid,
                "hifi_reads": [""],
                "affected": affected,
                "sex": sex,
                "father_id": ped["father_id"],
                "mother_id": ped["mother_id"],
                "inferred_sex": sex_dict[sid],
            })
    
            # vcfs
            snv_paths.append(snv_dict[sid])
            snv_index_paths.append(snv_dict[sid] + ".tbi")
            sv_paths.append(sv_dict[sid])
            sv_index_paths.append(sv_dict[sid] + ".tbi")
            trgt_paths.append(trgt_dict[sid])
            trgt_index_paths.append(trgt_dict[sid] + ".tbi")

        # ---------- output ----------
        if not samples:
            continue

        out = {
            "humanwgs_family.family": {
                "family_id": fam_id,
                "samples": samples,
            },
            "humanwgs_family.downstream": {
                "phased_small_variant_vcf": snv_paths,
                "phased_small_variant_vcf_index": snv_index_paths,
                "phased_sv_vcf": sv_paths,
                "phased_sv_vcf_index": sv_index_paths,
                "phased_trgt_vcf": trgt_paths,
                "phased_trgt_vcf_index": trgt_index_paths,
            },
            "humanwgs_family.ref_map_file": args.ref_map,
            "humanwgs_family.tertiary_map_file": args.tertiary_map,
            "humanwgs_family.backend": args.backend,
            "humanwgs_family.sge_queue": args.sge_queue,
            "humanwgs_family.preemptible": args.preemptible,
        }

        with open(f"{args.out_prefix}{fam_id}.family.json", "w") as f:
            json.dump(out, f, indent=2)

        print("[OK] written")


if __name__ == "__main__":
    main()
