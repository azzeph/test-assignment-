Инструкция по сборке и запуску:
docker build -f Dockerfile . -t demo:v1
docker run -p8080:8080 -eJAVA_OPTS="-Xms1G -Xmx2G" demo:v1 
curl -s -X GET localhost:8080
