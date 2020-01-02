-- Name: play_game(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.play_game(players integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
    perform shuffle();
    perform deal(players);
    END;
$$;


ALTER FUNCTION public.play_game(players integer) OWNER TO postgres;
