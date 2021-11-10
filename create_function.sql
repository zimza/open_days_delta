CREATE FUNCTION `open_days_delta`(delta_datetime DATETIME, days_delta INT SIGNED, full_weekend BIT(1)) RETURNS datetime
BEGIN
    DECLARE delta_done INT(1) DEFAULT 0;
    DECLARE delta_todo INT(1) DEFAULT days_delta;
    DECLARE delta_unit INT(1) DEFAULT 1;
    DECLARE week_end VARCHAR(3) DEFAULT '1';

    IF full_weekend = 1
        THEN SELECT '1|7' INTO week_end;
    END IF;

    IF days_delta < 0
        THEN SELECT days_delta * -1, -1 INTO delta_todo, delta_unit;
    END IF;

    WHILE (delta_done < delta_todo)
    DO
        SELECT delta_datetime + INTERVAL delta_unit DAY INTO delta_datetime;
        IF (DAYOFWEEK(delta_datetime) NOT RLIKE week_end AND (SELECT COUNT(holiday_date) FROM holidays WHERE holiday_date = DATE(delta_datetime)) = 0)
            THEN SELECT delta_done + 1 INTO delta_done;
        END IF;
    END WHILE;

    RETURN delta_datetime;
END
