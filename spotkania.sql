--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2022-08-24 22:29:51

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16712)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 3120 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 228 (class 1255 OID 16794)
-- Name: ks_odpowiedzialny(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ks_odpowiedzialny() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM "odpowiedzialni" WHERE id_ksiadz=NEW."id_ksiadz";
    INSERT INTO "odpowiedzialni" ("id_ksiadz", "login", "id_posl", "data")
         VALUES(NEW."id_ksiadz",NEW."nazwisko", NEW."id_posl", NOW());
RETURN NEW;
END;
$$;


ALTER FUNCTION public.ks_odpowiedzialny() OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 16804)
-- Name: ks_remover(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ks_remover() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM "odpowiedzialni" WHERE id_ksiadz=OLD."id_ksiadz";
RETURN OLD;
END;
$$;


ALTER FUNCTION public.ks_remover() OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 16789)
-- Name: ks_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ks_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "ksiadz_log" ("imie","nazwisko", "id_posl_przed" ,"aktywnosc_przed", "mail_przed", "tel_przed", "data_zmiany")
         VALUES(OLD."imie",OLD."nazwisko",OLD."id_posl",OLD."aktywnosc",OLD."mail", OLD."tel",current_date);
RETURN NEW;
END;
$$;


ALTER FUNCTION public.ks_update() OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 16763)
-- Name: para_odpowiedzialni(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.para_odpowiedzialni() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "odpowiedzialni" ("id_para", "login", "id_posl", "data")
         VALUES(NEW."id_para",NEW."nazwisko", NEW."id_posl", NOW());
RETURN NEW;
END;
$$;


ALTER FUNCTION public.para_odpowiedzialni() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 206 (class 1259 OID 16514)
-- Name: dekanat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dekanat (
    id_dekanat integer NOT NULL,
    nazwa character(40),
    id_ksiadz integer,
    id_para integer
);


ALTER TABLE public.dekanat OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16438)
-- Name: ksiadz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ksiadz (
    id_ksiadz integer NOT NULL,
    imie character(30),
    nazwisko character(40),
    id_posl integer,
    aktywnosc boolean,
    mail character(60),
    tel character(15)
);


ALTER TABLE public.ksiadz OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 16506)
-- Name: ksiadz_id_ksiadz_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ksiadz_id_ksiadz_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ksiadz_id_ksiadz_seq OWNER TO postgres;

--
-- TOC entry 3121 (class 0 OID 0)
-- Dependencies: 205
-- Name: ksiadz_id_ksiadz_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ksiadz_id_ksiadz_seq OWNED BY public.ksiadz.id_ksiadz;


--
-- TOC entry 213 (class 1259 OID 16778)
-- Name: ksiadz_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ksiadz_log (
    id_zmiana integer NOT NULL,
    id_uzytkownik integer,
    imie character(30),
    nazwisko character(40),
    id_posl_przed integer,
    aktywnosc_przed boolean,
    mail_przed character(60),
    tel_przed character(15),
    data_zmiany date
);


ALTER TABLE public.ksiadz_log OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16776)
-- Name: ksiadz_log_id_zmiana_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ksiadz_log_id_zmiana_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ksiadz_log_id_zmiana_seq OWNER TO postgres;

--
-- TOC entry 3122 (class 0 OID 0)
-- Dependencies: 212
-- Name: ksiadz_log_id_zmiana_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ksiadz_log_id_zmiana_seq OWNED BY public.ksiadz_log.id_zmiana;


--
-- TOC entry 202 (class 1259 OID 16418)
-- Name: miejscowosc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.miejscowosc (
    nazwa character varying(40) NOT NULL,
    kod character varying(6)
);


ALTER TABLE public.miejscowosc OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16606)
-- Name: odpowiedzialni; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.odpowiedzialni (
    id integer NOT NULL,
    id_ksiadz integer,
    id_para integer,
    login character(40),
    haslo character(134),
    data timestamp(6) without time zone,
    id_posl integer
);


ALTER TABLE public.odpowiedzialni OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16604)
-- Name: odpowiedzialni_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.odpowiedzialni_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.odpowiedzialni_id_seq OWNER TO postgres;

--
-- TOC entry 3126 (class 0 OID 0)
-- Dependencies: 210
-- Name: odpowiedzialni_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.odpowiedzialni_id_seq OWNED BY public.odpowiedzialni.id;


--
-- TOC entry 207 (class 1259 OID 16529)
-- Name: parafia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parafia (
    id_parafia integer NOT NULL,
    wezwanie character(80),
    miejscowosc character(40),
    id_dekanat integer NOT NULL
);


ALTER TABLE public.parafia OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16448)
-- Name: pary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pary (
    id_para integer NOT NULL,
    imie_zona character(30),
    imie_maz character(30),
    nazwisko character(40),
    id_posl integer,
    aktywnosc boolean,
    email_zona character(60),
    email_maz character(60),
    tel_zona character(15),
    tel_maz character(15)
);


ALTER TABLE public.pary OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16395)
-- Name: poslugi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poslugi (
    id_posl integer NOT NULL,
    nazwa character varying(40)
);


ALTER TABLE public.poslugi OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 16544)
-- Name: spotkanie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.spotkanie (
    id_spotkanie integer NOT NULL,
    id_parafia integer,
    id_ksiadz integer,
    id_para integer,
    adres character(300),
    spotkanie_1 timestamp(2) without time zone,
    spotkanie_2 timestamp(2) without time zone,
    spotkanie_3 timestamp(2) without time zone,
    spotkanie_4 timestamp(2) without time zone,
    spotkanie_5 timestamp(2) without time zone,
    rekrutacja boolean,
    prog_opl boolean
);


ALTER TABLE public.spotkanie OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16564)
-- Name: uczestnicy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uczestnicy (
    id_user integer NOT NULL,
    id_spotkanie integer,
    imie_narzeczona character(30),
    nazwisko_narzeczona character(40),
    parafia_narzeczona character(300),
    email_narzeczona character(60),
    tel_narzeczona character(15),
    imie_narzeczony character(30),
    nazwisko_narzeczony character(40),
    parafia_narzeczony character(300),
    email_narzeczony character(60),
    tel_narzeczony character(15),
    czas_zgloszenia timestamp(6) without time zone,
    wplata boolean
);


ALTER TABLE public.uczestnicy OWNER TO postgres;

--
-- TOC entry 2933 (class 2604 OID 16781)
-- Name: ksiadz_log id_zmiana; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ksiadz_log ALTER COLUMN id_zmiana SET DEFAULT nextval('public.ksiadz_log_id_zmiana_seq'::regclass);


--
-- TOC entry 2932 (class 2604 OID 16609)
-- Name: odpowiedzialni id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odpowiedzialni ALTER COLUMN id SET DEFAULT nextval('public.odpowiedzialni_id_seq'::regclass);


--
-- TOC entry 3107 (class 0 OID 16514)
-- Dependencies: 206
-- Data for Name: dekanat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dekanat (id_dekanat, nazwa, id_ksiadz, id_para) FROM stdin;
1	Starogardzki                            	1	1
2	Skarszewski                             	2	2
\.


--
-- TOC entry 3104 (class 0 OID 16438)
-- Dependencies: 203
-- Data for Name: ksiadz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ksiadz (id_ksiadz, imie, nazwisko, id_posl, aktywnosc, mail, tel) FROM stdin;
1	Sławomir                      	Ałaszewski                              	5	t	cos@cos.com                                                 	888888888      
2	Wojciech                      	Klawikowski                             	5	t	login@serwer.ozn                                            	23153          
\.


--
-- TOC entry 3114 (class 0 OID 16778)
-- Dependencies: 213
-- Data for Name: ksiadz_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ksiadz_log (id_zmiana, id_uzytkownik, imie, nazwisko, id_posl_przed, aktywnosc_przed, mail_przed, tel_przed, data_zmiany) FROM stdin;
2	\N	Jan                           	Iksiński                                	3	t	                                                            	654321987      	2021-08-15
3	\N	Jan                           	Iksiński                                	3	t	login@serwer.com                                            	654321987      	2021-08-16
4	\N	Jan                           	Iksiński                                	3	t	login@serwer.com                                            	123456789      	2021-08-23
5	\N	Jan                           	Iksiński                                	\N	t	login@serwer.ozn                                            	888888888      	2021-08-23
6	\N	Jan                           	Iksiński                                	\N	t	login@serwer.ozn                                            	6081573        	2021-08-23
7	\N	Jan                           	Iksiński                                	4	t	login@serwer.ozn                                            	6081573        	2021-08-26
8	\N	Wojciech                      	Klawikowski                             	5	t	cos@cos.com                                                 	888888888      	2021-08-26
9	\N	Arkadiusz                     	Guz                                     	4	t	login@serwer.ozn                                            	677777777      	2021-08-26
\.


--
-- TOC entry 3103 (class 0 OID 16418)
-- Dependencies: 202
-- Data for Name: miejscowosc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.miejscowosc (nazwa, kod) FROM stdin;
Starogard Gdański	83-200
Tczew	83-110
Czarna Woda	83-?
Kartuzy	83
\.


--
-- TOC entry 3112 (class 0 OID 16606)
-- Dependencies: 211
-- Data for Name: odpowiedzialni; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.odpowiedzialni (id, id_ksiadz, id_para, login, haslo, data, id_posl) FROM stdin;
1	1	\N	Ałaszewski                              	$2y$12$MjAyMS0wNy0xOCAyMzo1Muyg0btOBqjv8CWQZ5HhMAB.TzJfwRHIu                                                                          	2021-07-18 23:53:31.852642	5
2	\N	1	Talarek                                 	$2y$12$MjAyMS0wNy0zMSAxMDo1M.9bptJLSQBaJvYoEYnX3jiBycW6ZH6xO                                                                          	2021-07-31 10:50:07.890176	5
8	2	\N	Klawikowski                             	\N	2021-08-26 22:53:49.464034	5
\.


--
-- TOC entry 3108 (class 0 OID 16529)
-- Dependencies: 207
-- Data for Name: parafia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parafia (id_parafia, wezwanie, miejscowosc, id_dekanat) FROM stdin;
1	św. Katarzyny Sieneńskiej                                                       	Starogard Gdański                       	1
2	Św Wojciecha                                                                    	Starogard Gdański                       	1
\.


--
-- TOC entry 3105 (class 0 OID 16448)
-- Dependencies: 204
-- Data for Name: pary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pary (id_para, imie_zona, imie_maz, nazwisko, id_posl, aktywnosc, email_zona, email_maz, tel_zona, tel_maz) FROM stdin;
2	Anna                          	Jerzy                         	Kowalscy                                	4	t	login@server.com                                            	login@server.com                                            	88888888       	88888888       
3	Zofia                         	Michał                        	Nowakowie                               	4	t	                                                            	                                                            	               	               
4	Agata                         	Waldemar                      	Michałowscy                             	5	f	                                                            	                                                            	               	               
1	Magdalena                     	Bartłomiej                    	Talarek                                 	5	t	login@server.com                                            	login@server.com                                            	88888888       	88888888       
\.


--
-- TOC entry 3102 (class 0 OID 16395)
-- Dependencies: 201
-- Data for Name: poslugi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.poslugi (id_posl, nazwa) FROM stdin;
1	WSPOMAGAJĄCY
2	PROWADZĄCY
3	ANIMATOR
5	KOORDYNATOR
4	ODPOWIEDZIALNY
\.


--
-- TOC entry 3109 (class 0 OID 16544)
-- Dependencies: 208
-- Data for Name: spotkanie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spotkanie (id_spotkanie, id_parafia, id_ksiadz, id_para, adres, spotkanie_1, spotkanie_2, spotkanie_3, spotkanie_4, spotkanie_5, rekrutacja, prog_opl) FROM stdin;
1	2	1	1	salka parafialna                                                                                                                                                                                                                                                                                            	2021-07-02 17:00:00	2021-07-09 17:00:00	2021-07-16 17:00:00	2021-07-23 17:00:00	2021-07-30 17:00:00	t	t
\.


--
-- TOC entry 3110 (class 0 OID 16564)
-- Dependencies: 209
-- Data for Name: uczestnicy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uczestnicy (id_user, id_spotkanie, imie_narzeczona, nazwisko_narzeczona, parafia_narzeczona, email_narzeczona, tel_narzeczona, imie_narzeczony, nazwisko_narzeczony, parafia_narzeczony, email_narzeczony, tel_narzeczony, czas_zgloszenia, wplata) FROM stdin;
1	1	Anna                          	jakaś                                   	Miłosierdzia STG                                                                                                                                                                                                                                                                                            	login@serwer.com                                            	888888888      	Michał                        	Oktan                                   	św Mateusza stg                                                                                                                                                                                                                                                                                             	mail@serwer.com                                             	888888888      	\N	\N
2	1	Zosia                         	Kosia                                   	Marii-Magdaleny Czersk                                                                                                                                                                                                                                                                                      	login@serwer.com                                            	888888888      	Krzysztof                     	Ktosik                                  	NSPJ Legbąd                                                                                                                                                                                                                                                                                                 	mail@serwer.com                                             	888888888      	\N	\N
\.


--
-- TOC entry 3130 (class 0 OID 0)
-- Dependencies: 205
-- Name: ksiadz_id_ksiadz_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ksiadz_id_ksiadz_seq', 1, false);


--
-- TOC entry 3131 (class 0 OID 0)
-- Dependencies: 212
-- Name: ksiadz_log_id_zmiana_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ksiadz_log_id_zmiana_seq', 9, true);


--
-- TOC entry 3132 (class 0 OID 0)
-- Dependencies: 210
-- Name: odpowiedzialni_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.odpowiedzialni_id_seq', 9, true);


--
-- TOC entry 2943 (class 2606 OID 16518)
-- Name: dekanat dekanat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dekanat
    ADD CONSTRAINT dekanat_pkey PRIMARY KEY (id_dekanat);


--
-- TOC entry 2953 (class 2606 OID 16783)
-- Name: ksiadz_log ksiadz_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ksiadz_log
    ADD CONSTRAINT ksiadz_log_pkey PRIMARY KEY (id_zmiana);


--
-- TOC entry 2939 (class 2606 OID 16442)
-- Name: ksiadz ksiadz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ksiadz
    ADD CONSTRAINT ksiadz_pkey PRIMARY KEY (id_ksiadz) WITH (fillfactor='10');


--
-- TOC entry 2937 (class 2606 OID 16422)
-- Name: miejscowosc mijscowosc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.miejscowosc
    ADD CONSTRAINT mijscowosc_pkey PRIMARY KEY (nazwa);


--
-- TOC entry 2951 (class 2606 OID 16611)
-- Name: odpowiedzialni odpowiedzialni_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odpowiedzialni
    ADD CONSTRAINT odpowiedzialni_pkey PRIMARY KEY (id);


--
-- TOC entry 2941 (class 2606 OID 16452)
-- Name: pary pary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pary
    ADD CONSTRAINT pary_pkey PRIMARY KEY (id_para);


--
-- TOC entry 2935 (class 2606 OID 16399)
-- Name: poslugi poslugi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poslugi
    ADD CONSTRAINT poslugi_pkey PRIMARY KEY (id_posl);


--
-- TOC entry 2945 (class 2606 OID 16533)
-- Name: parafia prafia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parafia
    ADD CONSTRAINT prafia_pkey PRIMARY KEY (id_parafia);


--
-- TOC entry 2947 (class 2606 OID 16548)
-- Name: spotkanie spotkanie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spotkanie
    ADD CONSTRAINT spotkanie_pkey PRIMARY KEY (id_spotkanie);


--
-- TOC entry 2949 (class 2606 OID 16571)
-- Name: uczestnicy uczestnicy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uczestnicy
    ADD CONSTRAINT uczestnicy_pkey PRIMARY KEY (id_user);


--
-- TOC entry 2969 (class 2620 OID 16790)
-- Name: ksiadz ksiadz_log_insert_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ksiadz_log_insert_trig BEFORE UPDATE ON public.ksiadz FOR EACH ROW EXECUTE FUNCTION public.ks_update();


--
-- TOC entry 2970 (class 2620 OID 16795)
-- Name: ksiadz ksiadz_odpowiedzialny; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ksiadz_odpowiedzialny AFTER INSERT OR UPDATE ON public.ksiadz FOR EACH ROW WHEN ((new.id_posl >= 3)) EXECUTE FUNCTION public.ks_odpowiedzialny();


--
-- TOC entry 2968 (class 2620 OID 16805)
-- Name: ksiadz ksiadz_remove; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ksiadz_remove BEFORE DELETE ON public.ksiadz FOR EACH ROW EXECUTE FUNCTION public.ks_remover();


--
-- TOC entry 2971 (class 2620 OID 16792)
-- Name: pary para_odpowiedzialni; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER para_odpowiedzialni AFTER INSERT OR UPDATE ON public.pary FOR EACH ROW WHEN ((new.id_posl >= 3)) EXECUTE FUNCTION public.para_odpowiedzialni();


--
-- TOC entry 2958 (class 2606 OID 16534)
-- Name: parafia dekanat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parafia
    ADD CONSTRAINT dekanat FOREIGN KEY (id_dekanat) REFERENCES public.dekanat(id_dekanat);


--
-- TOC entry 2964 (class 2606 OID 16612)
-- Name: odpowiedzialni id_ksiadz; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odpowiedzialni
    ADD CONSTRAINT id_ksiadz FOREIGN KEY (id_ksiadz) REFERENCES public.ksiadz(id_ksiadz) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2965 (class 2606 OID 16617)
-- Name: odpowiedzialni id_para; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odpowiedzialni
    ADD CONSTRAINT id_para FOREIGN KEY (id_para) REFERENCES public.pary(id_para) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2956 (class 2606 OID 16519)
-- Name: dekanat ksiadz; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dekanat
    ADD CONSTRAINT ksiadz FOREIGN KEY (id_ksiadz) REFERENCES public.ksiadz(id_ksiadz);


--
-- TOC entry 2960 (class 2606 OID 16549)
-- Name: spotkanie ksiadz; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spotkanie
    ADD CONSTRAINT ksiadz FOREIGN KEY (id_ksiadz) REFERENCES public.ksiadz(id_ksiadz);


--
-- TOC entry 2959 (class 2606 OID 16539)
-- Name: parafia miejsce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parafia
    ADD CONSTRAINT miejsce FOREIGN KEY (miejscowosc) REFERENCES public.miejscowosc(nazwa);


--
-- TOC entry 2957 (class 2606 OID 16524)
-- Name: dekanat para; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dekanat
    ADD CONSTRAINT para FOREIGN KEY (id_para) REFERENCES public.pary(id_para);


--
-- TOC entry 2961 (class 2606 OID 16554)
-- Name: spotkanie para; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spotkanie
    ADD CONSTRAINT para FOREIGN KEY (id_para) REFERENCES public.pary(id_para);


--
-- TOC entry 2962 (class 2606 OID 16559)
-- Name: spotkanie parafia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spotkanie
    ADD CONSTRAINT parafia FOREIGN KEY (id_parafia) REFERENCES public.parafia(id_parafia);


--
-- TOC entry 2954 (class 2606 OID 16443)
-- Name: ksiadz posl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ksiadz
    ADD CONSTRAINT posl FOREIGN KEY (id_posl) REFERENCES public.poslugi(id_posl);


--
-- TOC entry 2955 (class 2606 OID 16453)
-- Name: pary posl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pary
    ADD CONSTRAINT posl FOREIGN KEY (id_posl) REFERENCES public.poslugi(id_posl) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2966 (class 2606 OID 16751)
-- Name: odpowiedzialni posl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odpowiedzialni
    ADD CONSTRAINT posl FOREIGN KEY (id_posl) REFERENCES public.poslugi(id_posl) NOT VALID;


--
-- TOC entry 2967 (class 2606 OID 16784)
-- Name: ksiadz_log posl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ksiadz_log
    ADD CONSTRAINT posl FOREIGN KEY (id_posl_przed) REFERENCES public.poslugi(id_posl);


--
-- TOC entry 2963 (class 2606 OID 16572)
-- Name: uczestnicy spotkanie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uczestnicy
    ADD CONSTRAINT spotkanie FOREIGN KEY (id_spotkanie) REFERENCES public.spotkanie(id_spotkanie);


--
-- TOC entry 3123 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN odpowiedzialni.id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(id) ON TABLE public.odpowiedzialni TO login;


--
-- TOC entry 3124 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN odpowiedzialni.login; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(login) ON TABLE public.odpowiedzialni TO login;


--
-- TOC entry 3125 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN odpowiedzialni.haslo; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(haslo) ON TABLE public.odpowiedzialni TO login;


--
-- TOC entry 3127 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE parafia; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.parafia TO uczestnik;


--
-- TOC entry 3128 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE spotkanie; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.spotkanie TO uczestnik;


--
-- TOC entry 3129 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE uczestnicy; Type: ACL; Schema: public; Owner: postgres
--

GRANT INSERT ON TABLE public.uczestnicy TO uczestnik;


-- Completed on 2022-08-24 22:29:52

--
-- PostgreSQL database dump complete
--

