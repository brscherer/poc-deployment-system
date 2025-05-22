package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
)

func TestNamespacesExist(t *testing.T) {
	options := k8s.NewKubectlOptions("", "", "default")

	// Verify 'infra' namespace exists
	infraNs := k8s.GetNamespace(t, options, "infra")
	assert.Equal(t, "infra", infraNs.Name)

	// Verify 'apps' namespace exists
	appNs := k8s.GetNamespace(t, options, "apps")
	assert.Equal(t, "apps", appNs.Name)
}

func TestGrafanaConfigMapExists(t *testing.T) {
	options := k8s.NewKubectlOptions("", "", "infra")

	cm := k8s.GetConfigMap(t, options, "grafana-dashboards")
	assert.Contains(t, cm.Data, "dashboard.json")
}
