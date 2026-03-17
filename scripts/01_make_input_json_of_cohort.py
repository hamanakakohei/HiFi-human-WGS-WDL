#!/usr/bin/env python3
#
# gvcfリストファイル、BAMリストファイル、PEDファイルの3つに共通しているサンプルのみ出力
#
# to do:
# - bam読み込みを関数化したが問題なければ以前のやりかた（コメントアウト部分）は消す（そもそもbam情報は要らないのだが）
# - gvcf読み込みも関数化する
import json
import argparse
from collections import defaultdict


def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument("--gvcf_map", required=True, help="ヘッダーなし、タブ区切り、サンプルIDとgvcfパスの2列のファイル。インデックスは同じパスで.tbiだとみなしている。")
    p.add_argument("--bam_map", required=True, help="ヘッダーなし、タブ区切り、サンプルIDとBAMパスの2列のファイル。複数BAMあれば別行に分けて書く。")
    p.add_argument("--ped", required=True, help="ヘッダーなし、父母のIDは0, ., 空白ならいないとみなす。sex, affectedは1 or 2でなければ勝手に女、非罹患とみなす。")
    p.add_argument("--ref_map", type=str, default="/path/to/HiFi-human-WGS-WDL-3.1.0/GRCh38.ref_map.v3p1p0.tsv")
    p.add_argument("--tertiary_map", type=str, default="/path/to/GRCh38.tertiary_map.v3p1p0.edit.tsv")
    p.add_argument("--title", type=str, default="3434samples")
    p.add_argument("--backend", type=str, default="HPC")
    p.add_argument("--sge_queue", type=str, default="your.q")
    p.add_argument("--preemptible", action="store_true")
    p.add_argument("--out_prefix", required=True)
    return p.parse_args()


def read_bam_map(path: str) -> Dict[str, List[str]]:
    bam_dict = {}
    with open(path) as f:
        for line in f:
            sid, bam_str = line.rstrip().split("\t")
            bam_dict[sid] = [x for x in bam_str.split(";") if x]
    return bam_dict


def is_missing_parent(x: str) -> bool:
    return x in {"0", ".", ""}


def read_ped(path: str) -> Dict[str, dict]:
    ped_dict = {}
    with open(path) as f:
        for line in f:
            fam, sid, fa, mo, sex, aff = line.rstrip("\n").split("\t")
            ped_dict[sid] = {
                "father_id": "" if is_missing_parent(fa) else fa,
                "mother_id": "" if is_missing_parent(mo) else mo,
                "sex": sex,
                "affected": aff
            }
    return ped_dict


def main():
    args = parse_args()

    # ---------- BAM ----------
    bam_dict = read_bam_map(args.bam_map)
    #bam_dict = defaultdict(list)
    #with open(args.bam_map) as f:
    #    for line in f:
    #        sid, path = line.rstrip().split("\t")
    #        bam_dict[sid].append(path)

    # ---------- GVCF ----------
    gvcf_dict = {}
    with open(args.gvcf_map) as f:
        for line in f:
            sid, path = line.rstrip().split("\t")
            gvcf_dict[sid] = path

    # ---------- PED ----------
    ped_dict = read_ped(args.ped)

    # ---------- sample intersection ----------
    valid_samples = sorted(
        set(bam_dict.keys()) &
        set(gvcf_dict.keys()) &
        set(ped_dict.keys())
    )
    print(f"[INFO] {len(valid_samples)} samples will be wrote")
    with open(f"{args.out_prefix}.list", "w") as f:
        for x in valid_samples:
            f.write(f"{x}\n")

    # ---------- build samples ----------
    samples = []
    gvcf_paths = []
    gvcf_index_paths = []

    for sid in valid_samples:
        ped = ped_dict[sid]

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

        samples.append({
            "sample_id": sid,
            "hifi_reads": bam_dict[sid],
            "affected": affected,
            "sex": sex,
            "father_id": ped["father_id"],
            "mother_id": ped["mother_id"],
        })

        gvcf_paths.append(gvcf_dict[sid])
        gvcf_index_paths.append(gvcf_dict[sid] + ".tbi")

    # ---------- output ----------
    out = {
        "humanwgs_family.family": {
            "family_id": args.title,
            "samples": samples
        },
        "humanwgs_family.gvcfs": gvcf_paths,
        "humanwgs_family.gvcf_indices": gvcf_index_paths,
        "humanwgs_family.ref_map_file": args.ref_map,
        "humanwgs_family.tertiary_map_file": args.tertiary_map,
        "humanwgs_family.backend": args.backend,
        "humanwgs_family.sge_queue": args.sge_queue,
        "humanwgs_family.preemptible": args.preemptible
    }

    with open(f"{args.out_prefix}.json", "w") as f:
        json.dump(out, f, indent=2)

    print(f"[OK] written")


if __name__ == "__main__":
    main()
