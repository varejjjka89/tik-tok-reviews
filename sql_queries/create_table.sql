--Below are queried that I used to create tables in BigQuery

--FACT table contains TikTok review_id and user_name 
create table `tit-tok-reviews.tik_tok_reviews.tiktok-fact`
as 
select
review_id,
user_name
from `tit-tok-reviews.tik_tok_reviews.tiktok-raw`;

--DIM table, contains TikTok users data 
create table `tit-tok-reviews.tik_tok_reviews.tiktok-users-dim`
as
select
user_name,
user_image
from `tit-tok-reviews.tik_tok_reviews.tiktok-raw`;

--DIM table, contains TikTok reviews data 
--DIM table, contains TikTok reviews data 
create table `tit-tok-reviews.tik_tok_reviews.tiktok-reviews-dim`
as
select
review_id,
content as user_comments,
score as user_score,
review_created_version as review_version,
thumbs_up_count,
extract(date from TIMESTAMP (created_at)) AS review_created_date,
extract(time from TIMESTAMP (created_at)) AS review_created_time,
extract(DAYOFWEEK from TIMESTAMP (created_at)) AS review_created_dow
from `tit-tok-reviews.tik_tok_reviews.tiktok-raw`;


--DIM table, contains TikTok replies to users data 
create table `tit-tok-reviews.tik_tok_reviews.tiktok-replies-to-user-dim`
as
select
review_id,
reply_content as reply_to_review_content,
extract(date from TIMESTAMP (replied_at)) AS reply_to_comment_date,
extract(time from TIMESTAMP (replied_at)) AS reply_to_comment_time
from `tit-tok-reviews.tik_tok_reviews.tiktok-raw`;


--This table contains aggregated data to help with scores analysis 
create table `tit-tok-reviews.tik_tok_reviews.tiktok-user-score-analysis`
as 
select review_created_date, extract(HOUR from review_created_time) as review_created_hour, 
      review_created_dow,
      case when review_created_dow=1 then 'Sunday'
           when review_created_dow=2 then 'Monday'
           when review_created_dow=3 then 'Tuesday'
           when review_created_dow=4 then 'Wednesday'
           when review_created_dow=5 then 'Thursday'
           when review_created_dow=6 then 'Friday'
           when review_created_dow=7 then 'Saturday'
           end as review_created_dow_name,     
      case when cast(user_score as INT64) = 1
        then count(review_id)
        else 0
        end as user_score_1,
      case when cast(user_score as INT64) = 2
        then count(review_id)
        else 0
        end as user_score_2,
      case when cast(user_score as INT64) = 3
        then count(review_id)
        else 0
        end as user_score_3,
      case when cast(user_score as INT64) = 4
        then count(review_id)
        else 0
        end as user_score_4,
      case when cast(user_score as INT64) = 5
        then count(review_id)
        else 0
        end as user_score_5
from `tit-tok-reviews.tik_tok_reviews.tiktok-reviews-dim`
group by review_created_date, user_score, review_created_dow, review_created_hour, review_created_dow_name;
         