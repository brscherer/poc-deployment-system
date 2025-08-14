const request = require("supertest");
const app = require("./app");

describe("API /factorial", () => {
  test("GET /factorial/5 returns factorial 120", async () => {
    const res = await request(app).get("/factorial/5");
    expect(res.statusCode).toBe(200);
    expect(res.body).toEqual({ n: 5, factorial: 120 });
  });

  test("GET /factorial/-1 returns error", async () => {
    const res = await request(app).get("/factorial/-1");
    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty("error");
  });

  test("GET /factorial/abc returns error", async () => {
    const res = await request(app).get("/factorial/abc");
    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty("error");
  });
});

describe("API /health", () => {
  test("GET /health returns OK", async () => {
    const res = await request(app).get("/health");
    expect(res.statusCode).toBe(200);
    expect(res.text).toBe("OK");
  });
});
