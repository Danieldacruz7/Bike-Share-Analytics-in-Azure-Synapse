CREATE TABLE [dbo].[FactPayments](
    [PaymentID] INT NOT NULL, 
    [DateKey] INT NOT NULL,
    [Amount] MONEY NOT NULL, 
    [AccountNumber] INT NOT NULL
)
WITH 
(
    DISTRIBUTION = HASH([PaymentID]),
    CLUSTERED COLUMNSTORE INDEX 
)

INSERT INTO FactPayments(PaymentID, DateKey, Amount, AccountNumber)
SELECT sp.PaymentID, dd.DateKey, sp.Amount, sp.AccountNumber
FROM [dbo].[staging_payment] sp
JOIN [dbo].[DimDate] dd ON dd.Date = sp.PaymentDate
GO;

SELECT TOP(100) * FROM dbo.FactPayments;
GO;