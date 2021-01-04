
TRUNCATE TABLE [staging].[Transaction_Import]

DECLARE @SourceDir VARCHAR(200),@FileName VARCHAR(100)

SET @SourceDir = 'D:\CustomerData\'
SET @FileName = 'CustomerTrans_' + CONVERT(varchar, GETDATE(), 112) + '.csv'
SET @FileName = 'CustomerTrans.csv'

DECLARE @SqlText NVARCHAR(2000)


SET @SqlText = 'BULK INSERT [staging].[Transaction_Import] FROM ''' + @SourceDir + @FileName + ''' 
			WITH ( DATAFILETYPE = ''widechar'',   FirstRow = 2, FIELDTERMINATOR = ''\t'', ROWTERMINATOR  = '''+char(10)+''')'
EXEC sp_executesql @SqlText

SELECT * FROM [staging].[Transaction_Import]

DECLARE @EmailAddress NVARCHAR(200) 
DECLARE @EmailSubject NVARCHAR(200) 
DECLARE @EmailBody NVARCHAR(max) 
DECLARE @EmailProfile varchar(10)

SET @EmailAddress = 'someone@azure.com'
SET @EmailSubject = 'Customer Order Loads for ' + CONVERT(Varchar, GETDATE(), 106)
SET @EmailBody = '<div style="font-family:Tahoma;">Customer transactions for <b>' + CONVERT(Varchar, GETDATE(), 106) + '</b> have been loaded</dvi>'
SET @EmailProfile = 'default'

EXEC msdb.dbo.sp_send_dbmail 
@profile_name = @EmailProfile,
@recipients = @EmailAddress,
@subject = @EmailSubject,
@body = @EmailBody,
@body_format = 'HTML',
@importance = 'Normal'


RAISERROR('Test Alert Error', 16,1) WITH LOG

SELECT [Entity_Name], CAST(Delivery_Date AS DATE), [Name], CAST(ReferenceId as Char(8)), RIGHT('0' + Zip, 4), [Address], CAST(Order_Date AS DATE), CAST(SUBSTRING(Denomination, 2, 3) AS Smallint), CAST(Ship_In As Int)
FROM Staging.Transaction_Import