# Historian (Previously Ghost)
[![Build Status](https://github.com/fremantle-industries/historian/workflows/test/badge.svg?branch=main)](https://github.com/fremantle-industries/historian/actions?query=workflow%3Atest)

[`historian.localhost:4000`](http://historian.localhost:4000)

## Install

```bash
$ git clone git@github.com:fremantle-industries/historian.git
$ cd historian
$ docker-compose up db
$ mix setup
```

## Development

```bash
$ docker-compose up db
$ mix phx.server
```

## Test

```bash
$ docker-compose up db
$ mix test
```

## Ecto Database

Reset drops the db, creates a new db & runs the migrations

```bash
$ mix ecto.reset
```

Migrate up

```bash
$ mix ecto.migrate
```

Migrate down

```bash
# Last migration
$ mix ecto.rollback
# Last 3 migrations
$ mix ecto.rollback -n 3
```
