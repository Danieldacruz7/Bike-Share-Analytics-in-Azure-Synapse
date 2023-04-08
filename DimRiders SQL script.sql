CREATE TABLE [dbo].[DimRiders](
    [RiderID] INT NOT NULL, 
    [FirstName] VARCHAR(50) NOT NULL, 
    [LastName] VARCHAR(50) NOT NULL, 
    [Address] VARCHAR(50) NOT NULL,
    [Birthday] DATE NOT NULL,
    [AccountStartDate] DATE NOT NULL, 
    [AccountEndDate] DATE NULL,
    [IsMember] BIT NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE,
    CLUSTERED COLUMNSTORE INDEX
)

INSERT INTO DimRiders(RiderID, FirstName, LastName, Address, Birthday, AccountStartDate, AccountEndDate, IsMember)
SELECT RiderID, 
FirstName, 
LastName, 
Address, 
TRY_CONVERT(DATE, LEFT(Birthday, 10)), 
TRY_CONVERT(DATE, LEFT(StartDate, 10)), 
TRY_CONVERT(DATE, LEFT(EndDate, 10)),
ISNULL(TRY_CONVERT(BIT, IsMember), 0)
FROM dbo.staging_rider
GO;

SELECT TOP(100) * FROM dbo.DimRiders;
GO;