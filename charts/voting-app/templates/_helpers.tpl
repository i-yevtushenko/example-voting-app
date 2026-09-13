{{- define "voting-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "voting-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "voting-app.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "voting-app.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "voting-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "voting-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "voting-app.syncWave" -}}
argocd.argoproj.io/sync-wave: {{ . | quote }}
{{- end }}

{{- define "voting-app.postgresSecretName" -}}
{{- default (printf "%s-postgres" (include "voting-app.fullname" .)) .Values.externalSecret.targetName }}
{{- end }}

{{- define "voting-app.redisSecretName" -}}
{{- default (printf "%s-redis" (include "voting-app.fullname" .)) .Values.externalSecret.redis.targetName }}
{{- end }}

{{- define "voting-app.image" -}}
{{- $tag := default .root.Chart.AppVersion .component.image.tag | toString }}
{{- printf "%s:%s" .component.image.repository $tag }}
{{- end }}

{{- define "voting-app.postgresAppEnv" -}}
{{- if .Values.db.enabled }}
- name: POSTGRES_HOST
  value: db
- name: POSTGRES_PORT
  value: {{ .Values.db.service.port | quote }}
{{- else }}
- name: POSTGRES_HOST
  valueFrom:
    secretKeyRef:
      name: {{ include "voting-app.postgresSecretName" . }}
      key: host
- name: POSTGRES_PORT
  valueFrom:
    secretKeyRef:
      name: {{ include "voting-app.postgresSecretName" . }}
      key: port
{{- end }}
- name: POSTGRES_DB
  value: postgres
- name: POSTGRES_USER
  valueFrom:
    secretKeyRef:
      name: {{ include "voting-app.postgresSecretName" . }}
      key: username
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "voting-app.postgresSecretName" . }}
      key: password
{{- end }}

{{- define "voting-app.redisAppEnv" -}}
{{- if .Values.redis.enabled }}
- name: REDIS_HOST
  value: redis
- name: REDIS_PORT
  value: {{ .Values.redis.service.port | quote }}
{{- else }}
- name: REDIS_HOST
  valueFrom:
    secretKeyRef:
      name: {{ include "voting-app.redisSecretName" . }}
      key: host
- name: REDIS_PORT
  valueFrom:
    secretKeyRef:
      name: {{ include "voting-app.redisSecretName" . }}
      key: port
{{- end }}
{{- end }}
