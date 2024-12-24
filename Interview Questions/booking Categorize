 categorize bookings based on whether a customer was a first-timer, subscriber, or ex-subscriber and count of booking for each category--
 WITH ranked_bookings AS (
	SELECT id ,customer_id, start_dt,end_dt,
		LAG(end_dt)OVER(partition by customer_id order by start_dt) AS prev_end_dt
    FROM bookings
    ),
categorized_bookings as (
SELECT id , customer_id, start_dt,end_dt,
	CASE 
		WHEN prev_end_dt is null then "first_timer"
        WHEN prev_end_dt >= start_dt then "subscriber"
        ELSE  "EX-Subscriber"
        END AS  "category"
FROM ranked_bookings
)
SELECT category ,count(*) FROM categorized_bookings
GROUP BY(category)
