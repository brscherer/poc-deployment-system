const promClient = require("prom-client");

const register = new promClient.Registry();
register.setDefaultLabels({ app: "server" });
promClient.collectDefaultMetrics({ register });

const httpRequestCount = new promClient.Counter({
  name: "http_requests_total",
  help: "Total HTTP requests",
  labelNames: ["method", "route", "status_code"],
});
register.registerMetric(httpRequestCount);

const httpRequestDuration = new promClient.Histogram({
  name: "http_request_duration_seconds",
  help: "HTTP request durations in seconds",
  labelNames: ["method", "route", "status_code"],
  buckets: [0.1, 0.5, 1, 2, 5],
});
register.registerMetric(httpRequestDuration);

function metricsMiddleware(req, res, next) {
  const end = httpRequestDuration.startTimer();
  res.on("finish", () => {
    httpRequestCount.labels(req.method, req.route?.path || req.path, res.statusCode).inc();
    end({
      method: req.method,
      route: req.route?.path || req.path,
      status_code: res.statusCode,
    });
  });
  next();
}

function metricsEndpoint(req, res) {
  res.set("Content-Type", register.contentType);
  register.metrics().then((metrics) => res.end(metrics));
}

module.exports = { metricsMiddleware, metricsEndpoint };
