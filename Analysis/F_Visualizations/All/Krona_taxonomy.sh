
for f in ../../C_Zone_Assembly*/C5_Bin_Classification/a_taxonomic_classification/kraken_out/kraken_aggregation/zone_level/zone.*.kreport; do
    a=${f#../../}
    b=${a%/C5*}
    ln -s $f $b.$(basename $f)
done

for f in ../../E_Control*/E5_Bin_Classification/a_taxonomic_classification/kraken_out/all.kreport; do
    a=${f#../../}
    b=${a%/E5_Bin_Classification/*}
    ln -s $f $b.$(basename $f)
done

for f in *kreport; do
    b=$(basename $f)

    cut -f2,3 $b /> $b.krona.input
done


ktImportTaxonomy *.krona.input -o all.krona.out.html -tax ../../Reference/kronatax/
