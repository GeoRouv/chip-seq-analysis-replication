# BOWTIE configuration
echo "Searching mm9 genome.."
bowtie-build ./data/bowtie_indexes/mm9.fa.gz ./bowtie_indexes/mm9
echo "Genome indexing done!"

echo "Creating genome file..."
gzip -dk ./data/bowtie_indexes/mm9.fa.gz
samtools faidx ./data/bowtie_indexes/mm9.fa
cut -f 1,2 ./data/bowtie_indexes/mm9.fa.fai > ./data/bowtie_indexes/mm9.genome

#Sample analysis
echo "Starting analysis for all samples..."
bash Pipeline.sh
echo "Finished analysis for all samples!"


#Visualization
"Starting IGV to visualize data..."
#IGV
#run igv
~/software/IGV_2.3.12/igv.sh
#Load genome mm9
#Load bam files
#Find target regions from MACS analysis
