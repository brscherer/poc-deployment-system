package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
)

func TestNamespacesExist(t *testing.T) {
	kubeConfigPath := k8s.GetKubeConfigPathFromEnv()
	options := k8s.NewKubectlOptions("", kubeConfigPath, "default")

	// Verify 'infra' namespace exists
	infraNs := k8s.GetNamespace(t, options, "infra")
	assert.Equal(t, "infra", infraNs.Name)

	// Verify 'apps' namespace exists
	appNs := k8s.GetNamespace(t, options, "apps")
	assert.Equal(t, "apps", appNs.Name)
}

func TestGrafanaConfigMapExists(t *testing.T) {
	kubeConfigPath := k8s.GetKubeConfigPathFromEnv()
	options := k8s.NewKubectlOptions("", kubeConfigPath, "infra")

	cm := k8s.GetConfigMap(t, options, "grafana-dashboards")
	assert.Contains(t, cm.Data, "dashboard.json")
}
