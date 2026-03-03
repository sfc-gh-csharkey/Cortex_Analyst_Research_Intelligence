-- ============================================================================
-- RESEARCH INTELLIGENCE SEMANTIC VIEW
-- ============================================================================
-- Description: Research Intelligence semantic view for analysts tracking 
--              recommendations, target prices, and rating changes across 
--              securities in capital markets.
-- Location:    FSI_DEMO_DB.CAPITAL_MARKETS.RESEARCH_INTELLIGENCE
-- Created:     2026-02-25
-- ============================================================================

create or replace semantic view FSI_DEMO_DB.CAPITAL_MARKETS.RESEARCH_INTELLIGENCE
	tables (
		FSI_DEMO_DB.CAPITAL_MARKETS.RESEARCH_NOTES primary key (NOTE_ID) comment='Research notes and analyst reports containing recommendations, target prices, and rating changes for securities',
		FSI_DEMO_DB.CAPITAL_MARKETS.SECURITIES primary key (SECURITY_ID) comment='Master securities reference data including stocks, bonds, and other financial instruments'
	)
	relationships (
		RESEARCH_NOTES_TO_SECURITIES as RESEARCH_NOTES(SECURITY_ID) references SECURITIES(SECURITY_ID)
	)
	facts (
		RESEARCH_NOTES.TARGET_PRICE as TARGET_PRICE with synonyms=('price target','analyst target','expected price') comment='Analyst''s target price for the security',
		RESEARCH_NOTES.PREVIOUS_TARGET as PREVIOUS_TARGET with synonyms=('prior target','old target price','previous price target') comment='Previous target price before the current update',
		SECURITIES.COUPON_RATE as COUPON_RATE with synonyms=('interest rate','coupon') comment='Coupon rate for fixed income securities',
		SECURITIES.PAR_VALUE as PAR_VALUE with synonyms=('face value','nominal value') comment='Par or face value of the security'
	)
	dimensions (
		RESEARCH_NOTES.NOTE_ID as NOTE_ID with synonyms=('research note id','note identifier') comment='Unique identifier for each research note',
		RESEARCH_NOTES.SECURITY_ID as SECURITY_ID with synonyms=('security identifier','stock id') comment='Foreign key linking to the securities table',
		RESEARCH_NOTES.ANALYST_ID as ANALYST_ID with synonyms=('analyst identifier','researcher id') comment='Unique identifier for the analyst who wrote the note',
		RESEARCH_NOTES.ANALYST_NAME as ANALYST_NAME with synonyms=('analyst','researcher','author') comment='Name of the analyst who authored the research note',
		RESEARCH_NOTES.REPORT_TYPE as REPORT_TYPE with synonyms=('research type','note type','report category') comment='Type of research report (EARNINGS_REVIEW, UPDATE, SECTOR_OVERVIEW, INITIATION, EARNINGS_PREVIEW)',
		RESEARCH_NOTES.TITLE as TITLE with synonyms=('report title','note title','headline') comment='Title of the research note',
		RESEARCH_NOTES.RECOMMENDATION as RECOMMENDATION with synonyms=('rating','analyst recommendation','buy sell hold','investment recommendation') comment='Analyst recommendation for the security (BUY, HOLD, SELL, OVERWEIGHT, NEUTRAL)',
		RESEARCH_NOTES.RATING_CHANGE as RATING_CHANGE with synonyms=('rating action','upgrade downgrade','recommendation change') comment='Type of rating change if any (UPGRADE, DOWNGRADE, INITIATION)',
		RESEARCH_NOTES.PUBLISH_DATE as PUBLISH_DATE with synonyms=('publication date','report date','note date') comment='Date when the research note was published',
		RESEARCH_NOTES.CREATED_AT as CREATED_AT with synonyms=('creation timestamp','created date') comment='Timestamp when the record was created',
		SECURITIES.SECURITY_ID as SECURITY_ID with synonyms=('security identifier','instrument id') comment='Unique identifier for each security',
		SECURITIES.TICKER as TICKER with synonyms=('stock symbol','trading symbol','symbol') comment='Trading ticker symbol for the security',
		SECURITIES.CUSIP as CUSIP with synonyms=('cusip number') comment='Committee on Uniform Securities Identification Procedures number',
		SECURITIES.ISIN as ISIN with synonyms=('isin code','international security id') comment='International Securities Identification Number',
		SECURITIES.SECURITY_NAME as SECURITY_NAME with synonyms=('company name','instrument name','stock name') comment='Full name of the security or issuing company',
		SECURITIES.SECURITY_TYPE as SECURITY_TYPE with synonyms=('instrument type','asset type') comment='Type of security (STOCK, BOND, ETF, etc.)',
		SECURITIES.ASSET_CLASS as ASSET_CLASS with synonyms=('asset category','investment class') comment='Asset class classification (EQUITY, FIXED_INCOME, etc.)',
		SECURITIES.EXCHANGE as EXCHANGE with synonyms=('stock exchange','trading venue','market') comment='Exchange where the security is traded',
		SECURITIES.SECTOR as SECTOR with synonyms=('industry sector','business sector','market sector') comment='Business sector classification',
		SECURITIES.INDUSTRY as INDUSTRY with synonyms=('industry group','business industry') comment='Specific industry within the sector',
		SECURITIES.COUNTRY as COUNTRY with synonyms=('country of origin','domicile') comment='Country where the security is domiciled',
		SECURITIES.CURRENCY as CURRENCY with synonyms=('trading currency','denomination') comment='Currency in which the security is denominated',
		SECURITIES.IS_ACTIVE as IS_ACTIVE with synonyms=('active status','trading status') comment='Whether the security is currently active for trading',
		SECURITIES.ISSUE_DATE as ISSUE_DATE with synonyms=('issuance date','listing date') comment='Date when the security was issued',
		SECURITIES.MATURITY_DATE as MATURITY_DATE with synonyms=('maturity','expiration date') comment='Maturity date for fixed income securities',
		SECURITIES.CREATED_AT as CREATED_AT with synonyms=('creation timestamp') comment='Timestamp when the record was created'
	)
	metrics (
		RESEARCH_NOTES.TOTAL_RESEARCH_NOTES as COUNT(NOTE_ID) with synonyms=('note count','number of notes','research count') comment='Total count of research notes',
		RESEARCH_NOTES.AVG_TARGET_PRICE as AVG(TARGET_PRICE) with synonyms=('average target','mean target price') comment='Average target price across research notes',
		RESEARCH_NOTES.TARGET_PRICE_CHANGE as AVG(TARGET_PRICE - PREVIOUS_TARGET) with synonyms=('price target change','target adjustment') comment='Average change in target price from previous target',
		SECURITIES.TOTAL_SECURITIES as COUNT(SECURITY_ID) with synonyms=('security count','number of securities') comment='Total count of securities',
		SECURITIES.ACTIVE_SECURITIES as COUNT_IF(IS_ACTIVE = TRUE) with synonyms=('active count') comment='Count of active securities'
	)
	comment='Research Intelligence semantic view for analysts tracking recommendations, target prices, and rating changes across securities in capital markets.';

-- ============================================================================
-- VERIFIED QUERIES (VQRs)
-- ============================================================================

-- VQR 1: How many research notes are there by recommendation?
SELECT
  RECOMMENDATION,
  COUNT(*) AS NOTE_COUNT
FROM FSI_DEMO_DB.CAPITAL_MARKETS.RESEARCH_NOTES
GROUP BY RECOMMENDATION
ORDER BY NOTE_COUNT DESC;

-- VQR 2: What is the average target price by sector?
SELECT
  s.SECTOR,
  AVG(rn.TARGET_PRICE) AS AVG_TARGET_PRICE,
  COUNT(*) AS NOTE_COUNT
FROM FSI_DEMO_DB.CAPITAL_MARKETS.RESEARCH_NOTES rn
JOIN FSI_DEMO_DB.CAPITAL_MARKETS.SECURITIES s
  ON rn.SECURITY_ID = s.SECURITY_ID
WHERE rn.TARGET_PRICE IS NOT NULL
GROUP BY s.SECTOR
ORDER BY AVG_TARGET_PRICE DESC;

-- VQR 3: What are the recent rating changes?
SELECT
  rn.RATING_CHANGE,
  s.TICKER,
  s.SECURITY_NAME,
  rn.ANALYST_NAME,
  rn.PUBLISH_DATE,
  rn.RECOMMENDATION,
  rn.TARGET_PRICE
FROM FSI_DEMO_DB.CAPITAL_MARKETS.RESEARCH_NOTES rn
JOIN FSI_DEMO_DB.CAPITAL_MARKETS.SECURITIES s
  ON rn.SECURITY_ID = s.SECURITY_ID
WHERE rn.RATING_CHANGE IS NOT NULL
ORDER BY rn.PUBLISH_DATE DESC
LIMIT 50;
