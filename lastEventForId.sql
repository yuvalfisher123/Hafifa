--chooses last event outside scope of dates
PREPARE event_query_outside_scope (BIGINT, BIGINT) AS 
	WITH ids_in_dates AS (
	SELECT DISTINCT id
	FROM event
	WHERE lut BETWEEN $1 AND $2
	),
	ranked_ids AS (
	SELECT *, ROW_NUMBER () OVER (PARTITION BY id ORDER BY lut DESC) AS rank_number
	FROM event
	)
	
    SELECT ranked.id, lut, name, longitude, latitude, description
    FROM ranked_ids ranked
    INNER JOIN ids_in_dates in_date
    ON ranked.id = in_date.id
    WHERE rank_number = 1

--chooses last event inside scope of dates
PREPARE event_query_inside_scope (BIGINT, BIGINT) AS 
    WITH ids_in_dates AS
	(
        SELECT *, ROW_NUMBER () OVER (PARTITION BY id ORDER BY lut DESC) AS rank_number
        FROM event
        WHERE lut BETWEEN $1 AND $2
	)

    SELECT id, lut, name, longitude, latitude, description
    FROM ids_in_dates
    WHERE rank_number = 1;