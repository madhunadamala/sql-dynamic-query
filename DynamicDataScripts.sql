
GO
/****** Object:  Table [dbo].[TEST_RESULT]    Script Date: 11/8/2018 1:52:12 PM ******/
DROP TABLE [dbo].[TEST_RESULT]
GO
/****** Object:  Table [dbo].[TEST_RAWCOLUMNDATA]    Script Date: 11/8/2018 1:52:12 PM ******/
DROP TABLE [dbo].[TEST_RAWCOLUMNDATA]
GO
/****** Object:  Table [dbo].[TEST_MAPPINGS]    Script Date: 11/8/2018 1:52:12 PM ******/
DROP TABLE [dbo].[TEST_MAPPINGS]
GO
/****** Object:  Table [dbo].[TEST_HEADERSCHEMA]    Script Date: 11/8/2018 1:52:12 PM ******/
DROP TABLE [dbo].[TEST_HEADERSCHEMA]
GO
/****** Object:  Table [dbo].[TEST_HEADERSCHEMA]    Script Date: 11/8/2018 1:52:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEST_HEADERSCHEMA](
	[HdrId] [int] NULL,
	[Hdr_Shcema] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TEST_MAPPINGS]    Script Date: 11/8/2018 1:52:12 PM ******/
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
/****** Object:  Table [dbo].[TEST_RAWCOLUMNDATA]    Script Date: 11/8/2018 1:52:12 PM ******/
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
/****** Object:  Table [dbo].[TEST_RESULT]    Script Date: 11/8/2018 1:52:12 PM ******/
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
INSERT [dbo].[TEST_HEADERSCHEMA] ([HdrId], [Hdr_Shcema]) VALUES (1, N'SALARY_INCOME,EXPENSES,EMP_ID')
INSERT [dbo].[TEST_HEADERSCHEMA] ([HdrId], [Hdr_Shcema]) VALUES (2, N'ITEM_QTY,COST,EMP_ID')
INSERT [dbo].[TEST_HEADERSCHEMA] ([HdrId], [Hdr_Shcema]) VALUES (3, N'HOUSE_INCOME,OTHER_INCOME,BALANCE,EMP_ID')
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'SALARY_INCOME', N'CAST(1.SALARY_INCOME AS INT)', N'SALARY', 1)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'EXPENSES', N'CAST(1.EXPENSES AS INT)', N'GENERAL_EXPENSES', 1)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'OTHER_INCOME', N'CAST(3.HOUSE_INCOME AS INT)+CAST(3.OTHER_INCOME AS INT)', N'OTHER_INCOME', 3)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'COST', N'CAST(2.ITEM_QTY AS INT)*CAST(2.COST AS INT)', N'ITEM_COST', 2)
INSERT [dbo].[TEST_MAPPINGS] ([RawColumn], [Expression], [Result], [HdrId]) VALUES (N'BALANCE', N'CAST(1.SALARY_INCOME AS INT)+CAST(3.HOUSE_INCOME AS INT)+CAST(3.OTHER_INCOME AS INT)-CAST(1.EXPENSES AS INT)-(CAST(2.ITEM_QTY AS INT)*CAST(2.COST AS INT))', N'BALANCE', 3)
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
