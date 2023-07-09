# spg
Simple Pan-Genome workflow for MAGs.

## Description of SPG

This Nextflow workflow is designed to perform pangenome analysis on Metagenome-Assembled Genomes (MAGs) using [Roary](https://sanger-pathogens.github.io/Roary/) with [Prokka-generated](https://github.com/tseemann/prokka) GFF files and [FriPan](https://github.com/drpowell/FriPan) for visualization. Pangenome analysis allows for exploring genetic diversity and functional potential within a set of related genomes, specifically MAGs obtained from metagenomic samples.

The workflow assumes that the MAGs have undergone quality control and preprocessing steps, such as assembly, binning, and annotation, using tools like MetaBAT or MaxBin, and Prokka for gene annotation. The input for this workflow consists of Prokka-generated GFF files representing the annotated genes in the MAGs.

The workflow begins by collecting the Prokka GFF files as input. These files are then used by Roary, a powerful tool for pangenome analysis, to identify core and accessory genes among the MAGs. Roary performs clustering of gene annotations and generates a comprehensive pan-genome matrix. We defined the roary parameters following recommendations for Meta-Genome-Assembled Genomes (MAGs) as described in the following [benchmark study](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9677465/).

The resulting pan-genome matrix from Roary is then utilized to visualize the pangenome using FriPan, a specialized visualization tool for pangenome analysis. FriPan allows for exploring gene presence/absence patterns, functional variations, and identifying unique gene clusters within the pangenome.

Various quality control metrics and visualizations can be generated throughout the workflow to assess the reliability and interpretability of the pangenome analysis results. These metrics may include statistics on gene cluster distribution, presence/absence patterns, and functional annotations. FriPan facilitates the creation of intuitive visual representations of the pangenome, enabling researchers to gain insights into the gene content and functional variations among the MAGs.

Nextflow, as a workflow management system, ensures the scalability and reproducibility of the analysis, making it suitable for handling many MAGs. By leveraging the capabilities of Roary for pangenome analysis and FriPan for visualization, this workflow provides a comprehensive and streamlined approach for exploring the pangenome of MAGs obtained from metagenomic samples.

## Nextflow run

```
nextflow run digenoma-lab/spg -r 1.0 --input test.csv -profile kutral
```
The **-profile** "kutral" is specifically tailored for executing on the computing infrastructure of the Digenoma Lab. This configuration leverages containers, eliminating the need for manual software installation and configuration. By adopting containers, the workflow can seamlessly run with all the necessary dependencies encapsulated, ensuring reproducibility and ease of deployment. This profile streamlines the execution process and allows researchers in the Digenoma Lab to focus on their analysis without the overhead of managing software installations.

## Pipeline parameters

| Argument     | Description                                                               | Default Value               |
|--------------|---------------------------------------------------------------------------|-----------------------------|
| `--input`    | Location of the input file describing MAGs and their annotation from Prokka | null   |
| `--outdir`   | The NextFlow result directory                                             | "results"  |
| `--roary`    | The parameters for roary                                                   | "-n -e -i 90 -cd 80"   |
| `--help`    | Display the help message                                                   |  false   |


## Command to prepare the input from a set of genomes

```
find <path_to_mag_results> -name "*.gff" | \\
grep "Refined" | awk -F "/" '{print $11" "$11" "$0}' | \\
awk '{split($1, a, "-"); split(a[3],b,"."); print b[1]" "$2" "$3}' | \\
sed 's/ /,/g' > test.csv
```

The command performs operations to extract relevant information from GFF files found within the specified `<path_to_mag_results>` directory. It processes the data and exports it to a CSV file named `test.csv`.

Explanation:

1. `find <path_to_mag_results> -name "*.gff"`: This command searches for files with the ".gff" extension within the specified `<path_to_mag_results>` directory and its subdirectories.

2. `grep "Refined"`: The `grep` command filters the results to include only the lines containing the term "Refined".

3. `awk -F "/" '{print $11" "$11" "$0}'`: The `awk` command uses "/" as the field separator (`-F "/"`) and prints the 11th field, followed by a space, and then the entire line. This helps extract the relevant information and structure the output.

4. `awk '{split($1, a, "-"); split(a[3],b,"."); print b[1]" "$2" "$3}'`: Another `awk` command is used to split the first field (`$1`) using "-" as the delimiter. The third element from the resulting array is further split using "." as the delimiter. Finally, it prints the first element (`b[1]`), followed by a space, the second element (`$2`), another space, and the third element (`$3`).

5. `sed 's/ /,/g'`: The `sed` command replaces all occurrences of spaces with commas in the output. This helps format the data as comma-separated values (CSV).

6. `> test.csv`: The `>` operator redirects the processed output to a file named `test.csv`.

## Software versions

1. Roary: 3.13.0
2. roary2fripan : 0.1

## Contributions

  | Name      | Email | Description     |
  |-----------|---------------|-----------------| 
  | Alex Di Genova*    | alex.digenova@uoh.cl    | Developer to contact for support |



