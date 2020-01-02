--
-- Name: deal(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.deal(players integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    DECLARE
    count int := 1;
    hand_num int := 0;
    seat_num int := 1;
    card_num int := 0;
    card_suit char(1) := 'E';
    BEGIN
    hand_num = coalesce(max(hands.hand_no),0)+1 from hands;
    -- deal out the first card
    while seat_num <= players loop
    card_num := number from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    card_suit := suit from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    insert into hands(seat_no, card_1_suit, card_1_strength, hand_no)
    values(seat_num,card_suit, card_num,hand_num);
    count := count + 1;
    seat_num := seat_num + 1;
    end loop;
    --reset the seat posistion
    seat_num := 1;
    -- deal out the second card
    while seat_num <= players loop 
    card_num := number from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    card_suit := suit from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;  
    
    update hands set card_2_strength = card_num,
    card_2_suit = card_suit
    where seat_no=seat_num
    and hand_no=hand_num;

    count := count + 1;
    seat_num := seat_num + 1;
    end loop;

    -- deal the community cards
    card_num := number from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    card_suit := suit from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    insert into community_cards(hand_no,burn_1_strength ,burn_1_suit)
    values(hand_num, card_num, card_suit);
    -- goto next card
    count := count + 1;
    
    card_num := number from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    card_suit := suit from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    
    update community_cards set card_1_strength  = card_num, card_1_suit=card_suit where community_cards.hand_no = hand_num; 

    -- goto next card
    count := count + 1;
    
    card_num := number from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    card_suit := suit from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    
    update community_cards set card_2_strength  = card_num, card_2_suit=card_suit where community_cards.hand_no = hand_num; 

    -- goto next card
    count := count + 1;
    
    card_num := number from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    card_suit := suit from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    
    update community_cards set card_3_strength  = card_num, card_3_suit=card_suit where community_cards.hand_no = hand_num; 

    -- goto next card
    count := count + 1;
    
    card_num := number from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    card_suit := suit from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    
    update community_cards set burn_2_strength  = card_num, burn_2_suit=card_suit where community_cards.hand_no = hand_num; 

    -- goto next card
    count := count + 1;
    
    card_num := number from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    card_suit := suit from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    
    update community_cards set card_4_strength = card_num, card_4_suit=card_suit where community_cards.hand_no = hand_num; 

    -- goto next card
    count := count + 1;
    
    card_num := number from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    card_suit := suit from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    
    update community_cards set burn_3_strength  = card_num, burn_3_suit=card_suit where community_cards.hand_no = hand_num; 

    -- goto next card
    count := count + 1;
    
    card_num := number from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    card_suit := suit from cards join shuffled_deck on
    shuffled_deck.id=cards.id where place_in_deck=count;
    
    update community_cards set card_5_strength = card_num, card_5_suit=card_suit where community_cards.hand_no = hand_num; 

    END;
$$;


ALTER FUNCTION public.deal(players integer) OWNER TO postgres;
