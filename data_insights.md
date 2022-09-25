## Data insights

### Below is a sample analysis of scores that I got by exporting tiktok-user-score-analysis table to Data Studio 
![score_sample_anlysis](/screenshots/score_sample_analysis.png)

Insights from the graph:
- Most "popular" hour for leaving a review is ~4pm
- Sunday and Saturday are days when users leave most reviews. Users are least active mid-week (Wednesday)
- Most popular score left by users is 5. 1 takes the second place


Insight from sql queries:
- some replies to User reviews by the Company are recorded earlier than actual review date - data concern
    - e.g. <br>
        ![scores_sample_anlysis](/screenshots/review_response.png)
- out of 167,296 reviews only 51 Users got a response from the Company, ~0.03%
- reviews are created very frequently, more than 1 review per minute, should keep in mind when scheduling data ingestion

