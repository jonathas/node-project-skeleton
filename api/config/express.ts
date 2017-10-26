const dotenv = require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const expressValidator = require("express-validator");
const db = require("./db");

export = () => {
    let app = express();

    app.use(bodyParser.json());
    app.use(expressValidator());

    // so we can get the client's IP address
    app.enable("trust proxy");

    require("../routes")(app);

    return app;
};
