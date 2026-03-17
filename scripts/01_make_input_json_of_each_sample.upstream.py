#!/usr/bin/env python3
#
# サンプル毎にinput jsonを作る
# hifi reads bamファイルにあるサンプルに対して作る
# father_id, mother_idは空で出力する（PED内の情報は使わない）
import json
import argparse
from typing import Dict, List


def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument("--hifi_bam_map", required=True, help="sample<TAB>bam1;bam2;etcというファイル")
    p.add_argument("--fail_bam_map", default=None, help="上と同形式のファイル")
    p.add_argument("--ped", required=True, help="ヘッダーなし、父母のIDは0, ., 空白ならいないとみなす。sex, affectedは1 or 2でなければ勝手に女、非罹患とみなす。")
    p.add_argument("--ref_map", type=str, default="/path/to/HiFi-human-WGS-WDL-3.1.0/GRCh38.ref_map.v3p1p0.tsv")
    p.add_argument("--tertiary_map", type=str, default="/path/to/GRCh38.tertiary_map.v3p1p0.edit.tsv")
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
    ped_dict = read_ped(args.ped)
    hifi_bam = read_bam_map(args.hifi_bam_map)
    if args.fail_bam_map is None:
        fail_bam = {}
    else:
        fail_bam = read_bam_map(args.fail_bam_map)

    for sid, hifi_reads in hifi_bam.items():

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

        # fail reads
        fail_reads = fail_bam.get(sid, [])

        out = {
            "humanwgs_family.family": {
                "family_id": sid,
                "samples": [
                    {
                        "sample_id": sid,
                        "hifi_reads": hifi_reads,
                        "fail_reads": fail_reads,
                        "affected": affected,
                        "sex": sex,
                        "father_id": "",
                        "mother_id": "",
                    }
                ],
            },
            "humanwgs_family.ref_map_file": args.ref_map,
            "humanwgs_family.tertiary_map_file": args.tertiary_map,
            "humanwgs_family.backend": args.backend,
            "humanwgs_family.sge_queue": args.sge_queue,
            "humanwgs_family.preemptible": args.preemptible,
        }

        with open(f"{args.out_prefix}{sid}.json", "w") as f:
            json.dump(out, f, indent=2)

    print("[OK] written")


if __name__ == "__main__":
    main()
