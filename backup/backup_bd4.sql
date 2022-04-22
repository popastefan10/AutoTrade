PGDMP     7                    z        	   AutoTrade    14.2    14.2     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16394 	   AutoTrade    DATABASE     j   CREATE DATABASE "AutoTrade" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Romanian_Romania.1252';
    DROP DATABASE "AutoTrade";
                postgres    false            �           0    0    DATABASE "AutoTrade"    ACL     .   GRANT ALL ON DATABASE "AutoTrade" TO pstefan;
                   postgres    false    3326            7           1247    16396    categ_caroserie    TYPE     �   CREATE TYPE public.categ_caroserie AS ENUM (
    'SUV',
    'estate',
    'sedan',
    'coupe',
    'cabriolet',
    'hatchback'
);
 "   DROP TYPE public.categ_caroserie;
       public          postgres    false            =           1247    16446    tip_tractiune    TYPE     W   CREATE TYPE public.tip_tractiune AS ENUM (
    'spate',
    'fata',
    'integrala'
);
     DROP TYPE public.tip_tractiune;
       public          postgres    false            �            1259    16419    masini    TABLE     �  CREATE TABLE public.masini (
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
       public         heap    postgres    false    823    823    829                        0    0    TABLE masini    ACL     -   GRANT ALL ON TABLE public.masini TO pstefan;
          public          postgres    false    209            �            1259    16430    masini_id_seq    SEQUENCE     �   CREATE SEQUENCE public.masini_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.masini_id_seq;
       public          postgres    false    209                       0    0    masini_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.masini_id_seq OWNED BY public.masini.id;
          public          postgres    false    210                       0    0    SEQUENCE masini_id_seq    ACL     7   GRANT ALL ON SEQUENCE public.masini_id_seq TO pstefan;
          public          postgres    false    210            e           2604    16431 	   masini id    DEFAULT     f   ALTER TABLE ONLY public.masini ALTER COLUMN id SET DEFAULT nextval('public.masini_id_seq'::regclass);
 8   ALTER TABLE public.masini ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209            �          0    16419    masini 
   TABLE DATA           �   COPY public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune) FROM stdin;
    public          postgres    false    209   �                  0    0    masini_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.masini_id_seq', 14, true);
          public          postgres    false    210            i           2606    16433    masini masini_nume_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_nume_key UNIQUE (nume);
 @   ALTER TABLE ONLY public.masini DROP CONSTRAINT masini_nume_key;
       public            postgres    false    209            k           2606    16435    masini masini_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.masini DROP CONSTRAINT masini_pkey;
       public            postgres    false    209            �   w  x��WMo�]3���ƛF �AI�%�M�"��4E
���l$� �\8EWﯽ�!%�ҵ.�6A$ʚsfΜ����w�����v���T5��+�4!�x��sz�=~I�#DC8@�jw�}�x��]��4F���������]���Sj�w\�j��8�5���UI�cy�
�߿ �O�O��_���اH֍(4/�%�_??�ՖW;���_6�q<�x��ե��Ca� `c��B�\���y{�[i���hU�[뜷��f�t3"f����F&6?�ÖQ⅌Ef�qFi�%���k��$��v$�l_i�.�Z�b��D!�?n�Ū�\|r-����Q�G���h�L�ԋS�x��g�W�p-�}�Xm��Q�A����W�|F�Ж7�������,d�K��7R��*;�4��{C�{a����Bπ�ey,LR���U��o�oU����F~�x�|���>AN�S��y?d�����[��{�[akaL������9o�T�e�ɒl�N.i�nN���7�F��ON!���t@!N:c�˫���׭�8����ԯ��%��t@��uٛ��9Y��2b^D�8I�#�p�����5X��A3���;���D�BM�'���2	C�I�W����{1���Y&��+Y��/@�bQd�,���eo���OD�~�iJ��Af�(C�P�|+�
bנK��񗋟�`^��
���?mJl���o���h���h��o/P����R�֖�����Wey8k�[2p�l���KCxI(c���W�J[��M���&P�N��m8�0]�b�%�iɁwr��5;~g0�{Yl�iw�J�J�X+�֑*���p̐p���Q%�J�{y*=�bm��^IS)W���# N��(��<�t/�F�ؒ�G������f���X��|L���a^�,+Mэ��,��֘�F<tI�����^�x
�+���3|�ޛFTvhq�"�F��08q]��]� y���	zj�/���	4��8� �Qo�V��18Hl`xi�-�,�Ӌ��U)��������Z�����
��R�p�ke;>�ݐ8�Y5%A00"��>a1�����g�ϡ{mͫ麅�}q@�
�ݠ��ǈ�]����q%f<˂�Ը���f�o<� 4��.��і�o�l�����=�V��+��A5m����b�Y����V�����{�X,V�����J1Z�"!3�)p�(��Z���xc��2�W��s�t��V�Ѹ-f�M;�5�q��[���~l$vX�_D8D�q�2n�ey2C��e�`Li2��>z:a.�D��o1��í���&��W�Dn�^ܛ֣�0�+^碗��=��0��P�f=�ؠ��Ť�#g�9+X�񪘫��IF좾f	��~q^h��$���E�-��0�e��]	�Z'����1Bث�!�Kc���b������ja�&��CA�o�5;�t��������ȍ���zX��n������Aa�`�$���@�l������]�m�E�."�\wn{�T����N|�NC��Om���1�t����'!̮1�ę��)�0�m��������n$Y�̣~ )���wvv�/geY�     