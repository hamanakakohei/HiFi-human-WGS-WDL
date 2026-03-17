#!/usr/bin/env python3
import sys

inp = sys.argv[1]
outp = sys.argv[2]


def update_consequence(row):
    cons = row.get("Consequence", "")
    tags = []

    # miRNA
    if row.get("miRNA", ".") != ".":
        tags.append("miRNA")

    # CLIN_SIG
    clin = row.get("CLIN_SIG", ".")
    if clin != "." and (
        "conflicting" in clin.lower()
        or "pathogenic" in clin.lower()
    ):
        tags.append("CLIN_SIG")

    # SpliceAI
    splice_cols = [
        "SpliceAI_pred_DP_AG",
        "SpliceAI_pred_DP_AL",
        "SpliceAI_pred_DP_DG",
        "SpliceAI_pred_DP_DL",
        "SpliceAI_pred_DS_AG",
        "SpliceAI_pred_DS_AL",
        "SpliceAI_pred_DS_DG",
        "SpliceAI_pred_DS_DL",
    ]

    for col in splice_cols:
        val = row.get(col, ".")
        if val != "." and float(val) >= 0.15:
            tags.append("SpliceAI")
            break

    # UTRannotator
    if row.get("_5UTR_consequence", ".") != ".":
        tags.append("UTRannotator")

    # RiboseqORF
    if row.get("RiboseqORFs_id", ".") != ".":
        tags.append("RiboseqORF")

    # 付加
    for tag in tags:
        cons += f"&{tag}"

    row["Consequence"] = cons
    return row


with open(inp, "r") as fin, open(outp, "w", newline="\n") as fout:
    header = fin.readline().rstrip("\n").split("\t")

    fixed_cols = header[:4]      # CHROM, POS, REF, ALT
    csq_cols = header[4:]        # CSQ由来の列名

    for line in fin:
        line = line.rstrip("\n")
        if not line:
            continue

        fields = line.split("\t")
        fixed_vals = fields[:4]
        csq_vals = fields[4:]

        # 列名 → 値 の dict
        row = dict(zip(csq_cols, csq_vals))

        # Consequence 更新
        row = update_consequence(row)

        # CSQ 再構築（列順はヘッダ順を厳密に維持）
        csq = "|".join(
            "" if row[col] == "." else row[col] for col in csq_cols
        )

        fout.write(
            f"{fixed_vals[0]}\t{fixed_vals[1]}\t{fixed_vals[2]}\t{fixed_vals[3]}\t{csq}\n"
        )
