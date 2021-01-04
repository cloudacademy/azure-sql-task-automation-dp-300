CREATE SCHEMA Staging
GO

CREATE TABLE [staging].[Transaction_Import](
	[Entity_Name] [varchar](255) NULL,
	[Delivery_Date] [varchar](25) NULL,
	[Name] [varchar](50) NULL,
	[ReferenceId] [varchar](25) NULL,
	[Zip] [varchar](10) NULL,
	[Address] [varchar](255) NULL,
	[Order_Date] [varchar](25) NULL,
	[Denomination] [varchar](10) NULL,
	[Ship_In] [varchar](20) NULL
) ON [PRIMARY]
GO

DROP TABLE [dbo].[Transaction_Import]
GO

CREATE TABLE [dbo].[Transaction_Import](
	Id				int not null identity(1,1),
	[From_Entity]	[varchar](255) NULL,
	[Delivery_Date] Date NOT NULL,
	[Name]			[varchar](50) NULL,
	[ReferenceId]	[char](8) NULL,
	[Zip]			[char](4) NULL,
	[Address]		[varchar](255) NULL,
	[Order_Date]	 Date NOT NULL,
	[Denomination]	SmallInt default 0,
	[Ship_In]		Int default 0
) ON [PRIMARY]
GO


CREATE TABLE [Staging].[Transaction_Import_Archive](
	[Entity_Name] [varchar](255) NULL,
	[Delivery_Date] [varchar](25) NULL,
	[Name] [varchar](50) NULL,
	[ReferenceId] [varchar](25) NULL,
	[Zip] [varchar](10) NULL,
	[Address] [varchar](255) NULL,
	[Order_Date] [varchar](25) NULL,
	[Denomination] [varchar](10) NULL,
	[Ship_In] [varchar](20) NULL
) ON [PRIMARY]
GO


CREATE PROCEDURE usp_Transaction_Import_Transform AS
BEGIN
	INSERT INTO dbo.Transaction_Import(From_Entity, Delivery_Date, [Name], ReferenceId, Zip, [Address], Order_Date, Denomination, Ship_In)
	SELECT [Entity_Name], CAST(Delivery_Date AS DATE), [Name], CAST(ReferenceId as Char(8)), RIGHT('0' + Zip, 4), [Address], CAST(Order_Date AS DATE), CAST(SUBSTRING(Denomination, 2, 3) AS Smallint), CAST(Ship_In As Int)
	FROM Staging.Transaction_Import

	INSERT INTO Staging.Transaction_Import_Archive
	SELECT *
	FROM Staging.Transaction_Import

	TRUNCATE TABLE Staging.Transaction_Import
END

