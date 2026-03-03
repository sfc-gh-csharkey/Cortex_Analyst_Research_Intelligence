-- Trading Analytics Semantic View
-- Deploy to FSI_DEMO_DB.CAPITAL_MARKETS
-- 
-- This SQL creates a semantic view for operational trading analytics
-- covering SECURITIES, TRADES, and MARKET_DATA tables.
--
-- Features:
--   - 3 tables with relationships
--   - 1 filter (active_securities)
--   - 3 verified queries
--   - 8 metrics across tables
--
-- Usage: Run this SQL in Snowflake to create the semantic view

CALL SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML(
  'FSI_DEMO_DB.CAPITAL_MARKETS',
  $$name: trading_analytics
description: Trading Analytics semantic view for operational queries on securities trading activity, market data, and trade performance analysis.

tables:
  - name: securities
    description: Master table of securities with identifiers, classification, and reference data.
    base_table:
      database: FSI_DEMO_DB
      schema: CAPITAL_MARKETS
      table: SECURITIES
    primary_key:
      columns:
        - SECURITY_ID
    dimensions:
      - name: security_id
        synonyms:
          - security identifier
          - sec id
        description: Unique identifier for the security
        expr: SECURITY_ID
        data_type: TEXT
      - name: ticker
        synonyms:
          - stock symbol
          - trading symbol
        description: Trading ticker symbol for the security
        expr: TICKER
        data_type: TEXT
        sample_values:
          - AAPL
          - MSFT
          - GOOGL
      - name: cusip
        description: CUSIP identifier for the security
        expr: CUSIP
        data_type: TEXT
      - name: isin
        description: ISIN identifier for the security
        expr: ISIN
        data_type: TEXT
      - name: security_name
        synonyms:
          - name
          - company name
        description: Full name of the security
        expr: SECURITY_NAME
        data_type: TEXT
      - name: security_type
        synonyms:
          - type
          - instrument type
        description: Type of security (e.g., Common Stock, Bond, ETF)
        expr: SECURITY_TYPE
        data_type: TEXT
        sample_values:
          - Common Stock
          - Bond
          - ETF
      - name: asset_class
        synonyms:
          - class
        description: Asset class classification
        expr: ASSET_CLASS
        data_type: TEXT
        sample_values:
          - Equity
          - Fixed Income
      - name: exchange
        synonyms:
          - trading exchange
          - market
        description: Exchange where the security is traded
        expr: EXCHANGE
        data_type: TEXT
        sample_values:
          - NYSE
          - NASDAQ
      - name: sector
        synonyms:
          - industry sector
        description: Business sector classification
        expr: SECTOR
        data_type: TEXT
        sample_values:
          - Technology
          - Healthcare
          - Financial Services
      - name: industry
        description: Specific industry within the sector
        expr: INDUSTRY
        data_type: TEXT
      - name: country
        description: Country of the issuer
        expr: COUNTRY
        data_type: TEXT
      - name: currency
        synonyms:
          - trading currency
        description: Currency for trading
        expr: CURRENCY
        data_type: TEXT
        sample_values:
          - USD
          - EUR
      - name: is_active
        synonyms:
          - active
          - status
        description: Whether the security is currently active
        expr: IS_ACTIVE
        data_type: BOOLEAN
    time_dimensions:
      - name: issue_date
        synonyms:
          - issuance date
        description: Date when the security was issued
        expr: ISSUE_DATE
        data_type: DATE
      - name: maturity_date
        description: Maturity date for fixed income securities
        expr: MATURITY_DATE
        data_type: DATE
    facts:
      - name: coupon_rate
        description: Coupon rate for fixed income securities
        expr: COUPON_RATE
        data_type: NUMBER
      - name: par_value
        description: Par/face value of the security
        expr: PAR_VALUE
        data_type: NUMBER
    filters:
      - name: active_securities
        synonyms:
          - active only
          - currently active
        description: Filter to show only active securities
        expr: IS_ACTIVE = TRUE

  - name: trades
    description: Trade transactions with execution details, pricing, and costs.
    base_table:
      database: FSI_DEMO_DB
      schema: CAPITAL_MARKETS
      table: TRADES
    primary_key:
      columns:
        - TRADE_ID
    dimensions:
      - name: trade_id
        synonyms:
          - transaction id
        description: Unique identifier for the trade
        expr: TRADE_ID
        data_type: TEXT
      - name: security_id
        description: Foreign key to securities table
        expr: SECURITY_ID
        data_type: TEXT
      - name: account_id
        synonyms:
          - client account
          - portfolio
        description: Account that executed the trade
        expr: ACCOUNT_ID
        data_type: TEXT
      - name: trade_type
        synonyms:
          - transaction type
          - buy sell
        description: Type of trade (BUY or SELL)
        expr: TRADE_TYPE
        data_type: TEXT
        sample_values:
          - BUY
          - SELL
      - name: order_type
        description: Order execution type
        expr: ORDER_TYPE
        data_type: TEXT
        sample_values:
          - MARKET
          - LIMIT
          - STOP
      - name: counterparty
        synonyms:
          - trading partner
        description: Counterparty to the trade
        expr: COUNTERPARTY
        data_type: TEXT
      - name: broker
        synonyms:
          - executing broker
        description: Broker that executed the trade
        expr: BROKER
        data_type: TEXT
      - name: execution_venue
        synonyms:
          - venue
          - trading venue
        description: Venue where trade was executed
        expr: EXECUTION_VENUE
        data_type: TEXT
      - name: is_algorithm_trade
        synonyms:
          - algo trade
          - algorithmic
        description: Whether trade was executed algorithmically
        expr: IS_ALGORITHM_TRADE
        data_type: BOOLEAN
      - name: anomaly_flag
        synonyms:
          - flagged
          - suspicious
        description: Whether trade has been flagged for anomaly
        expr: ANOMALY_FLAG
        data_type: BOOLEAN
    time_dimensions:
      - name: trade_date
        synonyms:
          - execution date
          - transaction date
        description: Date and time when the trade was executed
        expr: TRADE_DATE
        data_type: TIMESTAMP
      - name: settlement_date
        description: Date when the trade settles
        expr: SETTLEMENT_DATE
        data_type: DATE
    facts:
      - name: quantity
        synonyms:
          - shares
          - units
          - volume
        description: Number of units traded
        expr: QUANTITY
        data_type: NUMBER
      - name: price
        synonyms:
          - execution price
          - trade price
        description: Price per unit at execution
        expr: PRICE
        data_type: NUMBER
      - name: gross_amount
        synonyms:
          - gross value
        description: Total value before fees (quantity * price)
        expr: GROSS_AMOUNT
        data_type: NUMBER
      - name: commission
        synonyms:
          - trading commission
        description: Commission charged for the trade
        expr: COMMISSION
        data_type: NUMBER
      - name: fees
        synonyms:
          - transaction fees
        description: Additional fees for the trade
        expr: FEES
        data_type: NUMBER
      - name: net_amount
        synonyms:
          - net value
          - total cost
        description: Total value after fees and commission
        expr: NET_AMOUNT
        data_type: NUMBER
    metrics:
      - name: total_trades
        synonyms:
          - trade count
          - number of trades
        description: Total number of trades
        expr: COUNT(DISTINCT TRADE_ID)
      - name: total_volume
        synonyms:
          - total quantity
          - shares traded
        description: Total quantity/volume traded
        expr: SUM(QUANTITY)
      - name: total_net_amount
        synonyms:
          - total value
          - trading value
        description: Total net amount of all trades
        expr: SUM(NET_AMOUNT)
      - name: total_commission
        synonyms:
          - commission paid
        description: Total commission paid
        expr: SUM(COMMISSION)
      - name: average_trade_size
        synonyms:
          - avg trade size
        description: Average quantity per trade
        expr: AVG(QUANTITY)

  - name: market_data
    description: Daily market data with OHLC prices, volume, and market indicators.
    base_table:
      database: FSI_DEMO_DB
      schema: CAPITAL_MARKETS
      table: MARKET_DATA
    primary_key:
      columns:
        - MARKET_DATA_ID
    dimensions:
      - name: market_data_id
        description: Unique identifier for the market data record
        expr: MARKET_DATA_ID
        data_type: TEXT
      - name: security_id
        description: Foreign key to securities table
        expr: SECURITY_ID
        data_type: TEXT
    time_dimensions:
      - name: trade_date
        synonyms:
          - market date
          - price date
        description: Date of the market data
        expr: TRADE_DATE
        data_type: DATE
    facts:
      - name: open_price
        synonyms:
          - opening price
          - open
        description: Opening price for the day
        expr: OPEN_PRICE
        data_type: NUMBER
      - name: high_price
        synonyms:
          - daily high
          - high
        description: Highest price during the day
        expr: HIGH_PRICE
        data_type: NUMBER
      - name: low_price
        synonyms:
          - daily low
          - low
        description: Lowest price during the day
        expr: LOW_PRICE
        data_type: NUMBER
      - name: close_price
        synonyms:
          - closing price
          - close
        description: Closing price for the day
        expr: CLOSE_PRICE
        data_type: NUMBER
      - name: adjusted_close
        synonyms:
          - adj close
        description: Adjusted closing price accounting for splits/dividends
        expr: ADJUSTED_CLOSE
        data_type: NUMBER
      - name: volume
        synonyms:
          - trading volume
          - daily volume
        description: Number of shares traded
        expr: VOLUME
        data_type: NUMBER
      - name: vwap
        synonyms:
          - volume weighted average price
        description: Volume-weighted average price
        expr: VWAP
        data_type: NUMBER
      - name: bid_price
        synonyms:
          - bid
        description: Best bid price
        expr: BID_PRICE
        data_type: NUMBER
      - name: ask_price
        synonyms:
          - ask
          - offer
        description: Best ask price
        expr: ASK_PRICE
        data_type: NUMBER
      - name: dividend
        synonyms:
          - div
        description: Dividend amount
        expr: DIVIDEND
        data_type: NUMBER
      - name: split_factor
        description: Stock split factor
        expr: SPLIT_FACTOR
        data_type: NUMBER
    metrics:
      - name: average_close_price
        synonyms:
          - avg close
        description: Average closing price
        expr: AVG(CLOSE_PRICE)
      - name: total_market_volume
        synonyms:
          - total volume
        description: Total market volume
        expr: SUM(VOLUME)
      - name: price_range
        synonyms:
          - daily range
        description: Difference between high and low price
        expr: AVG(HIGH_PRICE - LOW_PRICE)

relationships:
  - name: trades_to_securities
    left_table: trades
    right_table: securities
    join_type: left_outer
    relationship_type: many_to_one
    relationship_columns:
      - left_column: SECURITY_ID
        right_column: SECURITY_ID
  - name: market_data_to_securities
    left_table: market_data
    right_table: securities
    join_type: left_outer
    relationship_type: many_to_one
    relationship_columns:
      - left_column: SECURITY_ID
        right_column: SECURITY_ID

verified_queries:
  - name: trading_volume_by_sector
    question: What is the total trading volume and net amount by sector?
    verified_at: 1740506793
    verified_by: cortex_code
    sql: |
      SELECT
        s.SECTOR,
        SUM(t.QUANTITY) AS total_quantity,
        SUM(t.NET_AMOUNT) AS total_net_amount,
        COUNT(DISTINCT t.TRADE_ID) AS trade_count
      FROM FSI_DEMO_DB.CAPITAL_MARKETS.TRADES t
      JOIN FSI_DEMO_DB.CAPITAL_MARKETS.SECURITIES s
        ON t.SECURITY_ID = s.SECURITY_ID
      GROUP BY s.SECTOR
      ORDER BY total_net_amount DESC
  - name: daily_trade_activity
    question: What is the daily trade activity summary by trade type?
    verified_at: 1740506793
    verified_by: cortex_code
    sql: |
      SELECT
        DATE_TRUNC('DAY', t.TRADE_DATE) AS trade_day,
        t.TRADE_TYPE,
        COUNT(DISTINCT t.TRADE_ID) AS trade_count,
        SUM(t.QUANTITY) AS total_quantity,
        SUM(t.NET_AMOUNT) AS total_net_amount,
        SUM(t.COMMISSION) AS total_commission
      FROM FSI_DEMO_DB.CAPITAL_MARKETS.TRADES t
      GROUP BY trade_day, t.TRADE_TYPE
      ORDER BY trade_day DESC
  - name: top_traded_securities
    question: What are the top 10 most traded securities by net amount?
    verified_at: 1740506793
    verified_by: cortex_code
    sql: |
      SELECT
        s.TICKER,
        s.SECURITY_NAME,
        s.SECTOR,
        COUNT(DISTINCT t.TRADE_ID) AS trade_count,
        SUM(t.QUANTITY) AS total_quantity,
        SUM(t.NET_AMOUNT) AS total_net_amount
      FROM FSI_DEMO_DB.CAPITAL_MARKETS.TRADES t
      JOIN FSI_DEMO_DB.CAPITAL_MARKETS.SECURITIES s
        ON t.SECURITY_ID = s.SECURITY_ID
      GROUP BY s.TICKER, s.SECURITY_NAME, s.SECTOR
      ORDER BY total_net_amount DESC
      LIMIT 10
$$,
  FALSE  -- Set to TRUE for verify-only mode (no actual creation)
);
