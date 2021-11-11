defmodule History.MixProject do
  use Mix.Project

  def project do
    [
      app: :history,
      version: "0.0.22",
      elixir: "~> 1.12",
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      description: description(),
      aliases: aliases(),
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix]
      ]
    ]
  end

  def application do
    [
      mod: {History.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:broadway, "~> 1.0"},
      {:confex, "~> 3.5"},
      {:ecto_enum, "~> 1.4"},
      {:ecto_sql, "~> 3.4"},
      {:enumerati, "~> 0.0.8"},
      {:etso, "~> 0.1.5"},
      {:ex_ftx, "~> 0.0.9"},
      {:gettext, "~> 0.11"},
      {:indifferent, "~> 0.9"},
      {:jason, "~> 1.0"},
      {:master_proxy, "~> 0.1"},
      {:notified_phoenix, "~> 0.0.6"},
      {:navigator, "~> 0.0.5"},
      {:paged_query, "~> 0.0.2"},
      {:phoenix, "~> 1.5.12"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_dashboard, "~> 0.4.0"},
      {:phoenix_live_view, "~> 0.15.7"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:redirect, "~> 0.3"},
      {:stylish, "~> 0.0.6"},
      # {:tai, github: "fremantle-industries/tai", sparse: "apps/tai", branch: "main", override: true},
      {:tai, "~> 0.0.71"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_metrics_prometheus, "~> 1.0"},
      {:telemetry_poller, "~> 0.4"},
      {:timex, "~> 3.7"},
      # {:workbench, github: "fremantle-industries/workbench", branch: "main"},
      {:workbench, "~> 0.0.15"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:floki, ">= 0.0.0", only: :test},
      {:mock, "~> 0.3", only: :test},
      {:wallaby, "~> 0.29.0", runtime: false, only: :test},
      {:logger_file_backend, "~> 0.0.1", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      setup: ["setup.deps", "setup.gen.migration", "ecto.setup"],
      "setup.deps": ["deps.get", "cmd npm install --prefix assets"],
      "setup.gen.migration": ["tai.gen.migration", "workbench.gen.migration", "history.gen.migration"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "history.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp description do
    "Download and warehouse historical trading data"
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Alex Kwiatkowski"],
      links: %{"GitHub" => "https://github.com/fremantle-industries/history"}
    }
  end
end
