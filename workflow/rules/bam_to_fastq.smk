#! /usr/bin/env python
# -*- coding utf-8 -*-

########################### DOWNLOADED BAMS TO FASTQS ###########################

rule bam_to_fastq:
    conda: "envs/utils.yaml"
    output:
        R1 = temp("samples/{sampid}/original_R1.fastq"),
        R2 = temp("samples/{sampid}/original_R2.fastq")
    input: "samples/{sampid}/original.bam"
    threads: workflow.cores
    params:
        tmp = config['local_tmp']
    shell:
        """
        picard SamToFastq --I {input} --FASTQ {output.R1} --SECOND_END_FASTQ {output.R2} --TMP_DIR {params.tmp}
        """
