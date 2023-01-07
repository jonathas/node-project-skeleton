# Node Project Skeleton

## Disclaimer (January of 2023)

I've implemented this example in 2017, when API development was very different from today.
Now in the beginning of 2023 I thought about updating it but then decided to keep it as it is for historical reasons and because there are just way too many things I'd change, so it would be better to start a similar project from scratch.

Let me list below what I would do different if this was done today:

- Use swagger (documentation in a json file) instead of apidoc
- Follow [conventional commits](https://www.conventionalcommits.org/en/v1.0.0-beta.2/#summary) for writing the commit messages
- Versioning done with the help of [release-it](https://www.npmjs.com/package/release-it)
- Drop gulp and use only typescript instead.
- jest instead of mocha for the tests
- jest instead of istanbul for code coverage
- fastify instead of express
- eslint instead of tslint
- Enforce proper rules with eslint. [Example here](https://gist.github.com/jonathas/c6b5f110e1eaf92d94ac976a19a3a178)
- nodemon is not needed anymore
- bluebird is not needed anymore

Truth be told, nowadays I'd recommend to start an API in Node.js using [Nest](https://nestjs.com/), which already gives you a well implemented architecture to start your project with. So I might be creating a similar project soon, but using Nest instead, and then we can compare the differences.

## Intro

This project contains the skeleton I usually have in my Node projects.

What is used here: Express, Mocha, Istanbul, apiDoc, gulp, TypeScript, MongoDB, Redis, pm2, Docker, Nginx, SSL, etc.

## Initial dependencies

- [yarn](https://yarnpkg.com/)
- [nvm](https://github.com/creationix/nvm)
- [docker](https://www.docker.com)
- [docker-compose](https://docs.docker.com/compose/install/)

## Setting up

Inside the infra directory, there are 3 ways of running the infrastructure for the project:

- standalone, which is for when you want to deploy all the containers in the same server.
- server-ssl, which is when you want to deploy to servers behind a load balancer, but this load balancer doesn't accept ssl termination.
- server, which is when you want to deploy to servers behind a load balancer and this load balancer accepts ssl termination, so the servers receive unencrypted requests from it.

Of course, you can always deploy to a PaaS instead, if you don't want to run the infrastructure by yourself.

If you want to run the project using the standalone or the server-ssl mode, you will need to have your SSL certificate and its private key inside infra/common/ssl. You can generate a self-singned one by following the tutorial inside the infra/common/ssl/test directory.

You also need to generate a dhparam.pem file, which can be done by running the gen_dhparam.sh script inside infra/common/ssl. This will take a while to run.

Inside api/process.yml you can configure how many instances pm2 will start.

Then you can install the packages inside the api directory:

```bash
$ yarn install
```

and generate the necessary files before starting the server:

```bash
$ ./node_modules/.bin/gulp
```

## Running

If you choose to run the infra from server-ssl, you will have to start the database containers as well, as server-ssl is not standalone.

If you choose to run the infra inside the standalone directory, then it contains also the container for the database and cache.

The way you can run any of these infrastructures is by pointing docker-compose to the chosen yml file inside the infra directory:

```bash
$ docker-compose -f <your file here> up
```

Then you can use a service file like the one inside infra/standalone/host for configuring the infra to start on boot, in case the server restarts.

Just change the path inside of it so it points to the right directory, then copy it to /etc/systemd/system, reload and enable the daemon:

```bash
$ sudo systemctl daemon-reload
$ sudo systemctl enable docker-infra
```

## Developing

If you want to run the project for development, the standalone infra is the best way to do it, with the docker-dev.yml file, as it is configured to reload pm2 on every code change:

```bash
$ cd infra/standalone
$ docker-compose -f docker-dev.yml up
```

Ps: Generate the SSL certificate before doing that.
