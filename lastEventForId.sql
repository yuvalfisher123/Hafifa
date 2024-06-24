--chooses last event outside scope of dates
PREPARE event_query_outside_scope (BIGINT, BIGINT) AS 
	SELECT *
    FROM event evnt
    WHERE lut = (SELECT MAX(lut)
                FROM event second
                WHERE id = evnt.id)
    AND id = ANY (
        SELECT id
        FROM event
        WHERE lut BETWEEN 1705878051 AND 1710398320
    );

--chooses last event inside scope of dates
PREPARE event_query_inside_scope (BIGINT, BIGINT) AS 
	SELECT *
	FROM event evnt
	WHERE lut = (SELECT MAX(lut)
			FROM event second
			WHERE id = evnt.id
			AND lut BETWEEN $1 AND $2);
