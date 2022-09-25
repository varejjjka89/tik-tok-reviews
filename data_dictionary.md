# Below is the ERD and data dictionary for tables created in BigQuery

![ERD](/screenshots/ERD.png)


## tiktok-raw
This table contains raw data, not recommended to use for analytical purposes 
<br>
|Field name |Type  |Description|
| --- | --- | ---|
|review_id|STRING|Unique identifier|
|user_name|STRING|Name of a User
|user_image|STRING|Profile image of a User|
|content|STRING|Field represents comments made by a User|
|score|STRING|Review score/rating between 1 and 5|
|thumbs_up_count|STRING|Number of Thumbs up received by a User|
|review_created_version|STRING|Version number on which the review is created|
|created_at|STRING|Date and time when User created the review (in STRING format)|
|reply_content|STRING|Comment to User reply by the Company|
|replied_at|STRING|Date and time when comment to User by the Company was made (in STRING format)|
<br>


## tiktok-fact
 FACT table, contains TikTok review_id and user_name 
 |Field name |Type  | Description|
 | --- | --- | ---|
 | review_id| STRING| Unique identifier|
 | user_name| STRING| Name of a User|
 
<br>

## tiktok-users-dim
 DIM table, contains TikTok users data 
 |Field name |Type  | Description|
 | --- | --- | ---|
 | user_name| STRING| Name of a User|
 |user_image| STRING| Profile image of a User|

 <br>

## tiktok-reviews-dim
 DIM table, contains TikTok reviews data 
 |Field name |Type  | Description|
 | --- | --- | ---|
 |review_id| STRING| Unique identifier|
 |user_comments| STRING| Comments made by a User|
 |user_score|INTEGER| Review scores/rating between 1 to 5|
 |review_version|STRING|Version number on which the review is created|
 |thumbs_up_count|INTEGER|Number of thumbs up received by a User|
 |review_created_date|DATE|Date when User created the review|
 |review_created_time|TIME|Time when User created the review|
 |review_created_dow|INTEGER|Day of the week when User created the review|

 <br>

 ## tiktok-replies-to-user-dim
 DIM table, contains TikTok replies to users data 
 |Field name |Type  | Description|
 | --- | --- | ---|
 |review_id| STRING| Unique identifier|
 |reply_to_review_content| STRING| Reply to the User review by the Company|
 |reply_to_review_date|DATE|Date of the reply to the User review by the Company|
 |reply_to_review_time|TIME|Time of the reply to the User review by the Company|

 <br>

## tiktok-user-score-analysis
This table contains aggregated data to help with scores analysis
<br>
|Field name |Type  | Description|
| --- | --- | ---|
|review_created_date|DATE|Date when User created the review
|review_created_hour|INTEGER|Hour of the day when User created the review
|review_created_dow|INTEGER|Day of the week when User created the review|
|review_created_dow_name|STRING|Name of the day of the week when User created the review|
|user_score_1|INTEGER|User score = 1|
|user_score_2|INTEGER|User score = 2|
|user_score_3|INTEGER|User score = 3|
|user_score_4|INTEGER|User score = 4|
|user_score_5|INTEGER|User score = 5|