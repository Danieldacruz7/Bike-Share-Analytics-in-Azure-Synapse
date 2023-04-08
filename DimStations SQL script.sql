CREATE TABLE [dbo].[DimStations]( 
    [StationID] VARCHAR(50) NOT NULL, 
    [Name] VARCHAR(100) NOT NULL, 
    [Latitude] FLOAT NOT NULL,
    [Longitude] FLOAT NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE,
    CLUSTERED COLUMNSTORE INDEX
)
GO;

INSERT INTO DimStations(StationID, Name, Latitude, Longitude)
SELECT StationID, 
Name, 
Latitude, 
Longitude
FROM dbo.staging_stations
GO;

SELECT TOP(100) * FROM DimStations;
GO;
