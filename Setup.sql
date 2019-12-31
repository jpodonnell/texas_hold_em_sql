
create table cards(id serial primary key, value varchar(2), suit varchar(1));
create table shuffled_deck(id int primary key references cards(id));
create table hands(id bigserial primary key, seat_no int, card_1 varchar(3), card_2 varchar(3), hand_no int);
create table community_cards(hand_no int, burn_1 varchar(3), card_1 varchar(3), card_2 varchar(3), 
card_3 varchar(3), burn_2 varchar(3), card_4 varchar(3), burn_3 varchar(3), card_5 varchar(3));

CREATE or replace FUNCTION shuffle() RETURNS void AS $$
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
$$ LANGUAGE plpgsql;
/*
jp_poker=# insert into cards(value, suit) values
jp_poker-# ('A','D'),('K','D'),('Q','D'),('J','D'),(10,'D'),(9,'D'),(8,'D'),(7,'D'),(6,'D'),(5,'D'),(4,'D'),(3,'D'),(2,'D');
INSERT 0 13
jp_poker=# insert into cards(value, suit) select value, 'S' from cards where suit='D';
INSERT 0 13
jp_poker=# insert into cards(value, suit) select value, 'C' from cards where suit='D';
INSERT 0 13
jp_poker=# insert into cards(value, suit) select value, 'H' from cards where suit='D';
INSERT 0 13
*/



CREATE or replace FUNCTION deal(players int) RETURNS void AS $$
    DECLARE
    	count int := 1;
    	hand_num int := 0;
    	seat_no int := 1;
    	community_id int := 0;
    	card varchar(3) := 'XYZ';
    BEGIN
    	hand_num = coalesce(max(hands.hand_no),0)+1 from hands;
    	-- deal out the first card
    	while seat_no <= players loop
    		card := value || suit from cards join shuffled_deck on
    		shuffled_deck.id=cards.id where place_in_deck=count;
    		insert into hands(seat_no, card_1, hand_no)
    		values(seat_no,card,hand_num);
    		count := count + 1;
    		seat_no := seat_no + 1;
    	end loop;
    	--reset the seat posistion
    	seat_no := 1;
    	-- deal out the second card
    	while seat_no <= players loop 
    		card := value || suit from cards join shuffled_deck on
    		shuffled_deck.id=cards.id where place_in_deck=count;   	
    		insert into hands(seat_no, card_2, hand_no)
    		values(seat_no,card,hand_num);
    		count := count + 1;
    		seat_no := seat_no + 1;
    	end loop;

    	-- deal the community cards
    	card := value || suit from cards join shuffled_deck on
    	shuffled_deck.id=cards.id where place_in_deck=count;
    	insert into community_cards(hand_no,burn_1)
    	values(hand_num, card);
    	-- goto next card
    	count := count + 1;
    	
    	card := value || suit from cards join shuffled_deck on
    	shuffled_deck.id=cards.id where place_in_deck=count;
    	
    	update community_cards set card_1 = card where community_cards.hand_no = hand_num; 

    	-- goto next card
    	count := count + 1;
    	
    	card := value || suit from cards join shuffled_deck on
    	shuffled_deck.id=cards.id where place_in_deck=count;
    	
    	update community_cards set card_2 = card where community_cards.hand_no = hand_num; 

    	-- goto next card
    	count := count + 1;
    	
    	card := value || suit from cards join shuffled_deck on
    	shuffled_deck.id=cards.id where place_in_deck=count;
    	
    	update community_cards set card_3 = card where community_cards.hand_no = hand_num; 

    	-- goto next card
    	count := count + 1;
    	
    	card := value || suit from cards join shuffled_deck on
    	shuffled_deck.id=cards.id where place_in_deck=count;
    	
    	update community_cards set burn_2 = card where community_cards.hand_no = hand_num; 

    	-- goto next card
    	count := count + 1;
    	
    	card := value || suit from cards join shuffled_deck on
    	shuffled_deck.id=cards.id where place_in_deck=count;
    	
    	update community_cards set card_4 = card where community_cards.hand_no = hand_num; 

    	-- goto next card
    	count := count + 1;
    	
    	card := value || suit from cards join shuffled_deck on
    	shuffled_deck.id=cards.id where place_in_deck=count;
    	
    	update community_cards set burn_3 = card where community_cards.hand_no = hand_num; 

    	-- goto next card
    	count := count + 1;
    	
    	card := value || suit from cards join shuffled_deck on
    	shuffled_deck.id=cards.id where place_in_deck=count;
    	
    	update community_cards set card_5 = card where community_cards.hand_no = hand_num; 

    END;
$$ LANGUAGE plpgsql;



CREATE or replace function play_game(players int) RETURNS void AS $$
    BEGIN
    	perform shuffle();
    	perform deal(players);
    END;
$$ LANGUAGE plpgsql;

