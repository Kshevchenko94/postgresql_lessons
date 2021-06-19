
/*
DO LANGUAGE plpgsql
$$
DECLARE
	j	integer;
	k 	integer;
BEGIN
	k = 0;

	<<outer_cycle>>
	LOOP
		j = 0;
		k = k+1;

		RAISE NOTICE 'k = %', k;

		IF k > 9
		THEN
			EXIT outer_cycle;
		END IF;

		<<inner_cycle>>
		LOOP
			j = j+1;
			RAISE NOTICE 'j = %', j;

			IF j > 9
			THEN
				EXIT inner_cycle;
				-- EXIT outer_cycle;
			END IF;
		END LOOP inner_cycle;

	END LOOP outer_cycle;
END;
$$;

DO LANGUAGE plpgsql
$$
DECLARE
	j	integer;
BEGIN
	j = 0;

	<<outer_cycle>>
	WHILE j < 10
	LOOP

		j = j + 1;
		RAISE NOTICE 'j = %', j;

	END LOOP outer_cycle;
END;
$$;

DO LANGUAGE plpgsql
$$
DECLARE
	j	double precision;
BEGIN

	<<outer_cycle>>
	-- FOR j IN 1..10
	FOR j IN REVERSE 10.77..1.4 BY 2
	LOOP

		RAISE NOTICE 'j = %', j;

	END LOOP outer_cycle;
END;
$$;
*/
DO LANGUAGE plpgsql
$$
DECLARE
	--ar	integer[];
	ar	integer[][][];
	--x	integer;
	x	integer [];
BEGIN
	ar = ARRAY [1, 2, 3, 4, 5, 55, 44, 33, 22, 11];
--/*
	ar = ARRAY 	[
				[
				[21, 22, 23, 24, 25, 255, 24],
				[81, 82, 83, 84, 85, 855, 844]
				],
				[
				[51, 52, 53, 54, 55, 555, 544],
				[31, 32, 33, 34, 35, 355, 344]
				],
				[
				[61, 62, 63, 64, 65, 655, 64],
				[11, 12, 13, 14, 15, 155, 144]
				]
			];
--*/
	<<outer_cycle>>
	-- FOREACH x IN ARRAY ar
	FOREACH x SLICE 2 IN ARRAY ar
	LOOP
		RAISE NOTICE 'x = %', x;
	END LOOP outer_cycle;
END;
$$;





