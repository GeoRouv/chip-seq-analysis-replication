#!/usr/bin/env 

#FASTQC
echo "Starting FastQC #1..."
fastqc ./data/original_samples/sra_data0.fastq -o ./output/1_fastQC/Sample0
fastqc ./data/original_samples/sra_data1.fastq -o ./output/1_fastQC/Sample1
fastqc ./data/original_samples/sra_data2.fastq -o ./output/1_fastQC/Sample2
fastqc ./data/original_samples/sra_data3.fastq -o ./output/1_fastQC/Sample3

#MINION
echo "Starting minion..."
minion search-adapter -i ./data/original_samples/sra_data0.fastq > ./output/2_minion/Sample0_output.txt
minion search-adapter -i ./data/original_samples/sra_data1.fastq > ./output/2_minion/Sample1_output.txt
minion search-adapter -i ./data/original_samples/sra_data2.fastq > ./output/2_minion/Sample2_output.txt
minion search-adapter -i ./data/original_samples/sra_data3.fastq > ./output/2_minion/Sample0_output.txt

#CUTADAPT illumina universal adapter
echo "Starting Cutadapt..."
cutadapt -a AGATCGGAAGAG -o ./output/3_cutadapt/Sample0/trimmed_sra_data0.fastq ./data/original_samples/sra_data0.fastq > ./output/3_cutadapt/Sample0/log.txt
cutadapt -a AGATCGGAAGAG -o ./output/3_cutadapt/Sample1/trimmed_sra_data1.fastq ./data/original_samples/sra_data1.fastq > ./output/3_cutadapt/Sample1/log.txt
cutadapt -a AGATCGGAAGAG -o ./output/3_cutadapt/Sample2/trimmed_sra_data2.fastq ./data/original_samples/sra_data2.fastq > ./output/3_cutadapt/Sample2/log.txt
cutadapt -a AGATCGGAAGAG -o ./output/3_cutadapt/Sample3/trimmed_sra_data3.fastq ./data/original_samples/sra_data3.fastq > ./output/3_cutadapt/Sample3/log.txt

#FASTQC #2
echo "Starting FastQC #2..."
fastqc ./data/trimmed_sra_data0.fastq -o ./output/4_fastqc/Sample0
fastqc ./data/trimmed_sra_data1.fastq -o ./output/4_fastqc/Sample1
fastqc ./data/trimmed_sra_data2.fastq -o ./output/4_fastqc/Sample2
fastqc ./data/trimmed_sra_data3.fastq -o ./output/4_fastqc/Sample3

#BOWTIE
echo "Starting Bowtie..."
bowtie -p 8 -m 1 -S ./data/bowtie_indexes/mm9 ./output/3_cutadapt/Sample0/trimmed_sra_data0.fastq > ./output/5_bowtie/Sample0/test.sam
bowtie -p 8 -m 1 -S ./data/bowtie_indexes/mm9 ./output/3_cutadapt/Sample1/trimmed_sra_data1.fastq > ./output/5_bowtie/Sample1/test.sam
bowtie -p 8 -m 1 -S ./data/bowtie_indexes/mm9 ./output/3_cutadapt/Sample0/trimmed_sra_data0.fastq > ./output/5_bowtie/Sample2/test.sam
bowtie -p 8 -m 1 -S ./data/bowtie_indexes/mm9 ./output/3_cutadapt/Sample0/trimmed_sra_data0.fastq > ./output/5_bowtie/Sample3/test.sam

samtools view -bSo ./output/5_bowtie/Sample0/test.bam ./output/5_bowtie/Sample0/test.sam
samtools view -bSo ./output/5_bowtie/Sample1/test.bam ./output/5_bowtie/Sample1/test.sam
samtools view -bSo ./output/5_bowtie/Sample2/test.bam ./output/5_bowtie/Sample2/test.sam
samtools view -bSo ./output/5_bowtie/Sample3/test.bam ./output/5_bowtie/Sample3/test.sam

samtools sort ./output/5_bowtie/Sample0/test.bam -o ./output/5_bowtie/Sample0/sorted_test.bam
samtools sort ./output/5_bowtie/Sample1/test.bam -o ./output/5_bowtie/Sample1/sorted_test.bam
samtools sort ./output/5_bowtie/Sample2/test.bam -o ./output/5_bowtie/Sample2/sorted_test.bam
samtools sort ./output/5_bowtie/Sample3/test.bam -o ./output/5_bowtie/Sample3/sorted_test.bam


samtools index ./output/5_bowtie/Sample0/sorted_test.bam
samtools index ./output/5_bowtie/Sample1/sorted_test.bam
samtools index ./output/5_bowtie/Sample2/sorted_test.bam
samtools index ./output/5_bowtie/Sample3/sorted_test.bam

#MACS (PEAK FINDING)
echo "Starting MACS..."
macs14 -t ./output/5_bowtie/Sample0/sorted_test.bam -f BAM -g mm -n MACStest 
macs14 -t ./output/5_bowtie/Sample1/sorted_test.bam -f BAM -g mm -n MACStest 
macs14 -t ./output/5_bowtie/Sample2/sorted_test.bam -f BAM -g mm -n MACStest 
macs14 -t ./output/5_bowtie/Sample3/sorted_test.bam -f BAM -g mm -n MACStest 

#MEME
echo "Starting MEME..."
slopBed -i ./output/6_MACS/Sample0/MACStest_summits.bed -g ./data/bowtie_indexes/mm9.genome -b 20 > ./output/8_Meme/Sample0/MACStest_summits-b20.bed
slopBed -i ./output/6_MACS/Sample1/MACStest_summits.bed -g ./data/bowtie_indexes/mm9.genome -b 20 > ./output/8_Meme/Sample1/MACStest_summits-b20.bed
slopBed -i ./output/6_MACS/Sample2/MACStest_summits.bed -g ./data/bowtie_indexes/mm9.genome -b 20 > ./output/8_Meme/Sample2/MACStest_summits-b20.bed
slopBed -i ./output/6_MACS/Sample3/MACStest_summits.bed -g ./data/bowtie_indexes/mm9.genome -b 20 > ./output/8_Meme/Sample3/MACStest_summits-b20.bed

fastaFromBed -fi ./data/bowtie_indexes/mm9.fa -bed ./output/6_MACS/Sample0/MACStest_summits-b20.bed  > ./output/8_Meme/Sample0/MACStest_summits-b20.fa
fastaFromBed -fi ./data/bowtie_indexes/mm9.fa -bed ./output/6_MACS/Sample1/MACStest_summits-b20.bed  > ./output/8_Meme/Sample1/MACStest_summits-b20.fa
fastaFromBed -fi ./data/bowtie_indexes/mm9.fa -bed ./output/6_MACS/Sample2/MACStest_summits-b20.bed  > ./output/8_Meme/Sample2/MACStest_summits-b20.fa
fastaFromBed -fi ./data/bowtie_indexes/mm9.fa -bed ./output/6_MACS/Sample3/MACStest_summits-b20.bed  > ./output/8_Meme/Sample3/MACStest_summits-b20.fa

meme ./output/8_Meme/Sample0/MACStest_summits-b20.fa -o meme -dna
meme ./output/8_Meme/Sample1/MACStest_summits-b20.fa -o meme -dna
meme ./output/8_Meme/Sample2/MACStest_summits-b20.fa -o meme -dna
meme ./output/8_Meme/Sample3/MACStest_summits-b20.fa -o meme -dna
