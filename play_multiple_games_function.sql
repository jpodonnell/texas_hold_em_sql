--
-- Name: play_multiple_games(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.play_multiple_games(number_of_games integer, players integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE 
count int := 1;
hand_num int := 0;
    BEGIN
    while count <= number_of_games loop
    perform shuffle();
    perform deal(players);
    hand_num := max(hand_no) from hands;
    perform rank_hands(hand_num);
    count := count + 1;
    end loop;
    END;
$$;


ALTER FUNCTION public.play_multiple_games(number_of_games integer, players integer) OWNER TO postgres;
