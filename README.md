# Replicate-ChiP-Seq-Analysis
In this project i replicated a ChiP-Seq analysis from an experiment regarding gene induction and repression during terminal erythropoiesis are mediated by distinct epigenetic changes.

You can find the research project [here](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3204918/)

## Data

The following **samples** from the project data have been used:

|Sample Name   |GEO Accession	  |Chip Anti-Body	  |Project Report Shortname
| ------------ |:--------------:| ---------------:|
|SRR1157326	   |GSM688808	      |H3K4me2	        |Sample0
|SRR1157329	   |GSM688811	      |H3K27me3	        |Sample1
|SRR1157333	   |GSM688815	      |RNA Pol II	      |Sample2
|SRR1157341	   |GSM688824	      |RNA Pol II	      |Sample3




## Tools you'll need:

* Python 2.7.1
* Samtools 1.11 (Utility)
* Bedtools 2.27.1 (Utility)
* FastQC 0.11.9 (Quality Control)
* Minion (Adapter Prediction)
* Cutadapt 1.9.1 (Adapter Trimming)
* Bowtie 1.0.0 (Alignment)
* MACS 1.4.1 (Peak Calling)
* MEME 5.0.2 (Motif analysis)

## Protocol
![logo]

[logo]: https://github.com/GeoRouv/Replicate-ChiP-Seq-Analysis/blob/main/Analysis%20Steps.jpg

1. Quality Control (FastQC) 
2. Adapter Prediction (Minion)
3. Adapter Trimming (Cutadapt)
4. Quality Control (FastQC)
5. Alignment (Bowtie)
6. Peak Calling (MACS)
7. Visualization (IGV)
8. Motif Analysis (MEME)


