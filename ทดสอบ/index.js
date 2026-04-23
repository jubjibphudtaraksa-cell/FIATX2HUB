export default function handler(req, res) {
  const key = req.query.key;
  const SECRET_KEY = "Dhhsbwjaizhnwkwowjsj";

  // ❌ key ผิด → 404 เนียน
  if (!key || key !== SECRET_KEY) {
    res.status(404);
    res.setHeader("Content-Type", "text/html");
    return res.send(`
      <html>
        <head><title>404 Not Found</title></head>
        <body>
          <h1>404 Not Found</h1>
        </body>
      </html>
    `);
  }

  // ✅ key ถูก → ส่ง script
  const SCRIPT = `
    print("Loaded successfully")
  `;

  res.setHeader("Content-Type", "text/plain");
  res.send(SCRIPT);
}
