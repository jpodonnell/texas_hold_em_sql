create function public.reset() returns void
language plpgsql
as $$
BEGIN
truncate table hands;
truncate table shuffled_deck;
truncate table community_cards;
END;
$$;
alter function public.reset() owner to postgres;
