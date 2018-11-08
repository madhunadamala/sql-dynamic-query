SELECT * FROM [dbo].[TEST_HEADERSCHEMA]
SELECT * FROM [dbo].[TEST_MAPPINGS]
SELECT * FROM [dbo].[TEST_RAWCOLUMNDATA]
TRUNCATE TABLE [TEST_RESULT]

IF OBJECT_ID('tempdb..#Tmp1') IS NOT NULL
   DROP TABLE #Tmp1

IF OBJECT_ID('tempdb..#Tmp2') IS NOT NULL
   DROP TABLE #Tmp2

IF OBJECT_ID('tempdb..#Tmp3') IS NOT NULL
   DROP TABLE #Tmp3

IF OBJECT_ID('tempdb..#TempTables') IS NOT NULL
   DROP TABLE #TempTables

IF OBJECT_ID('tempdb..#TmpMap') IS NOT NULL
   DROP TABLE #TmpMap
   
/*For Header Schema -1
  Create a Temp Table with each Header Schema Data by iterating HeadeSchema list for that file. 
  It means creating table for each sheet.
  For the example, it below temple table is is not dymanc. 
  Iterate through the header Schema and Create Temp tables First and then insert pivoted Data.
*/
SELECT RowID,SALARY_INCOME,EXPENSES,EMP_ID 
INTO #Tmp1
FROM
    (SELECT RowID, Rawcolumn,RawValue
     FROM [dbo].[TEST_RAWCOLUMNDATA]
	 WHERE SourceFile='Text.xls' AND HdrId=1
	)P
	PIVOT
	(
	 MAX(RawValue)
	 FOR Rawcolumn IN
	 (
	 [SALARY_INCOME],[EXPENSES],[EMP_ID]
	 )
	)AS PVT
	ORDER BY ROWID

--For Header Schema-2  
SELECT RowID,ITEM_QTY,COST,EMP_ID 
INTO #Tmp2
FROM
    (SELECT RowID, Rawcolumn,RawValue
     FROM [dbo].[TEST_RAWCOLUMNDATA]
	 WHERE SourceFile='Text.xls' AND HdrId=2
	)P
	PIVOT
	(
	 MAX(RawValue)
	 FOR Rawcolumn IN
	 (
	 [ITEM_QTY],[COST],[EMP_ID]
	 )
	)AS PVT
	ORDER BY ROWID

--For Header Schema-2  
SELECT RowID,HOUSE_INCOME,OTHER_INCOME,BALANCE,EMP_ID 
INTO #Tmp3
FROM
    (SELECT RowID, Rawcolumn,RawValue
     FROM [dbo].[TEST_RAWCOLUMNDATA]
	 WHERE SourceFile='Text.xls' AND HdrId=3
	)P
	PIVOT
	(
	 MAX(RawValue)
	 FOR Rawcolumn IN
	 (
	 [HOUSE_INCOME],[OTHER_INCOME],[BALANCE],[EMP_ID]
	 )
	)AS PVT
	ORDER BY ROWID

CREATE TABLE #TempTables
   (
    HdrId VARCHAR(5),
	TempTable NVARCHAR(50)
   );

INSERT INTO #TempTables (HdrId,TempTable) VALUES ('1','#Tmp1')
INSERT INTO #TempTables (HdrId,TempTable) VALUES ('2','#Tmp2')
INSERT INTO #TempTables (HdrId,TempTable) VALUES ('3','#Tmp3')
SELECT * INTO #TmpMap FROM [TEST_MAPPINGS] WHERE HdrId IN(1,2,3)

SELECT * FROM #Tmp1
SELECT * FROM #Tmp2
SELECT * FROM #Tmp3
SELECT * FROM #TempTables
SELECT * FROM #TmpMap

--Iterate through Temp table list replae the HdrId with with Temp Table name.
DECLARE @V_TmpMapCount INT
DECLARE @V_Count INT = 1
DECLARE @V_TmpTable VARCHAR(10)
DECLARE @V_HdrID VARCHAR(5)
SELECT @V_TmpMapCount = COUNT(*) FROM #TempTables

WHILE @V_Count <=@V_TmpMapCount
BEGIN 
  SELECT @V_TmpTable = TempTable+'.', @V_HdrID = HdrId+'.' FROM #TempTables WHERE HdrId = @V_Count
  UPDATE #TmpMap SET Expression= REPLACE(Expression,@V_HdrID,@V_TmpTable)
  SET @V_Count = @V_Count + 1
END

SELECT * FROM #TmpMap

--Convert the Expression in to Comma Separate in to a Dynamic String for the required result column as per Fina Result Table
INSERT INTO [dbo].[TEST_RESULT]
SELECT CAST(#Tmp1.SALARY_INCOME AS INT) AS SALARY,
     CAST(#Tmp1.EXPENSES AS INT) AS GENERAL_EXPENSES,
    CAST(#Tmp3.HOUSE_INCOME AS INT)+CAST(#Tmp3.OTHER_INCOME AS INT) AS OTHER_INCOME,
       CAST(#Tmp2.ITEM_QTY AS INT)*CAST(#Tmp2.COST AS INT) AS ITEM_COST,
	   CAST(#Tmp1.SALARY_INCOME AS INT)+CAST(#Tmp3.HOUSE_INCOME AS INT)+CAST(#Tmp3.OTHER_INCOME AS INT)-
	      CAST(#Tmp1.EXPENSES AS INT)-(CAST(#Tmp2.ITEM_QTY AS INT)*CAST(#Tmp2.COST AS INT)) AS BALANCE
FROM #TMP1, #TMP2,#TMP3

