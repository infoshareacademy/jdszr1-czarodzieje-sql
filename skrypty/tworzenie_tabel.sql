-- tworzymy tabele Country definition

create table Country (
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
    
-- tworzymy tabele CountryNotes definition

create table countryNotes (
    Countrycode TEXT,
    Seriescode TEXT,
    Description TEXT);
     
-- tworzymy tabele footnotes definition

create table footnotes (
    Countrycode TEXT,
    Seriescode TEXT,
    Year TEXT,
    Description TEXT);
   
   
--tworzymy tabele Indicators definition

create table indicators (
    CountryName TEXT,
    CountryCode TEXT,
    IndicatorName TEXT,
    IndicatorCode TEXT,
    Year INTEGER,
    Value NUMERIC);

create index indicators_CountryName_idx on Indicators (CountryName);
create index indicators_CountryCode_idx on Indicators (CountryCode);
create index indicators_IndicatorName_idx on Indicators (IndicatorName);
create index indicators_IndicatorCode_idx on Indicators (IndicatorCode);
create index indicators_Year_idx on Indicators (Year);

--tworzenie tabeli series definition

create table series (
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
   
   
--tworzenie tabeli Series Notes definition

create table seriesNotes (
    Seriescode TEXT,
    Year TEXT,
    Description TEXT);
   
   
   
   
   