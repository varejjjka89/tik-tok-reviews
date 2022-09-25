--Below are sample queries that analyst can run to help answer some questions regarding the data

--how many unique users were studied 
select count (distinct user_name) --154271
from `tit-tok-reviews.tik_tok_reviews.ttiktok-users-dim`;

--------------------------------------------------------------------

--average score for all reviews
select avg(user_score) --~4.3
from `tit-tok-reviews.tik_tok_reviews.ttiktok-reviews-dim`;

--------------------------------------------------------------------

/*
date range of the dataset
depends on what we're looking at: when users created review or when they got replies from the Company
*/
--date range on review_created_date 
select date_diff(max(review_created_date), min(review_created_date), day) --41 days
from `tit-tok-reviews.tik_tok_reviews.ttiktok-reviews-dim`;

--date range on reply_to_comment_date 
select date_diff(max(reply_to_comment_date), min(reply_to_comment_date), day) --1256 days
from `tit-tok-reviews.tik_tok_reviews.ttiktok-replies-to-user-dim`;

--------------------------------------------------------------------

--data patterns--

--some replies to User reviews by the Company are recorded earlier than actual review date - data concern
select c.review_created_date, b.reply_to_comment_date
from `rtit-tok-reviews.tik_tok_reviews.ttiktok-fact` a
join `tit-tok-reviews.tik_tok_reviews.ttiktok-replies-to-user-dim` b
       on a.review_id = b.review_id 
join `tit-tok-reviews.tik_tok_reviews.tiktok-reviews-dim` c
       on a.review_id = c.review_id
where b.reply_to_comment_date<c.review_created_date;

--out of 167296 reviews only 51 got a response, ~0.03%
select count(*)
from `tit-tok-reviews.tik_tok_reviews.tiktok-reviews-dim` a
join `tit-tok-reviews.tik_tok_reviews.tiktok-replies-to-user-dim` b
       on a.review_id = b.review_id
where b.reply_to_review_content is not null;

--several reviews are being created every minute, very frequently - keep in mind when schedule
select review_created_date, review_created_time
from `tit-tok-reviews.tik_tok_reviews.tiktok-reviews-dim`
order by review_created_date, review_created_time;

--looking at tiktok-user-score-analysis table
--most frequent desc: 5, 1, 4, 3, 2
--most "popular" hour for leaving a review ~4pm
--Sunday and Saturday are days when users leave most reviews
select sum(user_score_1) as user_score_1, --20288
       sum(user_score_2) as user_score_2, --4440
       sum(user_score_3) as user_score_3, --6542
       sum(user_score_4) as user_score_4, --9855
       sum(user_score_5) as user_score_5  --126171
from `tit-tok-reviews.tik_tok_reviews.tiktok-user-score-analysis`;


--------------------------------------------------------------------

--does review score change depending on the day, date, or time

--created tiktok-user-score-analysis table to get insights, used Data Studio as out of the box tool

--------------------------------------------------------------------

--does a scenario exist that a user has more than one review, are reviews approx the same
select a.user_name, max(b.user_score) as max_score, min(b.user_score) as min_score, avg(b.user_score) as avg_score
from `tit-tok-reviews.tik_tok_reviews.tiktok-fact` a
join `tit-tok-reviews.tik_tok_reviews.tiktok-reviews-dim` b
      on a.review_id = b.review_id
where a.user_name in (
  select user_name
  from `tit-tok-reviews.tik_tok_reviews.tiktok-fact`
  group by user_name 
  having count(*) > 1 
)
group by a.user_name;


--------------------------------------------------------------------

--distinct review versions
select distinct review_version
from `tit-tok-reviews.tik_tok_reviews.tiktok-reviews-dim`;

--review versions if want to see separately major, minor versions
with t0
as
(select split(review_version, '.')[offset(0)] as major_version,
       split(review_version, '.')[offset(1)] as minor_version,
       split(review_version, '.')[offset(2)] as minor_sub_version,
from `tit-tok-reviews.tik_tok_reviews.tiktok-reviews-dim`
where review_version is not null)
select distinct major_version  --minor_version, minor_sub_version
from t0;

--------------------------------------------------------------------

--users that got a response to a review
select a.user_name
from `tit-tok-reviews.tik_tok_reviews.tiktok-fact` a
join `tit-tok-reviews.tik_tok_reviews.tiktok-replies-to-user-dim` b
       on a.review_id = b.review_id
where b.reply_to_review_content is not null;

--------------------------------------------------------------------
--tone of response
--GCP has a Cloud Natural Language API that has capabilities to do Sentiment Analysis
--Python NLTK can help with Sentiment Analysis
--simple "guess words" query to get a feel of responses
select reply_to_review_content, 
       REGEXP_CONTAINS(reply_to_review_content, r'good|great|awesome|pleas|thank|great|sorry|apolog') AS positive_response,
       REGEXP_CONTAINS(reply_to_review_content, r'confus|bother|fuss|hardly') AS confused_response,
       REGEXP_CONTAINS(reply_to_review_content, r'ang|annoy|awful|bad|disgust|dull') AS negative_response
from `tit-tok-reviews.tik_tok_reviews.tiktok-replies-to-user-dim`
where reply_to_review_content is not null




