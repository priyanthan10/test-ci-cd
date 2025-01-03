const express = require('express');
const app = express();
const port = 3000;

// Serve static files from the "public" directory
app.use(express.static('public'));

// Define a route
app.get('/', (req, res) => {
    res.send('<h1>Welcome to My Simple Web App</h1><p>Node.js + Express is awesome!</p>');
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});
