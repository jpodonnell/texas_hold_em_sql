--
-- Name: play_multiple_games(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.play_multiple_games(number_of_games integer, players integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE 
count int := 1;
    BEGIN
    while count <= number_of_games loop
    perform shuffle();
    perform deal(players);
    perform rank_hands(count);
    count := count + 1;
    end loop;
    END;
$$;


ALTER FUNCTION public.play_multiple_games(number_of_games integer, players integer) OWNER TO postgres;
