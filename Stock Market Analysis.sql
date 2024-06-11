
#1- Buying Selling Signal#
    SELECT 
        year, quarter(Date),
		  trade_decision,
		round(AVG(RSI),2) AS 'RSI',
		round(AVG(MACD),2) AS 'MACD',
		round(AVG(`PE Ratio`),2) AS 'PE Ratio'
	FROM (
		SELECT 
		year,
			CASE
				WHEN (ROUND(`RSI (14 days)`, 2) < 45 AND ROUND(`MACD`, 2) > 0 AND ROUND(`PE Ratio`, 2) < 20) THEN 'Buy the Stocks'
				WHEN (ROUND(`RSI (14 days)`, 2) >= 69 AND ROUND(`MACD`, 2) < 0) THEN 'Sell the Stocks'
				ELSE 'Neutral Zone'
			END AS trade_decision,
			`RSI (14 days)` AS RSI,`MACD`,`PE Ratio`,Date
		FROM 
			main_2
		WHERE 
			ticker = "AAPL" and year= 2023
	) AS subquery
	GROUP BY 
		year, quarter(Date),trade_decision;
        
#2- Gain Loss In a day#
	SELECT 
	   T1.Date AS current_datex,
		T1.ticker,
		T1.Close AS current_price,
		T2.Close AS previous_price,
		CASE 
			WHEN T1.Close > T2.Close THEN 'Gain'
			WHEN T1.Close < T2.Close THEN 'Loss'
			ELSE 'No Change' 
		END AS price_change,
		concat(round(((T1.Close - T2.Close) / T2.Close) * 100, 2),'%') AS percentage_change
	FROM 
		main_2 AS T1
	LEFT JOIN 
		main_2 AS T2 
	ON 
		T1.ticker = T2.ticker
		AND T1.date = DATE_SUB(T2.date, INTERVAL 1 DAY)
		where T1.ticker="AAPL" and
        T2.close is not null;
        
        #3 Volatility with Rank#
        select year,ticker, round(avg(high-low),2) as AVg_Volatility, dense_rank() over(partition by year order by avg(high-low) asc)  as Ranking 
       from main_2
       where year in( 2022,2023)
       group by  year,ticker;
       
       # 4-Month With Highest Volume#
 WITH ranked_volumes AS (
    SELECT ticker,`Month Name`, Volume,
	ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY Volume DESC) AS volume_rank
    FROM 
        main_2)
SELECT ticker,`Month Name`, Volume AS Max_Volume
FROM 
    ranked_volumes
WHERE 
    volume_rank = 1
ORDER BY 
    ticker;
    
    # 5-Ticker Wise HighPrice and LowPrice by year#
SELECT
  Ticker,year,
  round(avg(High),2) AS High_Price,round(avg(Low),2) AS Low_Price
FROM main_2
GROUP BY Ticker,year order by year asc;

# 6-Ticker Wise OpenPrice and ClosePrice by year#
  Select Ticker,year,
 round(avg(Open),2) AS Opening_Price, round(avg(Close),2) AS Closing_Price
FROM main_2
GROUP BY Ticker,year order by year asc;
 
 # 7-Total Volume#
SELECT ticker, High, SUM(Volume) AS Total_Volume
FROM main_2
GROUP BY High;

# 8- Finding particular value in stock market #
Select * FROM main_2
 where volume = 6772285;

# 9- 2nd rank in stock market #
SELECT *
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY Low DESC) AS RowNum
    FROM 
       main_2
) AS RankedData
WHERE 
    RowNum = 2;
 
 # 10-Total Record Count #
SELECT COUNT(*) AS Total_Record_Count
FROM main_2; 

# 11- Highest Low Value #
SELECT ticker,MAX(Low) AS Highest_Low_Value
FROM main_2
group by ticker;

# 12 - Ranking of the table #
SELECT ticker,High, Low,ROW_NUMBER() OVER (ORDER BY Low) AS Ranking FROM main_2; 

 