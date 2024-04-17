WITH daily_aggregates AS (
  SELECT 
    DATE_TRUNC('day', transaction_time) AS transaction_day,
    SUM(transaction_amount) AS daily_total,count(*) as no_transactions
  FROM transactions
  GROUP BY transaction_day
),

t as
(select *, sum(daily_total) OVER (ORDER BY transaction_day ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as rolling_3_day_sum,
sum(no_transactions) OVER (ORDER BY transaction_day ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as rolling_3_day_total_transaction

from daily_aggregates
order by 1 desc)

select transaction_day, rolling_3_day_sum/rolling_3_day_total_transaction as mean
