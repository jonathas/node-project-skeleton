import * as pino from "pino";
const log = pino();
const app = require("./config/express")();

const port = process.env.PORT || 3000;

const server = app.listen(port, () => {
    log.info(`Skel server listening on port ${port}. Environment: ${process.env.NODE_ENV}`);
});
