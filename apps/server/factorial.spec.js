const factorial = require("./factorial");

test("factorial of 0 and 1 is 1", () => {
  expect(factorial(0)).toBe(1);
  expect(factorial(1)).toBe(1);
});

test("factorial of 5 is 120", () => {
  expect(factorial(5)).toBe(120);
});

test("factorial negative throws", () => {
  expect(() => factorial(-1)).toThrow("Negative not allowed");
});
