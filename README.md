# Marten Framework Website

[![CI](https://github.com/martenframework/website/workflows/Specs/badge.svg)](https://github.com/martenframework/website/actions) [![CI](https://github.com/martenframework/website/workflows/QA/badge.svg)](https://github.com/martenframework/website/actions)

This repository contains the Marten Framework website project.

## System requirements

* [Crystal](https://crystal-lang.org/) 1.13+
* [Node.js](https://nodejs.org/en/) - 18.x

## Installation

If all the above system dependencies are properly installed on the target system, it should be possible to install the project using the following command:

```shell
$ make
```

This command will take care of the installation of the required the dependencies and will build the development assets.

## Running the development server

The development server can be started using the following command:

```shell
$ make server
```

The development server should be accessible at http://127.0.0.1:8000.

## Running the test suite

The test suite can be run using the following command:

```shell
$ make tests
```

Code quality checks can be triggered using the following command:

```shell
$ make qa
```

## License

MIT. See `LICENSE` for more details.
