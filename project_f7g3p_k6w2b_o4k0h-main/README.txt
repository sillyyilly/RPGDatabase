QUERY CONTEXT AND ASSIGNMENT BREAKDOWN
This file shows how we divided up the query requirements, as well as what each query should accomplish

ANDY
- Selection: pick a table that user can freely choose WHERE clause with AND/OR - PlayableCharacter
- Projection: filter options on index.php for each table
- Join 2+ tables: user provides 1+ value in WHERE for querying - Find usernames, levels, and classes of chars who have worked on a specific quest

YILIAN
- INSERT: insert into Monster (has FK Defends)
- DELETE: delete Monster (ON DELETE CASCADE on BOSS, NEUTRAL)
- Aggregation with GROUP BY: avg level of each class (of playableCharacter)
- Division: find the levels of playable characters who have worked on every quest

AKSHAT
- UPDATE: update Monsters (has FK Defends)
- Aggregation with HAVING: find the level of the monster with the lowest level that is > 5, for each dungeon that has at least 2 monsters defending it
- Nested Aggregation with GROUP BY: Find all quest lengths that have an average reward higher than the average reward of all quests