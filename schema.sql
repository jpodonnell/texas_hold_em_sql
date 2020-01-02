--
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards (
    id integer NOT NULL,
    value character varying(2),
    suit character varying(1),
    number integer
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cards_id_seq OWNER TO postgres;

--
-- Name: cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cards_id_seq OWNED BY public.cards.id;


--
-- Name: community_cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.community_cards (
    hand_no integer,
    card_1_strength integer,
    card_2_strength integer,
    card_3_strength integer,
    card_4_strength integer,
    card_5_strength integer,
    burn_3_strength integer,
    burn_2_strength integer,
    burn_1_strength integer,
    burn_1_suit character(1),
    burn_2_suit character(1),
    burn_3_suit character(1),
    card_1_suit character(1),
    card_2_suit character(1),
    card_3_suit character(1),
    card_4_suit character(1),
    card_5_suit character(1),
    hand_rank integer
);


ALTER TABLE public.community_cards OWNER TO postgres;

--
-- Name: hand_ranks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hand_ranks (
    id integer NOT NULL,
    rank_description character varying(20)
);


ALTER TABLE public.hand_ranks OWNER TO postgres;

--
-- Name: hand_ranks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hand_ranks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hand_ranks_id_seq OWNER TO postgres;

--
-- Name: hand_ranks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hand_ranks_id_seq OWNED BY public.hand_ranks.id;


--
-- Name: hands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hands (
    id bigint NOT NULL,
    seat_no integer,
    hand_no integer,
    card_1_suit character(1),
    card_1_strength integer,
    card_2_suit character(1),
    card_2_strength integer,
    hand_rank integer
);


ALTER TABLE public.hands OWNER TO postgres;

--
-- Name: hands_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hands_id_seq OWNER TO postgres;

--
-- Name: hands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hands_id_seq OWNED BY public.hands.id;


--
-- Name: shuffled_deck; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shuffled_deck (
    id integer NOT NULL,
    place_in_deck integer NOT NULL
);


ALTER TABLE public.shuffled_deck OWNER TO postgres;

--
-- Name: shuffled_deck_place_in_deck_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shuffled_deck_place_in_deck_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shuffled_deck_place_in_deck_seq OWNER TO postgres;

--
-- Name: shuffled_deck_place_in_deck_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shuffled_deck_place_in_deck_seq OWNED BY public.shuffled_deck.place_in_deck;


--
-- Name: cards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards ALTER COLUMN id SET DEFAULT nextval('public.cards_id_seq'::regclass);


--
-- Name: hand_ranks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hand_ranks ALTER COLUMN id SET DEFAULT nextval('public.hand_ranks_id_seq'::regclass);


--
-- Name: hands id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hands ALTER COLUMN id SET DEFAULT nextval('public.hands_id_seq'::regclass);


--
-- Name: shuffled_deck place_in_deck; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shuffled_deck ALTER COLUMN place_in_deck SET DEFAULT nextval('public.shuffled_deck_place_in_deck_seq'::regclass);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: hand_ranks hand_ranks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hand_ranks
    ADD CONSTRAINT hand_ranks_pkey PRIMARY KEY (id);


--
-- Name: hands hands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hands
    ADD CONSTRAINT hands_pkey PRIMARY KEY (id);


--
-- Name: shuffled_deck shuffled_deck_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shuffled_deck
    ADD CONSTRAINT shuffled_deck_pkey PRIMARY KEY (id);


--
-- Name: shuffled_deck shuffled_deck_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shuffled_deck
    ADD CONSTRAINT shuffled_deck_id_fkey FOREIGN KEY (id) REFERENCES public.cards(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

