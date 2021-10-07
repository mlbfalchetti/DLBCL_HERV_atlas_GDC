#! /usr/bin/env python
# -*- coding utf-8 -*-

################################### TELESCOPE ###################################

rule telescope:
    conda: "envs/telescope"
    output:
        "results/{sampid}/{sampid}_telescope.report.tsv",
        "results/{sampid}/{sampid}_telescope.updated.bam"
    input:
        bam = "results/{sampid}_GDC38.Aligned.out.bam",
        annotation = rules.telescope_annotation.output
    log:
        "results/{sampid}/telescope.log"
    params:
        tmpdir = config['local_tmp']
    shell:
        """
        tdir=$(mktemp -d {config[local_tmp]}/{rule}.{wildcards.sampid}.XXXXXX)
        telescope assign\
         --exp_tag inform\
         --theta_prior 200000\
         --max_iter 200\
         --updated_sam\
         --outdir $tdir\
         {input[0]}\
         {input[1]}\
         2>&1 | tee {log[0]}
        mv $tdir/inform-telescope_report.tsv {output[0]}
        mv $tdir/inform-updated.bam {output[1]}
        chmod 600 {output[1]}
        rm -rf $tdir
        """

rule sample_complete:
    input:
        rules.telescope.output,
    output:
        touch("results/{sampid}/completed.txt")