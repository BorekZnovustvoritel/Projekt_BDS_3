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
    first_name character varying(45) NOT NULL,
    last_name character varying(45) NOT NULL,
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
-- Name: teachers_view_on_user; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.teachers_view_on_user AS
 SELECT "user".id,
    "user".first_name,
    "user".last_name,
    "user".email
   FROM project."user";


ALTER TABLE public.teachers_view_on_user OWNER TO postgres;

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
6	1	1	Is quite fun.
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
7	2	
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
2	Freddie	Znowustworzujoncy	Znowustworzujoncy.Freddie@gmail.com	1	https://thispersondoesnotexist.com/image	2	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
3	Freddie	Wankler	Wankler.Freddie@gmail.com	1	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
4	Alex	BDSmorelikeBDSM	BDSmorelikeBDSM.Alex@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
5	Karel	Tightanus	Tightanus.Karel@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
6	Jean	Dicktit	Dicktit.Jean@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
7	Ben	Dover	Dover.Ben@gmail.com	0	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
9	Bruh	Znowustworzujoncy	Znowustworzujoncy.Bruh@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
10	Thomas	Bezos	Bezos.Thomas@gmail.com	0	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
11	Waluigi	Mercumry	Mercumry.Waluigi@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
52	Táňa	Čmeláčková	tanacm@gmail.com	1	\N	\N	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
1	Karel	Wankler	Wankler.Karel@gmail.com	1	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
12	Marge	Drilldorzek	Drilldorzek.Marge@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
13	Steve	Minecraft	Minecraft.Steve@gmail.com	1	https://thispersondoesnotexist.com/image	5	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
14	Borzek	BDSmorelikeBDSM	BDSmorelikeBDSM.Borzek@gmail.com	1	https://thispersondoesnotexist.com/image	5	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
15	Leopoldius	Minecraft	Minecraft.Leopoldius@gmail.com	1	https://thispersondoesnotexist.com/image	5	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
16	Steve	Musk	Musk.Steve@gmail.com	1	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
17	Bob	Wankler	Wankler.Bob@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
18	Shrek	Musk	Musk.Shrek@gmail.com	0	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
19	Thomas	Wankler	Wankler.Thomas@gmail.com	0	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
21	Mathias	Traumterberk	Traumterberk.Mathias@gmail.com	0	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
22	Adolf	BDSmorelikeBDSM	BDSmorelikeBDSM.Adolf@gmail.com	1	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
23	Rob	Mercumry	Mercumry.Rob@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
24	Steve	Znowustworzujoncy	Znowustworzujoncy.Steve@gmail.com	1	https://thispersondoesnotexist.com/image	5	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
25	Leopoldius	BDSmorelikeBDSM	BDSmorelikeBDSM.Leopoldius@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
26	Mathias	Minecraft	Minecraft.Mathias@gmail.com	1	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
27	Thomas	ILOVESQL	ILOVESQL.Thomas@gmail.com	0	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
28	Adolf	Znowustworzujoncy	Znowustworzujoncy.Adolf@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
30	Borzek	Minecraft	Minecraft.Borzek@gmail.com	1	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
31	Marge	Dover	Dover.Marge@gmail.com	0	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
35	Marge	Musk	Musk.Marge@gmail.com	0	https://thispersondoesnotexist.com/image	5	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
33	Thomas	Minecraft	Minecraft.Thomas@gmail.com	0	https://thispersondoesnotexist.com/image	2	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
36	Freddie	Tightanus	Tightanus.Freddie@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
37	Bob	Bezos	Bezos.Bob@gmail.com	0	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
38	Borzek	Znowustworzujoncy	Znowustworzujoncy.Borzek@gmail.com	0	https://thispersondoesnotexist.com/image	2	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
39	Borzek	ILOVESQL	ILOVESQL.Borzek@gmail.com	0	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
40	Xi	Tightanus	Tightanus.Xi@gmail.com	0	https://thispersondoesnotexist.com/image	6	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
41	Bruh	Drilldorzek	Drilldorzek.Bruh@gmail.com	0	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
42	Adolf	Wankler	Wankler.Adolf@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
43	Alex	Minecraft	Minecraft.Alex@gmail.com	0	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
44	Bruh	Wankler	Wankler.Bruh@gmail.com	0	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
45	Thomas	Traumterberk	Traumterberk.Thomas@gmail.com	0	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
46	Mathias	BDSmorelikeBDSM	BDSmorelikeBDSM.Mathias@gmail.com	1	https://thispersondoesnotexist.com/image	1	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
47	Freddie	Bezos	Bezos.Freddie@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
48	Borzek	Dover	Dover.Borzek@gmail.com	0	https://thispersondoesnotexist.com/image	4	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
49	Adolf	Traumterberk	Traumterberk.Adolf@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
50	Freddie	BDSmorelikeBDSM	BDSmorelikeBDSM.Freddie@gmail.com	1	https://thispersondoesnotexist.com/image	3	$2a$12$51h0FPMzudGHzvjoSomo.O4Dx3pBoPoeJPgdWwX6iZqWNz1mtAnYW
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

SELECT pg_catalog.setval('project.comments_id_seq', 10, true);


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

SELECT pg_catalog.setval('project.feedback_id_seq', 7, true);


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

