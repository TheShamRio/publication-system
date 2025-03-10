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
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment (
    id integer NOT NULL,
    content text NOT NULL,
    user_id integer NOT NULL,
    publication_id integer NOT NULL,
    parent_id integer,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- Name: comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comment_id_seq OWNER TO postgres;

--
-- Name: comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_id_seq OWNED BY public.comment.id;


--
-- Name: plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plan (
    id integer NOT NULL,
    year integer NOT NULL,
    "expectedCount" integer NOT NULL,
    "fillType" character varying(10) NOT NULL,
    status character varying(20) NOT NULL,
    user_id integer NOT NULL,
    return_comment text
);


ALTER TABLE public.plan OWNER TO postgres;

--
-- Name: plan_entry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plan_entry (
    id integer NOT NULL,
    plan_id integer NOT NULL,
    title character varying(200),
    type character varying(50),
    publication_id integer,
    status character varying(50) NOT NULL,
    approved boolean,
    "isPostApproval" boolean DEFAULT false NOT NULL
);


ALTER TABLE public.plan_entry OWNER TO postgres;

--
-- Name: plan_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plan_entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plan_entry_id_seq OWNER TO postgres;

--
-- Name: plan_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.plan_entry_id_seq OWNED BY public.plan_entry.id;


--
-- Name: plan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plan_id_seq OWNER TO postgres;

--
-- Name: plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.plan_id_seq OWNED BY public.plan.id;


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
    published_at timestamp without time zone,
    returned_for_revision boolean
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
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    session_id character varying(255),
    data bytea,
    expiry timestamp without time zone
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sessions_id_seq OWNER TO postgres;

--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash text,
    role character varying(20) NOT NULL,
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
-- Name: comment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment ALTER COLUMN id SET DEFAULT nextval('public.comment_id_seq'::regclass);


--
-- Name: plan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan ALTER COLUMN id SET DEFAULT nextval('public.plan_id_seq'::regclass);


--
-- Name: plan_entry id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_entry ALTER COLUMN id SET DEFAULT nextval('public.plan_entry_id_seq'::regclass);


--
-- Name: publication id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication ALTER COLUMN id SET DEFAULT nextval('public.publication_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


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
5cb8466e3b2b
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment (id, content, user_id, publication_id, parent_id, created_at) FROM stdin;
1	df	16	4182	\N	2025-02-27 02:28:07.229592
2	sad	16	4182	\N	2025-02-27 02:28:21.873071
3	asdasd	16	4182	1	2025-02-27 02:28:26.356391
4	dsfsdfsdf	5	4182	3	2025-02-27 02:28:50.416843
5	dsfsdfsdfsdf	5	4182	4	2025-02-27 02:29:06.337958
6	dfgdfg	11	4183	\N	2025-03-02 16:41:29.215977
7	dfgdfg	11	4075	\N	2025-03-02 19:21:25.343008
8	sdfsdfsdf	11	4075	7	2025-03-02 19:21:33.451007
9	sdfsdfsdf	11	4075	\N	2025-03-02 19:21:36.287494
10	sdfsdfsdfsdf	11	4075	8	2025-03-02 19:21:40.853461
11	sdfsdfsdf	11	4075	7	2025-03-02 19:21:48.479896
12	dsfsdf	11	4075	\N	2025-03-02 19:21:53.48643
13	1	11	4075	\N	2025-03-02 19:21:54.950788
14	2	11	4075	13	2025-03-02 19:21:59.810011
15	вфывфыв	11	4076	\N	2025-03-02 19:30:26.331431
16	ыва	11	4171	\N	2025-03-02 19:32:14.493865
17	fdgdfgdfg	11	4074	\N	2025-03-02 20:31:18.296618
18	dsfsdfsdf	16	4074	\N	2025-03-02 22:03:30.147303
19	fdgdfgdfg	16	4074	18	2025-03-02 22:07:49.891331
20	псмчпвапвап	28	4185	\N	2025-03-03 00:40:39.798916
21	sdxfsdf	28	4066	\N	2025-03-03 01:28:46.413325
22	dsfsdf	16	4072	\N	2025-03-03 17:57:19.169115
23	sfsdf	16	4072	\N	2025-03-03 17:57:21.615161
24	sdfsdf	16	4072	\N	2025-03-03 17:57:23.496414
25	sdfsdfsdf	16	4072	\N	2025-03-03 17:57:25.144345
26	dsfsdf	16	4072	\N	2025-03-03 17:57:27.19945
27	орлрол	28	4072	\N	2025-03-03 21:03:34.849129
28	sdfsdfsdf	28	7755	\N	2025-03-04 01:34:57.042987
29	dfgdfg	28	4070	\N	2025-03-06 15:37:07.579617
30	dsfsdfsdf	28	4064	\N	2025-03-06 18:08:19.198988
31	dsfsdfsdf	28	7749	\N	2025-03-06 19:08:27.216505
32	sdfsdfsdfsdf	28	7752	\N	2025-03-06 19:27:43.173297
33	dfgdfgdfg	28	7756	\N	2025-03-06 19:29:09.39968
34	ghfhfgh	28	7756	\N	2025-03-07 10:11:18.936099
35	sadasdasdasd	28	7762	\N	2025-03-09 20:52:55.518103
36	dsfsdf	28	7766	\N	2025-03-10 00:36:51.690823
37	gfgffgh	28	7754	\N	2025-03-10 11:10:05.50695
\.


--
-- Data for Name: plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plan (id, year, "expectedCount", "fillType", status, user_id, return_comment) FROM stdin;
71	2026	4	manual	approved	42	\N
52	2028	6	manual	draft	16	\N
72	2026	3	manual	approved	42	1111111
56	2026	1	manual	draft	16	\N
73	2029	3	manual	approved	42	111111
54	2029	5	manual	returned	16	\N
55	2029	2	manual	approved	16	\N
51	2026	4	manual	approved	16	\N
46	2029	5	manual	approved	40	\N
44	2026	5	manual	approved	40	\N
53	2026	3	manual	approved	16	\N
43	2026	1	manual	approved	16	\N
57	2026	1	manual	approved	40	\N
75	2030	2	manual	approved	42	ываыва
58	2026	8	manual	approved	40	\N
59	2023	2	manual	approved	40	\N
76	2031	2	manual	approved	42	У вас не хватает одной работы
77	2033	2	manual	returned	16	мваапр
36	2026	4	manual	approved	16	\N
60	2026	4	manual	approved	40	\N
61	2026	13	manual	approved	40	\N
39	2026	1	manual	approved	16	\N
40	2026	1	manual	approved	16	\N
38	2026	2	manual	approved	16	\N
67	2030	3	manual	approved	40	\N
69	2026	1	manual	approved	40	\N
41	2022	3	manual	approved	16	\N
65	2026	3	manual	approved	40	\N
66	2026	1	manual	approved	40	\N
\.


--
-- Data for Name: plan_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plan_entry (id, plan_id, title, type, publication_id, status, approved, "isPostApproval") FROM stdin;
847	67	a	article	\N	planned	\N	f
848	67	a	article	7765	completed	\N	f
198	51	ку	article	\N	planned	\N	f
199	51	ууууууууууууу	article	\N	planned	\N	f
200	51	куу	article	\N	planned	\N	f
201	51	уууууууууууууууууу	article	\N	planned	\N	f
204	36	dfg	article	\N	planned	\N	f
205	36	dfg	article	\N	planned	\N	f
206	36	dfgdfg	article	\N	planned	\N	f
208	36	dfg	article	\N	planned	\N	f
209	36	dfg	article	\N	planned	\N	f
210	36	dfgdfg	article	\N	planned	\N	f
211	36	dfg	article	\N	planned	\N	f
212	36	dfg	article	\N	planned	\N	f
213	36	dfg	article	\N	planned	\N	f
141	36	dfgdfg	article	\N	planned	\N	f
142	36	dfg	article	\N	planned	\N	f
143	36	dfg	article	\N	planned	\N	f
144	36	dfg	article	\N	planned	\N	f
214	36		article	\N	planned	\N	f
215	36		article	\N	planned	\N	f
216	36	dfgdfg	article	\N	planned	\N	f
217	36	dfg	article	\N	planned	\N	f
218	36	dfg	article	\N	planned	\N	f
219	36	dfg	article	\N	planned	\N	f
220	36	dfgdfg	article	\N	planned	\N	f
221	36	dfg	article	\N	planned	\N	f
222	36	dfg	article	\N	planned	\N	f
223	36	dfg	article	\N	planned	\N	f
224	36	dfgdfg	article	\N	planned	\N	f
225	36	dfg	article	\N	planned	\N	f
226	36	dfg	article	\N	planned	\N	f
227	36	dfg	article	\N	planned	\N	f
228	36	dfgdfg	article	\N	planned	\N	f
229	36	dfg	article	\N	planned	\N	f
165	41	sadasdasdasd	article	\N	planned	\N	f
166	41	sdfsdfsdf	article	\N	planned	\N	f
167	41	sdfsdf	article	\N	planned	\N	f
230	36	dfg	article	\N	planned	\N	f
231	36	dfg	article	\N	planned	\N	f
232	36		article	\N	planned	\N	f
233	36		article	\N	planned	\N	f
234	36	dfgdfg	article	\N	planned	\N	f
235	36	dfg	article	\N	planned	\N	f
236	36	dfg	article	\N	planned	\N	f
175	43	фывфывфыв	article	\N	planned	\N	f
237	36	dfg	article	\N	planned	\N	f
238	36	dfgdfg	article	\N	planned	\N	f
239	36	dfg	article	\N	planned	\N	f
240	36	dfg	article	\N	planned	\N	f
241	36	dfg	article	\N	planned	\N	f
878	71	55555	article	\N	planned	\N	f
876	71	33333	article	7766	completed	\N	f
875	71	22222	article	7767	completed	\N	f
877	71	44444	article	7769	completed	\N	f
242	36	dfgdfg	article	\N	planned	\N	f
243	36	dfg	article	\N	planned	\N	f
244	36	dfg	article	\N	planned	\N	f
245	36	dfg	article	\N	planned	\N	f
246	36	dfgdfg	article	\N	planned	\N	f
247	36	dfg	article	\N	planned	\N	f
248	36	dfg	article	\N	planned	\N	f
249	36	dfg	article	\N	planned	\N	f
250	36		article	\N	planned	\N	f
251	36		article	\N	planned	\N	f
252	36	dfgdfg	article	\N	planned	\N	f
253	36	dfg	article	\N	planned	\N	f
254	36	dfg	article	\N	planned	\N	f
255	36	dfg	article	\N	planned	\N	f
256	36	dfgdfg	article	\N	planned	\N	f
257	36	dfg	article	\N	planned	\N	f
258	36	dfg	article	\N	planned	\N	f
259	36	dfg	article	\N	planned	\N	f
260	36	dfgdfg	article	\N	planned	\N	f
261	36	dfg	article	\N	planned	\N	f
262	36	dfg	article	\N	planned	\N	f
263	36	dfg	article	\N	planned	\N	f
264	36	dfgdfg	article	\N	planned	\N	f
265	36	dfg	article	\N	planned	\N	f
266	36	dfg	article	\N	planned	\N	f
267	36	dfg	article	\N	planned	\N	f
268	36		article	\N	planned	\N	f
269	36		article	\N	planned	\N	f
270	39	ываываыва	article	\N	planned	\N	f
271	39		article	\N	planned	\N	f
272	39	ываываыва	article	\N	planned	\N	f
273	39	ываываыва	article	\N	planned	\N	f
274	39		article	\N	planned	\N	f
275	39	ываываыва	article	\N	planned	\N	f
276	39	ываываыва	article	\N	planned	\N	f
277	39		article	\N	planned	\N	f
278	39	ываываыва	article	\N	planned	\N	f
279	39	ываываыва	article	\N	planned	\N	f
280	39		article	\N	planned	\N	f
281	52		article	\N	planned	\N	f
282	52		article	\N	planned	\N	f
283	52		article	\N	planned	\N	f
284	52		article	\N	planned	\N	f
285	52		article	\N	planned	\N	f
286	52		article	\N	planned	\N	f
207	36	dfg	article	238	completed	\N	f
202	36	dfgdfg	article	4066	completed	\N	f
203	36	dfg	article	7755	completed	\N	f
287	36	dfg	article	\N	planned	\N	f
288	36	dfg	article	\N	planned	\N	f
289	36	dfgdfg	article	\N	planned	\N	f
290	36	dfg	article	\N	planned	\N	f
291	36	dfg	article	\N	planned	\N	f
292	36	dfgdfg	article	\N	planned	\N	f
153	38	sadasdasd	article	7755	completed	\N	f
155	40	ываываыва	article	7755	completed	\N	f
874	71	11111	article	\N	planned	\N	f
879	71	66666	article	\N	planned	\N	f
293	36	dfg	article	\N	planned	\N	f
294	36	dfg	article	\N	planned	\N	f
295	36	dfg	article	\N	planned	\N	f
296	36	dfgdfg	article	\N	planned	\N	f
297	36	dfg	article	\N	planned	\N	f
298	36	dfg	article	\N	planned	\N	f
299	36	dfg	article	\N	planned	\N	f
300	36		article	\N	planned	\N	f
301	36		article	\N	planned	\N	f
302	36	dfgdfg	article	\N	planned	\N	f
303	36	dfg	article	\N	planned	\N	f
304	36	dfg	article	\N	planned	\N	f
305	36	dfg	article	\N	planned	\N	f
306	36	dfgdfg	article	\N	planned	\N	f
307	36	dfg	article	\N	planned	\N	f
308	36	dfg	article	\N	planned	\N	f
309	36	dfg	article	\N	planned	\N	f
310	36	dfgdfg	article	\N	planned	\N	f
311	36	dfg	article	\N	planned	\N	f
312	36	dfg	article	\N	planned	\N	f
313	36	dfg	article	\N	planned	\N	f
314	36	dfgdfg	article	\N	planned	\N	f
315	36	dfg	article	\N	planned	\N	f
316	36	dfg	article	\N	planned	\N	f
317	36	dfg	article	\N	planned	\N	f
318	36		article	\N	planned	\N	f
319	36		article	\N	planned	\N	f
320	36	dfgdfg	article	\N	planned	\N	f
321	36	dfg	article	\N	planned	\N	f
322	36	dfg	article	\N	planned	\N	f
323	36	dfg	article	\N	planned	\N	f
324	36	dfgdfg	article	\N	planned	\N	f
325	36	dfg	article	\N	planned	\N	f
326	36	dfg	article	\N	planned	\N	f
327	36	dfg	article	\N	planned	\N	f
328	36	dfgdfg	article	\N	planned	\N	f
329	36	dfg	article	\N	planned	\N	f
330	36	dfg	article	\N	planned	\N	f
331	36	dfg	article	\N	planned	\N	f
332	36	dfgdfg	article	\N	planned	\N	f
333	36	dfg	article	\N	planned	\N	f
334	36	dfg	article	\N	planned	\N	f
335	36	dfg	article	\N	planned	\N	f
336	36		article	\N	planned	\N	f
337	36		article	\N	planned	\N	f
338	36	dfgdfg	article	\N	planned	\N	f
339	36	dfg	article	\N	planned	\N	f
340	36	dfg	article	\N	planned	\N	f
341	36	dfg	article	\N	planned	\N	f
342	36	dfgdfg	article	\N	planned	\N	f
343	36	dfg	article	\N	planned	\N	f
344	36	dfg	article	\N	planned	\N	f
345	36	dfg	article	\N	planned	\N	f
346	36	dfgdfg	article	\N	planned	\N	f
347	36	dfg	article	\N	planned	\N	f
348	36	dfg	article	\N	planned	\N	f
349	36	dfg	article	\N	planned	\N	f
350	36	dfgdfg	article	\N	planned	\N	f
351	36	dfg	article	\N	planned	\N	f
352	36	dfg	article	\N	planned	\N	f
353	36	dfg	article	\N	planned	\N	f
354	36		article	\N	planned	\N	f
355	36		article	\N	planned	\N	f
356	36	dfg	article	\N	planned	\N	f
357	36	dfgdfg	article	\N	planned	\N	f
358	36	dfg	article	\N	planned	\N	f
850	69	dfdsfsdf	article	\N	planned	\N	f
880	71	77777	article	\N	planned	\N	t
894	73	1111	article	\N	planned	\N	f
895	73	111	article	\N	planned	\N	f
896	73	111	article	\N	planned	\N	f
901	75	asdas	article	\N	planned	\N	f
902	75	dasdasd	article	\N	planned	\N	f
359	36	dfg	article	\N	planned	\N	f
360	36	dfg	article	\N	planned	\N	f
361	36	dfgdfg	article	\N	planned	\N	f
362	36	dfg	article	\N	planned	\N	f
363	36	dfg	article	\N	planned	\N	f
364	36	dfgdfg	article	\N	planned	\N	f
365	36	dfg	article	\N	planned	\N	f
366	36	dfg	article	\N	planned	\N	f
367	36	dfg	article	\N	planned	\N	f
368	36	dfgdfg	article	\N	planned	\N	f
369	36	dfg	article	\N	planned	\N	f
370	36	dfg	article	\N	planned	\N	f
371	36	dfg	article	\N	planned	\N	f
372	36		article	\N	planned	\N	f
373	36		article	\N	planned	\N	f
374	36	dfgdfg	article	\N	planned	\N	f
375	36	dfg	article	\N	planned	\N	f
376	36	dfg	article	\N	planned	\N	f
377	36	dfg	article	\N	planned	\N	f
378	36	dfgdfg	article	\N	planned	\N	f
379	36	dfg	article	\N	planned	\N	f
380	36	dfg	article	\N	planned	\N	f
381	36	dfg	article	\N	planned	\N	f
382	36	dfgdfg	article	\N	planned	\N	f
383	36	dfg	article	\N	planned	\N	f
384	36	dfg	article	\N	planned	\N	f
385	36	dfg	article	\N	planned	\N	f
386	36	dfgdfg	article	\N	planned	\N	f
387	36	dfg	article	\N	planned	\N	f
388	36	dfg	article	\N	planned	\N	f
389	36	dfg	article	\N	planned	\N	f
390	36		article	\N	planned	\N	f
391	36		article	\N	planned	\N	f
392	36	dfgdfg	article	\N	planned	\N	f
393	36	dfg	article	\N	planned	\N	f
394	36	dfg	article	\N	planned	\N	f
395	36	dfg	article	\N	planned	\N	f
396	36	dfgdfg	article	\N	planned	\N	f
397	36	dfg	article	\N	planned	\N	f
398	36	dfg	article	\N	planned	\N	f
399	36	dfg	article	\N	planned	\N	f
400	36	dfgdfg	article	\N	planned	\N	f
401	36	dfg	article	\N	planned	\N	f
402	36	dfg	article	\N	planned	\N	f
403	36	dfg	article	\N	planned	\N	f
404	36	dfgdfg	article	\N	planned	\N	f
405	36	dfg	article	\N	planned	\N	f
406	36	dfg	article	\N	planned	\N	f
407	36	dfg	article	\N	planned	\N	f
408	36		article	\N	planned	\N	f
409	36		article	\N	planned	\N	f
410	36	dfgdfg	article	\N	planned	\N	f
411	36	dfg	article	\N	planned	\N	f
412	36	dfg	article	\N	planned	\N	f
413	36	dfg	article	\N	planned	\N	f
414	36	dfgdfg	article	\N	planned	\N	f
415	36	dfg	article	\N	planned	\N	f
416	36	dfg	article	\N	planned	\N	f
417	36	dfg	article	\N	planned	\N	f
418	36	dfgdfg	article	\N	planned	\N	f
419	36	dfg	article	\N	planned	\N	f
420	36	dfg	article	\N	planned	\N	f
421	36	dfg	article	\N	planned	\N	f
422	36	dfgdfg	article	\N	planned	\N	f
423	36	dfg	article	\N	planned	\N	f
424	36	dfg	article	\N	planned	\N	f
425	36	dfg	article	\N	planned	\N	f
426	36		article	\N	planned	\N	f
427	36		article	\N	planned	\N	f
428	36	dfg	article	\N	planned	\N	f
429	36	dfgdfg	article	\N	planned	\N	f
430	36	dfg	article	\N	planned	\N	f
431	36	dfg	article	\N	planned	\N	f
432	36	dfg	article	\N	planned	\N	f
433	36	dfgdfg	article	\N	planned	\N	f
434	36	dfg	article	\N	planned	\N	f
435	36	dfg	article	\N	planned	\N	f
436	36	dfgdfg	article	\N	planned	\N	f
437	36	dfg	article	\N	planned	\N	f
438	36	dfg	article	\N	planned	\N	f
439	36	dfg	article	\N	planned	\N	f
440	36	dfgdfg	article	\N	planned	\N	f
441	36	dfg	article	\N	planned	\N	f
442	36	dfg	article	\N	planned	\N	f
443	36	dfg	article	\N	planned	\N	f
444	36		article	\N	planned	\N	f
445	36		article	\N	planned	\N	f
446	36	dfgdfg	article	\N	planned	\N	f
447	36	dfg	article	\N	planned	\N	f
448	36	dfg	article	\N	planned	\N	f
449	36	dfg	article	\N	planned	\N	f
450	36	dfgdfg	article	\N	planned	\N	f
451	36	dfg	article	\N	planned	\N	f
452	36	dfg	article	\N	planned	\N	f
453	36	dfg	article	\N	planned	\N	f
454	36	dfgdfg	article	\N	planned	\N	f
455	36	dfg	article	\N	planned	\N	f
456	36	dfg	article	\N	planned	\N	f
457	36	dfg	article	\N	planned	\N	f
458	36	dfgdfg	article	\N	planned	\N	f
459	36	dfg	article	\N	planned	\N	f
460	36	dfg	article	\N	planned	\N	f
461	36	dfg	article	\N	planned	\N	f
462	36		article	\N	planned	\N	f
463	36		article	\N	planned	\N	f
464	36	dfgdfg	article	\N	planned	\N	f
465	36	dfg	article	\N	planned	\N	f
466	36	dfg	article	\N	planned	\N	f
467	36	dfg	article	\N	planned	\N	f
468	36	dfgdfg	article	\N	planned	\N	f
469	36	dfg	article	\N	planned	\N	f
470	36	dfg	article	\N	planned	\N	f
471	36	dfg	article	\N	planned	\N	f
472	36	dfgdfg	article	\N	planned	\N	f
473	36	dfg	article	\N	planned	\N	f
474	36	dfg	article	\N	planned	\N	f
475	36	dfg	article	\N	planned	\N	f
476	36	dfgdfg	article	\N	planned	\N	f
477	36	dfg	article	\N	planned	\N	f
478	36	dfg	article	\N	planned	\N	f
479	36	dfg	article	\N	planned	\N	f
480	36		article	\N	planned	\N	f
481	36		article	\N	planned	\N	f
482	36	dfgdfg	article	\N	planned	\N	f
483	36	dfg	article	\N	planned	\N	f
484	36	dfg	article	\N	planned	\N	f
485	36	dfg	article	\N	planned	\N	f
486	36	dfgdfg	article	\N	planned	\N	f
487	36	dfg	article	\N	planned	\N	f
488	36	dfg	article	\N	planned	\N	f
489	36	dfg	article	\N	planned	\N	f
490	36	dfgdfg	article	\N	planned	\N	f
491	36	dfg	article	\N	planned	\N	f
492	36	dfg	article	\N	planned	\N	f
493	36	dfg	article	\N	planned	\N	f
494	36	dfgdfg	article	\N	planned	\N	f
495	36	dfg	article	\N	planned	\N	f
496	36	dfg	article	\N	planned	\N	f
497	36	dfg	article	\N	planned	\N	f
498	36		article	\N	planned	\N	f
499	36		article	\N	planned	\N	f
500	36	dfg	article	\N	planned	\N	f
501	36	dfgdfg	article	\N	planned	\N	f
502	36	dfg	article	\N	planned	\N	f
503	36		article	\N	planned	\N	f
152	38	asdasdasd	article	801	completed	\N	f
539	46	asdasdasdasd	article	7762	completed	\N	f
534	46	asdas	article	7764	completed	\N	f
852	67	ыва	article	\N	planned	\N	t
854	67	ываыва	article	\N	planned	\N	t
853	67	ываыва	article	7759	completed	\N	t
513	53	фывфы	article	\N	planned	\N	f
514	53	фывфыв	article	\N	planned	\N	f
515	53	фыв	article	\N	planned	\N	f
516	54	фывфы	article	\N	planned	\N	f
517	54	фывфыв	article	\N	planned	\N	f
518	54	вап	article	\N	planned	\N	f
519	54	вап	article	\N	planned	\N	f
520	54	ап	article	\N	planned	\N	f
521	56		article	\N	planned	\N	f
151	39	ываываыва	article	4072	completed	\N	f
523	55	ываыва	article	\N	planned	\N	f
522	55	выа	article	4066	completed	\N	f
532	44	fsdfsdf	article	\N	planned	\N	f
530	44	sdfsdf	article	\N	planned	\N	f
529	44	sdfsdf	article	\N	planned	\N	f
545	57	ssd	article	\N	planned	\N	f
531	44	sdfsd	article	\N	planned	\N	f
600	44	sssss	article	\N	planned	\N	f
543	57	asdasdasdasd	article	\N	planned	\N	f
547	57	asd	article	\N	planned	\N	f
551	57	asd	article	\N	planned	\N	f
552	57	asdasd	article	\N	planned	\N	f
553	57	sdasd	article	\N	planned	\N	f
554	44	sdfsdfsdf	article	\N	planned	\N	f
555	44	fsdfsdf	article	\N	planned	\N	f
556	44	sdfsdf	article	\N	planned	\N	f
557	44	sdfsd	article	\N	planned	\N	f
558	44	sdfsdf	article	\N	planned	\N	f
559	44	sdsd	article	\N	planned	\N	f
560	44	sssss	article	\N	planned	\N	f
546	57	asdasd	article	\N	planned	\N	f
544	57	asdasdasdasd	article	\N	planned	\N	f
549	57	ssd	article	\N	planned	\N	f
581	58	test10	article	\N	planned	\N	f
582	58	test10	article	\N	planned	\N	f
583	58	test10	article	\N	planned	\N	f
584	58	test10	article	\N	planned	\N	f
585	58	test10	article	\N	planned	\N	f
586	58	выа	article	\N	planned	\N	f
587	58	test10	article	\N	planned	\N	f
588	58	ывасыва	article	\N	planned	\N	f
538	46	dasd	article	\N	planned	\N	f
536	46	asdasd	article	\N	planned	\N	f
537	46	asd	article	\N	planned	\N	f
535	46	asdasd	article	\N	planned	\N	f
525	46	dasd	article	\N	planned	\N	f
526	46	asd	article	\N	planned	\N	f
527	46	asdasd	article	\N	planned	\N	f
528	46	asdasd	article	\N	planned	\N	f
524	46	asdas	article	\N	planned	\N	f
589	44	sdfsdfsdf	article	\N	planned	\N	f
590	44	fsdfsdf	article	\N	planned	\N	f
591	44	sdfsdf	article	\N	planned	\N	f
592	44	sdfsd	article	\N	planned	\N	f
593	44	sdfsdf	article	\N	planned	\N	f
594	44	sdfsdfsdf	article	\N	planned	\N	f
595	44	fsdfsdf	article	\N	planned	\N	f
596	44	sdfsdf	article	\N	planned	\N	f
597	44	sdfsd	article	\N	planned	\N	f
598	44	sdfsdf	article	\N	planned	\N	f
599	44	sdsd	article	\N	planned	\N	f
602	44	sdfsdfsdf	article	\N	planned	\N	f
603	44	fsdfsdf	article	\N	planned	\N	f
604	44	sdfsdf	article	\N	planned	\N	f
605	44	sdfsd	article	\N	planned	\N	f
606	44	sdfsdf	article	\N	planned	\N	f
607	44	sdfsdfsdf	article	\N	planned	\N	f
608	44	fsdfsdf	article	\N	planned	\N	f
609	44	sdfsdf	article	\N	planned	\N	f
610	44	sdfsd	article	\N	planned	\N	f
611	44	sdfsdf	article	\N	planned	\N	f
612	44	sdsd	article	\N	planned	\N	f
613	44	sssss	article	\N	planned	\N	f
614	44	sdfsdfsdf	article	\N	planned	\N	f
615	44	fsdfsdf	article	\N	planned	\N	f
616	44	sdfsdf	article	\N	planned	\N	f
617	44	sdfsd	article	\N	planned	\N	f
618	44	sdfsdf	article	\N	planned	\N	f
619	44	sdfsdfsdf	article	\N	planned	\N	f
548	57	asdasdasdasd	article	\N	planned	\N	f
533	44	sdfsdfsdf	article	\N	planned	\N	f
851	67	ыва	article	7758	completed	\N	t
601	44	ываыв	article	\N	planned	\N	f
881	71	88888	article	\N	planned	\N	t
897	71	9999	article	7768	completed	\N	t
909	77	dfsd	article	\N	planned	\N	f
910	77	fsdf	article	\N	planned	\N	f
620	44	fsdfsdf	article	\N	planned	\N	f
621	44	sdfsdf	article	\N	planned	\N	f
622	44	sdfsd	article	\N	planned	\N	f
623	44	sdfsdf	article	\N	planned	\N	f
624	44	sdsd	article	\N	planned	\N	f
625	44	sssss	article	\N	planned	\N	f
626	44	ываыв	article	\N	planned	\N	f
627	44	ываыва	article	\N	planned	\N	f
632	57	asdasdasdasd	article	\N	planned	\N	f
633	57	asd	article	\N	planned	\N	f
634	57	asdasd	article	\N	planned	\N	f
635	57	ssd	article	\N	planned	\N	f
636	57	asdasdasdasd	article	\N	planned	\N	f
637	57	asd	article	\N	planned	\N	f
638	57	asdasd	article	\N	planned	\N	f
639	57	sdasd	article	\N	planned	\N	f
640	57	asdasdasdasd	article	\N	planned	\N	f
641	57	ssd	article	\N	planned	\N	f
642	57	asdasdasdasd	article	\N	planned	\N	f
643	57	фывфывфыв	article	\N	planned	\N	f
644	57	фывфыв	article	\N	planned	\N	f
645	57	asdasdasdasd	article	\N	planned	\N	f
646	57	asd	article	\N	planned	\N	f
647	57	asdasd	article	\N	planned	\N	f
648	57	ssd	article	\N	planned	\N	f
649	57	asdasdasdasd	article	\N	planned	\N	f
650	57	asd	article	\N	planned	\N	f
651	57	asdasd	article	\N	planned	\N	f
652	57	sdasd	article	\N	planned	\N	f
653	57	asdasdasdasd	article	\N	planned	\N	f
654	57	ssd	article	\N	planned	\N	f
655	57	asdasdasdasd	article	\N	planned	\N	f
656	57	asdasdasdasd	article	\N	planned	\N	f
657	57	asd	article	\N	planned	\N	f
658	57	asdasd	article	\N	planned	\N	f
659	57	ssd	article	\N	planned	\N	f
660	57	asdasdasdasd	article	\N	planned	\N	f
661	57	asd	article	\N	planned	\N	f
662	57	asdasd	article	\N	planned	\N	f
663	57	sdasd	article	\N	planned	\N	f
664	57	asdasdasdasd	article	\N	planned	\N	f
665	57	ssd	article	\N	planned	\N	f
666	57	asdasdasdasd	article	\N	planned	\N	f
667	57	фывфывфыв	article	\N	planned	\N	f
668	57	фывфыв	article	\N	planned	\N	f
669	57	юююююююююююююююю	article	\N	planned	\N	f
670	57	ыыыыыыыыыыыы	article	\N	planned	\N	f
671	57	asdasdasdasd	article	\N	planned	\N	f
672	57	asd	article	\N	planned	\N	f
673	57	asdasd	article	\N	planned	\N	f
674	57	asdasdasdasd	article	\N	planned	\N	f
675	57	asd	article	\N	planned	\N	f
676	57	asdasd	article	\N	planned	\N	f
677	57	sdasd	article	\N	planned	\N	f
678	57	asdasdasdasd	article	\N	planned	\N	f
679	57	ssd	article	\N	planned	\N	f
680	57	asdasdasdasd	article	\N	planned	\N	f
681	57	ssd	article	\N	planned	\N	f
682	57	asdasdasdasd	article	\N	planned	\N	f
683	57	asd	article	\N	planned	\N	f
684	57	asdasd	article	\N	planned	\N	f
685	57	ssd	article	\N	planned	\N	f
686	57	asdasdasdasd	article	\N	planned	\N	f
687	57	asd	article	\N	planned	\N	f
688	57	asdasd	article	\N	planned	\N	f
689	57	sdasd	article	\N	planned	\N	f
690	57	asdasdasdasd	article	\N	planned	\N	f
691	57	ssd	article	\N	planned	\N	f
692	57	asdasdasdasd	article	\N	planned	\N	f
693	57	фывфывфыв	article	\N	planned	\N	f
694	57	фывфыв	article	\N	planned	\N	f
695	57	asdasdasdasd	article	\N	planned	\N	f
696	57	asd	article	\N	planned	\N	f
697	57	asdasd	article	\N	planned	\N	f
698	57	ssd	article	\N	planned	\N	f
699	57	asdasdasdasd	article	\N	planned	\N	f
700	57	asd	article	\N	planned	\N	f
701	57	asdasd	article	\N	planned	\N	f
702	57	sdasd	article	\N	planned	\N	f
703	57	asdasdasdasd	article	\N	planned	\N	f
704	57	ssd	article	\N	planned	\N	f
705	57	asdasdasdasd	article	\N	planned	\N	f
706	57	asdasdasdasd	article	\N	planned	\N	f
707	57	asd	article	\N	planned	\N	f
708	57	asdasd	article	\N	planned	\N	f
709	57	ssd	article	\N	planned	\N	f
710	57	asdasdasdasd	article	\N	planned	\N	f
711	57	asd	article	\N	planned	\N	f
712	57	asdasd	article	\N	planned	\N	f
713	57	sdasd	article	\N	planned	\N	f
714	57	asdasdasdasd	article	\N	planned	\N	f
715	57	ssd	article	\N	planned	\N	f
716	57	asdasdasdasd	article	\N	planned	\N	f
717	57	фывфывфыв	article	\N	planned	\N	f
718	57	фывфыв	article	\N	planned	\N	f
719	57	юююююююююююююююю	article	\N	planned	\N	f
720	57	ыыыыыыыыыыыы	article	\N	planned	\N	f
721	57	ываываыва	article	\N	planned	\N	f
722	57	ываыва	article	\N	planned	\N	f
727	59	фывфывфыв	article	\N	planned	\N	f
731	59	22222	article	\N	planned	\N	f
723	59	фывфыв	article	\N	planned	\N	f
725	59	11111	article	\N	planned	\N	f
630	59	фывфыв	article	\N	planned	\N	f
724	59	фывфывфыв	article	\N	planned	\N	f
726	59	фывфыв	article	\N	planned	\N	f
730	59	11111	article	\N	planned	\N	f
728	59	фывфыв	article	\N	planned	\N	f
729	59	фывфывфыв	article	\N	planned	\N	f
732	59	dfgdfgdfg	article	\N	planned	\N	f
844	67	sdfsdf	article	\N	planned	\N	f
842	67	asdasd	article	\N	planned	\N	f
843	67	asdasdasd	article	\N	planned	\N	f
845	67	sdfsdf	article	\N	planned	\N	f
841	67	asd	article	7760	completed	\N	f
888	72	sdfsd	article	\N	planned	\N	f
889	72	fsdf	article	\N	planned	\N	f
890	72	sdfsdf	article	\N	planned	\N	f
905	76	asda	article	\N	planned	\N	f
906	76	sdasd	article	\N	planned	\N	f
772	61	s	article	\N	planned	\N	f
773	61	s	article	\N	planned	\N	f
774	61	s	article	\N	planned	\N	f
775	61	s	article	\N	planned	\N	f
776	61	aaaaa	article	\N	planned	\N	f
777	61	aaaaaaaaa	article	\N	planned	\N	f
778	61	fsdfsdfsdf	article	\N	planned	\N	f
779	61	dfsd	article	\N	planned	\N	f
780	61	sdfs	article	\N	planned	\N	f
788	59	asdasdas	article	\N	planned	\N	f
789	59	dasd	article	\N	planned	\N	f
790	59	asdasdasd	article	\N	planned	\N	f
809	66	ываыва	article	\N	planned	\N	f
733	59	dfgdfgdfg	article	\N	planned	\N	f
631	59	фывфывфыв	article	\N	planned	\N	f
828	65	папппп	article	\N	planned	\N	f
829	65	авп	article	\N	planned	\N	f
830	65	ываы	article	\N	planned	\N	f
831	65	ываыва	article	\N	planned	\N	f
832	65	111	article	\N	planned	\N	f
833	65	2222	article	\N	planned	\N	f
834	65	3333	article	\N	planned	\N	f
835	60	ddd	article	\N	planned	\N	f
836	44	dfgd	article	\N	planned	\N	f
837	44	dfg	article	\N	planned	\N	f
550	57	asdasdasdasd	article	\N	planned	\N	f
827	60	ффффф	article	\N	planned	\N	f
826	60	фывфыв	article	\N	planned	\N	f
787	59	asdasdasd	article	\N	planned	\N	f
\.


--
-- Data for Name: publication; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publication (id, title, authors, year, type, status, file_url, user_id, updated_at, published_at, returned_for_revision) FROM stdin;
1463	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334987	\N	\N
1464	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334989	\N	\N
238	ddsdf	test1	2014	article	published	/uploads/6_1.pdf	16	2025-03-06 14:31:36.362142	2025-03-06 14:31:36.36141	f
1461	On the Electrodynamics of Moving Bodies	Albert Einsteinaa	1905	article	published	/uploads/-17.pdf	16	2025-02-27 02:24:40.698779	2025-02-27 00:47:35.598112	\N
58	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-24 22:07:45.379718	\N	\N
59	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-24 22:07:59.993264	\N	\N
1300	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 01:50:19.371144	\N	\N
1301	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 01:50:19.371146	\N	\N
1302	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 01:50:19.371147	\N	\N
1303	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 01:50:19.371148	\N	\N
1304	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 01:50:19.37115	\N	\N
239	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840331	\N	\N
240	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840334	\N	\N
241	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840335	\N	\N
242	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840337	\N	\N
243	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840338	\N	\N
244	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.84034	\N	\N
245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:23.840341	\N	\N
246	Sham	test2	2010	article	draft	\N	16	2025-02-23 14:22:23.840343	\N	\N
247	длолд	ирмтми	2015	article	draft	\N	16	2025-02-23 14:22:23.840344	\N	\N
280	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.196161	\N	\N
281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.196163	\N	\N
282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.196164	\N	\N
283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.196165	\N	\N
284	Sham	test2	2010	article	draft	\N	16	2025-02-24 00:59:03.196167	\N	\N
285	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 00:59:03.196168	\N	\N
292	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642273	\N	\N
293	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642275	\N	\N
294	Sham	test2	2010	article	draft	\N	16	2025-02-24 01:00:46.642276	\N	\N
295	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 01:00:46.642278	\N	\N
278	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	monograph	draft	\N	16	2025-02-24 09:55:47.847765	\N	\N
208	Robotics and Automation	Evans, Linda	2021	conference	draft	\N	16	2025-02-24 09:55:56.247374	\N	\N
302	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376241	\N	\N
303	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376243	\N	\N
304	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376244	\N	\N
305	Sham	test2	2010	article	draft	\N	16	2025-02-24 09:56:22.376246	\N	\N
306	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 09:56:22.376247	\N	\N
308	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-24 10:07:13.615422	\N	\N
61	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
309	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-24 10:07:13.615425	\N	\N
310	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-24 10:07:13.615427	\N	\N
311	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-24 10:07:13.61543	\N	\N
312	dfd	sdfs	2022	article	draft	\N	16	2025-02-24 10:07:13.615431	\N	\N
313	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615433	\N	\N
314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615434	\N	\N
1305	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371151	\N	\N
1306	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371153	\N	\N
1307	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371154	\N	\N
1308	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371155	\N	\N
1309	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371157	\N	\N
1310	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371158	\N	\N
1400	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.334891	\N	\N
211	ddsdf	test1	2015	article	draft	\N	16	2025-02-22 20:42:02.54765	\N	\N
212	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547654	\N	\N
213	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547656	\N	\N
214	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547658	\N	\N
1401	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.334895	\N	\N
215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547659	\N	\N
1402	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.334896	\N	\N
216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547661	\N	\N
217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547662	\N	\N
218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 20:42:02.547664	\N	\N
297	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 09:56:22.37623	\N	\N
298	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376234	\N	\N
299	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376236	\N	\N
248	ddsdf	test1	2015	article	draft	\N	16	2025-02-23 14:22:31.780013	\N	\N
249	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780017	\N	\N
250	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780019	\N	\N
251	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.78002	\N	\N
252	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780022	\N	\N
253	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780024	\N	\N
254	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780025	\N	\N
255	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:31.780027	\N	\N
256	Sham	test2	2010	article	draft	\N	16	2025-02-23 14:22:31.780028	\N	\N
267	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 00:58:54.707625	\N	\N
268	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707629	\N	\N
269	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707632	\N	\N
270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707633	\N	\N
271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707635	\N	\N
272	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707637	\N	\N
273	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.707638	\N	\N
274	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:58:54.70764	\N	\N
275	Sham	test2	2010	article	draft	\N	16	2025-02-24 00:58:54.707641	\N	\N
286	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 01:00:46.642261	\N	\N
287	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642264	\N	\N
288	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642267	\N	\N
289	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642269	\N	\N
290	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.64227	\N	\N
291	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 01:00:46.642272	\N	\N
1403	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.334898	\N	\N
1404	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.3349	\N	\N
1405	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334901	\N	\N
300	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.376238	\N	\N
171	ddsdf	test1	2015	article	draft	\N	5	2025-02-22 19:20:19.605391	\N	\N
160	Разработка автоматизированнной системы	Шамиль и Виталик	2025	article	draft	\N	13	2025-02-22 12:23:17.724248	\N	\N
161	ddsdf	test1	2015	article	draft	\N	13	2025-02-22 12:23:32.177094	\N	\N
301	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 09:56:22.37624	\N	\N
1406	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334903	\N	\N
162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177098	\N	\N
125	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	review	\N	7	2025-02-22 11:53:22.366745	\N	\N
163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.1771	\N	\N
164	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177102	\N	\N
165	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177103	\N	\N
166	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177105	\N	\N
167	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177106	\N	\N
168	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	13	2025-02-22 12:23:32.177108	\N	\N
106	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605395	\N	\N
173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605397	\N	\N
174	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605399	\N	\N
175	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605401	\N	\N
176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605403	\N	\N
108	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
177	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605404	\N	\N
178	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	5	2025-02-22 19:20:19.605406	\N	\N
220	ddsdf	test1	2015	article	draft	\N	16	2025-02-22 22:32:27.172143	\N	\N
221	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172148	\N	\N
222	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.17215	\N	\N
223	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172152	\N	\N
224	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172153	\N	\N
225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172155	\N	\N
226	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172156	\N	\N
227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-22 22:32:27.172158	\N	\N
228	Sham	test2	2010	article	draft	\N	16	2025-02-22 22:32:27.172159	\N	\N
257	ddsdf	test1	2015	article	draft	\N	16	2025-02-23 14:26:08.310116	\N	\N
258	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310119	\N	\N
259	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310121	\N	\N
64	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
66	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
67	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
68	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
69	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
70	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
71	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
72	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
73	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
74	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
75	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
76	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
77	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
1407	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334905	\N	\N
1408	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334906	\N	\N
1409	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334908	\N	\N
1410	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33491	\N	\N
50	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
1411	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334911	\N	\N
1412	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334912	\N	\N
1413	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334914	\N	\N
78	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
79	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
80	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
81	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
82	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
83	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
84	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
85	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
86	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
87	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
88	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
89	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
91	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
92	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
93	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
94	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
95	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
96	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
97	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
114	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
115	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
117	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
260	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310123	\N	\N
65	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-24 22:08:07.160091	\N	\N
181	testik	testik	1999	conference	draft	/uploads/4411__3_1.docx	\N	2025-02-22 19:46:07.862543	\N	\N
804	выаыва	ываыва	2011	article	published	/uploads/Spasi_i_Sokhrani.docx	16	2025-02-24 16:24:41.136262	\N	\N
803	555	555ы	1999	article	published	/uploads/Spasi_i_Sokhrani.docx	16	2025-02-24 16:24:56.61221	\N	\N
1414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334915	\N	\N
98	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
99	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
100	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
102	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
104	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
105	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
107	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
118	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
119	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
120	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
124	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
127	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
128	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
129	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
130	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
132	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
1415	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334917	\N	\N
1416	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334918	\N	\N
1417	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33492	\N	\N
1418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334922	\N	\N
137	ddsdf	test1	2015	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
138	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
139	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
141	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
142	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
143	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
7755	ываыва	ываыва	2011	article	published	/uploads/848844016.pdf	16	2025-03-06 11:58:41.108997	2025-03-06 11:58:41.108234	f
4072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	monograph	published	/uploads/848844016.pdf	16	2025-03-06 15:35:40.196294	2025-03-06 15:35:40.19577	f
1419	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334923	\N	\N
1420	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334924	\N	\N
1421	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.334926	\N	\N
145	Sham	test2	2010	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
158	Разработка автоматизированнной системы	Шамиль и Виталик	2025	article	draft	\N	7	2025-02-22 22:41:06.997614	\N	\N
736	ddsdf	test1ы	2015	article	published	\N	16	2025-02-24 20:07:51.05722	\N	\N
229	ddsdf	test1	2015	article	draft	\N	16	2025-02-23 14:22:15.756568	\N	\N
230	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756571	\N	\N
231	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756574	\N	\N
232	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756576	\N	\N
233	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756577	\N	\N
234	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756579	\N	\N
235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.75658	\N	\N
236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:22:15.756582	\N	\N
237	Sham	test2	2010	article	draft	\N	16	2025-02-23 14:22:15.756583	\N	\N
261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310125	\N	\N
262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310126	\N	\N
263	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310128	\N	\N
264	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-23 14:26:08.310129	\N	\N
265	Sham	test2	2010	article	draft	\N	16	2025-02-23 14:26:08.310131	\N	\N
1422	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334928	\N	\N
277	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 00:59:03.196156	\N	\N
1423	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334929	\N	\N
315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615436	\N	\N
316	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615437	\N	\N
317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615438	\N	\N
318	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61544	\N	\N
319	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615442	\N	\N
320	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615443	\N	\N
322	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615446	\N	\N
323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615447	\N	\N
324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615449	\N	\N
325	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61545	\N	\N
326	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615451	\N	\N
327	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615453	\N	\N
328	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615454	\N	\N
329	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615456	\N	\N
330	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615457	\N	\N
331	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615459	\N	\N
332	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61546	\N	\N
333	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615462	\N	\N
334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615463	\N	\N
335	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615465	\N	\N
336	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615466	\N	\N
337	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615467	\N	\N
338	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615469	\N	\N
339	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.61547	\N	\N
340	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615472	\N	\N
341	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615473	\N	\N
342	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615474	\N	\N
343	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615476	\N	\N
344	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615477	\N	\N
345	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615479	\N	\N
346	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61548	\N	\N
347	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615481	\N	\N
348	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 10:07:13.615483	\N	\N
349	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615484	\N	\N
350	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615486	\N	\N
351	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615487	\N	\N
352	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615489	\N	\N
353	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61549	\N	\N
354	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615491	\N	\N
355	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615493	\N	\N
356	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615494	\N	\N
357	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615496	\N	\N
358	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615497	\N	\N
359	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615498	\N	\N
360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.6155	\N	\N
361	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615501	\N	\N
362	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615503	\N	\N
363	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615504	\N	\N
364	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615506	\N	\N
365	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615507	\N	\N
366	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615508	\N	\N
367	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.61551	\N	\N
368	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615511	\N	\N
369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615513	\N	\N
370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615514	\N	\N
371	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615516	\N	\N
372	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615517	\N	\N
373	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615518	\N	\N
374	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61552	\N	\N
375	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615521	\N	\N
376	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615523	\N	\N
377	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615524	\N	\N
378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615525	\N	\N
379	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615527	\N	\N
380	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615528	\N	\N
321	ddsdf	test1	2012	article	draft	\N	16	2025-02-24 15:51:02.731529	\N	\N
1024	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.97135	\N	\N
381	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61553	\N	\N
382	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615531	\N	\N
383	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615532	\N	\N
384	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 10:07:13.615534	\N	\N
385	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615535	\N	\N
386	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615537	\N	\N
387	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615538	\N	\N
388	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615539	\N	\N
389	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615543	\N	\N
390	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615544	\N	\N
391	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615546	\N	\N
392	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615547	\N	\N
393	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615549	\N	\N
394	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 10:07:13.61555	\N	\N
395	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-24 10:07:13.615551	\N	\N
396	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 10:07:13.615553	\N	\N
397	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615554	\N	\N
398	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615556	\N	\N
399	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615557	\N	\N
400	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615558	\N	\N
401	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.61556	\N	\N
402	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615561	\N	\N
403	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 10:07:13.615563	\N	\N
404	Sham	test2	2010	article	draft	\N	16	2025-02-24 10:07:13.615564	\N	\N
405	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 10:07:13.615565	\N	\N
408	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-24 11:02:10.265079	\N	\N
409	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-24 11:02:10.265084	\N	\N
410	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-24 11:02:10.265087	\N	\N
411	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-24 11:02:10.265089	\N	\N
412	dfd	sdfs	2022	article	draft	\N	16	2025-02-24 11:02:10.26509	\N	\N
413	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265092	\N	\N
414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265094	\N	\N
415	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265095	\N	\N
416	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265097	\N	\N
417	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265098	\N	\N
418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.2651	\N	\N
419	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265102	\N	\N
420	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265103	\N	\N
421	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265105	\N	\N
422	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265106	\N	\N
423	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265107	\N	\N
424	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265109	\N	\N
425	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26511	\N	\N
426	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265112	\N	\N
427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265114	\N	\N
428	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265115	\N	\N
429	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265116	\N	\N
430	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265118	\N	\N
431	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265119	\N	\N
432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265121	\N	\N
433	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265123	\N	\N
434	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265124	\N	\N
435	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265126	\N	\N
436	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265127	\N	\N
437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265129	\N	\N
438	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.26513	\N	\N
439	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265131	\N	\N
440	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265133	\N	\N
441	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265134	\N	\N
442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265136	\N	\N
443	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265137	\N	\N
444	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265139	\N	\N
445	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26514	\N	\N
1025	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971352	\N	\N
1026	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971353	\N	\N
446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265142	\N	\N
447	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265143	\N	\N
448	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 11:02:10.265145	\N	\N
449	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265146	\N	\N
450	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265147	\N	\N
451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265149	\N	\N
452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26515	\N	\N
453	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265152	\N	\N
454	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265153	\N	\N
455	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265155	\N	\N
456	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265156	\N	\N
457	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265157	\N	\N
458	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265159	\N	\N
459	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26516	\N	\N
460	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265162	\N	\N
461	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265163	\N	\N
462	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265164	\N	\N
463	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265166	\N	\N
464	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265167	\N	\N
465	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265169	\N	\N
466	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.26517	\N	\N
467	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265171	\N	\N
468	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265173	\N	\N
469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265174	\N	\N
470	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265175	\N	\N
471	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265177	\N	\N
472	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265178	\N	\N
473	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26518	\N	\N
474	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265181	\N	\N
475	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265182	\N	\N
476	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265184	\N	\N
477	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265185	\N	\N
478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265187	\N	\N
479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265188	\N	\N
480	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.26519	\N	\N
481	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265191	\N	\N
482	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265192	\N	\N
483	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265194	\N	\N
484	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 11:02:10.265195	\N	\N
485	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265197	\N	\N
486	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265198	\N	\N
487	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.2652	\N	\N
488	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265201	\N	\N
489	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265202	\N	\N
490	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265204	\N	\N
491	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265205	\N	\N
492	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265207	\N	\N
493	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265208	\N	\N
494	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 11:02:10.265209	\N	\N
495	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-24 11:02:10.265211	\N	\N
496	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 11:02:10.265212	\N	\N
497	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265214	\N	\N
498	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265215	\N	\N
499	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265217	\N	\N
500	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265218	\N	\N
501	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265219	\N	\N
502	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265221	\N	\N
503	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 11:02:10.265222	\N	\N
504	Sham	test2	2010	article	draft	\N	16	2025-02-24 11:02:10.265223	\N	\N
505	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 11:02:10.265225	\N	\N
507	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-24 15:54:07.060604	\N	\N
508	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-24 15:54:07.060609	\N	\N
509	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-24 15:54:07.060611	\N	\N
510	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-24 15:54:07.060613	\N	\N
511	dfd	sdfs	2022	article	draft	\N	16	2025-02-24 15:54:07.060615	\N	\N
512	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060616	\N	\N
513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060618	\N	\N
514	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060619	\N	\N
515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06062	\N	\N
516	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060622	\N	\N
517	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060623	\N	\N
518	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060625	\N	\N
519	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060626	\N	\N
520	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060628	\N	\N
521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060629	\N	\N
522	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06063	\N	\N
523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060632	\N	\N
524	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060633	\N	\N
525	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060634	\N	\N
526	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060636	\N	\N
527	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060637	\N	\N
528	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060638	\N	\N
529	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.06064	\N	\N
530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060641	\N	\N
531	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060643	\N	\N
532	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060644	\N	\N
533	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060645	\N	\N
534	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060647	\N	\N
535	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060648	\N	\N
536	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06065	\N	\N
537	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060651	\N	\N
538	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060652	\N	\N
539	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060654	\N	\N
540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060655	\N	\N
541	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060656	\N	\N
542	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060658	\N	\N
543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060659	\N	\N
544	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06066	\N	\N
545	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060662	\N	\N
546	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060663	\N	\N
547	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060665	\N	\N
548	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060666	\N	\N
549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060667	\N	\N
550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060669	\N	\N
551	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06067	\N	\N
552	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060671	\N	\N
553	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060673	\N	\N
554	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060674	\N	\N
555	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060675	\N	\N
556	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060677	\N	\N
557	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060678	\N	\N
558	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06068	\N	\N
559	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060681	\N	\N
560	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060682	\N	\N
561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060684	\N	\N
562	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060685	\N	\N
563	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060686	\N	\N
564	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060688	\N	\N
565	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060689	\N	\N
566	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060691	\N	\N
567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060692	\N	\N
568	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060693	\N	\N
569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060695	\N	\N
570	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060696	\N	\N
571	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060697	\N	\N
572	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060699	\N	\N
573	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.0607	\N	\N
574	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060702	\N	\N
575	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060703	\N	\N
576	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060704	\N	\N
577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060706	\N	\N
578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060707	\N	\N
579	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060708	\N	\N
1160	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370948	\N	\N
580	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06071	\N	\N
581	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060711	\N	\N
582	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060713	\N	\N
583	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060714	\N	\N
584	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060715	\N	\N
585	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060717	\N	\N
586	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060718	\N	\N
587	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06072	\N	\N
588	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060721	\N	\N
589	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060722	\N	\N
590	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060724	\N	\N
591	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060725	\N	\N
592	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060727	\N	\N
593	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060728	\N	\N
594	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-24 15:54:07.06073	\N	\N
595	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060731	\N	\N
596	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060732	\N	\N
597	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060734	\N	\N
598	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060735	\N	\N
599	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060737	\N	\N
600	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060738	\N	\N
601	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060739	\N	\N
602	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060741	\N	\N
603	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060742	\N	\N
604	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060743	\N	\N
605	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-24 15:54:07.060745	\N	\N
606	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-24 15:54:07.060746	\N	\N
607	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-24 15:54:07.060748	\N	\N
608	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-24 15:54:07.060749	\N	\N
609	dfd	sdfs	2022	article	draft	\N	16	2025-02-24 15:54:07.06075	\N	\N
610	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060752	\N	\N
611	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060753	\N	\N
612	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060754	\N	\N
613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060756	\N	\N
614	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060757	\N	\N
615	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060759	\N	\N
616	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06076	\N	\N
617	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060761	\N	\N
618	ddsdf	test1	2012	article	draft	\N	16	2025-02-24 15:54:07.060763	\N	\N
619	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060764	\N	\N
620	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060765	\N	\N
621	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060767	\N	\N
622	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060768	\N	\N
623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060769	\N	\N
624	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060771	\N	\N
625	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060772	\N	\N
626	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060774	\N	\N
627	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060775	\N	\N
628	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060776	\N	\N
629	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060778	\N	\N
630	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060779	\N	\N
631	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060781	\N	\N
632	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060782	\N	\N
633	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060783	\N	\N
634	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060785	\N	\N
635	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060786	\N	\N
636	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060787	\N	\N
637	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060789	\N	\N
638	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06079	\N	\N
639	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060791	\N	\N
640	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060793	\N	\N
641	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060794	\N	\N
642	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060795	\N	\N
643	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060797	\N	\N
644	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060798	\N	\N
645	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.0608	\N	\N
646	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060801	\N	\N
647	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060802	\N	\N
648	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060804	\N	\N
649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060805	\N	\N
650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060806	\N	\N
651	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060808	\N	\N
652	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060809	\N	\N
653	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06081	\N	\N
654	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060812	\N	\N
655	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060813	\N	\N
656	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060815	\N	\N
657	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060816	\N	\N
658	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060817	\N	\N
659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060819	\N	\N
660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06082	\N	\N
661	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060821	\N	\N
662	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060823	\N	\N
663	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060824	\N	\N
664	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060826	\N	\N
665	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060827	\N	\N
666	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060828	\N	\N
667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06083	\N	\N
668	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060831	\N	\N
669	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060832	\N	\N
670	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060834	\N	\N
671	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060835	\N	\N
672	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060836	\N	\N
673	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060838	\N	\N
674	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060839	\N	\N
675	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060841	\N	\N
676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060842	\N	\N
677	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060843	\N	\N
678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060845	\N	\N
679	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060846	\N	\N
680	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060847	\N	\N
681	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060849	\N	\N
682	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.06085	\N	\N
683	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060851	\N	\N
684	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060853	\N	\N
685	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060854	\N	\N
686	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060856	\N	\N
687	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060857	\N	\N
688	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060858	\N	\N
689	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060861	\N	\N
690	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060863	\N	\N
691	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060864	\N	\N
692	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-24 15:54:07.060866	\N	\N
693	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060867	\N	\N
694	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060868	\N	\N
695	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06087	\N	\N
696	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060871	\N	\N
697	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060872	\N	\N
698	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060874	\N	\N
699	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060875	\N	\N
700	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060877	\N	\N
701	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060878	\N	\N
702	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060879	\N	\N
703	TheShamRio	test1	2011	article	draft	\N	16	2025-02-24 15:54:07.060881	\N	\N
704	авп	ыва	1992	article	draft	\N	16	2025-02-24 15:54:07.060882	\N	\N
705	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-24 15:54:07.060883	\N	\N
706	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-24 15:54:07.060885	\N	\N
707	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-24 15:54:07.060886	\N	\N
708	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-24 15:54:07.060887	\N	\N
709	dfd	sdfs	2022	article	draft	\N	16	2025-02-24 15:54:07.060889	\N	\N
710	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.06089	\N	\N
711	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060892	\N	\N
712	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060893	\N	\N
713	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060894	\N	\N
714	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060896	\N	\N
715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060897	\N	\N
716	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060898	\N	\N
717	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.0609	\N	\N
718	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060901	\N	\N
719	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060902	\N	\N
720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060904	\N	\N
721	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060905	\N	\N
722	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060906	\N	\N
723	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060908	\N	\N
724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060909	\N	\N
725	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060911	\N	\N
726	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060912	\N	\N
727	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060913	\N	\N
728	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060915	\N	\N
729	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060916	\N	\N
730	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060917	\N	\N
731	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060919	\N	\N
732	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06092	\N	\N
733	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060921	\N	\N
734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060923	\N	\N
735	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060924	\N	\N
737	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060927	\N	\N
738	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060928	\N	\N
739	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06093	\N	\N
740	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060931	\N	\N
741	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060932	\N	\N
742	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060934	\N	\N
743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060935	\N	\N
744	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060936	\N	\N
745	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060938	\N	\N
746	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060939	\N	\N
747	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060941	\N	\N
748	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060942	\N	\N
749	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060943	\N	\N
750	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060945	\N	\N
751	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060946	\N	\N
752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060947	\N	\N
753	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060949	\N	\N
754	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.06095	\N	\N
755	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060952	\N	\N
756	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060953	\N	\N
757	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060954	\N	\N
758	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060956	\N	\N
759	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060957	\N	\N
760	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060958	\N	\N
761	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06096	\N	\N
762	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060961	\N	\N
763	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060963	\N	\N
764	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060964	\N	\N
765	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060965	\N	\N
766	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060967	\N	\N
767	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060968	\N	\N
768	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060969	\N	\N
769	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060971	\N	\N
770	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060972	\N	\N
771	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060973	\N	\N
772	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060975	\N	\N
773	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.060976	\N	\N
774	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060979	\N	\N
775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.06098	\N	\N
776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060982	\N	\N
777	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060983	\N	\N
779	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060986	\N	\N
780	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.060987	\N	\N
781	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.060989	\N	\N
782	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.06099	\N	\N
778	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	16	2025-02-25 01:44:56.259863	\N	\N
1161	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370949	\N	\N
783	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060991	\N	\N
784	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060993	\N	\N
785	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060994	\N	\N
786	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060995	\N	\N
787	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060997	\N	\N
788	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060998	\N	\N
789	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.060999	\N	\N
790	Sham	test2	2010	article	draft	\N	16	2025-02-24 15:54:07.061001	\N	\N
791	длолд	ирмтми	2015	article	draft	\N	16	2025-02-24 15:54:07.061002	\N	\N
793	ddsdf	test1	2015	article	draft	\N	16	2025-02-24 15:54:07.061005	\N	\N
794	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.061006	\N	\N
795	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.061008	\N	\N
796	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-24 15:54:07.061009	\N	\N
798	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	published	\N	16	2025-02-24 20:08:13.890181	\N	\N
805	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	19	2025-02-24 22:00:42.970915	\N	\N
806	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	19	2025-02-24 22:00:42.970919	\N	\N
60	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	/uploads/Spasi_i_Sokhrani.docx	7	2025-02-24 22:08:10.73348	\N	\N
807	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	19	2025-02-24 22:00:42.970922	\N	\N
799	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	16	2025-02-24 16:31:26.060319	\N	\N
126	Sham	test2	2010	article	published	\N	7	2025-02-22 11:53:38.87618	\N	\N
109	ddsdfdfddddddddd	test1	2015	article	published	\N	7	2025-02-22 11:53:02.049733	\N	\N
123	ssssssssssssssssss	Albert Einstein	1905	article	published	\N	7	2025-02-22 11:53:11.801522	\N	\N
23	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	5	2025-02-22 19:20:03.641889	\N	\N
34	ddsdf	test1	2015	article	published	\N	7	2025-02-22 22:41:06.997614	\N	\N
51	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-22 22:41:06.997614	\N	\N
53	Sham	test2	2010	article	published	\N	7	2025-02-22 22:41:06.997614	\N	\N
45	ddsdf	test1	2015	article	published	\N	7	2025-02-22 22:41:06.997614	\N	\N
135	Sham	test2	2010	article	published	\N	7	2025-02-22 22:41:06.997614	\N	\N
136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-22 22:41:06.997614	\N	\N
134	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-22 22:41:06.997614	\N	\N
133	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	7	2025-02-22 22:41:06.997614	\N	\N
276	ddsdf	test1	2015	conference	published	\N	16	2025-02-24 09:56:09.872409	\N	\N
792	dfg	dfgdfg	2023	article	published	\N	16	2025-02-24 16:36:39.285975	\N	\N
808	Robotics and Automation	Evans, Linda	2021	article	draft	\N	19	2025-02-24 22:00:42.970924	\N	\N
801	Sham	test2	2010	article	published	\N	16	2025-02-24 16:37:35.297233	\N	\N
800	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	16	2025-02-24 16:46:59.150272	\N	\N
797	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	\N	16	2025-02-24 16:50:49.423358	\N	\N
809	dfd	sdfs	2022	article	draft	\N	19	2025-02-24 22:00:42.970926	\N	\N
810	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.970927	\N	\N
811	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970929	\N	\N
812	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970931	\N	\N
813	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970932	\N	\N
814	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970934	\N	\N
815	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970936	\N	\N
816	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970937	\N	\N
817	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970939	\N	\N
818	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.97094	\N	\N
819	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970942	\N	\N
820	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970943	\N	\N
1297	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.37114	\N	\N
1298	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 01:50:19.371141	\N	\N
821	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970944	\N	\N
822	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970946	\N	\N
823	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970947	\N	\N
824	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970949	\N	\N
825	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97095	\N	\N
826	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.970951	\N	\N
827	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.970953	\N	\N
828	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970954	\N	\N
829	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970956	\N	\N
830	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970957	\N	\N
831	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970959	\N	\N
832	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97096	\N	\N
833	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970962	\N	\N
834	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970963	\N	\N
835	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.970966	\N	\N
836	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.970968	\N	\N
837	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97097	\N	\N
838	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970972	\N	\N
839	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970974	\N	\N
840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970976	\N	\N
841	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970979	\N	\N
842	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970981	\N	\N
843	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970983	\N	\N
844	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.970985	\N	\N
845	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.970986	\N	\N
846	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.970987	\N	\N
847	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970989	\N	\N
848	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970991	\N	\N
849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970992	\N	\N
850	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970993	\N	\N
851	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970995	\N	\N
852	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970996	\N	\N
853	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.970998	\N	\N
854	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.970999	\N	\N
855	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971001	\N	\N
856	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971002	\N	\N
857	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971004	\N	\N
858	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971005	\N	\N
859	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971006	\N	\N
860	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971008	\N	\N
861	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971009	\N	\N
862	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971011	\N	\N
863	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971012	\N	\N
864	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971014	\N	\N
865	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971015	\N	\N
866	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971017	\N	\N
867	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971018	\N	\N
868	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97102	\N	\N
869	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971021	\N	\N
870	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971022	\N	\N
871	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971024	\N	\N
872	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971025	\N	\N
873	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971027	\N	\N
874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971028	\N	\N
875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97103	\N	\N
876	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971031	\N	\N
877	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971032	\N	\N
878	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971034	\N	\N
879	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971035	\N	\N
880	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971037	\N	\N
881	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971038	\N	\N
882	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.97104	\N	\N
883	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971041	\N	\N
884	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971043	\N	\N
885	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971044	\N	\N
886	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971046	\N	\N
887	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971049	\N	\N
888	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971051	\N	\N
889	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971052	\N	\N
890	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971054	\N	\N
891	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971055	\N	\N
892	dfg	dfgdfg	2023	article	draft	\N	19	2025-02-24 22:00:42.971056	\N	\N
893	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971058	\N	\N
894	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971059	\N	\N
895	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971061	\N	\N
896	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971062	\N	\N
897	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971063	\N	\N
898	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971065	\N	\N
899	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971068	\N	\N
900	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97107	\N	\N
901	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971117	\N	\N
902	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971123	\N	\N
903	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	19	2025-02-24 22:00:42.971126	\N	\N
904	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	19	2025-02-24 22:00:42.971129	\N	\N
905	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	19	2025-02-24 22:00:42.971131	\N	\N
906	Robotics and Automation	Evans, Linda	2021	article	draft	\N	19	2025-02-24 22:00:42.971133	\N	\N
907	dfd	sdfs	2022	article	draft	\N	19	2025-02-24 22:00:42.971135	\N	\N
908	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971136	\N	\N
909	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971138	\N	\N
910	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971141	\N	\N
911	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971143	\N	\N
912	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971145	\N	\N
913	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971147	\N	\N
914	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971149	\N	\N
915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971151	\N	\N
916	ddsdf	test1	2012	article	draft	\N	19	2025-02-24 22:00:42.971152	\N	\N
917	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971155	\N	\N
918	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971156	\N	\N
919	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971158	\N	\N
920	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971159	\N	\N
921	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971161	\N	\N
922	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971163	\N	\N
923	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971166	\N	\N
924	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971168	\N	\N
925	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971171	\N	\N
926	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971173	\N	\N
927	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971175	\N	\N
928	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971177	\N	\N
929	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971179	\N	\N
930	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971181	\N	\N
931	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971183	\N	\N
932	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971185	\N	\N
933	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971188	\N	\N
934	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.97119	\N	\N
935	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971192	\N	\N
936	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971195	\N	\N
937	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971197	\N	\N
938	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971203	\N	\N
939	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971207	\N	\N
940	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971209	\N	\N
941	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971211	\N	\N
942	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971213	\N	\N
943	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971215	\N	\N
944	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971217	\N	\N
945	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971219	\N	\N
946	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971221	\N	\N
947	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971223	\N	\N
948	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971225	\N	\N
949	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971227	\N	\N
950	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971229	\N	\N
951	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971232	\N	\N
952	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971234	\N	\N
953	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971236	\N	\N
954	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971239	\N	\N
955	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971241	\N	\N
956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971243	\N	\N
957	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971245	\N	\N
958	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971247	\N	\N
959	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971248	\N	\N
960	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97125	\N	\N
961	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971252	\N	\N
962	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971253	\N	\N
963	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971255	\N	\N
964	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971256	\N	\N
965	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971258	\N	\N
966	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971259	\N	\N
967	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971261	\N	\N
968	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971263	\N	\N
969	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971265	\N	\N
970	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971266	\N	\N
971	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971268	\N	\N
972	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971269	\N	\N
973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971271	\N	\N
974	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971273	\N	\N
975	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971274	\N	\N
976	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971276	\N	\N
977	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971277	\N	\N
978	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971279	\N	\N
979	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971281	\N	\N
980	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971282	\N	\N
981	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971284	\N	\N
982	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971285	\N	\N
983	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971287	\N	\N
984	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971289	\N	\N
985	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97129	\N	\N
986	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971292	\N	\N
987	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971294	\N	\N
988	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971295	\N	\N
989	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971297	\N	\N
990	dfg	dfgdfg	2023	article	draft	\N	19	2025-02-24 22:00:42.971299	\N	\N
991	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.9713	\N	\N
992	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971302	\N	\N
993	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971303	\N	\N
994	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971305	\N	\N
995	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971306	\N	\N
996	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971308	\N	\N
997	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971309	\N	\N
998	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971311	\N	\N
999	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971312	\N	\N
1000	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971314	\N	\N
1001	TheShamRio	test1	2011	article	draft	\N	19	2025-02-24 22:00:42.971316	\N	\N
1002	авп	ыва	1992	article	draft	\N	19	2025-02-24 22:00:42.971317	\N	\N
1003	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	19	2025-02-24 22:00:42.971319	\N	\N
1004	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	19	2025-02-24 22:00:42.97132	\N	\N
1005	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	19	2025-02-24 22:00:42.971322	\N	\N
1006	Robotics and Automation	Evans, Linda	2021	article	draft	\N	19	2025-02-24 22:00:42.971323	\N	\N
1007	dfd	sdfs	2022	article	draft	\N	19	2025-02-24 22:00:42.971324	\N	\N
1008	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971326	\N	\N
1009	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971328	\N	\N
1010	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971329	\N	\N
1011	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971331	\N	\N
1012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971332	\N	\N
1013	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971334	\N	\N
1014	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971335	\N	\N
1015	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971337	\N	\N
1016	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971338	\N	\N
1017	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97134	\N	\N
1018	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971341	\N	\N
1019	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971343	\N	\N
1020	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971344	\N	\N
1021	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971346	\N	\N
1022	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971347	\N	\N
1023	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971349	\N	\N
1027	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971355	\N	\N
1028	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971357	\N	\N
1029	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971358	\N	\N
1030	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97136	\N	\N
1031	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971361	\N	\N
1032	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971363	\N	\N
1033	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971364	\N	\N
1034	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971366	\N	\N
1035	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971367	\N	\N
1036	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971369	\N	\N
1037	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97137	\N	\N
1038	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971372	\N	\N
1039	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971373	\N	\N
1040	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971375	\N	\N
1041	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971376	\N	\N
1042	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971378	\N	\N
1043	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971379	\N	\N
1044	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971381	\N	\N
1045	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971382	\N	\N
1046	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971384	\N	\N
1047	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971385	\N	\N
1048	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971387	\N	\N
1049	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971388	\N	\N
1050	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97139	\N	\N
1051	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971392	\N	\N
1052	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971393	\N	\N
1053	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971395	\N	\N
1054	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971396	\N	\N
1055	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971398	\N	\N
1056	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971399	\N	\N
1057	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971401	\N	\N
1058	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971402	\N	\N
1059	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971405	\N	\N
1060	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971406	\N	\N
1061	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971408	\N	\N
1062	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.97141	\N	\N
1063	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971415	\N	\N
1064	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971421	\N	\N
1065	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971423	\N	\N
1066	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971425	\N	\N
1067	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971426	\N	\N
1068	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971428	\N	\N
1069	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971431	\N	\N
1070	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971433	\N	\N
1071	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971434	\N	\N
1072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971436	\N	\N
1073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971437	\N	\N
1074	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971439	\N	\N
1075	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97144	\N	\N
1076	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971447	\N	\N
1077	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971448	\N	\N
1078	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.97145	\N	\N
1079	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971451	\N	\N
1080	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971453	\N	\N
1081	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971455	\N	\N
1082	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971457	\N	\N
1083	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971459	\N	\N
1084	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971461	\N	\N
1085	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971462	\N	\N
1086	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971465	\N	\N
1087	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971467	\N	\N
1088	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971469	\N	\N
1089	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971471	\N	\N
1090	dfg	dfgdfg	2023	article	draft	\N	19	2025-02-24 22:00:42.971473	\N	\N
1091	ddsdf	test1	2015	article	draft	\N	19	2025-02-24 22:00:42.971475	\N	\N
1092	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971476	\N	\N
1093	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971478	\N	\N
1094	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971481	\N	\N
1095	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971483	\N	\N
1096	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971485	\N	\N
1097	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.971488	\N	\N
1098	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	19	2025-02-24 22:00:42.97149	\N	\N
1099	Sham	test2	2010	article	draft	\N	19	2025-02-24 22:00:42.971493	\N	\N
1100	длолд	ирмтми	2015	article	draft	\N	19	2025-02-24 22:00:42.971494	\N	\N
1424	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334931	\N	\N
1425	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334932	\N	\N
1101	555	555ss	1999	article	published	\N	19	2025-02-24 22:01:22.456069	\N	\N
1102	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 01:50:19.370861	\N	\N
1103	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 01:50:19.370866	\N	\N
1104	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 01:50:19.370868	\N	\N
1105	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 01:50:19.37087	\N	\N
1106	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 01:50:19.370872	\N	\N
1107	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370873	\N	\N
1108	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370875	\N	\N
1109	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370876	\N	\N
1110	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370877	\N	\N
1111	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370879	\N	\N
1112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37088	\N	\N
1113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370882	\N	\N
1114	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370883	\N	\N
1115	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370885	\N	\N
1116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370886	\N	\N
1117	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370887	\N	\N
1118	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370889	\N	\N
1119	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37089	\N	\N
1120	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370892	\N	\N
1121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370893	\N	\N
1122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370894	\N	\N
1123	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370896	\N	\N
1124	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370897	\N	\N
1125	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370899	\N	\N
1126	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.3709	\N	\N
1127	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370901	\N	\N
1128	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370903	\N	\N
1129	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370904	\N	\N
1130	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370906	\N	\N
1131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370907	\N	\N
1132	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370909	\N	\N
1133	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.37091	\N	\N
1134	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370912	\N	\N
1135	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370913	\N	\N
1136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370914	\N	\N
1137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370916	\N	\N
1138	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370917	\N	\N
1139	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370918	\N	\N
1140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37092	\N	\N
1141	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370921	\N	\N
1142	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.370923	\N	\N
1143	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370924	\N	\N
1144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370926	\N	\N
1145	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370927	\N	\N
1146	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370928	\N	\N
1147	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37093	\N	\N
1148	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370931	\N	\N
1149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370933	\N	\N
1150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370934	\N	\N
1151	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370935	\N	\N
1152	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370937	\N	\N
1153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370938	\N	\N
1154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370939	\N	\N
1155	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370941	\N	\N
1156	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370942	\N	\N
1157	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370944	\N	\N
1158	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370945	\N	\N
1159	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370946	\N	\N
1162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370951	\N	\N
1163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370952	\N	\N
1164	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370953	\N	\N
1165	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370955	\N	\N
1166	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370956	\N	\N
1167	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370958	\N	\N
1168	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370959	\N	\N
1169	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.37096	\N	\N
1170	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370962	\N	\N
1171	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370963	\N	\N
1172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370964	\N	\N
1173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370966	\N	\N
1174	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370967	\N	\N
1175	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370969	\N	\N
1176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37097	\N	\N
1177	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370971	\N	\N
1178	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.370973	\N	\N
1179	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.370974	\N	\N
1180	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370976	\N	\N
1181	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370977	\N	\N
1182	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370979	\N	\N
1183	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37098	\N	\N
1184	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370981	\N	\N
1185	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370983	\N	\N
1186	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370984	\N	\N
1187	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.370986	\N	\N
1188	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.370987	\N	\N
1189	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 01:50:19.370988	\N	\N
1190	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.37099	\N	\N
1191	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370991	\N	\N
1192	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370993	\N	\N
1193	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370994	\N	\N
1194	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370995	\N	\N
1195	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370997	\N	\N
1196	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.370998	\N	\N
1197	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371	\N	\N
1198	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371001	\N	\N
1199	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371002	\N	\N
1200	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 01:50:19.371004	\N	\N
1201	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 01:50:19.371005	\N	\N
1202	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 01:50:19.371007	\N	\N
1203	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 01:50:19.371008	\N	\N
1204	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 01:50:19.37101	\N	\N
1205	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371011	\N	\N
1206	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371012	\N	\N
1207	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371014	\N	\N
1208	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371015	\N	\N
1209	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371016	\N	\N
1210	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371018	\N	\N
1211	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371019	\N	\N
1212	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371021	\N	\N
1213	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 01:50:19.371022	\N	\N
1214	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371024	\N	\N
1215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371025	\N	\N
1216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371026	\N	\N
1217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371028	\N	\N
1218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371029	\N	\N
1219	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371031	\N	\N
1220	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371032	\N	\N
1221	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371034	\N	\N
1222	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371035	\N	\N
1223	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371037	\N	\N
1224	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371038	\N	\N
1225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371039	\N	\N
1226	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371041	\N	\N
1227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371042	\N	\N
1228	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371044	\N	\N
1229	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371045	\N	\N
1230	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371046	\N	\N
1231	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371048	\N	\N
1232	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371049	\N	\N
1233	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371051	\N	\N
1234	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371052	\N	\N
1235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371053	\N	\N
1236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371055	\N	\N
1237	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371056	\N	\N
1238	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371058	\N	\N
1239	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371059	\N	\N
1240	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.37106	\N	\N
1241	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371062	\N	\N
1242	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371063	\N	\N
1243	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371064	\N	\N
1244	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371066	\N	\N
1245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371067	\N	\N
1246	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371069	\N	\N
1247	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37107	\N	\N
1248	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371072	\N	\N
1249	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371073	\N	\N
1250	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371074	\N	\N
1251	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371076	\N	\N
1252	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371077	\N	\N
1253	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371079	\N	\N
1254	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37108	\N	\N
1255	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371082	\N	\N
1256	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371083	\N	\N
1257	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371084	\N	\N
1258	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371086	\N	\N
1259	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371087	\N	\N
1260	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371089	\N	\N
1261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37109	\N	\N
1262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371091	\N	\N
1263	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371093	\N	\N
1264	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371094	\N	\N
1265	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371096	\N	\N
1266	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371097	\N	\N
1267	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371098	\N	\N
1268	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.3711	\N	\N
1269	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371101	\N	\N
1270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371102	\N	\N
1271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371104	\N	\N
1272	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371105	\N	\N
1273	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371107	\N	\N
1274	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371108	\N	\N
1275	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371109	\N	\N
1276	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371111	\N	\N
1277	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371112	\N	\N
1278	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371113	\N	\N
1279	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371115	\N	\N
1280	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371116	\N	\N
1281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371118	\N	\N
1282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371119	\N	\N
1283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37112	\N	\N
1284	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371122	\N	\N
1285	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371123	\N	\N
1286	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371125	\N	\N
1287	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 01:50:19.371126	\N	\N
1288	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371127	\N	\N
1289	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371129	\N	\N
1290	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37113	\N	\N
1291	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371132	\N	\N
1292	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371133	\N	\N
1293	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371134	\N	\N
1294	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371136	\N	\N
1295	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371137	\N	\N
1296	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371139	\N	\N
1311	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37116	\N	\N
1312	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371161	\N	\N
1313	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371162	\N	\N
1314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371164	\N	\N
1315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371165	\N	\N
1316	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371167	\N	\N
1317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371168	\N	\N
1318	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37117	\N	\N
1319	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371171	\N	\N
1320	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371173	\N	\N
1321	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371174	\N	\N
1322	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371175	\N	\N
1323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371177	\N	\N
1324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371178	\N	\N
1325	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37118	\N	\N
1326	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371181	\N	\N
1327	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371182	\N	\N
1328	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371184	\N	\N
1329	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371185	\N	\N
1330	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371187	\N	\N
1331	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371188	\N	\N
1332	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37119	\N	\N
1333	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371191	\N	\N
1334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371192	\N	\N
1335	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371194	\N	\N
1336	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371195	\N	\N
1337	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371197	\N	\N
1338	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371198	\N	\N
1339	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.3712	\N	\N
1340	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371201	\N	\N
1341	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371202	\N	\N
1342	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371204	\N	\N
1343	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371205	\N	\N
1344	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371207	\N	\N
1345	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371208	\N	\N
1346	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371209	\N	\N
1347	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371211	\N	\N
1348	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371212	\N	\N
1349	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371214	\N	\N
1350	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371215	\N	\N
1351	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371217	\N	\N
1352	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371218	\N	\N
1353	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371219	\N	\N
1354	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371221	\N	\N
1355	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371222	\N	\N
1356	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371224	\N	\N
1357	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371225	\N	\N
1358	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371226	\N	\N
1359	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371228	\N	\N
1360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371229	\N	\N
1361	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371231	\N	\N
1362	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371232	\N	\N
1363	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371233	\N	\N
1364	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371235	\N	\N
1365	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371236	\N	\N
1366	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371237	\N	\N
1367	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371239	\N	\N
1368	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.37124	\N	\N
1369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371242	\N	\N
1370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371243	\N	\N
1371	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371245	\N	\N
1372	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371246	\N	\N
1373	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371247	\N	\N
1374	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371249	\N	\N
1375	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.37125	\N	\N
1376	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371252	\N	\N
1377	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371253	\N	\N
2880	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48969	\N	\N
1378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371254	\N	\N
1379	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371256	\N	\N
1380	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371257	\N	\N
1381	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371259	\N	\N
1382	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37126	\N	\N
1383	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371261	\N	\N
1384	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371263	\N	\N
1385	Sham	test2	2010	article	draft	\N	16	2025-02-25 01:50:19.371264	\N	\N
1386	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 01:50:19.371266	\N	\N
1387	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 01:50:19.371267	\N	\N
1388	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 01:50:19.371268	\N	\N
1389	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.37127	\N	\N
1390	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371271	\N	\N
1391	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371273	\N	\N
1392	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371274	\N	\N
1393	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 01:50:19.371275	\N	\N
219	Sham	test2	1993	monograph	draft	/uploads/-17.pdf	16	2025-02-22 21:54:16.612963	\N	\N
3223	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142064	\N	\N
19	Тестовая публикация #1	Иван Иванов	2025	article	draft	/uploads/2.docx	5	2025-02-22 11:46:50.845599	\N	\N
3224	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142065	\N	\N
3225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142066	\N	\N
3226	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142068	\N	\N
44	lol2	lol2	2011	article	draft	/uploads/4411__3_1.docx	7	2025-02-22 22:41:06.997614	\N	\N
90	Иван Иванов	укеуке	2022	article	draft	/uploads/4411__3_1.docx	7	2025-02-22 22:41:06.997614	\N	\N
1426	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334934	\N	\N
1427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334935	\N	\N
1428	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334937	\N	\N
1429	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334938	\N	\N
1430	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33494	\N	\N
1431	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334941	\N	\N
1432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334943	\N	\N
1433	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334944	\N	\N
1434	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334946	\N	\N
1435	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334947	\N	\N
1436	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334948	\N	\N
1437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33495	\N	\N
1438	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334951	\N	\N
1439	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.334953	\N	\N
1440	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.334954	\N	\N
1441	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334956	\N	\N
1442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334957	\N	\N
1443	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334958	\N	\N
1444	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33496	\N	\N
1445	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334961	\N	\N
1446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334963	\N	\N
1447	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334964	\N	\N
1448	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334966	\N	\N
1449	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.334967	\N	\N
1450	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334969	\N	\N
1451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33497	\N	\N
1452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334972	\N	\N
1453	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334973	\N	\N
1454	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334975	\N	\N
1455	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334976	\N	\N
1456	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334978	\N	\N
1457	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334979	\N	\N
1458	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33498	\N	\N
1459	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334982	\N	\N
1460	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334983	\N	\N
3227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142069	\N	\N
3228	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14207	\N	\N
7757	123456	123456	1999	article	published	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-03-09 20:33:43.870843	2025-03-09 20:33:43.870339	f
7758	111111	1111111	1991	article	published	/uploads/Zayavlenie_na_utverzhdenie_temy_VKR_-_blank.pdf	40	2025-03-07 11:15:13.435505	2025-03-07 11:15:13.434983	f
7756	asdas	dasd	2011	article	draft	/uploads/-_2017.pdf	16	2025-03-09 20:33:26.520328	\N	t
7765	123	123	2001	monograph	published	/uploads/-_2017.pdf	40	2025-03-09 22:00:15.980032	2025-03-09 22:00:15.979485	f
406	TheShamRio	test1	2011	article	draft	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-24 10:31:29.617339	\N	\N
1465	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33499	\N	\N
1466	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334992	\N	\N
1467	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.334993	\N	\N
1468	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.334994	\N	\N
1469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334996	\N	\N
1470	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334997	\N	\N
1471	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.334998	\N	\N
1472	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335	\N	\N
1473	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335001	\N	\N
1474	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335003	\N	\N
1475	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335004	\N	\N
1476	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335005	\N	\N
1477	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335007	\N	\N
1478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335008	\N	\N
1479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335009	\N	\N
1480	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335011	\N	\N
1481	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335012	\N	\N
1482	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335014	\N	\N
1483	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335015	\N	\N
1484	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335016	\N	\N
1485	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335018	\N	\N
1486	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335019	\N	\N
1487	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.33502	\N	\N
1488	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335022	\N	\N
1489	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335023	\N	\N
1490	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335025	\N	\N
1491	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335026	\N	\N
1492	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335027	\N	\N
1493	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335029	\N	\N
1494	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33503	\N	\N
1495	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335031	\N	\N
1496	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335033	\N	\N
1497	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335034	\N	\N
1498	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335036	\N	\N
1499	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335037	\N	\N
1500	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335038	\N	\N
1501	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.33504	\N	\N
1502	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335041	\N	\N
1503	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335043	\N	\N
1504	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335044	\N	\N
1505	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335045	\N	\N
1506	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335047	\N	\N
1507	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335048	\N	\N
1508	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33505	\N	\N
1509	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335051	\N	\N
1510	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335053	\N	\N
1511	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:24:31.335054	\N	\N
1512	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335055	\N	\N
1513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335057	\N	\N
1514	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335058	\N	\N
1515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33506	\N	\N
1516	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335061	\N	\N
1517	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335063	\N	\N
1518	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335064	\N	\N
1519	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335065	\N	\N
1520	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335067	\N	\N
1521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335068	\N	\N
1522	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33507	\N	\N
1523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335071	\N	\N
1524	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335072	\N	\N
1525	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335074	\N	\N
1526	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335075	\N	\N
1527	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335077	\N	\N
1528	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335078	\N	\N
1529	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335079	\N	\N
1530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335081	\N	\N
1531	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335082	\N	\N
1532	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335083	\N	\N
1533	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335085	\N	\N
1534	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335086	\N	\N
1535	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335088	\N	\N
1536	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335089	\N	\N
1537	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335091	\N	\N
1538	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335092	\N	\N
1539	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335093	\N	\N
1540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335095	\N	\N
1541	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335096	\N	\N
1542	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335098	\N	\N
1543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335099	\N	\N
1544	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.3351	\N	\N
1545	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335102	\N	\N
1546	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335103	\N	\N
1547	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335104	\N	\N
1548	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335106	\N	\N
1549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335107	\N	\N
1550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335109	\N	\N
1551	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33511	\N	\N
1552	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335111	\N	\N
1553	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335113	\N	\N
1554	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335114	\N	\N
1555	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335116	\N	\N
1556	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335117	\N	\N
1557	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335118	\N	\N
1558	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33512	\N	\N
1559	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335121	\N	\N
1560	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335123	\N	\N
1561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335124	\N	\N
1562	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335126	\N	\N
1563	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335127	\N	\N
1564	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335128	\N	\N
1565	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33513	\N	\N
1566	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335131	\N	\N
1567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335132	\N	\N
1568	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335134	\N	\N
1569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335135	\N	\N
1570	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335136	\N	\N
1571	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335138	\N	\N
1572	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335139	\N	\N
1573	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335141	\N	\N
1574	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335142	\N	\N
1575	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335143	\N	\N
1576	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335145	\N	\N
1577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335146	\N	\N
1578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335147	\N	\N
1579	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335149	\N	\N
1580	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33515	\N	\N
1581	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335151	\N	\N
1582	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335153	\N	\N
1583	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335154	\N	\N
1584	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335155	\N	\N
1585	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335157	\N	\N
1586	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335158	\N	\N
1587	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33516	\N	\N
1588	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335161	\N	\N
1589	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335162	\N	\N
1590	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335164	\N	\N
1591	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335165	\N	\N
1592	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335166	\N	\N
1593	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335168	\N	\N
1594	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335169	\N	\N
1595	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.33517	\N	\N
1596	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:24:31.335172	\N	\N
1597	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:24:31.335173	\N	\N
1598	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335175	\N	\N
1599	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335176	\N	\N
1600	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335177	\N	\N
1601	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335179	\N	\N
1602	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.33518	\N	\N
1603	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335181	\N	\N
1604	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335183	\N	\N
1605	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335184	\N	\N
1606	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335185	\N	\N
1607	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335187	\N	\N
1608	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335188	\N	\N
1609	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33519	\N	\N
1610	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335191	\N	\N
1611	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335192	\N	\N
1612	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335194	\N	\N
1613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335195	\N	\N
1614	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335196	\N	\N
1615	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335198	\N	\N
1616	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335199	\N	\N
1617	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.3352	\N	\N
1618	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335202	\N	\N
1619	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335203	\N	\N
1620	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335204	\N	\N
1621	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335206	\N	\N
1622	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335207	\N	\N
1623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335209	\N	\N
1624	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33521	\N	\N
1625	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335211	\N	\N
1626	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335213	\N	\N
1627	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335214	\N	\N
1628	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335215	\N	\N
1629	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335217	\N	\N
1630	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335218	\N	\N
1631	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335219	\N	\N
1632	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335221	\N	\N
1633	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335222	\N	\N
1634	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335223	\N	\N
1635	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335225	\N	\N
1636	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335226	\N	\N
1637	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335228	\N	\N
1638	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335229	\N	\N
1639	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33523	\N	\N
1640	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335232	\N	\N
1641	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335233	\N	\N
1642	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335234	\N	\N
1643	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335236	\N	\N
1644	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335237	\N	\N
1645	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335239	\N	\N
1646	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33524	\N	\N
1647	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335241	\N	\N
1648	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335243	\N	\N
1649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335244	\N	\N
1650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335245	\N	\N
1651	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335247	\N	\N
1652	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335248	\N	\N
1653	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33525	\N	\N
1654	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335251	\N	\N
1655	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335252	\N	\N
1656	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335254	\N	\N
1657	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335255	\N	\N
1658	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335257	\N	\N
1659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335258	\N	\N
1660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335259	\N	\N
1661	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335261	\N	\N
1662	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335262	\N	\N
1663	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335263	\N	\N
1664	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335265	\N	\N
1665	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335266	\N	\N
1666	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335268	\N	\N
1667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335269	\N	\N
1668	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33527	\N	\N
1669	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335272	\N	\N
1670	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335273	\N	\N
1671	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335274	\N	\N
1672	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335276	\N	\N
1673	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335277	\N	\N
1674	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335279	\N	\N
1675	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33528	\N	\N
1676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335281	\N	\N
1677	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335283	\N	\N
1678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335284	\N	\N
1679	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335285	\N	\N
1680	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335287	\N	\N
1681	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335288	\N	\N
1682	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33529	\N	\N
1683	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335291	\N	\N
1684	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335292	\N	\N
1685	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335294	\N	\N
1686	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335295	\N	\N
1687	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335296	\N	\N
1688	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335298	\N	\N
1689	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335299	\N	\N
1690	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335301	\N	\N
1691	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335302	\N	\N
1692	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335303	\N	\N
1693	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335305	\N	\N
1694	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335306	\N	\N
1695	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335307	\N	\N
1696	555	555	1999	article	draft	\N	16	2025-02-25 03:24:31.335309	\N	\N
1697	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.33531	\N	\N
1698	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335311	\N	\N
1699	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335313	\N	\N
1700	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335314	\N	\N
1701	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335316	\N	\N
1702	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335317	\N	\N
1703	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335318	\N	\N
1704	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33532	\N	\N
1705	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335321	\N	\N
1706	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335322	\N	\N
1707	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335324	\N	\N
1708	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335325	\N	\N
1709	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335326	\N	\N
1710	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335328	\N	\N
1711	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335329	\N	\N
1712	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33533	\N	\N
1713	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335332	\N	\N
1714	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335333	\N	\N
1715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335335	\N	\N
1716	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335336	\N	\N
1717	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335337	\N	\N
1718	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335339	\N	\N
1719	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33534	\N	\N
1720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335341	\N	\N
1721	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335343	\N	\N
1722	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335344	\N	\N
1723	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335345	\N	\N
1724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335347	\N	\N
1725	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335348	\N	\N
1726	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335349	\N	\N
1727	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335351	\N	\N
1728	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335352	\N	\N
1729	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335354	\N	\N
1730	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335355	\N	\N
1731	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335356	\N	\N
1732	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335358	\N	\N
1733	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335359	\N	\N
1734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33536	\N	\N
3904	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142968	\N	\N
1735	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335362	\N	\N
1736	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335363	\N	\N
1737	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335364	\N	\N
1738	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335366	\N	\N
1739	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335367	\N	\N
1740	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335368	\N	\N
1741	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33537	\N	\N
1742	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335371	\N	\N
1743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335373	\N	\N
1744	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335374	\N	\N
1745	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335375	\N	\N
1746	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335377	\N	\N
1747	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335378	\N	\N
1748	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335379	\N	\N
1749	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335381	\N	\N
1750	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335382	\N	\N
1751	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335383	\N	\N
1752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335385	\N	\N
1753	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335386	\N	\N
1754	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335387	\N	\N
1755	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335389	\N	\N
1756	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33539	\N	\N
1757	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335392	\N	\N
1758	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335393	\N	\N
1759	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335394	\N	\N
1760	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335396	\N	\N
1761	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335397	\N	\N
1762	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335398	\N	\N
1763	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.3354	\N	\N
1764	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335401	\N	\N
1765	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335403	\N	\N
1766	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335404	\N	\N
1767	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335405	\N	\N
1768	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335407	\N	\N
1769	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335408	\N	\N
1770	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335409	\N	\N
1771	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335411	\N	\N
1772	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335412	\N	\N
1773	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335414	\N	\N
1774	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335415	\N	\N
1775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335416	\N	\N
1776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33542	\N	\N
1777	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335421	\N	\N
1778	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335423	\N	\N
1779	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335424	\N	\N
1780	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335425	\N	\N
1781	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335427	\N	\N
1782	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335428	\N	\N
1783	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335429	\N	\N
1784	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335431	\N	\N
1785	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335432	\N	\N
1786	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335433	\N	\N
1787	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335435	\N	\N
1788	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335436	\N	\N
1789	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335438	\N	\N
1790	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335439	\N	\N
1791	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33544	\N	\N
1792	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335442	\N	\N
1793	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335443	\N	\N
1794	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335444	\N	\N
1795	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335446	\N	\N
1796	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335447	\N	\N
1797	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335448	\N	\N
1798	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.33545	\N	\N
1799	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335451	\N	\N
1800	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335453	\N	\N
1801	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335454	\N	\N
1802	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335455	\N	\N
3905	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142969	\N	\N
1803	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335457	\N	\N
1804	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335458	\N	\N
1805	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335459	\N	\N
1806	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335461	\N	\N
1807	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335462	\N	\N
1808	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:24:31.335463	\N	\N
1809	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335465	\N	\N
1810	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335466	\N	\N
1811	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335467	\N	\N
1812	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335469	\N	\N
1813	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33547	\N	\N
1814	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335471	\N	\N
1815	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335473	\N	\N
1816	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335474	\N	\N
1817	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335475	\N	\N
1818	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335477	\N	\N
1819	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335478	\N	\N
1820	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335479	\N	\N
1821	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335481	\N	\N
1822	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335482	\N	\N
1823	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335484	\N	\N
1824	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335485	\N	\N
1825	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335486	\N	\N
1826	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335488	\N	\N
1827	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335489	\N	\N
1828	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33549	\N	\N
1829	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335492	\N	\N
1830	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335493	\N	\N
1831	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335494	\N	\N
1832	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335496	\N	\N
1833	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335497	\N	\N
1834	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335498	\N	\N
1835	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.3355	\N	\N
1836	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335501	\N	\N
1837	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335502	\N	\N
1838	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335504	\N	\N
1839	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335505	\N	\N
1840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335506	\N	\N
1841	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335508	\N	\N
1842	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335509	\N	\N
1843	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335511	\N	\N
1844	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335512	\N	\N
1845	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335513	\N	\N
1846	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335515	\N	\N
1847	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335516	\N	\N
1848	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335517	\N	\N
1849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335519	\N	\N
1850	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33552	\N	\N
1851	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335521	\N	\N
1852	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335523	\N	\N
1853	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335524	\N	\N
1854	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335525	\N	\N
1855	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335527	\N	\N
1856	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335528	\N	\N
1857	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335529	\N	\N
1858	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335531	\N	\N
1859	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335532	\N	\N
1860	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335535	\N	\N
1861	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335536	\N	\N
1862	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335538	\N	\N
1863	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335539	\N	\N
1864	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33554	\N	\N
1865	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335542	\N	\N
1866	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335543	\N	\N
1867	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335544	\N	\N
1868	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335546	\N	\N
4041	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14315	\N	\N
1869	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335547	\N	\N
1870	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335549	\N	\N
1871	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.33555	\N	\N
1872	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335551	\N	\N
1873	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335553	\N	\N
1874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335554	\N	\N
1875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335555	\N	\N
1876	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335557	\N	\N
1877	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335558	\N	\N
1878	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335559	\N	\N
1879	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335561	\N	\N
1880	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335562	\N	\N
1881	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335563	\N	\N
1882	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335565	\N	\N
1883	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335566	\N	\N
1884	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335567	\N	\N
1885	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335569	\N	\N
1886	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33557	\N	\N
1887	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335572	\N	\N
1888	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335573	\N	\N
1889	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335574	\N	\N
1890	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335576	\N	\N
1891	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335577	\N	\N
1892	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335578	\N	\N
1893	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:24:31.33558	\N	\N
1894	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:24:31.335581	\N	\N
1895	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335582	\N	\N
1896	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335584	\N	\N
1897	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335585	\N	\N
1898	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335587	\N	\N
1899	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335588	\N	\N
1900	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335589	\N	\N
1901	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335591	\N	\N
1902	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335592	\N	\N
1903	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335593	\N	\N
1904	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335595	\N	\N
1905	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335596	\N	\N
1906	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335597	\N	\N
1907	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335599	\N	\N
1908	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.3356	\N	\N
1909	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335602	\N	\N
1910	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335603	\N	\N
1911	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335604	\N	\N
1912	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335606	\N	\N
1913	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335607	\N	\N
1914	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335608	\N	\N
1915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33561	\N	\N
1916	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335611	\N	\N
1917	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335612	\N	\N
1918	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335614	\N	\N
1919	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335615	\N	\N
1920	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335616	\N	\N
1921	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335618	\N	\N
1922	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335619	\N	\N
1923	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33562	\N	\N
1924	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335622	\N	\N
1925	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335623	\N	\N
1926	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335625	\N	\N
1927	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335626	\N	\N
1928	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335627	\N	\N
1929	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335629	\N	\N
1930	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33563	\N	\N
1931	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335631	\N	\N
1932	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335633	\N	\N
1933	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335634	\N	\N
1934	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335635	\N	\N
1935	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335637	\N	\N
1936	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335638	\N	\N
1937	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335639	\N	\N
1938	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335641	\N	\N
1939	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335642	\N	\N
1940	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335643	\N	\N
1941	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335645	\N	\N
1942	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335646	\N	\N
1943	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335647	\N	\N
1944	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335649	\N	\N
1945	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335652	\N	\N
1946	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335653	\N	\N
1947	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335654	\N	\N
1948	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335656	\N	\N
1949	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335657	\N	\N
1950	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335658	\N	\N
1951	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33566	\N	\N
1952	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335661	\N	\N
1953	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335662	\N	\N
1954	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335664	\N	\N
1955	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335665	\N	\N
1956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335667	\N	\N
1957	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335668	\N	\N
1958	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335669	\N	\N
1959	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335671	\N	\N
1960	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335672	\N	\N
1961	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335673	\N	\N
1962	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335675	\N	\N
1963	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335676	\N	\N
1964	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335677	\N	\N
1965	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335679	\N	\N
1966	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33568	\N	\N
1967	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335681	\N	\N
1968	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335683	\N	\N
1969	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335684	\N	\N
1970	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335685	\N	\N
1971	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335688	\N	\N
1972	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33569	\N	\N
1973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335691	\N	\N
1974	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335692	\N	\N
1975	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335694	\N	\N
1976	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335695	\N	\N
1977	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335696	\N	\N
1978	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335698	\N	\N
1979	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335699	\N	\N
1980	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.3357	\N	\N
1981	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335702	\N	\N
1982	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335703	\N	\N
1983	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335704	\N	\N
1984	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335706	\N	\N
1985	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335707	\N	\N
1986	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335709	\N	\N
1987	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33571	\N	\N
1988	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335711	\N	\N
1989	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335713	\N	\N
1990	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335714	\N	\N
1991	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335715	\N	\N
1992	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335717	\N	\N
1993	555	555	1999	article	draft	\N	16	2025-02-25 03:24:31.335718	\N	\N
1994	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335719	\N	\N
1995	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335721	\N	\N
1996	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335722	\N	\N
1997	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335723	\N	\N
1998	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335725	\N	\N
1999	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335726	\N	\N
2000	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335728	\N	\N
2001	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335729	\N	\N
2002	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33573	\N	\N
2003	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335732	\N	\N
2004	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335733	\N	\N
2005	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335734	\N	\N
2006	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335736	\N	\N
2007	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335737	\N	\N
2008	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335738	\N	\N
2009	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33574	\N	\N
2010	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335741	\N	\N
2011	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335742	\N	\N
2012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335744	\N	\N
2013	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335745	\N	\N
2014	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335746	\N	\N
2015	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335748	\N	\N
2016	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335749	\N	\N
2017	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335751	\N	\N
2018	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335752	\N	\N
2019	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335753	\N	\N
2020	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335755	\N	\N
2021	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335756	\N	\N
2022	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335757	\N	\N
2023	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335759	\N	\N
2024	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33576	\N	\N
2025	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335761	\N	\N
2026	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335763	\N	\N
2027	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335764	\N	\N
2028	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335765	\N	\N
2029	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335767	\N	\N
2030	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33577	\N	\N
2031	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335771	\N	\N
2032	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335772	\N	\N
2033	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335774	\N	\N
2034	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335775	\N	\N
2035	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335776	\N	\N
2036	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335778	\N	\N
2037	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335779	\N	\N
2038	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33578	\N	\N
2039	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335782	\N	\N
2040	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335783	\N	\N
2041	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335784	\N	\N
2042	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335786	\N	\N
2043	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335787	\N	\N
2044	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335788	\N	\N
2045	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33579	\N	\N
2046	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335791	\N	\N
2047	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335793	\N	\N
2048	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335794	\N	\N
2049	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335795	\N	\N
2050	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335797	\N	\N
2051	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335798	\N	\N
2052	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335799	\N	\N
2053	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335801	\N	\N
2054	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335802	\N	\N
2055	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335803	\N	\N
2056	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335805	\N	\N
2057	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335806	\N	\N
2058	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335807	\N	\N
2059	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335809	\N	\N
2060	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33581	\N	\N
2061	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335811	\N	\N
2062	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335813	\N	\N
2063	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335814	\N	\N
2064	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335816	\N	\N
2065	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335817	\N	\N
2066	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335818	\N	\N
2067	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33582	\N	\N
2068	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335821	\N	\N
2069	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335822	\N	\N
2070	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335824	\N	\N
2071	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335825	\N	\N
2072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335826	\N	\N
4042	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143151	\N	\N
2073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335828	\N	\N
2074	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335829	\N	\N
2075	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33583	\N	\N
2076	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335832	\N	\N
2077	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335833	\N	\N
2078	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335835	\N	\N
2079	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335836	\N	\N
2080	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335837	\N	\N
2081	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335839	\N	\N
2082	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33584	\N	\N
2083	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335841	\N	\N
2084	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335843	\N	\N
2085	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335844	\N	\N
2086	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335845	\N	\N
2087	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335847	\N	\N
2088	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335848	\N	\N
2089	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335849	\N	\N
2090	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335851	\N	\N
2091	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335852	\N	\N
2092	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.335853	\N	\N
2093	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335855	\N	\N
2094	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335856	\N	\N
2095	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335857	\N	\N
2096	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335859	\N	\N
2097	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33586	\N	\N
2098	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335862	\N	\N
2099	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335863	\N	\N
2100	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335864	\N	\N
2101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335866	\N	\N
2102	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335867	\N	\N
2103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335868	\N	\N
2104	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33587	\N	\N
2105	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:24:31.335871	\N	\N
2106	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335872	\N	\N
2107	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335874	\N	\N
2108	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335875	\N	\N
2109	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335876	\N	\N
2110	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335878	\N	\N
2111	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335879	\N	\N
2112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33588	\N	\N
2113	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335882	\N	\N
2114	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335883	\N	\N
2115	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335884	\N	\N
2116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335887	\N	\N
2117	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335889	\N	\N
2118	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33589	\N	\N
2119	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335891	\N	\N
2120	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335893	\N	\N
2121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335894	\N	\N
2122	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335896	\N	\N
2123	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335897	\N	\N
2124	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335898	\N	\N
2125	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.3359	\N	\N
2126	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335901	\N	\N
2127	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335902	\N	\N
2128	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335904	\N	\N
2129	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335905	\N	\N
2130	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335906	\N	\N
2131	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335908	\N	\N
2132	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335909	\N	\N
2133	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33591	\N	\N
2134	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335912	\N	\N
2135	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335913	\N	\N
2136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335914	\N	\N
2137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335916	\N	\N
2138	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335917	\N	\N
2139	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335918	\N	\N
2140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33592	\N	\N
2141	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335921	\N	\N
2142	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335923	\N	\N
2143	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335924	\N	\N
2144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335925	\N	\N
2145	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335927	\N	\N
2146	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335928	\N	\N
2147	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335929	\N	\N
2148	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335931	\N	\N
2149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335932	\N	\N
2150	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335933	\N	\N
2151	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335935	\N	\N
2152	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335936	\N	\N
2153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335937	\N	\N
2154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335939	\N	\N
2155	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33594	\N	\N
2156	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335941	\N	\N
2157	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335943	\N	\N
2158	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335944	\N	\N
2159	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335946	\N	\N
2160	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335947	\N	\N
2161	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335948	\N	\N
2162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33595	\N	\N
2163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335951	\N	\N
2164	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335952	\N	\N
2165	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335954	\N	\N
2166	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335955	\N	\N
2167	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335956	\N	\N
2168	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335958	\N	\N
2169	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335959	\N	\N
2170	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33596	\N	\N
2171	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335962	\N	\N
2172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335963	\N	\N
2173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335964	\N	\N
2174	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335966	\N	\N
2175	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335967	\N	\N
2176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335969	\N	\N
2177	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33597	\N	\N
2178	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335971	\N	\N
2179	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.335973	\N	\N
2180	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335974	\N	\N
2181	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335975	\N	\N
2182	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335977	\N	\N
2183	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335978	\N	\N
2184	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335979	\N	\N
2185	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335981	\N	\N
2186	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335982	\N	\N
2187	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335983	\N	\N
2188	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.335985	\N	\N
2189	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.335986	\N	\N
2190	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:24:31.335987	\N	\N
2191	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:24:31.335989	\N	\N
2192	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:24:31.33599	\N	\N
2193	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:24:31.335991	\N	\N
2194	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:24:31.335993	\N	\N
2195	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:24:31.335994	\N	\N
2196	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:24:31.335996	\N	\N
2197	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.335997	\N	\N
2198	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.335998	\N	\N
2199	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336	\N	\N
2200	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336002	\N	\N
2201	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336004	\N	\N
2202	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336005	\N	\N
2203	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336006	\N	\N
2204	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336008	\N	\N
2205	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336009	\N	\N
2206	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33601	\N	\N
2207	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336012	\N	\N
146	ddsdf	test1	2015	article	draft	\N	\N	2025-03-02 14:40:29.017248	\N	\N
2208	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336013	\N	\N
2209	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336015	\N	\N
2210	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336016	\N	\N
2211	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336017	\N	\N
2212	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336019	\N	\N
2213	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33602	\N	\N
2214	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336021	\N	\N
2215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336023	\N	\N
2216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336024	\N	\N
2217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336025	\N	\N
2218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336027	\N	\N
2219	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336028	\N	\N
2220	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336029	\N	\N
2221	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336031	\N	\N
2222	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336032	\N	\N
2223	ddsdf	test1ы	2015	article	draft	\N	16	2025-02-25 03:24:31.336034	\N	\N
2224	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336035	\N	\N
2225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336036	\N	\N
2226	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336038	\N	\N
2227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336039	\N	\N
2228	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33604	\N	\N
2229	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336042	\N	\N
2230	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336043	\N	\N
2231	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336044	\N	\N
2232	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.336046	\N	\N
2233	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336047	\N	\N
2234	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336048	\N	\N
2235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33605	\N	\N
2236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336051	\N	\N
2237	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336052	\N	\N
2238	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336054	\N	\N
2239	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336055	\N	\N
2240	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336057	\N	\N
2241	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336058	\N	\N
2242	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336059	\N	\N
2243	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336061	\N	\N
2244	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336062	\N	\N
2245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336063	\N	\N
2246	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336065	\N	\N
2247	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336066	\N	\N
2248	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336067	\N	\N
2249	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336069	\N	\N
2250	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.33607	\N	\N
2251	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336071	\N	\N
2252	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336073	\N	\N
2253	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336074	\N	\N
2254	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336075	\N	\N
2255	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336077	\N	\N
2256	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336078	\N	\N
2257	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336079	\N	\N
2258	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336081	\N	\N
2259	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336082	\N	\N
2260	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336084	\N	\N
2261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336085	\N	\N
2262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336086	\N	\N
2263	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336088	\N	\N
2264	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336089	\N	\N
2265	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33609	\N	\N
2266	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336092	\N	\N
2267	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336093	\N	\N
2268	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.336094	\N	\N
2269	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.336096	\N	\N
2270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336097	\N	\N
2271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336098	\N	\N
2272	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.3361	\N	\N
2273	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336101	\N	\N
2274	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336102	\N	\N
2275	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336104	\N	\N
2276	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336105	\N	\N
2277	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:24:31.336106	\N	\N
2278	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:24:31.336108	\N	\N
2279	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:24:31.336109	\N	\N
2280	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:24:31.33611	\N	\N
2281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336112	\N	\N
2282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336113	\N	\N
2283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336115	\N	\N
2284	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336116	\N	\N
2285	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	draft	\N	16	2025-02-25 03:24:31.336119	\N	\N
2286	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.33612	\N	\N
2287	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:24:31.336121	\N	\N
3191	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142015	\N	\N
2288	Sham	test2	2013	article	draft	\N	16	2025-02-25 03:46:41.069738	\N	\N
2297	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.488884	\N	\N
2298	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.488888	\N	\N
2299	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.48889	\N	\N
2300	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.488892	\N	\N
2301	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.488894	\N	\N
2302	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488895	\N	\N
2303	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488896	\N	\N
2304	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488898	\N	\N
2305	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488899	\N	\N
2306	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488901	\N	\N
2307	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488902	\N	\N
2308	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488903	\N	\N
2309	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488905	\N	\N
2310	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488906	\N	\N
2311	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488908	\N	\N
2312	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488909	\N	\N
2313	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48891	\N	\N
2314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488912	\N	\N
2315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488913	\N	\N
2316	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488914	\N	\N
2317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488916	\N	\N
2318	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488917	\N	\N
2319	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488918	\N	\N
2320	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48892	\N	\N
2321	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488921	\N	\N
2322	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488923	\N	\N
2323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488924	\N	\N
2324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488925	\N	\N
2325	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488927	\N	\N
2326	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488928	\N	\N
2327	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488929	\N	\N
2328	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488931	\N	\N
2329	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488932	\N	\N
2330	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488934	\N	\N
2331	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488935	\N	\N
2332	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488936	\N	\N
2333	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488938	\N	\N
2334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488939	\N	\N
2335	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48894	\N	\N
2336	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488942	\N	\N
2337	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.488943	\N	\N
2338	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488945	\N	\N
3192	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142019	\N	\N
2339	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488946	\N	\N
2340	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488947	\N	\N
2341	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488949	\N	\N
2342	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48895	\N	\N
2343	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488951	\N	\N
2344	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488953	\N	\N
2345	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488954	\N	\N
2346	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488956	\N	\N
2347	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488957	\N	\N
2348	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488958	\N	\N
2349	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48896	\N	\N
2350	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488961	\N	\N
2351	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488962	\N	\N
2352	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488964	\N	\N
2353	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488965	\N	\N
2354	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488967	\N	\N
2355	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488968	\N	\N
2356	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488969	\N	\N
2357	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488971	\N	\N
2358	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488972	\N	\N
2359	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488973	\N	\N
2360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488975	\N	\N
2361	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488976	\N	\N
2362	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488977	\N	\N
2363	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488979	\N	\N
2364	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48898	\N	\N
2365	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488982	\N	\N
2366	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488983	\N	\N
2367	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488984	\N	\N
2368	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488986	\N	\N
2369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488987	\N	\N
2370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488989	\N	\N
2371	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48899	\N	\N
2372	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.488991	\N	\N
2373	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.488993	\N	\N
2374	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.488994	\N	\N
2375	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488995	\N	\N
2376	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488997	\N	\N
2377	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.488998	\N	\N
2378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489	\N	\N
2379	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489001	\N	\N
2380	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489002	\N	\N
2381	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489004	\N	\N
2382	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489005	\N	\N
2383	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489006	\N	\N
2384	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489008	\N	\N
2385	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489009	\N	\N
2386	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48901	\N	\N
2387	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489012	\N	\N
2388	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489013	\N	\N
2389	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489015	\N	\N
2390	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489016	\N	\N
2391	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489017	\N	\N
2392	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489019	\N	\N
2393	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48902	\N	\N
2394	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489021	\N	\N
2395	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489023	\N	\N
2396	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489024	\N	\N
2397	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489026	\N	\N
2398	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489027	\N	\N
2399	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489028	\N	\N
2400	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48903	\N	\N
2401	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489031	\N	\N
2402	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489032	\N	\N
2403	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489034	\N	\N
2404	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489035	\N	\N
2405	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489037	\N	\N
4218	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183752	\N	f
2406	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489038	\N	\N
2407	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48904	\N	\N
2408	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:51:29.489041	\N	\N
2409	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489043	\N	\N
2410	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489044	\N	\N
2411	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489045	\N	\N
2412	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489047	\N	\N
2413	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489048	\N	\N
2414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48905	\N	\N
2415	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489051	\N	\N
2416	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489052	\N	\N
2417	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489054	\N	\N
2418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489055	\N	\N
2419	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489056	\N	\N
2420	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489058	\N	\N
2421	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489059	\N	\N
2422	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489061	\N	\N
2423	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489062	\N	\N
2424	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489063	\N	\N
2425	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489065	\N	\N
2426	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489066	\N	\N
2427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489068	\N	\N
2428	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489069	\N	\N
2429	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48907	\N	\N
2430	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489072	\N	\N
2431	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489073	\N	\N
2432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489075	\N	\N
2433	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489076	\N	\N
2434	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489077	\N	\N
2435	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489079	\N	\N
2436	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48908	\N	\N
2437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489082	\N	\N
2438	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489083	\N	\N
2439	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489084	\N	\N
2440	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489086	\N	\N
2441	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489087	\N	\N
2442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489088	\N	\N
2443	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48909	\N	\N
2444	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489091	\N	\N
2445	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489092	\N	\N
2446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489094	\N	\N
2447	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489095	\N	\N
2448	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489097	\N	\N
2449	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489098	\N	\N
2450	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489099	\N	\N
2451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489101	\N	\N
2452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489102	\N	\N
2453	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489103	\N	\N
2454	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489105	\N	\N
2455	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489106	\N	\N
2456	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489108	\N	\N
2457	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489109	\N	\N
2458	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48911	\N	\N
2459	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489112	\N	\N
2460	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489113	\N	\N
2461	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489114	\N	\N
2462	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489116	\N	\N
2463	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489117	\N	\N
2464	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489119	\N	\N
2465	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48912	\N	\N
2466	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489121	\N	\N
2467	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489123	\N	\N
2468	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489124	\N	\N
2469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489125	\N	\N
2470	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489127	\N	\N
2471	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489128	\N	\N
2472	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48913	\N	\N
4219	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183753	\N	f
2473	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489131	\N	\N
2474	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489132	\N	\N
2475	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489134	\N	\N
2476	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489135	\N	\N
2477	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489137	\N	\N
2478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489138	\N	\N
2479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489139	\N	\N
2480	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489141	\N	\N
2481	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489142	\N	\N
2482	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489143	\N	\N
2483	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489145	\N	\N
2484	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489146	\N	\N
2485	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489147	\N	\N
2486	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489149	\N	\N
2487	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48915	\N	\N
2488	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489152	\N	\N
2489	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489153	\N	\N
2490	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489155	\N	\N
2491	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489156	\N	\N
2492	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489157	\N	\N
2493	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:51:29.489159	\N	\N
2494	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:51:29.48916	\N	\N
2495	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489161	\N	\N
2496	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489163	\N	\N
2497	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489164	\N	\N
2498	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489166	\N	\N
2499	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489167	\N	\N
2500	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489168	\N	\N
2501	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48917	\N	\N
2502	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489171	\N	\N
2503	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489172	\N	\N
2504	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489174	\N	\N
2505	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489175	\N	\N
2506	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489177	\N	\N
2507	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489178	\N	\N
2508	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489179	\N	\N
2509	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489181	\N	\N
2510	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489182	\N	\N
2511	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489183	\N	\N
2512	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489185	\N	\N
2513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489186	\N	\N
2514	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489188	\N	\N
2515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489189	\N	\N
2516	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48919	\N	\N
2517	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489192	\N	\N
2518	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489193	\N	\N
2519	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489194	\N	\N
2520	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489196	\N	\N
2521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489197	\N	\N
2522	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489199	\N	\N
2523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.4892	\N	\N
2524	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489201	\N	\N
2525	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489203	\N	\N
2526	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489204	\N	\N
2527	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489206	\N	\N
2528	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489207	\N	\N
2529	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489208	\N	\N
2530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48921	\N	\N
2531	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489211	\N	\N
2532	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489212	\N	\N
2533	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489214	\N	\N
2534	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489215	\N	\N
2535	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489217	\N	\N
2536	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489218	\N	\N
2537	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489219	\N	\N
2538	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489221	\N	\N
2539	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489222	\N	\N
2540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489224	\N	\N
2541	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489225	\N	\N
2542	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489226	\N	\N
2543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489228	\N	\N
2544	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489229	\N	\N
2545	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489231	\N	\N
2546	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489232	\N	\N
2547	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489233	\N	\N
2548	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489235	\N	\N
2549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489236	\N	\N
2550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489237	\N	\N
2551	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489239	\N	\N
2552	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48924	\N	\N
2553	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489242	\N	\N
2554	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489243	\N	\N
2555	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489244	\N	\N
2556	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489246	\N	\N
2557	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489247	\N	\N
2558	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489248	\N	\N
2559	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48925	\N	\N
2560	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489251	\N	\N
2561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489253	\N	\N
2562	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489254	\N	\N
2563	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489255	\N	\N
2564	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489257	\N	\N
2565	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489258	\N	\N
2566	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489259	\N	\N
2567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489261	\N	\N
2568	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489262	\N	\N
2569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489264	\N	\N
2570	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489265	\N	\N
2571	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489266	\N	\N
2572	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489268	\N	\N
2573	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489269	\N	\N
2574	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48927	\N	\N
2575	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489272	\N	\N
2576	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489273	\N	\N
2577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489275	\N	\N
2578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489276	\N	\N
2579	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489277	\N	\N
2580	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489279	\N	\N
2581	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.48928	\N	\N
2582	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489281	\N	\N
2583	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489283	\N	\N
2584	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489284	\N	\N
2585	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489286	\N	\N
2586	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489287	\N	\N
2587	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489288	\N	\N
2588	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48929	\N	\N
2589	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489291	\N	\N
2590	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489292	\N	\N
2591	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489294	\N	\N
2592	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489295	\N	\N
2593	555	555	1999	article	draft	\N	16	2025-02-25 03:51:29.489296	\N	\N
2594	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489298	\N	\N
2595	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489299	\N	\N
2596	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489301	\N	\N
2597	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489302	\N	\N
2598	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489303	\N	\N
2599	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489305	\N	\N
2600	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489306	\N	\N
2601	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489307	\N	\N
2602	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489309	\N	\N
2603	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48931	\N	\N
2604	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489312	\N	\N
2605	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489313	\N	\N
2606	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489314	\N	\N
2607	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489316	\N	\N
2608	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489317	\N	\N
2609	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489318	\N	\N
2610	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48932	\N	\N
2611	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489321	\N	\N
2612	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489323	\N	\N
2613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489324	\N	\N
2614	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489325	\N	\N
2615	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489327	\N	\N
2616	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489328	\N	\N
2617	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489329	\N	\N
2618	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489331	\N	\N
2619	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489332	\N	\N
2620	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489334	\N	\N
2621	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489335	\N	\N
2622	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489336	\N	\N
2623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489338	\N	\N
2624	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489339	\N	\N
2625	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48934	\N	\N
2626	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489342	\N	\N
2627	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489343	\N	\N
2628	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489345	\N	\N
2629	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489346	\N	\N
2630	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489347	\N	\N
2631	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489349	\N	\N
2632	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48935	\N	\N
2633	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489351	\N	\N
2634	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489353	\N	\N
2635	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489354	\N	\N
2636	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489356	\N	\N
2637	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489357	\N	\N
2638	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489358	\N	\N
2639	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48936	\N	\N
2640	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489361	\N	\N
2641	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489362	\N	\N
2642	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489364	\N	\N
2643	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489365	\N	\N
2644	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489366	\N	\N
2645	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489368	\N	\N
2646	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489369	\N	\N
2647	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489371	\N	\N
2648	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489372	\N	\N
2649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489373	\N	\N
2650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489375	\N	\N
2651	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489376	\N	\N
2652	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489377	\N	\N
2653	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489379	\N	\N
2654	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48938	\N	\N
2655	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489382	\N	\N
2656	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489383	\N	\N
2657	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489384	\N	\N
2658	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489386	\N	\N
2659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489387	\N	\N
2660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489388	\N	\N
2661	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48939	\N	\N
2662	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489391	\N	\N
2663	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489392	\N	\N
2664	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489394	\N	\N
2665	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489395	\N	\N
2666	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489397	\N	\N
2667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489398	\N	\N
2668	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489399	\N	\N
2669	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489401	\N	\N
2670	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489402	\N	\N
2671	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489403	\N	\N
2672	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489405	\N	\N
2673	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489406	\N	\N
2674	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489408	\N	\N
2675	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489409	\N	\N
2676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48941	\N	\N
2677	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489412	\N	\N
2678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489413	\N	\N
2679	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489414	\N	\N
2680	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489416	\N	\N
2681	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489417	\N	\N
2682	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489418	\N	\N
2683	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48942	\N	\N
2684	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489421	\N	\N
2685	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489423	\N	\N
2686	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489424	\N	\N
2687	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489425	\N	\N
2688	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489427	\N	\N
2689	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489428	\N	\N
2690	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489429	\N	\N
2691	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489431	\N	\N
2692	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489432	\N	\N
2693	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489434	\N	\N
2694	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489435	\N	\N
2695	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489436	\N	\N
2696	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489438	\N	\N
2697	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489439	\N	\N
2698	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48944	\N	\N
2699	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489442	\N	\N
2700	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489443	\N	\N
2701	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489444	\N	\N
2702	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489446	\N	\N
2703	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489447	\N	\N
2704	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489449	\N	\N
2705	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:51:29.48945	\N	\N
2706	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489451	\N	\N
2707	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489453	\N	\N
2708	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489454	\N	\N
2709	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489455	\N	\N
2710	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489457	\N	\N
2711	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489458	\N	\N
2712	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48946	\N	\N
2713	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489461	\N	\N
2714	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489462	\N	\N
2715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489464	\N	\N
2716	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489465	\N	\N
2717	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489466	\N	\N
2718	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489468	\N	\N
2719	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489469	\N	\N
2720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48947	\N	\N
2721	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489472	\N	\N
2722	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489473	\N	\N
2723	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489475	\N	\N
2724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489476	\N	\N
2725	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489477	\N	\N
2726	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489479	\N	\N
2727	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48948	\N	\N
2728	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489481	\N	\N
2729	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489483	\N	\N
2730	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489484	\N	\N
2731	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489486	\N	\N
2732	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489487	\N	\N
2733	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489488	\N	\N
2734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48949	\N	\N
2735	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489491	\N	\N
2736	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489492	\N	\N
2737	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489494	\N	\N
2738	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489495	\N	\N
2739	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489496	\N	\N
2740	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489498	\N	\N
2741	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489499	\N	\N
2742	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489501	\N	\N
2743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489502	\N	\N
2744	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489503	\N	\N
2745	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489505	\N	\N
2746	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489506	\N	\N
2747	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489507	\N	\N
2748	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489509	\N	\N
2749	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48951	\N	\N
2750	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489512	\N	\N
2751	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489513	\N	\N
2752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489514	\N	\N
2753	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489516	\N	\N
2754	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489517	\N	\N
2755	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489518	\N	\N
2756	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48952	\N	\N
2757	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489521	\N	\N
2758	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489522	\N	\N
2759	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489524	\N	\N
2760	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489525	\N	\N
2761	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489527	\N	\N
2762	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489528	\N	\N
2763	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489529	\N	\N
2764	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489531	\N	\N
2765	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489532	\N	\N
2766	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489533	\N	\N
2767	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489535	\N	\N
2768	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489536	\N	\N
2769	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489538	\N	\N
2770	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489539	\N	\N
2771	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48954	\N	\N
2772	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489542	\N	\N
2773	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489543	\N	\N
2774	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489544	\N	\N
2775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489546	\N	\N
2776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489547	\N	\N
2777	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489548	\N	\N
2778	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.48955	\N	\N
2779	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489551	\N	\N
2780	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489553	\N	\N
2781	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489554	\N	\N
2782	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489556	\N	\N
2783	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489557	\N	\N
2784	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489558	\N	\N
2785	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48956	\N	\N
2786	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489561	\N	\N
2787	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489562	\N	\N
2788	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489564	\N	\N
2789	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489565	\N	\N
2790	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:51:29.489567	\N	\N
2791	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:51:29.489568	\N	\N
2792	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489569	\N	\N
2793	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489571	\N	\N
2794	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489572	\N	\N
2795	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489573	\N	\N
2796	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489575	\N	\N
2797	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489576	\N	\N
2798	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489578	\N	\N
2799	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489579	\N	\N
2800	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48958	\N	\N
2801	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489582	\N	\N
2802	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489583	\N	\N
2803	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489584	\N	\N
2804	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489586	\N	\N
2805	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489587	\N	\N
2806	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489588	\N	\N
2807	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48959	\N	\N
2808	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489591	\N	\N
2809	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489593	\N	\N
2810	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489594	\N	\N
2811	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489595	\N	\N
2812	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489597	\N	\N
2813	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489598	\N	\N
2814	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489599	\N	\N
2815	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489601	\N	\N
2816	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489602	\N	\N
2817	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489604	\N	\N
2818	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489605	\N	\N
2819	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489606	\N	\N
2820	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489608	\N	\N
2821	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489609	\N	\N
2822	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48961	\N	\N
2823	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489612	\N	\N
2824	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489613	\N	\N
2825	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489614	\N	\N
2826	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489616	\N	\N
2827	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489617	\N	\N
2828	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489619	\N	\N
2829	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48962	\N	\N
2830	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489621	\N	\N
2831	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489623	\N	\N
2832	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489624	\N	\N
2833	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489625	\N	\N
2834	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489627	\N	\N
2835	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489628	\N	\N
2836	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48963	\N	\N
2837	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489631	\N	\N
2838	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489632	\N	\N
2839	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489634	\N	\N
2840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489635	\N	\N
2841	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489636	\N	\N
2842	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489638	\N	\N
2843	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489639	\N	\N
2844	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48964	\N	\N
2845	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489642	\N	\N
2846	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489643	\N	\N
2847	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489645	\N	\N
2848	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489646	\N	\N
2849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489647	\N	\N
2850	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489649	\N	\N
2851	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48965	\N	\N
2852	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489651	\N	\N
2853	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489653	\N	\N
2854	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489654	\N	\N
2855	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489656	\N	\N
2856	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489657	\N	\N
2857	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489658	\N	\N
2858	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48966	\N	\N
2859	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489661	\N	\N
2860	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489662	\N	\N
2861	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489664	\N	\N
2862	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489665	\N	\N
2863	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489667	\N	\N
2864	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489668	\N	\N
2865	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48967	\N	\N
2866	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489671	\N	\N
2867	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489672	\N	\N
2868	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489674	\N	\N
2869	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489675	\N	\N
2870	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489676	\N	\N
2871	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489678	\N	\N
2872	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489679	\N	\N
2873	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489681	\N	\N
2874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489682	\N	\N
2875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489683	\N	\N
2876	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489685	\N	\N
2877	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489686	\N	\N
2878	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489687	\N	\N
2879	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489689	\N	\N
2881	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489692	\N	\N
2882	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489693	\N	\N
2883	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489694	\N	\N
2884	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489696	\N	\N
2885	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489697	\N	\N
2886	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489698	\N	\N
2887	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.4897	\N	\N
2888	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489701	\N	\N
2889	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489702	\N	\N
2890	555	555	1999	article	draft	\N	16	2025-02-25 03:51:29.489704	\N	\N
2891	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489705	\N	\N
2892	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489707	\N	\N
2893	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489708	\N	\N
2894	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489709	\N	\N
2895	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489711	\N	\N
2896	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489712	\N	\N
2897	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489713	\N	\N
2898	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489715	\N	\N
2899	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489716	\N	\N
2900	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489718	\N	\N
2901	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489719	\N	\N
2902	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48972	\N	\N
2903	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489722	\N	\N
2904	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489723	\N	\N
2905	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489724	\N	\N
2906	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489726	\N	\N
2907	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489727	\N	\N
2908	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489729	\N	\N
2909	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48973	\N	\N
2910	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489731	\N	\N
2911	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489733	\N	\N
2912	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489734	\N	\N
2913	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489735	\N	\N
2914	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489737	\N	\N
2915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489738	\N	\N
2916	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489739	\N	\N
2917	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489741	\N	\N
2918	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489742	\N	\N
2919	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489744	\N	\N
2920	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489745	\N	\N
2921	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489746	\N	\N
2922	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489748	\N	\N
2923	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489749	\N	\N
2924	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48975	\N	\N
2925	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489752	\N	\N
2926	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489753	\N	\N
2927	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489755	\N	\N
2928	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489756	\N	\N
2929	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489757	\N	\N
2930	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489759	\N	\N
2931	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.48976	\N	\N
2932	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489761	\N	\N
2933	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489763	\N	\N
2934	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489764	\N	\N
2935	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489765	\N	\N
2936	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489767	\N	\N
2937	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489768	\N	\N
2938	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48977	\N	\N
2939	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489771	\N	\N
2940	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489772	\N	\N
2941	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489774	\N	\N
2942	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489775	\N	\N
2943	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489776	\N	\N
2944	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489778	\N	\N
2945	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489779	\N	\N
2946	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489781	\N	\N
2947	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489782	\N	\N
2948	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489783	\N	\N
2949	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489785	\N	\N
2950	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489786	\N	\N
2951	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489787	\N	\N
2952	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489789	\N	\N
2953	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48979	\N	\N
2954	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489792	\N	\N
2955	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489793	\N	\N
2956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489794	\N	\N
2957	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489796	\N	\N
2958	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489797	\N	\N
2959	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489798	\N	\N
2960	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.4898	\N	\N
2961	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489801	\N	\N
2962	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489803	\N	\N
2963	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489804	\N	\N
2964	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489805	\N	\N
2965	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489807	\N	\N
2966	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489808	\N	\N
2967	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489809	\N	\N
2968	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489811	\N	\N
2969	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489812	\N	\N
2970	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489814	\N	\N
2971	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489815	\N	\N
2972	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489816	\N	\N
2973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489818	\N	\N
2974	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489819	\N	\N
2975	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48982	\N	\N
2976	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489822	\N	\N
2977	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489823	\N	\N
2978	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489824	\N	\N
2979	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489826	\N	\N
2980	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489827	\N	\N
2981	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48983	\N	\N
2982	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489832	\N	\N
2983	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489833	\N	\N
2984	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489834	\N	\N
2985	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489836	\N	\N
2986	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489837	\N	\N
2987	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489839	\N	\N
2988	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.48984	\N	\N
2989	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489841	\N	\N
2990	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.489843	\N	\N
2991	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489844	\N	\N
2992	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489845	\N	\N
2993	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489847	\N	\N
2994	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489848	\N	\N
2995	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48985	\N	\N
2996	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489851	\N	\N
2997	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489852	\N	\N
2998	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489854	\N	\N
2999	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489855	\N	\N
3000	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489856	\N	\N
3001	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489858	\N	\N
3002	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 03:51:29.489859	\N	\N
3003	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489861	\N	\N
3004	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489862	\N	\N
3005	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489863	\N	\N
3006	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489865	\N	\N
3007	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489866	\N	\N
3008	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489867	\N	\N
3009	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489869	\N	\N
3010	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.48987	\N	\N
3011	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489871	\N	\N
3012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489873	\N	\N
3013	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489874	\N	\N
3014	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489876	\N	\N
3015	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489877	\N	\N
3016	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489878	\N	\N
3017	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48988	\N	\N
3018	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489881	\N	\N
3019	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489883	\N	\N
3020	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489884	\N	\N
3021	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489885	\N	\N
3022	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489887	\N	\N
3023	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489888	\N	\N
3024	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489889	\N	\N
3025	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489891	\N	\N
3026	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489892	\N	\N
3027	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489893	\N	\N
3028	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489895	\N	\N
3029	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489896	\N	\N
3030	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489898	\N	\N
3031	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489899	\N	\N
3032	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.4899	\N	\N
3033	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489902	\N	\N
3034	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489903	\N	\N
3035	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489905	\N	\N
3036	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489906	\N	\N
3037	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489907	\N	\N
3038	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489909	\N	\N
3039	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.48991	\N	\N
3040	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489911	\N	\N
3041	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489913	\N	\N
3042	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489914	\N	\N
3043	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489915	\N	\N
3044	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489917	\N	\N
3045	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489918	\N	\N
3046	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48992	\N	\N
3047	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489921	\N	\N
3048	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489922	\N	\N
3049	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489924	\N	\N
3050	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489925	\N	\N
3051	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489926	\N	\N
3052	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489928	\N	\N
3053	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489929	\N	\N
3054	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489931	\N	\N
3055	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489932	\N	\N
3056	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489933	\N	\N
3057	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489935	\N	\N
3058	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489936	\N	\N
3059	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489937	\N	\N
3060	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489939	\N	\N
3061	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48994	\N	\N
3062	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489942	\N	\N
3063	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489943	\N	\N
3064	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489944	\N	\N
3065	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489946	\N	\N
3066	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489947	\N	\N
3067	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489948	\N	\N
3068	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48995	\N	\N
3069	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489951	\N	\N
3070	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489953	\N	\N
3071	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489954	\N	\N
3072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489955	\N	\N
3073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489957	\N	\N
3074	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489958	\N	\N
3075	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489959	\N	\N
3076	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.489961	\N	\N
3077	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489962	\N	\N
3078	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489964	\N	\N
3079	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489965	\N	\N
3080	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489966	\N	\N
3081	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489968	\N	\N
3082	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489969	\N	\N
3083	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48997	\N	\N
3084	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489972	\N	\N
3085	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.489973	\N	\N
3086	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.489974	\N	\N
3087	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 03:51:29.489976	\N	\N
3088	авп	ыва	1992	article	draft	\N	16	2025-02-25 03:51:29.489977	\N	\N
3089	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 03:51:29.489979	\N	\N
3090	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 03:51:29.48998	\N	\N
3091	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 03:51:29.489981	\N	\N
3092	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 03:51:29.489983	\N	\N
3093	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 03:51:29.489984	\N	\N
3094	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489985	\N	\N
3095	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489987	\N	\N
3096	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489988	\N	\N
3097	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.48999	\N	\N
3098	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489991	\N	\N
3099	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489992	\N	\N
3100	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489994	\N	\N
3101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489995	\N	\N
3102	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.489996	\N	\N
3103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489998	\N	\N
3104	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.489999	\N	\N
3105	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490001	\N	\N
3106	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490002	\N	\N
3107	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490003	\N	\N
3108	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490005	\N	\N
3109	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490006	\N	\N
3110	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490007	\N	\N
3111	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490009	\N	\N
3112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.49001	\N	\N
3113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490011	\N	\N
3114	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490013	\N	\N
3115	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490014	\N	\N
3116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490016	\N	\N
3117	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490017	\N	\N
3118	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490018	\N	\N
3119	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.49002	\N	\N
3120	ddsdf	test1ы	2015	article	draft	\N	16	2025-02-25 03:51:29.490021	\N	\N
3121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490023	\N	\N
3122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490024	\N	\N
3123	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490025	\N	\N
3124	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490027	\N	\N
3125	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490028	\N	\N
3126	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490029	\N	\N
3127	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490031	\N	\N
3128	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490032	\N	\N
3129	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.490033	\N	\N
3130	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490035	\N	\N
3131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490036	\N	\N
3132	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490038	\N	\N
3133	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490039	\N	\N
3134	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.49004	\N	\N
3135	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490042	\N	\N
3136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490043	\N	\N
3137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490044	\N	\N
3138	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490046	\N	\N
3139	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490047	\N	\N
3140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490049	\N	\N
3141	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.49005	\N	\N
3142	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490051	\N	\N
3143	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490053	\N	\N
3144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490054	\N	\N
3145	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490055	\N	\N
3146	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490057	\N	\N
3147	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490058	\N	\N
3148	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.49006	\N	\N
3149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490061	\N	\N
3150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490062	\N	\N
3151	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490064	\N	\N
3152	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490065	\N	\N
3153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490066	\N	\N
3154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490068	\N	\N
3155	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490069	\N	\N
3156	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.49007	\N	\N
3157	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490072	\N	\N
3158	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490073	\N	\N
3159	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490075	\N	\N
3160	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490076	\N	\N
3161	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490077	\N	\N
3162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490079	\N	\N
3163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.49008	\N	\N
3164	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490081	\N	\N
3165	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.490083	\N	\N
3166	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490084	\N	\N
3167	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490085	\N	\N
3168	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490087	\N	\N
3169	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490088	\N	\N
3170	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.49009	\N	\N
3171	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490091	\N	\N
3172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490092	\N	\N
3173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490094	\N	\N
3174	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.490095	\N	\N
3175	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.490096	\N	\N
3176	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 03:51:29.490098	\N	\N
3177	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 03:51:29.490099	\N	\N
3178	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490101	\N	\N
3179	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490102	\N	\N
3180	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490103	\N	\N
3181	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490105	\N	\N
3182	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	draft	\N	16	2025-02-25 03:51:29.490106	\N	\N
3183	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490107	\N	\N
3184	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 03:51:29.490109	\N	\N
3185	Sham	test2	2010	article	draft	\N	16	2025-02-25 03:51:29.49011	\N	\N
3186	длолд111111111111111111111	ирмтми	2015	article	draft	\N	16	2025-02-25 03:51:29.490112	\N	\N
3187	555	555ы	1999	article	draft	\N	16	2025-02-25 03:51:29.490113	\N	\N
407	авп	ыва	1992	article	draft	/uploads/Spasi_i_Sokhrani.docx	16	2025-02-24 11:00:53.544476	\N	\N
3193	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142021	\N	\N
3194	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142024	\N	\N
3195	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142025	\N	\N
3196	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142027	\N	\N
3197	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142028	\N	\N
3198	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14203	\N	\N
3199	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142031	\N	\N
3200	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142032	\N	\N
3201	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142034	\N	\N
3202	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142035	\N	\N
3203	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142037	\N	\N
3204	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142038	\N	\N
3205	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142039	\N	\N
3206	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14204	\N	\N
3207	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142042	\N	\N
3208	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142043	\N	\N
3209	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142045	\N	\N
3210	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142046	\N	\N
3211	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142047	\N	\N
3212	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142048	\N	\N
3213	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14205	\N	\N
3214	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142051	\N	\N
3215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142052	\N	\N
3216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142054	\N	\N
3217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142055	\N	\N
3218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142057	\N	\N
3219	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142058	\N	\N
3220	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14206	\N	\N
3221	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142061	\N	\N
3222	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142062	\N	\N
506	555	555	1999	article	draft	/uploads/Spasi_i_Sokhrani.docx	16	2025-02-24 11:07:29.22586	\N	\N
3229	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142072	\N	\N
3230	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142073	\N	\N
3231	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142074	\N	\N
3232	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142076	\N	\N
3233	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142077	\N	\N
3234	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142078	\N	\N
3235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14208	\N	\N
3236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142081	\N	\N
3237	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142082	\N	\N
3238	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142084	\N	\N
3239	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142085	\N	\N
3240	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142086	\N	\N
3241	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142088	\N	\N
3242	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142089	\N	\N
3243	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14209	\N	\N
3244	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142092	\N	\N
3245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142093	\N	\N
3246	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142094	\N	\N
3247	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142096	\N	\N
3248	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142097	\N	\N
3249	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142099	\N	\N
3250	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.1421	\N	\N
3251	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142101	\N	\N
3252	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142103	\N	\N
3253	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142104	\N	\N
3254	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142105	\N	\N
3255	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142107	\N	\N
3256	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142108	\N	\N
3257	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142109	\N	\N
3258	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14211	\N	\N
3259	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142112	\N	\N
3260	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142113	\N	\N
3261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142115	\N	\N
3262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142116	\N	\N
3263	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142117	\N	\N
3264	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142119	\N	\N
3265	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14212	\N	\N
3266	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142121	\N	\N
3267	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142123	\N	\N
3268	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142124	\N	\N
3269	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142125	\N	\N
3270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142126	\N	\N
3271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142128	\N	\N
3272	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142129	\N	\N
3273	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14213	\N	\N
3274	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142132	\N	\N
3275	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142133	\N	\N
3276	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142134	\N	\N
3277	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142136	\N	\N
3278	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142137	\N	\N
3279	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142138	\N	\N
3280	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14214	\N	\N
3281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142141	\N	\N
3282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142142	\N	\N
3283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142144	\N	\N
3284	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142145	\N	\N
3285	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142146	\N	\N
3286	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142147	\N	\N
3287	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142149	\N	\N
3288	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14215	\N	\N
3289	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142151	\N	\N
3290	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142153	\N	\N
3291	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142154	\N	\N
3292	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142155	\N	\N
3293	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142157	\N	\N
3294	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142158	\N	\N
3295	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142159	\N	\N
3296	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142161	\N	\N
4472	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.184094	\N	f
3297	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142162	\N	\N
3298	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142163	\N	\N
3299	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142164	\N	\N
3300	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142166	\N	\N
3301	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142167	\N	\N
3302	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 23:54:36.142168	\N	\N
3303	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14217	\N	\N
3304	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142171	\N	\N
3305	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142172	\N	\N
3306	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142174	\N	\N
3307	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142175	\N	\N
3308	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142177	\N	\N
3309	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142178	\N	\N
3310	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14218	\N	\N
3311	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142181	\N	\N
3312	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142182	\N	\N
3313	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142183	\N	\N
3314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142185	\N	\N
3315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142186	\N	\N
3316	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142188	\N	\N
3317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142189	\N	\N
3318	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14219	\N	\N
3319	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142192	\N	\N
3320	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142193	\N	\N
3321	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142194	\N	\N
3322	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142196	\N	\N
3323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142197	\N	\N
3324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142198	\N	\N
3325	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.1422	\N	\N
3326	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142201	\N	\N
3327	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142202	\N	\N
3328	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142204	\N	\N
3329	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142205	\N	\N
3330	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142206	\N	\N
3331	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142207	\N	\N
3332	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142209	\N	\N
3333	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14221	\N	\N
3334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142211	\N	\N
3335	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142213	\N	\N
3336	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142214	\N	\N
3337	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142215	\N	\N
3338	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142217	\N	\N
3339	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142218	\N	\N
3340	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142219	\N	\N
3341	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142221	\N	\N
3342	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142222	\N	\N
3343	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142223	\N	\N
3344	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142225	\N	\N
3345	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142226	\N	\N
3346	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142227	\N	\N
3347	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142229	\N	\N
3348	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14223	\N	\N
3349	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142231	\N	\N
3350	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142233	\N	\N
3351	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142234	\N	\N
3352	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142235	\N	\N
3353	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142237	\N	\N
3354	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142238	\N	\N
3355	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142239	\N	\N
3356	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142241	\N	\N
3357	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142242	\N	\N
3358	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142243	\N	\N
3359	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142245	\N	\N
3360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142246	\N	\N
3361	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142247	\N	\N
3362	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142249	\N	\N
4473	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184095	\N	f
3363	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14225	\N	\N
3364	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142251	\N	\N
3365	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142253	\N	\N
3366	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142254	\N	\N
3367	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142255	\N	\N
3368	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142257	\N	\N
3369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142258	\N	\N
3370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142259	\N	\N
3371	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142261	\N	\N
3372	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142262	\N	\N
3373	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142263	\N	\N
3374	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142264	\N	\N
3375	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142266	\N	\N
3376	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142267	\N	\N
3377	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142269	\N	\N
3378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14227	\N	\N
3379	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142271	\N	\N
3380	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142272	\N	\N
3381	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142274	\N	\N
3382	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142275	\N	\N
3383	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142276	\N	\N
3384	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142278	\N	\N
3385	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142279	\N	\N
3386	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14228	\N	\N
3387	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 23:54:36.142282	\N	\N
3388	авп	ыва	1992	article	draft	\N	16	2025-02-25 23:54:36.142283	\N	\N
3389	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142284	\N	\N
3390	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142286	\N	\N
3391	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142287	\N	\N
3392	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142288	\N	\N
3393	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.14229	\N	\N
3394	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142291	\N	\N
3395	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142292	\N	\N
3396	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142294	\N	\N
3397	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142295	\N	\N
3398	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142296	\N	\N
3399	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142298	\N	\N
3400	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142299	\N	\N
3401	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.1423	\N	\N
3402	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142301	\N	\N
3403	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142303	\N	\N
3404	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142304	\N	\N
3405	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142306	\N	\N
3406	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142308	\N	\N
3407	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14231	\N	\N
3408	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142312	\N	\N
3409	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142313	\N	\N
3410	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142315	\N	\N
3411	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142316	\N	\N
3412	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142317	\N	\N
3413	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142319	\N	\N
3414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14232	\N	\N
3415	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142321	\N	\N
3416	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142322	\N	\N
3417	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142324	\N	\N
3418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142325	\N	\N
3419	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142326	\N	\N
3420	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142328	\N	\N
3421	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142329	\N	\N
3422	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14233	\N	\N
3423	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142332	\N	\N
3424	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142333	\N	\N
3425	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142334	\N	\N
3426	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142336	\N	\N
3427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142337	\N	\N
3428	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142338	\N	\N
3429	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14234	\N	\N
3430	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142341	\N	\N
3431	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142342	\N	\N
3432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142344	\N	\N
3433	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142345	\N	\N
3434	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142346	\N	\N
3435	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142347	\N	\N
3436	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142349	\N	\N
3437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14235	\N	\N
3438	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142352	\N	\N
3439	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142353	\N	\N
3440	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142354	\N	\N
3441	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142356	\N	\N
3442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142357	\N	\N
3443	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142358	\N	\N
3444	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14236	\N	\N
3445	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142361	\N	\N
3446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142362	\N	\N
3447	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142363	\N	\N
3448	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142365	\N	\N
3449	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142366	\N	\N
3450	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142367	\N	\N
3451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142369	\N	\N
3452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14237	\N	\N
3453	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142371	\N	\N
3454	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142373	\N	\N
3455	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142374	\N	\N
3456	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142375	\N	\N
3457	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142377	\N	\N
3458	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142378	\N	\N
3459	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142379	\N	\N
3460	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14238	\N	\N
3461	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142382	\N	\N
3462	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142383	\N	\N
3463	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142384	\N	\N
3464	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142386	\N	\N
3465	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142387	\N	\N
3466	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142388	\N	\N
3467	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14239	\N	\N
3468	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142391	\N	\N
3469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142392	\N	\N
3470	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142394	\N	\N
3471	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142395	\N	\N
3472	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142396	\N	\N
3473	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142398	\N	\N
3474	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142399	\N	\N
3475	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.1424	\N	\N
3476	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142401	\N	\N
3477	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142403	\N	\N
3478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142404	\N	\N
3479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142405	\N	\N
3480	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142407	\N	\N
3481	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142408	\N	\N
3482	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142409	\N	\N
3483	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142411	\N	\N
3484	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142412	\N	\N
3485	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142413	\N	\N
3486	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142415	\N	\N
3487	555	555	1999	article	draft	\N	16	2025-02-25 23:54:36.142416	\N	\N
3488	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142417	\N	\N
3489	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142419	\N	\N
3490	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.14242	\N	\N
3491	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142421	\N	\N
3492	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142423	\N	\N
3493	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142424	\N	\N
3494	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142425	\N	\N
3495	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142427	\N	\N
3496	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142428	\N	\N
3497	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142429	\N	\N
3498	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14243	\N	\N
3499	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142432	\N	\N
3500	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142433	\N	\N
3501	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142435	\N	\N
3502	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142438	\N	\N
3503	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14244	\N	\N
3504	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142441	\N	\N
3505	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142443	\N	\N
3506	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142444	\N	\N
3507	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142445	\N	\N
3508	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142447	\N	\N
3509	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142448	\N	\N
3510	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142449	\N	\N
3511	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14245	\N	\N
3512	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142452	\N	\N
3513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142453	\N	\N
3514	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142454	\N	\N
3515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142456	\N	\N
3516	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142457	\N	\N
3517	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142458	\N	\N
3518	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14246	\N	\N
3519	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142461	\N	\N
3520	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142462	\N	\N
3521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142464	\N	\N
3522	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142465	\N	\N
3523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142467	\N	\N
3524	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142468	\N	\N
3525	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142469	\N	\N
3526	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142471	\N	\N
3527	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142472	\N	\N
3528	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142473	\N	\N
3529	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142475	\N	\N
3530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142476	\N	\N
3531	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142477	\N	\N
3532	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142478	\N	\N
3533	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14248	\N	\N
3534	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142481	\N	\N
3535	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142482	\N	\N
3536	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142484	\N	\N
3537	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142485	\N	\N
3538	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142486	\N	\N
3539	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142488	\N	\N
3540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142489	\N	\N
3541	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14249	\N	\N
3542	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142492	\N	\N
3543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142493	\N	\N
3544	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142494	\N	\N
3545	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142495	\N	\N
3546	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142497	\N	\N
3547	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142498	\N	\N
3548	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142499	\N	\N
3549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142501	\N	\N
3550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142502	\N	\N
3551	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142503	\N	\N
3552	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142505	\N	\N
3553	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142506	\N	\N
3554	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142507	\N	\N
3555	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142508	\N	\N
3556	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14251	\N	\N
3557	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142511	\N	\N
3558	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142512	\N	\N
3559	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142514	\N	\N
3560	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142515	\N	\N
3561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142516	\N	\N
3562	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142518	\N	\N
3563	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142519	\N	\N
3564	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14252	\N	\N
3565	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142522	\N	\N
3566	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142523	\N	\N
4917	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184684	\N	f
3567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142524	\N	\N
3568	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142526	\N	\N
3569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142527	\N	\N
3570	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142528	\N	\N
3571	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142529	\N	\N
3572	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142531	\N	\N
3573	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142532	\N	\N
3574	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142533	\N	\N
3575	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142535	\N	\N
3576	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142536	\N	\N
3577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142537	\N	\N
3578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142539	\N	\N
3579	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14254	\N	\N
3580	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142541	\N	\N
3581	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142543	\N	\N
3582	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142544	\N	\N
3583	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142545	\N	\N
3584	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142546	\N	\N
3585	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142548	\N	\N
3586	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142549	\N	\N
3587	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.14255	\N	\N
3588	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142552	\N	\N
3589	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142553	\N	\N
3590	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142554	\N	\N
3591	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142556	\N	\N
3592	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142557	\N	\N
3593	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142558	\N	\N
3594	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142559	\N	\N
3595	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142561	\N	\N
3596	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142562	\N	\N
3597	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142563	\N	\N
3598	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142565	\N	\N
3599	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 23:54:36.142566	\N	\N
3600	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142567	\N	\N
3601	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142569	\N	\N
3602	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14257	\N	\N
3603	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142571	\N	\N
3604	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142573	\N	\N
3605	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142574	\N	\N
3606	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142575	\N	\N
3607	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142577	\N	\N
3608	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142578	\N	\N
3609	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142579	\N	\N
3610	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142581	\N	\N
3611	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142582	\N	\N
3612	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142583	\N	\N
3613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142585	\N	\N
3614	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142586	\N	\N
3615	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142587	\N	\N
3616	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142588	\N	\N
3617	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14259	\N	\N
3618	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142591	\N	\N
3619	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142594	\N	\N
3620	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142595	\N	\N
3621	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142597	\N	\N
3622	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142599	\N	\N
3623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.1426	\N	\N
3624	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142601	\N	\N
3625	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142602	\N	\N
3626	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142604	\N	\N
3627	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142605	\N	\N
3628	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142606	\N	\N
3629	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142608	\N	\N
3630	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142609	\N	\N
3631	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14261	\N	\N
3632	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142611	\N	\N
3633	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142613	\N	\N
3634	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142614	\N	\N
3635	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142615	\N	\N
3636	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142617	\N	\N
3637	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142618	\N	\N
3638	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142619	\N	\N
3639	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142621	\N	\N
3640	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142622	\N	\N
3641	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142623	\N	\N
3642	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142625	\N	\N
3643	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142626	\N	\N
3644	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142627	\N	\N
3645	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142628	\N	\N
3646	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14263	\N	\N
3647	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142631	\N	\N
3648	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142632	\N	\N
3649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142634	\N	\N
3650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142635	\N	\N
3651	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142636	\N	\N
3652	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142637	\N	\N
3653	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142639	\N	\N
3654	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14264	\N	\N
3655	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142641	\N	\N
3656	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142643	\N	\N
3657	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142644	\N	\N
3658	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142646	\N	\N
3659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142647	\N	\N
3660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142648	\N	\N
3661	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142649	\N	\N
3662	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142651	\N	\N
3663	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142652	\N	\N
3664	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142653	\N	\N
3665	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142655	\N	\N
3666	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142656	\N	\N
3667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142657	\N	\N
3668	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142659	\N	\N
3669	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14266	\N	\N
3670	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142661	\N	\N
3671	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142662	\N	\N
3672	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142664	\N	\N
3673	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142665	\N	\N
3674	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142666	\N	\N
3675	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142668	\N	\N
3676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142669	\N	\N
3677	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14267	\N	\N
3678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142672	\N	\N
3679	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142673	\N	\N
3680	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142674	\N	\N
3681	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142676	\N	\N
3682	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142677	\N	\N
3683	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142678	\N	\N
3684	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 23:54:36.14268	\N	\N
3685	авп	ыва	1992	article	draft	\N	16	2025-02-25 23:54:36.142681	\N	\N
3686	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142682	\N	\N
3687	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142684	\N	\N
3688	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142685	\N	\N
3689	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142686	\N	\N
3690	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142688	\N	\N
3691	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142689	\N	\N
3692	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14269	\N	\N
3693	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142692	\N	\N
3694	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142693	\N	\N
3695	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142694	\N	\N
3696	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142696	\N	\N
3697	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142697	\N	\N
3698	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142698	\N	\N
3699	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.1427	\N	\N
3700	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142701	\N	\N
3701	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142703	\N	\N
4982	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.184773	\N	f
3702	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142704	\N	\N
3703	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142705	\N	\N
3704	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142706	\N	\N
3705	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142708	\N	\N
3706	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142709	\N	\N
3707	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14271	\N	\N
3708	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142712	\N	\N
3709	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142713	\N	\N
3710	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142714	\N	\N
3711	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142716	\N	\N
3712	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142717	\N	\N
3713	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142718	\N	\N
3714	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142719	\N	\N
3715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142721	\N	\N
3716	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142722	\N	\N
3717	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142723	\N	\N
3718	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142725	\N	\N
3719	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142726	\N	\N
3720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142727	\N	\N
3721	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142729	\N	\N
3722	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14273	\N	\N
3723	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142731	\N	\N
3724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142733	\N	\N
3725	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142734	\N	\N
3726	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142735	\N	\N
3727	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142736	\N	\N
3728	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142738	\N	\N
3729	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142739	\N	\N
3730	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14274	\N	\N
3731	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142742	\N	\N
3732	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142743	\N	\N
3733	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142744	\N	\N
3734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142746	\N	\N
3735	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142747	\N	\N
3736	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142748	\N	\N
3737	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14275	\N	\N
3738	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142751	\N	\N
3739	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142752	\N	\N
3740	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142754	\N	\N
3741	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142755	\N	\N
3742	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142756	\N	\N
3743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142758	\N	\N
3744	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142759	\N	\N
3745	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14276	\N	\N
3746	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142761	\N	\N
3747	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142763	\N	\N
3748	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142764	\N	\N
3749	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142765	\N	\N
3750	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142767	\N	\N
3751	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142768	\N	\N
3752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142769	\N	\N
3753	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142771	\N	\N
3754	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142772	\N	\N
3755	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142773	\N	\N
3756	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142775	\N	\N
3757	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142776	\N	\N
3758	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142777	\N	\N
3759	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142778	\N	\N
3760	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14278	\N	\N
3761	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142781	\N	\N
3762	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142782	\N	\N
3763	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142784	\N	\N
3764	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142785	\N	\N
3765	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142786	\N	\N
3766	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142787	\N	\N
3767	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142789	\N	\N
3768	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14279	\N	\N
3769	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142791	\N	\N
3770	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142793	\N	\N
3771	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142794	\N	\N
3772	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142795	\N	\N
3773	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142797	\N	\N
3774	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142798	\N	\N
3775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142799	\N	\N
3776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142801	\N	\N
3777	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142802	\N	\N
3778	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142803	\N	\N
3779	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142804	\N	\N
3780	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142806	\N	\N
3781	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142807	\N	\N
3782	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142808	\N	\N
3783	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14281	\N	\N
3784	555	555	1999	article	draft	\N	16	2025-02-25 23:54:36.142811	\N	\N
3785	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142812	\N	\N
3786	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142814	\N	\N
3787	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142815	\N	\N
3788	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142816	\N	\N
3789	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142817	\N	\N
3790	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142819	\N	\N
3791	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14282	\N	\N
3792	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142821	\N	\N
3793	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142823	\N	\N
3794	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142824	\N	\N
3795	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142826	\N	\N
3796	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142827	\N	\N
3797	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142828	\N	\N
3798	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142829	\N	\N
3799	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142831	\N	\N
3800	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142832	\N	\N
3801	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142833	\N	\N
3802	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142835	\N	\N
3803	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142836	\N	\N
3804	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142837	\N	\N
3805	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142839	\N	\N
3806	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14284	\N	\N
3807	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142841	\N	\N
3808	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142842	\N	\N
3809	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142844	\N	\N
3810	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142845	\N	\N
3811	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142846	\N	\N
3812	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142848	\N	\N
3813	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142849	\N	\N
3814	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14285	\N	\N
3815	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142852	\N	\N
3816	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142853	\N	\N
3817	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142854	\N	\N
3818	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142856	\N	\N
3819	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142857	\N	\N
3820	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142858	\N	\N
3821	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14286	\N	\N
3822	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142861	\N	\N
3823	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142862	\N	\N
3824	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142863	\N	\N
3825	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142865	\N	\N
3826	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142866	\N	\N
3827	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142867	\N	\N
3828	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142869	\N	\N
3829	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14287	\N	\N
3830	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142871	\N	\N
3831	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142873	\N	\N
3832	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142874	\N	\N
3833	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142875	\N	\N
3834	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142876	\N	\N
3835	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142878	\N	\N
3836	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142879	\N	\N
3837	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14288	\N	\N
3838	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142882	\N	\N
3839	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142883	\N	\N
3840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142884	\N	\N
3841	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142886	\N	\N
3842	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142887	\N	\N
3843	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142888	\N	\N
3844	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142889	\N	\N
3845	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142891	\N	\N
3846	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142892	\N	\N
3847	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142893	\N	\N
3848	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142895	\N	\N
3849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142896	\N	\N
3850	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142897	\N	\N
3851	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142898	\N	\N
3852	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.1429	\N	\N
3853	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142901	\N	\N
3854	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142902	\N	\N
3855	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142904	\N	\N
3856	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142905	\N	\N
3857	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142906	\N	\N
3858	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142908	\N	\N
3859	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142909	\N	\N
3860	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14291	\N	\N
3861	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142912	\N	\N
3862	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142913	\N	\N
3863	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142914	\N	\N
3864	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142915	\N	\N
3865	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142917	\N	\N
3866	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142918	\N	\N
3867	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142919	\N	\N
3868	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142921	\N	\N
3869	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142922	\N	\N
3870	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142923	\N	\N
3871	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142925	\N	\N
3872	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.142926	\N	\N
3873	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142928	\N	\N
3874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142929	\N	\N
3875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14293	\N	\N
3876	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142932	\N	\N
3877	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142933	\N	\N
3878	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142934	\N	\N
3879	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142936	\N	\N
3880	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142937	\N	\N
3881	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142938	\N	\N
3882	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142939	\N	\N
3883	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.142941	\N	\N
3884	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.142942	\N	\N
3885	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.142943	\N	\N
3886	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.142945	\N	\N
3887	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.142946	\N	\N
3888	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142947	\N	\N
3889	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142948	\N	\N
3890	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14295	\N	\N
3891	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142951	\N	\N
3892	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142952	\N	\N
3893	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142954	\N	\N
3894	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142955	\N	\N
3895	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142956	\N	\N
3896	ddsdf	test1	2012	article	draft	\N	16	2025-02-25 23:54:36.142958	\N	\N
3897	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142959	\N	\N
3898	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14296	\N	\N
3899	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142961	\N	\N
3900	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142963	\N	\N
3901	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142964	\N	\N
3902	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142965	\N	\N
3903	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142967	\N	\N
3906	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142971	\N	\N
3907	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142972	\N	\N
3908	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142973	\N	\N
3909	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142974	\N	\N
3910	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142976	\N	\N
3911	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142977	\N	\N
3912	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142979	\N	\N
3913	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.14298	\N	\N
3914	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142981	\N	\N
3915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142982	\N	\N
3916	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142984	\N	\N
3917	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142985	\N	\N
3918	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142986	\N	\N
3919	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142988	\N	\N
3920	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142989	\N	\N
3921	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14299	\N	\N
3922	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.142992	\N	\N
3923	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.142993	\N	\N
3924	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.142994	\N	\N
3925	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142995	\N	\N
3926	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142997	\N	\N
3927	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142998	\N	\N
3928	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.142999	\N	\N
3929	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143001	\N	\N
3930	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143002	\N	\N
3931	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143003	\N	\N
3932	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143005	\N	\N
3933	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143006	\N	\N
3934	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143007	\N	\N
3935	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143008	\N	\N
3936	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14301	\N	\N
3937	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143011	\N	\N
3938	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143012	\N	\N
3939	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143014	\N	\N
3940	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143015	\N	\N
3941	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143016	\N	\N
3942	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143018	\N	\N
3943	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143019	\N	\N
3944	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14302	\N	\N
3945	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143021	\N	\N
3946	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143023	\N	\N
3947	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143024	\N	\N
3948	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143026	\N	\N
3949	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143027	\N	\N
3950	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143028	\N	\N
3951	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.14303	\N	\N
3952	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143031	\N	\N
3953	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143032	\N	\N
3954	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143033	\N	\N
3955	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143035	\N	\N
3956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143036	\N	\N
3957	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143037	\N	\N
3958	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143039	\N	\N
3959	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.14304	\N	\N
3960	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143041	\N	\N
3961	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143043	\N	\N
3962	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143044	\N	\N
3963	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143045	\N	\N
3964	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143046	\N	\N
3965	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143048	\N	\N
3966	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143049	\N	\N
3967	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14305	\N	\N
3968	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143052	\N	\N
3969	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143053	\N	\N
3970	dfg	dfgdfg	2023	article	draft	\N	16	2025-02-25 23:54:36.143054	\N	\N
3971	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143056	\N	\N
3972	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143057	\N	\N
3973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143058	\N	\N
3974	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14306	\N	\N
3975	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143061	\N	\N
3976	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143062	\N	\N
3977	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143063	\N	\N
3978	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143065	\N	\N
3979	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143066	\N	\N
3980	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143068	\N	\N
3981	TheShamRio	test1	2011	article	draft	\N	16	2025-02-25 23:54:36.143069	\N	\N
3982	авп	ыва	1992	article	draft	\N	16	2025-02-25 23:54:36.14307	\N	\N
3983	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-02-25 23:54:36.143071	\N	\N
3984	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-02-25 23:54:36.143073	\N	\N
3985	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-02-25 23:54:36.143074	\N	\N
3986	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-02-25 23:54:36.143075	\N	\N
3987	dfd	sdfs	2022	article	draft	\N	16	2025-02-25 23:54:36.143077	\N	\N
3988	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143078	\N	\N
3989	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143079	\N	\N
3990	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143081	\N	\N
3991	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143082	\N	\N
3992	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143083	\N	\N
3993	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143085	\N	\N
3994	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143086	\N	\N
3995	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143087	\N	\N
3996	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143089	\N	\N
3997	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14309	\N	\N
3998	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143091	\N	\N
3999	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143092	\N	\N
4000	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143094	\N	\N
4001	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143095	\N	\N
4002	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143098	\N	\N
4003	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143099	\N	\N
4004	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.1431	\N	\N
4005	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143102	\N	\N
4006	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143104	\N	\N
4007	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143105	\N	\N
4008	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143106	\N	\N
4009	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143108	\N	\N
4010	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143109	\N	\N
4011	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14311	\N	\N
4012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143112	\N	\N
4013	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143113	\N	\N
4014	ddsdf	test1ы	2015	article	draft	\N	16	2025-02-25 23:54:36.143114	\N	\N
4015	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143116	\N	\N
4016	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143117	\N	\N
4017	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143118	\N	\N
4018	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143119	\N	\N
4019	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143121	\N	\N
4020	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143122	\N	\N
4021	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143123	\N	\N
4022	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143125	\N	\N
4023	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143126	\N	\N
4024	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143127	\N	\N
4025	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143129	\N	\N
4026	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14313	\N	\N
4027	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143131	\N	\N
4028	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143133	\N	\N
4029	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143134	\N	\N
4030	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143135	\N	\N
4031	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143137	\N	\N
4032	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143138	\N	\N
4033	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143139	\N	\N
4034	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14314	\N	\N
4035	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143142	\N	\N
4036	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143143	\N	\N
4037	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143144	\N	\N
4038	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143146	\N	\N
4039	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143147	\N	\N
4040	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143148	\N	\N
4043	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143152	\N	\N
4044	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143153	\N	\N
4045	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143155	\N	\N
4046	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143156	\N	\N
4047	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143157	\N	\N
4049	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.14316	\N	\N
4050	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143161	\N	\N
4051	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143163	\N	\N
4052	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143164	\N	\N
4053	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143165	\N	\N
4054	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143167	\N	\N
4055	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143168	\N	\N
4056	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143169	\N	\N
4057	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143171	\N	\N
4058	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143172	\N	\N
4059	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143173	\N	\N
4060	ddsdf	test1	2015	article	draft	\N	16	2025-02-25 23:54:36.143174	\N	\N
4061	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143176	\N	\N
4062	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143177	\N	\N
4063	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143178	\N	\N
4065	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143181	\N	\N
4067	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-02-25 23:54:36.143185	\N	\N
4068	Sham	test2	2010	article	draft	\N	16	2025-02-25 23:54:36.143187	\N	\N
4069	длолд	ирмтми	2015	article	draft	\N	16	2025-02-25 23:54:36.143188	\N	\N
4070	dfg	dfgdfg	2022	article	published	/uploads/6.pdf	16	2025-03-10 11:09:25.888755	2025-03-10 11:09:25.887576	f
4084	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	20	2025-02-26 00:12:51.080084	\N	\N
4085	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	20	2025-02-26 00:12:51.080088	\N	\N
4086	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	20	2025-02-26 00:12:51.08009	\N	\N
4087	Robotics and Automation	Evans, Linda	2021	article	draft	\N	20	2025-02-26 00:12:51.080092	\N	\N
4088	dfd	sdfs	2022	article	draft	\N	20	2025-02-26 00:12:51.080093	\N	\N
4089	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080095	\N	\N
4090	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080096	\N	\N
4091	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080097	\N	\N
4092	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080099	\N	\N
4093	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.0801	\N	\N
4094	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080102	\N	\N
4095	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080103	\N	\N
4096	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080104	\N	\N
4097	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080106	\N	\N
4098	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080107	\N	\N
4099	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080108	\N	\N
4100	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.08011	\N	\N
4101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080111	\N	\N
4102	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080113	\N	\N
4103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080114	\N	\N
4104	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080115	\N	\N
4105	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080117	\N	\N
4106	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080118	\N	\N
4107	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080119	\N	\N
4108	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080121	\N	\N
4983	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184774	\N	f
5808	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18588	\N	f
4109	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080122	\N	\N
4110	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080123	\N	\N
4111	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080125	\N	\N
4112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080126	\N	\N
4113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080128	\N	\N
4114	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080129	\N	\N
4115	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.08013	\N	\N
4116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080132	\N	\N
4117	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080133	\N	\N
4118	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080134	\N	\N
4119	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080136	\N	\N
4120	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080137	\N	\N
4121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080138	\N	\N
4122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.08014	\N	\N
4123	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080141	\N	\N
4124	длолд	ирмтми	2015	article	draft	\N	20	2025-02-26 00:12:51.080143	\N	\N
4125	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080144	\N	\N
4126	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080145	\N	\N
4127	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080147	\N	\N
4128	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080148	\N	\N
4129	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080149	\N	\N
4130	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080151	\N	\N
4131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080152	\N	\N
4132	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080153	\N	\N
4133	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080155	\N	\N
4134	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080156	\N	\N
4135	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080158	\N	\N
4136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080159	\N	\N
4137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.08016	\N	\N
4138	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080162	\N	\N
4139	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080163	\N	\N
4140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080164	\N	\N
4141	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080166	\N	\N
4142	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080167	\N	\N
4143	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080168	\N	\N
4144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.08017	\N	\N
4145	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080171	\N	\N
4146	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080173	\N	\N
4147	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080174	\N	\N
4148	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080175	\N	\N
4149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080177	\N	\N
4150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080178	\N	\N
4151	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080179	\N	\N
4152	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080181	\N	\N
4153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080182	\N	\N
4154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080183	\N	\N
4155	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080185	\N	\N
4156	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080186	\N	\N
4157	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080187	\N	\N
4158	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080189	\N	\N
4159	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.08019	\N	\N
4160	длолд	ирмтми	2015	article	draft	\N	20	2025-02-26 00:12:51.080192	\N	\N
4161	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080193	\N	\N
4162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080194	\N	\N
4163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080196	\N	\N
4164	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080197	\N	\N
4165	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080198	\N	\N
4166	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.0802	\N	\N
4167	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080201	\N	\N
4168	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080203	\N	\N
4169	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080204	\N	\N
4170	длолд	ирмтми	2015	article	draft	\N	20	2025-02-26 00:12:51.080205	\N	\N
4172	ddsdf	test1	2015	article	draft	\N	20	2025-02-26 00:12:51.080208	\N	\N
4173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080209	\N	\N
4174	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080211	\N	\N
4175	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080212	\N	\N
4176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080214	\N	\N
4177	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080215	\N	\N
4178	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080216	\N	\N
4179	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	20	2025-02-26 00:12:51.080218	\N	\N
4180	Sham	test2	2010	article	draft	\N	20	2025-02-26 00:12:51.080219	\N	\N
4181	длолд	ирмтми	2015	article	draft	\N	20	2025-02-26 00:12:51.08022	\N	\N
156	Разработка автоматизированнной системы	Шамиль и Виталик	2025	article	published	/uploads/4411__3_1.docx	\N	2025-02-26 00:58:52.335399	\N	\N
1399	выа	выаываs	2011	article	published	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-26 01:26:02.701009	\N	\N
7759	22222222	222222222	1999	article	published	/uploads/-_2017.pdf	40	2025-03-07 11:15:28.192253	2025-03-07 11:15:28.191968	f
180	Разработка автоматизированнной системы	Шамиль и Виталик	2025	monograph	published	/uploads/4411__3_1.docx	5	2025-02-27 02:35:52.074732	2025-02-27 02:35:52.073119	\N
4182	sd	ds	2010	monograph	published	/uploads/Pokubovstaya_2016.pdf	16	2025-02-27 20:21:18.023116	2025-02-27 02:26:42.281678	\N
266	dsfsd	dsfsdf	1999	monograph	draft	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-23 14:31:37.540946	\N	\N
201	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	/uploads/4411__3_1.docx	16	2025-02-23 14:20:23.893653	\N	\N
202	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	/uploads/4411__3_1.docx	16	2025-02-23 14:26:22.288641	\N	\N
203	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	/uploads/-17.pdf	16	2025-02-23 14:27:47.381078	\N	\N
296	dfg	dfgdfg	2023	article	draft	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-24 01:00:54.560153	\N	\N
307	dssfsdf	TheShamRio	2024	monograph	draft	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-24 10:07:06.497205	\N	\N
210	dfd	sdfs	2022	article	draft	/uploads/4411__3_1.docx	16	2025-02-22 20:41:58.894679	\N	\N
147	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	\N	2025-03-02 14:40:29.017252	\N	\N
148	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	\N	2025-03-02 14:40:29.017254	\N	\N
149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	\N	2025-03-02 14:40:29.017256	\N	\N
150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	\N	2025-03-02 14:40:29.017258	\N	\N
151	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	\N	2025-03-02 14:40:29.017259	\N	\N
152	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	\N	2025-03-02 14:40:29.017261	\N	\N
153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	\N	2025-03-02 14:40:29.017262	\N	\N
154	Sham	test2	2010	article	draft	\N	\N	2025-03-02 14:40:29.017264	\N	\N
4184	dfgdfg	dfgdfg	2010	article	published	/uploads/6.pdf	27	2025-03-02 16:37:26.427803	2025-03-02 16:37:26.427317	\N
155	длолд	ирмтми	2015	article	published	/uploads/4411__3_1.docx	\N	2025-03-02 14:40:29.017265	\N	\N
7764	12	12	1997	article	published	/uploads/Zayavlenie_na_utverzhdenie_temy_VKR_-_blank.pdf	40	2025-03-09 22:00:20.162738	2025-03-09 22:00:20.162509	f
4185	dfgdfg	dfgdfg	2011	article	published	/uploads/848844016_1.pdf	16	2025-03-03 01:28:30.450542	2025-03-03 01:28:30.449742	f
3189	ываы	ваыва	1999	article	published	/uploads/4411__3_1.docx	16	2025-02-25 17:35:05.220975	2025-02-25 17:35:05.220495	\N
1397	длолд	ирмтми	2015	article	published	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 02:51:04.539398	2025-02-25 02:51:04.539182	\N
4188	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.183704	\N	f
4189	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.183708	\N	f
4190	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.183711	\N	f
4191	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.183713	\N	f
4192	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.183715	\N	f
4193	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183716	\N	f
4194	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183718	\N	f
4195	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183719	\N	f
4196	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18372	\N	f
4197	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183722	\N	f
4198	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183723	\N	f
4199	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183724	\N	f
4200	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183726	\N	f
4201	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183727	\N	f
4202	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183729	\N	f
4203	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18373	\N	f
4204	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183731	\N	f
4205	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183733	\N	f
4206	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183734	\N	f
4207	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183736	\N	f
4208	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183737	\N	f
4209	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183738	\N	f
4210	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18374	\N	f
4211	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183741	\N	f
4212	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183743	\N	f
4213	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183744	\N	f
4214	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183746	\N	f
4215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183747	\N	f
4216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183748	\N	f
4217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18375	\N	f
1396	Sham	test2	2010	article	published	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:12:30.699676	2025-02-25 03:12:30.699465	\N
1394	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:24:01.674822	\N	\N
7760	333333	33333333	1998	article	published	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	40	2025-03-07 11:15:20.512795	2025-03-07 11:15:20.51256	f
4220	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183754	\N	f
4221	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183755	\N	f
4222	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183757	\N	f
4223	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183758	\N	f
4224	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18376	\N	f
4225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183761	\N	f
4226	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183763	\N	f
4227	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183764	\N	f
4228	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.183765	\N	f
4229	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183766	\N	f
4230	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183768	\N	f
4231	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183769	\N	f
4232	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18377	\N	f
4233	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183772	\N	f
4234	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183773	\N	f
4235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183774	\N	f
4236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183775	\N	f
4237	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183777	\N	f
4238	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183778	\N	f
4239	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18378	\N	f
4240	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183781	\N	f
4241	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183782	\N	f
4242	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183784	\N	f
4243	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183785	\N	f
4244	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183786	\N	f
4245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183788	\N	f
4246	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183789	\N	f
4247	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18379	\N	f
4248	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183792	\N	f
4249	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183793	\N	f
4250	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183794	\N	f
4251	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183796	\N	f
4252	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183797	\N	f
4253	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183798	\N	f
4254	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1838	\N	f
4255	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183801	\N	f
4256	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183802	\N	f
4257	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183804	\N	f
4258	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183807	\N	f
4259	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183808	\N	f
4260	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18381	\N	f
4261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183811	\N	f
4262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183812	\N	f
4263	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183814	\N	f
4264	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.183815	\N	f
4265	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183817	\N	f
4266	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183818	\N	f
4267	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183819	\N	f
4268	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18382	\N	f
4269	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183822	\N	f
4270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183823	\N	f
4271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183824	\N	f
4272	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183826	\N	f
4273	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183827	\N	f
4274	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.183828	\N	f
4275	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.18383	\N	f
4276	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183831	\N	f
4277	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183832	\N	f
4278	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183834	\N	f
4279	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183835	\N	f
4280	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183836	\N	f
4281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183838	\N	f
4282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183839	\N	f
4283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18384	\N	f
4284	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183842	\N	f
4285	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.183843	\N	f
4286	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.183844	\N	f
4287	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.183846	\N	f
4288	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.183847	\N	f
4289	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.183848	\N	f
4290	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.18385	\N	f
4291	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183851	\N	f
4292	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183852	\N	f
4293	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183854	\N	f
4294	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183855	\N	f
4295	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183856	\N	f
4296	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183858	\N	f
4297	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183859	\N	f
4298	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18386	\N	f
4299	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.183862	\N	f
4300	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183863	\N	f
4301	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183864	\N	f
4302	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183866	\N	f
4303	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183867	\N	f
4304	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183868	\N	f
4305	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18387	\N	f
4306	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183871	\N	f
4307	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183872	\N	f
4308	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183874	\N	f
4309	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183875	\N	f
4310	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183876	\N	f
4311	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183878	\N	f
4312	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183879	\N	f
4313	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18388	\N	f
4314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183882	\N	f
4315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183883	\N	f
4316	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183884	\N	f
4317	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183885	\N	f
4318	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183887	\N	f
4319	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183888	\N	f
4320	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183889	\N	f
4321	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183891	\N	f
4322	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183892	\N	f
4323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183894	\N	f
4324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183895	\N	f
4325	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183896	\N	f
4326	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.183898	\N	f
4327	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183899	\N	f
4328	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1839	\N	f
4329	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183902	\N	f
4330	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183903	\N	f
4331	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183904	\N	f
4332	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183906	\N	f
4333	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183907	\N	f
4334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183909	\N	f
4335	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18391	\N	f
4336	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183912	\N	f
4337	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183913	\N	f
4338	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183914	\N	f
4339	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183916	\N	f
4340	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183917	\N	f
4341	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183918	\N	f
4342	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18392	\N	f
4343	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183921	\N	f
4344	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183922	\N	f
4345	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183924	\N	f
5110	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184948	\N	f
4346	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183925	\N	f
4347	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183926	\N	f
4348	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183928	\N	f
4349	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183929	\N	f
4350	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18393	\N	f
4351	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183932	\N	f
4352	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183933	\N	f
4353	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183934	\N	f
4354	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183936	\N	f
4355	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183937	\N	f
4356	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183938	\N	f
4357	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18394	\N	f
4358	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183941	\N	f
4359	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183942	\N	f
4360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183944	\N	f
4361	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183945	\N	f
4362	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.183946	\N	f
4363	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183948	\N	f
4364	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183949	\N	f
4365	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18395	\N	f
4366	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183952	\N	f
4367	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183953	\N	f
4368	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183954	\N	f
4369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183955	\N	f
4370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183957	\N	f
4371	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183958	\N	f
4372	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.183959	\N	f
4373	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.183961	\N	f
4374	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183962	\N	f
4375	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183963	\N	f
4376	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183965	\N	f
4377	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183966	\N	f
4378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183967	\N	f
4379	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183969	\N	f
4380	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18397	\N	f
4381	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183972	\N	f
4382	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.183973	\N	f
4383	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.183974	\N	f
4384	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.183976	\N	f
4385	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.183977	\N	f
4386	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.183978	\N	f
4387	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.18398	\N	f
4388	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.183981	\N	f
4389	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.183982	\N	f
4390	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183984	\N	f
4391	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183985	\N	f
4392	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183986	\N	f
4393	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183988	\N	f
4394	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183989	\N	f
4395	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18399	\N	f
4396	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183992	\N	f
4397	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183993	\N	f
4398	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.183995	\N	f
4399	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183996	\N	f
4400	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183997	\N	f
4401	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.183999	\N	f
4402	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184	\N	f
4403	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184001	\N	f
4404	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184003	\N	f
4405	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184004	\N	f
4406	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184005	\N	f
4407	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184007	\N	f
4408	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184008	\N	f
5363	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185286	\N	f
4409	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184009	\N	f
4410	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184011	\N	f
4411	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184012	\N	f
4412	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184013	\N	f
4413	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184015	\N	f
4414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184016	\N	f
4415	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184017	\N	f
4416	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184019	\N	f
4417	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18402	\N	f
4418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184022	\N	f
4419	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184023	\N	f
4420	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184024	\N	f
4421	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184026	\N	f
4422	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184027	\N	f
4423	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184028	\N	f
4424	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18403	\N	f
4425	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184031	\N	f
4426	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184032	\N	f
4427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184034	\N	f
4428	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184035	\N	f
4429	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184037	\N	f
4430	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184038	\N	f
4431	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184039	\N	f
4432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18404	\N	f
4433	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184042	\N	f
4434	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184043	\N	f
4435	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184044	\N	f
4436	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184046	\N	f
4437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184047	\N	f
4438	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184048	\N	f
4439	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18405	\N	f
4440	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184051	\N	f
4441	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184053	\N	f
4442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184054	\N	f
4443	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184056	\N	f
4444	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184057	\N	f
4445	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184058	\N	f
4446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18406	\N	f
4447	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184061	\N	f
4448	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184062	\N	f
4449	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184063	\N	f
4450	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184065	\N	f
4451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184066	\N	f
4452	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184067	\N	f
4453	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184069	\N	f
4454	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18407	\N	f
4455	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184071	\N	f
4456	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184073	\N	f
4457	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184074	\N	f
4458	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184075	\N	f
4459	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184077	\N	f
4460	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184078	\N	f
4461	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184079	\N	f
4462	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184081	\N	f
4463	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184082	\N	f
4464	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184083	\N	f
4465	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184085	\N	f
4466	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184086	\N	f
4467	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184087	\N	f
4468	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184089	\N	f
4469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18409	\N	f
4470	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184091	\N	f
4471	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184093	\N	f
4474	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184097	\N	f
4475	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184098	\N	f
4476	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184099	\N	f
4477	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184101	\N	f
4478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184102	\N	f
4479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184103	\N	f
4480	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184104	\N	f
4481	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184106	\N	f
4482	выа	выаываs	2011	article	draft	\N	16	2025-03-04 00:07:03.184107	\N	f
4483	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.184108	\N	f
4484	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.18411	\N	f
4485	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.184111	\N	f
4486	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.184112	\N	f
4487	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.184114	\N	f
4488	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184115	\N	f
4489	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184116	\N	f
4490	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184118	\N	f
4491	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184119	\N	f
4492	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18412	\N	f
4493	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184122	\N	f
4494	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184123	\N	f
4495	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184124	\N	f
4496	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184125	\N	f
4497	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184127	\N	f
4498	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184128	\N	f
4499	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184129	\N	f
4500	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184131	\N	f
4501	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184132	\N	f
4502	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184133	\N	f
4503	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184135	\N	f
4504	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184136	\N	f
4505	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184137	\N	f
4506	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184139	\N	f
4507	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18414	\N	f
4508	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184141	\N	f
4509	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184143	\N	f
4510	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184144	\N	f
4511	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184145	\N	f
4512	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184146	\N	f
4513	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184148	\N	f
4514	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184149	\N	f
4515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18415	\N	f
4516	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184152	\N	f
4517	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184153	\N	f
4518	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184154	\N	f
4519	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184156	\N	f
4520	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184157	\N	f
4521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184158	\N	f
4522	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18416	\N	f
4523	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184161	\N	f
4524	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184162	\N	f
4525	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184164	\N	f
4526	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184165	\N	f
4527	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184166	\N	f
4528	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184168	\N	f
4529	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184169	\N	f
4530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18417	\N	f
4531	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184172	\N	f
4532	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184173	\N	f
4533	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184174	\N	f
4534	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184175	\N	f
4535	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184177	\N	f
4536	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184178	\N	f
4537	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184179	\N	f
4538	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184181	\N	f
4539	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184182	\N	f
4540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184183	\N	f
4541	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184185	\N	f
4542	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184186	\N	f
4543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184187	\N	f
4544	On the Electrodynamics of Moving Bodies	Albert Einsteinaa	1905	article	draft	\N	16	2025-03-04 00:07:03.184189	\N	f
4545	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18419	\N	f
4546	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184191	\N	f
4547	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184192	\N	f
4548	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184194	\N	f
4549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184195	\N	f
4550	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184196	\N	f
4551	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184198	\N	f
4552	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184199	\N	f
4553	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1842	\N	f
4554	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184202	\N	f
4555	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184203	\N	f
4556	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184204	\N	f
4557	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184206	\N	f
4558	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184207	\N	f
4559	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184208	\N	f
4560	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184209	\N	f
4561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184211	\N	f
4562	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184212	\N	f
4563	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184213	\N	f
4564	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184215	\N	f
4565	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184216	\N	f
4566	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184217	\N	f
4567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184219	\N	f
4568	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18422	\N	f
4569	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184221	\N	f
4570	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.184223	\N	f
4571	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184224	\N	f
4572	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184225	\N	f
4573	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184226	\N	f
4574	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184228	\N	f
4575	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184229	\N	f
4576	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18423	\N	f
4577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184232	\N	f
4578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184233	\N	f
4579	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184234	\N	f
4580	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184236	\N	f
4581	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.184237	\N	f
4582	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.184238	\N	f
4583	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.18424	\N	f
4584	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.184241	\N	f
4585	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.184242	\N	f
4586	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184244	\N	f
4587	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184245	\N	f
4588	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184246	\N	f
4589	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184248	\N	f
4590	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184249	\N	f
4591	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18425	\N	f
4592	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184252	\N	f
4593	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184253	\N	f
4594	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.184254	\N	f
4595	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184256	\N	f
4596	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184257	\N	f
4597	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184259	\N	f
4598	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18426	\N	f
4599	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184261	\N	f
4600	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184263	\N	f
4601	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184264	\N	f
4602	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184265	\N	f
4603	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184267	\N	f
4604	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184268	\N	f
4605	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184269	\N	f
4606	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184271	\N	f
4607	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184272	\N	f
4608	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184273	\N	f
4609	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184275	\N	f
4610	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184276	\N	f
4611	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184277	\N	f
4612	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184279	\N	f
4613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18428	\N	f
4614	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184281	\N	f
4615	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184283	\N	f
4616	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184284	\N	f
4617	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184285	\N	f
4618	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184287	\N	f
4619	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184288	\N	f
4620	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184289	\N	f
4621	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184291	\N	f
4622	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184292	\N	f
4623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184293	\N	f
4624	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184295	\N	f
4625	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184296	\N	f
4626	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184297	\N	f
4627	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184299	\N	f
4628	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1843	\N	f
4629	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184301	\N	f
4630	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184303	\N	f
4631	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184304	\N	f
4632	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184305	\N	f
4633	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184307	\N	f
4634	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184308	\N	f
4635	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184309	\N	f
4636	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18431	\N	f
4637	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184312	\N	f
4638	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184313	\N	f
4639	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184314	\N	f
4640	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184316	\N	f
4641	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184317	\N	f
4642	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184318	\N	f
4643	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18432	\N	f
4644	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184321	\N	f
4645	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184322	\N	f
4646	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184324	\N	f
4647	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184325	\N	f
4648	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184326	\N	f
4649	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184328	\N	f
4650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184329	\N	f
4651	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18433	\N	f
4652	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184332	\N	f
4653	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184333	\N	f
4654	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184334	\N	f
4655	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184336	\N	f
4656	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184337	\N	f
4657	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184338	\N	f
4658	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18434	\N	f
4659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184341	\N	f
4660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184342	\N	f
4661	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184344	\N	f
4662	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184345	\N	f
4663	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184346	\N	f
4664	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184348	\N	f
4665	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184349	\N	f
4666	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18435	\N	f
4667	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184352	\N	f
4668	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.184353	\N	f
4669	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184354	\N	f
4670	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184356	\N	f
4671	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184357	\N	f
4672	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184358	\N	f
4673	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18436	\N	f
4674	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184361	\N	f
4675	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184362	\N	f
4676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184364	\N	f
4677	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184365	\N	f
4678	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184366	\N	f
4679	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.184367	\N	f
4680	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.184369	\N	f
4681	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.18437	\N	f
4682	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.184372	\N	f
4683	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.184373	\N	f
4684	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.184374	\N	f
4685	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.184375	\N	f
4686	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184377	\N	f
4687	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184378	\N	f
4688	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18438	\N	f
4689	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184381	\N	f
4690	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184382	\N	f
4691	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184384	\N	f
4692	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184385	\N	f
4693	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184386	\N	f
4694	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184388	\N	f
4695	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184389	\N	f
4696	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18439	\N	f
4697	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184392	\N	f
4698	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184393	\N	f
4699	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184394	\N	f
4700	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184395	\N	f
4701	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184397	\N	f
4702	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184398	\N	f
4703	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184399	\N	f
4704	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184401	\N	f
4705	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184402	\N	f
4706	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184403	\N	f
4707	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184405	\N	f
4708	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184406	\N	f
4709	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184407	\N	f
4710	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184409	\N	f
4711	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18441	\N	f
4712	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184411	\N	f
4713	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184413	\N	f
4714	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184414	\N	f
4715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184415	\N	f
4716	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184417	\N	f
4717	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184418	\N	f
4718	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184419	\N	f
4719	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184421	\N	f
4720	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184422	\N	f
4721	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184423	\N	f
4722	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184425	\N	f
4723	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184426	\N	f
4724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184427	\N	f
4725	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184429	\N	f
4726	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18443	\N	f
4727	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184431	\N	f
4728	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184433	\N	f
4729	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184434	\N	f
4730	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184435	\N	f
4731	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184437	\N	f
4732	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184438	\N	f
4733	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184439	\N	f
4734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184441	\N	f
4735	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184442	\N	f
4736	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184443	\N	f
4737	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184444	\N	f
4738	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184446	\N	f
4739	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184447	\N	f
4740	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184448	\N	f
4741	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18445	\N	f
4742	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184451	\N	f
4743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184452	\N	f
4744	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184454	\N	f
4745	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184455	\N	f
4746	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184456	\N	f
4747	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184457	\N	f
4748	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184459	\N	f
4749	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18446	\N	f
4750	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184461	\N	f
4751	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184463	\N	f
4752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184464	\N	f
4753	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184466	\N	f
4754	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184467	\N	f
4755	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184468	\N	f
4756	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18447	\N	f
4757	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184471	\N	f
4758	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184472	\N	f
4759	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184474	\N	f
4760	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184475	\N	f
4761	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184477	\N	f
4762	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184478	\N	f
4763	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184479	\N	f
4764	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184481	\N	f
4765	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184482	\N	f
4766	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184483	\N	f
4767	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184485	\N	f
4768	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.184486	\N	f
4769	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184487	\N	f
4770	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184489	\N	f
4771	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18449	\N	f
4772	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184492	\N	f
4773	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184493	\N	f
4774	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184494	\N	f
4775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184496	\N	f
4776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184497	\N	f
4777	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184498	\N	f
4778	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.1845	\N	f
4779	555	555	1999	article	draft	\N	16	2025-03-04 00:07:03.184501	\N	f
4780	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.184502	\N	f
4781	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.184504	\N	f
4782	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.184505	\N	f
4783	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.184506	\N	f
4784	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.184508	\N	f
4785	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184509	\N	f
4786	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184511	\N	f
4787	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184512	\N	f
4788	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184513	\N	f
4789	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184515	\N	f
4790	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184516	\N	f
4791	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184517	\N	f
4792	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184519	\N	f
4793	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18452	\N	f
4794	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184521	\N	f
4795	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184523	\N	f
4796	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184524	\N	f
4797	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184525	\N	f
4798	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184527	\N	f
4799	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184528	\N	f
4800	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184529	\N	f
4801	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184531	\N	f
4802	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184532	\N	f
4803	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184533	\N	f
4804	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184535	\N	f
4805	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184536	\N	f
4806	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184537	\N	f
4807	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184539	\N	f
4808	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18454	\N	f
4809	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184541	\N	f
4810	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184543	\N	f
4811	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184544	\N	f
4812	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184545	\N	f
4813	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184547	\N	f
4814	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184548	\N	f
4815	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184549	\N	f
4816	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184551	\N	f
4817	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184552	\N	f
4818	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184553	\N	f
4819	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184555	\N	f
4820	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184556	\N	f
4821	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184557	\N	f
4822	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184559	\N	f
4823	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18456	\N	f
4824	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184561	\N	f
4825	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184563	\N	f
4826	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184564	\N	f
4827	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184565	\N	f
4828	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184566	\N	f
4829	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184568	\N	f
4830	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184569	\N	f
4831	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184571	\N	f
4832	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184572	\N	f
4833	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184573	\N	f
4834	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184575	\N	f
4835	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184576	\N	f
4836	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184577	\N	f
4837	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184579	\N	f
4838	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18458	\N	f
4839	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184581	\N	f
4840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184582	\N	f
4841	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184584	\N	f
4842	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184585	\N	f
4843	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184586	\N	f
4844	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184588	\N	f
4845	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184589	\N	f
4846	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18459	\N	f
4847	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184592	\N	f
4848	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184593	\N	f
4849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184595	\N	f
4850	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184596	\N	f
4851	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184597	\N	f
4852	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184599	\N	f
4853	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1846	\N	f
4854	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184601	\N	f
4855	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184603	\N	f
4856	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184604	\N	f
4857	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184605	\N	f
4858	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184606	\N	f
4859	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184608	\N	f
4860	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184609	\N	f
4861	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18461	\N	f
4862	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184612	\N	f
4863	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184613	\N	f
4864	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184614	\N	f
4865	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184616	\N	f
4866	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184617	\N	f
4867	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.184618	\N	f
4868	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18462	\N	f
4869	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184621	\N	f
4870	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184622	\N	f
4871	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184624	\N	f
4872	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184625	\N	f
4873	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184626	\N	f
4874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184627	\N	f
4875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184629	\N	f
4876	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18463	\N	f
4877	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184631	\N	f
4878	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.184633	\N	f
4879	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.184634	\N	f
4880	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.184636	\N	f
4881	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.184637	\N	f
4882	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.184638	\N	f
4883	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18464	\N	f
4884	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184641	\N	f
4885	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184642	\N	f
4886	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184643	\N	f
4887	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184645	\N	f
4888	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184646	\N	f
4889	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184648	\N	f
4890	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184649	\N	f
4891	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.18465	\N	f
4892	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184651	\N	f
4893	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184653	\N	f
4894	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184654	\N	f
4895	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184655	\N	f
4896	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184657	\N	f
4897	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184658	\N	f
4898	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184659	\N	f
4899	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184661	\N	f
4900	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184662	\N	f
4901	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184663	\N	f
4902	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184665	\N	f
4903	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184666	\N	f
4904	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184667	\N	f
4905	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184669	\N	f
4906	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18467	\N	f
4907	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184671	\N	f
4908	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184673	\N	f
4909	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184674	\N	f
4910	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184675	\N	f
4911	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184676	\N	f
4912	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184678	\N	f
4913	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184679	\N	f
4914	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18468	\N	f
4915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184682	\N	f
4916	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184683	\N	f
4918	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184686	\N	f
4919	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184687	\N	f
4920	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184688	\N	f
4921	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18469	\N	f
4922	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184691	\N	f
4923	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184692	\N	f
4924	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184693	\N	f
4925	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184695	\N	f
4926	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184696	\N	f
4927	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184698	\N	f
4928	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184699	\N	f
4929	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1847	\N	f
4930	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184701	\N	f
4931	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184703	\N	f
4932	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184704	\N	f
4933	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184705	\N	f
4934	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184707	\N	f
4935	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184708	\N	f
4936	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184709	\N	f
4937	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184711	\N	f
4938	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184712	\N	f
4939	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184713	\N	f
4940	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184715	\N	f
4941	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184716	\N	f
4942	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184717	\N	f
4943	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184718	\N	f
4944	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18472	\N	f
4945	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184722	\N	f
4946	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184723	\N	f
4947	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184724	\N	f
4948	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184726	\N	f
4949	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184727	\N	f
4950	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184728	\N	f
4951	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18473	\N	f
4952	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184731	\N	f
4953	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184733	\N	f
4954	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184734	\N	f
4955	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184735	\N	f
4956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184737	\N	f
4957	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184738	\N	f
4958	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184739	\N	f
4959	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184741	\N	f
4960	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184742	\N	f
4961	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184743	\N	f
4962	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184745	\N	f
4963	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184746	\N	f
4964	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184747	\N	f
4965	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.184749	\N	f
4966	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18475	\N	f
4967	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184752	\N	f
4968	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184753	\N	f
4969	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184754	\N	f
4970	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184756	\N	f
4971	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184757	\N	f
4972	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184759	\N	f
4973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184761	\N	f
4974	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184762	\N	f
4975	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184763	\N	f
4976	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.184765	\N	f
4977	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.184766	\N	f
4978	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.184767	\N	f
4979	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.184769	\N	f
4980	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.18477	\N	f
4981	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.184771	\N	f
4984	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184776	\N	f
4985	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184777	\N	f
4986	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184778	\N	f
4987	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18478	\N	f
4988	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184781	\N	f
4989	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184782	\N	f
4990	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184784	\N	f
4991	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184785	\N	f
4992	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184786	\N	f
4993	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184788	\N	f
4994	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184789	\N	f
4995	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18479	\N	f
4996	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184792	\N	f
4997	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184793	\N	f
4998	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184794	\N	f
4999	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184796	\N	f
5000	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184798	\N	f
5001	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1848	\N	f
5002	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184801	\N	f
5003	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184802	\N	f
5004	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184804	\N	f
5005	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184805	\N	f
5006	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184807	\N	f
5007	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184808	\N	f
5008	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184809	\N	f
5009	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184811	\N	f
5010	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184813	\N	f
5011	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184814	\N	f
5012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184815	\N	f
5013	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184816	\N	f
5014	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184818	\N	f
5015	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184819	\N	f
5016	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184821	\N	f
5017	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184822	\N	f
5018	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184823	\N	f
5019	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184825	\N	f
5020	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184826	\N	f
5021	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184827	\N	f
5022	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184829	\N	f
5023	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18483	\N	f
5024	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184831	\N	f
5025	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184833	\N	f
5026	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184834	\N	f
5027	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184836	\N	f
5028	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184837	\N	f
5029	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184839	\N	f
5030	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18484	\N	f
5031	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184841	\N	f
5032	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184843	\N	f
5033	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184844	\N	f
5034	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184846	\N	f
5035	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184847	\N	f
5036	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184848	\N	f
5037	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18485	\N	f
5038	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184851	\N	f
5039	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184853	\N	f
5040	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184854	\N	f
5041	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184855	\N	f
5042	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184857	\N	f
5043	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184858	\N	f
5044	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184859	\N	f
5045	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184861	\N	f
5046	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184862	\N	f
5047	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184864	\N	f
5048	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184865	\N	f
5049	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184866	\N	f
5050	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184868	\N	f
5051	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184869	\N	f
5052	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18487	\N	f
5053	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184872	\N	f
5054	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184873	\N	f
5055	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184874	\N	f
5056	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184876	\N	f
5057	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184877	\N	f
5058	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184878	\N	f
5059	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18488	\N	f
5060	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184881	\N	f
5061	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184882	\N	f
5062	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184884	\N	f
5063	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184885	\N	f
5064	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184886	\N	f
5065	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.184888	\N	f
5066	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184889	\N	f
5067	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18489	\N	f
5068	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184892	\N	f
5069	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184893	\N	f
5070	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184894	\N	f
5071	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184896	\N	f
5072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184897	\N	f
5073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184898	\N	f
5074	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.1849	\N	f
5075	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184901	\N	f
5076	555	555	1999	article	draft	\N	16	2025-03-04 00:07:03.184902	\N	f
5077	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.184904	\N	f
5078	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.184905	\N	f
5079	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.184906	\N	f
5080	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.184908	\N	f
5081	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.184909	\N	f
5082	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184911	\N	f
5083	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184912	\N	f
5084	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184913	\N	f
5085	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184915	\N	f
5086	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184916	\N	f
5087	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184917	\N	f
5088	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184919	\N	f
5089	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18492	\N	f
5090	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184921	\N	f
5091	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184923	\N	f
5092	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184924	\N	f
5093	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.184925	\N	f
5094	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184927	\N	f
5095	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184928	\N	f
5096	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184929	\N	f
5097	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184931	\N	f
5098	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184932	\N	f
5099	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184933	\N	f
5100	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184935	\N	f
5101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184936	\N	f
5102	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184937	\N	f
5103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184939	\N	f
5104	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.18494	\N	f
5105	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184941	\N	f
5106	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184942	\N	f
5107	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184944	\N	f
5108	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184945	\N	f
5109	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184946	\N	f
5111	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184949	\N	f
5112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18495	\N	f
5113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184952	\N	f
5114	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184953	\N	f
5115	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.184954	\N	f
5116	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184956	\N	f
5117	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184957	\N	f
5118	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184958	\N	f
5119	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18496	\N	f
5120	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.184961	\N	f
5121	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184963	\N	f
5122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184964	\N	f
5123	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184966	\N	f
5124	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184967	\N	f
5125	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184968	\N	f
5126	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18497	\N	f
5127	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184971	\N	f
5128	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184972	\N	f
5129	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184974	\N	f
5130	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184975	\N	f
5131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184977	\N	f
5132	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184978	\N	f
5133	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184979	\N	f
5134	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184981	\N	f
5135	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184982	\N	f
5136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184983	\N	f
5137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184985	\N	f
5138	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184986	\N	f
5139	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184987	\N	f
5140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184989	\N	f
5141	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18499	\N	f
5142	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184991	\N	f
5143	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184993	\N	f
5144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184994	\N	f
5145	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184995	\N	f
5146	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.184997	\N	f
5147	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.184998	\N	f
5148	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.184999	\N	f
5149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185001	\N	f
5150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185002	\N	f
5151	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185003	\N	f
5152	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185005	\N	f
5153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185006	\N	f
5154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185007	\N	f
5155	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185009	\N	f
5156	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.18501	\N	f
5157	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185012	\N	f
5158	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185013	\N	f
5159	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185014	\N	f
5160	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185016	\N	f
5161	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185017	\N	f
5162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185018	\N	f
5163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18502	\N	f
5164	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185021	\N	f
5165	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185023	\N	f
5166	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.185024	\N	f
5167	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185025	\N	f
5168	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.185027	\N	f
5169	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185028	\N	f
5170	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185029	\N	f
5171	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185031	\N	f
5172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185032	\N	f
5173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185033	\N	f
5174	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185035	\N	f
5175	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185036	\N	f
5176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185037	\N	f
5177	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185038	\N	f
5178	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.18504	\N	f
5179	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.185041	\N	f
5180	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.185043	\N	f
5181	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.185044	\N	f
5182	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.185045	\N	f
5183	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.185047	\N	f
5184	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185048	\N	f
5185	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185049	\N	f
5186	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185051	\N	f
5187	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.185052	\N	f
5188	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185053	\N	f
5189	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185055	\N	f
5190	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185056	\N	f
5191	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185057	\N	f
5192	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185059	\N	f
5193	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.18506	\N	f
5194	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185061	\N	f
5195	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185063	\N	f
5196	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185064	\N	f
5197	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185065	\N	f
5198	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185067	\N	f
5199	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185068	\N	f
5200	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18507	\N	f
5201	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185071	\N	f
5202	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185072	\N	f
5203	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185074	\N	f
5204	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185075	\N	f
5205	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185076	\N	f
5206	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185078	\N	f
5207	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185079	\N	f
5208	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18508	\N	f
5209	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185082	\N	f
5210	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185083	\N	f
5211	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185084	\N	f
5212	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185086	\N	f
5213	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185087	\N	f
5214	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185088	\N	f
5215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18509	\N	f
5216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185091	\N	f
5217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185092	\N	f
5218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185093	\N	f
5219	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185095	\N	f
5220	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185096	\N	f
5221	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185097	\N	f
5222	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185099	\N	f
5223	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.1851	\N	f
5224	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185101	\N	f
5225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185103	\N	f
5226	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185104	\N	f
5227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185105	\N	f
5228	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185107	\N	f
5229	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185108	\N	f
5230	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185109	\N	f
5231	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185111	\N	f
5232	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185112	\N	f
5233	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185113	\N	f
5234	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185115	\N	f
5235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185116	\N	f
5236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185117	\N	f
5491	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185457	\N	f
5237	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185119	\N	f
5238	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18512	\N	f
5239	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185121	\N	f
5240	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185123	\N	f
5241	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185124	\N	f
5242	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185125	\N	f
5243	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185127	\N	f
5244	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185128	\N	f
5245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185129	\N	f
5246	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185131	\N	f
5247	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185132	\N	f
5248	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185133	\N	f
5249	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185134	\N	f
5250	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185136	\N	f
5251	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185137	\N	f
5252	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185138	\N	f
5253	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18514	\N	f
5254	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185141	\N	f
5255	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185142	\N	f
5256	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185144	\N	f
5257	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185145	\N	f
5258	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185146	\N	f
5259	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185148	\N	f
5260	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185149	\N	f
5261	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18515	\N	f
5262	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185152	\N	f
5263	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185153	\N	f
5264	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185154	\N	f
5265	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185155	\N	f
5266	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185157	\N	f
5267	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185158	\N	f
5268	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185159	\N	f
5269	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185161	\N	f
5270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185162	\N	f
5271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185163	\N	f
5272	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185165	\N	f
5273	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185166	\N	f
5274	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.185167	\N	f
5275	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185169	\N	f
5276	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18517	\N	f
5277	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185171	\N	f
5278	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185173	\N	f
5279	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185174	\N	f
5280	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185175	\N	f
5281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185176	\N	f
5282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185178	\N	f
5283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185179	\N	f
5284	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18518	\N	f
5285	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185182	\N	f
5286	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.185183	\N	f
5287	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.185184	\N	f
5288	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.185186	\N	f
5289	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.185187	\N	f
5290	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.185188	\N	f
5291	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.18519	\N	f
5292	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.185191	\N	f
5293	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185192	\N	f
5294	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185194	\N	f
5295	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185195	\N	f
5296	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185196	\N	f
5297	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185198	\N	f
5298	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185199	\N	f
5299	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1852	\N	f
5300	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185202	\N	f
5301	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185203	\N	f
5302	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185204	\N	f
5303	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185205	\N	f
5304	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185207	\N	f
5305	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185208	\N	f
5306	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185209	\N	f
5307	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185211	\N	f
5308	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185212	\N	f
5309	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185213	\N	f
5310	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185215	\N	f
5311	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185216	\N	f
5312	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185218	\N	f
5313	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185219	\N	f
5314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18522	\N	f
5315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185222	\N	f
5316	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185223	\N	f
5317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185224	\N	f
5318	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185226	\N	f
5319	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185227	\N	f
5320	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185228	\N	f
5321	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18523	\N	f
5322	ddsdf	test1ы	2015	article	draft	\N	16	2025-03-04 00:07:03.185231	\N	f
5323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185233	\N	f
5324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185234	\N	f
5325	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185235	\N	f
5326	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185236	\N	f
5327	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185238	\N	f
5328	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185239	\N	f
5329	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185241	\N	f
5330	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185242	\N	f
5331	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185243	\N	f
5332	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185245	\N	f
5333	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185246	\N	f
5334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185247	\N	f
5335	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185249	\N	f
5336	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18525	\N	f
5337	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185251	\N	f
5338	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185253	\N	f
5339	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185254	\N	f
5340	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185256	\N	f
5341	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185257	\N	f
5342	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185258	\N	f
5343	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18526	\N	f
5344	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185261	\N	f
5345	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185262	\N	f
5346	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185264	\N	f
5347	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185265	\N	f
5348	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185266	\N	f
5349	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185268	\N	f
5350	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185269	\N	f
5351	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18527	\N	f
5352	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185272	\N	f
5353	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185273	\N	f
5354	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185274	\N	f
5355	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185276	\N	f
5356	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185277	\N	f
5357	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185278	\N	f
5358	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18528	\N	f
5359	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185281	\N	f
5360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185282	\N	f
5361	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185284	\N	f
5362	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185285	\N	f
5364	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185288	\N	f
5365	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185289	\N	f
5366	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18529	\N	f
5367	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185292	\N	f
5368	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185293	\N	f
5369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185295	\N	f
5370	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185296	\N	f
5371	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185297	\N	f
5372	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185299	\N	f
5373	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1853	\N	f
5374	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185301	\N	f
5375	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185303	\N	f
5376	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185304	\N	f
5377	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185306	\N	f
5378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185307	\N	f
5379	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185308	\N	f
5380	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18531	\N	f
5381	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185311	\N	f
5382	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185312	\N	f
5383	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.185314	\N	f
5384	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185315	\N	f
5385	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185316	\N	f
5386	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185318	\N	f
5387	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185319	\N	f
5388	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18532	\N	f
5389	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185322	\N	f
5390	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	draft	\N	16	2025-03-04 00:07:03.185323	\N	f
5391	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185324	\N	f
5392	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185325	\N	f
5393	Sham	test2	2013	article	draft	\N	16	2025-03-04 00:07:03.185327	\N	f
5394	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185328	\N	f
5395	Lab_1_pcmi	выаыва	2010	article	draft	\N	16	2025-03-04 00:07:03.185329	\N	f
5396	парап	апрапр	2011	article	draft	\N	16	2025-03-04 00:07:03.185331	\N	f
5397	вапвап	вапвап	1999	article	draft	\N	16	2025-03-04 00:07:03.185332	\N	f
5398	авпвап	вапвап	2013	article	draft	\N	16	2025-03-04 00:07:03.185333	\N	f
5399	авпва	пвап	1999	article	draft	\N	16	2025-03-04 00:07:03.185335	\N	f
5400	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.185336	\N	f
5401	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.185337	\N	f
5402	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.185339	\N	f
5403	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18534	\N	f
5404	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.185341	\N	f
5405	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.185342	\N	f
5406	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185344	\N	f
5407	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185345	\N	f
5408	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185346	\N	f
5409	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185348	\N	f
5410	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185349	\N	f
5411	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18535	\N	f
5412	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185352	\N	f
5413	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185353	\N	f
5414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185355	\N	f
5415	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185356	\N	f
5416	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185357	\N	f
5417	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185358	\N	f
5418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18536	\N	f
5419	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185361	\N	f
5420	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185362	\N	f
5421	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185364	\N	f
5422	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185365	\N	f
5423	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185366	\N	f
5424	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185368	\N	f
5425	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185369	\N	f
5426	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18537	\N	f
5427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185372	\N	f
5428	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185373	\N	f
5429	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185374	\N	f
5430	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185376	\N	f
5431	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185377	\N	f
5432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185378	\N	f
5433	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185379	\N	f
5434	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185381	\N	f
5435	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185382	\N	f
5436	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185383	\N	f
5437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185385	\N	f
5438	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185386	\N	f
5439	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185387	\N	f
5440	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185389	\N	f
5441	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18539	\N	f
5442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185391	\N	f
5443	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185393	\N	f
5444	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185394	\N	f
5445	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185395	\N	f
5446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185397	\N	f
5447	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185398	\N	f
5448	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185399	\N	f
5449	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1854	\N	f
5450	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185402	\N	f
5451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185403	\N	f
5452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185404	\N	f
5453	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185406	\N	f
5454	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185407	\N	f
5455	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185408	\N	f
5456	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18541	\N	f
5457	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185411	\N	f
5458	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185412	\N	f
5459	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185414	\N	f
5460	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185415	\N	f
5461	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185416	\N	f
5462	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185418	\N	f
5463	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185419	\N	f
5464	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18542	\N	f
5465	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185422	\N	f
5466	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185423	\N	f
5467	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185424	\N	f
5468	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185426	\N	f
5469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185427	\N	f
5470	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185428	\N	f
5471	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18543	\N	f
5472	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185431	\N	f
5473	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185432	\N	f
5474	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185434	\N	f
5475	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185435	\N	f
5476	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185436	\N	f
5477	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185438	\N	f
5478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185439	\N	f
5479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18544	\N	f
5480	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185442	\N	f
5481	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185443	\N	f
5482	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185444	\N	f
5483	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185446	\N	f
5484	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185447	\N	f
5485	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185448	\N	f
5486	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18545	\N	f
5487	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185451	\N	f
5488	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185453	\N	f
5489	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185454	\N	f
5490	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185455	\N	f
5492	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185458	\N	f
5493	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185459	\N	f
5494	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185461	\N	f
5495	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185462	\N	f
5496	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.185463	\N	f
5497	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185465	\N	f
5498	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185466	\N	f
5499	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185467	\N	f
5500	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185469	\N	f
5501	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18547	\N	f
5502	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185471	\N	f
5503	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185473	\N	f
5504	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185474	\N	f
5505	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185475	\N	f
5506	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185477	\N	f
5507	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185478	\N	f
5508	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.185479	\N	f
5509	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.185481	\N	f
5510	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.185482	\N	f
5511	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.185483	\N	f
5512	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.185485	\N	f
5513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185486	\N	f
5514	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185487	\N	f
5515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185489	\N	f
5516	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18549	\N	f
5517	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185491	\N	f
5518	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185493	\N	f
5519	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185494	\N	f
5520	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185495	\N	f
5521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185497	\N	f
5522	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.185498	\N	f
5523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185499	\N	f
5524	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185501	\N	f
5525	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185502	\N	f
5526	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185503	\N	f
5527	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185505	\N	f
5528	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185506	\N	f
5529	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185507	\N	f
5530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185509	\N	f
5531	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18551	\N	f
5532	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185512	\N	f
5533	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185513	\N	f
5534	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185514	\N	f
5535	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185516	\N	f
5536	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185517	\N	f
5537	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185518	\N	f
5538	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18552	\N	f
5539	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185521	\N	f
5540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185522	\N	f
5541	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185524	\N	f
5542	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185525	\N	f
5543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185526	\N	f
5544	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185528	\N	f
5545	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185529	\N	f
5546	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18553	\N	f
5547	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185532	\N	f
5548	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185533	\N	f
5549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185534	\N	f
5550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185536	\N	f
5551	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185537	\N	f
5552	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185538	\N	f
5553	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18554	\N	f
5554	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185541	\N	f
5555	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185543	\N	f
5556	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185544	\N	f
5557	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185545	\N	f
5558	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185547	\N	f
5559	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185548	\N	f
5560	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185549	\N	f
5561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185551	\N	f
5562	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185552	\N	f
5563	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185553	\N	f
5564	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185555	\N	f
5565	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185556	\N	f
5566	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185557	\N	f
5567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185559	\N	f
5568	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18556	\N	f
5569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185561	\N	f
5570	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185563	\N	f
5571	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185564	\N	f
5572	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185565	\N	f
5573	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185567	\N	f
5574	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185568	\N	f
5575	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185569	\N	f
5576	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185571	\N	f
5577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185572	\N	f
5578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185573	\N	f
5579	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185575	\N	f
5580	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185576	\N	f
5581	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185577	\N	f
5582	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185579	\N	f
5583	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18558	\N	f
5584	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185581	\N	f
5585	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185583	\N	f
5586	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185584	\N	f
5587	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185585	\N	f
5588	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185587	\N	f
5589	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185588	\N	f
5590	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185589	\N	f
5591	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185591	\N	f
5592	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185592	\N	f
5593	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185593	\N	f
5594	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185595	\N	f
5595	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185596	\N	f
5596	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185597	\N	f
5597	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185599	\N	f
5598	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1856	\N	f
5599	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185601	\N	f
5600	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185603	\N	f
5601	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185604	\N	f
5602	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185605	\N	f
5603	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185607	\N	f
5604	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.185608	\N	f
5605	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185609	\N	f
5606	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18561	\N	f
5607	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185612	\N	f
5608	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185613	\N	f
5609	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185615	\N	f
5610	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185616	\N	f
5611	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185618	\N	f
5612	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185619	\N	f
5613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18562	\N	f
5614	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185622	\N	f
5615	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185623	\N	f
5616	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.185624	\N	f
5617	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.185626	\N	f
5618	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.185627	\N	f
5619	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.185628	\N	f
5620	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.185629	\N	f
5621	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.185631	\N	f
5622	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.185632	\N	f
5623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185633	\N	f
5624	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185635	\N	f
5625	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185636	\N	f
5626	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185637	\N	f
5627	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185639	\N	f
5628	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18564	\N	f
5629	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185641	\N	f
5630	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185643	\N	f
5631	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185644	\N	f
5632	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185645	\N	f
5633	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185647	\N	f
5634	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185648	\N	f
5635	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185649	\N	f
5636	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185651	\N	f
5637	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185652	\N	f
5638	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185653	\N	f
5639	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185655	\N	f
5640	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185656	\N	f
5641	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185657	\N	f
5642	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185658	\N	f
5643	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18566	\N	f
5644	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185661	\N	f
5645	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185662	\N	f
5646	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185664	\N	f
5647	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185665	\N	f
5648	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185666	\N	f
5649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185668	\N	f
5650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185669	\N	f
5651	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18567	\N	f
5652	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185672	\N	f
5653	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185673	\N	f
5654	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185674	\N	f
5655	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185675	\N	f
5656	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185677	\N	f
5657	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185678	\N	f
5658	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185679	\N	f
5659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185681	\N	f
5660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185682	\N	f
5661	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185683	\N	f
5662	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185685	\N	f
5663	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185686	\N	f
5664	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185687	\N	f
5665	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185689	\N	f
5666	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18569	\N	f
5667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185691	\N	f
5668	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185693	\N	f
5669	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185694	\N	f
5670	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185695	\N	f
5671	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185697	\N	f
5672	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185698	\N	f
5673	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185699	\N	f
5674	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185701	\N	f
5675	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185702	\N	f
5676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185703	\N	f
5677	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185705	\N	f
5678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185706	\N	f
5679	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185707	\N	f
5680	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185708	\N	f
5681	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18571	\N	f
5682	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185711	\N	f
5683	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185712	\N	f
5684	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185714	\N	f
5685	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185715	\N	f
5686	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185716	\N	f
5687	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185718	\N	f
5688	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185719	\N	f
5689	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18572	\N	f
5690	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185722	\N	f
5691	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185723	\N	f
5692	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185724	\N	f
5693	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185726	\N	f
5694	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185727	\N	f
5695	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185728	\N	f
5696	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18573	\N	f
5697	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185731	\N	f
5698	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185732	\N	f
5699	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185733	\N	f
5700	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185735	\N	f
5701	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185736	\N	f
5702	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185737	\N	f
5703	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185739	\N	f
5704	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18574	\N	f
5705	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185741	\N	f
5706	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185743	\N	f
5707	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185744	\N	f
5708	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185745	\N	f
5709	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185747	\N	f
5710	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185748	\N	f
5711	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185749	\N	f
5712	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18575	\N	f
5713	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185752	\N	f
5714	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.185753	\N	f
5715	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185754	\N	f
5716	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185756	\N	f
5717	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185757	\N	f
5718	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185758	\N	f
5719	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18576	\N	f
5720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185761	\N	f
5721	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185763	\N	f
5722	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185764	\N	f
5723	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185766	\N	f
5724	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185767	\N	f
5725	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185768	\N	f
5726	555	555	1999	article	draft	\N	16	2025-03-04 00:07:03.18577	\N	f
5727	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.185771	\N	f
5728	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.185772	\N	f
5729	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.185774	\N	f
5730	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.185775	\N	f
5731	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.185776	\N	f
5732	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185778	\N	f
5733	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185779	\N	f
5734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18578	\N	f
5735	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185782	\N	f
5736	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185783	\N	f
5737	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185784	\N	f
5738	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185786	\N	f
5739	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185787	\N	f
5740	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185789	\N	f
5741	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18579	\N	f
5742	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185791	\N	f
5743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185793	\N	f
5744	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185794	\N	f
5745	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185795	\N	f
5746	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185798	\N	f
5747	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185799	\N	f
5748	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185801	\N	f
5749	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185802	\N	f
5750	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185803	\N	f
5751	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185805	\N	f
5752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185806	\N	f
5753	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185807	\N	f
5754	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185809	\N	f
5755	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18581	\N	f
5756	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185811	\N	f
5757	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185813	\N	f
5758	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185814	\N	f
5759	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185815	\N	f
5760	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185817	\N	f
5761	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185818	\N	f
5762	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185819	\N	f
5763	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185821	\N	f
5764	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185822	\N	f
5765	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185823	\N	f
5766	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185825	\N	f
5767	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185826	\N	f
5768	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185827	\N	f
5769	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185829	\N	f
5770	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18583	\N	f
5771	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185831	\N	f
5772	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185833	\N	f
5773	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185834	\N	f
5774	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185835	\N	f
5775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185837	\N	f
5776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185838	\N	f
5777	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185839	\N	f
5778	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185841	\N	f
5779	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185842	\N	f
5780	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185843	\N	f
5781	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185845	\N	f
5782	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185846	\N	f
5783	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185847	\N	f
5784	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185849	\N	f
5785	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18585	\N	f
5786	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185851	\N	f
5787	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185853	\N	f
5788	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185854	\N	f
5789	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185855	\N	f
5790	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185857	\N	f
5791	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185858	\N	f
5792	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185859	\N	f
5793	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18586	\N	f
5794	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185862	\N	f
5795	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185863	\N	f
5796	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185864	\N	f
5797	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185866	\N	f
5798	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185867	\N	f
5799	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185868	\N	f
5800	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18587	\N	f
5801	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185871	\N	f
5802	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185872	\N	f
5803	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185874	\N	f
5804	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185875	\N	f
5805	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185876	\N	f
5806	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185878	\N	f
5807	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185879	\N	f
5809	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185882	\N	f
5810	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185883	\N	f
5811	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185884	\N	f
5812	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185885	\N	f
5813	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185887	\N	f
5814	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185888	\N	f
5815	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185889	\N	f
5816	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185891	\N	f
5817	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185892	\N	f
5818	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185893	\N	f
5819	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185895	\N	f
5820	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185896	\N	f
5821	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185897	\N	f
5822	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.185899	\N	f
5823	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.1859	\N	f
5824	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185901	\N	f
5825	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185903	\N	f
5826	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185904	\N	f
5827	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185905	\N	f
5828	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185907	\N	f
5829	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185908	\N	f
5830	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185909	\N	f
5831	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185911	\N	f
5832	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185912	\N	f
5833	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185913	\N	f
5834	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.185915	\N	f
5835	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.185916	\N	f
5836	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.185917	\N	f
5837	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.185918	\N	f
5838	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.18592	\N	f
5839	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185921	\N	f
5840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185922	\N	f
5841	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185924	\N	f
5842	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185925	\N	f
5843	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185926	\N	f
5844	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185928	\N	f
5845	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185929	\N	f
5846	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18593	\N	f
5847	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185932	\N	f
5848	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.185933	\N	f
5849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185934	\N	f
5850	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185935	\N	f
5851	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185937	\N	f
5852	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185938	\N	f
5853	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185939	\N	f
5854	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185941	\N	f
5855	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185942	\N	f
5856	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185943	\N	f
5857	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185945	\N	f
5858	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185946	\N	f
5859	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185947	\N	f
5860	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185949	\N	f
5861	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18595	\N	f
5862	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185951	\N	f
5863	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185953	\N	f
5864	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185954	\N	f
5865	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185955	\N	f
5866	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185957	\N	f
5867	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185958	\N	f
5868	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185959	\N	f
5869	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185961	\N	f
5870	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185962	\N	f
5871	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185963	\N	f
5872	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185964	\N	f
5873	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185966	\N	f
5874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185967	\N	f
5875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185968	\N	f
5876	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18597	\N	f
5877	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185971	\N	f
5878	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.185972	\N	f
5879	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185974	\N	f
5880	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185975	\N	f
5881	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185976	\N	f
5882	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185978	\N	f
5883	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185979	\N	f
5884	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18598	\N	f
5885	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185981	\N	f
5886	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185983	\N	f
5887	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185984	\N	f
5888	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185985	\N	f
5889	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.185987	\N	f
5890	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185988	\N	f
5891	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185989	\N	f
5892	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185991	\N	f
5893	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185992	\N	f
5894	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185993	\N	f
5895	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185995	\N	f
5896	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.185996	\N	f
5897	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185997	\N	f
5898	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.185998	\N	f
5899	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186	\N	f
5900	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186001	\N	f
5901	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186002	\N	f
5902	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186004	\N	f
5903	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186005	\N	f
5904	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186006	\N	f
5905	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186008	\N	f
5906	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186009	\N	f
5907	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186011	\N	f
5908	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186012	\N	f
5909	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186013	\N	f
5910	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186015	\N	f
5911	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186016	\N	f
5912	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186017	\N	f
5913	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186019	\N	f
5914	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18602	\N	f
5915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186021	\N	f
5916	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186023	\N	f
5917	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186024	\N	f
5918	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186025	\N	f
5919	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186027	\N	f
5920	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186028	\N	f
5921	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186029	\N	f
5922	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186031	\N	f
5923	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186032	\N	f
5924	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186034	\N	f
5925	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186035	\N	f
5926	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186036	\N	f
5927	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186038	\N	f
5928	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186039	\N	f
5929	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.18604	\N	f
5930	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186042	\N	f
5931	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186043	\N	f
5932	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186044	\N	f
5933	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186046	\N	f
5934	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186047	\N	f
5935	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186048	\N	f
5936	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18605	\N	f
5937	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186051	\N	f
5938	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186053	\N	f
5939	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186054	\N	f
5940	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186055	\N	f
5941	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.186057	\N	f
5942	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.186058	\N	f
5943	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.186059	\N	f
5944	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.186061	\N	f
5945	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.186062	\N	f
5946	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.186063	\N	f
5947	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.186065	\N	f
5948	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186066	\N	f
5949	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186067	\N	f
5950	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186069	\N	f
5951	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18607	\N	f
5952	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186071	\N	f
5953	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186073	\N	f
5954	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186074	\N	f
5955	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186075	\N	f
5956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186077	\N	f
5957	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186078	\N	f
5958	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186079	\N	f
5959	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186081	\N	f
5960	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186082	\N	f
5961	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186083	\N	f
5962	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186085	\N	f
5963	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186086	\N	f
5964	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186087	\N	f
5965	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186089	\N	f
5966	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18609	\N	f
5967	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186091	\N	f
5968	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186093	\N	f
5969	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186094	\N	f
5970	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186095	\N	f
5971	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186097	\N	f
5972	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186098	\N	f
5973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186099	\N	f
5974	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186101	\N	f
5975	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186102	\N	f
5976	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186103	\N	f
5977	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186105	\N	f
5978	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186106	\N	f
5979	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186108	\N	f
5980	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186109	\N	f
5981	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18611	\N	f
5982	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186112	\N	f
5983	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186113	\N	f
5984	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186114	\N	f
5985	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186116	\N	f
5986	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186117	\N	f
5987	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186118	\N	f
5988	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186119	\N	f
5989	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186121	\N	f
5990	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186122	\N	f
5991	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186123	\N	f
5992	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186125	\N	f
5993	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186126	\N	f
5994	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186127	\N	f
5995	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186129	\N	f
5996	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18613	\N	f
5997	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186131	\N	f
5998	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186133	\N	f
6126	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186304	\N	f
5999	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186134	\N	f
6000	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186136	\N	f
6001	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186137	\N	f
6002	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186138	\N	f
6003	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186139	\N	f
6004	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186141	\N	f
6005	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186142	\N	f
6006	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186143	\N	f
6007	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186145	\N	f
6008	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186146	\N	f
6009	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186147	\N	f
6010	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186149	\N	f
6011	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18615	\N	f
6012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186151	\N	f
6013	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186152	\N	f
6014	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186154	\N	f
6015	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186155	\N	f
6016	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186156	\N	f
6017	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186158	\N	f
6018	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18616	\N	f
6019	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186161	\N	f
6020	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186162	\N	f
6021	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186164	\N	f
6022	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186165	\N	f
6023	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186166	\N	f
6024	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186168	\N	f
6025	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186169	\N	f
6026	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.18617	\N	f
6027	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186172	\N	f
6028	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186173	\N	f
6029	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186174	\N	f
6030	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186175	\N	f
6031	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186177	\N	f
6032	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186178	\N	f
6033	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186179	\N	f
6034	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186181	\N	f
6035	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186182	\N	f
6036	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186183	\N	f
6037	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186185	\N	f
6038	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.186186	\N	f
6039	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186187	\N	f
6040	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186189	\N	f
6041	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18619	\N	f
6042	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186191	\N	f
6043	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186193	\N	f
6044	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186194	\N	f
6045	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186195	\N	f
6046	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186196	\N	f
6047	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186198	\N	f
6048	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186199	\N	f
6049	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.1862	\N	f
6050	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186202	\N	f
6051	555	555	1999	article	draft	\N	16	2025-03-04 00:07:03.186203	\N	f
6052	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.186204	\N	f
6053	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.186206	\N	f
6054	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.186207	\N	f
6055	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.186208	\N	f
6056	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.18621	\N	f
6057	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186211	\N	f
6058	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186212	\N	f
6059	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186214	\N	f
6060	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186215	\N	f
6061	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186216	\N	f
6062	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186218	\N	f
6063	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186219	\N	f
6064	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18622	\N	f
6065	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186222	\N	f
6066	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186223	\N	f
6067	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186224	\N	f
6068	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186226	\N	f
6069	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186227	\N	f
6070	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186228	\N	f
6071	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186229	\N	f
6072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186231	\N	f
6073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186232	\N	f
6074	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186233	\N	f
6075	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186235	\N	f
6076	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186236	\N	f
6077	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186237	\N	f
6078	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186239	\N	f
6079	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18624	\N	f
6080	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186241	\N	f
6081	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186243	\N	f
6082	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186244	\N	f
6083	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186245	\N	f
6084	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186247	\N	f
6085	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186248	\N	f
6086	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186249	\N	f
6087	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18625	\N	f
6088	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186252	\N	f
6089	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186253	\N	f
6090	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186255	\N	f
6091	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186256	\N	f
6092	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186257	\N	f
6093	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186259	\N	f
6094	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18626	\N	f
6095	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186261	\N	f
6096	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186263	\N	f
6097	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186265	\N	f
6098	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186266	\N	f
6099	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186267	\N	f
6100	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186269	\N	f
6101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18627	\N	f
6102	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186271	\N	f
6103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186273	\N	f
6104	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186274	\N	f
6105	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186275	\N	f
6106	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186277	\N	f
6107	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186278	\N	f
6108	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18628	\N	f
6109	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186281	\N	f
6110	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186282	\N	f
6111	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186284	\N	f
6112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186285	\N	f
6113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186286	\N	f
6114	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186288	\N	f
6115	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186289	\N	f
6116	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.18629	\N	f
6117	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186292	\N	f
6118	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186293	\N	f
6119	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186294	\N	f
6120	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186296	\N	f
6121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186297	\N	f
6122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186298	\N	f
6123	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1863	\N	f
6124	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186301	\N	f
6125	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186302	\N	f
6127	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.186305	\N	f
6128	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186306	\N	f
6129	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186308	\N	f
6130	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186309	\N	f
6131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18631	\N	f
6132	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186312	\N	f
6133	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186313	\N	f
6134	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186315	\N	f
6135	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186316	\N	f
6136	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186317	\N	f
6137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186319	\N	f
6138	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18632	\N	f
6139	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186321	\N	f
6140	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186323	\N	f
6141	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186324	\N	f
6142	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186326	\N	f
6143	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186327	\N	f
6144	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186328	\N	f
6145	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18633	\N	f
6146	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186331	\N	f
6147	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.186332	\N	f
6148	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186334	\N	f
6149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186335	\N	f
6150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186336	\N	f
6151	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186338	\N	f
6152	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186339	\N	f
6153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18634	\N	f
6154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186342	\N	f
6155	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186343	\N	f
6156	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186344	\N	f
6157	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186346	\N	f
6158	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186347	\N	f
6159	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.186348	\N	f
6160	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18635	\N	f
6161	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.186351	\N	f
6162	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.186352	\N	f
6163	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.186354	\N	f
6164	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.186355	\N	f
6165	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186356	\N	f
6166	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186358	\N	f
6167	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186359	\N	f
6168	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18636	\N	f
6169	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186362	\N	f
6170	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186363	\N	f
6171	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186364	\N	f
6172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186365	\N	f
6173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186367	\N	f
6174	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.186368	\N	f
6175	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18637	\N	f
6176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186371	\N	f
6177	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186372	\N	f
6178	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186374	\N	f
6179	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186375	\N	f
6180	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186376	\N	f
6181	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186378	\N	f
6182	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186379	\N	f
6183	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186381	\N	f
6184	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186382	\N	f
6185	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186383	\N	f
6186	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186385	\N	f
6187	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186386	\N	f
6188	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186387	\N	f
6189	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186389	\N	f
6190	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18639	\N	f
6191	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186391	\N	f
6192	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186392	\N	f
6193	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186394	\N	f
6194	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186395	\N	f
6195	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186396	\N	f
6196	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186398	\N	f
6197	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186399	\N	f
6198	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1864	\N	f
6199	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186402	\N	f
6200	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186403	\N	f
6201	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186404	\N	f
6202	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186406	\N	f
6203	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186407	\N	f
6204	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186408	\N	f
6205	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18641	\N	f
6206	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186411	\N	f
6207	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186412	\N	f
6208	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186414	\N	f
6209	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186415	\N	f
6210	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186416	\N	f
6211	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186417	\N	f
6212	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186419	\N	f
6213	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18642	\N	f
6214	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186421	\N	f
6215	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186423	\N	f
6216	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186424	\N	f
6217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186426	\N	f
6218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186427	\N	f
6219	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186428	\N	f
6220	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186429	\N	f
6221	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186431	\N	f
6222	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186432	\N	f
6223	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186433	\N	f
6224	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186435	\N	f
6225	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186436	\N	f
6226	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186437	\N	f
6227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186439	\N	f
6228	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18644	\N	f
6229	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186441	\N	f
6230	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186443	\N	f
6231	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186444	\N	f
6232	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186445	\N	f
6233	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186447	\N	f
6234	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186448	\N	f
6235	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186449	\N	f
6236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186451	\N	f
6237	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186452	\N	f
6238	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186453	\N	f
6239	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186455	\N	f
6240	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186456	\N	f
6241	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186457	\N	f
6242	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186458	\N	f
6243	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.18646	\N	f
6244	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186461	\N	f
6245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186462	\N	f
6246	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186464	\N	f
6247	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186465	\N	f
6248	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186466	\N	f
6249	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186468	\N	f
6250	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186469	\N	f
6251	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18647	\N	f
6252	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186472	\N	f
6253	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186473	\N	f
6254	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.186474	\N	f
6255	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186476	\N	f
6256	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186477	\N	f
6257	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186478	\N	f
6258	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.18648	\N	f
6259	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186481	\N	f
6260	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186482	\N	f
6261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186483	\N	f
6262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186485	\N	f
6263	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186486	\N	f
6264	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186487	\N	f
6265	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186489	\N	f
6266	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.18649	\N	f
6267	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.186491	\N	f
6268	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.186493	\N	f
6269	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.186494	\N	f
6270	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.186495	\N	f
6271	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.186496	\N	f
6272	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.186498	\N	f
6273	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.186499	\N	f
6274	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.1865	\N	f
6275	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186502	\N	f
6276	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186503	\N	f
6277	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186505	\N	f
6278	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186506	\N	f
6279	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186507	\N	f
6280	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.186508	\N	f
6281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18651	\N	f
6282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186511	\N	f
6283	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186513	\N	f
6284	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186514	\N	f
6285	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186515	\N	f
6286	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186517	\N	f
6287	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186518	\N	f
6288	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186519	\N	f
6289	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186521	\N	f
6290	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186522	\N	f
6291	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.186523	\N	f
6292	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186525	\N	f
6293	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186526	\N	f
6294	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186527	\N	f
6295	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186529	\N	f
6296	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18653	\N	f
6297	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186532	\N	f
6298	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186533	\N	f
6299	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186534	\N	f
6300	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186536	\N	f
6301	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186537	\N	f
6302	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.186538	\N	f
6303	ddsdf	test1ы	2015	article	draft	\N	16	2025-03-04 00:07:03.18654	\N	f
6304	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186541	\N	f
6305	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186542	\N	f
6306	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186543	\N	f
6307	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186545	\N	f
6308	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186546	\N	f
6309	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186547	\N	f
6310	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186549	\N	f
6311	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18655	\N	f
6312	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186551	\N	f
6313	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186553	\N	f
6314	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186554	\N	f
6315	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186556	\N	f
6316	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186557	\N	f
6317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186558	\N	f
6318	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18656	\N	f
6319	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186561	\N	f
6320	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186562	\N	f
6321	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186564	\N	f
6322	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186565	\N	f
6323	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186566	\N	f
6324	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186568	\N	f
6325	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186569	\N	f
6326	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186571	\N	f
6327	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186572	\N	f
6328	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186573	\N	f
6329	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186575	\N	f
6330	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186576	\N	f
6331	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186577	\N	f
6332	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186579	\N	f
6333	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18658	\N	f
6334	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186581	\N	f
6335	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186583	\N	f
6336	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186584	\N	f
6337	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186585	\N	f
6338	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186587	\N	f
6339	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186588	\N	f
6340	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186589	\N	f
6341	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186591	\N	f
6342	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186592	\N	f
6343	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186593	\N	f
6344	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186595	\N	f
6345	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186596	\N	f
6346	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186597	\N	f
6347	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186599	\N	f
6348	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1866	\N	f
6349	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186601	\N	f
6350	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186603	\N	f
6351	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186604	\N	f
6352	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186605	\N	f
6353	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186607	\N	f
6354	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186608	\N	f
6355	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186609	\N	f
6356	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186611	\N	f
6357	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186612	\N	f
6358	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186613	\N	f
6359	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186615	\N	f
6360	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186616	\N	f
6361	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186617	\N	f
6362	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186619	\N	f
6363	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.18662	\N	f
6364	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.186621	\N	f
6365	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186623	\N	f
6366	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186624	\N	f
6367	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186625	\N	f
6368	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186627	\N	f
6369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186628	\N	f
6370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186629	\N	f
6371	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	draft	\N	16	2025-03-04 00:07:03.186631	\N	f
6372	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186632	\N	f
6373	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186633	\N	f
6374	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186634	\N	f
6375	длолд111111111111111111111	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186636	\N	f
6376	555	555ы	1999	article	draft	\N	16	2025-03-04 00:07:03.186637	\N	f
6377	ываы	ваыва	1999	article	draft	\N	16	2025-03-04 00:07:03.186638	\N	f
6378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18664	\N	f
6379	df	dsf	2011	article	draft	\N	16	2025-03-04 00:07:03.186641	\N	f
6380	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.186642	\N	f
7139	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187736	\N	f
6381	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.186644	\N	f
6382	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.186645	\N	f
6383	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.186646	\N	f
6384	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.186648	\N	f
6385	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186649	\N	f
6386	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18665	\N	f
6387	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186652	\N	f
6388	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186653	\N	f
6389	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186654	\N	f
6390	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186656	\N	f
6391	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186657	\N	f
6392	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186658	\N	f
6393	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18666	\N	f
6394	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186661	\N	f
6395	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186662	\N	f
6396	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186663	\N	f
6397	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186665	\N	f
6398	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186666	\N	f
6399	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186667	\N	f
6400	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.186669	\N	f
6401	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18667	\N	f
6402	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186671	\N	f
6403	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186673	\N	f
6404	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186674	\N	f
6405	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186675	\N	f
6406	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186677	\N	f
6407	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186678	\N	f
6408	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186679	\N	f
6409	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186681	\N	f
6410	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186682	\N	f
6411	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186683	\N	f
6412	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186685	\N	f
6413	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186686	\N	f
6414	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186687	\N	f
6415	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186688	\N	f
6416	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18669	\N	f
6417	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186691	\N	f
6418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186692	\N	f
6419	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186694	\N	f
6420	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186695	\N	f
6421	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186696	\N	f
6422	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186698	\N	f
6423	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186699	\N	f
6424	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.1867	\N	f
6425	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186702	\N	f
6426	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186703	\N	f
6427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186704	\N	f
6428	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186705	\N	f
6429	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186707	\N	f
6430	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186708	\N	f
6431	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186709	\N	f
6432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186711	\N	f
6433	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186712	\N	f
6434	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186713	\N	f
6435	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186715	\N	f
6436	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186716	\N	f
6437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186717	\N	f
6438	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186719	\N	f
6439	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18672	\N	f
6440	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186721	\N	f
6441	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186722	\N	f
6442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186724	\N	f
6443	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186725	\N	f
6444	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186726	\N	f
6445	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186728	\N	f
6446	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186729	\N	f
6447	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18673	\N	f
6448	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186732	\N	f
6449	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186733	\N	f
6450	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186734	\N	f
6451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186736	\N	f
6452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186737	\N	f
6453	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186738	\N	f
6454	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186739	\N	f
6455	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186741	\N	f
6456	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186742	\N	f
6457	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186744	\N	f
6458	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186745	\N	f
6459	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186746	\N	f
6460	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186748	\N	f
6461	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186749	\N	f
6462	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18675	\N	f
6463	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186752	\N	f
6464	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186753	\N	f
6465	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186754	\N	f
6466	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186756	\N	f
6467	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186757	\N	f
6468	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186758	\N	f
6469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18676	\N	f
6470	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186761	\N	f
6471	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186763	\N	f
6472	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186764	\N	f
6473	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186765	\N	f
6474	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186767	\N	f
6475	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.186768	\N	f
6476	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186769	\N	f
6477	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186771	\N	f
6478	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186772	\N	f
6479	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186773	\N	f
6480	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186775	\N	f
6481	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186776	\N	f
6482	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186777	\N	f
6483	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186779	\N	f
6484	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18678	\N	f
6485	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186781	\N	f
6486	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186783	\N	f
6487	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.186784	\N	f
6488	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186785	\N	f
6489	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.186786	\N	f
6490	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.186788	\N	f
6491	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.186789	\N	f
6492	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.18679	\N	f
6493	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186792	\N	f
6494	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186793	\N	f
6495	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186795	\N	f
6496	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186796	\N	f
6497	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186797	\N	f
6498	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186799	\N	f
6499	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.1868	\N	f
6500	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186801	\N	f
6501	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186803	\N	f
6502	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.186804	\N	f
6503	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186805	\N	f
6504	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186808	\N	f
6505	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18681	\N	f
6506	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186811	\N	f
7140	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187737	\N	f
6507	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186813	\N	f
6508	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186814	\N	f
6509	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186815	\N	f
6510	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186817	\N	f
6511	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186818	\N	f
6512	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186819	\N	f
6513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186821	\N	f
6514	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186822	\N	f
6515	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186823	\N	f
6516	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186825	\N	f
6517	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186826	\N	f
6518	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186827	\N	f
6519	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186829	\N	f
6520	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18683	\N	f
6521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186832	\N	f
6522	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186833	\N	f
6523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186834	\N	f
6524	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186835	\N	f
6525	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186837	\N	f
6526	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186838	\N	f
6527	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186839	\N	f
6528	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186841	\N	f
6529	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186842	\N	f
6530	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186843	\N	f
6531	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186845	\N	f
6532	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186846	\N	f
6533	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186847	\N	f
6534	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186849	\N	f
6535	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18685	\N	f
6536	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186851	\N	f
6537	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186853	\N	f
6538	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186854	\N	f
6539	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186855	\N	f
6540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186856	\N	f
6541	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186858	\N	f
6542	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186859	\N	f
6543	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18686	\N	f
6544	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186862	\N	f
6545	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186863	\N	f
6546	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186864	\N	f
6547	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186866	\N	f
6548	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186867	\N	f
6549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186868	\N	f
6550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18687	\N	f
6551	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186871	\N	f
6552	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186872	\N	f
6553	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186874	\N	f
6554	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186875	\N	f
6555	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186876	\N	f
6556	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186878	\N	f
6557	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186879	\N	f
6558	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18688	\N	f
6559	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186882	\N	f
6560	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186883	\N	f
6561	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186884	\N	f
6562	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186886	\N	f
6563	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186887	\N	f
6564	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186889	\N	f
6565	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18689	\N	f
6566	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186892	\N	f
6567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186893	\N	f
6568	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186895	\N	f
6569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186896	\N	f
6570	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186898	\N	f
6571	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186899	\N	f
6572	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.1869	\N	f
6573	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186902	\N	f
6574	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186903	\N	f
6575	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186905	\N	f
6576	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186906	\N	f
6577	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186907	\N	f
6578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186909	\N	f
6579	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18691	\N	f
6580	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186911	\N	f
6581	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186913	\N	f
6582	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186914	\N	f
6583	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.186915	\N	f
6584	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186917	\N	f
6585	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186918	\N	f
6586	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18692	\N	f
6587	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186921	\N	f
6588	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186922	\N	f
6589	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186924	\N	f
6590	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186925	\N	f
6591	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186926	\N	f
6592	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186928	\N	f
6593	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186929	\N	f
6594	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.18693	\N	f
6595	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.186932	\N	f
6596	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.186933	\N	f
6597	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.186934	\N	f
6598	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186936	\N	f
6599	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.186937	\N	f
6600	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.186938	\N	f
6601	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.18694	\N	f
6602	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.186941	\N	f
6603	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186942	\N	f
6604	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186944	\N	f
6605	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186945	\N	f
6606	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186946	\N	f
6607	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186948	\N	f
6608	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186949	\N	f
6609	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18695	\N	f
6610	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186952	\N	f
6611	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186953	\N	f
6612	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186954	\N	f
6613	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186956	\N	f
6614	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186957	\N	f
6615	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186958	\N	f
6616	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18696	\N	f
6617	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186961	\N	f
6618	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186962	\N	f
6619	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186964	\N	f
6620	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186965	\N	f
6621	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186967	\N	f
6622	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186968	\N	f
6623	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186969	\N	f
6624	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186971	\N	f
6625	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186972	\N	f
6626	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186973	\N	f
6627	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186975	\N	f
6628	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186976	\N	f
6629	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186978	\N	f
6630	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186979	\N	f
6631	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18698	\N	f
6632	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186982	\N	f
7585	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18838	\N	f
6633	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186983	\N	f
6634	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186984	\N	f
6635	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186986	\N	f
6636	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186987	\N	f
6637	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186988	\N	f
6638	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186989	\N	f
6639	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186991	\N	f
6640	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.186992	\N	f
6641	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.186993	\N	f
6642	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186995	\N	f
6643	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.186996	\N	f
6644	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186998	\N	f
6645	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.186999	\N	f
6646	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187	\N	f
6647	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187001	\N	f
6648	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187003	\N	f
6649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187004	\N	f
6650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187005	\N	f
6651	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187007	\N	f
6652	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187008	\N	f
6653	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187009	\N	f
6654	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187011	\N	f
6655	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187012	\N	f
6656	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187013	\N	f
6657	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187015	\N	f
6658	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187016	\N	f
6659	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187017	\N	f
6660	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187019	\N	f
6661	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18702	\N	f
6662	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187021	\N	f
6663	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187023	\N	f
6664	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187024	\N	f
6665	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187025	\N	f
6666	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187027	\N	f
6667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187028	\N	f
6668	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187029	\N	f
6669	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18703	\N	f
6670	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187032	\N	f
6671	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187033	\N	f
6672	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187034	\N	f
6673	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187036	\N	f
6674	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187037	\N	f
6675	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187038	\N	f
6676	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18704	\N	f
6677	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187041	\N	f
6678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187042	\N	f
6679	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187044	\N	f
6680	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187045	\N	f
6681	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187046	\N	f
6682	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187048	\N	f
6683	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187049	\N	f
6684	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18705	\N	f
6685	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187052	\N	f
6686	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187053	\N	f
6687	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187054	\N	f
6688	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187055	\N	f
6689	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187057	\N	f
6690	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187058	\N	f
6691	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187059	\N	f
6692	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187061	\N	f
6693	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.187062	\N	f
6694	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187064	\N	f
6695	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187065	\N	f
7586	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188381	\N	f
6696	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187066	\N	f
6697	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187067	\N	f
6698	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187069	\N	f
6699	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18707	\N	f
6700	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187072	\N	f
6701	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187073	\N	f
6702	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187074	\N	f
6703	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187076	\N	f
6704	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187077	\N	f
6705	555	555	1999	article	draft	\N	16	2025-03-04 00:07:03.187078	\N	f
6706	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.18708	\N	f
6707	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.187081	\N	f
6708	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187082	\N	f
6709	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.187083	\N	f
6710	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.187085	\N	f
6711	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.187086	\N	f
6712	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187087	\N	f
6713	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187089	\N	f
6714	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18709	\N	f
6715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187091	\N	f
6716	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187093	\N	f
6717	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187094	\N	f
6718	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187095	\N	f
6719	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187097	\N	f
6720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187098	\N	f
6721	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187099	\N	f
6722	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187101	\N	f
6723	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187102	\N	f
6724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187103	\N	f
6725	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187105	\N	f
6726	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187106	\N	f
6727	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187107	\N	f
6728	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187109	\N	f
6729	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18711	\N	f
6730	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187111	\N	f
6731	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187112	\N	f
6732	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187114	\N	f
6733	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187115	\N	f
6734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187116	\N	f
6735	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187118	\N	f
6736	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187119	\N	f
6737	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18712	\N	f
6738	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187122	\N	f
6739	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187123	\N	f
6740	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187124	\N	f
6741	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187126	\N	f
6742	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187127	\N	f
6743	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187128	\N	f
6744	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187129	\N	f
6745	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187131	\N	f
6746	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187132	\N	f
6747	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187133	\N	f
6748	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187135	\N	f
6749	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187136	\N	f
6750	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187137	\N	f
6751	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187139	\N	f
6752	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18714	\N	f
6753	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187141	\N	f
6754	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187143	\N	f
6755	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187144	\N	f
6756	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187146	\N	f
6757	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187147	\N	f
6758	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187148	\N	f
6759	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18715	\N	f
6760	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187151	\N	f
6761	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187152	\N	f
6762	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187154	\N	f
6763	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187155	\N	f
6764	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187157	\N	f
6765	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187158	\N	f
6766	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187159	\N	f
6767	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187161	\N	f
6768	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187162	\N	f
6769	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187163	\N	f
6770	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187165	\N	f
6771	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187166	\N	f
6772	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187167	\N	f
6773	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187169	\N	f
6774	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18717	\N	f
6775	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187171	\N	f
6776	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187173	\N	f
6777	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187174	\N	f
6778	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187175	\N	f
6779	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187177	\N	f
6780	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187178	\N	f
6781	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18718	\N	f
6782	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187181	\N	f
6783	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187182	\N	f
6784	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187183	\N	f
6785	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187185	\N	f
6786	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187186	\N	f
6787	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187187	\N	f
6788	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187189	\N	f
6789	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187191	\N	f
6790	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187192	\N	f
6791	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187193	\N	f
6792	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187195	\N	f
6793	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187196	\N	f
6794	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187197	\N	f
6795	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187199	\N	f
6796	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.1872	\N	f
6797	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187201	\N	f
6798	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187203	\N	f
6799	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187204	\N	f
6800	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187205	\N	f
6801	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187207	\N	f
6802	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.187208	\N	f
6803	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18721	\N	f
6804	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187211	\N	f
6805	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187212	\N	f
6806	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187214	\N	f
6807	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187215	\N	f
6808	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187216	\N	f
6809	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187218	\N	f
6810	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187219	\N	f
6811	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18722	\N	f
6812	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187222	\N	f
6813	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187223	\N	f
6814	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.187224	\N	f
6815	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.187225	\N	f
6816	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.187227	\N	f
6817	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.187228	\N	f
6818	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187229	\N	f
6819	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.187231	\N	f
6820	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187232	\N	f
6821	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187234	\N	f
6822	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187235	\N	f
6823	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187237	\N	f
6824	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187238	\N	f
6825	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18724	\N	f
6826	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187241	\N	f
6827	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187242	\N	f
6828	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.187244	\N	f
6829	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187245	\N	f
6830	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187246	\N	f
6831	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187248	\N	f
6832	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187249	\N	f
6833	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187251	\N	f
6834	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187252	\N	f
6835	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187253	\N	f
6836	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187255	\N	f
6837	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187256	\N	f
6838	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187257	\N	f
6839	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187259	\N	f
6840	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18726	\N	f
6841	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187261	\N	f
6842	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187263	\N	f
6843	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187264	\N	f
6844	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187266	\N	f
6845	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187267	\N	f
6846	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187268	\N	f
6847	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18727	\N	f
6848	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187271	\N	f
6849	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187273	\N	f
6850	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187274	\N	f
6851	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187275	\N	f
6852	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187277	\N	f
6853	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187278	\N	f
6854	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187279	\N	f
6855	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18728	\N	f
6856	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187282	\N	f
6857	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187283	\N	f
6858	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187285	\N	f
6859	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187286	\N	f
6860	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187287	\N	f
6861	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187289	\N	f
6862	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18729	\N	f
6863	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187292	\N	f
6864	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187293	\N	f
6865	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187294	\N	f
6866	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187296	\N	f
6867	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187297	\N	f
6868	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187299	\N	f
6869	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.1873	\N	f
6870	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187301	\N	f
6871	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187302	\N	f
6872	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187304	\N	f
6873	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187305	\N	f
6874	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187307	\N	f
6875	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187308	\N	f
6876	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187309	\N	f
6877	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187311	\N	f
6878	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187312	\N	f
6879	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187314	\N	f
6880	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187315	\N	f
6881	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187317	\N	f
6882	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187318	\N	f
6883	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187319	\N	f
6884	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187321	\N	f
6885	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187323	\N	f
6886	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187325	\N	f
6887	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187327	\N	f
6888	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187329	\N	f
6889	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187331	\N	f
6890	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187333	\N	f
6891	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187336	\N	f
6892	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18734	\N	f
6893	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187342	\N	f
6894	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187346	\N	f
6895	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187349	\N	f
6896	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187351	\N	f
6897	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187353	\N	f
6898	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187355	\N	f
6899	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187357	\N	f
6900	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187359	\N	f
6901	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187362	\N	f
6902	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187364	\N	f
6903	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187366	\N	f
6904	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187368	\N	f
6905	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187372	\N	f
6906	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187375	\N	f
6907	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187377	\N	f
6908	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187379	\N	f
6909	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187382	\N	f
6910	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.187383	\N	f
6911	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187387	\N	f
6912	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187389	\N	f
6913	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187392	\N	f
6914	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187395	\N	f
6915	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187397	\N	f
6916	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187399	\N	f
6917	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187401	\N	f
6918	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187404	\N	f
6919	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187407	\N	f
6920	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187409	\N	f
6921	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187411	\N	f
6922	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.187413	\N	f
6923	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.187414	\N	f
6924	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.187417	\N	f
6925	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.187419	\N	f
6926	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.187421	\N	f
6927	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.187424	\N	f
6928	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187426	\N	f
6929	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.187429	\N	f
6930	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187431	\N	f
6931	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187434	\N	f
6932	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187436	\N	f
6933	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187438	\N	f
6934	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18744	\N	f
6935	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187442	\N	f
6936	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187446	\N	f
6937	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187449	\N	f
6938	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187451	\N	f
6939	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187454	\N	f
6940	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187456	\N	f
6941	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187459	\N	f
6942	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187462	\N	f
6943	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187465	\N	f
6944	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187468	\N	f
6945	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18747	\N	f
6946	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187472	\N	f
6947	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187474	\N	f
6948	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187475	\N	f
7713	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188539	\N	f
6949	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187477	\N	f
6950	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187478	\N	f
6951	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18748	\N	f
6952	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187481	\N	f
6953	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187482	\N	f
6954	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187484	\N	f
6955	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187485	\N	f
6956	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187487	\N	f
6957	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187488	\N	f
6958	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18749	\N	f
6959	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187491	\N	f
6960	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187492	\N	f
6961	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187494	\N	f
6962	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187495	\N	f
6963	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187497	\N	f
6964	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187498	\N	f
6965	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187499	\N	f
6966	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187501	\N	f
6967	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187502	\N	f
6968	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187504	\N	f
6969	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187505	\N	f
6970	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187506	\N	f
6971	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187508	\N	f
6972	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187509	\N	f
6973	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18751	\N	f
6974	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187512	\N	f
6975	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187513	\N	f
6976	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187515	\N	f
6977	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187516	\N	f
6978	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187517	\N	f
6979	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187519	\N	f
6980	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18752	\N	f
6981	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187521	\N	f
6982	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187523	\N	f
6983	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187524	\N	f
6984	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187526	\N	f
6985	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187527	\N	f
6986	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187528	\N	f
6987	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18753	\N	f
6988	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187531	\N	f
6989	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187532	\N	f
6990	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187534	\N	f
6991	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187535	\N	f
6992	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187536	\N	f
6993	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187538	\N	f
6994	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187539	\N	f
6995	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187541	\N	f
6996	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187542	\N	f
6997	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187543	\N	f
6998	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187545	\N	f
6999	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187546	\N	f
7000	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187547	\N	f
7001	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187549	\N	f
7002	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18755	\N	f
7003	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187551	\N	f
7004	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187553	\N	f
7005	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187554	\N	f
7006	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187555	\N	f
7007	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187557	\N	f
7008	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187558	\N	f
7009	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18756	\N	f
7010	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187561	\N	f
7011	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187562	\N	f
7012	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187564	\N	f
7013	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187565	\N	f
7014	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187567	\N	f
7015	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187568	\N	f
7016	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187569	\N	f
7017	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187571	\N	f
7018	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187572	\N	f
7019	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187573	\N	f
7020	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.187575	\N	f
7021	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187576	\N	f
7022	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187577	\N	f
7023	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187579	\N	f
7024	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18758	\N	f
7025	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187581	\N	f
7026	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187583	\N	f
7027	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187584	\N	f
7028	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187585	\N	f
7029	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187587	\N	f
7030	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187588	\N	f
7031	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187589	\N	f
7032	555	555	1999	article	draft	\N	16	2025-03-04 00:07:03.187591	\N	f
7033	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.187592	\N	f
7034	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.187594	\N	f
7035	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.187595	\N	f
7036	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.187596	\N	f
7037	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.187598	\N	f
7038	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187599	\N	f
7039	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.1876	\N	f
7040	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187602	\N	f
7041	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187603	\N	f
7042	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187604	\N	f
7043	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187606	\N	f
7044	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187607	\N	f
7045	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187608	\N	f
7046	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18761	\N	f
7047	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187611	\N	f
7048	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187613	\N	f
7049	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187614	\N	f
7050	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187615	\N	f
7051	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187617	\N	f
7052	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187618	\N	f
7053	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18762	\N	f
7054	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187621	\N	f
7055	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187622	\N	f
7056	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187624	\N	f
7057	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187625	\N	f
7058	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187626	\N	f
7059	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187628	\N	f
7060	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187629	\N	f
7061	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18763	\N	f
7062	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187632	\N	f
7063	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187633	\N	f
7064	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187634	\N	f
7065	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187636	\N	f
7066	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187637	\N	f
7067	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187639	\N	f
7068	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18764	\N	f
7069	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187641	\N	f
7070	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187643	\N	f
7071	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187644	\N	f
7072	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187645	\N	f
7073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187647	\N	f
7074	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187648	\N	f
7075	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18765	\N	f
7076	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187651	\N	f
7077	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187652	\N	f
7078	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187654	\N	f
7079	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187655	\N	f
7080	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187657	\N	f
7081	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187658	\N	f
7082	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187659	\N	f
7083	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187661	\N	f
7084	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187662	\N	f
7085	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187663	\N	f
7086	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187665	\N	f
7087	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187666	\N	f
7088	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187667	\N	f
7089	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187668	\N	f
7090	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18767	\N	f
7091	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187671	\N	f
7092	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187673	\N	f
7093	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187674	\N	f
7094	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187675	\N	f
7095	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187677	\N	f
7096	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187678	\N	f
7097	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187679	\N	f
7098	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187681	\N	f
7099	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187682	\N	f
7100	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187683	\N	f
7101	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187684	\N	f
7102	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187686	\N	f
7103	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187687	\N	f
7104	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187688	\N	f
7105	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18769	\N	f
7106	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187691	\N	f
7107	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187692	\N	f
7108	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187694	\N	f
7109	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187695	\N	f
7110	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187696	\N	f
7111	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187698	\N	f
7112	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187699	\N	f
7113	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187701	\N	f
7114	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187702	\N	f
7115	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187703	\N	f
7116	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187705	\N	f
7117	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187706	\N	f
7118	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187707	\N	f
7119	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187709	\N	f
7120	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18771	\N	f
7121	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187711	\N	f
7122	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187713	\N	f
7123	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187714	\N	f
7124	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187715	\N	f
7125	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187717	\N	f
7126	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187718	\N	f
7127	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187719	\N	f
7128	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187721	\N	f
7129	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.187722	\N	f
7130	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187724	\N	f
7131	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187725	\N	f
7132	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187727	\N	f
7133	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187728	\N	f
7134	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187729	\N	f
7135	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187731	\N	f
7136	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187732	\N	f
7137	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187733	\N	f
7138	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187735	\N	f
7141	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.187739	\N	f
7142	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.18774	\N	f
7143	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.187742	\N	f
7144	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.187743	\N	f
7145	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.187744	\N	f
7146	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187746	\N	f
7147	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187747	\N	f
7148	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187748	\N	f
7149	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18775	\N	f
7150	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187751	\N	f
7151	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187753	\N	f
7152	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187754	\N	f
7153	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187755	\N	f
7154	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187757	\N	f
7155	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.187758	\N	f
7156	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187759	\N	f
7157	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187761	\N	f
7158	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187762	\N	f
7159	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187764	\N	f
7160	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187765	\N	f
7161	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187766	\N	f
7162	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187768	\N	f
7163	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187769	\N	f
7164	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18777	\N	f
7165	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187772	\N	f
7166	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187773	\N	f
7167	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187774	\N	f
7168	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187776	\N	f
7169	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187777	\N	f
7170	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187779	\N	f
7171	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18778	\N	f
7172	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187782	\N	f
7173	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187783	\N	f
7174	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187784	\N	f
7175	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187786	\N	f
7176	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187787	\N	f
7177	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187788	\N	f
7178	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18779	\N	f
7179	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187791	\N	f
7180	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187792	\N	f
7181	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187794	\N	f
7182	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187795	\N	f
7183	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187797	\N	f
7184	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187798	\N	f
7185	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187802	\N	f
7186	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187803	\N	f
7187	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187804	\N	f
7188	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187806	\N	f
7189	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187807	\N	f
7190	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187809	\N	f
7191	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18781	\N	f
7192	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187811	\N	f
7193	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187813	\N	f
7194	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187814	\N	f
7195	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187815	\N	f
7196	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187817	\N	f
7197	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187818	\N	f
7198	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187819	\N	f
7199	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187821	\N	f
7200	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187822	\N	f
7201	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187823	\N	f
7202	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187825	\N	f
7203	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187826	\N	f
7204	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187828	\N	f
7205	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187829	\N	f
7206	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18783	\N	f
7207	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187832	\N	f
7208	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187833	\N	f
7209	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187835	\N	f
7210	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187836	\N	f
7211	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187837	\N	f
7212	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187839	\N	f
7213	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18784	\N	f
7214	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.187841	\N	f
7215	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187843	\N	f
7216	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187844	\N	f
7217	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187845	\N	f
7218	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187847	\N	f
7219	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187848	\N	f
7220	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18785	\N	f
7221	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187851	\N	f
7222	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187852	\N	f
7223	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187854	\N	f
7224	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187855	\N	f
7225	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187856	\N	f
7226	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187858	\N	f
7227	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187859	\N	f
7228	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18786	\N	f
7229	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187862	\N	f
7230	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187863	\N	f
7231	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187865	\N	f
7232	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187866	\N	f
7233	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187867	\N	f
7234	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187869	\N	f
7235	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.18787	\N	f
7236	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187872	\N	f
7237	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.187873	\N	f
7238	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187874	\N	f
7239	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187876	\N	f
7240	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187877	\N	f
7241	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187878	\N	f
7242	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18788	\N	f
7243	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187881	\N	f
7244	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187883	\N	f
7245	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187884	\N	f
7246	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187885	\N	f
7247	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187887	\N	f
7248	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187888	\N	f
7249	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.18789	\N	f
7250	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.187891	\N	f
7251	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.187892	\N	f
7252	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.187894	\N	f
7253	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.187895	\N	f
7254	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.187896	\N	f
7255	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.187898	\N	f
7256	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187899	\N	f
7257	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1879	\N	f
7258	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187902	\N	f
7259	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187903	\N	f
7260	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187904	\N	f
7261	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187906	\N	f
7262	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187907	\N	f
7263	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187908	\N	f
7264	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187909	\N	f
7265	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187911	\N	f
7266	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187913	\N	f
7267	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187914	\N	f
7714	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18854	\N	f
7268	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187915	\N	f
7269	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187917	\N	f
7270	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187918	\N	f
7271	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187919	\N	f
7272	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187921	\N	f
7273	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187922	\N	f
7274	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187923	\N	f
7275	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187925	\N	f
7276	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187926	\N	f
7277	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187927	\N	f
7278	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187929	\N	f
7279	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18793	\N	f
7280	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187931	\N	f
7281	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187933	\N	f
7282	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187934	\N	f
7283	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187935	\N	f
7284	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187936	\N	f
7285	ddsdf	test1ы	2015	article	draft	\N	16	2025-03-04 00:07:03.187938	\N	f
7286	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187939	\N	f
7287	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187941	\N	f
7288	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187942	\N	f
7289	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187943	\N	f
7290	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187945	\N	f
7291	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187946	\N	f
7292	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187947	\N	f
7293	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187948	\N	f
7294	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18795	\N	f
7295	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.187951	\N	f
7296	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187952	\N	f
7297	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187954	\N	f
7298	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187955	\N	f
7299	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187956	\N	f
7300	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187958	\N	f
7301	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187959	\N	f
7302	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18796	\N	f
7303	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187962	\N	f
7304	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187963	\N	f
7305	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187964	\N	f
7306	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187966	\N	f
7307	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187967	\N	f
7308	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187968	\N	f
7309	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18797	\N	f
7310	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187971	\N	f
7311	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187973	\N	f
7312	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187974	\N	f
7313	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.187976	\N	f
7314	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187978	\N	f
7315	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18798	\N	f
7316	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.187982	\N	f
7317	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187987	\N	f
7318	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187994	\N	f
7319	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187997	\N	f
7320	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.187999	\N	f
7321	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188001	\N	f
7322	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188003	\N	f
7323	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188005	\N	f
7324	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188007	\N	f
7325	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188009	\N	f
7326	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18801	\N	f
7327	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188012	\N	f
7328	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188014	\N	f
7329	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188016	\N	f
7330	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188018	\N	f
7331	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18802	\N	f
7332	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188022	\N	f
7333	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188024	\N	f
7334	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188027	\N	f
7335	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.188029	\N	f
7336	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18803	\N	f
7337	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188032	\N	f
7338	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188035	\N	f
7339	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188037	\N	f
7340	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188039	\N	f
7341	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188042	\N	f
7342	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188044	\N	f
7343	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188046	\N	f
7344	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188048	\N	f
7345	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.18805	\N	f
7346	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.188052	\N	f
7347	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.188054	\N	f
7348	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188056	\N	f
7349	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188058	\N	f
7350	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188059	\N	f
7351	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	draft	\N	16	2025-03-04 00:07:03.188062	\N	f
7352	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188065	\N	f
7353	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188067	\N	f
7354	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.188069	\N	f
7355	длолд111111111111111111111	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188071	\N	f
7356	555	555ы	1999	article	draft	\N	16	2025-03-04 00:07:03.188073	\N	f
7357	выаыва	ываыва	2011	article	draft	\N	16	2025-03-04 00:07:03.188075	\N	f
7358	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.188078	\N	f
7359	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.18808	\N	f
7360	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.188081	\N	f
7361	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.188083	\N	f
7362	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188084	\N	f
7363	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188086	\N	f
7364	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188087	\N	f
7365	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188089	\N	f
7366	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18809	\N	f
7367	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188091	\N	f
7368	dfgdfg	dfgdfg	2011	article	draft	\N	16	2025-03-04 00:07:03.188092	\N	f
7369	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188094	\N	f
7370	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188095	\N	f
7371	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188097	\N	f
7372	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188098	\N	f
7373	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188099	\N	f
7374	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1881	\N	f
7375	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188102	\N	f
7376	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188103	\N	f
7377	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188104	\N	f
7378	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188105	\N	f
7379	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188107	\N	f
7380	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188108	\N	f
7381	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188109	\N	f
7382	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18811	\N	f
7383	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188112	\N	f
7384	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188114	\N	f
7385	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188116	\N	f
7386	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188118	\N	f
7387	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18812	\N	f
7388	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188123	\N	f
7389	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188125	\N	f
7390	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188127	\N	f
7391	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188129	\N	f
7392	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188131	\N	f
7393	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188134	\N	f
7394	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188136	\N	f
7395	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188138	\N	f
7396	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18814	\N	f
7397	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188141	\N	f
7398	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188143	\N	f
7399	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188146	\N	f
7400	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188147	\N	f
7401	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188148	\N	f
7402	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18815	\N	f
7403	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188152	\N	f
7404	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188153	\N	f
7405	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188154	\N	f
7406	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188156	\N	f
7407	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188157	\N	f
7408	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188158	\N	f
7409	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188159	\N	f
7410	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188161	\N	f
7411	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188162	\N	f
7412	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188163	\N	f
7413	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188164	\N	f
7414	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188165	\N	f
7415	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188167	\N	f
7416	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188168	\N	f
7417	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188169	\N	f
7418	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18817	\N	f
7419	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188172	\N	f
7420	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188173	\N	f
7421	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188174	\N	f
7422	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188175	\N	f
7423	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188177	\N	f
7424	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188178	\N	f
7425	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188179	\N	f
7426	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188181	\N	f
7427	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188182	\N	f
7428	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188183	\N	f
7429	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188184	\N	f
7430	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188185	\N	f
7431	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188187	\N	f
7432	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188188	\N	f
7433	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188189	\N	f
7434	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.18819	\N	f
7435	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188192	\N	f
7436	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188193	\N	f
7437	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188194	\N	f
7438	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188195	\N	f
7439	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188197	\N	f
7440	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188198	\N	f
7441	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188199	\N	f
7442	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1882	\N	f
7443	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188202	\N	f
7444	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188203	\N	f
7445	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.188204	\N	f
7446	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188205	\N	f
7447	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188207	\N	f
7448	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188208	\N	f
7449	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188209	\N	f
7450	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18821	\N	f
7451	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188212	\N	f
7452	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188213	\N	f
7453	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188214	\N	f
7454	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188215	\N	f
7455	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188217	\N	f
7456	555	555	1999	article	draft	\N	16	2025-03-04 00:07:03.188218	\N	f
7457	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.188219	\N	f
7458	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.188221	\N	f
7459	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.188222	\N	f
7460	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.188223	\N	f
7461	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.188224	\N	f
7462	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188226	\N	f
7463	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188227	\N	f
7464	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188228	\N	f
7465	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188229	\N	f
7466	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188231	\N	f
7467	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188232	\N	f
7468	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188233	\N	f
7469	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188234	\N	f
7470	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188236	\N	f
7471	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188237	\N	f
7472	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188238	\N	f
7473	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188239	\N	f
7474	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18824	\N	f
7475	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188242	\N	f
7476	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188243	\N	f
7477	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188244	\N	f
7478	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188245	\N	f
7479	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188247	\N	f
7480	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188248	\N	f
7481	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188249	\N	f
7482	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18825	\N	f
7483	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188252	\N	f
7484	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188253	\N	f
7485	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188254	\N	f
7486	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188255	\N	f
7487	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188256	\N	f
7488	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188258	\N	f
7489	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188259	\N	f
7490	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18826	\N	f
7491	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188261	\N	f
7492	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188263	\N	f
7493	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188264	\N	f
7494	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188265	\N	f
7495	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188266	\N	f
7496	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188267	\N	f
7497	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188269	\N	f
7498	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18827	\N	f
7499	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188271	\N	f
7500	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188273	\N	f
7501	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188274	\N	f
7502	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188275	\N	f
7503	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188276	\N	f
7504	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188278	\N	f
7505	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188279	\N	f
7506	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18828	\N	f
7507	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188281	\N	f
7508	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188283	\N	f
7509	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188284	\N	f
7510	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188286	\N	f
7511	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188287	\N	f
7512	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188288	\N	f
7513	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188289	\N	f
7514	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188291	\N	f
7515	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188292	\N	f
7516	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188293	\N	f
7517	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188294	\N	f
7518	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188296	\N	f
7519	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188297	\N	f
7520	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188298	\N	f
7521	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1883	\N	f
7522	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188301	\N	f
7523	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188302	\N	f
7524	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188303	\N	f
7525	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188305	\N	f
7526	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188306	\N	f
7527	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188307	\N	f
7528	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188308	\N	f
7529	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18831	\N	f
7530	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188311	\N	f
7531	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188312	\N	f
7532	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188314	\N	f
7533	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188315	\N	f
7534	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188316	\N	f
7535	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188317	\N	f
7536	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188319	\N	f
7537	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18832	\N	f
7538	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188321	\N	f
7539	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188322	\N	f
7540	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188324	\N	f
7541	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188325	\N	f
7542	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188326	\N	f
7543	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188327	\N	f
7544	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.188329	\N	f
7545	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18833	\N	f
7546	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188331	\N	f
7547	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188332	\N	f
7548	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188334	\N	f
7549	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188335	\N	f
7550	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188336	\N	f
7551	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188338	\N	f
7552	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188339	\N	f
7553	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18834	\N	f
7554	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188341	\N	f
7555	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.188343	\N	f
7556	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.188344	\N	f
7557	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.188345	\N	f
7558	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.188346	\N	f
7559	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.188348	\N	f
7560	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188349	\N	f
7561	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18835	\N	f
7562	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188351	\N	f
7563	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188352	\N	f
7564	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188354	\N	f
7565	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188355	\N	f
7566	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188356	\N	f
7567	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188357	\N	f
7568	ddsdf	test1	2012	article	draft	\N	16	2025-03-04 00:07:03.188359	\N	f
7569	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18836	\N	f
7570	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188361	\N	f
7571	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188362	\N	f
7572	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188364	\N	f
7573	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188365	\N	f
7574	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188366	\N	f
7575	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188367	\N	f
7576	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188369	\N	f
7577	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.18837	\N	f
7578	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188371	\N	f
7579	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188373	\N	f
7580	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188374	\N	f
7581	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188375	\N	f
7582	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188376	\N	f
7583	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188377	\N	f
7584	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188379	\N	f
7587	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188382	\N	f
7588	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188384	\N	f
7589	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188385	\N	f
7590	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188386	\N	f
7591	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188387	\N	f
7592	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188389	\N	f
7593	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18839	\N	f
7594	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188391	\N	f
7595	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188392	\N	f
7596	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188393	\N	f
7597	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188395	\N	f
7598	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188396	\N	f
7599	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188397	\N	f
7600	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188398	\N	f
7601	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1884	\N	f
7602	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188401	\N	f
7603	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188402	\N	f
7604	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188403	\N	f
7605	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188405	\N	f
7606	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188406	\N	f
7607	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188407	\N	f
7608	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188408	\N	f
7609	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188409	\N	f
7610	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188411	\N	f
7611	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188412	\N	f
7612	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188413	\N	f
7613	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188414	\N	f
7614	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188416	\N	f
7615	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188417	\N	f
7616	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188418	\N	f
7617	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188419	\N	f
7618	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188421	\N	f
7619	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188422	\N	f
7620	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188423	\N	f
7621	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188424	\N	f
7622	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188426	\N	f
7623	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188427	\N	f
7624	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188428	\N	f
7625	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188429	\N	f
7626	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18843	\N	f
7627	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188432	\N	f
7628	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188433	\N	f
7629	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188434	\N	f
7630	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188435	\N	f
7631	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188437	\N	f
7632	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188438	\N	f
7633	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188439	\N	f
7634	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18844	\N	f
7635	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188442	\N	f
7636	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188443	\N	f
7637	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188444	\N	f
7638	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188445	\N	f
7639	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188446	\N	f
7640	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188448	\N	f
7641	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188449	\N	f
7642	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.18845	\N	f
7643	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188451	\N	f
7644	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188453	\N	f
7645	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188454	\N	f
7646	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188455	\N	f
7647	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188456	\N	f
7648	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188458	\N	f
7649	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188459	\N	f
7650	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18846	\N	f
7651	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188461	\N	f
7652	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188463	\N	f
7653	TheShamRio	test1	2011	article	draft	\N	16	2025-03-04 00:07:03.188464	\N	f
7654	авп	ыва	1992	article	draft	\N	16	2025-03-04 00:07:03.188465	\N	f
7655	Introduction to Quantum Computing	Johnson, Robert	2019	article	draft	\N	16	2025-03-04 00:07:03.188466	\N	f
7656	Energy-Efficient Algorithms for IoT Devices	Brown, Emily and Lee, Michael	2019	article	draft	\N	16	2025-03-04 00:07:03.188468	\N	f
7657	Neural Networks in Medical Imaging	Clark, Sarahs	2021	article	draft	\N	16	2025-03-04 00:07:03.188469	\N	f
7658	Robotics and Automation	Evans, Linda	2021	article	draft	\N	16	2025-03-04 00:07:03.18847	\N	f
7659	dfd	sdfs	2022	article	draft	\N	16	2025-03-04 00:07:03.188471	\N	f
7660	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188472	\N	f
7661	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188474	\N	f
7662	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188475	\N	f
7663	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188476	\N	f
7664	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188478	\N	f
7665	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188479	\N	f
7666	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18848	\N	f
7667	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188481	\N	f
7668	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188483	\N	f
7669	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188484	\N	f
7670	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188485	\N	f
7671	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188486	\N	f
7672	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188488	\N	f
7673	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188489	\N	f
7674	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18849	\N	f
7675	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188491	\N	f
7676	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188492	\N	f
7677	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188494	\N	f
7678	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188495	\N	f
7679	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188496	\N	f
7680	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188497	\N	f
7681	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188498	\N	f
7682	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.1885	\N	f
7683	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188501	\N	f
7684	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188502	\N	f
7685	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188503	\N	f
7686	ddsdf	test1ы	2015	article	draft	\N	16	2025-03-04 00:07:03.188505	\N	f
7687	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188506	\N	f
7688	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188507	\N	f
7689	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188508	\N	f
7690	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18851	\N	f
7691	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188511	\N	f
7692	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188512	\N	f
7693	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188514	\N	f
7694	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188515	\N	f
7695	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188516	\N	f
7696	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188517	\N	f
7697	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188519	\N	f
7698	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18852	\N	f
7699	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188521	\N	f
7700	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188523	\N	f
7701	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188524	\N	f
7702	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188525	\N	f
7703	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188526	\N	f
7704	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188528	\N	f
7705	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188529	\N	f
7706	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18853	\N	f
7707	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188531	\N	f
7708	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188533	\N	f
7709	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188534	\N	f
7710	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188535	\N	f
7711	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188537	\N	f
7712	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188538	\N	f
7715	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188542	\N	f
7716	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188543	\N	f
7717	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188544	\N	f
7718	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188545	\N	f
7719	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188547	\N	f
7720	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188548	\N	f
7721	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188549	\N	f
7722	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18855	\N	f
7723	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188552	\N	f
7724	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188553	\N	f
7725	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188554	\N	f
7726	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188555	\N	f
7727	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188557	\N	f
7728	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188558	\N	f
7729	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188559	\N	f
7730	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.18856	\N	f
7731	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188562	\N	f
7732	ddsdf	test1	2015	article	draft	\N	16	2025-03-04 00:07:03.188563	\N	f
7733	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188564	\N	f
7734	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188565	\N	f
7735	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188567	\N	f
7736	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188568	\N	f
7737	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188569	\N	f
7738	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.18857	\N	f
7739	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	draft	\N	16	2025-03-04 00:07:03.188572	\N	f
7740	Sham	test2	2010	article	draft	\N	16	2025-03-04 00:07:03.188573	\N	f
7741	длолд	ирмтми	2015	article	draft	\N	16	2025-03-04 00:07:03.188574	\N	f
7742	dfg	dfgdfg	2023	article	draft	\N	16	2025-03-04 00:07:03.188576	\N	f
7762	hjkghjgjgj	kghjkhjgjhg;;;;;	1999	article	published	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	40	2025-03-09 20:52:56.832465	2025-03-09 20:52:56.831819	f
7752	длолд111111111111111111111	ирмтми	2015	article	published	/uploads/848844016.pdf	16	2025-03-10 00:31:43.586721	2025-03-10 00:31:43.586124	f
2291	выаыва	ываыва	2011	monograph	published	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:46:03.514405	2025-02-25 03:46:03.513835	\N
2292	Lab_1_pcmi	выаыва	2010	article	draft	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:46:54.078628	\N	\N
7748	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	published	/uploads/6.pdf	16	2025-03-10 12:28:07.914676	2025-03-10 12:28:07.91399	f
2293	парап	апрапр	2011	article	draft	/uploads/Spasi_i_Sokhrani.docx	16	2025-02-25 03:47:18.980923	\N	\N
2294	вапвап	вапвап	1999	article	draft	/uploads/Spasi_i_Sokhrani.docx	16	2025-02-25 03:49:21.412916	\N	\N
2295	авпвап	вапвап	2013	article	draft	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:50:07.955754	\N	\N
2296	авпва	пвап	1999	article	draft	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	16	2025-02-25 03:51:21.902155	\N	\N
4083	dddddd	dddddd	2011	article	review	/uploads/4411__3_1.docx	20	2025-02-26 00:12:28.817312	\N	\N
4082	выаыва	ываыва	2011	conference	published	/uploads/64e5ea737c46f_nauchnaja-statja-primer.pdf	16	2025-02-27 20:22:41.058937	2025-02-27 20:22:41.058133	\N
4079	Sham	test2	2010	article	published	/uploads/848844016.pdf	16	2025-03-02 13:53:55.135698	2025-03-02 13:53:55.134013	\N
4076	On the Electrodynamics of Moving Bodies	Albert Einsteinssss	1905	article	published	/uploads/6.pdf	16	2025-03-02 19:40:07.541087	2025-03-02 19:40:07.541075	\N
4075	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	/uploads/6.pdf	16	2025-03-02 23:24:27.43863	\N	f
4048	On the Electrodynamics of Moving Bodies	Albert Einstein	1907	conference	draft	/uploads/848844016.pdf	16	2025-03-04 00:04:59.089757	\N	\N
4081	555	555ы	1999	article	published	/uploads/Istoria_1.docx	16	2025-02-27 22:50:20.216516	2025-02-27 20:26:15.530624	\N
7769	15151515	15151515	2005	article	published	/uploads/Zayavlenie_na_utverzhdenie_temy_VKR_-_blank.pdf	42	2025-03-10 00:36:45.004388	2025-03-10 00:36:45.004151	f
4080	длолд111111111111111111111	ирмтми	2015	article	review	/uploads/Khasanshin4411_TIGR2_1.docx	16	2025-02-28 02:22:51.596211	2025-02-28 00:10:55.950926	\N
7766	12121212	12121212	2001	article	published	/uploads/-_2017.pdf	42	2025-03-10 00:40:58.110099	2025-03-10 00:40:58.109839	f
4171	dfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdf gdfgdfgd fgdfgdfg	dfgdfg	2023	article	draft	/uploads/848844016.pdf	20	2025-03-02 19:41:14.95803	\N	\N
4183	dfgdfgdfg	dfgdfgdfg	2011	article	draft	/uploads/848844016.pdf	27	2025-03-02 19:42:53.782794	\N	\N
4064	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	needs_review	/uploads/6.pdf	16	2025-03-06 19:07:48.349114	\N	f
4074	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	/uploads/6.pdf	16	2025-03-02 23:25:00.636362	2025-03-02 23:25:00.636357	f
4186	вапва	пвап	2008	article	draft	/uploads/6.pdf	16	2025-03-03 23:57:33.340009	\N	f
4187	авп	вап	1999	article	draft	/uploads/6.pdf	16	2025-03-03 23:59:51.844194	\N	f
7753	555	555ы	1999	article	needs_review	/uploads/6.pdf	16	2025-03-04 00:09:40.805879	\N	f
7749	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	needs_review	/uploads/848844016.pdf	16	2025-03-06 19:30:20.800411	\N	f
7768	14141414	14141414	2001	article	published	/uploads/-_2017.pdf	42	2025-03-10 00:37:02.274676	2025-03-10 00:37:02.274436	f
7744	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	needs_review	/uploads/6.pdf	16	2025-03-04 03:20:20.215212	\N	f
7750	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	needs_review	/uploads/6.pdf	16	2025-03-04 03:45:25.95101	\N	f
7754	выаыва	ываыва	2011	monograph	draft	/uploads/6.pdf	16	2025-03-10 11:10:06.8302	\N	t
169	Shamфффффф	test2ффффффф	2010	monograph	published	/uploads/4411__3_1.docx	13	2025-02-22 20:10:33.775622	\N	\N
159	dfgdfgdfg	dfgdfg	2024	monograph	published	/uploads/-17.pdf	7	2025-02-22 11:50:44.606891	\N	\N
43	lol1	lol1	2011	article	published	/uploads/1_.pdf	7	2025-02-22 22:41:06.997614	\N	\N
28	Sham	test2	2010	article	published	/uploads/Spasi_i_Sokhrani.docx	7	2025-02-22 22:41:06.997614	\N	\N
33	fdgdfg	dfgdfgdf	2011	monograph	published	/uploads/4411__3_1.docx	7	2025-02-22 22:41:06.997614	\N	\N
63	ddsdf	test1	2015	article	published	/uploads/4411__3_1.docx	7	2025-02-22 22:41:06.997614	\N	\N
157	Разработка автоматизированнной системы	Шамиль и Виталик	2025	article	published	/uploads/4411__3_1.docx	\N	2025-02-22 21:50:00.808239	\N	\N
802	длолд111111111111111111111	ирмтми	2015	article	published	/uploads/Spasi_i_Sokhrani.docx	16	2025-02-24 16:47:19.116526	\N	\N
3190	df	dsf	2011	article	draft	/uploads/4411__3_1.docx	16	2025-02-25 23:54:30.663488	\N	\N
7767	13131313	13131313	2000	article	published	/uploads/TIGR_LB4_Fedotov_AD_4411.docx	42	2025-03-10 00:36:57.508646	2025-03-10 00:36:57.508409	f
4066	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	/uploads/848844016.pdf	16	2025-03-03 21:01:38.641766	2025-03-03 21:01:38.640985	f
4078	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	/uploads/848844016.pdf	16	2025-03-02 16:31:29.74568	\N	\N
4073	On the Electrodynamics of Moving Bodies	Albert Einstein	1905	article	published	/uploads/848844016.pdf	16	2025-03-02 23:24:14.339301	2025-03-02 23:24:14.339292	f
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, session_id, data, expiry) FROM stdin;
2	session:6Gx-pvi2tHPzrDWGCIuNSE_2oqG01Eor_N591QiHToA	\\x85aa5f7065726d616e656e74c3aa637372665f746f6b656ed92864646131613637643039373131323261653031366239636166626561633134366536626339643737a85f757365725f6964a23238a65f6672657368c3a35f6964d9803634616665363963616530343765653062376337616437646232623130373266626535393765623834343032393536666161623631623230343262373161636563313065646165393035386436373233363163363262333565346564636333343262393664663130303630393032656338383563666339643939343837313965	2025-03-17 12:45:56.002331
1	session:HxTeJO6jMccsx0LqduCc7e1FcXUVNb7hL9ystEJjLKc	\\x82aa5f7065726d616e656e74c3aa637372665f746f6b656ed92863636339613964306263323761373733333337646163613931396363386235363265623264636138	2025-03-09 22:27:18.465325
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, username, password_hash, role, last_name, first_name, middle_name, created_at, updated_at) FROM stdin;
16	TheShamRio	scrypt:32768:8:1$xyVSA3g0FZ9H0Mnt$51b82a263a1e3e89455420385eb7abc553ad45b08ba273a6c1d1c1e00897c6d6efa182d5166243da0000817316c6444a0306b62acdf70f4213c8d680d81d15f9	user	Хасаншинs	Шамиль	Равгатовичd	2025-02-22 19:47:14.708751	2025-03-06 19:33:04.007509
21	sh.khasanshin	scrypt:32768:8:1$iOLtO7e5d9ciKH7G$7649695a6bfddc610ee12447b42d3c90df9355da538fde6c449c024e3fac2bfb786763b422b99e551e345094255e07fa45a2871095521f81f924a02f1e23aa45	user	Хасаншин	Шамиль	Равгатович	2025-03-02 14:39:36.894577	2025-03-02 14:39:36.894582
23	tutubalinpi	scrypt:32768:8:1$lajY7VwRpFXEVVUR$c15f80107af2178fdecdc753b5efe3bf21dcc86d7ce0dc97893ee172534a858cc67e66d129d391ae896b265c2d2da172c6867fc6d62ef6609d2429cc4c3b758e	user	Тутубалин	Павел 	Инноконтьевич	2025-03-02 14:54:19.946806	2025-03-02 14:54:19.946811
24	vyayvayy	scrypt:32768:8:1$6LCfZMMHhclQeLgE$77f9b1567ca54702ae7552e545538bd93b69f530035951b856fc4cf2ef915215ee7534f2797d2c76d70457a81cbac64c4a9042a39018ffd5fb2881f2e8d373a3	user	выаыва	ываыва	ываыва	2025-03-02 14:54:30.859166	2025-03-02 14:54:30.859171
25	KhasanshinShR	scrypt:32768:8:1$z5ygMXWfE7Pc3sem$c95e929b738eb376e5288a42ba7d71344db59a80eb507cc0c3c05780cb447c354c49098ca38855cc69a7075c69de80973a8e29db8c5951e5602660a814801aa0	user	Хасаншин	Шамиль	Равгатович	2025-03-02 14:57:34.720505	2025-03-02 14:57:34.72051
35	3333333	scrypt:32768:8:1$r4IrSAJT5qkjjdA3$79c70d3c41a76fea22e23b7c793131ab532039721cf08bfadaf3d06e6a8f9d3b1ac4e785f85120dacfd3d4ad4ec00566cfc898aa70888bf46e879ef39839771b	user	33333	333333333333	33333333333	2025-03-03 01:46:56.958459	2025-03-03 01:46:56.958464
26	ChervovVS	scrypt:32768:8:1$UekIt8PvMUJphsKw$752c23f1174ecfa6128f769c26c0058b5c36fd1826003ea1327a37571da2418039764992fa0803228eb40dad8663b91d406452b05de51a60f31155d4dec829ed	user	Червов	Виталий	Сергеевич	2025-03-02 14:58:29.990278	2025-03-02 14:59:10.545864
27	TestTT	scrypt:32768:8:1$GRYGZ9tgWTizx3Qg$76d6487ccc945c7d389cff0570e4cbc943a0198cfba7bdae0959259ce58a6b7fbd5de751d9e390bb48daeedfc938d2896112ed3288858bbd75241dd61891d91d	user	Test	Test	Test	2025-03-02 16:34:39.929582	2025-03-02 16:34:39.929587
28	manager	scrypt:32768:8:1$5borpbSl9xHHluj6$3b6e91d887cf9d77bd738b9646c673c95462e852fe5d357d87d59c03cb690b5e32ae0a332e5737859805686fd6804efcc5d0c314dd0e97a7fa7c3d4f4857a80f	manager	dfgdfg	dfgdfg	dfgdfgdf	2025-03-03 00:28:10.227273	2025-03-03 00:28:32.796124
29	YvayvAV	scrypt:32768:8:1$C3n2lOd00jg9pSBd$d7ae0cabf6ccd7edf3be1cedc16ed36d0d9d73d5f15f81d31ac0844d5c3b17084eb763585057e5dfbba4fe64fee376ab98d914b9db20d35b6938550cd1677041	user	ываыв	аываы	ваываыва	2025-03-03 01:39:13.818832	2025-03-03 01:39:13.818837
18	deleted_user	scrypt:32768:8:1$38YLIfnFjItDTVkh$78c0537741c39984281623819bdb212558d5c136ed65f0e6b79fd651bf8b2c91333d171478c25678dbde529b6fa09e5ca552b2e93d98f4c7ef1fd8d30d774163	deleted	\N	\N	\N	2025-02-22 21:50:17.306578	2025-02-22 21:50:17.306578
11	admin	scrypt:32768:8:1$Xb4PJnpw58lA05fu$c11917d4db472bbcd7b1fdd622161bd23db2f39e29c007d3d44291f266ec3d1cef6b3a41642751947d8a2aa4cade807d6d79bd2a5546762bede972f4b425282a	admin	Adminov	Admin	Adminovich	2025-02-21 18:27:01.941445	2025-02-21 18:27:01.941445
20	dddddd	scrypt:32768:8:1$0011XhdirMkeq4oL$07ea1e50a0f74226ad6434fb30e304761d6bb2c26c24dae61463f36bf70fbef6855a342310b50cb2534bc8b96dafee4d744b6e1b66cdcd9ec83a95f1580afe31	user	dddddd	dddddd	dddddd	2025-02-26 00:12:02.077058	2025-02-26 00:12:02.077058
7	test3	scrypt:32768:8:1$46vqkRsfKayXABUf$03126ce87fde7bd1b845bce8056dff4e137eca8b4e9086639e9a1170aff222ec41d78aed72814847c86a2572714f846cd691ad428db6219c641b2cca961e4d92	user	Ивановы	Иван	Иванович	2025-02-20 15:36:42.152142	2025-02-20 15:36:42.152142
36	222222	scrypt:32768:8:1$x9F0EkqPZBQzeYzG$3445b7855ab73afe7a4e6f2dd63277cdde26b5e8a790ea476670fecd9e0c74c48aa5e4ff027f29058d4eaddcb4b63fb5e657723c5382c2ce61106af5b8f4a547	user	2222	222222222222	2222222222	2025-03-03 01:47:07.992028	2025-03-03 01:47:07.992034
40	Shamil	scrypt:32768:8:1$VSUd6X4cCpBvUF3P$3f5b580d55383652fb59c00324c48fb84a82afc40e250f37b5af095e1e2a8283b0618e1c3e380b6a7cc298d7611c26553c179e567ed87caac40f067aefcdc644	user	Shamil	Shamil	Shamil	2025-03-07 00:19:00.850927	2025-03-07 00:19:00.850932
30	YvayvAY	scrypt:32768:8:1$zD1KAABlGz3QoY9w$7499261fd9b7d2450ba0b1f52c96ec92e60c81bf194dc3f1b17f0311241ee4cde9651e3a85d5a1d5cf58960686adbad647c238e6ecc62961a3c888b0bfbeaf36	user	ываыв	аыва	ываыва	2025-03-03 01:39:42.633688	2025-03-03 01:39:42.633693
41	user1741552345340	scrypt:32768:8:1$brZJUfsU0SK9w9Yg$14ba10cf58cd428efc7fd0a7adde1f8575ffc70de841352e7477eb8f56e7b1849fa21febe39372178add4c60bd0b110bb4dfe941feda23f7a286c535c3fab1f2	user	nbbmnbmn	mnbmbmn	nbvbvnbm	2025-03-09 20:33:02.303516	2025-03-09 20:33:02.303525
5	test1	scrypt:32768:8:1$HoElhhL6bGNZwjwT$3f25ca66e7b09bb68aad88ab4b0068036e2abed27d0347734aa960f49b116f11367338d3f0af365d8f165df400c102cbef3436f130fe78ad9362a95bc8b1eea4	user	Закиев	Замиры	Магомедович	2025-02-22 13:53:34.409453	2025-02-22 13:53:34.409453
13	test11	scrypt:32768:8:1$cwetAVU49dCyMdzK$a59c241e73681e0c11b0c37de64518e3953e5b546d2736b6b6295828e31dc513776a661a2d7327c3ecd010dcf1b1a5279e1b0020127278af430b8192e24aba71	user	test11	test11	test11s	2025-02-22 12:12:10.634449	2025-02-22 12:12:10.634449
19	TEST2	scrypt:32768:8:1$0o1sOj7sXtGWrSpw$f9ae9950e26e8457edac22066e811958feccc226458f143ec5b2838ab5b97f599a90b53d055bc1f50151f0feaf6dbcc6c68dd2a5b1a65c9bfc065d500044d4c9	user	TEST2	TEST2	TEST2	2025-02-24 22:00:21.225144	2025-02-24 22:00:21.225144
31	AsdasDA	scrypt:32768:8:1$PU16AB5wzcgGJsHb$80f7665c8265103941ac1a3fae13303628ee8fab3f8b4b1717f26f73182c2b801f1898c1d2c326c72f16eaa21c76403a4e1ab4a2bd6463599b99066b6255c471	user	asdas	dasd	asdasd	2025-03-03 01:40:22.094409	2025-03-03 01:40:22.094414
32	AsdasDA1	scrypt:32768:8:1$C13VT9fP8Tje1PlI$1f2cb8f91ebb00d60b7c506fbb6a3e3a030774f463a1c445ea247b381ec5647f014b98df1592135cd9697f3dbbdaef05c62d39fb5720fd5a6be7cddeb3fe8ba1	user	asdas	dasdавчпвапва	asdasd	2025-03-03 01:41:53.339029	2025-03-03 01:41:53.339035
33	1111111111	scrypt:32768:8:1$r56STg2rDSr237dN$2180e42e3fab1a88555a854e6de946fd585c27d6306e964bd03d803771cea41805c317d731215b71cfb06219a9b0dec11ebaa4f38d1bc4abc783eaff255e31e6	user	11111111	111111111111111	1111111111111	2025-03-03 01:42:13.829354	2025-03-03 01:42:13.829362
34	22222	scrypt:32768:8:1$iLkJvAz7tidgaRrX$d12b6bcdc3809daff7854523e32139c4d111f68275611da4395cd79e1ec675c2b94f30acd67f49a1dcf8eb4cc8d745ce07f6730fcc3e8d6767e3eae3c63d36be	user	222	2222222222222	222222222222	2025-03-03 01:43:33.982843	2025-03-03 01:43:33.982848
37	user1741276406051	scrypt:32768:8:1$SXKDiIKfVLYsM8dm$fcfa6eac6879c03e28588c60bd5787ba0c3c226ae29f0a5a86fe5da06768f47d7dcc893db09fdaf5fa3dceabbd4812b75bdeddc46f1e12c2407868c817c1dfd9	user	dfgd	fgdfg	dfg	2025-03-06 15:53:27.827051	2025-03-06 15:53:27.827056
38	user1741276416681	scrypt:32768:8:1$Y4mB2avmwafhdTF9$5199bcad2d47c3b521b08e03a00f5e8f06c2d6522f67c0470fd68af3f1be1efd541d6cb5e1711bf8886424a3e7e0a319dad4165064e716d6784d96c4e08d4f14	user	dfgdf	fdg	gdfg	2025-03-06 15:53:41.084111	2025-03-06 15:53:41.084117
39	user1741276434731	scrypt:32768:8:1$WWnhC68ChnTWeeJm$5ef4f006359e02108daa7fabd77fb3df8d59ff994a1f881097abc18c60a3277f31697bc1d969c76e662a0ab95a751a009083c7e011f3e45d5bbcbbf96c5e0f10	user	dfgdfgdfgdfg	dfgdfgdfg	dfgdfdfgdfg	2025-03-06 15:53:56.181565	2025-03-06 15:53:56.18157
42	Sham1	scrypt:32768:8:1$v96FGGmag7ByN3dw$7322b98239fb8249b302fccedf00e5be2fc9aa911c681d7c5226e662b312962271f15de0cb4bba9750f5bea9aea1a9a046951e1c2c191a06c01224747b4fe8b8	user	Sham1111	Sham111	Sham111	2025-03-10 00:32:07.359329	2025-03-10 02:15:37.935201
43	user1741610076151	scrypt:32768:8:1$ItKRyuVpPoNJsrll$d47e63bab88e564c29db5abe9c40baf9342871d8c46be0bf080df206b315b7c8a96e65ebe0afd931d4297fbf680b117d720beb2643d6424e6a9643db110da124	user	1	1	1	2025-03-10 12:34:43.819409	2025-03-10 12:34:43.819414
\.


--
-- Name: achievement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.achievement_id_seq', 1, false);


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_id_seq', 37, true);


--
-- Name: plan_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plan_entry_id_seq', 910, true);


--
-- Name: plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plan_id_seq', 77, true);


--
-- Name: publication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publication_id_seq', 7770, true);


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sessions_id_seq', 2, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 43, true);


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
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: plan_entry plan_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_entry
    ADD CONSTRAINT plan_entry_pkey PRIMARY KEY (id);


--
-- Name: plan plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan
    ADD CONSTRAINT plan_pkey PRIMARY KEY (id);


--
-- Name: publication publication_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_session_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_session_id_key UNIQUE (session_id);


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
-- Name: comment comment_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.comment(id);


--
-- Name: comment comment_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_publication_id_fkey FOREIGN KEY (publication_id) REFERENCES public.publication(id);


--
-- Name: comment comment_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: plan_entry fk_plan_entry_plan_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_entry
    ADD CONSTRAINT fk_plan_entry_plan_id FOREIGN KEY (plan_id) REFERENCES public.plan(id);


--
-- Name: plan fk_plan_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan
    ADD CONSTRAINT fk_plan_user_id FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: plan_entry plan_entry_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plan_entry
    ADD CONSTRAINT plan_entry_publication_id_fkey FOREIGN KEY (publication_id) REFERENCES public.publication(id);


--
-- Name: publication publication_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

