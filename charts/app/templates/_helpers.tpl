{{- define "app.hostname" -}}
{{- if .Values.httpRoute.hostname }}
{{- .Values.httpRoute.hostname }}
{{- else }}
{{- $global := default dict .Values.global }}
{{- $domains := default dict $global.domains }}
{{- index $domains (include "voting-lib.name" .) | default "" }}
{{- end }}
{{- end }}

{{- define "app.parentRefs" -}}
{{- if .Values.httpRoute.parentRefs }}
{{- toYaml .Values.httpRoute.parentRefs }}
{{- else }}
{{- include "voting-lib.parentRefs" . }}
{{- end }}
{{- end }}

{{- define "app.imagePullSecrets" -}}
{{- $global := default dict .Values.global }}
{{- $secrets := .Values.imagePullSecrets | default list }}
{{- if $secrets }}
{{- toYaml $secrets }}
{{- else if $global.imagePullSecrets }}
{{- toYaml $global.imagePullSecrets }}
{{- end }}
{{- end }}
