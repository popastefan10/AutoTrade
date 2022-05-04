PGDMP     /    )                z        	   AutoTrade    14.2    14.2     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16508 	   AutoTrade    DATABASE     j   CREATE DATABASE "AutoTrade" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Romanian_Romania.1252';
    DROP DATABASE "AutoTrade";
                postgres    false            7           1247    16510    categ_caroserie    TYPE     �   CREATE TYPE public.categ_caroserie AS ENUM (
    'SUV',
    'estate',
    'sedan',
    'coupe',
    'cabriolet',
    'hatchback'
);
 "   DROP TYPE public.categ_caroserie;
       public          postgres    false            :           1247    16524    tip_tractiune    TYPE     W   CREATE TYPE public.tip_tractiune AS ENUM (
    'spate',
    'fata',
    'integrala'
);
     DROP TYPE public.tip_tractiune;
       public          postgres    false            �            1259    16531    masini    TABLE     �  CREATE TABLE public.masini (
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
    CONSTRAINT masini_cai_putere_check CHECK ((cai_putere >= 0)),
    CONSTRAINT masini_kilometri_reali_check CHECK ((kilometri_reali >= 0))
);
    DROP TABLE public.masini;
       public         heap    postgres    false    823    823    826            �           0    0    TABLE masini    ACL     -   GRANT ALL ON TABLE public.masini TO pstefan;
          public          postgres    false    209            �            1259    16541    masini_id_seq    SEQUENCE     �   CREATE SEQUENCE public.masini_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.masini_id_seq;
       public          postgres    false    209                        0    0    masini_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.masini_id_seq OWNED BY public.masini.id;
          public          postgres    false    210                       0    0    SEQUENCE masini_id_seq    ACL     7   GRANT ALL ON SEQUENCE public.masini_id_seq TO pstefan;
          public          postgres    false    210            e           2604    16542 	   masini id    DEFAULT     f   ALTER TABLE ONLY public.masini ALTER COLUMN id SET DEFAULT nextval('public.masini_id_seq'::regclass);
 8   ALTER TABLE public.masini ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209            �          0    16531    masini 
   TABLE DATA           �   COPY public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune) FROM stdin;
    public          postgres    false    209                     0    0    masini_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.masini_id_seq', 15, true);
          public          postgres    false    210            i           2606    16544    masini masini_nume_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_nume_key UNIQUE (nume);
 @   ALTER TABLE ONLY public.masini DROP CONSTRAINT masini_nume_key;
       public            postgres    false    209            k           2606    16546    masini masini_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.masini DROP CONSTRAINT masini_pkey;
       public            postgres    false    209            �   �  x��Y�n�6}f���s"���o�l�)�"ظ)Z���H�JR	�E��C�,��~��� �-Rs�̙����J��77^7J	����ת)q&
!��Ӓ���J�T3�HL3^s��*Ǭ��b܀oT)2�YY�ͼJyƳ�ҸѸ���<f�[���Ŵ�5�·7����][5j�3�q]ДI�a]�r�B����ʚɌ��̃���OQq�-䄾mۖm��r���8(�m�8�-2�i��>����j.*��
�8�8f��;�4/�o��-Ϲ����8�i��Or�zIaд��s�؎si{���	YgE|����W�����xR�-�~\&��#2\+2"86"p=�����i �~� 6 ��y�S,����\r)��#� aR3`c���WNh9v>R5�~a#�BS�ܯ���EB�=�]��X�?�x��W�� ��ю�t�J�7@���_�a��B�ޠ���m�{�� �xQl���=>����
�����w~�H��A�L�ȱ�5^{=��������[�ӞI����7%U��~��kW\02n4��D��W<�pM�������u����|b���c;�Жjz棫&��[���}̼{�����1#��u��I�n$��L�Z���Fa3�*�ʏF�Hd����؟�&�ʏV�� ��W������A�Z�whO�vZ�������r[��6Z�h�(��g�W}u�I�z0Oh�Vv�"�E 뢉*����M��Y�OLn�,i��E�b��\t������G� 9��fR ����@��mJ�� ��~�D(i�������D�LJ�@I�L�x���W�]�\p�ޑs퐩��Ӝ��h?+��fFݭ��=��6+%����<ŉi�W��Պc7�^�������SZ��O�m@�FMz��,�s�0�P��D�g�@�nQ(��h<Lk�9��z���7�") �N�a�JwT�,C�o�n�+}X�&S;Ί�e���K!�s���AB�I��6Yy�哘Dd��LY���5���{����~���!GA�i��m�AϿ� -��:Q�9���b��N�+�䁛�2���Ń\	]{ZU\t��+~t��C\�u��>Z��uz h豁�������!m�=1^_yQ��(���8i1.�d)�!��GR�P�G8�<����A�,B� ��G�r��2����^?߀bm�s[1�x�ߣ�.͎VN`���!w�9���E�IHt���O�|DZ�3X�99� 㹍��vq8�Nl�v�L%�����<�-k�]�/�r	�)	�\�f�4�p*���gc���%�.�t@4a��	������>&xd����2-(���,h��h�ג���UL�{,a����ͬg��\a{Iϵ����
��'�����M}@�b*�-��2ǧ��px�!l��y|wۨ�ۃ��.���f�WC1U�	(�.��I�2>�ǽ��M�dn��y�2�X�<t'd��D
|[fb�}�	q;B 1ڌ�2ru�|q~'r\�|���&Q._i7<_�%[� s@�+? ��Q<:����U��qŗ˯{���"�?���T������_�B��X�ᬳ���+�&i�8�`ɮ��Õ[�� �2�5-�|�+���Z$��Zm��dH��-\ߎ���U�.uebm�c*\m�l޺����S�H�t��V�,�4Q������ֽ2�     