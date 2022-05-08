PGDMP     5                    z        	   AutoTrade    14.2    14.2     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16442 	   AutoTrade    DATABASE     j   CREATE DATABASE "AutoTrade" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Romanian_Romania.1252';
    DROP DATABASE "AutoTrade";
                postgres    false            7           1247    16444    categ_caroserie    TYPE     �   CREATE TYPE public.categ_caroserie AS ENUM (
    'SUV',
    'estate',
    'sedan',
    'coupe',
    'cabriolet',
    'hatchback'
);
 "   DROP TYPE public.categ_caroserie;
       public          postgres    false            :           1247    16458    tip_tractiune    TYPE     W   CREATE TYPE public.tip_tractiune AS ENUM (
    'spate',
    'fata',
    'integrala'
);
     DROP TYPE public.tip_tractiune;
       public          postgres    false            �            1259    16465    masini    TABLE     �  CREATE TABLE public.masini (
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
          public          postgres    false    209            �            1259    16475    masini_id_seq    SEQUENCE     �   CREATE SEQUENCE public.masini_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.masini_id_seq;
       public          postgres    false    209                        0    0    masini_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.masini_id_seq OWNED BY public.masini.id;
          public          postgres    false    210                       0    0    SEQUENCE masini_id_seq    ACL     7   GRANT ALL ON SEQUENCE public.masini_id_seq TO pstefan;
          public          postgres    false    210            e           2604    16476 	   masini id    DEFAULT     f   ALTER TABLE ONLY public.masini ALTER COLUMN id SET DEFAULT nextval('public.masini_id_seq'::regclass);
 8   ALTER TABLE public.masini ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209            �          0    16465    masini 
   TABLE DATA           �   COPY public.masini (id, nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, categorie, dotari, folosita, imagine, data_adaugare, tractiune) FROM stdin;
    public          postgres    false    209                     0    0    masini_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.masini_id_seq', 15, true);
          public          postgres    false    210            i           2606    16478    masini masini_nume_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_nume_key UNIQUE (nume);
 @   ALTER TABLE ONLY public.masini DROP CONSTRAINT masini_nume_key;
       public            postgres    false    209            k           2606    16480    masini masini_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.masini
    ADD CONSTRAINT masini_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.masini DROP CONSTRAINT masini_pkey;
       public            postgres    false    209            �      x��Z]���r}�E��,�$��HI�6�{��qffml@h�-�=$��I��{`���C�����TuS�ff� �w��GR�?�N�:U�0��2-nnq� �V�Yw;%*�WM+rU)+[m*q��{Ո���եl��P��TJ4��Ŷ��ݎ�U�jt^�*�'da��B�UM��U]+ie���*�J��-���Fڝl�S���YW�4���hU��La��I����*;�v�5Z6m#��(0���ѐ����@MK�ڮj��������j|�ٍ_�gM������ߍX�ok�2q��֚J�����#Q*y<,ͭ?=����V����A=��X�u)=�"�����v��Ģ9�����ݪ�-"�Mk��k�j�W��#���tV�wJ�iRL�I$�'�g+�w��l�3��TY3	���M�SB��Ǚ���N�\eA�_�i�����33�*����_d��RXc��|�1dfr�������k�$kI8[����:�i���q4at1/�I��e�U���|{�.�m}����p�(�������Si]x�T%*Yb�����t0%��8d��j�íJ������$�n����t��}� Ua�}3����/�A|)��	+�w{��.d��jw�~4�jlI��C#��s�F�"U�pi��֚R$ӈbD�_qY;�+�c� @�:�rJcq~��5c�����a��VjZ,�D�Ȥ�h���P�;Sβ������q������I�Y�klԡ4��ht� dW Zpې�j) 7ĺex�(j�3�=�]#��Po3�7 �����(��Ū�N��[`~9b�?o/��:��M�Z����`سBH@���4�j��[��al�`�3d�"�]�ˋy8�&�E�
��z����ƶ��7��,���>�����{��`+�bY �@����G<
l��?���e��hN��hP!�@^��4ơ���n"G\�xc,��۹�#b]T���=k��QZ����}qs�gR��(�܃���`���S��Ă�0�kJ+�����/=���+ǡ�`�)���+�&����x`J;��3>�&+�6w��?s�،�O��ou�[���L��]�� t�j��5�y�f�ӛ^��{����tq�&`�d9`�e@��7�gݟW`N��/��9�+E!$^�������vC�y���"S�ߙ� L���2 �05fC�+C)�C�(^�����vOL�V���c5:�7=������#���ȼ���曝�^���r�ɰ!���8�F�m������^���=6H�%�b<#nSӶⓢ�G �a��q~�,��2��s2}�o���\�n�����Ǿ����E�L�h_��\�����#X����A0��A�D�p����Y��jd��ɑ��P4Ό!n��|Z������*t��^���G1��و���j�C��}.��v�����`i�U���E���4�k�<��X���m�Kښ�B�tn�f�r�q����ؒrj�Ą�r]9��A6oL[��R�g>��O�(�9���~��8#7�\�%��SA���\�\�ߡ:��d6]DC�N������5������.s0��q@ʂٶ�;Xd�-	UݒAu5~�Z��ҦF|�m����������H�7w	%��r�g��,5�t>���q��"�!e��|0齪vJ�f�ˠvMEڰ�]�zP�">��7��
2��ړk�ߟ�8jF��cE�'�|�Y2pץf��g�=GO3*�?:Mۜ7_gm�N{ӯU��.L�^'�$�š��0|
���n����M+�S��`��N"��g���2Xܿ����5��n9Fh�\��59l����算�8�d�,9hv��)W[5�L�M3��ad,ѳ����N\)H,��2ޚ�#y��'�5E'�ZǩVSs:�u�٣t�z(W- ��tkYZ_R�*��n:�,�x��1�IcU�����������lJ�*~&�9�.���ڢ�T`�t��TjϠ��b���y�<	F�d�J�p�C"
����R�*)W]��ϯ�����1馫��H� o]A@D�'�-K���%H����\��������|6Z��h��AFWD�R9����J]\7]Yb����w�u��[q0 ����J����z�rA���/���%g� �$䙫��(�a��,L�j�'^����un�q�lu1�'�|��.�l;���=!�?�-dֱ�+[`�� 7�2h�dX���Ő�7\
�(��HQ��2��/�c�pO�
�B�UM��V�W(v�_:5~�&4��^g�Haf��Dm��<�A���?pl�fW���8/�0�o�(mH��ꛈo;MD�a)lZ��j xU�L����4\sa�H��_f]�)��B5m���ٽ^"�B�>�Os����ϗ�oG/ߛ\pU�◴0̸�N��a�5��3^�/.�U�l�\��??��C��7�6�/�}��/��bE+�@ ���@d�=MF�)0��JƇa�L�`���4�Lq2	�r�����3Ly9�T�Inp2�K��_05�(]־%�Gi�����������_L�>찥`��!;zV�<!KrR	��cB��1�{2�:��[8����"ZL��t5�������XT���l�Zb�����
;.�v�5�[��~|݁`l�����a
U�u�{����!�0YS�>f�xP;�B�r�x���-��ǛA��u})j�\�i��N�5J��1&׀V�S���/_�FV�x��H�P� �y�tt���x�k-
�1ٱ�9��6#F�%'�;�ZSm�6�7�*�d���Z��"ț�Լ;�/�d9b .�q���.:�X�(���c1�1rj7�:u^��`���	xpj���e�$È_�ER�i��KN��PJ\w�jv0��D<�m$A��9Ior �VB�8�Q���}�:�i��A�^�0l���l}������N6.�*�N#��L	��3��Rȶ[Sh��|F��Զ��KU\���S��v�����p���lD\!��nP@�}�{��8����~��H�`v��&(���˪�9q'԰�.E�-�M}�
^{ܩ���K�[g�Gp3�	s��[���+uW�Z���H�1���D��?5�WT�[$v]��=��\���� �v�����P���7�۩��-o�*��H^8f3���G�/S(�a8!�.��Կ������) �_M���J����^�	N�H`�;?N�0۞/���[�9��5N, ��SK��f��ó	��^���O���	b�S@��"��h�� ������֠�5�:���\Qs�Vs���$K��	+'n�k�? �I &�1�P���a���a�#��Jp�_�=�)b�I�;���w,6��=�ʻ�2{ӥ)r�,Ү�$�ajM���w��r�}���_VmdF*��8��V��t��ߠ����F~W�$uۺڅ�D�o�*q�b�c@A|�~��(�W�����[v&��P��Ø{�el݄뺷�|�Rg����	P��b������9���/�kξ�A%�R����iX���Jή�uj'�,0A�]�4OA���To���%�-]�9�v�f�e1s%�X�#f���ЁRO������J{�$ ���Yq��䟉�`�PS���N�0�#Ԑ&%���Vz�����_+�q�I�q-y��}k�n�����tv��`�?�D���r���g�15�t�DeC_��	Bt1H�8����gU��<N�
"
���ת����L\^_!�ݏ�"���q�.q>�o̞�J��P/��(�`c�˹V��cw�dMq]�7X�CC��	8�gv.�H-x$���,e|�!�	���>��rg��
�@��m��Y�LW)u]�ǟ���E�ZL�wGvW�7��#.�Z5ve�진2�%Q�k[�9s4����
�ǧ����Y�d�p�	<�l�\��Wۨ[sx�>��]Svt[�����;����فo� (O^Q���U�3�<���e���xp;PNϕ[�Q�_i��J�<   ��e�?ÃȆ��b1�o�f}�rp� ���~ۿ�0x����[��gAQ� ��z�d�|�Xpc��]�jn�<U��ŴUN~�%������o`�0����㻫��U�M?����"�5L�N��:�0��n���(Xi����b���L'Z�V_��R�����z|P�����1��<��܅���k�6���@܀P|a���M��7~���3��"�U/;8������K[���k�u��>���$��>�.�/R���Go!�㝊�S��}��ԍ8��c�������E�N?F�T��-��7�aB�W,��"�k8���A�h�L�Kq�0�n��o�.��P��Ȩ�?�}�δL���\��Ńr�ܙ<wmII9~�:�[n����jJ��r�h����sW�4��������o��qe�듳��-�Y��c�+�80�=���i���A��|u�G��'����`7�7.�v��P	:O�/��|w���2>AFs}v_}�=�Z�8�z�~�ba�$���wu�3����ŧ�i�ao���15�6j���[�ȁaIIc�W��אl���1�[=z1�(��g���W��=t[��1���h�B�Oq ;vb@]���u�sB�n7p�IӮ��=�W`���i�S�fG�Q/�gh���= ���{��P�^r\q����X��\�z
Yٺ����1��WVX�!0U�	]B|� Y����X��Ν�96"�2}�U�����F��&|E���|]���IPj?ͣe���/^�a���     