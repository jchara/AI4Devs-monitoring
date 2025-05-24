# Integración AWS-Datadog con Terraform

## 🤖 Modelo LLM Utilizado
**Claude 4 Sonnet Thinking** - AI Assistant desarrollado por Anthropic

---

## 📋 Contexto del Proyecto

**Objetivo**: Extender código Terraform existente para:
- Configurar integración Datadog con AWS
- Instalar agente Datadog en instancias EC2
- Crear dashboard en Datadog para visualizar métricas AWS
- Mantener costos en capa gratuita de AWS

**Infraestructura Base Existente**:
- Instancias EC2 (Frontend y Backend)
- Security Groups
- Roles IAM básicos
- Scripts de user_data

---

## 🚀 PROMPTS PASO A PASO

### PROMPT 1: Análisis del Proyecto
```
Eres un experto ingeniero desarrollador y devsecops, analiza este proyecto y oriéntame para hacer lo siguiente.

Tengo una cuenta AWS y Datadog en su capa gratuita, necesito ajustar la configuración de terraform para tener configuradas las credenciales de AWS y Datadog en mi entorno local, mi sistema operativo es windows 11.
```

### PROMPT 2: Configuración de Credenciales
```
Cómo obtengo las credenciales de AWS y Datadog, Explica paso a paso para cada plataforma lo siguiente:
- AWS_ACCESS_KEY_ID y AWS_SECRET_ACCESS_KEY
- datadog_api_key y datadog_app_key
```

### PROMPT 3: Implementación de la Integración
```
Como experto en devsecops extiende el código Terraform existente para:

1. Configurar la integración de Datadog con AWS usando Terraform.
2. Instalar el agente Datadog en la instancia EC2.
3. Crear un dashboard en Datadog para visualizar métricas clave de AWS.

Pasos a Seguir:
a) Configurar la Integración AWS-Datadog:
Utiliza Terraform para configurar la integración entre AWS y Datadog, siguiendo la guía proporcionada.

b) Configurar el Proveedor Datadog:
Añade el proveedor Datadog a tu configuración de Terraform.

c) Instalar el Agente Datadog:
Modifica el script de usuario de la instancia EC2 para instalar y configurar el agente Datadog.

d) Crear un Dashboard:
Utiliza Terraform para definir un dashboard en Datadog que muestre métricas relevantes de tu infraestructura AWS.

Hazlo paso a paso y en cada uno de los pasos si tienes dudas pregúntame primero antes de realizar cualquier cambio.
```

### PROMPT 4: Verificación de Costos antes de Apply
```
Antes de dar el último paso y ejecutar los comandos de terraform, debido a que estoy en la capa gratuita de AWS, como experto en devsecops analiza la configuración de los archivos terraform que se han realizado para dar un doble check.

Analiza específicamente:
- Tipos de instancias EC2 que se van a crear
- Almacenamiento S3 y transferencias
- Servicios de Datadog 
- Cualquier otro recurso que pueda generar costos

Si hay recursos que generen costos, recomienda los ajustes, no modifiques nada, solo realiza las recomendaciones en caso de encontrarlas.
```

### PROMPT 5: Solución de Error de Bucket S3
```
Ejecuté terraform apply y me dio este error:

Error: creating S3 Bucket (ai4devs-project-code-bucket): operation error S3: CreateBucket, https response error StatusCode: 409, RequestID: [ID], HostID: [HOST], BucketAlreadyExists:

¿Cómo lo soluciono? ¿La solución estaría cambiando el nombre del bucket?
```

### PROMPT 6: Verificación Final antes de Apply
```
La implementación de terraform fue exitosa, verifica una última vez la implementación para ver si hay margen de mejora en configuraciones de seguridad.
```

### PROMPT 7: Documentación del Proyecto
```
En @README.md crea un resumen y explicación de la implementación terraform y de los cambios realizados,

Incluye:
- Descripción completa del proyecto y arquitectura implementada
- Estructura de archivos del proyecto
- Cambios realizados en cada archivo con justificación técnica
- Desafíos encontrados durante la implementación y sus soluciones específicas
- Comandos de despliegue y configuración
- Recursos creados en AWS y Datadog
- Optimización de costos
- Mejores prácticas de seguridad implementadas
- Resultados obtenidos y funcionalidades operativas

El documento debe ser profesional, técnico y servir como documentación oficial del proyecto.
```