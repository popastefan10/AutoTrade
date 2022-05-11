PGDMP     (    /                z        	   AutoTrade    14.2    14.2 &               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16547 	   AutoTrade    DATABASE     j   CREATE DATABASE "AutoTrade" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Romanian_Romania.1252';
    DROP DATABASE "AutoTrade";
                postgres    false                       0    0    DATABASE "AutoTrade"    ACL     .   GRANT ALL ON DATABASE "AutoTrade" TO pstefan;
                   postgres    false    3356            ;           1247    16549    categ_caroserie    TYPE     �   CREATE TYPE public.categ_caroserie AS ENUM (
    'SUV',
    'estate',
    'sedan',
    'coupe',
    'cabriolet',
    'hatchback'
);
 "   DROP TYPE public.categ_caroserie;
       public          postgres    false            D           1247    16586    roluri    TYPE     Q   CREATE TYPE public.roluri AS ENUM (
    'admin',
    'moderator',
    'comun'
);
    DROP TYPE public.roluri;
       public          postgres    false            >           1247    16562    tip_tractiune    TYPE     W   CREATE TYPE public.tip_tractiune AS ENUM (
    'spate',
    'fata',
    'integrala'
);
     DROP TYPE public.tip_tractiune;
       public          postgres    false            �            1259    16608    accesari    TABLE     �   CREATE TABLE public.accesari (
    id integer NOT NULL,
    ip character varying(100) NOT NULL,
    user_id integer,
    pagina character varying(500) NOT NULL,
    data_accesare timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.accesari;
       public         heap    postgres    false                       0    0    TABLE accesari    ACL     /   GRANT ALL ON TABLE public.accesari TO pstefan;
          public          postgres    false    214            �            1259    16607    accesari_id_seq    SEQUENCE     �   CREATE SEQUENCE public.accesari_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.accesari_id_seq;
       public          postgres    false    214                       0    0    accesari_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.accesari_id_seq OWNED BY public.accesari.id;
          public          postgres    false    213                        0    0    SEQUENCE accesari_id_seq    ACL     9   GRANT ALL ON SEQUENCE public.accesari_id_seq TO pstefan;
          public          postgres    false    213            �            1259    16569    masini    TABLE       CREATE TABLE public.masini (
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
    DROP TABLE public.masini;
       public         heap    postgres    false    827    827    830            !           0    0    TABLE masini    ACL     -   GRANT ALL ON TABLE public.masini TO pstefan;
          public          postgres    false    209            �            1259    16579    masini_id_seq    SEQUENCE     �   CREATE SEQUENCE public.masini_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.masini_id_seq;
       public          postgres    false    209            "           0    0    masini_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.masini_id_seq OWNED BY public.masini.id;
          public          postgres    false    210            #           0    0    SEQUENCE masini_id_seq    ACL     7   GRANT ALL ON SEQUENCE public.masini_id_seq TO pstefan;
          public          postgres    false    210            �            1259    16594    utilizatori    TABLE       CREATE TABLE public.utilizatori (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    nume character varying(100) NOT NULL,
    prenume character varying(100) NOT NULL,
    parola character varying(500) NOT NULL,
    rol public.roluri DEFAULT 'comun'::public.roluri NOT NULL,
    email character varying(100) NOT NULL,
    culoare_chat character varying(50) NOT NULL,
    data_adaugare timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    cod character varying(200),
    confirmat_mail boolean DEFAULT false
);
    DROP TABLE public.utilizatori;
       public         heap    postgres    false    836    836            $           0    0    TABLE utilizatori    ACL     2   GRANT ALL ON TABLE public.utilizatori TO pstefan;
          public          postgres    false    212            �            1259    16593    utilizatori_id_seq    SEQUENCE     �   CREATE SEQUENCE public.utilizatori_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.utilizatori_id_seq;
       public          postgres    false    212            %           0    0    utilizatori_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.utilizatori_id_seq OWNED BY public.utilizatori.id;
          public          postgres    false    211            &           0    0    SEQUENCE utilizatori_id_seq    ACL     <   GRANT ALL ON SEQUENCE public.utilizatori_id_seq TO pstefan;
          public          postgres    false    211            y           2604    16611    accesari id    DEFAULT     j   ALTER TABLE ONLY public.accesari ALTER COLUMN id SET DEFAULT nextval('public.accesari_id_seq'::regclass);
 :   ALTER TABLE public.accesari ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    214    214            r           2604    16580 	   masini id    DEFAULT     f   ALTER TABLE ONLY public.masini ALTER COLUMN id SET DEFAULT nextval('public.masini_id_seq'::regclass);
 8   ALTER TABLE public.masini ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209            u           2604    16597    utilizatori id    DEFAULT     p   ALTER TABLE ONLY public.utilizatori ALTER COLUMN id SET DEFAULT nextval('public.utilizatori_id_seq'::regclass);
 =   ALTER TABLE public.utilizatori ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    212    211    212                      0    16608    accesari 
   TABLE DATA           J   COPY public.accesari (id, ip, user_id, pagina, data_accesare) FROM stdin;
    public          postgres    false    214   +                 0    16569    masini 
   TABLE DATA           �   COPY public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune, tip_motor) FROM stdin;
    public          postgres    false    209   $+                 0    16594    utilizatori 
   TABLE DATA           �   COPY public.utilizatori (id, username, nume, prenume, parola, rol, email, culoare_chat, data_adaugare, cod, confirmat_mail) FROM stdin;
    public          postgres    false    212   p>       '           0    0    accesari_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.accesari_id_seq', 1, false);
          public          postgres    false    213            (           0    0    masini_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.masini_id_seq', 15, true);
          public          postgres    false    210            )           0    0    utilizatori_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.utilizatori_id_seq', 26, true);
          public          postgres    false    211            �           2606    16616    accesari accesari_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.accesari
    ADD CONSTRAINT accesari_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.accesari DROP CONSTRAINT accesari_pkey;
       public            postgres    false    214            |           2606    16582    masini masini_nume_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_nume_key UNIQUE (nume);
 @   ALTER TABLE ONLY public.masini DROP CONSTRAINT masini_nume_key;
       public            postgres    false    209            ~           2606    16584    masini masini_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.masini DROP CONSTRAINT masini_pkey;
       public            postgres    false    209            �           2606    16604    utilizatori utilizatori_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.utilizatori
    ADD CONSTRAINT utilizatori_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.utilizatori DROP CONSTRAINT utilizatori_pkey;
       public            postgres    false    212            �           2606    16606 $   utilizatori utilizatori_username_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.utilizatori
    ADD CONSTRAINT utilizatori_username_key UNIQUE (username);
 N   ALTER TABLE ONLY public.utilizatori DROP CONSTRAINT utilizatori_username_key;
       public            postgres    false    212            �           2606    16617    accesari accesari_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.accesari
    ADD CONSTRAINT accesari_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.utilizatori(id);
 H   ALTER TABLE ONLY public.accesari DROP CONSTRAINT accesari_user_id_fkey;
       public          postgres    false    214    3200    212                  x������ � �            x��Zˎ��r]��"�0�XDJ���U�jz���[��������br2�R��|��͗�DdR�*�]x}{S-)���'ND2�n�B��y&n�dՈ���a�D�v�5b�*ee�M%����h0�-���JL��kT-V���'�*���JWk~B�V�b/�zm�s�	_յ�VV9�[BW����E�3K�H��*�>�JlM�l%�o*S��^l$�e�Y����U�i���qb���u)���<�5��m+'�����NW���.��:�8k���-�����Ĵ?��*ă�k*��N����V��ain����Zn��j�����Ś���t���������5��Vv��܋B���e��f�,�Gb��i��m�*�qR�Y"�'�g%����h�3��T�D�h��ᐁ��qf>|��v��(ï�0�^���Տ
3l�*�W�W_d�m��Ƭ�y�1dfr���V���벅$�-���[���a���~2qr=��ǣA��i�Qk+K}�^%ѝ�9���FU�"�����F���������%N�Òy�8m#�'��y�6�Ca����3�v���Nu���@f�m�'�ˑ�7�v�"p�'<�<g��V�X{��A���Q靄P���\#�<�E-m�� ��g���Җ0ONs�"C7<�+W5�c8	���g�!����ߖҹ`U!K`Ǫ��ֺR�\!V�ly��Ʀ�z ~!C��6'�*��4=�G���7��jU!j� "�#���W�O�[W���plD%�����`x�b�Ͷ5�m�͕1d��*	��;���4 �Y��M�N؉�<�|��#�1����H`p���2v�T��Q��>r�� ���w�fw8���tm�J�%VZ���Bn�p���d2N�a=����"�F�-s�f��N�����N8����+�e�oU�Ax���nVu)ZE�%^
�,�p=(hm�J��� ��M�K��7:m���0 gG�B�2���5�У��m+x�:��N�b��� �hr:UE�H�.L��_�|�4[N���;3�h�w�ǲm����L�<�6ސ��t`W�\߱�B��[���1a�ښ'](µm��8�\�'X\�Sp`z�YL:��ш����U?;�_<�b!�dE�Jb)��hK�/D���%F!�-���v�ȏxY���K��]'� ��l����Sv5�>(k��⋱�Y�ʈ��ܒ�VM0D�sJ��Z�SdM��"n�A���6�0�ə�g�� ����  �GǕ ��<�Y�/	��RB����}���;�51Q]J�"�dӮ��<���[,�������ք;��DB�:)V�i�t���@N;y���+��,��yBd/���4M ����șD�(I;0�33b�(K��Q.�V� �,]�^�/��-�lI���;��L;�h�'\ԝe� ���d��I��q� ��b^�	�_c�6����Ùr�M���"�G����E � ��̾���=�E6,cX���
�b��xӎ>k�ҘGG�T���{_��&<���J��!���G�C=���G���y�ݙV[Fd1�o nJsJ�(0��@�:�$� 6�L�P�Y��bd�AS�ah�t�|"����N�~[oL�g���@�f�{�yX�$��~�Hr�klhS�x�+:9"��`�Q3�a����C+R�N�}�:�S��;d:މ@��>�2;P�QΛ�N�cw�(��f|�򷶅UX^YS^H�^$N���x��1[,��u:�ǃa6�d����*�J��Fd,�ʣ{@S�E��>#�~5����8�"�� s�9��w�l$��L�^.�I�)�����^��4�#���A /�"�-�5���|�k-W"�)��2����Պ���/��a6!���'(r6�2q�Ӭ5�i"Ae��wc�a���{�JП�-t(�$�ӎ��>H�Ð��>Fc��4���k.�I
mNy���)̽�:ǻ��{����p��6@Œ�ɨ�jr 5o�g��~�����%�~�I<� ��l/ˇc<]�cDo������3���8��g��M�t�w߮���❊,����{q�h��MC����$�g�yv1�P��#o\LK:�@���lG���5���4y�7;q<�y��f����	��a�%ٕ�][Q�m��X��h�T~C<6���ߐ���ix�o+�4<����~�{�e��\��p���i�'Ex8�-��q�gc|Ά/R�;���+��H��u��a��z8�N�A��@Q�5�U���ʋ>S��Om��|<��n��ʫO�Ҁ�_c�T�?��>Q�c~`�-bDr6bi
h�f_*pӍ��>`��dp����	y�������4�kO-�4T���m�[ޘ%C����c�2yv�j�Dt��B��x��`F8%I6oJ[� IO��:�;��1�5��
�ek�PtMO�����Nf��p�<�]�C���x�p���e!��
/z����P�Q1�u����z"�P�5Ν���~M�(��n��� �P�^Q������. ��D<BA���`CI����G�?�j����R�A}UQ���]�6zR[Eb�wHr������p����?+���(�F���c/+���ڏNӸ��Ƌ��.���U��3���8�Gi|���k��>̣95C�㑴�,�vL��>SK�27�_!3�Q�|��77�/aM�ٳ���6S�1��@���fY�o�e�ѵR����4�V"u"��%�6U�ۜ�V�ܓ���Ue�R8V�7���{�^��D�r��U�EX�UC 7���z�ŗ�|��Z�҇8K��x���LRn�~��w���v��z?R��^g֞��p~c�#N�5�!�m��-��Gh��w��d������q=�=�񫤼u{>�vbm|{��F�S	��{�P��Z���J�'Uy�B�����G��C��R����A��7���Py�G�Sp��[L����r�cٵ�-6�����ƍ^��i��'���$
�}g�׍��v��?�� �XeGy+D� C8��eB�dPLi�+sm��\xqi��D�=�{��<3�]��A6�Ά���4��G�WS>��ĭ)Wb*�Y.�ٞ�x����St�Dy��7Lƽ���]W<<)��7f�&'b�Ե��-Z۩�t�2dr �t�9w^��Y�Io��cF���ְ6�w�8���}��˾����z�!���J��Q��� ?����������k�ЛJ߭8�Q�I���l(Aן��Z�3�o[����Q�/�|�[�ڎz�XRǰ��8&�k-�8�b���1tr:���i��4���>~�(~2R+���_P�#���i�w~U[������2��@�Zy��%N�Q� ̀Ş�K��w�b�	�	!��=��U|�Ch�{��u���	�ƛ��J���|���K]Y8�ٓFd|)C:�s�i]Ad�Fp��m!,��h��yG�{�"���m����	�D�\�Ș�u�X����15(ǳ�p6�V��.�D�$loר���ٶ���8�LbA�@��,���{@/U���f��ڠ^�eolY��֜�}~�U
��=&&�*��,�@�Ns��-P�
]���oBaG���hM.%Վ���䟩�e�]���]��,PG-�Ǌ%Lw�|j�w�o�8��gM�{�]�Y�'׏��a���'��H����j��% P��_�9�����Mw���Ƣ��^�&����l2{&���PKNW��R+����7�v[�ѥ�Bd�d�,Lw�$w��qN� �T���uWdH�d�]xe �'MW�ђ"2�S̋����K�+r�~ �K��~k5��2	( ;����%۬L��'��,P��"#�绘\��б������p�y:,v��4����������x�g[�a����>�D[?�t"b��j���l<>]�����۱��:g���{{Ľ��Ui���ki�=���
��񠻉��JpH�)��5�la�`Ҕ�`�J�QI��~�f�\5'�t��X���gVHMSBUxx_��$L��������2���۝�7�k�ý�G& 7  �����Ɣ���D����^�,�Ɂ�$���lm}7SQ��oܓI��+��;�D�0I�`�Y>鵏����{�U�N��KB�Ow۵n��ݿ�JL�74@2N�������*GP�T��9z�Xa���f1��� ����At�GH�, j	���s��� ���.��φ�+�Վ������O��8�vb,\8�g	�[�
�2;���+5� �0dΌ=��]�%	7	��*C$���CƁ�G�`������_]Z���h��u�5b��]�9��e!/F^"p�v�,n��{�>���>0_�E��K�U2Q���ta/�b��5�D�&��3���[h�
N���}��=�eݔ͆���FG7�&���f	����w��M/���U4m��֕�*��u�9�a��|K4���cL�9��X*݀��a�䞫�چv�V}Lү!L��J/,**���'�~���)�q�?��?]]B�Ƙ��==������t@�+�U;��_��Y�	ǒ������t�i�!ޔ�j�r�́9|p��l �f�ܛ��p�b�G��*�	*�A:��Y��ͳ�vŃܓB~�n����7Y���J)��^�8��������1�>�ꡭn���H;H� B�蔿���8�xn�[��㥡/�BJja�����[�7<u2�o��nz�� �RIy�#��}�q���F�;���H'S���ߜ�\���S#�*����"\N.Ap� �^���}�^���%���p�xG u�$C2:�Q�=�9��H���>e��ɇ�3L�4KN{�>��cpuu��8�9         �  x�ݕK��F��=��,�͢V�e�X/#��	l���~�@ g7n�%�T�����'^���	�����ǗO��x��]Z&1�Ѷ,���:��,�;m�	��t��a(�8�
`�қ��^�(�hk/g��d�&�M)�}H��9e6���2�?��y[�?_ �������Q�._ּ�}����C��������~�[<�P���}y�}�n]Y�� �e��L�"�G�J=q���4�e�}{��s��,0,�0�ʴG�dum��&�._�-�c������)q��Gz��[��|
'ҁDBt�{��!��@����G�������0�S�/5�ā���4V_������0[��<u�)�R�tmY*�1�W��~�B�*ͧ�����8�F��O�Ň�����y�����+�ޫ\�G�k.7�CQ�gL�ڎ������	���*Pܳc8�>�3v�U��k�4����`�YIm�c����'�!�Tnró[|��x�l�f-q�^J6w�Y+�3�l��F=�:E�j�m�2�UWZ�s���7�����GY$隃E�P�I�a RN��c	 go��xr������C�~�/��m����	rD������� �;y�E>?�,�������#�x��k��jx� ���.���o�:y#,��A3��X@P���A�Ec���r��`@��S]ai��鲤�H+��ڔ��V�j�%�=�=�X���lL� vy�뺖�d�:� �f�F��7��(�8E�F���K��s�)ն����xzz�v��8     