-- Role: eCommerce Database Analyst

-- Web Traffic Analysis
-- Analyze traffic sources to determine where website sessions are originating.
-- Data Request Date: 2012-04-12
SELECT 	utm_source,
		utm_campaign,
        http_referer,
        COUNT(DISTINCT website_session_id) AS sessions
FROM 	website_sessions
WHERE 	created_at < '2012-04-12'
GROUP BY utm_source,
		 utm_campaign,
		 http_referer
ORDER BY sessions DESC;

-- Calculate the conversion rate (CVR) for the Gsearch non-brand campaign.
-- Data Request Date: 2012-04-14
SELECT 	utm_source,
		utm_campaign,
        COUNT(DISTINCT w.website_session_id) AS sessions,
        COUNT(DISTINCT o.order_id) AS orders,
        COUNT(o.order_id) / COUNT(DISTINCT w.website_session_id) AS session_to_order_conv_rt
FROM 	website_sessions AS w
	LEFT JOIN orders AS o
		ON		o.website_session_id = w.website_session_id
WHERE 	w.created_at < '2012-04-14' 
	AND		utm_source = 'gsearch'
	AND		utm_campaign = 'nonbrand'
GROUP BY utm_source,
		utm_campaign
ORDER BY sessions DESC;

-- Analyze weekly session trends for the Gsearch non-brand campaign following a bid reduction.
-- Data Request Date: 2012-05-10
SELECT	WEEK(created_at) AS wk,
		MIN(DATE(created_at)) AS week_start_date,
		COUNT(DISTINCT website_session_id) AS sessions
FROM	website_sessions
WHERE	created_at < '2012-05-10'
AND		utm_source = 'gsearch'
AND		utm_campaign = 'nonbrand'
GROUP BY 1;

-- Determine the CVR from session to order by device type to optimize bidding by segment.
-- Data Request Date: 2012-05-11
SELECT 	w.device_type,
		COUNT(w.website_session_id) AS sessions,
        COUNT(o.order_id) AS orders,
        COUNT(o.order_id) / COUNT(w.website_session_id) AS session_to_order_conv_rt 
FROM 	website_sessions AS w 
LEFT JOIN orders AS o
ON		o.website_session_id = w.website_session_id
WHERE	w.created_at < '2012-05-11'
AND		utm_source = 'gsearch'
AND		utm_campaign = 'nonbrand'
GROUP BY 1;

/* Evaluate the impact of increased desktop bids 
   by comparing desktop and mobile session trends between April 15, 2012, and June 6, 2012. */

SELECT  -- WEEK(created_at),
		MIN(DATE(created_at)) AS week_start_date,
        COUNT(CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS dtop_sessions,
        COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mob_sessions
		-- COUNT(DISTINCT website_session_id) AS sessions
FROM	website_sessions
WHERE	created_at BETWEEN '2012-04-15' AND '2012-06-09'
AND		utm_source = 'gsearch'
AND		utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at);
