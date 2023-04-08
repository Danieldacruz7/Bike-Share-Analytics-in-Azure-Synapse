DROP TABLE [dbo].[DimDate]
GO

CREATE TABLE [dbo].[DimDate](
    [DateKey] INT IDENTITY(1,1), 
    [Date] DATE NOT NULL,
    [Year] INT NOT NULL, 
    [Quarter] INT NOT NULL,
    [Month] INT NOT NULL,
    [Day] INT NOT NULL,
    [Week] INT NOT NULL
)
WITH 
(
    DISTRIBUTION = REPLICATE,
    CLUSTERED COLUMNSTORE INDEX 
)
GO;

DECLARE @start_date AS DATE;
DECLARE @current_date AS DATE;
DECLARE @end_date AS DATE;

SET @start_date = '01/01/2020'
SET @end_date = '01/01/2040'

SET @current_date = @start_date

WHILE @current_date < @end_date
BEGIN 
    DECLARE @current_year int;
    DECLARE @current_quarter int;
    DECLARE @current_month int;
    DECLARE @current_day int;
    DECLARE @current_week int;

    SET @current_year = YEAR(@current_date);
    SET @current_quarter = DATEPART(QUARTER, @current_date);
    SET @current_month = MONTH(@current_date);
    SET @current_day = DAY(@current_date);
    SET @current_week = DATEPART(WEEK, @current_date);

    INSERT INTO DimDate (Date, Year, Quarter, Month, Day, Week)
    VALUES (
        @current_date, 
        @current_year, 
        @current_quarter, 
        @current_month, 
        @current_day,
        @current_week
        );
    SET @current_date = DATEADD(DAY, 1, @current_date)
END

