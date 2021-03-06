USE [DQAVT]
GO
/****** Object:  Table [dbo].[TEST_RESULT]    Script Date: 11/9/2018 3:31:42 PM ******/
DROP TABLE [dbo].[TEST_RESULT]
GO
/****** Object:  Table [dbo].[TEST_RAWCOLUMNDATA]    Script Date: 11/9/2018 3:31:42 PM ******/
DROP TABLE [dbo].[TEST_RAWCOLUMNDATA]
GO
/****** Object:  Table [dbo].[TEST_QUERIES]    Script Date: 11/9/2018 3:31:42 PM ******/
DROP TABLE [dbo].[TEST_QUERIES]
GO
/****** Object:  Table [dbo].[TEST_MAPPINGS]    Script Date: 11/9/2018 3:31:42 PM ******/
DROP TABLE [dbo].[TEST_MAPPINGS]
GO
/****** Object:  Table [dbo].[TEST_HEADERSCHEMA]    Script Date: 11/9/2018 3:31:42 PM ******/
DROP TABLE [dbo].[TEST_HEADERSCHEMA]
GO
/****** Object:  Table [dbo].[TEST_HEADERSCHEMA]    Script Date: 11/9/2018 3:31:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEST_HEADERSCHEMA](
	[HdrId] [int] NULL,
	[Hdr_Shcema] [nvarchar](max) NULL,
	[SiblingHdrId] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TEST_MAPPINGS]    Script Date: 11/9/2018 3:31:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEST_MAPPINGS](
	[RawColumn] [nvarchar](50) NULL,
	[Expression] [nvarchar](max) NULL,
	[Result] [nvarchar](50) NULL,
	[HdrId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TEST_QUERIES]    Script Date: 11/9/2018 3:31:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEST_QUERIES](
	[QryID] [int] NULL,
	[Query] [nvarchar](1000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TEST_RAWCOLUMNDATA]    Script Date: 11/9/2018 3:31:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEST_RAWCOLUMNDATA](
	[RawColumn] [nvarchar](50) NULL,
	[RawValue] [nvarchar](50) NULL,
	[HdrId] [int] NULL,
	[SourceFile] [nvarchar](50) NULL,
	[RowID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TEST_RESULT]    Script Date: 11/9/2018 3:31:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEST_RESULT](
	[Salary] [int] NULL,
	[General_Expenses] [int] NULL,
	[Other_Income] [int] NULL,
	[Item_Cost] [int] NULL,
	[Balance] [int] NULL
) ON [PRIMARY]

GO
INSERT [dbo].[TEST_HEADERSCHEMA] ([HdrId], [Hdr_Shcema], [SiblingHdrId]) VALUES (1, N'SALARY_INCOME,EXPENSES,EMP_ID', NULL)
INSERT [dbo].[TEST_HEADERSCHEMA] ([HdrId], [Hdr_Shcema], [SiblingHdrId]) VALUES (2, N'ITEM_QTY,COST,EMP_ID', NULL)
INSERT [dbo].[TEST_HEADERSCHEMA] ([HdrId], [Hdr_Shcema], [SiblingHdrId]) VALUES (3, N'HOUSE_INCOME,OTHER_INCOME,BALANCE,EMP_ID', NULL)
INSERT [dbo].[TEST_HEADERSCHEMA] ([HdrId], [Hdr_Shcema], [SiblingHdrId]) VALUES (4, N'EmpID,Salary,Ppf,Bonus', N'5,6')
INSERT [dbo].[TEST_HEADERSCHEMA] ([HdrId], [Hdr_Shcema], [SiblingHdrId]) VALUES (5, N'Slab_Frm,Slab_To,Amount', N'4,6')
INSERT [dbo].[TEST_HEADERSCHEMA] ([HdrId], [Hdr_Shcema], [SiblingHdrId]) VALUES (6, N'EmpId,Month,Amount', N'4,5')
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'SALARY_INCOME', N'CAST(1.SALARY_INCOME AS INT)', N'SALARY', 1)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'EXPENSES', N'CAST(1.EXPENSES AS INT)', N'GENERAL_EXPENSES', 1)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'OTHER_INCOME', N'CAST(3.HOUSE_INCOME AS INT)+CAST(3.OTHER_INCOME AS INT)', N'OTHER_INCOME', 3)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'COST', N'CAST(2.ITEM_QTY AS INT)*CAST(2.COST AS INT)', N'ITEM_COST', 2)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'BALANCE', N'CAST(1.SALARY_INCOME AS INT)+CAST(3.HOUSE_INCOME AS INT)+CAST(3.OTHER_INCOME AS INT)-CAST(1.EXPENSES AS INT)-(CAST(2.ITEM_QTY AS INT)*CAST(2.COST AS INT))', N'BALANCE', 3)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'EMPID', N'#HDRID4.EmpId', N'EMPID', 4)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'Salary', N'#HDRID4.Salary', N'Salary', 4)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'Bonus', N'QryID2', N'Bonus', 4)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'PPF', N'QryID1', N'PPF', 4)
INSERT [dbo].[TEST_QUERIES] ([QryID], [Query]) VALUES (1, N'(SELECT SUM(CAST(#HDRID6.Amount AS INT)) FROM #HDRID6 WHERE #HDRID4.EMPID = #HDRID6.EMPID Group By EMPID)')
INSERT [dbo].[TEST_QUERIES] ([QryID], [Query]) VALUES (2, N'(SELECT AMOUNT FROM #HDRID5  WHERE CAST(#HDRID4.Salary AS INT) BETWEEN CAST(#HDRID5 .Slab_Frm AS INT) AND  CAST(#HDRID5 .Slab_To AS INT))')
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'SALARY_INCOME', N'10000', 1, N'Text.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'EXPENSES', N'5000', 1, N'Text.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'ITEM_QTY', N'2', 2, N'Text.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'COST', N'1000', 2, N'Text.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'HOUSE_INCOME', N'4000', 3, N'Text.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'OTHER_INCOME', N'500', 3, N'Text.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'BALANCE', N'0', 1, N'Text.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'EMP_ID', N'123', 1, N'Text.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'EMP_ID', N'123', 2, N'Text.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'EMP_ID', N'123', 3, N'Text.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'EmpID', N'1', 4, N'File1.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Salary', N'9500', 4, N'File1.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Slab_Frm', N'5000', 5, N'File1.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Slab_To', N'7000', 5, N'File1.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Amount', N'600', 5, N'File1.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Slab_Frm', N'7001', 5, N'File1.xls', 2)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Slab_To', N'10000', 5, N'File1.xls', 2)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Amount', N'800', 5, N'File1.xls', 2)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'EmpID', N'1', 6, N'File1.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Month', N'Jan', 6, N'File1.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Amount', N'200', 6, N'File1.xls', 1)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'EmpID', N'1', 6, N'File1.xls', 2)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Month', N'Feb', 6, N'File1.xls', 2)
INSERT [dbo].[TEST_RAWCOLUMNDATA] ([RawColumn], [RawValue], [HdrId], [SourceFile], [RowID]) VALUES (N'Amount', N'300', 6, N'File1.xls', 2)
