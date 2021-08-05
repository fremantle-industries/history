# History
[![Build Status](https://github.com/fremantle-industries/history/workflows/test/badge.svg?branch=main)](https://github.com/fremantle-industries/history/actions?query=workflow%3Atest)
[![hex.pm version](https://img.shields.io/hexpm/v/history.svg?style=flat)](https://hex.pm/packages/history)

Download and warehouse historical trading data

## Install

Add `history` to your list of dependencies in `mix.exs`

```elixir
def deps do
  [
    {:history, "~> 0.0.1"}
  ]
end
```

## Usage

```bash
$ docker-compose up
```

Visit [`history.localhost:4000`](http://history.localhost:4000)

## Features

### Import Products From Tai

![import-tai-products](./docs/import-tai-products.png)

### Download Historical Venue Data

![predicted-funding-rate-download](./docs/predicted-funding-rate-download.png)

### Visualize & Explore Data for Market Insights

![swap-funding-rates](./docs/swap-funding-rates.png)

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
