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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: achievement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.achievement (
    id integer NOT NULL,
    user_id integer NOT NULL,
    badge character varying(50),
    date_earned timestamp without time zone NOT NULL
);


ALTER TABLE public.achievement OWNER TO postgres;

--
-- Name: achievement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.achievement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.achievement_id_seq OWNER TO postgres;

--
-- Name: achievement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.achievement_id_seq OWNED BY public.achievement.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: publication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publication (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    authors character varying(200) NOT NULL,
    year integer NOT NULL,
    type character varying(50) NOT NULL,
    status character varying(50) NOT NULL,
    file_url character varying(200),
    user_id integer,
    updated_at timestamp without time zone NOT NULL,
    published_at timestamp without time zone
);


ALTER TABLE public.publication OWNER TO postgres;

--
-- Name: publication_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.publication_id_seq OWNER TO postgres;

--
-- Name: publication_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publication_id_seq OWNED BY public.publication.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash text,
    role character varying(20),
    last_name character varying(100),
    first_name character varying(100),
    middle_name character varying(100),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: achievement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievement ALTER COLUMN id SET DEFAULT nextval('public.achievement_id_seq'::regclass);


--
-- Name: publication id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication ALTER COLUMN id SET DEFAULT nextval('public.publication_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: achievement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.achievement (id, user_id, badge, date_earned) FROM stdin;
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
2d4211b11c69
\.


--
-- Data for Name: publication; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publication (id, title, authors, year, type, status, file_url, user_id, updated_at, published_at) FROM stdin;
1462	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334986	\N
1463	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334987	\N
1464	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334989	\N
1461	On the Electrodynamics of Moving Bodies	Albert Einsteinaa	1905	article	draft	\N	16	2025-02-26 00:59:17.37943	\N
58	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-24 22:07:45.379718	\N
57	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-24 22:07:51.362658	\N
59	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-24 22:07:59.993264	\N
60	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	D:\\publication-system\\backend\\uploads\\Spasi_i_Sokhrani.docx	7	2025-02-24 22:08:10.73348	\N
1300	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 01:50:19.371144	\N
1301	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 01:50:19.371146	\N
266	dsfsd	dsfsdf	1999	monograph	draft	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-23 14:31:37.540946	\N
1302	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 01:50:19.371147	\N
279	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.19616	\N
1303	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 01:50:19.371148	\N
1304	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 01:50:19.37115	\N
201	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	16	2025-02-23 14:20:23.893653	\N
238	ddsdf	test1	2015	article	draft	\N	16	2025-02-23 14:22:23.840328	\N
239	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840331	\N
240	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840334	\N
241	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840335	\N
242	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840337	\N
243	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840338	\N
244	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.84034	\N
245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840341	\N
246	Sham	test2	2010	article	draft	\N	16	2025-02-23 14:22:23.840343	\N
247	длолд	ирмтми	2015	article	draft	\N	16	2025-02-23 14:22:23.840344	\N
202	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	16	2025-02-23 14:26:22.288641	\N
203	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	D:\\publication-system\\backend\\uploads\\-17.pdf	16	2025-02-23 14:27:47.381078	\N
280	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.196161	\N
281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.196163	\N
282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.196164	\N
283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.196165	\N
284	Sham	test2	2010	article	draft	\N	16	2025-02-24 00:59:03.196167	\N
285	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 00:59:03.196168	\N
292	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642273	\N
293	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642275	\N
294	Sham	test2	2010	article	draft	\N	16	2025-02-24 01:00:46.642276	\N
295	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 01:00:46.642278	\N
296	dfg	dfgdfg	2023	article	draft	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-24 01:00:54.560153	\N
278	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	monograph	draft	\N	16	2025-02-24 09:55:47.847765	\N
208	Robotics and Automation	Evans, Linda	2021	conference	draft	\N	16	2025-02-24 09:55:56.247374	\N
302	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376241	\N
303	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376243	\N
304	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376244	\N
305	Sham	test2	2010	article	draft	\N	16	2025-02-24 09:56:22.376246	\N
306	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 09:56:22.376247	\N
307	dssfsdf	TheShamRio	2024	monograph	draft	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-24 10:07:06.497205	\N
308	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-24 10:07:13.615422	\N
61	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
309	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-24 10:07:13.615425	\N
310	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-24 10:07:13.615427	\N
311	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-24 10:07:13.61543	\N
312	dfd	sdfs	2022	article	draft	\N	16	2025-02-24 10:07:13.615431	\N
313	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615433	\N
314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615434	\N
1305	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371151	\N
1306	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371153	\N
1307	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371154	\N
1308	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371155	\N
1309	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371157	\N
1310	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371158	\N
1400	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.334891	\N
210	dfd	sdfs	2022	article	draft	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	16	2025-02-22 20:41:58.894679	\N
211	ddsdf	test1	2015	article	draft	\N	16	2025-02-22 20:42:02.54765	\N
212	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547654	\N
213	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547656	\N
214	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547658	\N
1401	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.334895	\N
215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547659	\N
1402	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.334896	\N
216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547661	\N
217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547662	\N
218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547664	\N
297	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 09:56:22.37623	\N
298	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376234	\N
299	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376236	\N
219	Sham	test2	1993	monograph	draft	D:\\publication-system\\backend\\uploads\\-17.pdf	16	2025-02-22 21:54:16.612963	\N
248	ddsdf	test1	2015	article	draft	\N	16	2025-02-23 14:22:31.780013	\N
249	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780017	\N
250	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780019	\N
251	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.78002	\N
252	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780022	\N
253	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780024	\N
254	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780025	\N
255	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780027	\N
256	Sham	test2	2010	article	draft	\N	16	2025-02-23 14:22:31.780028	\N
267	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 00:58:54.707625	\N
268	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707629	\N
269	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707632	\N
270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707633	\N
271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707635	\N
272	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707637	\N
273	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707638	\N
274	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.70764	\N
275	Sham	test2	2010	article	draft	\N	16	2025-02-24 00:58:54.707641	\N
286	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 01:00:46.642261	\N
287	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642264	\N
288	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642267	\N
289	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642269	\N
290	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.64227	\N
291	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642272	\N
1403	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.334898	\N
1404	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.3349	\N
1405	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334901	\N
300	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376238	\N
171	ddsdf	test1	2015	article	draft	\N	5	2025-02-22 19:20:19.605391	\N
160	Разработка автоматизированнной системы	Шамиль и Виталик	2025	article	draft	\N	13	2025-02-22 12:23:17.724248	\N
161	ddsdf	test1	2015	article	draft	\N	13	2025-02-22 12:23:32.177094	\N
19	Тестовая публикация #1	Иван Иванов	2025	article	draft	D:\\publication-system\\backend\\uploads\\2.docx	5	2025-02-22 11:46:50.845599	\N
301	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.37624	\N
1406	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334903	\N
162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177098	\N
125	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	review	\N	7	2025-02-22 11:53:22.366745	\N
163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.1771	\N
164	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177102	\N
165	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177103	\N
166	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177105	\N
167	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177106	\N
168	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177108	\N
106	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605395	\N
173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605397	\N
174	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605399	\N
175	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605401	\N
176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605403	\N
108	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
177	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605404	\N
178	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605406	\N
181	testik	testik	1999	conference	draft	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	\N	2025-02-22 19:46:07.862543	\N
180	Разработка автоматизированнной системы	Шамиль и Виталик	2025	article	draft	\N	5	2025-02-22 19:20:19.605409	\N
220	ddsdf	test1	2015	article	draft	\N	16	2025-02-22 22:32:27.172143	\N
221	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172148	\N
222	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.17215	\N
223	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172152	\N
224	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172153	\N
225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172155	\N
226	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172156	\N
227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172158	\N
228	Sham	test2	2010	article	draft	\N	16	2025-02-22 22:32:27.172159	\N
257	ddsdf	test1	2015	article	draft	\N	16	2025-02-23 14:26:08.310116	\N
258	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310119	\N
259	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310121	\N
64	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
66	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
67	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
68	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
69	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
70	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
71	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
72	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
73	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
74	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
44	lol2	lol2	2011	article	draft	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	7	2025-02-22 22:41:06.997614	\N
75	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
76	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
77	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
1407	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334905	\N
1408	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334906	\N
1409	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334908	\N
1410	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33491	\N
50	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
1411	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334911	\N
1412	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334912	\N
1413	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334914	\N
78	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
79	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
80	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
81	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
82	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
83	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
84	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
85	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
86	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
87	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
88	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
89	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
90	Иван Иванов	укеуке	2022	article	draft	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	7	2025-02-22 22:41:06.997614	\N
91	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
92	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
93	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
94	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
95	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
96	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
97	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
114	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
115	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
117	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
260	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310123	\N
65	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-24 22:08:07.160091	\N
1414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334915	\N
98	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
99	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
100	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
102	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
104	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
105	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
107	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
118	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
119	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
120	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
124	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
127	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
128	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
129	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
130	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
132	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
1415	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334917	\N
1416	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334918	\N
1417	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33492	\N
1418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334922	\N
137	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
138	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
139	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
141	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
142	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
143	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
146	ddsdf	test1	2015	article	draft	\N	9	2025-02-22 22:41:06.997614	\N
147	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	9	2025-02-22 22:41:06.997614	\N
148	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	9	2025-02-22 22:41:06.997614	\N
149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	9	2025-02-22 22:41:06.997614	\N
150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	9	2025-02-22 22:41:06.997614	\N
151	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	9	2025-02-22 22:41:06.997614	\N
152	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	9	2025-02-22 22:41:06.997614	\N
153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	9	2025-02-22 22:41:06.997614	\N
154	Sham	test2	2010	article	draft	\N	9	2025-02-22 22:41:06.997614	\N
1419	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334923	\N
1420	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334924	\N
1421	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.334926	\N
145	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
158	Разработка автоматизированнной системы	Шамиль и Виталик	2025	article	draft	\N	7	2025-02-22 22:41:06.997614	\N
736	ddsdf	test1ы	2015	article	published	\N	16	2025-02-24 20:07:51.05722	\N
229	ddsdf	test1	2015	article	draft	\N	16	2025-02-23 14:22:15.756568	\N
230	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756571	\N
231	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756574	\N
232	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756576	\N
233	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756577	\N
234	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756579	\N
235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.75658	\N
236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756582	\N
237	Sham	test2	2010	article	draft	\N	16	2025-02-23 14:22:15.756583	\N
261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310125	\N
262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310126	\N
263	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310128	\N
264	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310129	\N
265	Sham	test2	2010	article	draft	\N	16	2025-02-23 14:26:08.310131	\N
1422	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334928	\N
277	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.196156	\N
1423	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334929	\N
315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615436	\N
316	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615437	\N
317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615438	\N
318	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61544	\N
319	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615442	\N
320	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615443	\N
322	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615446	\N
323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615447	\N
324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615449	\N
325	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61545	\N
326	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615451	\N
327	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615453	\N
328	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615454	\N
329	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615456	\N
330	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615457	\N
331	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615459	\N
332	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61546	\N
333	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615462	\N
334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615463	\N
335	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615465	\N
336	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615466	\N
337	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615467	\N
338	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615469	\N
339	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.61547	\N
340	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615472	\N
341	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615473	\N
342	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615474	\N
343	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615476	\N
344	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615477	\N
345	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615479	\N
346	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61548	\N
347	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615481	\N
348	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 10:07:13.615483	\N
349	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615484	\N
350	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615486	\N
351	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615487	\N
352	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615489	\N
353	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61549	\N
354	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615491	\N
355	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615493	\N
356	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615494	\N
357	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615496	\N
358	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615497	\N
359	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615498	\N
360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.6155	\N
361	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615501	\N
362	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615503	\N
363	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615504	\N
364	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615506	\N
365	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615507	\N
366	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615508	\N
367	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.61551	\N
368	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615511	\N
369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615513	\N
370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615514	\N
371	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615516	\N
372	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615517	\N
373	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615518	\N
374	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61552	\N
375	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615521	\N
376	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615523	\N
377	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615524	\N
378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615525	\N
379	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615527	\N
380	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615528	\N
321	ddsdf	test1	2012	article	draft	\N	16	2025-02-24 15:51:02.731529	\N
1024	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.97135	\N
381	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61553	\N
382	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615531	\N
383	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615532	\N
384	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 10:07:13.615534	\N
385	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615535	\N
386	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615537	\N
387	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615538	\N
388	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615539	\N
389	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615543	\N
390	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615544	\N
391	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615546	\N
392	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615547	\N
393	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615549	\N
394	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 10:07:13.61555	\N
395	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-24 10:07:13.615551	\N
396	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615553	\N
397	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615554	\N
398	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615556	\N
399	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615557	\N
400	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615558	\N
401	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61556	\N
402	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615561	\N
403	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615563	\N
404	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615564	\N
405	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 10:07:13.615565	\N
406	TheShamRio	test1	2011	article	draft	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-24 10:31:29.617339	\N
407	авп	ыва	1992	article	draft	D:\\publication-system\\backend\\uploads\\Spasi_i_Sokhrani.docx	16	2025-02-24 11:00:53.544476	\N
408	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-24 11:02:10.265079	\N
409	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-24 11:02:10.265084	\N
410	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-24 11:02:10.265087	\N
411	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-24 11:02:10.265089	\N
412	dfd	sdfs	2022	article	draft	\N	16	2025-02-24 11:02:10.26509	\N
413	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265092	\N
414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265094	\N
415	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265095	\N
416	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265097	\N
417	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265098	\N
418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.2651	\N
419	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265102	\N
420	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265103	\N
421	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265105	\N
422	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265106	\N
423	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265107	\N
424	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265109	\N
425	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26511	\N
426	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265112	\N
427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265114	\N
428	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265115	\N
429	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265116	\N
430	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265118	\N
431	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265119	\N
432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265121	\N
433	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265123	\N
434	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265124	\N
435	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265126	\N
436	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265127	\N
437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265129	\N
438	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.26513	\N
439	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265131	\N
440	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265133	\N
441	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265134	\N
442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265136	\N
443	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265137	\N
444	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265139	\N
445	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26514	\N
1025	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971352	\N
1026	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971353	\N
446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265142	\N
447	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265143	\N
448	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 11:02:10.265145	\N
449	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265146	\N
450	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265147	\N
451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265149	\N
452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26515	\N
453	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265152	\N
454	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265153	\N
455	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265155	\N
456	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265156	\N
457	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265157	\N
458	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265159	\N
459	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26516	\N
460	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265162	\N
461	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265163	\N
462	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265164	\N
463	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265166	\N
464	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265167	\N
465	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265169	\N
466	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.26517	\N
467	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265171	\N
468	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265173	\N
469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265174	\N
470	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265175	\N
471	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265177	\N
472	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265178	\N
473	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26518	\N
474	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265181	\N
475	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265182	\N
476	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265184	\N
477	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265185	\N
478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265187	\N
479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265188	\N
480	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26519	\N
481	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265191	\N
482	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265192	\N
483	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265194	\N
484	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 11:02:10.265195	\N
485	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265197	\N
486	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265198	\N
487	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.2652	\N
488	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265201	\N
489	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265202	\N
490	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265204	\N
491	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265205	\N
492	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265207	\N
493	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265208	\N
494	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 11:02:10.265209	\N
495	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-24 11:02:10.265211	\N
496	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265212	\N
497	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265214	\N
498	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265215	\N
499	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265217	\N
500	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265218	\N
501	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265219	\N
502	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265221	\N
503	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265222	\N
504	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265223	\N
505	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 11:02:10.265225	\N
506	555	555	1999	article	draft	D:\\publication-system\\backend\\uploads\\Spasi_i_Sokhrani.docx	16	2025-02-24 11:07:29.22586	\N
507	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-24 15:54:07.060604	\N
508	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-24 15:54:07.060609	\N
509	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-24 15:54:07.060611	\N
510	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-24 15:54:07.060613	\N
511	dfd	sdfs	2022	article	draft	\N	16	2025-02-24 15:54:07.060615	\N
512	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060616	\N
513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060618	\N
514	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060619	\N
515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06062	\N
516	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060622	\N
517	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060623	\N
518	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060625	\N
519	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060626	\N
520	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060628	\N
521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060629	\N
522	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06063	\N
523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060632	\N
524	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060633	\N
525	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060634	\N
526	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060636	\N
527	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060637	\N
528	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060638	\N
529	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.06064	\N
530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060641	\N
531	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060643	\N
532	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060644	\N
533	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060645	\N
534	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060647	\N
535	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060648	\N
536	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06065	\N
537	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060651	\N
538	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060652	\N
539	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060654	\N
540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060655	\N
541	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060656	\N
542	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060658	\N
543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060659	\N
544	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06066	\N
545	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060662	\N
546	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060663	\N
547	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060665	\N
548	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060666	\N
549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060667	\N
550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060669	\N
551	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06067	\N
552	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060671	\N
553	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060673	\N
554	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060674	\N
555	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060675	\N
556	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060677	\N
557	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060678	\N
558	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06068	\N
559	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060681	\N
560	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060682	\N
561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060684	\N
562	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060685	\N
563	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060686	\N
564	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060688	\N
565	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060689	\N
566	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060691	\N
567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060692	\N
568	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060693	\N
569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060695	\N
570	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060696	\N
571	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060697	\N
572	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060699	\N
573	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.0607	\N
574	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060702	\N
575	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060703	\N
576	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060704	\N
577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060706	\N
578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060707	\N
579	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060708	\N
1160	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370948	\N
580	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06071	\N
581	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060711	\N
582	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060713	\N
583	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060714	\N
584	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060715	\N
585	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060717	\N
586	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060718	\N
587	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06072	\N
588	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060721	\N
589	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060722	\N
590	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060724	\N
591	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060725	\N
592	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060727	\N
593	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060728	\N
594	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-24 15:54:07.06073	\N
595	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060731	\N
596	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060732	\N
597	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060734	\N
598	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060735	\N
599	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060737	\N
600	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060738	\N
601	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060739	\N
602	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060741	\N
603	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060742	\N
604	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060743	\N
605	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-24 15:54:07.060745	\N
606	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-24 15:54:07.060746	\N
607	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-24 15:54:07.060748	\N
608	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-24 15:54:07.060749	\N
609	dfd	sdfs	2022	article	draft	\N	16	2025-02-24 15:54:07.06075	\N
610	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060752	\N
611	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060753	\N
612	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060754	\N
613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060756	\N
614	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060757	\N
615	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060759	\N
616	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06076	\N
617	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060761	\N
618	ddsdf	test1	2012	article	draft	\N	16	2025-02-24 15:54:07.060763	\N
619	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060764	\N
620	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060765	\N
621	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060767	\N
622	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060768	\N
623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060769	\N
624	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060771	\N
625	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060772	\N
626	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060774	\N
627	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060775	\N
628	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060776	\N
629	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060778	\N
630	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060779	\N
631	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060781	\N
632	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060782	\N
633	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060783	\N
634	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060785	\N
635	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060786	\N
636	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060787	\N
637	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060789	\N
638	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06079	\N
639	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060791	\N
640	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060793	\N
641	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060794	\N
642	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060795	\N
643	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060797	\N
644	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060798	\N
645	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.0608	\N
646	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060801	\N
647	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060802	\N
648	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060804	\N
649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060805	\N
650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060806	\N
651	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060808	\N
652	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060809	\N
653	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06081	\N
654	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060812	\N
655	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060813	\N
656	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060815	\N
657	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060816	\N
658	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060817	\N
659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060819	\N
660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06082	\N
661	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060821	\N
662	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060823	\N
663	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060824	\N
664	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060826	\N
665	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060827	\N
666	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060828	\N
667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06083	\N
668	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060831	\N
669	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060832	\N
670	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060834	\N
671	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060835	\N
672	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060836	\N
673	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060838	\N
674	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060839	\N
675	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060841	\N
676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060842	\N
677	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060843	\N
678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060845	\N
679	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060846	\N
680	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060847	\N
681	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060849	\N
682	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.06085	\N
683	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060851	\N
684	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060853	\N
685	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060854	\N
686	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060856	\N
687	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060857	\N
688	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060858	\N
689	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060861	\N
690	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060863	\N
691	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060864	\N
692	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-24 15:54:07.060866	\N
693	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060867	\N
694	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060868	\N
695	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06087	\N
696	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060871	\N
697	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060872	\N
698	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060874	\N
699	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060875	\N
700	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060877	\N
701	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060878	\N
702	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060879	\N
703	TheShamRio	test1	2011	article	draft	\N	16	2025-02-24 15:54:07.060881	\N
704	авп	ыва	1992	article	draft	\N	16	2025-02-24 15:54:07.060882	\N
705	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-24 15:54:07.060883	\N
706	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-24 15:54:07.060885	\N
707	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-24 15:54:07.060886	\N
708	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-24 15:54:07.060887	\N
709	dfd	sdfs	2022	article	draft	\N	16	2025-02-24 15:54:07.060889	\N
710	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.06089	\N
711	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060892	\N
712	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060893	\N
713	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060894	\N
714	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060896	\N
715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060897	\N
716	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060898	\N
717	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.0609	\N
718	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060901	\N
719	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060902	\N
720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060904	\N
721	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060905	\N
722	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060906	\N
723	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060908	\N
724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060909	\N
725	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060911	\N
726	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060912	\N
727	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060913	\N
728	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060915	\N
729	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060916	\N
730	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060917	\N
731	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060919	\N
732	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06092	\N
733	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060921	\N
734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060923	\N
735	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060924	\N
737	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060927	\N
738	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060928	\N
739	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06093	\N
740	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060931	\N
741	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060932	\N
742	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060934	\N
743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060935	\N
744	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060936	\N
745	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060938	\N
746	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060939	\N
747	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060941	\N
748	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060942	\N
749	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060943	\N
750	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060945	\N
751	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060946	\N
752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060947	\N
753	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060949	\N
754	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.06095	\N
755	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060952	\N
756	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060953	\N
757	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060954	\N
758	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060956	\N
759	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060957	\N
760	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060958	\N
761	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06096	\N
762	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060961	\N
763	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060963	\N
764	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060964	\N
765	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060965	\N
766	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060967	\N
767	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060968	\N
768	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060969	\N
769	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060971	\N
770	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060972	\N
771	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060973	\N
772	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060975	\N
773	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060976	\N
774	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060979	\N
775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06098	\N
776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060982	\N
777	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060983	\N
779	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060986	\N
780	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060987	\N
781	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060989	\N
782	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.06099	\N
778	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	16	2025-02-25 01:44:56.259863	\N
1161	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370949	\N
783	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060991	\N
784	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060993	\N
785	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060994	\N
786	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060995	\N
787	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060997	\N
788	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060998	\N
789	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060999	\N
790	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.061001	\N
791	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.061002	\N
793	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.061005	\N
794	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.061006	\N
795	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.061008	\N
796	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.061009	\N
798	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	published	\N	16	2025-02-24 20:08:13.890181	\N
805	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	19	2025-02-24 22:00:42.970915	\N
806	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	19	2025-02-24 22:00:42.970919	\N
804	выаыва	ываыва	2011	article	published	D:\\publication-system\\backend\\uploads\\Spasi_i_Sokhrani.docx	16	2025-02-24 16:24:41.136262	\N
803	555	555ы	1999	article	published	D:\\publication-system\\backend\\uploads\\Spasi_i_Sokhrani.docx	16	2025-02-24 16:24:56.61221	\N
807	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	19	2025-02-24 22:00:42.970922	\N
799	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	16	2025-02-24 16:31:26.060319	\N
169	Shamфффффф	test2ффффффф	2010	monograph	published	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	13	2025-02-22 20:10:33.775622	\N
126	Sham	test2	2010	article	published	\N	7	2025-02-22 11:53:38.87618	\N
159	dfgdfgdfg	dfgdfg	2024	monograph	published	D:\\publication-system\\backend\\uploads\\-17.pdf	7	2025-02-22 11:50:44.606891	\N
109	ddsdfdfddddddddd	test1	2015	article	published	\N	7	2025-02-22 11:53:02.049733	\N
123	ssssssssssssssssss	Albert Einstein	1905	article	published	\N	7	2025-02-22 11:53:11.801522	\N
23	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	5	2025-02-22 19:20:03.641889	\N
34	ddsdf	test1	2015	article	published	\N	7	2025-02-22 22:41:06.997614	\N
43	lol1	lol1	2011	article	published	D:\\publication-system\\backend\\uploads\\1_.pdf	7	2025-02-22 22:41:06.997614	\N
28	Sham	test2	2010	article	published	D:\\publication-system\\backend\\uploads\\Spasi_i_Sokhrani.docx	7	2025-02-22 22:41:06.997614	\N
33	fdgdfg	dfgdfgdf	2011	monograph	published	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	7	2025-02-22 22:41:06.997614	\N
51	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-22 22:41:06.997614	\N
53	Sham	test2	2010	article	published	\N	7	2025-02-22 22:41:06.997614	\N
45	ddsdf	test1	2015	article	published	\N	7	2025-02-22 22:41:06.997614	\N
63	ddsdf	test1	2015	article	published	uploads\\4411__3_1.docx	7	2025-02-22 22:41:06.997614	\N
135	Sham	test2	2010	article	published	\N	7	2025-02-22 22:41:06.997614	\N
136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-22 22:41:06.997614	\N
134	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-22 22:41:06.997614	\N
133	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-22 22:41:06.997614	\N
155	длолд	ирмтми	2015	article	published	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	9	2025-02-22 22:41:06.997614	\N
157	Разработка автоматизированнной системы	Шамиль и Виталик	2025	article	published	uploads\\4411__3_1.docx	\N	2025-02-22 21:50:00.808239	\N
276	ddsdf	test1	2015	conference	published	\N	16	2025-02-24 09:56:09.872409	\N
792	dfg	dfgdfg	2023	article	published	\N	16	2025-02-24 16:36:39.285975	\N
808	Robotics and Automation	Evans, Linda	2021	article	draft	\N	19	2025-02-24 22:00:42.970924	\N
801	Sham	test2	2010	article	published	\N	16	2025-02-24 16:37:35.297233	\N
800	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	16	2025-02-24 16:46:59.150272	\N
802	длолд111111111111111111111	ирмтми	2015	article	published	D:\\publication-system\\backend\\uploads\\Spasi_i_Sokhrani.docx	16	2025-02-24 16:47:19.116526	\N
797	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	16	2025-02-24 16:50:49.423358	\N
809	dfd	sdfs	2022	article	draft	\N	19	2025-02-24 22:00:42.970926	\N
810	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.970927	\N
811	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970929	\N
812	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970931	\N
813	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970932	\N
814	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970934	\N
815	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970936	\N
816	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970937	\N
817	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970939	\N
818	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.97094	\N
819	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970942	\N
820	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970943	\N
1297	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.37114	\N
1298	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 01:50:19.371141	\N
821	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970944	\N
822	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970946	\N
823	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970947	\N
824	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970949	\N
825	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97095	\N
826	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.970951	\N
827	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.970953	\N
828	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970954	\N
829	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970956	\N
830	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970957	\N
831	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970959	\N
832	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97096	\N
833	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970962	\N
834	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970963	\N
835	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.970966	\N
836	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.970968	\N
837	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97097	\N
838	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970972	\N
839	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970974	\N
840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970976	\N
841	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970979	\N
842	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970981	\N
843	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970983	\N
844	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.970985	\N
845	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.970986	\N
846	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.970987	\N
847	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970989	\N
848	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970991	\N
849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970992	\N
850	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970993	\N
851	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970995	\N
852	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970996	\N
853	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970998	\N
854	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.970999	\N
855	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971001	\N
856	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971002	\N
857	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971004	\N
858	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971005	\N
859	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971006	\N
860	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971008	\N
861	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971009	\N
862	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971011	\N
863	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971012	\N
864	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971014	\N
865	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971015	\N
866	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971017	\N
867	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971018	\N
868	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97102	\N
869	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971021	\N
870	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971022	\N
871	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971024	\N
872	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971025	\N
873	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971027	\N
874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971028	\N
875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97103	\N
876	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971031	\N
877	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971032	\N
878	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971034	\N
879	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971035	\N
880	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971037	\N
881	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971038	\N
882	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.97104	\N
883	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971041	\N
884	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971043	\N
885	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971044	\N
886	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971046	\N
887	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971049	\N
888	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971051	\N
889	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971052	\N
890	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971054	\N
891	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971055	\N
892	dfg	dfgdfg	2023	article	draft	\N	19	2025-02-24 22:00:42.971056	\N
893	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971058	\N
894	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971059	\N
895	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971061	\N
896	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971062	\N
897	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971063	\N
898	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971065	\N
899	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971068	\N
900	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97107	\N
901	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971117	\N
902	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971123	\N
903	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	19	2025-02-24 22:00:42.971126	\N
904	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	19	2025-02-24 22:00:42.971129	\N
905	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	19	2025-02-24 22:00:42.971131	\N
906	Robotics and Automation	Evans, Linda	2021	article	draft	\N	19	2025-02-24 22:00:42.971133	\N
907	dfd	sdfs	2022	article	draft	\N	19	2025-02-24 22:00:42.971135	\N
908	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971136	\N
909	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971138	\N
910	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971141	\N
911	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971143	\N
912	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971145	\N
913	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971147	\N
914	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971149	\N
915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971151	\N
916	ddsdf	test1	2012	article	draft	\N	19	2025-02-24 22:00:42.971152	\N
917	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971155	\N
918	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971156	\N
919	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971158	\N
920	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971159	\N
921	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971161	\N
922	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971163	\N
923	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971166	\N
924	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971168	\N
925	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971171	\N
926	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971173	\N
927	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971175	\N
928	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971177	\N
929	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971179	\N
930	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971181	\N
931	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971183	\N
932	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971185	\N
933	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971188	\N
934	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.97119	\N
935	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971192	\N
936	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971195	\N
937	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971197	\N
938	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971203	\N
939	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971207	\N
940	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971209	\N
941	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971211	\N
942	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971213	\N
943	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971215	\N
944	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971217	\N
945	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971219	\N
946	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971221	\N
947	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971223	\N
948	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971225	\N
949	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971227	\N
950	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971229	\N
951	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971232	\N
952	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971234	\N
953	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971236	\N
954	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971239	\N
955	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971241	\N
956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971243	\N
957	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971245	\N
958	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971247	\N
959	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971248	\N
960	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97125	\N
961	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971252	\N
962	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971253	\N
963	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971255	\N
964	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971256	\N
965	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971258	\N
966	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971259	\N
967	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971261	\N
968	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971263	\N
969	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971265	\N
970	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971266	\N
971	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971268	\N
972	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971269	\N
973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971271	\N
974	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971273	\N
975	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971274	\N
976	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971276	\N
977	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971277	\N
978	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971279	\N
979	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971281	\N
980	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971282	\N
981	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971284	\N
982	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971285	\N
983	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971287	\N
984	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971289	\N
985	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97129	\N
986	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971292	\N
987	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971294	\N
988	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971295	\N
989	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971297	\N
990	dfg	dfgdfg	2023	article	draft	\N	19	2025-02-24 22:00:42.971299	\N
991	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.9713	\N
992	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971302	\N
993	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971303	\N
994	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971305	\N
995	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971306	\N
996	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971308	\N
997	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971309	\N
998	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971311	\N
999	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971312	\N
1000	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971314	\N
1001	TheShamRio	test1	2011	article	draft	\N	19	2025-02-24 22:00:42.971316	\N
1002	авп	ыва	1992	article	draft	\N	19	2025-02-24 22:00:42.971317	\N
1003	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	19	2025-02-24 22:00:42.971319	\N
1004	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	19	2025-02-24 22:00:42.97132	\N
1005	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	19	2025-02-24 22:00:42.971322	\N
1006	Robotics and Automation	Evans, Linda	2021	article	draft	\N	19	2025-02-24 22:00:42.971323	\N
1007	dfd	sdfs	2022	article	draft	\N	19	2025-02-24 22:00:42.971324	\N
1008	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971326	\N
1009	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971328	\N
1010	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971329	\N
1011	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971331	\N
1012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971332	\N
1013	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971334	\N
1014	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971335	\N
1015	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971337	\N
1016	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971338	\N
1017	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97134	\N
1018	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971341	\N
1019	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971343	\N
1020	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971344	\N
1021	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971346	\N
1022	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971347	\N
1023	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971349	\N
1027	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971355	\N
1028	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971357	\N
1029	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971358	\N
1030	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97136	\N
1031	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971361	\N
1032	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971363	\N
1033	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971364	\N
1034	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971366	\N
1035	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971367	\N
1036	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971369	\N
1037	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97137	\N
1038	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971372	\N
1039	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971373	\N
1040	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971375	\N
1041	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971376	\N
1042	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971378	\N
1043	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971379	\N
1044	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971381	\N
1045	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971382	\N
1046	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971384	\N
1047	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971385	\N
1048	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971387	\N
1049	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971388	\N
1050	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97139	\N
1051	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971392	\N
1052	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971393	\N
1053	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971395	\N
1054	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971396	\N
1055	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971398	\N
1056	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971399	\N
1057	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971401	\N
1058	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971402	\N
1059	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971405	\N
1060	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971406	\N
1061	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971408	\N
1062	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.97141	\N
1063	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971415	\N
1064	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971421	\N
1065	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971423	\N
1066	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971425	\N
1067	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971426	\N
1068	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971428	\N
1069	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971431	\N
1070	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971433	\N
1071	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971434	\N
1072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971436	\N
1073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971437	\N
1074	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971439	\N
1075	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97144	\N
1076	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971447	\N
1077	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971448	\N
1078	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.97145	\N
1079	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971451	\N
1080	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971453	\N
1081	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971455	\N
1082	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971457	\N
1083	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971459	\N
1084	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971461	\N
1085	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971462	\N
1086	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971465	\N
1087	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971467	\N
1088	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971469	\N
1089	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971471	\N
1090	dfg	dfgdfg	2023	article	draft	\N	19	2025-02-24 22:00:42.971473	\N
1091	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971475	\N
1092	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971476	\N
1093	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971478	\N
1094	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971481	\N
1095	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971483	\N
1096	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971485	\N
1097	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971488	\N
1098	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97149	\N
1099	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971493	\N
1100	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971494	\N
1424	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334931	\N
1425	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334932	\N
1101	555	555ss	1999	article	published	\N	19	2025-02-24 22:01:22.456069	\N
1102	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 01:50:19.370861	\N
1103	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 01:50:19.370866	\N
1104	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 01:50:19.370868	\N
1105	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 01:50:19.37087	\N
1106	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 01:50:19.370872	\N
1107	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370873	\N
1108	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370875	\N
1109	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370876	\N
1110	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370877	\N
1111	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370879	\N
1112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37088	\N
1113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370882	\N
1114	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370883	\N
1115	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370885	\N
1116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370886	\N
1117	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370887	\N
1118	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370889	\N
1119	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37089	\N
1120	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370892	\N
1121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370893	\N
1122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370894	\N
1123	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370896	\N
1124	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370897	\N
1125	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370899	\N
1126	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.3709	\N
1127	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370901	\N
1128	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370903	\N
1129	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370904	\N
1130	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370906	\N
1131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370907	\N
1132	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370909	\N
1133	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.37091	\N
1134	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370912	\N
1135	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370913	\N
1136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370914	\N
1137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370916	\N
1138	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370917	\N
1139	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370918	\N
1140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37092	\N
1141	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370921	\N
1142	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.370923	\N
1143	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370924	\N
1144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370926	\N
1145	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370927	\N
1146	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370928	\N
1147	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37093	\N
1148	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370931	\N
1149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370933	\N
1150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370934	\N
1151	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370935	\N
1152	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370937	\N
1153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370938	\N
1154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370939	\N
1155	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370941	\N
1156	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370942	\N
1157	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370944	\N
1158	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370945	\N
1159	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370946	\N
1162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370951	\N
1163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370952	\N
1164	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370953	\N
1165	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370955	\N
1166	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370956	\N
1167	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370958	\N
1168	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370959	\N
1169	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.37096	\N
1170	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370962	\N
1171	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370963	\N
1172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370964	\N
1173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370966	\N
1174	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370967	\N
1175	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370969	\N
1176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37097	\N
1177	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370971	\N
1178	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.370973	\N
1179	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370974	\N
1180	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370976	\N
1181	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370977	\N
1182	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370979	\N
1183	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37098	\N
1184	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370981	\N
1185	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370983	\N
1186	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370984	\N
1187	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370986	\N
1188	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.370987	\N
1189	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 01:50:19.370988	\N
1190	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.37099	\N
1191	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370991	\N
1192	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370993	\N
1193	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370994	\N
1194	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370995	\N
1195	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370997	\N
1196	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370998	\N
1197	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371	\N
1198	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371001	\N
1199	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371002	\N
1200	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 01:50:19.371004	\N
1201	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 01:50:19.371005	\N
1202	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 01:50:19.371007	\N
1203	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 01:50:19.371008	\N
1204	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 01:50:19.37101	\N
1205	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371011	\N
1206	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371012	\N
1207	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371014	\N
1208	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371015	\N
1209	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371016	\N
1210	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371018	\N
1211	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371019	\N
1212	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371021	\N
1213	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 01:50:19.371022	\N
1214	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371024	\N
1215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371025	\N
1216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371026	\N
1217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371028	\N
1218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371029	\N
1219	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371031	\N
1220	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371032	\N
1221	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371034	\N
1222	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371035	\N
1223	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371037	\N
1224	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371038	\N
1225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371039	\N
1226	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371041	\N
1227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371042	\N
1228	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371044	\N
1229	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371045	\N
1230	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371046	\N
1231	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371048	\N
1232	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371049	\N
1233	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371051	\N
1234	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371052	\N
1235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371053	\N
1236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371055	\N
1237	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371056	\N
1238	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371058	\N
1239	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371059	\N
1240	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.37106	\N
1241	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371062	\N
1242	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371063	\N
1243	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371064	\N
1244	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371066	\N
1245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371067	\N
1246	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371069	\N
1247	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37107	\N
1248	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371072	\N
1249	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371073	\N
1250	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371074	\N
1251	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371076	\N
1252	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371077	\N
1253	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371079	\N
1254	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37108	\N
1255	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371082	\N
1256	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371083	\N
1257	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371084	\N
1258	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371086	\N
1259	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371087	\N
1260	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371089	\N
1261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37109	\N
1262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371091	\N
1263	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371093	\N
1264	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371094	\N
1265	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371096	\N
1266	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371097	\N
1267	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371098	\N
1268	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.3711	\N
1269	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371101	\N
1270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371102	\N
1271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371104	\N
1272	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371105	\N
1273	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371107	\N
1274	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371108	\N
1275	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371109	\N
1276	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371111	\N
1277	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371112	\N
1278	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371113	\N
1279	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371115	\N
1280	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371116	\N
1281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371118	\N
1282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371119	\N
1283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37112	\N
1284	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371122	\N
1285	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371123	\N
1286	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371125	\N
1287	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 01:50:19.371126	\N
1288	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371127	\N
1289	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371129	\N
1290	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37113	\N
1291	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371132	\N
1292	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371133	\N
1293	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371134	\N
1294	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371136	\N
1295	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371137	\N
1296	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371139	\N
1311	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37116	\N
1312	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371161	\N
1313	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371162	\N
1314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371164	\N
1315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371165	\N
1316	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371167	\N
1317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371168	\N
1318	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37117	\N
1319	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371171	\N
1320	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371173	\N
1321	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371174	\N
1322	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371175	\N
1323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371177	\N
1324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371178	\N
1325	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37118	\N
1326	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371181	\N
1327	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371182	\N
1328	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371184	\N
1329	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371185	\N
1330	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371187	\N
1331	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371188	\N
1332	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37119	\N
1333	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371191	\N
1334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371192	\N
1335	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371194	\N
1336	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371195	\N
1337	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371197	\N
1338	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371198	\N
1339	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.3712	\N
1340	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371201	\N
1341	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371202	\N
1342	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371204	\N
1343	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371205	\N
1344	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371207	\N
1345	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371208	\N
1346	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371209	\N
1347	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371211	\N
1348	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371212	\N
1349	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371214	\N
1350	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371215	\N
1351	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371217	\N
1352	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371218	\N
1353	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371219	\N
1354	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371221	\N
1355	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371222	\N
1356	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371224	\N
1357	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371225	\N
1358	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371226	\N
1359	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371228	\N
1360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371229	\N
1361	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371231	\N
1362	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371232	\N
1363	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371233	\N
1364	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371235	\N
1365	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371236	\N
1366	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371237	\N
1367	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371239	\N
1368	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.37124	\N
1369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371242	\N
1370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371243	\N
1371	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371245	\N
1372	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371246	\N
1373	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371247	\N
1374	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371249	\N
1375	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.37125	\N
1376	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371252	\N
1377	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371253	\N
2880	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48969	\N
1378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371254	\N
1379	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371256	\N
1380	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371257	\N
1381	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371259	\N
1382	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37126	\N
1383	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371261	\N
1384	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371263	\N
1385	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371264	\N
1386	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371266	\N
1387	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 01:50:19.371267	\N
1388	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371268	\N
1389	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37127	\N
1390	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371271	\N
1391	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371273	\N
1392	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371274	\N
1393	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371275	\N
3189	ываы	ваыва	1999	article	published	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	16	2025-02-25 17:35:05.220975	2025-02-25 17:35:05.220495
3223	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142064	\N
1397	длолд	ирмтми	2015	article	published	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 02:51:04.539398	2025-02-25 02:51:04.539182
3224	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142065	\N
3225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142066	\N
3226	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142068	\N
1396	Sham	test2	2010	article	published	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:12:30.699676	2025-02-25 03:12:30.699465
1394	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:24:01.674822	\N
1426	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334934	\N
1427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334935	\N
1428	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334937	\N
1429	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334938	\N
1430	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33494	\N
1431	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334941	\N
1432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334943	\N
1433	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334944	\N
1434	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334946	\N
1435	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334947	\N
1436	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334948	\N
1437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33495	\N
1438	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334951	\N
1439	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.334953	\N
1440	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.334954	\N
1441	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334956	\N
1442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334957	\N
1443	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334958	\N
1444	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33496	\N
1445	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334961	\N
1446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334963	\N
1447	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334964	\N
1448	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334966	\N
1449	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.334967	\N
1450	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334969	\N
1451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33497	\N
1452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334972	\N
1453	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334973	\N
1454	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334975	\N
1455	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334976	\N
1456	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334978	\N
1457	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334979	\N
1458	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33498	\N
1459	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334982	\N
1460	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334983	\N
3227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142069	\N
3228	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14207	\N
1465	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33499	\N
1466	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334992	\N
1467	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.334993	\N
1468	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334994	\N
1469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334996	\N
1470	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334997	\N
1471	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334998	\N
1472	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335	\N
1473	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335001	\N
1474	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335003	\N
1475	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335004	\N
1476	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335005	\N
1477	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335007	\N
1478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335008	\N
1479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335009	\N
1480	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335011	\N
1481	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335012	\N
1482	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335014	\N
1483	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335015	\N
1484	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335016	\N
1485	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335018	\N
1486	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335019	\N
1487	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.33502	\N
1488	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335022	\N
1489	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335023	\N
1490	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335025	\N
1491	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335026	\N
1492	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335027	\N
1493	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335029	\N
1494	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33503	\N
1495	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335031	\N
1496	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335033	\N
1497	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335034	\N
1498	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335036	\N
1499	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335037	\N
1500	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335038	\N
1501	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.33504	\N
1502	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335041	\N
1503	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335043	\N
1504	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335044	\N
1505	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335045	\N
1506	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335047	\N
1507	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335048	\N
1508	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33505	\N
1509	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335051	\N
1510	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335053	\N
1511	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:24:31.335054	\N
1512	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335055	\N
1513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335057	\N
1514	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335058	\N
1515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33506	\N
1516	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335061	\N
1517	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335063	\N
1518	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335064	\N
1519	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335065	\N
1520	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335067	\N
1521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335068	\N
1522	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33507	\N
1523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335071	\N
1524	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335072	\N
1525	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335074	\N
1526	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335075	\N
1527	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335077	\N
1528	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335078	\N
1529	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335079	\N
1530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335081	\N
1531	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335082	\N
1532	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335083	\N
1533	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335085	\N
1534	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335086	\N
1535	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335088	\N
1536	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335089	\N
1537	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335091	\N
1538	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335092	\N
1539	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335093	\N
1540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335095	\N
1541	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335096	\N
1542	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335098	\N
1543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335099	\N
1544	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.3351	\N
1545	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335102	\N
1546	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335103	\N
1547	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335104	\N
1548	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335106	\N
1549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335107	\N
1550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335109	\N
1551	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33511	\N
1552	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335111	\N
1553	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335113	\N
1554	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335114	\N
1555	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335116	\N
1556	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335117	\N
1557	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335118	\N
1558	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33512	\N
1559	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335121	\N
1560	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335123	\N
1561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335124	\N
1562	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335126	\N
1563	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335127	\N
1564	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335128	\N
1565	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33513	\N
1566	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335131	\N
1567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335132	\N
1568	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335134	\N
1569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335135	\N
1570	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335136	\N
1571	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335138	\N
1572	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335139	\N
1573	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335141	\N
1574	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335142	\N
1575	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335143	\N
1576	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335145	\N
1577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335146	\N
1578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335147	\N
1579	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335149	\N
1580	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33515	\N
1581	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335151	\N
1582	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335153	\N
1583	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335154	\N
1584	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335155	\N
1585	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335157	\N
1586	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335158	\N
1587	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33516	\N
1588	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335161	\N
1589	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335162	\N
1590	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335164	\N
1591	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335165	\N
1592	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335166	\N
1593	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335168	\N
1594	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335169	\N
1595	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.33517	\N
1596	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:24:31.335172	\N
1597	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:24:31.335173	\N
1598	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335175	\N
1599	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335176	\N
1600	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335177	\N
1601	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335179	\N
1602	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.33518	\N
1603	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335181	\N
1604	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335183	\N
1605	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335184	\N
1606	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335185	\N
1607	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335187	\N
1608	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335188	\N
1609	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33519	\N
1610	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335191	\N
1611	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335192	\N
1612	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335194	\N
1613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335195	\N
1614	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335196	\N
1615	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335198	\N
1616	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335199	\N
1617	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.3352	\N
1618	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335202	\N
1619	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335203	\N
1620	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335204	\N
1621	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335206	\N
1622	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335207	\N
1623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335209	\N
1624	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33521	\N
1625	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335211	\N
1626	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335213	\N
1627	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335214	\N
1628	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335215	\N
1629	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335217	\N
1630	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335218	\N
1631	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335219	\N
1632	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335221	\N
1633	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335222	\N
1634	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335223	\N
1635	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335225	\N
1636	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335226	\N
1637	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335228	\N
1638	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335229	\N
1639	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33523	\N
1640	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335232	\N
1641	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335233	\N
1642	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335234	\N
1643	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335236	\N
1644	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335237	\N
1645	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335239	\N
1646	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33524	\N
1647	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335241	\N
1648	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335243	\N
1649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335244	\N
1650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335245	\N
1651	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335247	\N
1652	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335248	\N
1653	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33525	\N
1654	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335251	\N
1655	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335252	\N
1656	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335254	\N
1657	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335255	\N
1658	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335257	\N
1659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335258	\N
1660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335259	\N
1661	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335261	\N
1662	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335262	\N
1663	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335263	\N
1664	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335265	\N
1665	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335266	\N
1666	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335268	\N
1667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335269	\N
1668	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33527	\N
1669	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335272	\N
1670	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335273	\N
1671	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335274	\N
1672	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335276	\N
1673	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335277	\N
1674	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335279	\N
1675	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33528	\N
1676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335281	\N
1677	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335283	\N
1678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335284	\N
1679	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335285	\N
1680	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335287	\N
1681	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335288	\N
1682	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33529	\N
1683	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335291	\N
1684	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335292	\N
1685	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335294	\N
1686	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335295	\N
1687	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335296	\N
1688	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335298	\N
1689	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335299	\N
1690	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335301	\N
1691	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335302	\N
1692	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335303	\N
1693	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335305	\N
1694	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335306	\N
1695	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335307	\N
1696	555	555	1999	article	draft	\N	16	2025-02-25 03:24:31.335309	\N
1697	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.33531	\N
1698	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335311	\N
1699	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335313	\N
1700	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335314	\N
1701	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335316	\N
1702	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335317	\N
1703	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335318	\N
1704	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33532	\N
1705	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335321	\N
1706	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335322	\N
1707	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335324	\N
1708	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335325	\N
1709	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335326	\N
1710	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335328	\N
1711	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335329	\N
1712	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33533	\N
1713	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335332	\N
1714	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335333	\N
1715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335335	\N
1716	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335336	\N
1717	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335337	\N
1718	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335339	\N
1719	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33534	\N
1720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335341	\N
1721	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335343	\N
1722	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335344	\N
1723	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335345	\N
1724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335347	\N
1725	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335348	\N
1726	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335349	\N
1727	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335351	\N
1728	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335352	\N
1729	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335354	\N
1730	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335355	\N
1731	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335356	\N
1732	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335358	\N
1733	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335359	\N
1734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33536	\N
3904	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142968	\N
1735	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335362	\N
1736	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335363	\N
1737	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335364	\N
1738	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335366	\N
1739	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335367	\N
1740	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335368	\N
1741	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33537	\N
1742	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335371	\N
1743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335373	\N
1744	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335374	\N
1745	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335375	\N
1746	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335377	\N
1747	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335378	\N
1748	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335379	\N
1749	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335381	\N
1750	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335382	\N
1751	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335383	\N
1752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335385	\N
1753	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335386	\N
1754	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335387	\N
1755	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335389	\N
1756	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33539	\N
1757	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335392	\N
1758	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335393	\N
1759	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335394	\N
1760	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335396	\N
1761	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335397	\N
1762	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335398	\N
1763	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.3354	\N
1764	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335401	\N
1765	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335403	\N
1766	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335404	\N
1767	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335405	\N
1768	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335407	\N
1769	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335408	\N
1770	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335409	\N
1771	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335411	\N
1772	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335412	\N
1773	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335414	\N
1774	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335415	\N
1775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335416	\N
1776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33542	\N
1777	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335421	\N
1778	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335423	\N
1779	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335424	\N
1780	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335425	\N
1781	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335427	\N
1782	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335428	\N
1783	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335429	\N
1784	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335431	\N
1785	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335432	\N
1786	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335433	\N
1787	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335435	\N
1788	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335436	\N
1789	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335438	\N
1790	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335439	\N
1791	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33544	\N
1792	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335442	\N
1793	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335443	\N
1794	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335444	\N
1795	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335446	\N
1796	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335447	\N
1797	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335448	\N
1798	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.33545	\N
1799	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335451	\N
1800	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335453	\N
1801	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335454	\N
1802	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335455	\N
3905	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142969	\N
1803	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335457	\N
1804	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335458	\N
1805	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335459	\N
1806	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335461	\N
1807	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335462	\N
1808	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:24:31.335463	\N
1809	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335465	\N
1810	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335466	\N
1811	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335467	\N
1812	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335469	\N
1813	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33547	\N
1814	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335471	\N
1815	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335473	\N
1816	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335474	\N
1817	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335475	\N
1818	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335477	\N
1819	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335478	\N
1820	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335479	\N
1821	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335481	\N
1822	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335482	\N
1823	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335484	\N
1824	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335485	\N
1825	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335486	\N
1826	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335488	\N
1827	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335489	\N
1828	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33549	\N
1829	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335492	\N
1830	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335493	\N
1831	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335494	\N
1832	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335496	\N
1833	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335497	\N
1834	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335498	\N
1835	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.3355	\N
1836	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335501	\N
1837	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335502	\N
1838	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335504	\N
1839	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335505	\N
1840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335506	\N
1841	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335508	\N
1842	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335509	\N
1843	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335511	\N
1844	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335512	\N
1845	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335513	\N
1846	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335515	\N
1847	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335516	\N
1848	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335517	\N
1849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335519	\N
1850	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33552	\N
1851	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335521	\N
1852	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335523	\N
1853	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335524	\N
1854	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335525	\N
1855	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335527	\N
1856	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335528	\N
1857	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335529	\N
1858	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335531	\N
1859	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335532	\N
1860	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335535	\N
1861	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335536	\N
1862	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335538	\N
1863	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335539	\N
1864	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33554	\N
1865	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335542	\N
1866	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335543	\N
1867	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335544	\N
1868	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335546	\N
4041	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14315	\N
1869	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335547	\N
1870	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335549	\N
1871	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.33555	\N
1872	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335551	\N
1873	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335553	\N
1874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335554	\N
1875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335555	\N
1876	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335557	\N
1877	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335558	\N
1878	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335559	\N
1879	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335561	\N
1880	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335562	\N
1881	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335563	\N
1882	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335565	\N
1883	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335566	\N
1884	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335567	\N
1885	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335569	\N
1886	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33557	\N
1887	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335572	\N
1888	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335573	\N
1889	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335574	\N
1890	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335576	\N
1891	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335577	\N
1892	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335578	\N
1893	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:24:31.33558	\N
1894	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:24:31.335581	\N
1895	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335582	\N
1896	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335584	\N
1897	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335585	\N
1898	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335587	\N
1899	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335588	\N
1900	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335589	\N
1901	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335591	\N
1902	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335592	\N
1903	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335593	\N
1904	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335595	\N
1905	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335596	\N
1906	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335597	\N
1907	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335599	\N
1908	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.3356	\N
1909	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335602	\N
1910	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335603	\N
1911	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335604	\N
1912	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335606	\N
1913	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335607	\N
1914	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335608	\N
1915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33561	\N
1916	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335611	\N
1917	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335612	\N
1918	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335614	\N
1919	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335615	\N
1920	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335616	\N
1921	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335618	\N
1922	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335619	\N
1923	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33562	\N
1924	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335622	\N
1925	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335623	\N
1926	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335625	\N
1927	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335626	\N
1928	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335627	\N
1929	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335629	\N
1930	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33563	\N
1931	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335631	\N
1932	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335633	\N
1933	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335634	\N
1934	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335635	\N
1935	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335637	\N
1936	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335638	\N
1937	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335639	\N
1938	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335641	\N
1939	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335642	\N
1940	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335643	\N
1941	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335645	\N
1942	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335646	\N
1943	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335647	\N
1944	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335649	\N
1945	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335652	\N
1946	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335653	\N
1947	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335654	\N
1948	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335656	\N
1949	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335657	\N
1950	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335658	\N
1951	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33566	\N
1952	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335661	\N
1953	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335662	\N
1954	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335664	\N
1955	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335665	\N
1956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335667	\N
1957	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335668	\N
1958	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335669	\N
1959	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335671	\N
1960	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335672	\N
1961	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335673	\N
1962	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335675	\N
1963	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335676	\N
1964	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335677	\N
1965	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335679	\N
1966	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33568	\N
1967	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335681	\N
1968	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335683	\N
1969	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335684	\N
1970	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335685	\N
1971	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335688	\N
1972	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33569	\N
1973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335691	\N
1974	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335692	\N
1975	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335694	\N
1976	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335695	\N
1977	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335696	\N
1978	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335698	\N
1979	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335699	\N
1980	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.3357	\N
1981	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335702	\N
1982	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335703	\N
1983	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335704	\N
1984	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335706	\N
1985	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335707	\N
1986	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335709	\N
1987	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33571	\N
1988	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335711	\N
1989	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335713	\N
1990	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335714	\N
1991	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335715	\N
1992	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335717	\N
1993	555	555	1999	article	draft	\N	16	2025-02-25 03:24:31.335718	\N
1994	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335719	\N
1995	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335721	\N
1996	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335722	\N
1997	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335723	\N
1998	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335725	\N
1999	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335726	\N
2000	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335728	\N
2001	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335729	\N
2002	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33573	\N
2003	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335732	\N
2004	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335733	\N
2005	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335734	\N
2006	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335736	\N
2007	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335737	\N
2008	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335738	\N
2009	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33574	\N
2010	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335741	\N
2011	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335742	\N
2012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335744	\N
2013	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335745	\N
2014	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335746	\N
2015	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335748	\N
2016	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335749	\N
2017	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335751	\N
2018	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335752	\N
2019	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335753	\N
2020	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335755	\N
2021	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335756	\N
2022	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335757	\N
2023	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335759	\N
2024	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33576	\N
2025	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335761	\N
2026	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335763	\N
2027	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335764	\N
2028	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335765	\N
2029	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335767	\N
2030	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33577	\N
2031	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335771	\N
2032	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335772	\N
2033	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335774	\N
2034	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335775	\N
2035	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335776	\N
2036	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335778	\N
2037	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335779	\N
2038	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33578	\N
2039	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335782	\N
2040	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335783	\N
2041	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335784	\N
2042	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335786	\N
2043	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335787	\N
2044	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335788	\N
2045	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33579	\N
2046	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335791	\N
2047	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335793	\N
2048	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335794	\N
2049	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335795	\N
2050	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335797	\N
2051	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335798	\N
2052	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335799	\N
2053	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335801	\N
2054	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335802	\N
2055	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335803	\N
2056	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335805	\N
2057	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335806	\N
2058	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335807	\N
2059	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335809	\N
2060	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33581	\N
2061	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335811	\N
2062	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335813	\N
2063	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335814	\N
2064	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335816	\N
2065	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335817	\N
2066	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335818	\N
2067	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33582	\N
2068	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335821	\N
2069	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335822	\N
2070	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335824	\N
2071	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335825	\N
2072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335826	\N
4042	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143151	\N
2073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335828	\N
2074	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335829	\N
2075	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33583	\N
2076	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335832	\N
2077	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335833	\N
2078	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335835	\N
2079	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335836	\N
2080	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335837	\N
2081	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335839	\N
2082	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33584	\N
2083	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335841	\N
2084	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335843	\N
2085	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335844	\N
2086	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335845	\N
2087	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335847	\N
2088	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335848	\N
2089	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335849	\N
2090	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335851	\N
2091	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335852	\N
2092	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335853	\N
2093	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335855	\N
2094	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335856	\N
2095	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335857	\N
2096	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335859	\N
2097	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33586	\N
2098	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335862	\N
2099	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335863	\N
2100	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335864	\N
2101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335866	\N
2102	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335867	\N
2103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335868	\N
2104	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33587	\N
2105	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:24:31.335871	\N
2106	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335872	\N
2107	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335874	\N
2108	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335875	\N
2109	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335876	\N
2110	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335878	\N
2111	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335879	\N
2112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33588	\N
2113	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335882	\N
2114	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335883	\N
2115	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335884	\N
2116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335887	\N
2117	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335889	\N
2118	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33589	\N
2119	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335891	\N
2120	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335893	\N
2121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335894	\N
2122	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335896	\N
2123	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335897	\N
2124	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335898	\N
2125	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.3359	\N
2126	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335901	\N
2127	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335902	\N
2128	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335904	\N
2129	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335905	\N
2130	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335906	\N
2131	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335908	\N
2132	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335909	\N
2133	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33591	\N
2134	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335912	\N
2135	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335913	\N
2136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335914	\N
2137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335916	\N
2138	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335917	\N
2139	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335918	\N
2140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33592	\N
2141	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335921	\N
2142	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335923	\N
2143	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335924	\N
2144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335925	\N
2145	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335927	\N
2146	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335928	\N
2147	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335929	\N
2148	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335931	\N
2149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335932	\N
2150	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335933	\N
2151	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335935	\N
2152	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335936	\N
2153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335937	\N
2154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335939	\N
2155	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33594	\N
2156	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335941	\N
2157	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335943	\N
2158	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335944	\N
2159	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335946	\N
2160	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335947	\N
2161	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335948	\N
2162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33595	\N
2163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335951	\N
2164	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335952	\N
2165	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335954	\N
2166	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335955	\N
2167	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335956	\N
2168	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335958	\N
2169	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335959	\N
2170	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33596	\N
2171	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335962	\N
2172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335963	\N
2173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335964	\N
2174	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335966	\N
2175	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335967	\N
2176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335969	\N
2177	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33597	\N
2178	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335971	\N
2179	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335973	\N
2180	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335974	\N
2181	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335975	\N
2182	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335977	\N
2183	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335978	\N
2184	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335979	\N
2185	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335981	\N
2186	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335982	\N
2187	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335983	\N
2188	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335985	\N
2189	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335986	\N
2190	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:24:31.335987	\N
2191	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:24:31.335989	\N
2192	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.33599	\N
2193	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335991	\N
2194	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335993	\N
2195	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335994	\N
2196	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335996	\N
2197	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335997	\N
2198	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335998	\N
2199	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336	\N
2200	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336002	\N
2201	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336004	\N
2202	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336005	\N
2203	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336006	\N
2204	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336008	\N
2205	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336009	\N
2206	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33601	\N
2207	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336012	\N
2208	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336013	\N
2209	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336015	\N
2210	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336016	\N
2211	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336017	\N
2212	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336019	\N
2213	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33602	\N
2214	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336021	\N
2215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336023	\N
2216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336024	\N
2217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336025	\N
2218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336027	\N
2219	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336028	\N
2220	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336029	\N
2221	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336031	\N
2222	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336032	\N
2223	ddsdf	test1ы	2015	article	draft	\N	16	2025-02-25 03:24:31.336034	\N
2224	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336035	\N
2225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336036	\N
2226	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336038	\N
2227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336039	\N
2228	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33604	\N
2229	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336042	\N
2230	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336043	\N
2231	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336044	\N
2232	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.336046	\N
2233	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336047	\N
2234	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336048	\N
2235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33605	\N
2236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336051	\N
2237	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336052	\N
2238	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336054	\N
2239	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336055	\N
2240	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336057	\N
2241	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336058	\N
2242	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336059	\N
2243	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336061	\N
2244	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336062	\N
2245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336063	\N
2246	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336065	\N
2247	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336066	\N
2248	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336067	\N
2249	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336069	\N
2250	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33607	\N
2251	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336071	\N
2252	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336073	\N
2253	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336074	\N
2254	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336075	\N
2255	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336077	\N
2256	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336078	\N
2257	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336079	\N
2258	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336081	\N
2259	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336082	\N
2260	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336084	\N
2261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336085	\N
2262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336086	\N
2263	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336088	\N
2264	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336089	\N
2265	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33609	\N
2266	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336092	\N
2267	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336093	\N
2268	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.336094	\N
2269	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336096	\N
2270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336097	\N
2271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336098	\N
2272	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.3361	\N
2273	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336101	\N
2274	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336102	\N
2275	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336104	\N
2276	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336105	\N
2277	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336106	\N
2278	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.336108	\N
2279	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.336109	\N
2280	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33611	\N
2281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336112	\N
2282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336113	\N
2283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336115	\N
2284	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336116	\N
2285	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	draft	\N	16	2025-02-25 03:24:31.336119	\N
2286	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33612	\N
2287	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336121	\N
3190	df	dsf	2011	article	draft	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	16	2025-02-25 23:54:30.663488	\N
3191	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142015	\N
2291	выаыва	ываыва	2011	monograph	published	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:46:03.514405	2025-02-25 03:46:03.513835
2288	Sham	test2	2013	article	draft	\N	16	2025-02-25 03:46:41.069738	\N
2292	Lab_1_pcmi	выаыва	2010	article	draft	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:46:54.078628	\N
2293	парап	апрапр	2011	article	draft	D:\\publication-system\\backend\\uploads\\Spasi_i_Sokhrani.docx	16	2025-02-25 03:47:18.980923	\N
2294	вапвап	вапвап	1999	article	draft	D:\\publication-system\\backend\\uploads\\Spasi_i_Sokhrani.docx	16	2025-02-25 03:49:21.412916	\N
2295	авпвап	вапвап	2013	article	draft	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:50:07.955754	\N
2296	авпва	пвап	1999	article	draft	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:51:21.902155	\N
2297	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.488884	\N
2298	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.488888	\N
2299	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.48889	\N
2300	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.488892	\N
2301	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.488894	\N
2302	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488895	\N
2303	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488896	\N
2304	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488898	\N
2305	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488899	\N
2306	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488901	\N
2307	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488902	\N
2308	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488903	\N
2309	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488905	\N
2310	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488906	\N
2311	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488908	\N
2312	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488909	\N
2313	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48891	\N
2314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488912	\N
2315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488913	\N
2316	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488914	\N
2317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488916	\N
2318	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488917	\N
2319	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488918	\N
2320	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48892	\N
2321	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488921	\N
2322	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488923	\N
2323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488924	\N
2324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488925	\N
2325	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488927	\N
2326	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488928	\N
2327	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488929	\N
2328	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488931	\N
2329	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488932	\N
2330	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488934	\N
2331	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488935	\N
2332	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488936	\N
2333	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488938	\N
2334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488939	\N
2335	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48894	\N
2336	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488942	\N
2337	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.488943	\N
2338	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488945	\N
3192	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142019	\N
2339	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488946	\N
2340	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488947	\N
2341	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488949	\N
2342	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48895	\N
2343	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488951	\N
2344	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488953	\N
2345	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488954	\N
2346	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488956	\N
2347	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488957	\N
2348	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488958	\N
2349	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48896	\N
2350	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488961	\N
2351	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488962	\N
2352	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488964	\N
2353	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488965	\N
2354	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488967	\N
2355	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488968	\N
2356	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488969	\N
2357	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488971	\N
2358	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488972	\N
2359	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488973	\N
2360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488975	\N
2361	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488976	\N
2362	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488977	\N
2363	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488979	\N
2364	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48898	\N
2365	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488982	\N
2366	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488983	\N
2367	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488984	\N
2368	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488986	\N
2369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488987	\N
2370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488989	\N
2371	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48899	\N
2372	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488991	\N
2373	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.488993	\N
2374	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488994	\N
2375	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488995	\N
2376	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488997	\N
2377	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488998	\N
2378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489	\N
2379	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489001	\N
2380	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489002	\N
2381	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489004	\N
2382	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489005	\N
2383	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489006	\N
2384	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489008	\N
2385	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489009	\N
2386	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48901	\N
2387	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489012	\N
2388	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489013	\N
2389	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489015	\N
2390	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489016	\N
2391	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489017	\N
2392	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489019	\N
2393	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48902	\N
2394	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489021	\N
2395	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489023	\N
2396	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489024	\N
2397	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489026	\N
2398	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489027	\N
2399	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489028	\N
2400	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48903	\N
2401	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489031	\N
2402	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489032	\N
2403	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489034	\N
2404	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489035	\N
2405	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489037	\N
2406	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489038	\N
2407	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48904	\N
2408	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:51:29.489041	\N
2409	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489043	\N
2410	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489044	\N
2411	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489045	\N
2412	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489047	\N
2413	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489048	\N
2414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48905	\N
2415	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489051	\N
2416	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489052	\N
2417	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489054	\N
2418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489055	\N
2419	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489056	\N
2420	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489058	\N
2421	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489059	\N
2422	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489061	\N
2423	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489062	\N
2424	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489063	\N
2425	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489065	\N
2426	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489066	\N
2427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489068	\N
2428	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489069	\N
2429	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48907	\N
2430	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489072	\N
2431	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489073	\N
2432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489075	\N
2433	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489076	\N
2434	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489077	\N
2435	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489079	\N
2436	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48908	\N
2437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489082	\N
2438	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489083	\N
2439	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489084	\N
2440	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489086	\N
2441	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489087	\N
2442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489088	\N
2443	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48909	\N
2444	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489091	\N
2445	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489092	\N
2446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489094	\N
2447	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489095	\N
2448	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489097	\N
2449	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489098	\N
2450	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489099	\N
2451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489101	\N
2452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489102	\N
2453	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489103	\N
2454	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489105	\N
2455	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489106	\N
2456	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489108	\N
2457	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489109	\N
2458	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48911	\N
2459	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489112	\N
2460	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489113	\N
2461	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489114	\N
2462	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489116	\N
2463	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489117	\N
2464	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489119	\N
2465	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48912	\N
2466	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489121	\N
2467	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489123	\N
2468	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489124	\N
2469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489125	\N
2470	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489127	\N
2471	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489128	\N
2472	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48913	\N
2473	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489131	\N
2474	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489132	\N
2475	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489134	\N
2476	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489135	\N
2477	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489137	\N
2478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489138	\N
2479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489139	\N
2480	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489141	\N
2481	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489142	\N
2482	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489143	\N
2483	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489145	\N
2484	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489146	\N
2485	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489147	\N
2486	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489149	\N
2487	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48915	\N
2488	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489152	\N
2489	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489153	\N
2490	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489155	\N
2491	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489156	\N
2492	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489157	\N
2493	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:51:29.489159	\N
2494	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:51:29.48916	\N
2495	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489161	\N
2496	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489163	\N
2497	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489164	\N
2498	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489166	\N
2499	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489167	\N
2500	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489168	\N
2501	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48917	\N
2502	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489171	\N
2503	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489172	\N
2504	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489174	\N
2505	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489175	\N
2506	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489177	\N
2507	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489178	\N
2508	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489179	\N
2509	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489181	\N
2510	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489182	\N
2511	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489183	\N
2512	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489185	\N
2513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489186	\N
2514	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489188	\N
2515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489189	\N
2516	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48919	\N
2517	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489192	\N
2518	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489193	\N
2519	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489194	\N
2520	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489196	\N
2521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489197	\N
2522	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489199	\N
2523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.4892	\N
2524	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489201	\N
2525	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489203	\N
2526	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489204	\N
2527	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489206	\N
2528	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489207	\N
2529	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489208	\N
2530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48921	\N
2531	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489211	\N
2532	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489212	\N
2533	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489214	\N
2534	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489215	\N
2535	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489217	\N
2536	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489218	\N
2537	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489219	\N
2538	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489221	\N
2539	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489222	\N
2540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489224	\N
2541	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489225	\N
2542	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489226	\N
2543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489228	\N
2544	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489229	\N
2545	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489231	\N
2546	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489232	\N
2547	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489233	\N
2548	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489235	\N
2549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489236	\N
2550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489237	\N
2551	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489239	\N
2552	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48924	\N
2553	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489242	\N
2554	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489243	\N
2555	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489244	\N
2556	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489246	\N
2557	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489247	\N
2558	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489248	\N
2559	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48925	\N
2560	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489251	\N
2561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489253	\N
2562	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489254	\N
2563	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489255	\N
2564	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489257	\N
2565	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489258	\N
2566	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489259	\N
2567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489261	\N
2568	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489262	\N
2569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489264	\N
2570	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489265	\N
2571	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489266	\N
2572	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489268	\N
2573	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489269	\N
2574	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48927	\N
2575	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489272	\N
2576	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489273	\N
2577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489275	\N
2578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489276	\N
2579	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489277	\N
2580	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489279	\N
2581	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.48928	\N
2582	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489281	\N
2583	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489283	\N
2584	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489284	\N
2585	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489286	\N
2586	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489287	\N
2587	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489288	\N
2588	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48929	\N
2589	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489291	\N
2590	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489292	\N
2591	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489294	\N
2592	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489295	\N
2593	555	555	1999	article	draft	\N	16	2025-02-25 03:51:29.489296	\N
2594	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489298	\N
2595	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489299	\N
2596	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489301	\N
2597	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489302	\N
2598	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489303	\N
2599	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489305	\N
2600	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489306	\N
2601	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489307	\N
2602	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489309	\N
2603	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48931	\N
2604	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489312	\N
2605	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489313	\N
2606	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489314	\N
2607	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489316	\N
2608	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489317	\N
2609	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489318	\N
2610	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48932	\N
2611	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489321	\N
2612	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489323	\N
2613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489324	\N
2614	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489325	\N
2615	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489327	\N
2616	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489328	\N
2617	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489329	\N
2618	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489331	\N
2619	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489332	\N
2620	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489334	\N
2621	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489335	\N
2622	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489336	\N
2623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489338	\N
2624	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489339	\N
2625	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48934	\N
2626	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489342	\N
2627	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489343	\N
2628	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489345	\N
2629	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489346	\N
2630	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489347	\N
2631	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489349	\N
2632	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48935	\N
2633	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489351	\N
2634	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489353	\N
2635	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489354	\N
2636	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489356	\N
2637	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489357	\N
2638	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489358	\N
2639	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48936	\N
2640	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489361	\N
2641	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489362	\N
2642	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489364	\N
2643	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489365	\N
2644	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489366	\N
2645	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489368	\N
2646	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489369	\N
2647	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489371	\N
2648	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489372	\N
2649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489373	\N
2650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489375	\N
2651	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489376	\N
2652	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489377	\N
2653	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489379	\N
2654	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48938	\N
2655	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489382	\N
2656	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489383	\N
2657	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489384	\N
2658	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489386	\N
2659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489387	\N
2660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489388	\N
2661	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48939	\N
2662	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489391	\N
2663	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489392	\N
2664	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489394	\N
2665	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489395	\N
2666	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489397	\N
2667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489398	\N
2668	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489399	\N
2669	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489401	\N
2670	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489402	\N
2671	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489403	\N
2672	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489405	\N
2673	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489406	\N
2674	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489408	\N
2675	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489409	\N
2676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48941	\N
2677	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489412	\N
2678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489413	\N
2679	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489414	\N
2680	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489416	\N
2681	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489417	\N
2682	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489418	\N
2683	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48942	\N
2684	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489421	\N
2685	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489423	\N
2686	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489424	\N
2687	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489425	\N
2688	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489427	\N
2689	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489428	\N
2690	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489429	\N
2691	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489431	\N
2692	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489432	\N
2693	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489434	\N
2694	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489435	\N
2695	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489436	\N
2696	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489438	\N
2697	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489439	\N
2698	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48944	\N
2699	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489442	\N
2700	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489443	\N
2701	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489444	\N
2702	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489446	\N
2703	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489447	\N
2704	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489449	\N
2705	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:51:29.48945	\N
2706	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489451	\N
2707	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489453	\N
2708	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489454	\N
2709	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489455	\N
2710	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489457	\N
2711	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489458	\N
2712	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48946	\N
2713	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489461	\N
2714	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489462	\N
2715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489464	\N
2716	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489465	\N
2717	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489466	\N
2718	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489468	\N
2719	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489469	\N
2720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48947	\N
2721	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489472	\N
2722	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489473	\N
2723	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489475	\N
2724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489476	\N
2725	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489477	\N
2726	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489479	\N
2727	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48948	\N
2728	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489481	\N
2729	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489483	\N
2730	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489484	\N
2731	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489486	\N
2732	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489487	\N
2733	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489488	\N
2734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48949	\N
2735	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489491	\N
2736	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489492	\N
2737	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489494	\N
2738	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489495	\N
2739	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489496	\N
2740	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489498	\N
2741	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489499	\N
2742	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489501	\N
2743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489502	\N
2744	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489503	\N
2745	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489505	\N
2746	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489506	\N
2747	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489507	\N
2748	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489509	\N
2749	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48951	\N
2750	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489512	\N
2751	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489513	\N
2752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489514	\N
2753	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489516	\N
2754	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489517	\N
2755	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489518	\N
2756	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48952	\N
2757	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489521	\N
2758	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489522	\N
2759	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489524	\N
2760	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489525	\N
2761	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489527	\N
2762	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489528	\N
2763	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489529	\N
2764	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489531	\N
2765	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489532	\N
2766	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489533	\N
2767	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489535	\N
2768	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489536	\N
2769	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489538	\N
2770	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489539	\N
2771	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48954	\N
2772	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489542	\N
2773	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489543	\N
2774	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489544	\N
2775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489546	\N
2776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489547	\N
2777	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489548	\N
2778	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.48955	\N
2779	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489551	\N
2780	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489553	\N
2781	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489554	\N
2782	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489556	\N
2783	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489557	\N
2784	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489558	\N
2785	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48956	\N
2786	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489561	\N
2787	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489562	\N
2788	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489564	\N
2789	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489565	\N
2790	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:51:29.489567	\N
2791	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:51:29.489568	\N
2792	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489569	\N
2793	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489571	\N
2794	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489572	\N
2795	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489573	\N
2796	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489575	\N
2797	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489576	\N
2798	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489578	\N
2799	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489579	\N
2800	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48958	\N
2801	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489582	\N
2802	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489583	\N
2803	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489584	\N
2804	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489586	\N
2805	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489587	\N
2806	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489588	\N
2807	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48959	\N
2808	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489591	\N
2809	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489593	\N
2810	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489594	\N
2811	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489595	\N
2812	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489597	\N
2813	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489598	\N
2814	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489599	\N
2815	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489601	\N
2816	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489602	\N
2817	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489604	\N
2818	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489605	\N
2819	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489606	\N
2820	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489608	\N
2821	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489609	\N
2822	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48961	\N
2823	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489612	\N
2824	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489613	\N
2825	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489614	\N
2826	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489616	\N
2827	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489617	\N
2828	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489619	\N
2829	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48962	\N
2830	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489621	\N
2831	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489623	\N
2832	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489624	\N
2833	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489625	\N
2834	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489627	\N
2835	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489628	\N
2836	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48963	\N
2837	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489631	\N
2838	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489632	\N
2839	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489634	\N
2840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489635	\N
2841	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489636	\N
2842	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489638	\N
2843	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489639	\N
2844	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48964	\N
2845	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489642	\N
2846	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489643	\N
2847	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489645	\N
2848	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489646	\N
2849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489647	\N
2850	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489649	\N
2851	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48965	\N
2852	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489651	\N
2853	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489653	\N
2854	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489654	\N
2855	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489656	\N
2856	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489657	\N
2857	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489658	\N
2858	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48966	\N
2859	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489661	\N
2860	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489662	\N
2861	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489664	\N
2862	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489665	\N
2863	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489667	\N
2864	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489668	\N
2865	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48967	\N
2866	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489671	\N
2867	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489672	\N
2868	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489674	\N
2869	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489675	\N
2870	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489676	\N
2871	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489678	\N
2872	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489679	\N
2873	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489681	\N
2874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489682	\N
2875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489683	\N
2876	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489685	\N
2877	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489686	\N
2878	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489687	\N
2879	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489689	\N
2881	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489692	\N
2882	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489693	\N
2883	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489694	\N
2884	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489696	\N
2885	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489697	\N
2886	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489698	\N
2887	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.4897	\N
2888	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489701	\N
2889	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489702	\N
2890	555	555	1999	article	draft	\N	16	2025-02-25 03:51:29.489704	\N
2891	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489705	\N
2892	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489707	\N
2893	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489708	\N
2894	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489709	\N
2895	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489711	\N
2896	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489712	\N
2897	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489713	\N
2898	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489715	\N
2899	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489716	\N
2900	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489718	\N
2901	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489719	\N
2902	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48972	\N
2903	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489722	\N
2904	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489723	\N
2905	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489724	\N
2906	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489726	\N
2907	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489727	\N
2908	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489729	\N
2909	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48973	\N
2910	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489731	\N
2911	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489733	\N
2912	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489734	\N
2913	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489735	\N
2914	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489737	\N
2915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489738	\N
2916	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489739	\N
2917	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489741	\N
2918	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489742	\N
2919	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489744	\N
2920	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489745	\N
2921	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489746	\N
2922	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489748	\N
2923	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489749	\N
2924	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48975	\N
2925	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489752	\N
2926	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489753	\N
2927	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489755	\N
2928	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489756	\N
2929	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489757	\N
2930	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489759	\N
2931	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.48976	\N
2932	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489761	\N
2933	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489763	\N
2934	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489764	\N
2935	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489765	\N
2936	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489767	\N
2937	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489768	\N
2938	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48977	\N
2939	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489771	\N
2940	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489772	\N
2941	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489774	\N
2942	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489775	\N
2943	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489776	\N
2944	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489778	\N
2945	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489779	\N
2946	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489781	\N
2947	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489782	\N
2948	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489783	\N
2949	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489785	\N
2950	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489786	\N
2951	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489787	\N
2952	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489789	\N
2953	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48979	\N
2954	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489792	\N
2955	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489793	\N
2956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489794	\N
2957	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489796	\N
2958	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489797	\N
2959	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489798	\N
2960	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.4898	\N
2961	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489801	\N
2962	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489803	\N
2963	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489804	\N
2964	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489805	\N
2965	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489807	\N
2966	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489808	\N
2967	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489809	\N
2968	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489811	\N
2969	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489812	\N
2970	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489814	\N
2971	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489815	\N
2972	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489816	\N
2973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489818	\N
2974	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489819	\N
2975	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48982	\N
2976	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489822	\N
2977	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489823	\N
2978	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489824	\N
2979	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489826	\N
2980	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489827	\N
2981	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48983	\N
2982	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489832	\N
2983	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489833	\N
2984	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489834	\N
2985	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489836	\N
2986	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489837	\N
2987	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489839	\N
2988	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.48984	\N
2989	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489841	\N
2990	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489843	\N
2991	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489844	\N
2992	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489845	\N
2993	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489847	\N
2994	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489848	\N
2995	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48985	\N
2996	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489851	\N
2997	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489852	\N
2998	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489854	\N
2999	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489855	\N
3000	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489856	\N
3001	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489858	\N
3002	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:51:29.489859	\N
3003	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489861	\N
3004	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489862	\N
3005	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489863	\N
3006	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489865	\N
3007	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489866	\N
3008	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489867	\N
3009	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489869	\N
3010	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48987	\N
3011	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489871	\N
3012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489873	\N
3013	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489874	\N
3014	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489876	\N
3015	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489877	\N
3016	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489878	\N
3017	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48988	\N
3018	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489881	\N
3019	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489883	\N
3020	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489884	\N
3021	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489885	\N
3022	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489887	\N
3023	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489888	\N
3024	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489889	\N
3025	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489891	\N
3026	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489892	\N
3027	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489893	\N
3028	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489895	\N
3029	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489896	\N
3030	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489898	\N
3031	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489899	\N
3032	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.4899	\N
3033	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489902	\N
3034	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489903	\N
3035	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489905	\N
3036	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489906	\N
3037	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489907	\N
3038	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489909	\N
3039	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48991	\N
3040	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489911	\N
3041	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489913	\N
3042	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489914	\N
3043	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489915	\N
3044	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489917	\N
3045	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489918	\N
3046	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48992	\N
3047	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489921	\N
3048	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489922	\N
3049	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489924	\N
3050	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489925	\N
3051	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489926	\N
3052	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489928	\N
3053	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489929	\N
3054	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489931	\N
3055	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489932	\N
3056	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489933	\N
3057	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489935	\N
3058	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489936	\N
3059	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489937	\N
3060	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489939	\N
3061	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48994	\N
3062	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489942	\N
3063	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489943	\N
3064	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489944	\N
3065	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489946	\N
3066	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489947	\N
3067	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489948	\N
3068	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48995	\N
3069	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489951	\N
3070	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489953	\N
3071	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489954	\N
3072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489955	\N
3073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489957	\N
3074	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489958	\N
3075	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489959	\N
3076	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489961	\N
3077	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489962	\N
3078	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489964	\N
3079	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489965	\N
3080	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489966	\N
3081	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489968	\N
3082	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489969	\N
3083	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48997	\N
3084	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489972	\N
3085	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489973	\N
3086	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489974	\N
3087	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:51:29.489976	\N
3088	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:51:29.489977	\N
3089	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489979	\N
3090	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.48998	\N
3091	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489981	\N
3092	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489983	\N
3093	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489984	\N
3094	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489985	\N
3095	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489987	\N
3096	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489988	\N
3097	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48999	\N
3098	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489991	\N
3099	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489992	\N
3100	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489994	\N
3101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489995	\N
3102	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489996	\N
3103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489998	\N
3104	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489999	\N
3105	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490001	\N
3106	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490002	\N
3107	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490003	\N
3108	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490005	\N
3109	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490006	\N
3110	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490007	\N
3111	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490009	\N
3112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.49001	\N
3113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490011	\N
3114	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490013	\N
3115	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490014	\N
3116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490016	\N
3117	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490017	\N
3118	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490018	\N
3119	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.49002	\N
3120	ddsdf	test1ы	2015	article	draft	\N	16	2025-02-25 03:51:29.490021	\N
3121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490023	\N
3122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490024	\N
3123	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490025	\N
3124	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490027	\N
3125	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490028	\N
3126	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490029	\N
3127	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490031	\N
3128	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490032	\N
3129	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.490033	\N
3130	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490035	\N
3131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490036	\N
3132	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490038	\N
3133	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490039	\N
3134	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.49004	\N
3135	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490042	\N
3136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490043	\N
3137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490044	\N
3138	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490046	\N
3139	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490047	\N
3140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490049	\N
3141	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.49005	\N
3142	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490051	\N
3143	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490053	\N
3144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490054	\N
3145	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490055	\N
3146	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490057	\N
3147	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490058	\N
3148	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.49006	\N
3149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490061	\N
3150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490062	\N
3151	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490064	\N
3152	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490065	\N
3153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490066	\N
3154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490068	\N
3155	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490069	\N
3156	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.49007	\N
3157	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490072	\N
3158	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490073	\N
3159	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490075	\N
3160	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490076	\N
3161	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490077	\N
3162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490079	\N
3163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.49008	\N
3164	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490081	\N
3165	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.490083	\N
3166	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490084	\N
3167	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490085	\N
3168	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490087	\N
3169	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490088	\N
3170	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.49009	\N
3171	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490091	\N
3172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490092	\N
3173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490094	\N
3174	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490095	\N
3175	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.490096	\N
3176	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.490098	\N
3177	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490099	\N
3178	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490101	\N
3179	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490102	\N
3180	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490103	\N
3181	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490105	\N
3182	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	draft	\N	16	2025-02-25 03:51:29.490106	\N
3183	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490107	\N
3184	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490109	\N
3185	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.49011	\N
3186	длолд111111111111111111111	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.490112	\N
3187	555	555ы	1999	article	draft	\N	16	2025-02-25 03:51:29.490113	\N
3193	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142021	\N
3194	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142024	\N
3195	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142025	\N
3196	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142027	\N
3197	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142028	\N
3198	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14203	\N
3199	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142031	\N
3200	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142032	\N
3201	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142034	\N
3202	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142035	\N
3203	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142037	\N
3204	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142038	\N
3205	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142039	\N
3206	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14204	\N
3207	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142042	\N
3208	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142043	\N
3209	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142045	\N
3210	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142046	\N
3211	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142047	\N
3212	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142048	\N
3213	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14205	\N
3214	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142051	\N
3215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142052	\N
3216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142054	\N
3217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142055	\N
3218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142057	\N
3219	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142058	\N
3220	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14206	\N
3221	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142061	\N
3222	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142062	\N
3229	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142072	\N
3230	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142073	\N
3231	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142074	\N
3232	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142076	\N
3233	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142077	\N
3234	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142078	\N
3235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14208	\N
3236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142081	\N
3237	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142082	\N
3238	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142084	\N
3239	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142085	\N
3240	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142086	\N
3241	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142088	\N
3242	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142089	\N
3243	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14209	\N
3244	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142092	\N
3245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142093	\N
3246	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142094	\N
3247	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142096	\N
3248	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142097	\N
3249	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142099	\N
3250	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.1421	\N
3251	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142101	\N
3252	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142103	\N
3253	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142104	\N
3254	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142105	\N
3255	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142107	\N
3256	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142108	\N
3257	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142109	\N
3258	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14211	\N
3259	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142112	\N
3260	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142113	\N
3261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142115	\N
3262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142116	\N
3263	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142117	\N
3264	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142119	\N
3265	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14212	\N
3266	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142121	\N
3267	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142123	\N
3268	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142124	\N
3269	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142125	\N
3270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142126	\N
3271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142128	\N
3272	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142129	\N
3273	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14213	\N
3274	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142132	\N
3275	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142133	\N
3276	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142134	\N
3277	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142136	\N
3278	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142137	\N
3279	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142138	\N
3280	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14214	\N
3281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142141	\N
3282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142142	\N
3283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142144	\N
3284	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142145	\N
3285	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142146	\N
3286	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142147	\N
3287	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142149	\N
3288	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14215	\N
3289	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142151	\N
3290	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142153	\N
3291	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142154	\N
3292	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142155	\N
3293	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142157	\N
3294	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142158	\N
3295	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142159	\N
3296	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142161	\N
3297	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142162	\N
3298	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142163	\N
3299	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142164	\N
3300	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142166	\N
3301	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142167	\N
3302	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 23:54:36.142168	\N
3303	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14217	\N
3304	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142171	\N
3305	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142172	\N
3306	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142174	\N
3307	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142175	\N
3308	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142177	\N
3309	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142178	\N
3310	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14218	\N
3311	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142181	\N
3312	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142182	\N
3313	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142183	\N
3314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142185	\N
3315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142186	\N
3316	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142188	\N
3317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142189	\N
3318	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14219	\N
3319	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142192	\N
3320	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142193	\N
3321	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142194	\N
3322	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142196	\N
3323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142197	\N
3324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142198	\N
3325	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.1422	\N
3326	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142201	\N
3327	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142202	\N
3328	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142204	\N
3329	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142205	\N
3330	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142206	\N
3331	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142207	\N
3332	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142209	\N
3333	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14221	\N
3334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142211	\N
3335	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142213	\N
3336	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142214	\N
3337	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142215	\N
3338	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142217	\N
3339	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142218	\N
3340	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142219	\N
3341	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142221	\N
3342	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142222	\N
3343	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142223	\N
3344	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142225	\N
3345	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142226	\N
3346	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142227	\N
3347	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142229	\N
3348	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14223	\N
3349	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142231	\N
3350	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142233	\N
3351	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142234	\N
3352	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142235	\N
3353	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142237	\N
3354	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142238	\N
3355	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142239	\N
3356	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142241	\N
3357	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142242	\N
3358	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142243	\N
3359	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142245	\N
3360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142246	\N
3361	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142247	\N
3362	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142249	\N
3363	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14225	\N
3364	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142251	\N
3365	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142253	\N
3366	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142254	\N
3367	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142255	\N
3368	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142257	\N
3369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142258	\N
3370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142259	\N
3371	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142261	\N
3372	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142262	\N
3373	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142263	\N
3374	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142264	\N
3375	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142266	\N
3376	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142267	\N
3377	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142269	\N
3378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14227	\N
3379	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142271	\N
3380	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142272	\N
3381	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142274	\N
3382	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142275	\N
3383	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142276	\N
3384	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142278	\N
3385	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142279	\N
3386	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14228	\N
3387	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 23:54:36.142282	\N
3388	авп	ыва	1992	article	draft	\N	16	2025-02-25 23:54:36.142283	\N
3389	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142284	\N
3390	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142286	\N
3391	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142287	\N
3392	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142288	\N
3393	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.14229	\N
3394	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142291	\N
3395	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142292	\N
3396	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142294	\N
3397	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142295	\N
3398	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142296	\N
3399	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142298	\N
3400	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142299	\N
3401	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.1423	\N
3402	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142301	\N
3403	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142303	\N
3404	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142304	\N
3405	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142306	\N
3406	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142308	\N
3407	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14231	\N
3408	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142312	\N
3409	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142313	\N
3410	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142315	\N
3411	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142316	\N
3412	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142317	\N
3413	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142319	\N
3414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14232	\N
3415	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142321	\N
3416	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142322	\N
3417	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142324	\N
3418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142325	\N
3419	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142326	\N
3420	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142328	\N
3421	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142329	\N
3422	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14233	\N
3423	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142332	\N
3424	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142333	\N
3425	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142334	\N
3426	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142336	\N
3427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142337	\N
3428	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142338	\N
3429	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14234	\N
3430	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142341	\N
3431	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142342	\N
3432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142344	\N
3433	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142345	\N
3434	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142346	\N
3435	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142347	\N
3436	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142349	\N
3437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14235	\N
3438	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142352	\N
3439	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142353	\N
3440	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142354	\N
3441	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142356	\N
3442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142357	\N
3443	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142358	\N
3444	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14236	\N
3445	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142361	\N
3446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142362	\N
3447	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142363	\N
3448	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142365	\N
3449	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142366	\N
3450	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142367	\N
3451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142369	\N
3452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14237	\N
3453	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142371	\N
3454	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142373	\N
3455	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142374	\N
3456	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142375	\N
3457	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142377	\N
3458	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142378	\N
3459	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142379	\N
3460	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14238	\N
3461	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142382	\N
3462	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142383	\N
3463	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142384	\N
3464	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142386	\N
3465	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142387	\N
3466	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142388	\N
3467	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14239	\N
3468	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142391	\N
3469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142392	\N
3470	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142394	\N
3471	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142395	\N
3472	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142396	\N
3473	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142398	\N
3474	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142399	\N
3475	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.1424	\N
3476	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142401	\N
3477	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142403	\N
3478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142404	\N
3479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142405	\N
3480	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142407	\N
3481	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142408	\N
3482	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142409	\N
3483	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142411	\N
3484	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142412	\N
3485	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142413	\N
3486	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142415	\N
3487	555	555	1999	article	draft	\N	16	2025-02-25 23:54:36.142416	\N
3488	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142417	\N
3489	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142419	\N
3490	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.14242	\N
3491	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142421	\N
3492	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142423	\N
3493	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142424	\N
3494	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142425	\N
3495	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142427	\N
3496	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142428	\N
3497	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142429	\N
3498	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14243	\N
3499	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142432	\N
3500	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142433	\N
3501	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142435	\N
3502	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142438	\N
3503	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14244	\N
3504	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142441	\N
3505	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142443	\N
3506	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142444	\N
3507	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142445	\N
3508	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142447	\N
3509	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142448	\N
3510	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142449	\N
3511	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14245	\N
3512	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142452	\N
3513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142453	\N
3514	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142454	\N
3515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142456	\N
3516	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142457	\N
3517	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142458	\N
3518	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14246	\N
3519	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142461	\N
3520	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142462	\N
3521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142464	\N
3522	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142465	\N
3523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142467	\N
3524	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142468	\N
3525	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142469	\N
3526	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142471	\N
3527	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142472	\N
3528	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142473	\N
3529	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142475	\N
3530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142476	\N
3531	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142477	\N
3532	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142478	\N
3533	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14248	\N
3534	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142481	\N
3535	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142482	\N
3536	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142484	\N
3537	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142485	\N
3538	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142486	\N
3539	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142488	\N
3540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142489	\N
3541	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14249	\N
3542	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142492	\N
3543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142493	\N
3544	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142494	\N
3545	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142495	\N
3546	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142497	\N
3547	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142498	\N
3548	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142499	\N
3549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142501	\N
3550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142502	\N
3551	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142503	\N
3552	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142505	\N
3553	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142506	\N
3554	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142507	\N
3555	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142508	\N
3556	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14251	\N
3557	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142511	\N
3558	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142512	\N
3559	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142514	\N
3560	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142515	\N
3561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142516	\N
3562	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142518	\N
3563	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142519	\N
3564	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14252	\N
3565	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142522	\N
3566	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142523	\N
3567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142524	\N
3568	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142526	\N
3569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142527	\N
3570	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142528	\N
3571	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142529	\N
3572	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142531	\N
3573	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142532	\N
3574	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142533	\N
3575	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142535	\N
3576	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142536	\N
3577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142537	\N
3578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142539	\N
3579	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14254	\N
3580	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142541	\N
3581	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142543	\N
3582	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142544	\N
3583	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142545	\N
3584	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142546	\N
3585	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142548	\N
3586	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142549	\N
3587	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.14255	\N
3588	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142552	\N
3589	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142553	\N
3590	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142554	\N
3591	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142556	\N
3592	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142557	\N
3593	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142558	\N
3594	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142559	\N
3595	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142561	\N
3596	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142562	\N
3597	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142563	\N
3598	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142565	\N
3599	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 23:54:36.142566	\N
3600	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142567	\N
3601	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142569	\N
3602	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14257	\N
3603	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142571	\N
3604	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142573	\N
3605	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142574	\N
3606	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142575	\N
3607	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142577	\N
3608	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142578	\N
3609	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142579	\N
3610	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142581	\N
3611	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142582	\N
3612	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142583	\N
3613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142585	\N
3614	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142586	\N
3615	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142587	\N
3616	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142588	\N
3617	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14259	\N
3618	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142591	\N
3619	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142594	\N
3620	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142595	\N
3621	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142597	\N
3622	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142599	\N
3623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.1426	\N
3624	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142601	\N
3625	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142602	\N
3626	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142604	\N
3627	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142605	\N
3628	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142606	\N
3629	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142608	\N
3630	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142609	\N
3631	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14261	\N
3632	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142611	\N
3633	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142613	\N
3634	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142614	\N
3635	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142615	\N
3636	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142617	\N
3637	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142618	\N
3638	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142619	\N
3639	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142621	\N
3640	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142622	\N
3641	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142623	\N
3642	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142625	\N
3643	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142626	\N
3644	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142627	\N
3645	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142628	\N
3646	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14263	\N
3647	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142631	\N
3648	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142632	\N
3649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142634	\N
3650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142635	\N
3651	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142636	\N
3652	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142637	\N
3653	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142639	\N
3654	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14264	\N
3655	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142641	\N
3656	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142643	\N
3657	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142644	\N
3658	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142646	\N
3659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142647	\N
3660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142648	\N
3661	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142649	\N
3662	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142651	\N
3663	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142652	\N
3664	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142653	\N
3665	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142655	\N
3666	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142656	\N
3667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142657	\N
3668	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142659	\N
3669	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14266	\N
3670	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142661	\N
3671	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142662	\N
3672	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142664	\N
3673	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142665	\N
3674	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142666	\N
3675	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142668	\N
3676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142669	\N
3677	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14267	\N
3678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142672	\N
3679	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142673	\N
3680	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142674	\N
3681	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142676	\N
3682	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142677	\N
3683	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142678	\N
3684	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 23:54:36.14268	\N
3685	авп	ыва	1992	article	draft	\N	16	2025-02-25 23:54:36.142681	\N
3686	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142682	\N
3687	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142684	\N
3688	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142685	\N
3689	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142686	\N
3690	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142688	\N
3691	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142689	\N
3692	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14269	\N
3693	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142692	\N
3694	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142693	\N
3695	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142694	\N
3696	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142696	\N
3697	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142697	\N
3698	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142698	\N
3699	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.1427	\N
3700	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142701	\N
3701	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142703	\N
3702	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142704	\N
3703	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142705	\N
3704	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142706	\N
3705	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142708	\N
3706	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142709	\N
3707	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14271	\N
3708	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142712	\N
3709	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142713	\N
3710	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142714	\N
3711	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142716	\N
3712	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142717	\N
3713	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142718	\N
3714	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142719	\N
3715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142721	\N
3716	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142722	\N
3717	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142723	\N
3718	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142725	\N
3719	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142726	\N
3720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142727	\N
3721	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142729	\N
3722	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14273	\N
3723	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142731	\N
3724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142733	\N
3725	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142734	\N
3726	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142735	\N
3727	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142736	\N
3728	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142738	\N
3729	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142739	\N
3730	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14274	\N
3731	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142742	\N
3732	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142743	\N
3733	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142744	\N
3734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142746	\N
3735	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142747	\N
3736	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142748	\N
3737	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14275	\N
3738	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142751	\N
3739	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142752	\N
3740	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142754	\N
3741	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142755	\N
3742	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142756	\N
3743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142758	\N
3744	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142759	\N
3745	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14276	\N
3746	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142761	\N
3747	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142763	\N
3748	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142764	\N
3749	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142765	\N
3750	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142767	\N
3751	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142768	\N
3752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142769	\N
3753	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142771	\N
3754	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142772	\N
3755	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142773	\N
3756	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142775	\N
3757	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142776	\N
3758	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142777	\N
3759	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142778	\N
3760	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14278	\N
3761	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142781	\N
3762	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142782	\N
3763	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142784	\N
3764	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142785	\N
3765	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142786	\N
3766	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142787	\N
3767	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142789	\N
3768	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14279	\N
3769	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142791	\N
3770	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142793	\N
3771	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142794	\N
3772	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142795	\N
3773	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142797	\N
3774	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142798	\N
3775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142799	\N
3776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142801	\N
3777	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142802	\N
3778	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142803	\N
3779	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142804	\N
3780	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142806	\N
3781	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142807	\N
3782	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142808	\N
3783	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14281	\N
3784	555	555	1999	article	draft	\N	16	2025-02-25 23:54:36.142811	\N
3785	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142812	\N
3786	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142814	\N
3787	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142815	\N
3788	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142816	\N
3789	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142817	\N
3790	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142819	\N
3791	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14282	\N
3792	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142821	\N
3793	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142823	\N
3794	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142824	\N
3795	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142826	\N
3796	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142827	\N
3797	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142828	\N
3798	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142829	\N
3799	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142831	\N
3800	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142832	\N
3801	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142833	\N
3802	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142835	\N
3803	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142836	\N
3804	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142837	\N
3805	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142839	\N
3806	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14284	\N
3807	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142841	\N
3808	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142842	\N
3809	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142844	\N
3810	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142845	\N
3811	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142846	\N
3812	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142848	\N
3813	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142849	\N
3814	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14285	\N
3815	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142852	\N
3816	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142853	\N
3817	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142854	\N
3818	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142856	\N
3819	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142857	\N
3820	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142858	\N
3821	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14286	\N
3822	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142861	\N
3823	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142862	\N
3824	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142863	\N
3825	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142865	\N
3826	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142866	\N
3827	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142867	\N
3828	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142869	\N
3829	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14287	\N
3830	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142871	\N
3831	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142873	\N
3832	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142874	\N
3833	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142875	\N
3834	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142876	\N
3835	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142878	\N
3836	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142879	\N
3837	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14288	\N
3838	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142882	\N
3839	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142883	\N
3840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142884	\N
3841	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142886	\N
3842	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142887	\N
3843	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142888	\N
3844	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142889	\N
3845	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142891	\N
3846	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142892	\N
3847	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142893	\N
3848	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142895	\N
3849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142896	\N
3850	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142897	\N
3851	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142898	\N
3852	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.1429	\N
3853	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142901	\N
3854	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142902	\N
3855	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142904	\N
3856	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142905	\N
3857	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142906	\N
3858	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142908	\N
3859	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142909	\N
3860	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14291	\N
3861	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142912	\N
3862	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142913	\N
3863	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142914	\N
3864	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142915	\N
3865	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142917	\N
3866	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142918	\N
3867	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142919	\N
3868	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142921	\N
3869	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142922	\N
3870	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142923	\N
3871	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142925	\N
3872	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142926	\N
3873	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142928	\N
3874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142929	\N
3875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14293	\N
3876	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142932	\N
3877	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142933	\N
3878	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142934	\N
3879	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142936	\N
3880	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142937	\N
3881	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142938	\N
3882	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142939	\N
3883	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142941	\N
3884	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142942	\N
3885	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142943	\N
3886	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142945	\N
3887	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142946	\N
3888	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142947	\N
3889	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142948	\N
3890	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14295	\N
3891	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142951	\N
3892	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142952	\N
3893	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142954	\N
3894	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142955	\N
3895	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142956	\N
3896	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 23:54:36.142958	\N
3897	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142959	\N
3898	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14296	\N
3899	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142961	\N
3900	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142963	\N
3901	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142964	\N
3902	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142965	\N
3903	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142967	\N
3906	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142971	\N
3907	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142972	\N
3908	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142973	\N
3909	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142974	\N
3910	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142976	\N
3911	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142977	\N
3912	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142979	\N
3913	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14298	\N
3914	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142981	\N
3915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142982	\N
3916	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142984	\N
3917	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142985	\N
3918	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142986	\N
3919	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142988	\N
3920	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142989	\N
3921	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14299	\N
3922	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142992	\N
3923	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142993	\N
3924	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142994	\N
3925	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142995	\N
3926	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142997	\N
3927	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142998	\N
3928	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142999	\N
3929	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143001	\N
3930	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143002	\N
3931	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143003	\N
3932	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143005	\N
3933	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143006	\N
3934	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143007	\N
3935	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143008	\N
3936	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14301	\N
3937	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143011	\N
3938	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143012	\N
3939	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143014	\N
3940	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143015	\N
3941	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143016	\N
3942	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143018	\N
3943	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143019	\N
3944	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14302	\N
3945	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143021	\N
3946	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143023	\N
3947	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143024	\N
3948	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143026	\N
3949	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143027	\N
3950	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143028	\N
3951	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14303	\N
3952	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143031	\N
3953	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143032	\N
3954	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143033	\N
3955	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143035	\N
3956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143036	\N
3957	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143037	\N
3958	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143039	\N
3959	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14304	\N
3960	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143041	\N
3961	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143043	\N
3962	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143044	\N
3963	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143045	\N
3964	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143046	\N
3965	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143048	\N
3966	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143049	\N
3967	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14305	\N
3968	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143052	\N
3969	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143053	\N
3970	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.143054	\N
3971	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143056	\N
3972	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143057	\N
3973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143058	\N
3974	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14306	\N
3975	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143061	\N
3976	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143062	\N
3977	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143063	\N
3978	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143065	\N
3979	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143066	\N
3980	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143068	\N
3981	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 23:54:36.143069	\N
3982	авп	ыва	1992	article	draft	\N	16	2025-02-25 23:54:36.14307	\N
3983	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.143071	\N
3984	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.143073	\N
3985	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.143074	\N
3986	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.143075	\N
3987	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.143077	\N
3988	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143078	\N
3989	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143079	\N
3990	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143081	\N
3991	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143082	\N
3992	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143083	\N
3993	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143085	\N
3994	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143086	\N
3995	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143087	\N
3996	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143089	\N
3997	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14309	\N
3998	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143091	\N
3999	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143092	\N
4000	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143094	\N
4001	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143095	\N
4002	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143098	\N
4003	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143099	\N
4004	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.1431	\N
4005	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143102	\N
4006	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143104	\N
4007	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143105	\N
4008	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143106	\N
4009	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143108	\N
4010	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143109	\N
4011	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14311	\N
4012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143112	\N
4013	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143113	\N
4014	ddsdf	test1ы	2015	article	draft	\N	16	2025-02-25 23:54:36.143114	\N
4015	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143116	\N
4016	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143117	\N
4017	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143118	\N
4018	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143119	\N
4019	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143121	\N
4020	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143122	\N
4021	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143123	\N
4022	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143125	\N
4023	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143126	\N
4024	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143127	\N
4025	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143129	\N
4026	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14313	\N
4027	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143131	\N
4028	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143133	\N
4029	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143134	\N
4030	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143135	\N
4031	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143137	\N
4032	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143138	\N
4033	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143139	\N
4034	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14314	\N
4035	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143142	\N
4036	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143143	\N
4037	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143144	\N
4038	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143146	\N
4039	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143147	\N
4040	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143148	\N
4043	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143152	\N
4044	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143153	\N
4045	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143155	\N
4046	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143156	\N
4047	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143157	\N
4048	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143159	\N
4049	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14316	\N
4050	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143161	\N
4051	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143163	\N
4052	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143164	\N
4053	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143165	\N
4054	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143167	\N
4055	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143168	\N
4056	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143169	\N
4057	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143171	\N
4058	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143172	\N
4059	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143173	\N
4060	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143174	\N
4061	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143176	\N
4062	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143177	\N
4063	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143178	\N
4064	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14318	\N
4065	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143181	\N
4066	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143183	\N
4067	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143185	\N
4068	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143187	\N
4069	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143188	\N
4070	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.14319	\N
4071	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143191	\N
4072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143192	\N
4073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143194	\N
4074	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143195	\N
4075	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143196	\N
4076	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	draft	\N	16	2025-02-25 23:54:36.143197	\N
4077	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143199	\N
4078	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.1432	\N
4079	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143201	\N
4080	длолд111111111111111111111	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143203	\N
4081	555	555ы	1999	article	draft	\N	16	2025-02-25 23:54:36.143204	\N
4082	выаыва	ываыва	2011	article	draft	\N	16	2025-02-25 23:54:36.143205	\N
4083	dddddd	dddddd	2011	article	review	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	20	2025-02-26 00:12:28.817312	\N
4084	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	20	2025-02-26 00:12:51.080084	\N
4085	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	20	2025-02-26 00:12:51.080088	\N
4086	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	20	2025-02-26 00:12:51.08009	\N
4087	Robotics and Automation	Evans, Linda	2021	article	draft	\N	20	2025-02-26 00:12:51.080092	\N
4088	dfd	sdfs	2022	article	draft	\N	20	2025-02-26 00:12:51.080093	\N
4089	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080095	\N
4090	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080096	\N
4091	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080097	\N
4092	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080099	\N
4093	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.0801	\N
4094	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080102	\N
4095	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080103	\N
4096	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080104	\N
4097	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080106	\N
4098	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080107	\N
4099	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080108	\N
4100	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.08011	\N
4101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080111	\N
4102	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080113	\N
4103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080114	\N
4104	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080115	\N
4105	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080117	\N
4106	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080118	\N
4107	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080119	\N
4108	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080121	\N
4109	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080122	\N
4110	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080123	\N
4111	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080125	\N
4112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080126	\N
4113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080128	\N
4114	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080129	\N
4115	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.08013	\N
4116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080132	\N
4117	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080133	\N
4118	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080134	\N
4119	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080136	\N
4120	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080137	\N
4121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080138	\N
4122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.08014	\N
4123	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080141	\N
4124	длолд	ирмтми	2015	article	draft	\N	20	2025-02-26 00:12:51.080143	\N
4125	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080144	\N
4126	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080145	\N
4127	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080147	\N
4128	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080148	\N
4129	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080149	\N
4130	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080151	\N
4131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080152	\N
4132	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080153	\N
4133	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080155	\N
4134	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080156	\N
4135	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080158	\N
4136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080159	\N
4137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.08016	\N
4138	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080162	\N
4139	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080163	\N
4140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080164	\N
4141	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080166	\N
4142	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080167	\N
4143	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080168	\N
4144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.08017	\N
4145	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080171	\N
4146	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080173	\N
4147	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080174	\N
4148	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080175	\N
4149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080177	\N
4150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080178	\N
4151	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080179	\N
4152	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080181	\N
4153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080182	\N
4154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080183	\N
4155	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080185	\N
4156	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080186	\N
4157	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080187	\N
4158	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080189	\N
4159	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.08019	\N
4160	длолд	ирмтми	2015	article	draft	\N	20	2025-02-26 00:12:51.080192	\N
4161	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080193	\N
4162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080194	\N
4163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080196	\N
4164	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080197	\N
4165	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080198	\N
4166	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.0802	\N
4167	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080201	\N
4168	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080203	\N
4169	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080204	\N
4170	длолд	ирмтми	2015	article	draft	\N	20	2025-02-26 00:12:51.080205	\N
4171	dfg	dfgdfg	2023	article	draft	\N	20	2025-02-26 00:12:51.080207	\N
4172	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080208	\N
4173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080209	\N
4174	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080211	\N
4175	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080212	\N
4176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080214	\N
4177	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080215	\N
4178	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080216	\N
4179	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080218	\N
4180	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080219	\N
4181	длолд	ирмтми	2015	article	draft	\N	20	2025-02-26 00:12:51.08022	\N
156	Разработка автоматизированнной системы	Шамиль и Виталик	2025	article	published	D:\\publication-system\\backend\\uploads\\4411__3_1.docx	\N	2025-02-26 00:58:52.335399	\N
1399	выа	выаываs	2011	article	published	D:\\publication-system\\backend\\uploads\\TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-26 01:26:02.701009	\N
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, username, password_hash, role, last_name, first_name, middle_name, created_at, updated_at) FROM stdin;
18	deleted_user	scrypt:32768:8:1$38YLIfnFjItDTVkh$78c0537741c39984281623819bdb212558d5c136ed65f0e6b79fd651bf8b2c91333d171478c25678dbde529b6fa09e5ca552b2e93d98f4c7ef1fd8d30d774163	deleted	\N	\N	\N	2025-02-22 21:50:17.306578	2025-02-22 21:50:17.306578
11	admin	scrypt:32768:8:1$Xb4PJnpw58lA05fu$c11917d4db472bbcd7b1fdd622161bd23db2f39e29c007d3d44291f266ec3d1cef6b3a41642751947d8a2aa4cade807d6d79bd2a5546762bede972f4b425282a	admin	Adminov	Admin	Adminovich	2025-02-21 18:27:01.941445	2025-02-21 18:27:01.941445
20	dddddd	scrypt:32768:8:1$0011XhdirMkeq4oL$07ea1e50a0f74226ad6434fb30e304761d6bb2c26c24dae61463f36bf70fbef6855a342310b50cb2534bc8b96dafee4d744b6e1b66cdcd9ec83a95f1580afe31	user	dddddd	dddddd	dddddd	2025-02-26 00:12:02.077058	2025-02-26 00:12:02.077058
7	test3	scrypt:32768:8:1$46vqkRsfKayXABUf$03126ce87fde7bd1b845bce8056dff4e137eca8b4e9086639e9a1170aff222ec41d78aed72814847c86a2572714f846cd691ad428db6219c641b2cca961e4d92	user	Ивановы	Иван	Иванович	2025-02-20 15:36:42.152142	2025-02-20 15:36:42.152142
16	TheShamRio	scrypt:32768:8:1$QMdPXu7VqNIZiykR$0af94e210620a6c89ce1b8fabd4af06ed1599609f0377ccada02389f951f0d566fbb5f065346622e7450ee41de5cb32ae3d118cd9d1d2a84002a6b1560b25457	user	Хасаншинs	Шамиль	Равгатович	2025-02-22 19:47:14.708751	2025-02-22 19:47:14.708751
6	test2	scrypt:32768:8:1$KR3sQYKHRmCyk2eU$79b5eaacea9a759e04b18a0f6e065582bc9520867fe070b930761fa51ee7219d74f63ad91c7b82d8c87b07f43428fbf28a1eb1f0e045418e8d3eef45d20c180a	user	\N	\N	\N	2025-02-22 13:53:34.409453	2025-02-22 13:53:34.409453
9	 Papas	scrypt:32768:8:1$acSOmEAC5U8qRMJw$2c86cb2eb1d0f585b45f7c00ca8fc577a12157ff80df5e636a517f3bddee88a65a8f2f9c21939ff7baccffc7baeb3edf87661ea2aed7699e2ae9588047350e41	user	 Papas	 Papa	 Papa	2025-02-21 12:56:48.630524	2025-02-21 12:56:48.630524
5	test1	scrypt:32768:8:1$HoElhhL6bGNZwjwT$3f25ca66e7b09bb68aad88ab4b0068036e2abed27d0347734aa960f49b116f11367338d3f0af365d8f165df400c102cbef3436f130fe78ad9362a95bc8b1eea4	user	Закиев	Замиры	Магомедович	2025-02-22 13:53:34.409453	2025-02-22 13:53:34.409453
13	test11	scrypt:32768:8:1$cwetAVU49dCyMdzK$a59c241e73681e0c11b0c37de64518e3953e5b546d2736b6b6295828e31dc513776a661a2d7327c3ecd010dcf1b1a5279e1b0020127278af430b8192e24aba71	user	test11	test11	test11s	2025-02-22 12:12:10.634449	2025-02-22 12:12:10.634449
19	TEST2	scrypt:32768:8:1$0o1sOj7sXtGWrSpw$f9ae9950e26e8457edac22066e811958feccc226458f143ec5b2838ab5b97f599a90b53d055bc1f50151f0feaf6dbcc6c68dd2a5b1a65c9bfc065d500044d4c9	user	TEST2	TEST2	TEST2	2025-02-24 22:00:21.225144	2025-02-24 22:00:21.225144
\.


--
-- Name: achievement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.achievement_id_seq', 1, false);


--
-- Name: publication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publication_id_seq', 4181, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 20, true);


--
-- Name: achievement achievement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievement
    ADD CONSTRAINT achievement_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: publication publication_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- Name: achievement achievement_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievement
    ADD CONSTRAINT achievement_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: publication publication_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

