#!/usr/bin/env nextflow

nextflow.enable.dsl = 2
//check some variables before execution
params.help = false
params.debug = false
params.input= null
params.outdir="results"
params.enable_conda = null

//this options are for MAG genomes
params.roary = "-n -e -i 90 -cd 80"
//see this paper
//https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9677465/

def help_function() {
    help = """spg.nf: Simple pangenome analisis run roary + roary2fripan
             |Required arguments:
             |  --input  Location of the input file describing MAGs and their annotation from Prokka
             |                [default: ${params.input}]
             |
             |Optional arguments:
             |  --cpus   number of cpus
             |                [default: ${params.cpus}]
             |  --outdir       The NextFlow result directory.
             |                [default: ${params.outdir}]
             |  --roary       The parameters for roary.
             |                [default: ${params.roary}]
             |                """.stripMargin()
    // Print the help with the stripped margin and exit
    println(help)
    exit(0)
}

process ROARY {
    tag "${meta}-roary"
    
    publishDir "$params.outdir/roary/${meta}", mode: "copy"

     conda (params.enable_conda ? "bioconda::roary==3.13.0--pl526h516909a_0" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/roary:3.13.0--pl526h516909a_0"
    } else {
        container "quay.io/biocontainers/roary:3.13.0--pl526h516909a_0"
    }

    input:
    tuple val(meta), val(mags), path(prokka_gff3)

    output:
    tuple val(meta), path("${prefix}/gene_presence_absence.csv") , emit: roary_pa
    path "${prefix}"

    when:
    prokka_gff3.toList().size().value > 1

    script:
    prefix          = "${meta}_ry"
    if(params.debug){
    """
        echo  roary -p $task.cpus ${params.roary} -f $prefix *.gff
        mkdir ${prefix}
        touch ${prefix}/gene_presence_absence.csv
    """
    }else{
    """
    roary -p $task.cpus ${params.roary} -f $prefix *.gff
    """
    }
}


process ROARY2FRIPAN {
     tag "${meta}-fripan"
    publishDir "$params.outdir/fripan/${meta}", mode: "copy"

    conda (params.enable_conda ? "bioconda::roary2fripan.py==0.1--hdfd78af_2" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/roary2fripan.py:0.1--hdfd78af_2"
    } else {
        container "quay.io/biocontainers/roary2fripan.py:0.1--hdfd78af_2"
    }

    input:
    tuple val(meta), path(roary_pa)

    output:
    path "${prefix}.*"

    script:
    prefix          = "${meta}_fp"
    if(params.debug){
     """
     echo roary2fripan.py --input $roary_pa ${prefix}
     mkdir ${prefix} 
     """
    }else{
    """
    roary2fripan.py --input $roary_pa ${prefix}
    """
    }
}

workflow {
    //we read pairs from regex 
     if(params.help){
        help_function()
     }

    if(params.input == null || params.outdir == null){
        help_function()
        
    }else{     
    //we reads pairs from csv
    genomes=Channel.fromPath(params.input) \
        | splitCsv(header:true) \
        | map { row-> tuple(row.sampleId, row.mag, file(row.gff))}\
   } 
    //genomes.view()
    groups=genomes.groupTuple(by: 0)
    //groups.view()
    ROARY(groups)
    ROARY2FRIPAN(ROARY.out.roary_pa)   
}

