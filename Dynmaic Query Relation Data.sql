SELECT * FROM [dbo].[TEST_HEADERSCHEMA] WHERE HdrId IN(4,5,6)
SELECT * FROM [dbo].[TEST_QUERIES] 
SELECT * FROM [dbo].[TEST_MAPPINGS] WHERE HdrId IN(4,5,6)
SELECT * FROM [dbo].[TEST_RAWCOLUMNDATA] WHERE HdrId IN(4,5,6)
SELECT * FROM [dbo].[TEST_HEADERSCHEMA] WHERE HdrId=4

--Based on the SiblingHdrId, We know we have dependency on 3 Header Scheam Data
--It means it required 3 Temp Tables
IF OBJECT_ID('tempdb..#HDRID4') IS NOT NULL
   DROP TABLE #HDRID4

IF OBJECT_ID('tempdb..#HDRID5') IS NOT NULL
   DROP TABLE #HDRID5

IF OBJECT_ID('tempdb..#HDRID6') IS NOT NULL
   DROP TABLE #HDRID6

IF OBJECT_ID('tempdb..#TempTables') IS NOT NULL
   DROP TABLE #TempTables

IF OBJECT_ID('tempdb..#TmpMap') IS NOT NULL
   DROP TABLE #TmpMap
   
/*For Header Schema -1
   As we are creating TempTable for each HeaderSchema, letus Create TempTable as 
   "HDRID1" etc
*/
SELECT RowID,EmpID,Salary,Ppf,Bonus 
INTO #HDRID4
FROM
    (SELECT RowID,Rawcolumn,RawValue
     FROM [dbo].[TEST_RAWCOLUMNDATA]
	 WHERE SourceFile='File1.xls' AND HdrId=4
	)P
	PIVOT
	(
	 MAX(RawValue)
	 FOR Rawcolumn IN
	 (
	 [EmpID],[Salary],[Ppf],[Bonus]
	 )
	)AS PVT
	ORDER BY ROWID

--For Header Schema-2  
SELECT RowID,Slab_Frm,Slab_To,Amount 
INTO #HDRID5
FROM
    (SELECT RowID,Rawcolumn,RawValue
     FROM [dbo].[TEST_RAWCOLUMNDATA]
	 WHERE SourceFile='File1.xls' AND HdrId=5
	)P
	PIVOT
	(
	 MAX(RawValue)
	 FOR Rawcolumn IN
	 (
	 [Slab_Frm],[Slab_To],[Amount]
	 )
	)AS PVT
	ORDER BY ROWID

--For Header Schema-2  
SELECT RowID,EmpId,[Month],Amount 
INTO #HDRID6
FROM
    (SELECT RowID,Rawcolumn,RawValue
     FROM [dbo].[TEST_RAWCOLUMNDATA]
	 WHERE SourceFile='File1.xls' AND HdrId=6
	)P
	PIVOT
	(
	 MAX(RawValue)
	 FOR Rawcolumn IN
	 (
	 EmpId,[Month],Amount
	 )
	)AS PVT
	ORDER BY ROWID

CREATE TABLE #TempTables
   (
    HdrId VARCHAR(5),
	TempTable NVARCHAR(50)
   );

SELECT * INTO #TmpMap FROM [TEST_MAPPINGS] WHERE HdrId IN(4,5,6)
ALTER TABLE #TmpMap ADD QRYID INT

SELECT * FROM #HDRID4
SELECT * FROM #HDRID5
SELECT * FROM #HDRID6

UPDATE #TmpMap SET QRYID = CAST(REPLACE(Expression,'QRYID','')AS INT) WHERE Expression LIKE 'QRYID%'
UPDATE  TM SET TM.Expression=tq.Query
   FROM #TmpMap TM INNER JOIN [dbo].[TEST_QUERIES] TQ
   ON TQ.QryID = TM.QRYID;

SELECT * FROM #TmpMap

SELECT #HDRID4.EmpId AS EMPID
      ,#HDRID4.Salary AS SALARY
	  ,(SELECT AMOUNT FROM #HDRID5  WHERE CAST(#HDRID4.Salary AS INT) BETWEEN CAST(#HDRID5 .Slab_Frm AS INT) AND  CAST(#HDRID5 .Slab_To AS INT)) AS PPF
      ,(SELECT SUM(CAST(#HDRID6.Amount AS INT)) FROM #HDRID6 WHERE #HDRID4.EMPID = #HDRID6.EMPID Group By EMPID) AS BONUS
FROM #HDRID4