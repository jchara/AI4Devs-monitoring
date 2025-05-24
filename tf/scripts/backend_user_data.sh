#!/bin/bash
yum update -y
sudo yum install -y docker

# Iniciar el servicio de Docker
sudo service docker start

# Instalar Datadog Agent
DD_API_KEY="${datadog_api_key}" DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Configurar Datadog Agent para Docker
cat <<EOF > /etc/datadog-agent/conf.d/docker.d/conf.yaml
init_config:

instances:
  - url: "unix://var/run/docker.sock"
    new_tag_names: true
    collect_container_size: true
    collect_container_count: true
    collect_images_stats: true
    collect_image_size: true
    collect_disk_stats: true
EOF

# Configurar tags para identificar la instancia
cat <<EOF >> /etc/datadog-agent/datadog.yaml
tags:
  - env:production
  - service:backend
  - project:ai4devs
EOF

# Dar permisos al agente para acceder a Docker
sudo usermod -a -G docker dd-agent

# Reiniciar Datadog Agent
sudo systemctl restart datadog-agent
sudo systemctl enable datadog-agent

# Descargar y descomprimir el archivo backend.zip desde S3
aws s3 cp s3://ai4devs-project-code-bucket/backend.zip /home/ec2-user/backend.zip
unzip /home/ec2-user/backend.zip -d /home/ec2-user/

# Construir la imagen Docker para el backend
cd /home/ec2-user/backend
sudo docker build -t lti-backend .

# Ejecutar el contenedor Docker
sudo docker run -d -p 8080:8080 lti-backend

# Timestamp to force update
echo "Timestamp: ${timestamp}"
