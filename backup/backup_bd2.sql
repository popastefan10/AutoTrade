PGDMP                         z           bd_1552    14.2    14.2     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16394    bd_1552    DATABASE     f   CREATE DATABASE bd_1552 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Romanian_Romania.1252';
    DROP DATABASE bd_1552;
                postgres    false            �           0    0    DATABASE bd_1552    ACL     *   GRANT ALL ON DATABASE bd_1552 TO lab1512;
                   postgres    false    3313            �            1259    16396    tabel    TABLE     �   CREATE TABLE public.tabel (
    id integer NOT NULL,
    nume character varying(100) NOT NULL,
    pret integer DEFAULT 100 NOT NULL
);
    DROP TABLE public.tabel;
       public         heap    postgres    false            �           0    0    TABLE tabel    ACL     ,   GRANT ALL ON TABLE public.tabel TO lab1512;
          public          postgres    false    210            �            1259    16395    tabel_id_seq    SEQUENCE     �   ALTER TABLE public.tabel ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tabel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    210            �           0    0    SEQUENCE tabel_id_seq    ACL     6   GRANT ALL ON SEQUENCE public.tabel_id_seq TO lab1512;
          public          postgres    false    209            �          0    16396    tabel 
   TABLE DATA           /   COPY public.tabel (id, nume, pret) FROM stdin;
    public          postgres    false    210   b
       �           0    0    tabel_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.tabel_id_seq', 3, true);
          public          postgres    false    209            ^           2606    16401    tabel tabel_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.tabel
    ADD CONSTRAINT tabel_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.tabel DROP CONSTRAINT tabel_pkey;
       public            postgres    false    210            �   -   x�3�LLJN�420�2���/-N�4��9�  &��Ԁ+F��� �
�     