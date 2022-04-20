--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

-- Started on 2022-04-19 19:41:12

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
-- TOC entry 210 (class 1259 OID 16396)
-- Name: tabel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tabel (
    id integer NOT NULL,
    nume character varying(100) NOT NULL,
    pret integer DEFAULT 100 NOT NULL
);


ALTER TABLE public.tabel OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16395)
-- Name: tabel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tabel ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tabel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3307 (class 0 OID 16396)
-- Dependencies: 210
-- Data for Name: tabel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tabel (id, nume, pret) FROM stdin;
1	abcd	200
2	mouse	100
3	zzzzzzz\n	50
\.


--
-- TOC entry 3315 (class 0 OID 0)
-- Dependencies: 209
-- Name: tabel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tabel_id_seq', 3, true);


--
-- TOC entry 3166 (class 2606 OID 16401)
-- Name: tabel tabel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabel
    ADD CONSTRAINT tabel_pkey PRIMARY KEY (id);


--
-- TOC entry 3313 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE tabel; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tabel TO lab1512;


--
-- TOC entry 3314 (class 0 OID 0)
-- Dependencies: 209
-- Name: SEQUENCE tabel_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.tabel_id_seq TO lab1512;


-- Completed on 2022-04-19 19:41:12

--
-- PostgreSQL database dump complete
--

