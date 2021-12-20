--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9 (Ubuntu 12.9-2.pgdg20.04+1)
-- Dumped by pg_dump version 12.9 (Ubuntu 12.9-2.pgdg20.04+1)

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
-- Name: project; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA project;


ALTER SCHEMA project OWNER TO postgres;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: say_hooray(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.say_hooray() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
RAISE NOTICE 'Hooray, new friendship on the platform!';
RETURN NEW;
END;
$$;


ALTER FUNCTION public.say_hooray() OWNER TO postgres;

--
-- Name: subs_warn(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.subs_warn()
    LANGUAGE plpgsql
    AS $$
DECLARE us_id integer;
BEGIN
for us_id in (SELECT u."id" FROM 
			  "user" u RIGHT JOIN "user_subscription" s
			 ON u.id = s.user_id WHERE s.end - NOW() < INTERVAL '7' day
			 AND s.end - NOW() > INTERVAL '0:0:0')
			 LOOP
			 RAISE NOTICE 'Subscription of user with id % is about to expire in less than a week.', us_id;
			 END LOOP;
END;
$$;


ALTER PROCEDURE public.subs_warn() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: blocked_profiles; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.blocked_profiles (
    blocker_id integer NOT NULL,
    blocked_id integer NOT NULL,
    "timestamp" timestamp without time zone,
    reason character varying(100)
);


ALTER TABLE project.blocked_profiles OWNER TO postgres;

--
-- Name: certificate; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.certificate (
    id integer NOT NULL,
    url character varying(255),
    "timestamp" timestamp without time zone
);


ALTER TABLE project.certificate OWNER TO postgres;

--
-- Name: certificate_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.certificate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.certificate_id_seq OWNER TO postgres;

--
-- Name: certificate_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.certificate_id_seq OWNED BY project.certificate.id;


--
-- Name: comments; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.comments (
    id integer NOT NULL,
    lesson_id integer NOT NULL,
    user_id integer NOT NULL,
    text character varying(1000) NOT NULL
);


ALTER TABLE project.comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.comments_id_seq OWNED BY project.comments.id;


--
-- Name: completed_lessons; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.completed_lessons (
    user_id integer NOT NULL,
    lesson_id integer NOT NULL,
    "timestamp" timestamp without time zone
);


ALTER TABLE project.completed_lessons OWNER TO postgres;

--
-- Name: contact_type; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.contact_type (
    id integer NOT NULL,
    type character varying(50) NOT NULL,
    icon_url character varying(255)
);


ALTER TABLE project.contact_type OWNER TO postgres;

--
-- Name: contact_type_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.contact_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.contact_type_id_seq OWNER TO postgres;

--
-- Name: contact_type_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.contact_type_id_seq OWNED BY project.contact_type.id;


--
-- Name: course; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.course (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(1000),
    requires_premium integer
);


ALTER TABLE project.course OWNER TO postgres;

--
-- Name: course_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.course_id_seq OWNER TO postgres;

--
-- Name: course_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.course_id_seq OWNED BY project.course.id;


--
-- Name: feedback; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.feedback (
    id integer NOT NULL,
    user_id integer,
    feedback character varying(1000)
);


ALTER TABLE project.feedback OWNER TO postgres;

--
-- Name: feedback_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.feedback_id_seq OWNER TO postgres;

--
-- Name: feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.feedback_id_seq OWNED BY project.feedback.id;


--
-- Name: lesson; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.lesson (
    id integer NOT NULL,
    course_id integer,
    name character varying(100) NOT NULL,
    link character varying(255) NOT NULL,
    requires_premium integer
);


ALTER TABLE project.lesson OWNER TO postgres;

--
-- Name: lesson_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.lesson_id_seq OWNER TO postgres;

--
-- Name: lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.lesson_id_seq OWNED BY project.lesson.id;


--
-- Name: nation; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.nation (
    id integer NOT NULL,
    name character varying(45) NOT NULL,
    flag_url character varying(255) NOT NULL,
    abbreviation character varying(5) NOT NULL
);


ALTER TABLE project.nation OWNER TO postgres;

--
-- Name: nation_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.nation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.nation_id_seq OWNER TO postgres;

--
-- Name: nation_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.nation_id_seq OWNED BY project.nation.id;


--
-- Name: relationship; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.relationship (
    user1_id integer NOT NULL,
    user2_id integer NOT NULL,
    relationship_type_id integer NOT NULL,
    "timestamp" timestamp without time zone
);


ALTER TABLE project.relationship OWNER TO postgres;

--
-- Name: relationship_type; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.relationship_type (
    id integer NOT NULL,
    type character varying(50),
    icon_url character varying(255)
);


ALTER TABLE project.relationship_type OWNER TO postgres;

--
-- Name: relationship_type_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.relationship_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.relationship_type_id_seq OWNER TO postgres;

--
-- Name: relationship_type_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.relationship_type_id_seq OWNED BY project.relationship_type.id;


--
-- Name: subscription; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.subscription (
    id integer NOT NULL,
    price_month integer NOT NULL,
    price_year numeric,
    title character varying(25) NOT NULL,
    description character varying(150)
);


ALTER TABLE project.subscription OWNER TO postgres;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.subscription_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.subscription_id_seq OWNER TO postgres;

--
-- Name: subscription_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.subscription_id_seq OWNED BY project.subscription.id;


--
-- Name: user; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project."user" (
    id integer NOT NULL,
    first_name bytea NOT NULL,
    last_name bytea NOT NULL,
    email character varying(255) NOT NULL,
    is_verified bit(1) NOT NULL,
    picture_url character varying(255),
    nation_id integer,
    password character varying(255) NOT NULL
);


ALTER TABLE project."user" OWNER TO postgres;

--
-- Name: user_contacts; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.user_contacts (
    user_id integer NOT NULL,
    contact_type_id integer NOT NULL,
    address character varying(255)
);


ALTER TABLE project.user_contacts OWNER TO postgres;

--
-- Name: user_course; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.user_course (
    user_id integer NOT NULL,
    course_id integer NOT NULL,
    certificate_id integer,
    course_rating smallint,
    user_feedback character varying(1000),
    CONSTRAINT user_course_course_rating_check CHECK (((course_rating > 0) AND (course_rating < 11)))
);


ALTER TABLE project.user_course OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: project; Owner: postgres
--

CREATE SEQUENCE project.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: project; Owner: postgres
--

ALTER SEQUENCE project.user_id_seq OWNED BY project."user".id;


--
-- Name: user_subscription; Type: TABLE; Schema: project; Owner: postgres
--

CREATE TABLE project.user_subscription (
    user_id integer NOT NULL,
    subscription_id integer NOT NULL,
    start timestamp without time zone NOT NULL,
    "end" timestamp without time zone NOT NULL
);


ALTER TABLE project.user_subscription OWNER TO postgres;

--
-- Name: most_used_platforms; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.most_used_platforms AS
 SELECT t.type,
    count(DISTINCT u.user_id) AS num_of_users
   FROM (project.user_contacts u
     LEFT JOIN project.contact_type t ON ((u.contact_type_id = t.id)))
  GROUP BY t.type;


ALTER TABLE public.most_used_platforms OWNER TO postgres;

--
-- Name: users_per_free_lesson; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.users_per_free_lesson AS
 SELECT c.name AS course_name,
    count(DISTINCT u.user_id) AS num_of_users,
    count(DISTINCT l.id) AS num_of_lessons
   FROM ((project.user_course u
     JOIN project.course c ON ((u.course_id = c.id)))
     RIGHT JOIN project.lesson l ON ((l.course_id = c.id)))
  WHERE ((l.requires_premium IS NULL) OR (l.requires_premium = ( SELECT subscription.id
           FROM project.subscription
          WHERE ((subscription.title)::text = 'Default'::text))))
  GROUP BY c.name, c.requires_premium
 HAVING ((c.requires_premium IS NULL) OR (c.requires_premium = ( SELECT subscription.id
           FROM project.subscription
          WHERE ((subscription.title)::text = 'Default'::text))))
  WITH NO DATA;


ALTER TABLE public.users_per_free_lesson OWNER TO postgres;

--
-- Name: certificate id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.certificate ALTER COLUMN id SET DEFAULT nextval('project.certificate_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.comments ALTER COLUMN id SET DEFAULT nextval('project.comments_id_seq'::regclass);


--
-- Name: contact_type id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.contact_type ALTER COLUMN id SET DEFAULT nextval('project.contact_type_id_seq'::regclass);


--
-- Name: course id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.course ALTER COLUMN id SET DEFAULT nextval('project.course_id_seq'::regclass);


--
-- Name: feedback id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.feedback ALTER COLUMN id SET DEFAULT nextval('project.feedback_id_seq'::regclass);


--
-- Name: lesson id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.lesson ALTER COLUMN id SET DEFAULT nextval('project.lesson_id_seq'::regclass);


--
-- Name: nation id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.nation ALTER COLUMN id SET DEFAULT nextval('project.nation_id_seq'::regclass);


--
-- Name: relationship_type id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.relationship_type ALTER COLUMN id SET DEFAULT nextval('project.relationship_type_id_seq'::regclass);


--
-- Name: subscription id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.subscription ALTER COLUMN id SET DEFAULT nextval('project.subscription_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project."user" ALTER COLUMN id SET DEFAULT nextval('project.user_id_seq'::regclass);


--
-- Data for Name: blocked_profiles; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.blocked_profiles (blocker_id, blocked_id, "timestamp", reason) FROM stdin;
37	11	2021-10-24 16:39:00.435644	Called me a dumbo.
7	1	2021-10-24 16:39:00.435644	I dont like him
48	49	2021-10-24 16:39:00.435644	He refused to buy me premium
16	17	2021-10-24 16:39:00.435644	\N
14	11	2021-10-24 16:39:00.435644	Bruh
\.


--
-- Data for Name: certificate; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.certificate (id, url, "timestamp") FROM stdin;
1	certicateHDpunjabinovirus100percentlegit.com/16	2021-10-24 16:39:44.813603
2	certicateHDpunjabinovirus100percentlegit.com/786	2021-10-24 16:39:44.813603
3	certicateHDpunjabinovirus100percentlegit.com/147	2021-10-24 16:39:44.813603
4	certicateHDpunjabinovirus100percentlegit.com/143	2021-10-24 16:39:44.813603
5	certicateHDpunjabinovirus100percentlegit.com/11	2021-10-24 16:39:44.813603
6	certificateHDpunjabinovirus100legit.com/6512	2021-11-08 15:02:12.143382
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.comments (id, lesson_id, user_id, text) FROM stdin;
1	17	1	Epic!
2	18	1	Very bad, thanks
3	19	1	Meh..
4	20	1	I completed this.
5	21	1	Once again, epic!
7	1	1	Nevermind, I got bored.
8	1	1	Nevermind, Is fun again.
10	1	2	Wtf is diz?
11	25	1	Hewwo UwU
12	27	1	Is not so bs
13	1	1	Guess who's back
6	1	1	Is quite fun!
14	1	1	hi again
\.


--
-- Data for Name: completed_lessons; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.completed_lessons (user_id, lesson_id, "timestamp") FROM stdin;
1	17	2021-10-24 16:40:39.967823
1	18	2021-10-24 16:40:39.967823
1	19	2021-10-24 16:40:39.967823
1	20	2021-10-24 16:40:39.967823
1	21	2021-10-24 16:40:39.967823
1	1	2021-11-28 14:29:49.516079
1	6	2021-11-28 14:34:50.597597
1	7	2021-11-28 14:43:19.813083
1	24	2021-11-28 15:08:44.24104
1	12	2021-11-28 15:24:49.658541
1	30	2021-11-28 15:25:04.613008
1	32	2021-11-28 15:25:07.607505
1	36	2021-11-28 15:25:12.109947
1	50	2021-11-28 15:25:14.174374
1	52	2021-11-28 15:25:16.197462
1	53	2021-11-28 15:25:18.12829
1	54	2021-11-28 15:25:20.602784
1	33	2021-11-28 15:25:29.31661
1	25	2021-12-06 17:40:58.593379
1	3	2021-12-06 17:42:04.023421
1	2	2021-12-06 17:43:52.267466
1	5	2021-12-06 17:44:38.941556
2	1	2021-12-06 18:35:59.780184
2	6	2021-12-06 19:56:49.16207
1	27	2021-12-18 11:01:08.256547
1	15	2021-12-19 16:48:08.046578
1	29	2021-12-20 13:15:57.558357
1	42	2021-12-20 13:16:05.756748
\.


--
-- Data for Name: contact_type; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.contact_type (id, type, icon_url) FROM stdin;
1	Miscelaneous	\N
2	Google	placeholder
3	Facebook	placeholder
4	Twitter	placeholder
5	GitHub	placeholder
\.


--
-- Data for Name: course; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.course (id, name, description, requires_premium) FROM stdin;
1	Python	Python timee	1
2	C	C timee	1
3	C#	C# timee	1
4	Ruby	Ruby - hoovno	1
5	Git	Git timee	1
\.


--
-- Data for Name: feedback; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.feedback (id, user_id, feedback) FROM stdin;
1	1	Cool App!
2	1	Very very cool
4	2	I dont want to give you feedback, lol
\.


--
-- Data for Name: lesson; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.lesson (id, course_id, name, link, requires_premium) FROM stdin;
1	1	hacking	url.com/Python/lesson1	1
2	5	doing some stuff	url.com/Git/lesson2	5
3	4	getting high	url.com/Ruby/lesson3	3
4	5	sleeping	url.com/Git/lesson4	1
5	2	objects	url.com/C/lesson5	1
6	1	sleeping again	url.com/Python/lesson6	1
7	1	baking pies	url.com/Python/lesson7	1
8	2	sleeping again	url.com/C/lesson8	1
9	5	idk, doing something	url.com/Git/lesson9	1
10	2	hacking	url.com/C/lesson10	5
11	5	baking pies	url.com/Git/lesson11	4
12	3	shredding	url.com/C#/lesson12	5
13	2	objects	url.com/C/lesson13	1
14	2	connecting to sql	url.com/C/lesson14	1
15	4	shredding	url.com/Ruby/lesson15	4
16	4	regex	url.com/Ruby/lesson16	1
17	3	baking pies	url.com/C#/lesson17	2
18	1	making funny stuff	url.com/Python/lesson18	1
19	3	objects	url.com/C#/lesson19	1
20	3	why is Python superior	url.com/C#/lesson20	1
21	1	doing nothing	url.com/Python/lesson21	1
22	4	sleeping again	url.com/Ruby/lesson22	4
23	4	sleeping	url.com/Ruby/lesson23	1
24	1	getting high	url.com/Python/lesson24	1
25	1	shredding	url.com/Python/lesson25	1
26	2	objects	url.com/C/lesson26	1
27	1	regex	url.com/Python/lesson27	4
28	2	regex	url.com/C/lesson28	1
29	1	baking pies	url.com/Python/lesson29	1
30	3	regex	url.com/C#/lesson30	5
31	5	baking pies	url.com/Git/lesson31	2
32	3	getting high	url.com/C#/lesson32	1
33	3	objects	url.com/C#/lesson33	4
34	5	idk, doing something	url.com/Git/lesson34	1
35	2	why is Python superior	url.com/C/lesson35	1
36	3	sleeping again	url.com/C#/lesson36	4
37	4	connecting to sql	url.com/Ruby/lesson37	1
38	2	baking pies	url.com/C/lesson38	1
39	5	making funny stuff	url.com/Git/lesson39	1
40	5	objects	url.com/Git/lesson40	1
41	4	baking pies	url.com/Ruby/lesson41	5
42	1	regex	url.com/Python/lesson42	4
43	4	doing some stuff	url.com/Ruby/lesson43	3
44	2	idk, doing something	url.com/C/lesson44	5
45	4	idk, doing something	url.com/Ruby/lesson45	4
46	2	getting high	url.com/C/lesson46	1
47	5	getting high	url.com/Git/lesson47	3
48	5	regex	url.com/Git/lesson48	1
49	1	idk, doing something	url.com/Python/lesson49	4
50	3	idk, doing something	url.com/C#/lesson50	2
51	5	objects	url.com/Git/lesson51	1
52	3	doing nothing	url.com/C#/lesson52	1
53	3	why is Python superior	url.com/C#/lesson53	4
54	3	regex	url.com/C#/lesson54	1
55	4	objects	url.com/Ruby/lesson55	1
56	5	baking pies	url.com/Git/lesson56	4
57	5	shredding	url.com/Git/lesson57	4
58	4	making funny stuff	url.com/Ruby/lesson58	3
59	2	regex	url.com/C/lesson59	2
60	5	doing some stuff	url.com/Git/lesson60	3
\.


--
-- Data for Name: nation; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.nation (id, name, flag_url, abbreviation) FROM stdin;
1	Czechia	placeholder	CZ
2	United Kingdom	placeholder	UK
3	France	placeholder	FR
4	Poland	placeholder	PL
5	Germany	placeholder	DE
6	United States	placeholder	USA
\.


--
-- Data for Name: relationship; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.relationship (user1_id, user2_id, relationship_type_id, "timestamp") FROM stdin;
1	2	1	2021-10-24 16:38:45.857832
3	2	4	2021-10-24 16:38:45.857832
7	14	4	2021-10-24 16:38:45.857832
1	37	2	2021-10-24 16:38:45.857832
37	44	1	2021-11-07 18:12:55.095936
44	14	1	2021-11-08 15:39:11.972719
\.


--
-- Data for Name: relationship_type; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.relationship_type (id, type, icon_url) FROM stdin;
1	friends	placeholder
2	colleagues	placeholder
3	1 is student of 2	placeholder
4	1 is follower of 2	placeholder
5	1 is boss of 2	placeholder
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.subscription (id, price_month, price_year, title, description) FROM stdin;
1	0	0	Default	NULL
2	1	10	Rookie	For cheapstakes only. Unlocks some lessons.
3	2	20	Advanced	Unlock more, learn more.
4	3	30	PRO	Learn all the knowledge in the world
5	10	100	Diamond	Jump freely between any content. All is yours. We all respect you. Thank you.
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project."user" (id, first_name, last_name, email, is_verified, picture_url, nation_id, password) FROM stdin;
2	\\xc30d04070302c51a6f04361dde3777d238013a11cba3d35078ee348c01b7f32e630d1aae1251cdb66c1ace3e6c8e104ddec077e88481a518a2e2230ff2165c10a57a0c8140b0c91ae3	\\xc30d0407030272e6aa55233cfcc072d24201953216b9a6a8cd853e1bc35bc71a0d6a540777ed4b688350674d0ecf4f159e5c5b0fd6410d5c0a11a41e1823d4c402e2654c98fbcccf9f915e4b40841034b1ee1e	Znowustworzujoncy.Freddie@gmail.com	1	https://thispersondoesnotexist.com/image	2	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
3	\\xc30d040703028f26c53767c5bf1c65d23801fc4c9e95ae39d1b5f27c794ff091774a60a707a94625bf8cba885aa957a7154bb17810a856c233ebadaf758e8c78ed273e31b585d7a879	\\xc30d040703029b75511f83317dc76ad23801b14538ddb18d9df682d194f3a5184198798bf5146261f162f4bf14cdd606a1399deb39bc460add4ec30d36b2d2a75274925cd9ad9da956	Wankler.Freddie@gmail.com	1	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
4	\\xc30d040703020e56719a103a6fd16ad235011723b20d429c42bab5010f8e806444ab3d246f1e2c268c04a747707b0f907c289b566050f84ebb4a656f682138cdb148d2b7edbd	\\xc30d040703029f0dc7b29f63240d7fd240016ac7ac773fb293c5286eed5c2079290acebfd485a9989e2700f04dc02b7104cd68cd90e475c0c614454682d2530f75411cbb4aa70359dfc7a1afec57dd1df7	BDSmorelikeBDSM.Alex@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
5	\\xc30d0407030298d132fea72bee176ad23601fb4e02fed22e4478e9ecd8285442b31cfae2aa2ba997e6408ed176d05ba8e869dc84c77804ff1ec8993a9b9d93fbe0bc6b570be0ac	\\xc30d040703025cf71d6af061c32676d23a0111b4fd9c565d9b3726f32dc6590db9f936d8a8fc64f5655246c2f19cd77e90d18ab7ee998bab0e9c720a056505c8a8dbbd26f1ff1f306e5c93	Tightanus.Karel@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
6	\\xc30d040703023aacb94621072b7c71d23501d1d71468ac3ebf67bb5b768bdeb85efe807bc0193ccd0494ec954fce9681fb822dc21d44851d0c90b79e11516ebaa526a66aa071	\\xc30d040703020893365ac133e5cd71d238014e9f5b7133dbbfb7baab8f2b62c2f252e46831bc95db4d9a82702faea502e11c97d9ff09c7a49c87223ebd75c67213de2c3f0e99e7a34d	Dicktit.Jean@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
7	\\xc30d0407030271e86a48107885bb67d2340107e92cf39ffefd92670c714d49583a47e3be54c7ad98181625d257152726eb96902bdac54d6e845b1f554bbdf3b78b5bd95784	\\xc30d04070302457393ca88fa1a1565d236015496c7c19c94a99fb0a0a1fc90a4b5e29a7c698d93e1500997e8c49abcc2e21c40e64734bcd902e790eac0a03c5c3e72aa69c4ed63	Dover.Ben@gmail.com	0	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
9	\\xc30d040703024becb679c8fd7fe367d2350191d4b2ac184784f8795519d14b9df850bee36ef259cea3a1197bfd8742f0937521228b7ffc0e4201fee2e72e72e02637f6c02bdd	\\xc30d040703020dc462e7216b5dde75d24201f94b1e2c759f5686a70e8013ae9fdaf93fb4ce5a2fa73e6b4326c4f6683294f5c5abef9db620147828cecb5de396fa60d436c29485a435e50339435e7fc53c3e3d	Znowustworzujoncy.Bruh@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
10	\\xc30d04070302bb1928539252180260d237017eebd0ef812087358d7559c7c9930344f8cf0aab8afca9bfce9cc796f297aaf28fb3b1aef5b3a5179aeff751e414bcf0b8d489706912	\\xc30d04070302175d7165162276396fd236018660f4dc49457932bb5a40331202ff7bb5ed0fda54e66d189a0bea52d8a5cef6219490b845f0654cdf92c5d989ebe0db6eb5769662	Bezos.Thomas@gmail.com	0	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
11	\\xc30d04070302ba23b7458f93ac4867d2380124d9ae42256e3420b2439591b757985b6991fcbff6b9022565c0b7542bcd798a9332cd20496d0efc90ab6ba153ff5466ac4c4ef57fe77f	\\xc30d0407030293ffad6441ef64d670d23901a1ae855d150e45adba34024810158fd249d6bc748da9df87422cbf1af3a1707277c49a1f771d915c4169a4f0298e95c1fd0fde5a8b1d1a85	Mercumry.Waluigi@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
52	\\xc30d04070302e14117079d28980a67d237013e7f5a4ce0598b748c8b19211a92b61601dbe823e91646d3859ad6b663d9d0bcc1797dfc498b120bbd99dad47b5882e66754aeb4989d	\\xc30d040703026c6c9269380eec6467d23f010808d1b8fc4f67685908ebcf5b88ce8ff17f5085cefb96c2aa828e3c43e48f0b4b7f223bbf24924e596801f392aee4e63e151aef60557c2073bb78589a45	tanacm@gmail.com	1	\N	\N	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
1	\\xc30d04070302c4baf481583fa18172d236017197398625e28bb24bf8f4a7a52410ebbc1487d21e61bd46f1d43e3290214a2649d466bf7585a9362aec0e062ead91ebddd7abfbe0	\\xc30d04070302298d8dd063b405ef65d238013f94b7863a064d21b598870626447ec88153d42e76b104c09585d9f743c36c9dc5119f128e02a7a932e26bd1a24619af39c24d82365320	Wankler.Karel@gmail.com	1	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
12	\\xc30d04070302417884a8e771f3cc72d23601733d42c668ce02824f4a51f75ee38e2a3b773f0ca2c757d768aa2e99b4d304e7363315058ec723b6466f23d35002fbdff53c00adcb	\\xc30d04070302771b72e1fb37abb074d23c011cbbc2f2348e0694b755ed3820c484dcd4ae6a3afc33e425b79c240f9a40d9602ac17e830161f147cc0a5bf18c9f29cd2c99408c3aa3c058a71b28	Drilldorzek.Marge@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
13	\\xc30d04070302a6677c053c70c8bc77d236010408a185984f52a0f6575da14af9e6420bf3f335308604aa0aceca103dbc739952d90b1ff90e98839006556d4f7c5e532850172ae9	\\xc30d04070302d2f0fae7af02cb5f71d23a01729ecd8b00b3ad0b1374705349947dad548c399a78d3122b3b6cf49951ff685131e4e66a75d6b57fc2ef276cc5d2eda4fae6223111142ba11d	Minecraft.Steve@gmail.com	1	https://thispersondoesnotexist.com/image	5	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
14	\\xc30d040703022c7acecd9904ab9561d23701425e5686bd238436d2f6a12f4f99aeadf53fd05dfc7519ff3d06baf4270168a2527713c779ff11b0a9a584444185af42051887216b85	\\xc30d040703027f79d08402456b1166d24001e7cac91c2db59f16454813b25a042aca547ebfee200ce374336121ca9e7d047f37843f1cca157fcf1dfd8074e37caae36d5423acd300ec6339fe8a72c3802f	BDSmorelikeBDSM.Borzek@gmail.com	1	https://thispersondoesnotexist.com/image	5	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
15	\\xc30d040703028d94d6efb6d3c22a79d23b01cc334ebe61ac584ca01c64c9e05646275565a24b420248ed1bcf6a7af5a5deaa01bc2f55eb420003a2db11849102a2e09b22ec37c3ea887c9a03	\\xc30d040703028a8ea6c6d461dad464d23a019484a6773aca73d3bebb99e11b593c362a129d7e3f592212e79edaa0c3e91025e7ca2d466f82697bf13998e3a59cd4325235c147f4d46c1a46	Minecraft.Leopoldius@gmail.com	1	https://thispersondoesnotexist.com/image	5	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
16	\\xc30d040703022e7c4b218a6e1fc17fd23601150946d6197a303ef19ed1d1f1105857a5bb190b0b3405e2cb4c87257d93ae091fd7320e6c18d8a4eb896205a96125308f73bedba8	\\xc30d04070302097ed017975bb55d6fd2350197a7343954cc000e616b6e8305f28f343ca2aab0ecd11438f8d0f77714c207e362d499f4eded3722555e9e86016ddd61bb43e74b	Musk.Steve@gmail.com	1	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
17	\\xc30d04070302835b4174345442436ed234013117dd03653b235b95cdd6db89464e5d65dd8f194781889307e59fc2ce65afcab62b2ef9abaca26bf5782792e8477b003c7ee4	\\xc30d04070302ffb7c799b9e1d25b65d2380176130a1595b9a47c8866327718f4705cd5e718ccfd6b2fecb63cb6a10a141644125e750058fa9f49458b9476f0eba164304c877f6f46cd	Wankler.Bob@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
18	\\xc30d040703028be741c0b352d1ba79d23601172a12504419c5893c96d9b2f6444a20ea090b5d54f9839b210b1b8f9bebe580e6d6fe27f104462a79266a7167b943dd949199f0b1	\\xc30d040703022868f72c9509589666d23501aaab1414fd725dc41e51171929f1505b6cade41ca59e3f6473fec89ef2877d2e069576bb32cfc16684cfa18af2561cecf26cf6e7	Musk.Shrek@gmail.com	0	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
19	\\xc30d0407030281397a6f877c83526ad23701b7a26a12f5dec1731a74a3c0b37752ab9873bbdd108cf5edde9f2cd09f75b40edbd6b35222187f9d3679de4bdc287dd700d19d95cf4e	\\xc30d04070302c6adbdba8ded073a79d238018a5f437ee5d34774fd0eaa809d8e28d0a4be6ddd04135f934b87acdcba52cc40a619d7c60ae7bd63c5b62531c27173c486c67674c987ec	Wankler.Thomas@gmail.com	0	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
21	\\xc30d040703025cec9b72f74028b96ed23801ae6185405eb96399d9cb5446700ac103f83fc30aa82a246a946b581b801168e27286472c6e8a05b97bf044890d0dcdc7db512814f64fce	\\xc30d040703021d7c041b9310295d66d23d01eca98863ca72ec29a191d2c6d3e058781855f01257f0fc9c5bd24dd2fd22f6849918886b0fa6b0223ddc73a4713d95cbc041a931516d0629486c4d2e	Traumterberk.Mathias@gmail.com	0	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
22	\\xc30d04070302eeac3624e5a7b0c774d23601e4b2dbe3cce6e519d16bcd5ac0d2c56a50b089e616f5b7079bd99ec5a89e6a854dbefc0ac87b5b43bf0930bc90c59cd79d9f317b39	\\xc30d04070302a8dd84da4594648d61d240018fba2c92773e6aa5f7e90e68cf2aa953a37096704dba363b687ec32300347058631f799b0e85a8b0966162458f8ebd39e649ae2b1bec94bc3f20810277d400	BDSmorelikeBDSM.Adolf@gmail.com	1	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
23	\\xc30d040703024b5fd6248a26a1d772d234012c826ef478df874d92fe55029af8c67a3a93ce19e920718a2ee5e229a290e1fd57d4dc075d95a69b290817f4c18c45e22abfa3	\\xc30d0407030241ff63af544c1f096ad23901c38e8b076118d789b8be09cf1daa6850b70d8eb0e4563842a3245e2b97f7978b14c27889ec4a7da306c782f7d6877e464fa7de6c505438de	Mercumry.Rob@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
24	\\xc30d0407030251fd71575c579e4a7dd23601ee6911f05abff29d11e591f3a922bb821e94ccf50f815144be100e3830324da46707103ebdf0578cdca4bf59404006bdfae00898ca	\\xc30d040703026f8cf2640276291f6fd2420129f14efff9fbcf61ba69a9fa6c7a694e1f1af4d39b3586f39b8d02908c808036d2a64c1d5aac0a8f89c6e167b5ae56a36d54112884a66dc43303740341374c55f8	Znowustworzujoncy.Steve@gmail.com	1	https://thispersondoesnotexist.com/image	5	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
25	\\xc30d04070302164e098c82d674ba74d23b019e954ad7accda6f1f1e38e001752fad447839c7c0534140bff464097c16fb78d7100fdd32a9edcca7ab35a07031f55e1e9181060cb12c5ba0a7f	\\xc30d0407030296f101a0dba8ceab7ed240016ee64fa9734ddd7df8efd74eef0c08b52f9f64b523e751b18d0ce96e1ef2fae25019be2e294bd527cd3d52d516f68daa1c0ace253e29cb87b82650e378c926	BDSmorelikeBDSM.Leopoldius@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
26	\\xc30d04070302ed519cb6aaa06a0978d23801ecf5314860d9959707e044a579fd590c8c4901aa00aca76ec42eb9bb98bb7d133b32a3e01d02ffffcf9a347a3e23411200d5820d548ef7	\\xc30d0407030223cd0696600d8f1e71d23a01f5f90178c28b9daad3b5c5d47eec8c46b333722f440b2ec460cfda9091315c98c9ab4047767002e959b55452d9fe958a5ace384fa96062a7d2	Minecraft.Mathias@gmail.com	1	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
27	\\xc30d040703027e13519afd9e9a5869d23701d35cfa0c998b69d42174e0d3f3cacad6b46f531e9ff2c863d1984a073617c347cfcafe57b06794c3299e8c8cded34890993e0a1b19bd	\\xc30d0407030259f7891a73ef7c3c79d23901a679fc82e0c6847a726f48a1e7743fbea42e483c95c48cc67f8c174cf0330df23288a1f2e675b48750c900806adedb5cf4ae4a57ba59d286	ILOVESQL.Thomas@gmail.com	0	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
28	\\xc30d04070302fdfed852ec8faad061d236017c3e6af58b410c5946fca6284dc789490fa44b03f054e9b078be7051dc977bd04b3b77fb561ae43770993da9e178d80e16e1f84164	\\xc30d04070302450279457bbc5cd670d24201f2dd5f18da21d4d28d307012e88e579059fc2203744ad93985e4d96cf3c633ed73a1b75ff6e505d6612067e7f37b8cc140bebdbcd1d1d16dce801745db896a0dec	Znowustworzujoncy.Adolf@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
30	\\xc30d0407030217b06343da0ee3f679d23701e4fc3bcdf599174030c94fee187044a63dd6c9f30197f20602b31bb510b8b7199df5b1ce2c35e5df2f8b1ffaa7f7fa39eef6d48a2710	\\xc30d0407030217e40851ae83777e60d23a015633cb5c6bf0e7935bb46208b15972bf969d16f7b13177ab3752a41ec5442dfcc1f7f378367ab8d29a43aca9d1f8dce8e86bac3c730b84f165	Minecraft.Borzek@gmail.com	1	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
31	\\xc30d040703020e682f4e556af66765d23601d30a2a7c05b9ca7e940ba1bcb5016bf72d2ad55d74157b27fa20d8439a7bea0b2da6271214b81ed7257672f081f6bbcde8b2258c9c	\\xc30d04070302869a244bd53d655674d236015eea94eeffac3d1c1d64d5f9852901c50751afad9a37c9cdb0ce63e20e6e5b0e19cae38cdde0967a4be7eef24c212847a51aca44c1	Dover.Marge@gmail.com	0	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
35	\\xc30d04070302b1f241c655895bdb6bd2360147852ee6b0d2c03e17f451e31489afbe7c3af4479b81f60c37074bf986ce8855e4861685c811453228b7938d5f895228a360d70292	\\xc30d040703024fd514278921e65f6dd2350168c46eb4e03784fb1f38ad3c2ccc61db63a342dcb483e15b5de7907a3513d1454870f32515598b280ce6aa67e6dfbee5bc1061d2	Musk.Marge@gmail.com	0	https://thispersondoesnotexist.com/image	5	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
33	\\xc30d04070302a4e45c72ffc3041c6dd23701f4e70f51a32d401a174aff40879b3a4c97c68e4ebbc026700bf71935398b1c12b857c187b751fb87ab013e6f8ad97178b2fee43c2086	\\xc30d04070302d0512cc00cf8f59077d23a01a99aa77ae212ca82d69afc593a256fa522658112a164145838691038ba3a9fa4d89e0423758def3bcee08d367bde83b88b7299c55b0119f07d	Minecraft.Thomas@gmail.com	0	https://thispersondoesnotexist.com/image	2	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
36	\\xc30d04070302cd64b9399bf9786a68d2380192ec7c81aac2133114cf091bfe7ada3f02a6825f5d14bb302c7a2619671ca989aadb8f07fab87f23f28b70e94ad7400f7c23abb3e2cc09	\\xc30d040703027f540861e2d96cfc63d23a0103d4044695f227e35ff4958b7fc2ab4b53d2198a27014dc7215bfded438098003b8877fb8eb631276167aca5b19ed0492c73921f1737806f24	Tightanus.Freddie@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
37	\\xc30d040703029d552a3a6ec3eb4379d23401050ff57f273378976fa0aac45bf2c52b692da8528ba686ddd8c8fc2754b5154696113a68120b14cf713737cfb8c16d6aaa5867	\\xc30d040703023e4fadf6c76817ce72d23601f7a6364219c29840f7967abc5f355a36651794ba71ade0f62023e1318218f57086434eebd9773244582d75196b11ee716f658df82b	Bezos.Bob@gmail.com	0	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
38	\\xc30d04070302d6c26d81eff6f27570d237018c6aa8b1b244a0144c80991dfe0fd6dbf33d08356a364dc9166bf4c02d266149116fbec1864e944fe30f38ef62559a16bac504ef840d	\\xc30d04070302301cc1ac8e33cffe60d242019ed89e8abdb93a693034bde98f68411601ccab2d30f7c265e34ad87af5110e1fa93ee43d460a242d32a4c39ae80db3d602b333efb16dca66419a1122d2f611fc4f	Znowustworzujoncy.Borzek@gmail.com	0	https://thispersondoesnotexist.com/image	2	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
39	\\xc30d0407030238e0309372d6729f6bd23701d5ab1d3d63dc8534a60bb15637838d4d0b3cc24e8ead6f61fe71dfb4523f8852eaa1c6fb1d2d4c180d38013b691ce4947763ed81b5d5	\\xc30d04070302b5a95e5adf2666c477d2390165276984f19b9f869bcafc256949077eb1ed48d8018c5ffd854034ff4b0fa4f99d585f261d4689e85d056eb5bc86bcb76e2df7b86708eb7d	ILOVESQL.Borzek@gmail.com	0	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
40	\\xc30d040703020b6268d7b05a89cc7ad23301658aa129dd32d3092e5cd58cc699912f877983eaffff93674cf34eb93399b44b3459cee4e92b47af845b44dab61f65ecfadc	\\xc30d040703029a006e75c336e0826ed23a01d8d8e13cc06a32be5a3fb74ffdf97204175dac5bc06ad5dc73004e64595f5aeca8f7d817245f72386b1e040cfef9553ba94de4f89f8ae6458d	Tightanus.Xi@gmail.com	0	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
41	\\xc30d0407030268c0040692fcbb1b63d23501238a933f8a574596aa058f677bfc8c597b9b5bf00a2a254e78f8b7b1f9981c7507ce794b71b482f97c5ab1bcc03de0ae7a9327d3	\\xc30d040703023335f362e935ecd86dd23c0128b3fa531056d7254a9c5682ba18c027f7206b2f93e8cbca897a70c9207d8f1d1c3a20b704990fb5dce5b5f5410886b5f9f45b45ff7209db70067b	Drilldorzek.Bruh@gmail.com	0	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
42	\\xc30d04070302424aaa6782bd79d36fd23601fccfe42801da1fe98fbd2539fab564180bc9ff58770d86b8046abd0e6e35eb51f9b64b0756d064c6d99a8b126410654b60fcfbfd1e	\\xc30d04070302f3a5838aff7d30b26bd238013566ce90779e868d1060ba7c76bd9cae5bb250683587d03afe2b3d26b7e12a5f16201ce0eafcea569ce707951ea7d641c3c8288f88d28a	Wankler.Adolf@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
43	\\xc30d04070302985544ab1dde45936cd235010f5f01094f3b467e56f6b5f60b418a58c6d29e18246179711c9d252be4772fe79b724631f99a25a6c5b6161571f38d91a3df8575	\\xc30d04070302e5bee0bbf42807397bd23a0163c3379a544967878698624ea2f1696a3065c94240f087ae199c46b05416acb9e5f0eb22a59a6c8b7b9eebcede10d348a4256f8e52a5a910b5	Minecraft.Alex@gmail.com	0	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
44	\\xc30d040703021b5f02d4a088a5c67cd23501acd58e7fd6814e0ab012fab4cf1db5fcfd99096280d86423d1505fdf263992c0f33ffd20160297723118d4b947726324b1caa64e	\\xc30d04070302e8cc38f15c570d6a69d23801cc32751ff6e3f2d58860393dbd5a63f9d72c3cab7f0ab81066db4d2601d57285e81255e8608eeea3970ff84db43ce76eb1c810d9da1892	Wankler.Bruh@gmail.com	0	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
45	\\xc30d040703021506a5dd1974f5d878d2370148264ea0f4041fa79f0c3f5853142e64b8ad7b3edf9380ff2e0d97e2e753865948b1509944db9596edcdc1a178fe6515ff3a87130bc5	\\xc30d04070302cbcccb49e05bd57f6ed23d01fd5090c5c389ac7ffac19c3df7a3f6eb09b55e99181f23a2fe9dd07944f5f4a8ded79401b42899d4537bafbce5015179fc4f773daf03c060e3b8eb57	Traumterberk.Thomas@gmail.com	0	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
46	\\xc30d04070302b9a9c223f4f7ba327bd23801b1dbf36069104d40eaee829f44e36181e17d2e29e95fb326d5eecddb84ed154b003f60b96000a27ddc0fd75b017bec46ca9d0d84d9bf08	\\xc30d04070302d2be839d7069b7877dd24001b42f3505b0382dc092024108288d8cb3490c7c8d8d6bdff444fd98de6ac75be6f9a1113d4f35caf358dfec5e359a6378b59dd754f1523266042620332a644c	BDSmorelikeBDSM.Mathias@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
47	\\xc30d04070302e9e9e9763a1f96a164d2380165bb8ff09d4abf30b9f3c648dfd8178d38d2f74d13e9b013f02ede59359e9e3491da85367b67b7c9919dd1ddeec6055b346cc117042754	\\xc30d04070302ef82f2b36e068d8176d236012639f860b0a76c870324a591705de4b50df7aef9503386a7bced167ece6549ef96bba94c71bbc5cd573138a1256ab87893d1830506	Bezos.Freddie@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
48	\\xc30d04070302a917edbc3fb4b05c6ed23701dc813c8b5e6a04ed3bcd4f1e1f01a66e0ad267807b65954538e5959e7ac3515b68ff2e3bd634cbdcc1254921f26831e7fbe530973aa0	\\xc30d0407030276c6113f934b06977cd23601948108d4353a8c9238ded12193d522c276d64bd7d544a89e3eb10b4de8f1de028f23617bc5430f9c2811ccc9b579df4fe3ef1ba7e2	Dover.Borzek@gmail.com	0	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
49	\\xc30d04070302e30bec9823f643046ed2360124946460be386b74d8449a26cf7723f04a1e0df50062f1bedde37f63cdb837721fbbcbcb61e3b90e540fcbdce61dc099ee0f65627e	\\xc30d0407030259fcb0b71af6985765d23d01e8cdc4b330d15401c4475f92388e1971db3f8f98900f210a006521f5a1cb113611b00a2121d551279a89b1cff9f3806afb7df416fb989a4083e96f9a	Traumterberk.Adolf@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
50	\\xc30d040703029bbd5ac5e67963a46ed23801b2f5177e0cc49a0f2ef313bef61fd268162dc15815b4f937b74fdb9ba267486f7a215e74175b2385a6fee353dc07616ce62618e9916748	\\xc30d0407030254b527653559581278d240015d4090c7355b7ad0a2535166ae764c6f2e4008b57f4940b962e800bea36a0fe57fefd70f59d1bbc393eb77f355deebc5e1df9cce5b0dc273183bcfa23f7c86	BDSmorelikeBDSM.Freddie@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
\.


--
-- Data for Name: user_contacts; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.user_contacts (user_id, contact_type_id, address) FROM stdin;
1	2	mymail@gmail.com
37	3	fb.com/myacc
14	5	github.com/myacc2
12	4	twitter.com/@myAcc
7	1	+420132456789
\.


--
-- Data for Name: user_course; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.user_course (user_id, course_id, certificate_id, course_rating, user_feedback) FROM stdin;
1	2	1	\N	\N
2	1	2	9	Me likey.
37	3	3	8	Was oke.
3	4	4	1	Sucks.
49	5	5	\N	\N
1	1	\N	\N	\N
1	3	\N	\N	\N
1	4	\N	\N	\N
1	5	\N	\N	\N
\.


--
-- Data for Name: user_subscription; Type: TABLE DATA; Schema: project; Owner: postgres
--

COPY project.user_subscription (user_id, subscription_id, start, "end") FROM stdin;
27	3	2021-10-24 16:38:23.654867	2021-11-24 16:38:23.654867
11	4	2021-10-24 16:38:23.654867	2022-10-24 16:38:23.654867
3	2	2021-10-24 16:38:23.654867	2022-10-24 16:38:23.654867
44	5	2021-10-24 16:38:23.654867	2021-11-24 16:38:23.654867
5	2	2021-10-24 16:38:23.654867	2022-10-24 16:38:23.654867
\.


--
-- Name: certificate_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.certificate_id_seq', 6, true);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.comments_id_seq', 14, true);


--
-- Name: contact_type_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.contact_type_id_seq', 5, true);


--
-- Name: course_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.course_id_seq', 5, true);


--
-- Name: feedback_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.feedback_id_seq', 11, true);


--
-- Name: lesson_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.lesson_id_seq', 60, true);


--
-- Name: nation_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.nation_id_seq', 6, true);


--
-- Name: relationship_type_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.relationship_type_id_seq', 5, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.subscription_id_seq', 5, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: project; Owner: postgres
--

SELECT pg_catalog.setval('project.user_id_seq', 53, true);


--
-- Name: certificate certificate_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.certificate
    ADD CONSTRAINT certificate_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: contact_type contact_type_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.contact_type
    ADD CONSTRAINT contact_type_pkey PRIMARY KEY (id);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (id);


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (id);


--
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (id);


--
-- Name: nation nation_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.nation
    ADD CONSTRAINT nation_pkey PRIMARY KEY (id);


--
-- Name: relationship_type relationship_type_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.relationship_type
    ADD CONSTRAINT relationship_type_pkey PRIMARY KEY (id);


--
-- Name: subscription subscription_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (id);


--
-- Name: user uniq_email; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project."user"
    ADD CONSTRAINT uniq_email UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: c_idx; Type: INDEX; Schema: project; Owner: postgres
--

CREATE INDEX c_idx ON project.course USING btree (name);


--
-- Name: idx; Type: INDEX; Schema: project; Owner: postgres
--

CREATE INDEX idx ON project.lesson USING btree (name);


--
-- Name: relationship friendship; Type: TRIGGER; Schema: project; Owner: postgres
--

CREATE TRIGGER friendship AFTER INSERT ON project.relationship FOR EACH STATEMENT EXECUTE FUNCTION public.say_hooray();


--
-- Name: blocked_profiles blocked_profiles_blocked_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.blocked_profiles
    ADD CONSTRAINT blocked_profiles_blocked_id_fkey FOREIGN KEY (blocked_id) REFERENCES project."user"(id) ON DELETE CASCADE;


--
-- Name: blocked_profiles blocked_profiles_blocker_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.blocked_profiles
    ADD CONSTRAINT blocked_profiles_blocker_id_fkey FOREIGN KEY (blocker_id) REFERENCES project."user"(id) ON DELETE CASCADE;


--
-- Name: comments comments_lesson_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.comments
    ADD CONSTRAINT comments_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES project.lesson(id) ON DELETE CASCADE;


--
-- Name: comments comments_user_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES project."user"(id);


--
-- Name: completed_lessons completed_lessons_lesson_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.completed_lessons
    ADD CONSTRAINT completed_lessons_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES project.lesson(id) ON DELETE CASCADE;


--
-- Name: completed_lessons completed_lessons_user_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.completed_lessons
    ADD CONSTRAINT completed_lessons_user_id_fkey FOREIGN KEY (user_id) REFERENCES project."user"(id) ON DELETE CASCADE;


--
-- Name: course course_requires_premium_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.course
    ADD CONSTRAINT course_requires_premium_fkey FOREIGN KEY (requires_premium) REFERENCES project.subscription(id);


--
-- Name: feedback feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.feedback
    ADD CONSTRAINT feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES project."user"(id);


--
-- Name: lesson lesson_course_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.lesson
    ADD CONSTRAINT lesson_course_id_fkey FOREIGN KEY (course_id) REFERENCES project.course(id);


--
-- Name: lesson lesson_requires_premium_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.lesson
    ADD CONSTRAINT lesson_requires_premium_fkey FOREIGN KEY (requires_premium) REFERENCES project.subscription(id);


--
-- Name: relationship relationship_relationship_type_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.relationship
    ADD CONSTRAINT relationship_relationship_type_id_fkey FOREIGN KEY (relationship_type_id) REFERENCES project.relationship_type(id);


--
-- Name: relationship relationship_user1_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.relationship
    ADD CONSTRAINT relationship_user1_id_fkey FOREIGN KEY (user1_id) REFERENCES project."user"(id) ON DELETE CASCADE;


--
-- Name: relationship relationship_user2_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.relationship
    ADD CONSTRAINT relationship_user2_id_fkey FOREIGN KEY (user2_id) REFERENCES project."user"(id) ON DELETE CASCADE;


--
-- Name: user_contacts user_contacts_contact_type_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.user_contacts
    ADD CONSTRAINT user_contacts_contact_type_id_fkey FOREIGN KEY (contact_type_id) REFERENCES project.contact_type(id);


--
-- Name: user_contacts user_contacts_user_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.user_contacts
    ADD CONSTRAINT user_contacts_user_id_fkey FOREIGN KEY (user_id) REFERENCES project."user"(id) ON DELETE CASCADE;


--
-- Name: user_course user_course_certificate_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.user_course
    ADD CONSTRAINT user_course_certificate_id_fkey FOREIGN KEY (certificate_id) REFERENCES project.certificate(id);


--
-- Name: user_course user_course_course_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.user_course
    ADD CONSTRAINT user_course_course_id_fkey FOREIGN KEY (course_id) REFERENCES project.course(id) ON DELETE CASCADE;


--
-- Name: user_course user_course_user_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.user_course
    ADD CONSTRAINT user_course_user_id_fkey FOREIGN KEY (user_id) REFERENCES project."user"(id) ON DELETE CASCADE;


--
-- Name: user user_nation_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project."user"
    ADD CONSTRAINT user_nation_id_fkey FOREIGN KEY (nation_id) REFERENCES project.nation(id);


--
-- Name: user_subscription user_subscription_subscription_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.user_subscription
    ADD CONSTRAINT user_subscription_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES project.subscription(id);


--
-- Name: user_subscription user_subscription_user_id_fkey; Type: FK CONSTRAINT; Schema: project; Owner: postgres
--

ALTER TABLE ONLY project.user_subscription
    ADD CONSTRAINT user_subscription_user_id_fkey FOREIGN KEY (user_id) REFERENCES project."user"(id) ON DELETE CASCADE;


--
-- Name: SCHEMA project; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA project TO java_user;


--
-- Name: TABLE blocked_profiles; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project.blocked_profiles TO java_user;


--
-- Name: TABLE certificate; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project.certificate TO java_user;


--
-- Name: SEQUENCE certificate_id_seq; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE project.certificate_id_seq TO java_user;


--
-- Name: TABLE comments; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE project.comments TO java_user;


--
-- Name: SEQUENCE comments_id_seq; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE project.comments_id_seq TO java_user;


--
-- Name: TABLE completed_lessons; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE project.completed_lessons TO java_user;


--
-- Name: TABLE contact_type; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project.contact_type TO java_user;


--
-- Name: SEQUENCE contact_type_id_seq; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE project.contact_type_id_seq TO java_user;


--
-- Name: TABLE course; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project.course TO student;
GRANT SELECT ON TABLE project.course TO java_user;


--
-- Name: SEQUENCE course_id_seq; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE project.course_id_seq TO java_user;


--
-- Name: TABLE feedback; Type: ACL; Schema: project; Owner: postgres
--

GRANT ALL ON TABLE project.feedback TO java_user;


--
-- Name: SEQUENCE feedback_id_seq; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE project.feedback_id_seq TO java_user;


--
-- Name: TABLE lesson; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE project.lesson TO teacher;
GRANT SELECT ON TABLE project.lesson TO student;
GRANT SELECT ON TABLE project.lesson TO java_user;


--
-- Name: SEQUENCE lesson_id_seq; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE project.lesson_id_seq TO java_user;


--
-- Name: TABLE nation; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project.nation TO java_user;


--
-- Name: SEQUENCE nation_id_seq; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE project.nation_id_seq TO java_user;


--
-- Name: TABLE relationship; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project.relationship TO java_user;


--
-- Name: TABLE relationship_type; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project.relationship_type TO java_user;


--
-- Name: SEQUENCE relationship_type_id_seq; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE project.relationship_type_id_seq TO java_user;


--
-- Name: TABLE subscription; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project.subscription TO java_user;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE project.subscription_id_seq TO java_user;


--
-- Name: TABLE "user"; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project."user" TO java_user;


--
-- Name: TABLE user_contacts; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project.user_contacts TO java_user;


--
-- Name: TABLE user_course; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE project.user_course TO java_user;


--
-- Name: SEQUENCE user_id_seq; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE project.user_id_seq TO java_user;


--
-- Name: TABLE user_subscription; Type: ACL; Schema: project; Owner: postgres
--

GRANT SELECT ON TABLE project.user_subscription TO java_user;


--
-- Name: users_per_free_lesson; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.users_per_free_lesson;


--
-- PostgreSQL database dump complete
--

