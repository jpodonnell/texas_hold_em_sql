
--
-- Name: shuffle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.shuffle() RETURNS void
    LANGUAGE plpgsql
    AS $$
    DECLARE
    count int := 1;
    card int := 1;
    exists int := 0; 
    BEGIN
    alter sequence shuffled_deck_place_in_deck_seq restart with 1;
    truncate table shuffled_deck;
        while count <= 52 
        loop
         card = floor(random() *(52-1+1)+1);
     exists =  count(*) from shuffled_deck where id=card;
        if exists = 0 then
         insert into shuffled_deck(id) values(card); 
         count := count + 1;
        end if;
        end loop;
    END;
$$;


ALTER FUNCTION public.shuffle() OWNER TO postgres;

