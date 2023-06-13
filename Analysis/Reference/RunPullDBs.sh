###This is to pull databases for analyses not yet in the main pipeline, but in progress of adding.


echo "Checking and downloading megan database"
if [ -d "${./reference_database/megan_ref" ]; then
     echo "megan database already installed"
else
     echo "Downloading megan database (Takes a long time, be patient)"
     mkdir -p  ./reference_database/megan_ref
     cd ./reference_database/megan_ref
     wget http://ab.inf.uni-tuebingen.de/data/software/megan6/download/prot_acc2tax-Nov2018X1.abin.zip
     unzip prot_acc2tax-Nov2018X1.abin.zip
     wget http://ab.inf.uni-tuebingen.de/data/software/megan6/download/acc2kegg-Dec2017X1-ue.abin.zip
     unzip acc2kegg-Dec2017X1-ue.abin.zip
     wget http://ab.inf.uni-tuebingen.de/data/software/megan6/download/acc2interpro-June2018X.abin.zip
     unzip acc2interpro-June2018X.abin.zip
     wget http://ab.inf.uni-tuebingen.de/data/software/megan6/download/acc2eggnog-Oct2016X.abin.zip
     unzip acc2eggnog-Oct2016X.abin.zip
     wget http://ab.inf.uni-tuebingen.de/data/software/megan6/download/nucl_acc2tax-Nov2018.abin.zip
     unzip nucl_acc2tax-Nov2018.abin.zip
     wget http://ab.inf.uni-tuebingen.de/data/software/megan6/download/acc2seed-May2015XX.abin.zip
     unzip acc2seed-May2015XX.abin.zip
fi
echo "DONE checking and downloading megan database!"

echo "Checking and downloading humann2 database"
if [ -d "${REFERENCE_FOLDER}/reference_database/humann2_databases" ]; then
    echo "humann2 database already installed"
else
    hg clone https://bitbucket.org/biobakery/humann2
    cd humann2
    python3 setup.py install --user
    echo "Downloading humann2 database (Takes a long time, be patient)"
    mkdir -p ./reference_database/humann2_databases
    humann2_databases --download chocophlan full ./reference_database/humann2_databases
    #To download the full UniRef90 database (11.0GB, recommended):
    humann2_databases --download uniref uniref90_diamond ./reference_database/humann2_databases
    #To download the EC-filtered UniRef90 database (0.8GB):
    humann2_databases --download uniref uniref90_ec_filtered_diamond ./reference_database/humann2_databases
    #To download the full UniRef50 database (4.6GB):
    humann2_databases --download uniref uniref50_diamond ./reference_database/humann2_databases
    #To download the EC-filtered UniRef50 database (0.2GB):
    humann2_databases --download uniref uniref50_ec_filtered_diamond ./reference_database/humann2_databases
    humann2_config --update database_folders nucleotide ./reference_database/humann2_databases/chocophlan/
    humann2_config --update database_folders protein ./reference_database/humann2_databases/uniref/
fi

echo "DONE checking and downloading humann2 database!"

echo "Checking and downloading metaphlan database"
if [ -d "./reference_database/metaphlan2" ]; then
    echo "metaphlan database already installed"
else
    mkdir -p ./reference_database/metaphlan2
    cd ./reference_database/metaphlan2
    wget https://bitbucket.org/biobakery/metaphlan2/downloads/mpa_v20_m200.tar
    tar -xvvf mpa_v20_m200.tar
    bunzip2 mpa_v20_m200.fna.bz2
    bowtie2-build --threads 20 mpa_v20_m200.fna mpa_v20_m200
    rm mpa_v20_m200.tar
fi
echo "DONE checking and downloading metaphlan database!"
