echo "Checking for software used in this step"

echo "Checking for Kraken2"
echo "Checking for KrakenDB"
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20230605.tar.gz
tar xfv k2_standard_20230605.tar.gz
mv k2_standard_20230605.tar.gz ../../../../Reference/


echo "DONE Checking software"
