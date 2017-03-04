#!/bin/bash

# Set start and end date
START_DATE="2017-03-07"  # YYYY-MM-DD
END_DATE="2017-03-24"    # YYYY-MM-DD

# Min and max commits per selected day
MIN_COMMITS=2
MAX_COMMITS=4

# Min and max days per month to commit
MIN_DAYS_PER_MONTH=8
MAX_DAYS_PER_MONTH=12

# Set author and committer name and email
AUTHOR_NAME="ricardojikal0311"
AUTHOR_EMAIL="15992876+ricardojikal0311@users.noreply.github.com"

# Updated commit messages from your extracted 20 logs
commit_messages=(
    "fix: adjust gitignore"
    "Initial commit"
    "Add circuit breaker event count metric"
    "Fix appExtensions filter"
    "Replace redis with valkey and run tests with valkey service"
    "Fix attribute over-fetching for pages"
    "Adjust app extension filters to new fields"
    "Fix empty country code in Address input"
    "Fix: AvataxPlugin: Correct tax calculation for duplicate variant lines"
    "Fix missing external shipping metadata on the order"
    "Unify webhooks metrics and attributes"
    "Fix flaky test for discount recalculation"
    "Fix negative unit price on gift line"
    "Do not trigger order_charged webhooks for draft orders"
    "Fix refund reason required for non-refund action"
    "Bump supported version"
    "Bump Django"
    "Fix voucher usage update for draft orders deletion"
    "Fix validate_attribute_owns_values"
    "Add new field on AssignedVariantAttributeValue"
)

# Convert START_DATE to first day of the month
current_date=$(date -d "$START_DATE" +"%Y-%m-01")

# Loop through each month in the date range
while [[ "$current_date" < "$END_DATE" ]] || [[ "$current_date" == "$END_DATE" ]]; do
    days_in_month=$(date -d "$current_date +1 month -1 day" +"%d")

    num_commit_days=$(( RANDOM % (MAX_DAYS_PER_MONTH - MIN_DAYS_PER_MONTH + 1) + MIN_DAYS_PER_MONTH ))

    commit_days=()
    while [[ ${#commit_days[@]} -lt $num_commit_days ]]; do
        random_day=$(( RANDOM % days_in_month + 1 ))
        if [[ ! " ${commit_days[@]} " =~ " $random_day " ]]; then
            commit_days+=("$random_day")
        fi
    done

    for day in "${commit_days[@]}"; do
        commit_date=$(date -d "$current_date +$((day-1)) days" +"%Y-%m-%d")

        num_commits=$(( RANDOM % (MAX_COMMITS - MIN_COMMITS + 1) + MIN_COMMITS ))

        for ((i=1; i<=num_commits; i++)); do
            commit_time=$(date -d "$commit_date $((RANDOM % 24)):$((RANDOM % 60)):$((RANDOM % 60))" +"%Y-%m-%d %H:%M:%S")

            commit_message=${commit_messages[$RANDOM % ${#commit_messages[@]}]}

            echo "Commit on $commit_time" >> dummy.txt

            git add .

            GIT_AUTHOR_NAME="$AUTHOR_NAME" GIT_AUTHOR_EMAIL="$AUTHOR_EMAIL" \
            GIT_COMMITTER_NAME="$AUTHOR_NAME" GIT_COMMITTER_EMAIL="$AUTHOR_EMAIL" \
            GIT_COMMITTER_DATE="$commit_time" GIT_AUTHOR_DATE="$commit_time" \
            git commit -m "$commit_message"
        done
    done

    current_date=$(date -d "$current_date +1 month" +"%Y-%m-01")
done
