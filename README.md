# Erwinia_amylovora_bioinformatica
Scripts y resultados del análisis bioinformático del genoma de Erwinia amylovora

# Análisis de calidad de lecturas de secuenciación

## Objetivo
Evaluar la calidad de lecturas crudas obtenidas por secuenciación Illumina paired-end utilizando FastQC, analizar su contenido, estimar la cobertura y realizar interpretación taxonómica mediante One Codex. También contempla limpieza de adaptadores y recorte de baja calidad con Trimmomatic.

## Materiales
- Archivos FASTQ:
  - Forward: `*_R1.fastq.gz`
  - Reverse: `*_R2.fastq.gz`
- Link de descarga: [Google Drive](https://drive.google.com/drive/folders/13LFl0o7ONo02Hrov40zw39JPlWWeIgbf?usp=sharing)

### Herramientas
- [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- [One Codex](https://app.onecodex.com/)
- [Trimmomatic](https://github.com/usadellab/Trimmomatic)
- [SeqKit](https://github.com/shenwei356/seqkit)

## Metodología

1. **Evaluación de calidad con FastQC**
   - Abrir FastQC y cargar ambos archivos FASTQ.
   - Guardar resultados en `.html`.
   - Analizar módulos: per base sequence quality, per sequence quality scores, per base GC content, per base N content, sequence duplication levels, adapter content, overrepresented sequences.
   - Registrar warnings/fails y número total de lecturas.

2. **Análisis taxonómico con One Codex**
   - Crear cuenta o iniciar sesión.
   - Subir archivos FASTQ.
   - Identificar taxones predominantes, explorar contaminantes y guardar reportes.

## Resultados fastq
El análisis de las lecturas de secuenciación Illumina mostró un desempeño general excelente. Tanto las lecturas forward como reverse presentaron 8,674,825 secuencias cada una, con longitud constante de 151 pb y un contenido de GC de 53%, evidenciando homogeneidad y alta calidad entre ambos archivos . La evaluación con FastQC indicó que la mayoría de los módulos evaluados se encontraban en estado PASS, incluyendo la calidad por base y por secuencia, la composición de bases y la ausencia significativa de adaptadores o secuencias sobre-representadas. Las advertencias observadas, relacionadas con ligeras variaciones en Per tile sequence quality y la distribución de GC, se consideraron normales dada la alta cobertura y la baja diversidad de la muestra, sin comprometer la integridad de los datos. La plataforma One Codex corroboró estos resultados, mostrando que más del 96% de las lecturas se asignaban específicamente a E. amylovora, confirmando la dominancia de un solo organismo y la idoneidad de los datos para los análisis posteriores. La cobertura estimada, de aproximadamente 689X, garantizó una profundidad suficiente para la reconstrucción confiable del genoma y la identificación de elementos genéticos relevantes. 

# Ensamblado y anotación genómica - Erwinia amylovora
- Realizar el ensamblado de novo de un genoma a partir de lecturas paired-end utilizando tres programas distintos: SPAdes, ABySS y VelvetOptimiser.
- Evaluar la calidad de los ensamblados obtenidos con QUAST y realizar la anotación genómica usando Prokka.

## Material
- Archivos FASTQ previamente procesados con Trimmomatic:
  - Forward reads: `LMX_R1.fastq.gz`
  - Reverse reads: `LMX_R2.fastq.gz`

## Programas
- [SPAdes](https://github.com/ablab/spades)
- [ABySS](https://github.com/bcgsc/abyss)
- [Velvet + VelvetOptimiser](https://github.com/tseemann/VelvetOptimiser)
- [QUAST](https://github.com/ablab/quast)
- [Prokka](https://github.com/tseemann/prokka)

## Metodología

### 1. Estimación del k-mer óptimo
- Se utilizó VelvetAdvisor para definir un rango adecuado de valores de k.
- Parámetros ingresados:
  - Tamaño promedio de lectura
  - Tipo de lectura: paired-end
  - Tamaño estimado del genoma
  - Cobertura estimada
- Nota: k debe ser impar; valores muy pequeños o muy grandes afectan la sensibilidad y continuidad del ensamblado.

### 2. Ensamblado con SPAdes
```bash
spades.py --careful -1 sample_R1.fastq.gz -2 sample_R2.fastq.gz -k 21,33,55,77,99,127 -o spades


### Comandos utilizados

 **SPAdes**    `~/bioinformatica/SPAdes-4.2.0-Linux/bin/spades.py -k 91,93,95,97,99 --careful -m 8 -1 ~/bioinformatica/practica6/reads/Erw1_1.fastq -2 ~/bioinformatica/practica6/reads/Erw1_2.fastq -o ~/bioinformatica/practica6/spades` 
**ABySS**       `abyss-pe -C abyss/kXX name=abyss k=XX B=1G in='reads/Erw1_1.fastq reads/Erw1_2.fastq'`<br>*Donde XX corresponde a los valores de k-mer evaluados (91, 93, 95, 97 y 99).* 
**VelvetOptimiser**   `VelvetOptimiser.pl -s 91 -e 99 -f '-shortPaired -fastq /home/ortizgaby/bioinformatica/practica6/reads/Erw1_1.fastq /home/ortizgaby/bioinformatica/practica6/reads/Erw1_2.fastq' -d VelvetOp -p VelvetOp` 
 **QUAST**      `quast.py abyss/k99/abyss-contigs.fa spades/spades/contigs.fasta velvet/contigs.fa -o quast/resultados_finales` 
 **Prokka**        `prokka --outdir LMX1_prokka --force --prefix LMX1 --genus Erwinia --kingdom Bacteria --usegenus --evalue 1e-12 spades/spades/contigs.fasta`

En cuanto al ensamblado genómico, se emplearon tres programas distintos SPAdes, ABySS y VelvetOptimiser. La comparación de los resultados mediante QUAST permitió seleccionar el ensamblado de SPAdes como el de mejor calidad , debido a su balance entre continuidad, bajo número de contigs y ausencia de regiones indefinidas. Este ensamblado presentó un N50 de 323,275 pb, 33 contigs y un tamaño total de 3,785,642 pb, garantizando un ensamblado sólido y confiable. Los otros ensambladores, aunque con ciertas métricas elevadas, mostraron limitaciones como fragmentación excesiva o presencia de regiones no resueltas. Posteriormente, la anotación con Prokka  sobre el ensamblado de SPAdes permitió identificar 3,411 genes codificantes, 16 rRNA, 71 tRNA y 1 tmRNA, generando un perfil funcional completo y consistente con lo esperado para un genoma de E. amylovora.


# Análisis Filogenómico - Erwinia amylovora
Realizar un análisis filogenómico basado en secuencias de genomas bacterianos mediante hibridación virtual y cálculo de distancias genéticas utilizando VAMPhyRE y VFAT.

## Descarga de datos e instalación de software
1. **Genomas de referencia y ensamblados**
   - Agregar los ensamblados obtenidos 
2. **Instalación de software**
   - Clonar VAMPhyRE:  
     ```bash
     git clone https://github.com/alfonsomt/vamphyre
     ```
   - Instalar MEGA: [MEGA Software](https://www-megasoftware-net.translate.goog/?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc)

## Preprocesamiento de secuencias
- Concatenar contigs de cada genoma usando el script:  
  ```bash
  chmod +x ContigsConcatenation.sh
  ./ContigsConcatenation.sh

chmod +x VH5cmdl
VH5cmdl -PROBEFILE vps13.txt -TARGETLIST list.txt -OUTFILE vh_salida.txt -MISMATCHES 1 -STRAND both


chmod +x VFAT
VFAT -VHFILE vh_salida.txt -TARGETLIST list.txt -OUTFILE dist_salida -LEFTEXT 4 -RIGHTEXT 4 -THRESHOLD 19 -MODE DISTANCE


Para validar la identidad del ensamblado, se realizó un análisis filogenómico utilizando VAMPhyRE, integrando 14 genomas de referencia de E. amylovora y un grupo externo, Agrobacterium tumefaciens. La reconstrucción del árbol filogenético mediante el método Neighbor-Joining en MEGA, posteriormente editado en iTOL, situó el ensamblado de SPAdes dentro del clúster de E. amylovora, mientras que A. tumefaciens quedó claramente separado como grupo externo . Este resultado confirmó que el genoma analizado pertenece a la especie de interés y que las lecturas y el ensamblado reflejan la composición genómica correcta del patógeno, respaldando tanto la calidad de la secuenciación como la confiabilidad del flujo de trabajo bioinformático utilizado.




   - Cobertura (X) = (Número de lecturas × 2 × longitud promedio de lectura) / tamaño del genoma
   - Nota: Multiplicar por 2 por tratarse de lecturas paired-end. Usar tamaño de genoma del mejor hit de One Codex.
