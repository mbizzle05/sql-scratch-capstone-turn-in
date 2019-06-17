/* Query 1a - pulls data for all distinct campaigns being ran*/
SELECT DISTINCT utm_campaign
FROM page_visits;
/* Counts number of distinct campaigns from page_visits table*/
SELECT COUNT(DISTINCT utm_campaign) AS '#ofcampaigns'
FROM page_visits;
/* Query 1b - pulls data for all distinct sources campaigns use */
SELECT DISTINCT utm_source
FROM page_visits;
/* Counts the number of sources pulled from the page_visits table*/
SELECT COUNT(DISTINCT utm_source) AS '#ofsources'
FROM page_visits;
/* Query 1c - pulls data from page_visits table displaying which campaigns use which sources*/
SELECT DISTINCT utm_source,
                utm_campaign
FROM page_visits;

/* Query 2 - pulls DISTINCT page names from the page_visits table*/
SELECT DISTINCT page_name AS 'Page Names'
FROM page_visits;

/* Query 3 - creates a temporary table that aids in counting first touches  per campaign  */
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(ft.first_touch_at) AS '#of 1st Touches'
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;

/* Query 4 - creates a temporary table that aids in counting last touches per campaign */
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(lt.last_touch_at) AS '#of Last Touches'
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;

/* Query 5 - counts all distinct users that made it through to purchase page*/
SELECT COUNT(DISTINCT user_id) AS 'Buyers'
FROM page_visits
WHERE page_name = '4 - purchase';

/* Query 5b Extra - counts all distinct users that represent all visitors to the site*/
SELECT COUNT(DISTINCT user_id) AS 'Visitors'
FROM page_visits;

/* Query 6 - amended last touch query that shows which campaigns led to a purchase */
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
  	WHERE page_name = '4 - purchase'
    GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(lt.last_touch_at) AS '#of Buyers Last Touches'
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;
