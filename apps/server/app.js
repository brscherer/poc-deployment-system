const express = require("express");
const factorial = require("./factorial");

const app = express();

app.get("/health-check", (req, res) => res.status(200).send("OK"));

app.get("/factorial/:n", (req, res) => {
  const n = parseInt(req.params.n, 10);
  if (isNaN(n)) {
    return res.status(400).json({ error: "Invalid number" });
  }
  try {
    const result = factorial(n);
    res.json({ n, factorial: result });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = app;
