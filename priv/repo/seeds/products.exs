require Ecto.Query

alias Ghost.Products.Product
alias Ghost.Repo

[
  %Product{venue: "ftx", symbol: "1inch/usd", base: "1inch", quote: "usd", venue_symbol: "1INCH/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "1inch-perp", base: "1inch", quote: "usd", venue_symbol: "1INCH-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "aave/usd", base: "aave", quote: "usd", venue_symbol: "AAVE/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "aave/usdt", base: "aave", quote: "usdt", venue_symbol: "AAVE/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "aave-perp", base: "aave", quote: "usd", venue_symbol: "AAVE-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "alcx/usd", base: "alcx", quote: "usd", venue_symbol: "ALCX/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "alcx-perp", base: "alcx", quote: "usd", venue_symbol: "ALCX-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "alpha/usd", base: "alpha", quote: "usd", venue_symbol: "ALPHA/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "alpha-perp", base: "alpha", quote: "usd", venue_symbol: "ALPHA-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "audio/usd", base: "audio", quote: "usd", venue_symbol: "AUDIO/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "audio/usdt", base: "audio", quote: "usdt", venue_symbol: "AUDIO/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "audio-perp", base: "audio", quote: "usd", venue_symbol: "AUDIO-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "axs/usd", base: "axs", quote: "usd", venue_symbol: "AXS/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "axs-perp", base: "axs", quote: "usd", venue_symbol: "AXS-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "badger/usd", base: "badger", quote: "usd", venue_symbol: "BADGER/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "badger-perp", base: "badger", quote: "usd", venue_symbol: "BADGER-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "bal/usd", base: "bal", quote: "usd", venue_symbol: "BAL/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "bal/usdt", base: "bal", quote: "usdt", venue_symbol: "BAL/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "bal-perp", base: "bal", quote: "usd", venue_symbol: "BAL-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "band/usd", base: "band", quote: "usd", venue_symbol: "BAND/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "band-perp", base: "band", quote: "usd", venue_symbol: "BAND-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "bao/usd", base: "bao", quote: "usd", venue_symbol: "BAO/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "bao-perp", base: "bao", quote: "usd", venue_symbol: "BAO-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "bat/usd", base: "bat", quote: "usd", venue_symbol: "BAT/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "bat-perp", base: "bat", quote: "usd", venue_symbol: "BAT-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "bch/usd", base: "bch", quote: "usd", venue_symbol: "BCH/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "bch/usdt", base: "bch", quote: "usdt", venue_symbol: "BCH/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "bch-perp", base: "bch", quote: "usd", venue_symbol: "BCH-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "bnb/usd", base: "bnb", quote: "usd", venue_symbol: "BNB/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "bnb/usdt", base: "bnb", quote: "usdt", venue_symbol: "BNB/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "bnb-perp", base: "bnb", quote: "usd", venue_symbol: "BNB-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "bnt/usd", base: "bnt", quote: "usd", venue_symbol: "BNT/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "bnt-perp", base: "bnt", quote: "usd", venue_symbol: "BNT-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "brz/usd", base: "brz", quote: "usd", venue_symbol: "BRZ/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "brz/usdt", base: "brz", quote: "usdt", venue_symbol: "BRZ/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "brz-perp", base: "brz", quote: "usd", venue_symbol: "BRZ-PERP", type: "swap"},

  %Product{venue: "binance", symbol: "btc-usdt", base: "btc", quote: "usdt", venue_symbol: "BTC-USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "btc/usd", base: "btc", quote: "usd", venue_symbol: "BTC/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "btc/usdt", base: "btc", quote: "usdt", venue_symbol: "BTC/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "btc-perp", base: "btc", quote: "usd", venue_symbol: "BTC-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "btmx/usd", base: "btmx", quote: "usd", venue_symbol: "BTMX/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "btmx-perp", base: "btmx", quote: "usd", venue_symbol: "BTMX-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "chz/usd", base: "chz", quote: "usd", venue_symbol: "CHZ/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "chz/usdt", base: "chz", quote: "usdt", venue_symbol: "CHZ/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "chz-perp", base: "chz", quote: "usd", venue_symbol: "CHZ-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "comp/usd", base: "comp", quote: "usd", venue_symbol: "COMP/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "comp/usdt", base: "comp", quote: "usdt", venue_symbol: "COMP/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "comp-perp", base: "comp", quote: "usd", venue_symbol: "COMP-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "conv/usd", base: "conv", quote: "usd", venue_symbol: "CONV/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "conv-perp", base: "conv", quote: "usd", venue_symbol: "CONV-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "cream/usd", base: "cream", quote: "usd", venue_symbol: "CREAM/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "cream/usdt", base: "cream", quote: "usdt", venue_symbol: "CREAM/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "cream-perp", base: "cream", quote: "usd", venue_symbol: "CREAM-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "cro/usd", base: "cro", quote: "usd", venue_symbol: "CRO/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "cro-perp", base: "cro", quote: "usd", venue_symbol: "CRO-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "crv/usd", base: "crv", quote: "usd", venue_symbol: "CRV/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "crv-perp", base: "crv", quote: "usd", venue_symbol: "CRV-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "dawn/usd", base: "dawn", quote: "usd", venue_symbol: "DAWN/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "dawn-perp", base: "dawn", quote: "usd", venue_symbol: "DAWN-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "dent/usd", base: "dent", quote: "usd", venue_symbol: "DENT/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "dent-perp", base: "dent", quote: "usd", venue_symbol: "DENT-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "dodo/usd", base: "dodo", quote: "usd", venue_symbol: "DODO/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "dodo-perp", base: "dodo", quote: "usd", venue_symbol: "DODO-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "doge/usd", base: "doge", quote: "usd", venue_symbol: "DOGE/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "doge/usdt", base: "doge", quote: "usdt", venue_symbol: "DOGE/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "doge-perp", base: "doge", quote: "usd", venue_symbol: "DOGE-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "enj/usd", base: "enj", quote: "usd", venue_symbol: "ENJ/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "enj-perp", base: "enj", quote: "usd", venue_symbol: "ENJ-PERP", type: "swap"},

  %Product{venue: "binance", symbol: "eth-usdt", base: "eth", quote: "usdt", venue_symbol: "ETH-USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "eth/usd", base: "eth", quote: "usd", venue_symbol: "ETH/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "eth/usdt", base: "eth", quote: "usdt", venue_symbol: "ETH/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "eth-perp", base: "eth", quote: "usd", venue_symbol: "ETH-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "fida/usd", base: "fida", quote: "usd", venue_symbol: "FIDA/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "fida/usdt", base: "fida", quote: "usdt", venue_symbol: "FIDA/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "fida-perp", base: "fida", quote: "usd", venue_symbol: "FIDA-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "ftm/usd", base: "ftm", quote: "usd", venue_symbol: "FTM/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "ftm-perp", base: "ftm", quote: "usd", venue_symbol: "FTM-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "ftt/usd", base: "ftt", quote: "usd", venue_symbol: "FTT/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "ftt/usdt", base: "ftt", quote: "usdt", venue_symbol: "FTT/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "ftt-perp", base: "ftt", quote: "usd", venue_symbol: "FTT-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "grt/usd", base: "grt", quote: "usd", venue_symbol: "GRT/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "grt-perp", base: "grt", quote: "usd", venue_symbol: "GRT-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "hnt/usd", base: "hnt", quote: "usd", venue_symbol: "HNT/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "hnt/usdt", base: "hnt", quote: "usdt", venue_symbol: "HNT/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "hnt-perp", base: "hnt", quote: "usd", venue_symbol: "HNT-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "holy/usd", base: "holy", quote: "usd", venue_symbol: "HOLY/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "holy-perp", base: "holy", quote: "usd", venue_symbol: "HOLY-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "ht/usd", base: "ht", quote: "usd", venue_symbol: "HT/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "ht-perp", base: "ht", quote: "usd", venue_symbol: "HT-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "hum/usd", base: "hum", quote: "usd", venue_symbol: "HUM/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "hum-perp", base: "hum", quote: "usd", venue_symbol: "HUM-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "kin/usd", base: "kin", quote: "usd", venue_symbol: "KIN/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "kin-perp", base: "kin", quote: "usd", venue_symbol: "KIN-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "knc/usd", base: "knc", quote: "usd", venue_symbol: "KNC/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "knc/usdt", base: "knc", quote: "usdt", venue_symbol: "KNC/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "knc-perp", base: "knc", quote: "usd", venue_symbol: "KNC-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "leo/usd", base: "leo", quote: "usd", venue_symbol: "LEO/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "leo-perp", base: "leo", quote: "usd", venue_symbol: "LEO-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "lina/usd", base: "lina", quote: "usd", venue_symbol: "LINA/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "lina-perp", base: "lina", quote: "usd", venue_symbol: "LINA-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "link/usd", base: "link", quote: "usd", venue_symbol: "LINK/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "link/usdt", base: "link", quote: "usdt", venue_symbol: "LINK/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "link-perp", base: "link", quote: "usd", venue_symbol: "LINK-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "lrc/usd", base: "lrc", quote: "usd", venue_symbol: "LRC/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "lrc-perp", base: "lrc", quote: "usd", venue_symbol: "LRC-PERP", type: "swap"},

  %Product{venue: "binance", symbol: "ltc-usdt", base: "ltc", quote: "usdt", venue_symbol: "LTC-USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "ltc/usd", base: "ltc", quote: "usd", venue_symbol: "LTC/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "ltc/usdt", base: "ltc", quote: "usdt", venue_symbol: "LTC/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "ltc-perp", base: "ltc", quote: "usd", venue_symbol: "LTC-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "maps/usd", base: "maps", quote: "usd", venue_symbol: "MAPS/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "maps/usdt", base: "maps", quote: "usdt", venue_symbol: "MAPS/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "maps-perp", base: "maps", quote: "usd", venue_symbol: "MAPS-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "matic/usd", base: "matic", quote: "usd", venue_symbol: "MATIC/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "matic-perp", base: "matic", quote: "usd", venue_symbol: "MATIC-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "mkr/usd", base: "mkr", quote: "usd", venue_symbol: "MKR/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "mkr/usdt", base: "mkr", quote: "usdt", venue_symbol: "MKR/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "mkr-perp", base: "mkr", quote: "usd", venue_symbol: "MKR-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "mta/usd", base: "mta", quote: "usd", venue_symbol: "MTA/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "mta/usdt", base: "mta", quote: "usdt", venue_symbol: "MTA/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "mta-perp", base: "mta", quote: "usd", venue_symbol: "MTA-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "mtl/usd", base: "mtl", quote: "usd", venue_symbol: "MTL/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "mtl-perp", base: "mtl", quote: "usd", venue_symbol: "MTL-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "okb/usd", base: "okb", quote: "usd", venue_symbol: "OKB/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "okb-perp", base: "okb", quote: "usd", venue_symbol: "OKB-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "omg/usd", base: "omg", quote: "usd", venue_symbol: "OMG/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "omg-perp", base: "omg", quote: "usd", venue_symbol: "OMG-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "orbs/usd", base: "orbs", quote: "usd", venue_symbol: "ORBS/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "orbs-perp", base: "orbs", quote: "usd", venue_symbol: "ORBS-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "oxy/usd", base: "oxy", quote: "usd", venue_symbol: "OXY/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "oxy/usdt", base: "oxy", quote: "usdt", venue_symbol: "OXY/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "oxy-perp", base: "oxy", quote: "usd", venue_symbol: "OXY-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "paxg/usd", base: "paxg", quote: "usd", venue_symbol: "PAXG/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "paxg/usdt", base: "paxg", quote: "usdt", venue_symbol: "PAXG/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "paxg-perp", base: "paxg", quote: "usd", venue_symbol: "PAXG-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "penn/usd", base: "penn", quote: "usd", venue_symbol: "PENN/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "penn-perp", base: "penn", quote: "usd", venue_symbol: "PENN-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "pundix/usd", base: "pundix", quote: "usd", venue_symbol: "PUNDIX/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "pundix-perp", base: "pundix", quote: "usd", venue_symbol: "PUNDIX-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "ray/usd", base: "ray", quote: "usd", venue_symbol: "RAY/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "ray-perp", base: "ray", quote: "usd", venue_symbol: "RAY-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "reef/usd", base: "reef", quote: "usd", venue_symbol: "REEF/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "reef-perp", base: "reef", quote: "usd", venue_symbol: "REEF-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "ren/usd", base: "ren", quote: "usd", venue_symbol: "REN/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "ren-perp", base: "ren", quote: "usd", venue_symbol: "REN-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "rook/usd", base: "rook", quote: "usd", venue_symbol: "ROOK/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "rook/usdt", base: "rook", quote: "usdt", venue_symbol: "ROOK/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "rook-perp", base: "rook", quote: "usd", venue_symbol: "ROOK-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "rsr/usd", base: "rsr", quote: "usd", venue_symbol: "RSR/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "rsr-perp", base: "rsr", quote: "usd", venue_symbol: "RSR-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "rune/usd", base: "rune", quote: "usd", venue_symbol: "RUNE/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "rune/usdt", base: "rune", quote: "usdt", venue_symbol: "RUNE/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "rune-perp", base: "rune", quote: "usd", venue_symbol: "RUNE-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "sand/usd", base: "sand", quote: "usd", venue_symbol: "SAND/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "sand-perp", base: "sand", quote: "usd", venue_symbol: "SAND-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "seco/usd", base: "seco", quote: "usd", venue_symbol: "SECO/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "seco-perp", base: "seco", quote: "usd", venue_symbol: "SECO-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "skl/usd", base: "skl", quote: "usd", venue_symbol: "SKL/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "skl-perp", base: "skl", quote: "usd", venue_symbol: "SKL-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "snx/usd", base: "snx", quote: "usd", venue_symbol: "SNX/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "snx-perp", base: "snx", quote: "usd", venue_symbol: "SNX-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "sol/usd", base: "sol", quote: "usd", venue_symbol: "SOL/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "sol/usdt", base: "sol", quote: "usdt", venue_symbol: "SOL/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "sol-perp", base: "sol", quote: "usd", venue_symbol: "SOL-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "srm/usd", base: "srm", quote: "usd", venue_symbol: "SRM/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "srm/usdt", base: "srm", quote: "usdt", venue_symbol: "SRM/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "srm-perp", base: "srm", quote: "usd", venue_symbol: "SRM-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "stmx/usd", base: "stmx", quote: "usd", venue_symbol: "STMX/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "stmx-perp", base: "stmx", quote: "usd", venue_symbol: "STMX-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "storj/usd", base: "storj", quote: "usd", venue_symbol: "STORJ/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "storj-perp", base: "storj", quote: "usd", venue_symbol: "STORJ-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "sushi/usd", base: "sushi", quote: "usd", venue_symbol: "SUSHI/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "sushi/usdt", base: "sushi", quote: "usdt", venue_symbol: "SUSHI/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "sushi-perp", base: "sushi", quote: "usd", venue_symbol: "SUSHI-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "sxp/usd", base: "sxp", quote: "usd", venue_symbol: "SXP/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "sxp/usdt", base: "sxp", quote: "usdt", venue_symbol: "SXP/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "sxp-perp", base: "sxp", quote: "usd", venue_symbol: "SXP-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "tomo/usd", base: "tomo", quote: "usd", venue_symbol: "TOMO/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "tomo/usdt", base: "tomo", quote: "usdt", venue_symbol: "TOMO/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "tomo-perp", base: "tomo", quote: "usd", venue_symbol: "TOMO-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "tru/usd", base: "tru", quote: "usd", venue_symbol: "TRU/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "tru/usdt", base: "tru", quote: "usdt", venue_symbol: "TRU/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "tru-perp", base: "tru", quote: "usd", venue_symbol: "TRU-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "trx/usd", base: "trx", quote: "usd", venue_symbol: "TRX/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "trx/usdt", base: "trx", quote: "usdt", venue_symbol: "TRX/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "trx-perp", base: "trx", quote: "usd", venue_symbol: "TRX-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "tryb/usd", base: "tryb", quote: "usd", venue_symbol: "TRYB/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "tryb-perp", base: "tryb", quote: "usd", venue_symbol: "TRYB-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "uni/usd", base: "uni", quote: "usd", venue_symbol: "UNI/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "uni/usdt", base: "uni", quote: "usdt", venue_symbol: "UNI/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "uni-perp", base: "uni", quote: "usd", venue_symbol: "UNI-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "usdt/usd", base: "usdt", quote: "usd", venue_symbol: "USDT/USD", type: "spot"},

  %Product{venue: "ftx", symbol: "waves/usd", base: "waves", quote: "usd", venue_symbol: "WAVES/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "waves-perp", base: "waves", quote: "usd", venue_symbol: "WAVES-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "xaut/usd", base: "xaut", quote: "usd", venue_symbol: "XAUT/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "xaut/usdt", base: "xaut", quote: "usdt", venue_symbol: "XAUT/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "xaut-perp", base: "xaut", quote: "usd", venue_symbol: "XAUT-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "xrp/usd", base: "xrp", quote: "usd", venue_symbol: "XRP/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "xrp/usdt", base: "xrp", quote: "usdt", venue_symbol: "XRP/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "xrp-perp", base: "xrp", quote: "usd", venue_symbol: "XRP-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "yfi/usd", base: "yfi", quote: "usd", venue_symbol: "YFI/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "yfi/usdt", base: "yfi", quote: "usdt", venue_symbol: "YFI/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "yfi-perp", base: "yfi", quote: "usd", venue_symbol: "YFI-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "yfii/usd", base: "yfii", quote: "usd", venue_symbol: "YFII/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "yfii-perp", base: "yfii", quote: "usd", venue_symbol: "YFII-PERP", type: "swap"},

  %Product{venue: "ftx", symbol: "zrx/usd", base: "zrx", quote: "usd", venue_symbol: "ZRX/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "zrx-perp", base: "zrx", quote: "usd", venue_symbol: "ZRX-PERP", type: "swap"},
]
|> Enum.map(fn product ->
  case Ghost.Repo.one(
         Ecto.Query.from(p in Product, where: p.venue == ^product.venue and p.symbol == ^product.symbol and p.type == ^product.type)
       ) do
    nil -> %Product{venue: product.venue, symbol: product.symbol, venue_symbol: product.venue_symbol, base: product.base, quote: product.quote, type: product.type}
    product -> product
  end
end)
|> Enum.map(&Product.changeset(&1, %{}))
|> Enum.each(&Repo.insert_or_update!/1)
