-- Country definition

CREATE TABLE Country (
    CountryCode TEXT,
    ShortName TEXT,
    TableName TEXT,
    LongName TEXT,
    Alpha2Code TEXT,
    CurrencyUnit TEXT,
    SpecialNotes TEXT,
    Region TEXT,
    IncomeGroup TEXT,
    Wb2Code TEXT,
    NationalAccountsBaseYear TEXT,
    NationalAccountsReferenceYear TEXT,
    SnaPriceValuation TEXT,
    LendingCategory TEXT,
    OtherGroups TEXT,
    SystemOfNationalAccounts TEXT,
    AlternativeConversionFactor TEXT,
    PppSurveyYear TEXT,
    BalanceOfPaymentsManualInUse TEXT,
    ExternalDebtReportingStatus TEXT,
    SystemOfTrade TEXT,
    GovernmentAccountingConcept TEXT,
    ImfDataDisseminationStandard TEXT,
    LatestPopulationCensus TEXT,
    LatestHouseholdSurvey TEXT,
    SourceOfMostRecentIncomeAndExpenditureData TEXT,
    VitalRegistrationComplete TEXT,
    LatestAgriculturalCensus TEXT,
    LatestIndustrialData NUMERIC,
    LatestTradeData NUMERIC,
    LatestWaterWithdrawalData NUMERIC);
    
   -- CountryNotes definition

CREATE TABLE CountryNotes (
    Countrycode TEXT,
    Seriescode TEXT,
    Description TEXT);
     
   -- Footnotes definition

CREATE TABLE Footnotes (
    Countrycode TEXT,
    Seriescode TEXT,
    Year TEXT,
    Description TEXT);
   
   
  -- Indicators definition

CREATE TABLE Indicators (
    CountryName TEXT,
    CountryCode TEXT,
    IndicatorName TEXT,
    IndicatorCode TEXT,
    Year INTEGER,
    Value NUMERIC);

CREATE INDEX indicators_CountryName_idx ON Indicators (CountryName);
CREATE INDEX indicators_CountryCode_idx ON Indicators (CountryCode);
CREATE INDEX indicators_IndicatorName_idx ON Indicators (IndicatorName);
CREATE INDEX indicators_IndicatorCode_idx ON Indicators (IndicatorCode);
CREATE INDEX indicators_Year_idx ON Indicators (Year);

-- Series definition

CREATE TABLE Series (
    SeriesCode TEXT,
    Topic TEXT,
    IndicatorName TEXT,
    ShortDefinition TEXT,
    LongDefinition TEXT,
    UnitOfMeasure TEXT,
    Periodicity TEXT,
    BasePeriod TEXT,
    OtherNotes NUMERIC,
    AggregationMethod TEXT,
    LimitationsAndExceptions TEXT,
    NotesFromOriginalSource TEXT,
    GeneralComments TEXT,
    Source TEXT,
    StatisticalConceptAndMethodology TEXT,
    DevelopmentRelevance TEXT,
    RelatedSourceLinks TEXT,
    OtherWebLinks NUMERIC,
    RelatedIndicators NUMERIC,
    LicenseType TEXT);
   
   
   -- SeriesNotes definition

CREATE TABLE SeriesNotes (
    Seriescode TEXT,
    Year TEXT,
    Description TEXT);
   
   
   
   
   