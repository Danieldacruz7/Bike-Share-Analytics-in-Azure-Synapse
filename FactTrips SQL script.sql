CREATE TABLE [dbo].[FactTrips](
    [TripID] VARCHAR(50) NOT NULL, 
    [DateKey] INT NOT NULL,
    [RideableType] VARCHAR(50) NOT NULL,
    [StartedAt] DATE NOT NULL,
    [EndedAt] DATE NOT NULL,
    [TripDuration] FLOAT NOT NULL,
    [StartStationID] VARCHAR(50) NOT NULL, 
    [EndStationID] VARCHAR(50) NOT NULL, 
    [RiderID] INT NOT NULL, 
    [RiderAge] INT NOT NULL
)
WITH
(
    DISTRIBUTION = HASH([TripID]),
    CLUSTERED COLUMNSTORE INDEX
)
GO;

INSERT INTO FactTrips(TripID, DateKey, RideableType, StartedAt, EndedAt, TripDuration, StartStationID, EndStationID, RiderID, RiderAge)
SELECT st.TripID, 
dd.DateKey,
st.RideableType,
TRY_CONVERT(DATE, LEFT(st.StartedAt, 10)), 
TRY_CONVERT(DATE, LEFT(st.EndedAt, 10)), 
DATEDIFF(SECOND, st.StartedAt , st.EndedAt),
st.StartStationID, 
st.EndStationID, 
st.MemberID, 
DATEDIFF(year, sr.Birthday,
    CONVERT(Datetime, SUBSTRING([StartedAt], 1, 19), 120)) - (
        CASE WHEN MONTH(sr.Birthday) > MONTH(CONVERT(Datetime, SUBSTRING([StartedAt], 1, 19), 120))
        OR MONTH(sr.Birthday) =
            MONTH(CONVERT(Datetime, SUBSTRING([StartedAt], 1, 19), 120))
        AND DAY(sr.Birthday) >
            DAY(CONVERT(Datetime, SUBSTRING([StartedAt], 1, 19), 120))
        THEN 1 ELSE 0 END
    )
FROM [dbo].[staging_trips] st
JOIN [dbo].[staging_rider] sr ON st.MemberID = sr.RiderID
JOIN [dbo].[DimDate] dd ON dd.Date = st.StartedAt
GO;

SELECT TOP(100) * FROM dbo.FactTrips;
GO;