const express = require('express');
const app = express();

app.get('/health-check', (req, res) => res.status(200).send('OK'));

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Health check app running on port ${port}`));
