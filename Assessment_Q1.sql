-- Subquery for Sasso breed
SELECT * FROM (
    SELECT 
        [Prefix],
        [Deposit Date] as [Deposit_Date],
        [Ready To Recieve Date] as [Ready_To_Receive_Date],
        DATEDIFF(day, [Deposit Date], GETDATE()) as waitingDay,
        DATEDIFF(day, [Deposit Date], [Ready To Recieve Date]) as waitingDayRtr,
        CASE
            WHEN [Ready To Recieve Date] <= GETDATE() THEN 'Past RTR Date'
            WHEN [Ready To Recieve Date] > GETDATE() THEN 'Upcoming RTR Date'
            ELSE 'RTR Date Not Specified'
        END AS RTR_Datre_Status,
        [Order_Number],
        [Order_Conversion_Date],
        [DeliveryStatus],
        [Order_Conversion_Status],
        [City] as Zone,
        [Territory Code] as [Territory_Code],
        [Posting Date] as [Posting_Date],
        DATEPART(YEAR, [Deposit Date]) as Year_,
        DATENAME(MONTH, [Deposit Date]) as Month_,
        RIGHT(CONVERT(VARCHAR(4), DATEPART(YEAR, [Deposit Date])), 2) + '-WK-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(WEEK, [Deposit Date])), 2)  as Deposit_Week_Num,
        [Description],
        'Sasso' as Breed_Type,
        [Quantity],
        [Reason Code] as [Reason_Code],
        [Bill-to Customer No_] as [Bill_to_Customer_No],
        [Unit Price] as [Unit_Price],
        [Customer Price Group] as [Customer_Price_Group]
    FROM [gold].[Sales_Fact_All_Company]
    WHERE 
        [Description] IN ('Day Old Chick - Mixed - Sasso', 'Day Old Chick - Female - Sasso', 'Day Old Chick - Male - Sasso','Day Old Chick - Mixed - Sasso(last Rem is Bovans)')
        AND [Order_Conversion_Status] = 'Active Order'
) sasso
WHERE 
    sasso.waitingDay > 42
    AND CAST(sasso.Unit_Price AS FLOAT) > 0 
    AND sasso.[Customer_Price_Group] <> 'INTERCO'

UNION ALL

-- Subquery for Layer breed
SELECT * FROM (
    SELECT 
        [Prefix],
        [Deposit Date] as [Deposit_Date],
        [Ready To Recieve Date] as [Ready_To_Receive_Date],
        DATEDIFF(day, [Deposit Date], GETDATE()) as waitingDay,
        DATEDIFF(day, [Deposit Date], [Ready To Recieve Date]) as waitingDayRtr,
        CASE
            WHEN [Ready To Recieve Date] <= GETDATE() THEN 'Past RTR Date'
            WHEN [Ready To Recieve Date] > GETDATE() THEN 'Upcoming RTR Date'
            ELSE 'RTR Date Not Specified'
        END AS RTR_Datre_Status,
        [Order_Number],
        [Order_Conversion_Date],
        [DeliveryStatus],
        [Order_Conversion_Status],
        [City] as Zone,
        [Territory Code] as [Territory_Code],
        [Posting Date] as [Posting_Date],
        DATEPART(YEAR, [Deposit Date]) as Year_,
        DATENAME(MONTH, [Deposit Date]) as Month_,
        RIGHT(CONVERT(VARCHAR(4), DATEPART(YEAR, [Deposit Date])), 2) + '-WK-' + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(WEEK, [Deposit Date])), 2)  as Deposit_Week_Num,
        [Description],
        'Layer' as Breed_Type,
        [Quantity],
        [Reason Code] as [Reason_Code],
        [Bill-to Customer No_] as [Bill_to_Customer_No],
        [Unit Price] as [Unit_Price],
        [Customer Price Group] as [Customer_Price_Group]
    FROM [gold].[Sales_Fact_All_Company]
    WHERE 
        [Description] IN ('Day Old Chick - Female - Layer', 'Day Old Chick - Female - Lohman', 'Day Old Chick - Female - Bovans')
        AND [Order_Conversion_Status] = 'Active Order'
) layer
WHERE 
    layer.waitingDay > 105
    AND CAST(layer.Unit_Price AS FLOAT) > 0 
    AND layer.[Customer_Price_Group] <> 'INTERCO'
