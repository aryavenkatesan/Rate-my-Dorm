const express = require("express");
const errorHandler = require("./middleware/errorHandler");
const connectDb = require("./config/dbConnection")
const dotenv = require("dotenv").config();
const cors = require('cors');

//to enable https
const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('key.pem'),
  cert: fs.readFileSync('cert.pem')
};


connectDb();


const app = express();

const port = process.env.PORT || 5002;

app.use(express.json());
//app.use(express.urlencoded({ encoded: true }));
app.use (
    cors({
        origin: "*",
        credentials: true
    })
)
app.use("/api/users", require("./routes/userRoutes"));
app.use("/api/listing", require("./routes/listingRoutes"))
app.use(errorHandler);

https.createServer(options, app).listen(port, () => {
    console.log(`HTTPS Server running on port ${port}`);
});
