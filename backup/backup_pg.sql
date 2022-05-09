--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

-- Started on 2022-05-09 15:50:11

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
-- TOC entry 823 (class 1247 OID 16549)
-- Name: categ_caroserie; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.categ_caroserie AS ENUM (
    'SUV',
    'estate',
    'sedan',
    'coupe',
    'cabriolet',
    'hatchback'
);


ALTER TYPE public.categ_caroserie OWNER TO postgres;

--
-- TOC entry 826 (class 1247 OID 16562)
-- Name: tip_tractiune; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tip_tractiune AS ENUM (
    'spate',
    'fata',
    'integrala'
);


ALTER TYPE public.tip_tractiune OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16569)
-- Name: masini; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.masini (
    id integer NOT NULL,
    nume character varying(50) NOT NULL,
    descriere text,
    pret numeric(8,2) NOT NULL,
    producator character varying(50) NOT NULL,
    motor character varying(50) NOT NULL,
    cai_putere integer NOT NULL,
    kilometri_reali integer NOT NULL,
    categorie public.categ_caroserie DEFAULT 'sedan'::public.categ_caroserie,
    dotari character varying[],
    folosita boolean DEFAULT true NOT NULL,
    imagine character varying(300),
    data_adaugare timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tractiune public.tip_tractiune,
    tip_motor character varying(50),
    CONSTRAINT masini_cai_putere_check CHECK ((cai_putere >= 0)),
    CONSTRAINT masini_kilometri_reali_check CHECK ((kilometri_reali >= 0))
);


ALTER TABLE public.masini OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16579)
-- Name: masini_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.masini_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.masini_id_seq OWNER TO postgres;

--
-- TOC entry 3327 (class 0 OID 0)
-- Dependencies: 210
-- Name: masini_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.masini_id_seq OWNED BY public.masini.id;


--
-- TOC entry 3173 (class 2604 OID 16580)
-- Name: masini id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.masini ALTER COLUMN id SET DEFAULT nextval('public.masini_id_seq'::regclass);


--
-- TOC entry 3319 (class 0 OID 16569)
-- Dependencies: 209
-- Data for Name: masini; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (1, 'Audi RS6 Avant C8', 'The newest generation Audi RS6 takes the ultimate estate one step further, redesigning the already aggressive appearance and incorporating the best that the latest in modern technology has to offer. Enthusiasts will be glad to hear the RS6 still runs a 4.0L Twin-Turbo V8 through Audi’s 8-Speed Tiptronic gearbox, meaning the RS6 is still as competent as ever. Producing 592 bhp the Quattro system perfectly distributes the power to all four wheels, meaning a 0-62 time of just 3.6 seconds.', 130000.00, 'Audi', '4.0L V8 Turbocharged', 600, 50, 'estate', '{"Heated windshield","Panorama roof","Seat heating"}', false, 'audi_rs6_avant_c8.jpg', '2022-04-20 12:01:43.519181', 'integrala', 'V8');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (2, 'Mercedes-Benz G 63 AMG', 'A luxury SUV has become the must-have vehicle in the driveway and with a plethora of contenders perhaps none of them have generated quite as much interest as the new G-wagon and in particular the G63 AMG. For the first time since it’s conception in the late 1970’s, the G-Class has been fully re-engineered from the ground up. With reduced weight, increased stiffness and strength and a totally redesigned suspension and off road system it gives a much more sure-footed handling experience than previous generations.', 190000.00, 'Mercedes-Benz', '4.0L V8 Twin-Turbo', 585, 2000, 'SUV', '{"Performance package","Parking assistant","Rain sensor"}', true, 'mercedes_benz_g63_amg.jpg', '2022-04-20 12:11:44.77308', 'integrala', 'V8');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (3, 'BMW M3 Competition G80', 'The latest generation of M3 was initially met with a mixed reception due to BMW''s bold new front grille design but there is a general consensus that the design is growing on people and it''s now being much more universally well received. What was never in doubt was it''s driving credentials with a new 8-speed automatic combining with the twin-turbo straight six under the bonnet to provide a truly memorable experience behind the wheel.', 120000.00, 'BMW', '3.0L Inline-6 Twin-Turbo', 510, 10000, 'sedan', '{"Hill holder","Air conditioning",Armrest}', true, 'bmw_m3_competition_g80.jpg', '2022-04-20 12:19:21.11567', 'spate', 'L6');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (4, 'Ferrari Portofino M', 'Named after the picturesque and glamorous fishing village located on the Italian Riviera, the Portofino is Ferrari’s 2+2 hard top convertible which replaced the hugely successful California. This is not however just a facelifted and rebadged California but instead has been redesigned from the ground up, sitting on a totally new chassis.', 250000.00, 'Ferrari', '3.9L V8', 620, 100, 'cabriolet', '{"Seat heating","Electric rear view mirror"}', false, 'ferrari_portofino_m.jpg', '2022-04-20 12:35:27.206765', 'spate', 'V8');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (5, 'Audi R8 Spyder V10', 'The Audi R8 V10, a car that has been named as ''the supercar for everyday'', has received an update, refreshing and modernising its looks. The ‘V10 Plus’ has now been replaced with the ‘V10 Performance’, with power being increased from 602bhp to 612bhp. Along with the added power comes slightly more sound produced from the highly praised 5.2L V10. The V10 symphony is amplified through slightly larger exhaust pipes on either side of the sharper looking rear bumper. The same can be said for the front bumper, with a more aggressive finish than the pre-facelift.', 183000.00, 'Audi', '5.2L V10', 570, 5000, 'cabriolet', '{"Cruise control","Rain sensor"}', true, 'audi_r8_spyder_v10.jpg', '2022-04-21 13:58:41.069769', 'spate', 'V10');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (6, 'Audi RS5 Sportback', 'Revealed at the New York International Auto Show, the new four-wheel drive fastback joins its recently introduced sister models, the RS5 Coupe and RS4 Avant, in an expanded range of new mid-range RS models aimed at providing stiff competition to the likes of the BMW M3 and M4 as well as Mercedes-AMG C63 sedan and coupe.', 70000.00, 'Audi', '2.9L V6 TSFI', 450, 35000, 'sedan', '{"Digital radio","Electric side mirrors","Seat heating"}', true, 'audi_rs5_sportback.jpg', '2022-04-21 14:07:19.13068', 'integrala', 'V6');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (7, 'Audi R8 Coupe V10 Performance', 'The Audi R8 V10, a car that has been named as ''the supercar for everyday'', has received an update, refreshing and modernising its looks. The ‘V10 Plus’ has now been replaced with the ‘V10 Performance’, with power being increased from 602bhp to 612bhp. Along with the added power comes slightly more sound produced from the highly praised 5.2L V10. The V10 symphony is amplified through slightly larger exhaust pipes on either side of the sharper looking rear bumper. The same can be said for the front bumper, with a more aggressive finish than the pre-facelift.', 200000.00, 'Audi', '5.2L V10', 620, 10, 'coupe', '{"Cruise control","Parking assistant"}', false, 'audi_r8_coupe_v10_performance.jpg', '2022-04-21 14:16:41.842758', 'integrala', 'V10');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (8, 'BMW Z8', 'The BMW Z8 is a roadster produced by German automotive manufacturer BMW from 2000 to 2003. The Z8 was developed under the codename "E52" between 1993 and 1999, through the efforts of a design team led by Chris Bangle from 1993 to 1995. The exterior was designed by Henrik Fisker and the interior by Scott Lempert.', 200000.00, 'BMW', '4.9L V8', 400, 60000, 'cabriolet', '{"CD player"}', true, 'bmw_z8.jpg', '2022-04-21 20:08:26.12368', 'spate', 'V8');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (9, 'BMW M8 Competition', 'Introduced in June 2019, the M8 was initially produced in the 2-door convertible (F91 model code) and 2-door coupe (F92 model code) body styles. A 4-door sedan (F93 model code, marketed as ''Gran Coupe'') body style was added to the lineup in October 2019. The M8 is powered by the BMW S63 twin-turbocharged V8 engine shared with the BMW M5 (F90).', 118000.00, 'BMW', '4.4L V8', 625, 14000, 'coupe', '{"Parking assistant","Heated windshield"}', true, 'bmw_m8_competition.jpg', '2022-04-21 20:12:29.30721', 'integrala', 'V8');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (10, 'BMW M4 DTM Champions Edition', 'Two years after his first title win, BMW M4 pilot Marco Wittmann (GER) once again secured the driver’s title in the DTM at the 2016 season finale at the Hockenheimring. To honour this achievement, BMW M is rolling out the BMW M4 DTM Champion Edition.', 77000.00, 'BMW', '3.0L Inline-6', 432, 33600, 'coupe', '{"Air conditioning","Cruise control","Sport seats"}', true, 'bmw_m4_dtm_champions_edition.jpg', '2022-04-21 20:16:58.461351', 'spate', 'L6');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (11, 'BMW M3 GTS', 'Some people knew the M3 GTS from the "Need for Speed" saga, where it was the trophy car was at the end of the "Most Wanted" game. In real life, the coupe was made by order only and built as a track-focused car. But BMW offered an option for the owners to get it modified and made it road-legal. The car also marked the 25th anniversary of the first BMW M3, the E30.', 185000.00, 'BMW', '4.4L V8', 450, 38000, 'coupe', '{"Brake energy regeneration","Air conditioning","Rain sensor"}', true, 'bmw_m3_gts.jpg', '2022-04-21 20:20:16.796517', 'spate', 'V8');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (12, 'Toyota Yaris GR', 'Toyota''s going one step further with its GR Yaris, creating an even more hardcore hyper-hatch, revealed at the 2022 Tokyo Auto Salon. It joins the regular GR Yaris hot hatch family this summer – but only if you live in Japan. It won''t come to the UK.', 36000.00, 'Toyota', '1.6L I3 Turbo', 260, 15, 'hatchback', '{"Digital radio","Seat heating"}', false, 'toyota_yaris_gr.jpg', '2022-04-21 20:39:35.648907', 'integrala', 'L3');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (13, 'Volkswagen Golf 8 R', 'The 2022 Volkswagen Golf R is ready to overthrow the hottest hatchbacks that have been hogging headlines during its absence from our shores. Spawned from the improvements made to the upcoming Mk8 Golf GTI, the R-rated model has a more powerful 315-hp turbo-four and an all-wheel-drive system with a drift mode.', 52000.00, 'Volkswagen', '2.0L L4', 320, 4000, 'hatchback', '{"Dusk sensor","Parking sensors","Tyre pressure monitoring system"}', true, 'volkswagen_golf_8_r.jpg', '2022-04-21 20:44:15.900221', 'integrala', 'L4');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (15, 'MINI John Cooper Works GP F56', 'MINI John Cooper Works GP embodies a rich racing heritage that stretches back over five decades. Its 2.0 litre, 306 PS 4-cylinder turbocharged engine with an outstanding 450 Nm torque delivers an impressively powerful performance.', 45000.00, 'MINI', '2.0L L4 Turbo', 306, 9000, 'hatchback', '{"CD player","Parking assistant","Air conditioning"}', true, 'mini_john_cooper_works_gp_f56.jpg', '2022-04-21 20:51:27.499094', 'fata', 'L4');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (17, 'Lamborghini Urus', 'Lamborghini have created a new sector in the SUV market with the Urus touted as the world''s first Super SUV and effectively the first ever 5 seater supercar. They have certainly raised the bar for what an SUV is capable of with what can only be perceived as outrageous performance bringing the Lamborghini DNA to compete with the likes of the Range Rover for the very first time.', 350000.00, 'Lamborghini', '4.0L V8 Turbocharged', 650, 25000, 'SUV', '{"Air suspension","Light sensor","Panoramic roof"}', true, 'lamborghini_urus.jpg', '2022-04-21 21:20:44.45679', 'integrala', 'V8');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (18, 'Porsche Panamera Turbo S Sport Turismo', 'Much like minivans, station wagons are easy to mock, but the jokes will run dry when members of the 2022 Porsche Panamera Sport Turismo family fly by. Easily the quirkiest car in Porsche''s portfolio, the Sport Turismo is essentially a four-door Panamera with an elongated roof.', 210000.00, 'Porsche', '4.0L V8 Twin-Turbo', 630, 24000, 'estate', '{"Sport package","Sport seats"}', true, 'porsche_panamera_turbo_s_sport_turismo.jpg', '2022-04-22 10:40:12.993644', 'spate', 'V8');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (19, 'Ferrari GTC4 Lusso', 'Powerful yet sophisticated, sporty yet luxurious. Ferrari''s new 12-cylinder really does make every journey a radically different experience. Whether being driven solo or with all four seats occupied, the latest addition to the Ferrari range puts people at the centre of a whole new world. The GTC4 Lusso was designed to deliver different and entirely surprising emotions.', 275000.00, 'Ferrari', '6.3L V12', 690, 22000, 'estate', '{"Navigation system","Seat ventilation","Digital radio"}', true, 'ferrari_gtc4_lusso.jpg', '2022-04-22 11:12:15.242815', 'integrala', 'V12');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (14, 'Ford Focus RS', 'Ford''s hard-core hatch has a 350-hp turbocharged four-cylinder engine that pairs exclusively with a six-speed manual transmission. Its torque-vectoring all-wheel drive is capable of conquering snow-covered streets or gravel-strewn back roads. While its cheap interior can''t be ignored, the RS will still fit four adults and their stuff.', 30000.00, 'Ford', '2.3L L4', 350, 85000, 'hatchback', '{ABS,"Fog lights","Side airbag"}', true, 'ford_focus_rs.jpg', '2022-04-21 20:47:56.513789', 'integrala', 'L4');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (16, 'Porsche Cayenne Turbo S E-Hybrid', 'Although a few Porsche purists probably still wince at the thought that their revered brand builds vehicles like the 2022 Cayenne Turbo and Turbo S E-Hybrid, both models are respectable ways to park a fun-and-practical SUV in your driveway. The Turbo packs a 541-hp twin-turbo V-8 under its hood and the S E-Hybrid adds an electric motor for an outrageous combined 670-hp rating.', 200000.00, 'Porsche', '4.0L V8 Twin-Turbo', 680, 5500, 'SUV', '{Bluetooth,"Heated steering wheel","Cruise control"}', true, 'porsche_cayenne_turbo_s_e_hybrid.jpg', '2022-04-21 21:17:39.508166', 'integrala', 'V8');
INSERT INTO public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) VALUES (20, 'Porsche Taycan Turbo S', 'A direct threat to the Tesla Model S, the Porsche Taycan is a fully electric large premium sedan that delivers 522 horsepower in base 4S trim. The mid-range model is called Turbo and increases output to 670 horsepower. But wait, there’s more: the top-line Taycan Turbo S generates as much as 750 horsepower—seriously. You’ll need to spend well above $200,000 to get it, however.', 210000.00, 'Porsche', 'Dual Electric Motors', 760, 20, 'sedan', '{"Audio system","Parking assistant",ABS}', false, 'porsche_taycan_turbo_s.jpg', '2022-04-22 11:21:14.765627', 'integrala', 'Electric');


--
-- TOC entry 3329 (class 0 OID 0)
-- Dependencies: 210
-- Name: masini_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.masini_id_seq', 15, true);


--
-- TOC entry 3177 (class 2606 OID 16582)
-- Name: masini masini_nume_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_nume_key UNIQUE (nume);


--
-- TOC entry 3179 (class 2606 OID 16584)
-- Name: masini masini_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_pkey PRIMARY KEY (id);


--
-- TOC entry 3326 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE masini; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.masini TO pstefan;


--
-- TOC entry 3328 (class 0 OID 0)
-- Dependencies: 210
-- Name: SEQUENCE masini_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.masini_id_seq TO pstefan;


-- Completed on 2022-05-09 15:50:12

--
-- PostgreSQL database dump complete
--

