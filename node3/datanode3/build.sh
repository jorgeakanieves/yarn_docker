
#echo "Y" | ssh-keygen -t rsa -P '' -f config/id_rsa

if [ ! -d "deps" ]; then
  mkdir -p deps
  echo "Downloading hadoop, spark dependencies"
  wget http://mirrors.whoishostingthis.com/apache/hadoop/common/hadoop-3.1.0/hadoop-3.1.0.tar.gz -P ./deps
#  wget http://mirrors.whoishostingthis.com/apache/spark/spark-2.3.0/spark-2.3.0-bin-without-hadoop.tgz -P ./deps
wget https://archive.apache.org/dist/spark/spark-2.3.0/spark-2.3.0-bin-without-hadoop.tgz  -P ./deps
else
  echo "Dependencies found, skipping retrieval..."
fi

cp -R ../../common/config ./
cp -R ../../common/datanode/Dockerfile ./
docker build . -t worker3
rm -rf Dockerfile
rm -rf config
rm -rf deps/*


