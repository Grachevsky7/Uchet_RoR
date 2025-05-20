--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

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

ALTER TABLE ONLY public.new_zakazs DROP CONSTRAINT fk_rails_a9cc913f8c;
ALTER TABLE ONLY public.new_zakazs DROP CONSTRAINT fk_rails_9afc164ccd;
ALTER TABLE ONLY public.obrashenies DROP CONSTRAINT fk_rails_7be4004b6d;
ALTER TABLE ONLY public.new_zakazs DROP CONSTRAINT fk_rails_72741da5f8;
ALTER TABLE ONLY public.obrashenies DROP CONSTRAINT fk_rails_46cd22c577;
ALTER TABLE ONLY public.obrashenies DROP CONSTRAINT fk_rails_23ad51024f;
DROP INDEX public.index_users_on_reset_password_token;
DROP INDEX public.index_users_on_email;
DROP INDEX public.index_obrashenies_on_specialist_id;
DROP INDEX public.index_obrashenies_on_po_id;
DROP INDEX public.index_obrashenies_on_klient_id;
DROP INDEX public.index_new_zakazs_on_specialist_id;
DROP INDEX public.index_new_zakazs_on_po_id;
DROP INDEX public.index_new_zakazs_on_klient_id;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.specialists DROP CONSTRAINT specialists_pkey;
ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
ALTER TABLE ONLY public.pos DROP CONSTRAINT pos_pkey;
ALTER TABLE ONLY public.obrashenies DROP CONSTRAINT obrashenies_pkey;
ALTER TABLE ONLY public.new_zakazs DROP CONSTRAINT new_zakazs_pkey;
ALTER TABLE ONLY public.klients DROP CONSTRAINT klients_pkey;
ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.specialists ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.pos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.obrashenies ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.new_zakazs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.klients ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.users_id_seq;
DROP TABLE public.users;
DROP SEQUENCE public.specialists_id_seq;
DROP TABLE public.specialists;
DROP TABLE public.schema_migrations;
DROP SEQUENCE public.pos_id_seq;
DROP TABLE public.pos;
DROP SEQUENCE public.obrashenies_id_seq;
DROP TABLE public.obrashenies;
DROP SEQUENCE public.new_zakazs_id_seq;
DROP TABLE public.new_zakazs;
DROP SEQUENCE public.klients_id_seq;
DROP TABLE public.klients;
DROP TABLE public.ar_internal_metadata;
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: klients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.klients (
    id bigint NOT NULL,
    name_komp character varying,
    kontakt_lico character varying,
    telef_kl character varying,
    pochta_kl character varying,
    adres_kl character varying,
    status boolean,
    s_delete boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.klients OWNER TO postgres;

--
-- Name: klients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.klients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.klients_id_seq OWNER TO postgres;

--
-- Name: klients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.klients_id_seq OWNED BY public.klients.id;


--
-- Name: new_zakazs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.new_zakazs (
    id bigint NOT NULL,
    po_id bigint NOT NULL,
    klient_id bigint NOT NULL,
    data_zak date,
    stat_zak character varying,
    specialist_id bigint NOT NULL,
    data_vypoln_zak date,
    stoimost_v_god numeric,
    srok_arendy integer,
    stoimost_zak numeric,
    dok_vypoln_zak_path character varying,
    chek_opl_zak_path character varying,
    status boolean,
    s_delete boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.new_zakazs OWNER TO postgres;

--
-- Name: new_zakazs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.new_zakazs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.new_zakazs_id_seq OWNER TO postgres;

--
-- Name: new_zakazs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.new_zakazs_id_seq OWNED BY public.new_zakazs.id;


--
-- Name: obrashenies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.obrashenies (
    id bigint NOT NULL,
    po_id bigint NOT NULL,
    klient_id bigint NOT NULL,
    tema_obr character varying,
    data_obr date,
    status_obr character varying,
    specialist_id bigint NOT NULL,
    data_vypoln_obr date,
    dok_vypoln_obr_path character varying,
    status boolean,
    s_delete boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.obrashenies OWNER TO postgres;

--
-- Name: obrashenies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.obrashenies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.obrashenies_id_seq OWNER TO postgres;

--
-- Name: obrashenies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.obrashenies_id_seq OWNED BY public.obrashenies.id;


--
-- Name: pos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos (
    id bigint NOT NULL,
    name_po character varying,
    vers_po character varying,
    data_vypuska_po date,
    stoimost_v_god_po numeric,
    status boolean,
    s_delete boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.pos OWNER TO postgres;

--
-- Name: pos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pos_id_seq OWNER TO postgres;

--
-- Name: pos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pos_id_seq OWNED BY public.pos.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: specialists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specialists (
    id bigint NOT NULL,
    fio_spec character varying,
    telef_spec character varying,
    pochta_spec character varying,
    dlzhnst_spec character varying,
    status_spec character varying,
    status boolean,
    s_delete boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.specialists OWNER TO postgres;

--
-- Name: specialists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specialists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.specialists_id_seq OWNER TO postgres;

--
-- Name: specialists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specialists_id_seq OWNED BY public.specialists.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    role integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: klients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klients ALTER COLUMN id SET DEFAULT nextval('public.klients_id_seq'::regclass);


--
-- Name: new_zakazs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.new_zakazs ALTER COLUMN id SET DEFAULT nextval('public.new_zakazs_id_seq'::regclass);


--
-- Name: obrashenies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obrashenies ALTER COLUMN id SET DEFAULT nextval('public.obrashenies_id_seq'::regclass);


--
-- Name: pos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos ALTER COLUMN id SET DEFAULT nextval('public.pos_id_seq'::regclass);


--
-- Name: specialists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialists ALTER COLUMN id SET DEFAULT nextval('public.specialists_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2024-11-02 13:11:09.256701	2024-11-02 13:11:09.256704
\.


--
-- Data for Name: klients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.klients (id, name_komp, kontakt_lico, telef_kl, pochta_kl, adres_kl, status, s_delete, created_at, updated_at) FROM stdin;
2	АО "УралМеталл"	Петров C.В.	+7 (343) 987-65-43	uralmetall@yandex.ru	Екатеринбург, пр. Мира, д. 5	f	f	2024-11-05 17:39:00.344026	2024-11-05 17:39:00.344026
3	ЗАО "СеверСтрой"	Сидоров В.О.	+7 (812) 333-22-11	severstroy@mail.ru	Санкт-Петербург, ул. Малая, д. 23	f	f	2024-11-05 17:39:39.773076	2024-11-05 17:39:39.773076
4	ООО "КузбассДобыча"	Николаева Н.Н.	+7 (384) 456-78-90	kuzbassdob@mail.ru	Кемерово, ул. Шахтерская, д. 15	f	f	2024-11-05 17:40:31.334524	2024-11-05 17:40:31.334524
5	ПАО "АвтоПром"	Смирнов А.К.	+7 (499) 654-32-10	avtoprom@yandex.ru	Москва, ул. Транспортная, д. 4	f	f	2024-11-05 17:41:14.27365	2024-11-05 17:41:14.27365
6	АО "ТрансЛогистика"	Кузнецов В.А.	+7 (421) 111-22-33	translog@mail.ru	Хабаровск, пр. Победы, д. 8	f	f	2024-11-05 17:41:45.76903	2024-11-05 17:41:45.76903
1	ООО "ГорТехСервис"	Иванов Л.А.	+7 (495) 123-45-67	gortech@yandex.ru	Москва, ул. Ленина, д. 10	f	f	2024-11-05 17:37:30.898607	2025-02-09 14:12:05.027017
\.


--
-- Data for Name: new_zakazs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.new_zakazs (id, po_id, klient_id, data_zak, stat_zak, specialist_id, data_vypoln_zak, stoimost_v_god, srok_arendy, stoimost_zak, dok_vypoln_zak_path, chek_opl_zak_path, status, s_delete, created_at, updated_at) FROM stdin;
5	2	2	2022-07-17	Выполнен	6	2022-08-05	5999000.0	3	17997000.0	/docs/ustanovka_4.pdf	/receipts/chek_4.pdf	f	f	2024-11-09 18:10:38.130927	2024-11-09 18:10:38.130927
6	3	3	2023-10-06	Выполнен	1	2023-10-26	8999000.0	5	44995000.0	/docs/ustanovka_5.pdf	/receipts/chek_5.pdf	f	f	2024-11-09 18:13:40.204721	2024-11-09 18:13:40.204721
1	4	1	2021-03-05	Выполнен	1	2021-03-20	1999000.0	3	5997000.0	/docs/ustanovka_1.pdf	/receipts/chek_1.pdf	f	f	2024-11-09 17:08:07.487988	2024-11-10 11:03:28.644518
4	1	3	2022-05-05	Выполнен	5	2022-05-15	2999000.0	1	2999000.0	/docs/ustanovka_3.pdf	/receipts/chek_3.pdf	f	f	2024-11-09 18:06:22.730388	2025-01-13 18:56:03.171225
12	2	2	2024-12-10	Выполнен	3	2024-12-20	5999000.0	3	17997000.0	/docs/ustanovka_7.pdf	/receipts/chek_7.pdf	f	f	2025-03-03 16:50:06.415187	2025-03-03 16:50:06.415187
7	6	2	2024-11-30	Выполнен	4	2024-12-10	5999000.0	4	23996000.0	/docs/ustanovka_6.pdf	/receipts/chek_6.pdf	f	f	2024-11-09 18:15:56.446683	2025-03-03 16:51:47.172237
13	1	2	2025-01-01	Выполнен	3	2025-02-15	2999000.0	4	11996000.0	/docs/ustanovka_8.pdf	/receipts/chek_8.pdf	f	f	2025-03-03 16:59:26.116096	2025-03-03 16:59:26.116096
\.


--
-- Data for Name: obrashenies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.obrashenies (id, po_id, klient_id, tema_obr, data_obr, status_obr, specialist_id, data_vypoln_obr, dok_vypoln_obr_path, status, s_delete, created_at, updated_at) FROM stdin;
1	4	1	Проблемы с установкой обновления	2021-07-20	Выполнено	2	2021-07-25	/doсs/service_1.pdf	f	f	2024-11-09 19:11:40.335094	2024-11-10 10:04:45.48667
3	2	2	Сбой в работе модуля	2023-12-15	Выполнено	1	2023-12-30	/doсs/service_3.pdf	f	f	2024-11-10 10:11:01.198384	2024-11-10 10:11:01.198384
4	6	6	Способы повышения безопасности	2024-12-20	В работе	3	\N		f	f	2024-11-10 10:15:55.422687	2024-11-10 10:15:55.422687
2	1	3	Ошибка при запуске	2022-10-07	Выполнено	2	2022-10-15	/doсs/service_2.pdf	f	f	2024-11-10 10:06:57.729741	2024-11-10 11:42:42.855446
\.


--
-- Data for Name: pos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos (id, name_po, vers_po, data_vypuska_po, stoimost_v_god_po, status, s_delete, created_at, updated_at) FROM stdin;
2	Zyfra Industrial IoT Platform	V2	2022-06-15	5999000	f	f	2024-11-05 00:00:00	2024-11-05 00:00:00
4	Диспетчер	V1	2020-12-20	1999000	f	f	2024-11-05 00:00:00	2024-11-05 00:00:00
5	Диспетчер	V2	2021-05-27	3999000	f	f	2024-11-05 00:00:00	2024-11-05 00:00:00
6	Диспетчер	V3	2022-08-13	5999000	f	f	2024-11-05 00:00:00	2024-11-05 00:00:00
1	Zyfra Industrial IoT Platform	V1	2022-03-23	2999000	f	f	2024-11-05 00:00:00	2025-02-07 19:56:12.993755
3	Zyfra Industrial IoT Platform	V3	2023-10-05	8999000	f	f	2024-11-05 00:00:00	2025-02-08 10:03:49.023696
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version) FROM stdin;
20241102131048
20241102161959
20241102162647
20241102163921
20241102164723
20241109154110
20241109161610
20250515173842
20250518212344
\.


--
-- Data for Name: specialists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.specialists (id, fio_spec, telef_spec, pochta_spec, dlzhnst_spec, status_spec, status, s_delete, created_at, updated_at) FROM stdin;
3	Кузнецов Алексей Викторович	+7 (925) 987-65-43	alex.kuznetsov@example.com	Тестировщик ПО	Готов к работе	f	f	2024-11-09 16:37:04.197189	2024-11-09 16:37:04.197189
2	Смирнова Анастасия Олеговна	+7 (903) 111-22-33	anastasia.smirnova@mail.ru	Консультант по безопасности	Готов к работе	f	f	2024-11-09 16:36:14.441004	2024-11-09 16:37:41.049458
4	Новиков Дмитрий Петрович	+7 (999) 123-45-67	d.novikov@yandex.ru	Архитектор ПО	Выполняет работу	f	f	2024-11-09 16:38:22.401532	2024-11-09 16:38:22.401532
5	Мельников Николай Андреевич	+7 (901) 567-89-10	nikolay.melnikov@gmail.com	Руководитель отдела ИТ	Выполняет работу	f	f	2024-11-09 16:41:51.128831	2024-11-09 16:44:31.638387
6	Петров Игорь Владимирович	 +7 (926) 123-00-55	igor.petrov@mail.ru	Инженер-программист	Выполняет работу	f	f	2024-11-09 16:43:54.58387	2024-11-09 18:09:03.934221
1	Иванов Петр Сергеевич	+7 (912) 345-67-89	petr.ivanov@gmail.com	Инженер-программист	Выполняет работу	f	f	2024-11-09 16:32:31.178029	2025-02-10 13:41:17.287216
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, role, created_at, updated_at) FROM stdin;
1	admin@example.com	$2a$12$Gf0tySR4OGrWbVy26Y/xZuDpp/e4H.jW5edU/DMUDqCFCjetyGGOC	\N	\N	\N	0	2025-05-18 21:37:26.077113	2025-05-19 20:03:19.802961
3	head@example.com	$2a$12$6Gizc5UApsL00L51IvEMnuRz33Ne0OKKbfyH/QsoVJnyrZkYwGBom	\N	\N	\N	2	2025-05-20 16:04:57.812479	2025-05-20 18:47:20.468922
2	manager@example.com	$2a$12$NB.lQkKCel61XCqapo3wqOu4lrhujRQgFz6gF6Rd1igmpcB3TFQLO	\N	\N	\N	1	2025-05-20 16:04:23.493583	2025-05-20 18:59:40.357492
\.


--
-- Name: klients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.klients_id_seq', 8, true);


--
-- Name: new_zakazs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.new_zakazs_id_seq', 13, true);


--
-- Name: obrashenies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.obrashenies_id_seq', 12, true);


--
-- Name: pos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pos_id_seq', 21, true);


--
-- Name: specialists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specialists_id_seq', 9, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: klients klients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klients
    ADD CONSTRAINT klients_pkey PRIMARY KEY (id);


--
-- Name: new_zakazs new_zakazs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.new_zakazs
    ADD CONSTRAINT new_zakazs_pkey PRIMARY KEY (id);


--
-- Name: obrashenies obrashenies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obrashenies
    ADD CONSTRAINT obrashenies_pkey PRIMARY KEY (id);


--
-- Name: pos pos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos
    ADD CONSTRAINT pos_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: specialists specialists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialists
    ADD CONSTRAINT specialists_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_new_zakazs_on_klient_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_new_zakazs_on_klient_id ON public.new_zakazs USING btree (klient_id);


--
-- Name: index_new_zakazs_on_po_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_new_zakazs_on_po_id ON public.new_zakazs USING btree (po_id);


--
-- Name: index_new_zakazs_on_specialist_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_new_zakazs_on_specialist_id ON public.new_zakazs USING btree (specialist_id);


--
-- Name: index_obrashenies_on_klient_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_obrashenies_on_klient_id ON public.obrashenies USING btree (klient_id);


--
-- Name: index_obrashenies_on_po_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_obrashenies_on_po_id ON public.obrashenies USING btree (po_id);


--
-- Name: index_obrashenies_on_specialist_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_obrashenies_on_specialist_id ON public.obrashenies USING btree (specialist_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: obrashenies fk_rails_23ad51024f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obrashenies
    ADD CONSTRAINT fk_rails_23ad51024f FOREIGN KEY (po_id) REFERENCES public.pos(id);


--
-- Name: obrashenies fk_rails_46cd22c577; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obrashenies
    ADD CONSTRAINT fk_rails_46cd22c577 FOREIGN KEY (klient_id) REFERENCES public.klients(id);


--
-- Name: new_zakazs fk_rails_72741da5f8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.new_zakazs
    ADD CONSTRAINT fk_rails_72741da5f8 FOREIGN KEY (klient_id) REFERENCES public.klients(id);


--
-- Name: obrashenies fk_rails_7be4004b6d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obrashenies
    ADD CONSTRAINT fk_rails_7be4004b6d FOREIGN KEY (specialist_id) REFERENCES public.specialists(id);


--
-- Name: new_zakazs fk_rails_9afc164ccd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.new_zakazs
    ADD CONSTRAINT fk_rails_9afc164ccd FOREIGN KEY (specialist_id) REFERENCES public.specialists(id);


--
-- Name: new_zakazs fk_rails_a9cc913f8c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.new_zakazs
    ADD CONSTRAINT fk_rails_a9cc913f8c FOREIGN KEY (po_id) REFERENCES public.pos(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

