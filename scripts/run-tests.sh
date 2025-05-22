set -euo pipefail

echo "🚀 Starting test suite..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
  echo "❌ Go is not installed. Please install Go to run tests."
  exit 1
fi

# Infra Tests with Terratest
echo "🧪 Running infrastructure tests..."
pushd infra/tests > /dev/null
go test -v -timeout 5m
popd > /dev/null

echo "✅ All tests passed!"
