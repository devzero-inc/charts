{{/*
Expand the name of the chart.
*/}}
{{- define "devzero.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "devzero.fullname" -}}
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

{{/*
Resource name template
Params:
  ctx = . context
  component = component name (optional)
*/}}
{{- define "devzero.resourceName" -}}
{{- $resourceName := include "devzero.fullname" .ctx -}}
{{- $componentName := .component | replace "_" "-" -}}
{{- if .component -}}{{- $resourceName = printf "%s-%s" $resourceName .component -}}{{- end -}}
{{- $resourceName -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "devzero.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Resource labels
Params:
  ctx = . context
  component = component name (optional)
*/}}
{{- define "devzero.labels" -}}
helm.sh/chart: {{ include "devzero.chart" .ctx }}
app.kubernetes.io/name: {{ include "devzero.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{ if .ctx.Chart.AppVersion }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion }}
{{ end }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- end }}

{{/*
Selector labels
Params:
  ctx = . context
  component = name of the component
*/}}
{{- define "devzero.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devzero.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/*
Pod labels
Params:
  ctx = . context
  component = name of the component
*/}}
{{- define "devzero.podLabels" -}}
{{- include "devzero.labels" . }}
{{- if .component }}
  {{- with (index .ctx.Values .component).podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "devzero.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "devzero.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
POD annotations
Params:
  ctx = . context
  component = name of the component
*/}}
{{- define "devzero.podAnnotations" -}}
{{- with .ctx.Values.global.podAnnotations }}
{{ toYaml . }}
{{- end }}
{{- if .component }}
  {{- with (index .ctx.Values .component).podAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end }}
{{- end -}}
