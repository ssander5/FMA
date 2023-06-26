
for f in ../../C_Zone_Assembly*/C5_Bin_Classification/a_taxonomic_classification/kraken_out/kraken_aggregation/zone_level/zone.*.kreport; do
    a=${f#../../}
    b=${a%/C5*}
    ln -s $f $b.$(basename $f)
done

#for f in ../../C_*/C5_Bin_Classification/a_taxonomic_classification/kraken_out/zone*/*.kreport; do
for f in *kreport; do
    ln -s $f .
    b=$(basename $f)

    cut -f2,3 $b /> $b.krona.input
done


ktImportTaxonomy *.krona.input -o zones.krona.out.html -tax ../../Reference/kronatax/
