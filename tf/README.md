# Integración AWS-Datadog con Terraform

## 📋 Descripción del Proyecto

Este proyecto implementa una integración completa entre AWS y Datadog utilizando Terraform como herramienta de Infrastructure as Code (IaC). La solución despliega una infraestructura de monitoreo que incluye instancias EC2 con agentes Datadog, dashboards personalizados y configuración de roles IAM con permisos específicos.

## 🏗️ Arquitectura Implementada

### Componentes Principales

- **2 Instancias EC2** (Frontend y Backend) con Amazon Linux 2
- **Agentes Datadog** instalados automáticamente vía user_data
- **Integración AWS-Datadog** con roles IAM específicos
- **Dashboard personalizado** en Datadog para métricas de infraestructura
- **Bucket S3** para almacenamiento de artefactos
- **CloudWatch Agent** para métricas adicionales

### Diagrama de Arquitectura

```
┌─────────────────┐    ┌─────────────────┐
│   Frontend EC2  │    │   Backend EC2   │
│   (t2.micro)    │    │   (t2.micro)    │
│                 │    │                 │
│ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │Datadog Agent│ │    │ │Datadog Agent│ │
│ └─────────────┘ │    │ └─────────────┘ │
└─────────┬───────┘    └─────────┬───────┘
          │                      │
          └──────────┬───────────┘
                     │
            ┌────────▼────────┐
            │   Datadog SaaS  │
            │   - Dashboard   │
            │   - Metrics     │
            │   - Monitoring  │
            └─────────────────┘
```

## 📁 Estructura de Archivos

```
tf/
├── README.md                    # Este archivo
├── provider.tf                  # Configuración de proveedores AWS y Datadog
├── variables.tf                 # Definición de variables
├── terraform.tfvars            # Valores de variables (credenciales)
├── datadog.tf                  # Integración AWS-Datadog y dashboard
├── iam.tf                      # Roles y políticas IAM
├── ec2.tf                      # Instancias EC2 con configuración Datadog
├── s3.tf                       # Bucket S3 y objetos
├── security_groups.tf          # Grupos de seguridad
└── scripts/
    ├── backend_user_data.sh    # Script de inicialización backend
    └── frontend_user_data.sh   # Script de inicialización frontend
```

## 🔄 Cambios Realizados

### 1. Configuración de Proveedores (`provider.tf`)
- **Agregado**: Proveedor Datadog versión ~> 3.0
- **Mantenido**: Proveedor AWS versión ~> 5.0
- **Configuración**: Credenciales vía variables de entorno y variables Terraform

### 2. Variables y Configuración (`variables.tf` y `terraform.tfvars`)
- **Creado**: Variables sensibles para API keys de Datadog
- **Implementado**: Archivo tfvars para valores de credenciales
- **Seguridad**: Marcado como sensible para evitar exposición en logs

### 3. Integración Datadog (`datadog.tf`)
- **Nuevo archivo**: Configuración completa de integración AWS-Datadog
- **Role IAM**: Para que Datadog acceda a métricas de AWS
- **Dashboard**: Widgets personalizados para CPU, red, memoria y conteo de instancias
- **Políticas**: Permisos específicos para lectura de métricas AWS

### 4. Infraestructura EC2 (`ec2.tf`)
- **Modificado**: Integración de datadog_api_key en user_data
- **Optimizado**: Cambio de t2.medium a t2.micro (Free Tier)
- **Mejorado**: Templates para pasar variables a scripts de inicialización

### 5. Scripts de User Data
- **Backend**: Instalación automática de Datadog Agent con configuración
- **Frontend**: Instalación automática de Datadog Agent con configuración
- **CloudWatch**: Configuración de agente para métricas adicionales
- **Tags**: Etiquetas organizacionales para clasificación

### 6. Permisos IAM (`iam.tf`)
- **Agregado**: Políticas para CloudWatch Agent
- **Agregado**: Políticas de acceso a S3
- **Mejorado**: Roles con permisos mínimos necesarios

### 7. Almacenamiento S3 (`s3.tf`)
- **Creado**: Bucket con nombre único para evitar conflictos
- **Configurado**: Encriptación AES256 por defecto
- **Seguridad**: Bloqueo de acceso público
- **Compatibilidad**: Eliminación de null_resource para Windows

## ⚠️ Desafíos Encontrados y Soluciones

### 1. Error "BucketAlreadyExists"
**🔴 Problema**: El nombre del bucket S3 `ai4devs-project-code-bucket` ya existía globalmente.

**✅ Solución**: 
- Cambio del nombre a `ai4devs-project-code-bucket-2025`
- Los nombres de bucket S3 deben ser únicos globalmente
- Recomendación: Usar sufijos únicos (timestamp, región, etc.)

### 2. Incompatibilidad con Windows PowerShell
**🔴 Problema**: Scripts bash en `null_resource` no funcionan en Windows.

**✅ Solución**:
- Eliminación del `null_resource` que usaba comando `sh`
- Creación manual de archivos ZIP usando PowerShell:
  ```powershell
  Compress-Archive -Path .\backend\* -DestinationPath .\backend.zip -Force
  Compress-Archive -Path .\frontend\* -DestinationPath .\frontend.zip -Force
  ```

### 3. Costos fuera del Free Tier
**🔴 Problema**: Instancias `t2.medium` generan costos fuera de la capa gratuita.

**✅ Solución**:
- Cambio de todas las instancias a `t2.micro`
- Verificación de límites del Free Tier:
  - 750 horas/mes de t2.micro
  - 5GB de almacenamiento S3
  - Servicios de CloudWatch incluidos

### 4. Variables de Datadog no definidas
**🔴 Problema**: Terraform no encontraba las credenciales de Datadog.

**✅ Solución**:
- Creación de archivo `terraform.tfvars`
- Definición de variables sensibles en `variables.tf`
- Configuración correcta del proveedor Datadog

### 5. Configuración de Credenciales
**🔴 Problema**: Complejidad en la configuración de credenciales AWS y Datadog.

**✅ Solución**:
- **AWS**: Variables de entorno (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
- **Datadog**: Variables en terraform.tfvars (api_key, app_key)
- Documentación paso a paso para obtener credenciales

## 🚀 Comandos de Despliegue

### Preparación (Una sola vez)
```powershell
# Crear archivos ZIP
Compress-Archive -Path .\backend\* -DestinationPath .\backend.zip -Force
Compress-Archive -Path .\frontend\* -DestinationPath .\frontend.zip -Force

# Configurar credenciales AWS
$env:AWS_ACCESS_KEY_ID="tu_access_key"
$env:AWS_SECRET_ACCESS_KEY="tu_secret_key"
```

### Despliegue
```bash
# Navegar al directorio
cd tf

# Inicializar Terraform
terraform init

# Validar configuración
terraform validate

# Revisar plan
terraform plan

# Aplicar cambios
terraform apply -auto-approve
```

## 📊 Recursos Creados

### AWS
- **2 Instancias EC2** t2.micro (Frontend y Backend)
- **1 Bucket S3** con encriptación y objetos ZIP
- **Roles IAM** para EC2 y integración Datadog
- **Políticas IAM** para CloudWatch y S3
- **Security Groups** para comunicación

### Datadog
- **Integración AWS** configurada
- **Dashboard "AWS Infrastructure Monitoring"** con widgets:
  - CPU Utilization por instancia
  - Network In/Out por instancia
  - Conteo total de instancias
  - Top instancias por CPU

## 💰 Optimización de Costos

### Configuración Free Tier
- ✅ **Instancias**: t2.micro (750h/mes gratuitas)
- ✅ **S3**: <1MB total (5GB gratuitos)
- ✅ **CloudWatch**: Métricas básicas incluidas
- ✅ **Datadog**: Tier gratuito (5 hosts)

### Estimación de Costos
**Costo mensual**: $0.00 (dentro de límites gratuitos)

## 🔒 Seguridad Implementada

### Mejores Prácticas
- **IAM**: Roles con permisos mínimos (principio de menor privilegio)
- **S3**: Acceso público bloqueado por defecto
- **Encriptación**: AES256 en bucket S3
- **Variables sensibles**: Marcadas como `sensitive = true`
- **Credenciales**: No hardcodeadas en archivos

### Tags de Organización
```hcl
tags = {
  Environment = "production"
  Project     = "ai4devs"
  Service     = "backend/frontend"
  ManagedBy   = "terraform"
}
```

## 🎯 Resultados Obtenidos

### ✅ Infraestructura Desplegada
- 2 instancias EC2 funcionando con Datadog Agent
- Dashboard operativo con métricas en tiempo real
- Integración AWS-Datadog completamente configurada
- Almacenamiento S3 con artefactos del proyecto

### ✅ Monitoreo Activo
- Métricas de CPU, memoria, disco y red
- Alertas configurables desde Datadog
- Tags organizacionales para filtrado
- Logs centralizados y estructurados

**Implementación completada exitosamente** ✅
