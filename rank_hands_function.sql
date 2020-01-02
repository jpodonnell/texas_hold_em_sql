--
-- Name: rank_hands(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rank_hands(hand_num integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE 
no_of_players int := 0;
player int := 1;
suit char(1) := 'E';
card_no int := 1;
min_card_value int := 0;
max_card_value int := 0;
BEGIN
no_of_players := max(seat_no) from hands where hand_no=hand_num;
while player <= no_of_players loop
--look for flush 
suit := a from (
select card_2_suit as a from hands where seat_no=player and hand_no=hand_num
union all 
select card_1_suit from hands where seat_no=player and hand_no=hand_num
union all
select card_1_suit from community_cards where hand_no=hand_num
union all
select card_2_suit from community_cards where hand_no=hand_num
union all
select card_3_suit from community_cards where hand_no=hand_num
union all
select card_4_suit from community_cards where hand_no=hand_num
union all
select card_5_suit from community_cards where hand_no=hand_num
) x where a != '' group by a having count(*) >=5;
if suit is not null then 
-- we have a flush check if straight
update hands set hand_rank = 99 where seat_no=player;
-- find the min strength and add 1, if you have another, continue
create temp table hand (hand_suit char(1), card_num int);

insert into hand (hand_suit, card_num)
select suit, card_1_strength from hands
where hand_no=hand_num and seat_no=player and card_1_suit=suit;
insert into hand (hand_suit, card_num)
select suit, card_2_strength from hands
where hand_no=hand_num and seat_no=player and card_2_suit=suit;
insert into hand (hand_suit, card_num)
select suit, card_1_strength from community_cards
where hand_no=hand_num and card_1_suit=suit;
insert into hand (hand_suit, card_num)
select suit, card_2_strength from community_cards
where hand_no=hand_num and card_2_suit=suit;
insert into hand (hand_suit, card_num)
select suit, card_3_strength from community_cards
where hand_no=hand_num and card_3_suit=suit;
insert into hand (hand_suit, card_num)
select suit, card_4_strength from community_cards
where hand_no=hand_num and card_4_suit=suit;
insert into hand (hand_suit, card_num)
select suit, card_5_strength from community_cards
where hand_no=hand_num and card_5_suit=suit;

min_card_value := min(card_num) from hand where hand_suit=suit;
max_card_value := max(card_num) from hand where hand_suit=suit;

if max_card_value - min_card_value = 4 then
--we have a straigh flush, royal flush wouldn't come in here
update hands set hand_rank = 90 where seat_no=player;
elsif min_card_value = 1 then
-- check if royal flush
min_card_value := min(card_num) from hand where hand_suit=suit and card_num != 1;
if min_card_value=10 then
--royal flush
update hands set hand_rank = 80 where seat_no=player;
end if;
end if;

end if;
--look for straight Ace can be high or low


--look for four of a kind

--look for three of a kind

--look for pairs

--determine highest card and suit
player := player + 1;
end loop;
drop table hand;
END;
$$;


ALTER FUNCTION public.rank_hands(hand_num integer) OWNER TO postgres;
