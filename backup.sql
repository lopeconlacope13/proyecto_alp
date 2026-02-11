--
-- PostgreSQL database dump
--

\restrict XAiBX98292OYIYIEZCgYdSKHxI1xcWDexlaCth1jE1MyZsVJKaVoXCcx8ZzDm1j

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

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

ALTER TABLE IF EXISTS ONLY public.pedido_producto DROP CONSTRAINT IF EXISTS fk_dd333c27645698e;
ALTER TABLE IF EXISTS ONLY public.pedido_producto DROP CONSTRAINT IF EXISTS fk_dd333c24854653a;
ALTER TABLE IF EXISTS ONLY public.pedido DROP CONSTRAINT IF EXISTS fk_c4ec16cedb38439e;
ALTER TABLE IF EXISTS ONLY public.producto DROP CONSTRAINT IF EXISTS fk_a7bb06153397707a;
DROP TRIGGER IF EXISTS notify_trigger ON public.messenger_messages;
DROP INDEX IF EXISTS public.uniq_identifier_login;
DROP INDEX IF EXISTS public.idx_dd333c27645698e;
DROP INDEX IF EXISTS public.idx_dd333c24854653a;
DROP INDEX IF EXISTS public.idx_c4ec16cedb38439e;
DROP INDEX IF EXISTS public.idx_a7bb06153397707a;
DROP INDEX IF EXISTS public.idx_75ea56e0fb7336f0;
DROP INDEX IF EXISTS public.idx_75ea56e0e3bd61ce;
DROP INDEX IF EXISTS public.idx_75ea56e016ba31db;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_pkey;
ALTER TABLE IF EXISTS ONLY public.producto DROP CONSTRAINT IF EXISTS producto_pkey;
ALTER TABLE IF EXISTS ONLY public.pedido_producto DROP CONSTRAINT IF EXISTS pedido_producto_pkey;
ALTER TABLE IF EXISTS ONLY public.pedido DROP CONSTRAINT IF EXISTS pedido_pkey;
ALTER TABLE IF EXISTS ONLY public.messenger_messages DROP CONSTRAINT IF EXISTS messenger_messages_pkey;
ALTER TABLE IF EXISTS ONLY public.doctrine_migration_versions DROP CONSTRAINT IF EXISTS doctrine_migration_versions_pkey;
ALTER TABLE IF EXISTS ONLY public.categoria DROP CONSTRAINT IF EXISTS categoria_pkey;
ALTER TABLE IF EXISTS public.usuario ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.producto ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.pedido_producto ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.pedido ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.messenger_messages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.categoria ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.usuario_id_seq;
DROP TABLE IF EXISTS public.usuario;
DROP SEQUENCE IF EXISTS public.producto_id_seq;
DROP TABLE IF EXISTS public.producto;
DROP SEQUENCE IF EXISTS public.pedido_producto_id_seq;
DROP TABLE IF EXISTS public.pedido_producto;
DROP SEQUENCE IF EXISTS public.pedido_id_seq;
DROP TABLE IF EXISTS public.pedido;
DROP SEQUENCE IF EXISTS public.messenger_messages_id_seq;
DROP TABLE IF EXISTS public.messenger_messages;
DROP TABLE IF EXISTS public.doctrine_migration_versions;
DROP SEQUENCE IF EXISTS public.categoria_id_seq;
DROP TABLE IF EXISTS public.categoria;
DROP FUNCTION IF EXISTS public.notify_messenger_messages();
--
-- Name: notify_messenger_messages(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.notify_messenger_messages() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
                PERFORM pg_notify('messenger_messages', NEW.queue_name::text);
                RETURN NEW;
            END;
        $$;


ALTER FUNCTION public.notify_messenger_messages() OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categoria; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.categoria (
    id integer NOT NULL,
    codigo character varying(6) NOT NULL,
    nombre character varying(255) NOT NULL
);


ALTER TABLE public.categoria OWNER TO admin;

--
-- Name: categoria_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.categoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categoria_id_seq OWNER TO admin;

--
-- Name: categoria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.categoria_id_seq OWNED BY public.categoria.id;


--
-- Name: doctrine_migration_versions; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.doctrine_migration_versions (
    version character varying(191) NOT NULL,
    executed_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    execution_time integer
);


ALTER TABLE public.doctrine_migration_versions OWNER TO admin;

--
-- Name: messenger_messages; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.messenger_messages (
    id bigint NOT NULL,
    body text NOT NULL,
    headers text NOT NULL,
    queue_name character varying(190) NOT NULL,
    created_at timestamp(0) without time zone NOT NULL,
    available_at timestamp(0) without time zone NOT NULL,
    delivered_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone
);


ALTER TABLE public.messenger_messages OWNER TO admin;

--
-- Name: COLUMN messenger_messages.created_at; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON COLUMN public.messenger_messages.created_at IS '(DC2Type:datetime_immutable)';


--
-- Name: COLUMN messenger_messages.available_at; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON COLUMN public.messenger_messages.available_at IS '(DC2Type:datetime_immutable)';


--
-- Name: COLUMN messenger_messages.delivered_at; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON COLUMN public.messenger_messages.delivered_at IS '(DC2Type:datetime_immutable)';


--
-- Name: messenger_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.messenger_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messenger_messages_id_seq OWNER TO admin;

--
-- Name: messenger_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.messenger_messages_id_seq OWNED BY public.messenger_messages.id;


--
-- Name: pedido; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.pedido (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    fecha date NOT NULL,
    coste numeric(10,2) NOT NULL,
    code character varying(4) NOT NULL
);


ALTER TABLE public.pedido OWNER TO admin;

--
-- Name: pedido_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_id_seq OWNER TO admin;

--
-- Name: pedido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.pedido_id_seq OWNED BY public.pedido.id;


--
-- Name: pedido_producto; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.pedido_producto (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    producto_id integer NOT NULL,
    unidades integer NOT NULL,
    no character varying(255) NOT NULL
);


ALTER TABLE public.pedido_producto OWNER TO admin;

--
-- Name: pedido_producto_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.pedido_producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_producto_id_seq OWNER TO admin;

--
-- Name: pedido_producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.pedido_producto_id_seq OWNED BY public.pedido_producto.id;


--
-- Name: producto; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.producto (
    id integer NOT NULL,
    categoria_id integer NOT NULL,
    precio double precision NOT NULL,
    codigo character varying(6) NOT NULL,
    nombre character varying(255) NOT NULL,
    nombre_corto character varying(50) DEFAULT NULL::character varying,
    descripcion text NOT NULL
);


ALTER TABLE public.producto OWNER TO admin;

--
-- Name: producto_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_id_seq OWNER TO admin;

--
-- Name: producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.producto_id_seq OWNED BY public.producto.id;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.usuario (
    id integer NOT NULL,
    login character varying(180) NOT NULL,
    roles json NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20) DEFAULT NULL::character varying,
    is_verified boolean NOT NULL
);


ALTER TABLE public.usuario OWNER TO admin;

--
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_seq OWNER TO admin;

--
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- Name: categoria id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.categoria ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_seq'::regclass);


--
-- Name: messenger_messages id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.messenger_messages ALTER COLUMN id SET DEFAULT nextval('public.messenger_messages_id_seq'::regclass);


--
-- Name: pedido id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.pedido ALTER COLUMN id SET DEFAULT nextval('public.pedido_id_seq'::regclass);


--
-- Name: pedido_producto id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.pedido_producto ALTER COLUMN id SET DEFAULT nextval('public.pedido_producto_id_seq'::regclass);


--
-- Name: producto id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.producto ALTER COLUMN id SET DEFAULT nextval('public.producto_id_seq'::regclass);


--
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.categoria (id, codigo, nombre) FROM stdin;
1	FER	"Ferreteria"
2	FON	"Fontaneria"
3	ELE	"Electricidad"
4	JAR	"Jardin"
\.


--
-- Data for Name: doctrine_migration_versions; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.doctrine_migration_versions (version, executed_at, execution_time) FROM stdin;
DoctrineMigrations\\Version20251007190027	2025-10-07 19:03:59	40
DoctrineMigrations\\Version20251014190458	2025-10-14 19:05:34	4
DoctrineMigrations\\Version20251203152953	2025-12-03 15:33:41	18
DoctrineMigrations\\Version20260120193020	2026-01-20 19:30:56	31
\.


--
-- Data for Name: messenger_messages; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.messenger_messages (id, body, headers, queue_name, created_at, available_at, delivered_at) FROM stdin;
1	O:36:\\"Symfony\\\\Component\\\\Messenger\\\\Envelope\\":2:{s:44:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0stamps\\";a:1:{s:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\";a:1:{i:0;O:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\":1:{s:55:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\0busName\\";s:21:\\"messenger.bus.default\\";}}}s:45:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0message\\";O:51:\\"Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\":2:{s:60:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0message\\";O:39:\\"Symfony\\\\Bridge\\\\Twig\\\\Mime\\\\TemplatedEmail\\":5:{i:0;s:16:\\"correo.html.twig\\";i:1;N;i:2;a:4:{s:9:\\"pedido_id\\";i:5;s:9:\\"productos\\";a:1:{s:5:\\"JUN01\\";O:19:\\"App\\\\Entity\\\\Producto\\":7:{s:23:\\"\\0App\\\\Entity\\\\Producto\\0id\\";i:12;s:27:\\"\\0App\\\\Entity\\\\Producto\\0precio\\";d:2.5;s:27:\\"\\0App\\\\Entity\\\\Producto\\0codigo\\";s:5:\\"JUN01\\";s:27:\\"\\0App\\\\Entity\\\\Producto\\0nombre\\";s:20:\\"Junta de la Trócola\\";s:32:\\"\\0App\\\\Entity\\\\Producto\\0nombreCorto\\";s:8:\\"La Junta\\";s:32:\\"\\0App\\\\Entity\\\\Producto\\0descripcion\\";s:104:\\"Nadie sabe para qué sirve, pero el fontanero dice que te hace falta y te va a cobrar 50 euros por ella.\\";s:30:\\"\\0App\\\\Entity\\\\Producto\\0categoria\\";O:35:\\"Proxies\\\\__CG__\\\\App\\\\Entity\\\\Categoria\\":3:{s:24:\\"\\0App\\\\Entity\\\\Categoria\\0id\\";i:2;s:28:\\"\\0App\\\\Entity\\\\Categoria\\0codigo\\";N;s:28:\\"\\0App\\\\Entity\\\\Categoria\\0nombre\\";N;}}}s:8:\\"unidades\\";a:1:{s:5:\\"JUN01\\";s:2:\\"50\\";}s:5:\\"coste\\";d:125;}i:3;a:6:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;a:0:{}i:5;a:2:{i:0;O:37:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\":2:{s:46:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0headers\\";a:3:{s:4:\\"from\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:4:\\"From\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:25:\\"alopper2510@g.educaand.es\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:2:\\"to\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:2:\\"To\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:27:\\"paco.taquito.paco@gmail.com\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:7:\\"subject\\";a:1:{i:0;O:48:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:7:\\"Subject\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:55:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\0value\\";s:25:\\"Confirmación de pedido 5\\";}}}s:49:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0lineLength\\";i:76;}i:1;N;}}i:4;N;}s:61:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0envelope\\";N;}}	[]	default	2026-01-27 23:16:09	2026-01-27 23:16:09	\N
2	O:36:\\"Symfony\\\\Component\\\\Messenger\\\\Envelope\\":2:{s:44:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0stamps\\";a:1:{s:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\";a:1:{i:0;O:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\":1:{s:55:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\0busName\\";s:21:\\"messenger.bus.default\\";}}}s:45:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0message\\";O:51:\\"Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\":2:{s:60:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0message\\";O:39:\\"Symfony\\\\Bridge\\\\Twig\\\\Mime\\\\TemplatedEmail\\":5:{i:0;s:16:\\"correo.html.twig\\";i:1;N;i:2;a:4:{s:9:\\"pedido_id\\";i:6;s:9:\\"productos\\";a:1:{s:5:\\"LAD01\\";O:19:\\"App\\\\Entity\\\\Producto\\":7:{s:23:\\"\\0App\\\\Entity\\\\Producto\\0id\\";i:14;s:27:\\"\\0App\\\\Entity\\\\Producto\\0precio\\";d:4.5;s:27:\\"\\0App\\\\Entity\\\\Producto\\0codigo\\";s:5:\\"LAD01\\";s:27:\\"\\0App\\\\Entity\\\\Producto\\0nombre\\";s:28:\\"Ladrón de Enchufes Kamikaze\\";s:32:\\"\\0App\\\\Entity\\\\Producto\\0nombreCorto\\";s:10:\\"Ladrón 5x\\";s:32:\\"\\0App\\\\Entity\\\\Producto\\0descripcion\\";s:105:\\"Para conectar la estufa, la plancha, el horno y la lavadora a la vez. El seguro de hogar no cubre su uso.\\";s:30:\\"\\0App\\\\Entity\\\\Producto\\0categoria\\";O:35:\\"Proxies\\\\__CG__\\\\App\\\\Entity\\\\Categoria\\":3:{s:24:\\"\\0App\\\\Entity\\\\Categoria\\0id\\";i:3;s:28:\\"\\0App\\\\Entity\\\\Categoria\\0codigo\\";N;s:28:\\"\\0App\\\\Entity\\\\Categoria\\0nombre\\";N;}}}s:8:\\"unidades\\";a:1:{s:5:\\"LAD01\\";s:1:\\"8\\";}s:5:\\"coste\\";d:36;}i:3;a:6:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;a:0:{}i:5;a:2:{i:0;O:37:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\":2:{s:46:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0headers\\";a:3:{s:4:\\"from\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:4:\\"From\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:25:\\"alopper2510@g.educaand.es\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:2:\\"to\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:2:\\"To\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:27:\\"paco.taquito.paco@gmail.com\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:7:\\"subject\\";a:1:{i:0;O:48:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:7:\\"Subject\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:55:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\0value\\";s:25:\\"Confirmación de pedido 6\\";}}}s:49:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0lineLength\\";i:76;}i:1;N;}}i:4;N;}s:61:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0envelope\\";N;}}	[]	default	2026-01-27 23:17:54	2026-01-27 23:17:54	\N
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.pedido (id, usuario_id, fecha, coste, code) FROM stdin;
1	1	2026-01-27	71.60	228f
2	1	2026-01-27	71.60	e7b0
3	1	2026-01-27	125.00	1873
4	1	2026-01-27	125.00	7338
5	1	2026-01-27	125.00	47cc
6	1	2026-01-27	36.00	1b94
7	1	2026-01-27	4536.00	a35b
8	1	2026-01-27	6786.00	c59c
9	1	2026-01-27	6786.00	d510
10	1	2026-01-27	6786.00	d374
11	1	2026-01-27	6786.00	5b95
12	1	2026-01-27	6786.00	45e2
13	1	2026-01-27	6786.00	bf66
14	1	2026-01-27	6786.00	2692
15	1	2026-01-28	77.45	df75
16	1	2026-01-28	7429159.75	5d7b
17	1	2026-01-28	7429159.75	1cc1
18	1	2026-01-28	4.80	2328
19	1	2026-02-04	52.25	ed98
20	1	2026-02-10	600.00	8364
\.


--
-- Data for Name: pedido_producto; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.pedido_producto (id, pedido_id, producto_id, unidades, no) FROM stdin;
1	1	11	8	1
2	2	11	8	1
3	3	12	50	1
4	4	12	50	1
5	5	12	50	1
6	6	14	8	1
7	7	14	8	1
8	7	18	100	1
9	8	14	8	1
10	8	18	150	1
11	9	14	8	1
12	9	18	150	1
13	10	14	8	1
14	10	18	150	1
15	11	14	8	1
16	11	18	150	1
17	12	14	8	1
18	12	18	150	1
19	13	14	8	1
20	13	18	150	1
21	14	14	8	1
22	14	18	150	1
23	15	16	5	1
24	15	8	5	1
25	16	16	5	1
26	16	8	500005	1
27	16	11	8	1
28	16	12	13	1
29	16	13	11	1
30	16	17	300	1
31	16	18	20500	1
32	16	19	350	1
33	17	16	5	1
34	17	8	500005	1
35	17	11	8	1
36	17	12	13	1
37	17	13	11	1
38	17	17	300	1
39	17	18	20500	1
40	17	19	350	1
41	18	13	4	1
42	19	11	5	1
43	19	12	3	1
44	20	13	500	1
\.


--
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.producto (id, categoria_id, precio, codigo, nombre, nombre_corto, descripcion) FROM stdin;
7	1	5.5	CIN01	Cinta Americana "Lo Arregla Todo"	Cinta Dios	Si esto no lo arregla, es que está roto de verdad. Sirve para fugas, parachoques y secuestros (es broma).
8	1	12.99	MAR01	Martillo de la Paciencia	Martillo Thor	Ideal para cuando el mueble de IKEA no encaja. Si no entra por las buenas, entra por las malas.
9	1	0.1	TORN2	Tornillo que siempre sobra	Tornillo Extra	Al montar cualquier cosa siempre te sobra uno. Es este. Cómpralo por si acaso.
10	1	4.5	WD40	Spray 3 en 1 Milagroso	Aflojatodo	Si se mueve y no debería: Cinta americana. Si no se mueve y debería: Este spray.
11	2	8.95	DES01	Desatascador Nuclear	El Destructor	Saca hasta los recuerdos de tu ex de la tubería. No usar sin mascarilla.
12	2	2.5	JUN01	Junta de la Trócola	La Junta	Nadie sabe para qué sirve, pero el fontanero dice que te hace falta y te va a cobrar 50 euros por ella.
13	2	1.2	TEF01	Cinta de Teflón Infinita	Teflón	Da igual cuánto pongas, seguirá goteando un poquito para ponerte nervioso.
14	3	4.5	LAD01	Ladrón de Enchufes Kamikaze	Ladrón 5x	Para conectar la estufa, la plancha, el horno y la lavadora a la vez. El seguro de hogar no cubre su uso.
15	3	3	BOMB1	Bombilla "Cálida" (Amarillo Pollo)	Bombilla Fea	Da una luz tan amarilla que parecerá que tienes ictericia. Dura 20 años para que sufras.
16	3	2.5	CAL01	Calambrazo 3000	Buscapolos	Destornillador buscapolos. Si se enciende la luz, hay corriente. Si gritas, también.
17	4	15	MAN01	Manguera con Vida Propia	Manguera Loca	Se enreda sola en cuanto te das la vuelta. Garantizado.
18	4	45	BAR01	Barbacoa "Domingueros"	Barbacoa	Incluye instrucciones para quemar la carne por fuera y dejarla cruda por dentro.
19	4	19.9	ENA01	Enanito de Jardín Siniestro	Enanito Miedo	Te mira mal cuando no riegas. Ideal para ahuyentar ladrones y visitas no deseadas.
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.usuario (id, login, roles, password, email, phone, is_verified) FROM stdin;
1	usuario1@gmail.com	["ROLE_ADMIN"]	$2y$13$3Ei30DAliD93E0BXYFCbgu.0sWKxIFnL/DWcdaJBVU1pCQMMhHjUq	usuario1@gmail.com	123	t
2	usuario2@gmail.com	["ROLE_USER"]	$2y$13$jEQwD1OXLir2zZVxws1qquPV.wqXEaB/bOOddyImgMCJACLCqkW/6	usuario2@gmail.com	123	t
\.


--
-- Name: categoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.categoria_id_seq', 3, true);


--
-- Name: messenger_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.messenger_messages_id_seq', 2, true);


--
-- Name: pedido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.pedido_id_seq', 20, true);


--
-- Name: pedido_producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.pedido_producto_id_seq', 44, true);


--
-- Name: producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.producto_id_seq', 19, true);


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.usuario_id_seq', 1, true);


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);


--
-- Name: doctrine_migration_versions doctrine_migration_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.doctrine_migration_versions
    ADD CONSTRAINT doctrine_migration_versions_pkey PRIMARY KEY (version);


--
-- Name: messenger_messages messenger_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.messenger_messages
    ADD CONSTRAINT messenger_messages_pkey PRIMARY KEY (id);


--
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (id);


--
-- Name: pedido_producto pedido_producto_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.pedido_producto
    ADD CONSTRAINT pedido_producto_pkey PRIMARY KEY (id);


--
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- Name: idx_75ea56e016ba31db; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_75ea56e016ba31db ON public.messenger_messages USING btree (delivered_at);


--
-- Name: idx_75ea56e0e3bd61ce; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_75ea56e0e3bd61ce ON public.messenger_messages USING btree (available_at);


--
-- Name: idx_75ea56e0fb7336f0; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_75ea56e0fb7336f0 ON public.messenger_messages USING btree (queue_name);


--
-- Name: idx_a7bb06153397707a; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_a7bb06153397707a ON public.producto USING btree (categoria_id);


--
-- Name: idx_c4ec16cedb38439e; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_c4ec16cedb38439e ON public.pedido USING btree (usuario_id);


--
-- Name: idx_dd333c24854653a; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_dd333c24854653a ON public.pedido_producto USING btree (pedido_id);


--
-- Name: idx_dd333c27645698e; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_dd333c27645698e ON public.pedido_producto USING btree (producto_id);


--
-- Name: uniq_identifier_login; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX uniq_identifier_login ON public.usuario USING btree (login);


--
-- Name: messenger_messages notify_trigger; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER notify_trigger AFTER INSERT OR UPDATE ON public.messenger_messages FOR EACH ROW EXECUTE FUNCTION public.notify_messenger_messages();


--
-- Name: producto fk_a7bb06153397707a; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT fk_a7bb06153397707a FOREIGN KEY (categoria_id) REFERENCES public.categoria(id);


--
-- Name: pedido fk_c4ec16cedb38439e; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_c4ec16cedb38439e FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- Name: pedido_producto fk_dd333c24854653a; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.pedido_producto
    ADD CONSTRAINT fk_dd333c24854653a FOREIGN KEY (pedido_id) REFERENCES public.pedido(id);


--
-- Name: pedido_producto fk_dd333c27645698e; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.pedido_producto
    ADD CONSTRAINT fk_dd333c27645698e FOREIGN KEY (producto_id) REFERENCES public.producto(id);


--
-- PostgreSQL database dump complete
--

\unrestrict XAiBX98292OYIYIEZCgYdSKHxI1xcWDexlaCth1jE1MyZsVJKaVoXCcx8ZzDm1j

