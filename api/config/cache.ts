import * as pino from "pino";
const log = pino();
import * as bluebird from "bluebird";
const redis = bluebird.Promise.promisifyAll(require("redis"));

const cacheAddress = process.env.CACHE_HOST || "127.0.0.1";
const cachePort = process.env.CACHE_PORT || 6379;

let cache = redis.createClient(cachePort, cacheAddress);

if (process.env.CACHE_AUTH === "true") {
    cache.auth(process.env.CACHE_PASS);
}

cache.on("error", (err) => {
    if (err.message.indexOf("ECONNREFUSED") !== -1) {
        log.error("Error: The server was not able to reach Redis. Maybe it's not running?");
        process.exit(1);
    } else {
        throw err;
    }
});

export const cleanKey = async (keyName: string): Promise<void> => {
    let rows = await cache.keysAsync(keyName);
    await delRows(rows);
};

export const cleanEnvKeys = async (): Promise<void> => {
    const env = (process.env.NODE_ENV) ? process.env.NODE_ENV : "test";
    let rows = await cache.keysAsync(env + "*");
    await delRows(rows);
};

const delRows = async (rows: Array<any>) => {
    for (let row of rows) {
        await cache.delAsync(row);
    }
};

export default cache;