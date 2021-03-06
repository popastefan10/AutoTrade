PGDMP         '                z        	   AutoTrade    14.2    14.2     ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            ?           1262    16416 	   AutoTrade    DATABASE     j   CREATE DATABASE "AutoTrade" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Romanian_Romania.1252';
    DROP DATABASE "AutoTrade";
                postgres    false                        0    0    DATABASE "AutoTrade"    ACL     .   GRANT ALL ON DATABASE "AutoTrade" TO pstefan;
                   postgres    false    3327            7           1247    16459    categ_caroserie    TYPE     ?   CREATE TYPE public.categ_caroserie AS ENUM (
    'SUV',
    'estate',
    'sedan',
    'coupe',
    'cabriolet',
    'hatchback'
);
 "   DROP TYPE public.categ_caroserie;
       public          postgres    false            :           1247    16472    tip_motorizare    TYPE     f   CREATE TYPE public.tip_motorizare AS ENUM (
    'benzina',
    'diesel',
    'GPL',
    'electric'
);
 !   DROP TYPE public.tip_motorizare;
       public          postgres    false            ?            1259    16482    masini    TABLE     :  CREATE TABLE public.masini (
    id integer NOT NULL,
    nume character varying(50) NOT NULL,
    descriere text,
    pret numeric(8,2) NOT NULL,
    producator character varying(50) NOT NULL,
    motor character varying(50) NOT NULL,
    cai_putere integer NOT NULL,
    kilometri_reali integer NOT NULL,
    motorizare public.tip_motorizare DEFAULT 'benzina'::public.tip_motorizare,
    categorie public.categ_caroserie DEFAULT 'sedan'::public.categ_caroserie,
    dotari character varying[],
    folosita boolean DEFAULT true NOT NULL,
    imagine character varying(300),
    data_adaugare timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT masini_cai_putere_check CHECK ((cai_putere >= 0)),
    CONSTRAINT masini_kilometri_reali_check CHECK (((kilometri_reali >= 0) AND (kilometri_reali <= 10000)))
);
    DROP TABLE public.masini;
       public         heap    postgres    false    826    823    823    826                       0    0    TABLE masini    ACL     -   GRANT ALL ON TABLE public.masini TO pstefan;
          public          postgres    false    210            ?            1259    16481    masini_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.masini_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.masini_id_seq;
       public          postgres    false    210                       0    0    masini_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.masini_id_seq OWNED BY public.masini.id;
          public          postgres    false    209                       0    0    SEQUENCE masini_id_seq    ACL     7   GRANT ALL ON SEQUENCE public.masini_id_seq TO pstefan;
          public          postgres    false    209            b           2604    16485 	   masini id    DEFAULT     f   ALTER TABLE ONLY public.masini ALTER COLUMN id SET DEFAULT nextval('public.masini_id_seq'::regclass);
 8   ALTER TABLE public.masini ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    210    210            ?          0    16482    masini 
   TABLE DATA           ?   COPY public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, motorizare, categorie, dotari, folosita, imagine, data_adaugare) FROM stdin;
    public          postgres    false    210   1                  0    0    masini_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.masini_id_seq', 4, true);
          public          postgres    false    209            j           2606    16497    masini masini_nume_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_nume_key UNIQUE (nume);
 @   ALTER TABLE ONLY public.masini DROP CONSTRAINT masini_nume_key;
       public            postgres    false    210            l           2606    16495    masini masini_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.masini DROP CONSTRAINT masini_pkey;
       public            postgres    false    210            ?   ?  x?m??n?0@??W????;Nni??-X???c3? G2h?2??_ۇ?v??Ū? ??ޓh??X[??-`??.??T??ɴ?D?a[M}?%?y??'?G?U!??V;r'?PQ0??9?o\???2A??c{?G?F?c?q??`+??
??`???еR???@?????8?Nӱ??S&?k3?dInf?4Q????ԍ??VPd?X?????]Ϋ??ƃ???\nѯ:?o????'
?!?{>??h?>?????"? ??=a?E#[ϽE???$?N3]F??Z?uKh)? e`U?A"?HH??z??XG?❀??????z?屁V&>B???? ?ց|G??????0?S,+,1?????I?ɋi4Q?Čla?9??u?Ñ??~N?Y???H??J???B?{n?7m ???Q?k???ٞ?@5Tɲb?s?=?!l???i??bZ??CE?_TD?v     