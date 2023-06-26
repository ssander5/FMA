
for f in ./*kreport; do
    kraken-biom $f --fmt json -o $f.all.biom
done

kraken-biom *.kreport --fmt json -o all.biom

Rscript RunPhyloseq.R
