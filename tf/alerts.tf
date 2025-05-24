# Alertas de Datadog para infraestructura AWS

# Alerta por CPU alto
resource "datadog_monitor" "high_cpu" {
  name    = "High CPU Usage on EC2 Instance"
  type    = "metric alert"
  message = <<-EOF
    **CPU Usage is above 80% on {{instanceid.name}}**
    
    Please check the instance performance:
    - Instance ID: {{instanceid.name}}
    - Current CPU: {{value}}%
    
    @your-email@example.com
  EOF

  query = "avg(last_5m):avg:aws.ec2.cpuutilization{*} by {instanceid} > 80"

  monitor_thresholds {
    warning  = 70
    critical = 80
  }

  notify_no_data    = false
  renotify_interval = 60
  notify_audit      = false
  timeout_h         = 24
  include_tags      = true

  tags = ["environment:production", "team:devops", "project:ai4devs"]
}

# Alerta por instancia sin datos (caída)
resource "datadog_monitor" "instance_down" {
  name    = "EC2 Instance Down or Unreachable"
  type    = "metric alert"
  message = <<-EOF
    **EC2 Instance is not reporting metrics**
    
    Instance {{instanceid.name}} has not reported metrics for 10 minutes.
    This could indicate:
    - Instance is stopped or terminated
    - Datadog agent is not running
    - Network connectivity issues
    
    @your-email@example.com
  EOF

  query = "avg(last_10m):avg:aws.ec2.cpuutilization{*} by {instanceid} < 0"

  monitor_thresholds {
    critical = 0
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 30
  notify_audit      = false
  timeout_h         = 24
  include_tags      = true

  tags = ["environment:production", "team:devops", "project:ai4devs"]
}

# Alerta por uso alto de memoria (si CloudWatch Agent está configurado)
resource "datadog_monitor" "high_memory" {
  name    = "High Memory Usage on EC2 Instance"
  type    = "metric alert"
  message = <<-EOF
    **Memory Usage is above 85% on {{host.name}}**
    
    Please check memory consumption:
    - Host: {{host.name}}
    - Current Memory: {{value}}%
    
    @your-email@example.com
  EOF

  query = "avg(last_5m):avg:system.mem.pct_usable{*} by {host} < 15"

  monitor_thresholds {
    warning  = 20
    critical = 15
  }

  notify_no_data    = false
  renotify_interval = 60
  notify_audit      = false
  timeout_h         = 24
  include_tags      = true

  tags = ["environment:production", "team:devops", "project:ai4devs"]
}

# Alerta por uso alto de disco
resource "datadog_monitor" "high_disk" {
  name    = "High Disk Usage on EC2 Instance"
  type    = "metric alert"
  message = <<-EOF
    **Disk Usage is above 90% on {{device.name}} of {{host.name}}**
    
    Please check disk space:
    - Host: {{host.name}}
    - Device: {{device.name}}
    - Current Usage: {{value}}%
    
    @your-email@example.com
  EOF

  query = "avg(last_5m):avg:system.disk.in_use{*} by {host,device} > 0.9"

  monitor_thresholds {
    warning  = 0.8
    critical = 0.9
  }

  notify_no_data    = false
  renotify_interval = 60
  notify_audit      = false
  timeout_h         = 24
  include_tags      = true

  tags = ["environment:production", "team:devops", "project:ai4devs"]
} 