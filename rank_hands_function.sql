--
-- Name: rank_hands(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rank_hands(hand_num integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE 
trips int := 0;
fours int := 0;
pairs int := 0;
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
update hands set hand_rank = 5 where seat_no=player and hand_no=hand_num;
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
update hands set hand_rank = 2 where seat_no=player and hand_no=hand_num;
elsif min_card_value = 1 then
-- check if royal flush
min_card_value := min(card_num) from hand where hand_suit=suit and card_num != 1;
if min_card_value=10 then
--royal flush
update hands set hand_rank = 1 where seat_no=player and hand_no=hand_num;
--if a royal flush, nothing is higher, exit out of the ranking function
return;

end if;
end if;

end if;
--look for straight Ace can be high or low

truncate table hand;
insert into hand (hand_suit, card_num)
select suit, card_1_strength from hands
where hand_no=hand_num and seat_no=player;
insert into hand (hand_suit, card_num)
select suit, card_2_strength from hands
where hand_no=hand_num and seat_no=player;
insert into hand (hand_suit, card_num)
select suit, card_1_strength from community_cards
where hand_no=hand_num;
insert into hand (hand_suit, card_num)
select suit, card_2_strength from community_cards
where hand_no=hand_num;
insert into hand (hand_suit, card_num)
select suit, card_3_strength from community_cards
where hand_no=hand_num;
insert into hand (hand_suit, card_num)
select suit, card_4_strength from community_cards
where hand_no=hand_num;
insert into hand (hand_suit, card_num)
select suit, card_5_strength from community_cards
where hand_no=hand_num;

--Find the lowest card num, look for one adjacent, repeat twice if none found, kick out
min_card_value := min(card_num) from hand;
--If the min card value is 1, that's an Ace so we need to check for a King
--if min_card_vlaue = 1 then

--setup the checks for pair/four of a kind/trips/full boat
create temp table card_counts (num_of_cards int, card_num int);

insert into card_counts(num_of_cards, card_num)
select count(*) as num_of_cards, card_num 
from hand group by card_num having count(*) >= 2;

trips := count(*) from card_counts where num_of_cards=3;
fours := count(*) from card_counts where num_of_cards=4;
pairs := count(*) from card_counts where num_of_cards=2;

--look for a full house
if (trips = 1 and pairs >=1) or trips = 2 
then 
--we have a full house
update hands set hand_rank = 4 where seat_no=player and hand_no=hand_num;
end if;
--look for four of a kind
if fours = 1 
then
update hands set hand_rank = 3 where seat_no=player and hand_no=hand_num;
end if;
--look for three of a kind
if trips >= 1 -- you have 3 of a kind, but don't set rank if it is already set
then 
update hands set hand_rank = 7 where seat_no=player and hand_no=hand_num and hand_rank is null;
end if;
--look for pairs

if pairs >= 2 then
update hands set hand_rank = 8 where seat_no=player and hand_no=hand_num and hand_rank is null;
end if;

if pairs = 1 then
update hands set hand_rank = 9 where seat_no=player and hand_no=hand_num and hand_rank is null;
end if;

--determine highest card and suit

update hand set card_num=14 where card_num=1;
update hands set high_card_1 =
select cast(card_num as varchar(2)) || ' ' ||  hand_suit from hand join suits
on hand_suit=suit_value
order by card_num, suit_rank limit 1;

update hands set high_card_2 =
select cast(card_num as varchar(2)) || ' ' ||  hand_suit from hand join suits
on hand_suit=suit_value
order by card_num, suit_rank offset 1 limit 1;

player := player + 1;
end loop;
drop table hand;
drop table card_counts;
END;
$$;


ALTER FUNCTION public.rank_hands(hand_num integer) OWNER TO postgres;
