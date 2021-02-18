#!/bin/sh

bwa index Saccharomyces_cerevisiae.EF4.68.dna.toplevel.fa

for n in {1..2}
do
	bwa mem -R '@RG\tID:'"$n"'\tLB:library\tPL:Illumina\tPU:lane'"$n"'\tSM:yeast' \
	Saccharomyces_cerevisiae.EF4.68.dna.toplevel.fa \
	lane$n/s-7-1.trim.paired.fastq lane$n/s-7-2.trim.paired.fastq | \
	samtools view -b - | \
	samtools sort - -o lane${n}_sorted.bam  &&

	samtools index lane${n}_sorted.bam
done

picard MergeSamFiles INPUT=lane1_sorted.bam INPUT=lane2_sorted.bam OUTPUT=library.bam

samtools index library.bam

samtools view -C \
        -T Saccharomyces_cerevisiae.EF4.68.dna.toplevel.fa \
        lane1_sorted.bam > lane1_sorted.cram
