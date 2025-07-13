function factorial(n) {
  if (n < 0) throw new Error("Negative not allowed");
  return n <= 1 ? 1 : n * factorial(n - 1);
}
module.exports = factorial;
