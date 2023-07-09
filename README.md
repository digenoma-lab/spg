# spg
Simple Pan-Genome workflow for MAGs.

## Description of SPG

This Nextflow workflow is designed to perform pangenome analysis on Metagenome-Assembled Genomes (MAGs) using Roary with Prokka-generated GFF files and FriPan for visualization. Pangenome analysis allows for the exploration of genetic diversity and functional potential within a set of related genomes, specifically MAGs obtained from metagenomic samples.

The workflow assumes that the MAGs have undergone quality control and preprocessing steps, such as assembly, binning, and annotation using tools like MetaBAT or MaxBin, and Prokka for gene annotation. The input for this workflow consists of Prokka-generated GFF files representing the annotated genes in the MAGs.

The workflow begins by collecting the Prokka GFF files as input. These files are then used by Roary, a powerful tool for pangenome analysis, to identify core and accessory genes among the MAGs. Roary performs clustering of gene annotations and generates a comprehensive pan-genome matrix.

The resulting pan-genome matrix from Roary is then utilized to visualize the pangenome using FriPan, a specialized visualization tool for pangenome analysis. FriPan allows for the exploration of gene presence/absence patterns, functional variations, and the identification of unique gene clusters within the pangenome.

Throughout the workflow, various quality control metrics and visualizations can be generated to assess the reliability and interpretability of the pangenome analysis results. These metrics may include statistics on gene cluster distribution, presence/absence patterns, and functional annotations. FriPan facilitates the creation of intuitive visual representations of the pangenome, enabling researchers to gain insights into the gene content and functional variations among the MAGs.

Utilizing Nextflow as a workflow management system ensures scalability and reproducibility of the analysis, making it suitable for handling a large number of MAGs. By leveraging the capabilities of Roary for pangenome analysis and FriPan for visualization, this workflow provides a comprehensive and streamlined approach to explore the pangenome of MAGs obtained from metagenomic samples.

## Nextflow run

```
nextflow run spg.nf --input test.csv -profile kutral
```

## Command to prepare a set of genomes

```
find /mnt/beegfs/labs/DiGenomaLab/Systemix/analysis/mag-adg-spades/Prokka/SPAdes/ -name "*.gff" | grep "Refined" | awk -F "/" '{print $11" "$11" "$0}' | awk '{split($1, a, "-"); split(a[3],b,"."); print b[1]" "$2" "$3}' | sed 's/ /,/g' > test.csv
```

