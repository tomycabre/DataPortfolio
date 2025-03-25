--
-- PostgreSQL database dump
--

-- Dumped from database version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)
-- Dumped by pg_dump version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)

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

DROP DATABASE universe;
--
-- Name: universe; Type: DATABASE; Schema: -; Owner: freecodecamp
--

CREATE DATABASE universe WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE universe OWNER TO freecodecamp;

\connect universe

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
-- Name: asteroid; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.asteroid (
    asteroid_id integer NOT NULL,
    name character varying(50),
    galaxy_id integer NOT NULL
);


ALTER TABLE public.asteroid OWNER TO freecodecamp;

--
-- Name: galaxy; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.galaxy (
    galaxy_id integer DEFAULT nextval('1'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    age_in_millions_of_years integer,
    description text,
    galaxy_types character varying(50)
);


ALTER TABLE public.galaxy OWNER TO freecodecamp;

--
-- Name: moon; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.moon (
    moon_id integer NOT NULL,
    name character varying(50) NOT NULL,
    age_in_millions_of_years integer,
    distance_from_earth numeric(2,0) NOT NULL,
    description text,
    is_habitable boolean,
    planet_id integer NOT NULL
);


ALTER TABLE public.moon OWNER TO freecodecamp;

--
-- Name: planet; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.planet (
    planet_id integer NOT NULL,
    name character varying(50) NOT NULL,
    age_in_millions_of_years integer,
    distance_from_earth numeric(2,0) NOT NULL,
    description text,
    is_habitable boolean,
    star_id integer NOT NULL
);


ALTER TABLE public.planet OWNER TO freecodecamp;

--
-- Name: star; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.star (
    star_id integer NOT NULL,
    name character varying(50) NOT NULL,
    age_in_millions_of_years integer,
    distance_from_earth numeric(2,0) NOT NULL,
    description text,
    galaxy_id integer NOT NULL
);


ALTER TABLE public.star OWNER TO freecodecamp;

--
-- Data for Name: asteroid; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.asteroid VALUES (1, 'Xerxes-47', 1);
INSERT INTO public.asteroid VALUES (2, 'Titan Shard', 3);
INSERT INTO public.asteroid VALUES (3, 'Oblivion Rock', 5);


--
-- Data for Name: galaxy; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.galaxy VALUES (1, 'Andromeda', 10000, 'Andrómeda es la galaxia espiral más cercana a la Vía Láctea y se espera que colisione con ella en unos 4.5 mil millones de años.', 'Espiral');
INSERT INTO public.galaxy VALUES (2, 'Via Lactea', 13600, 'Nuestra galaxia espiral barrada alberga el sistema solar y contiene cientos de miles de millones de estrellas.', 'Espiral Barrada');
INSERT INTO public.galaxy VALUES (3, 'Sombrero', 9000, 'Galaxia espiral con un prominente bulbo central y un anillo de polvo, situada en la constelación de Virgo.', 'Espiral');
INSERT INTO public.galaxy VALUES (4, 'Triangulo', 12000, 'También conocida como M33, es una galaxia espiral cercana a Andrómeda y la tercera más grande del Grupo Local.', 'Espiral');
INSERT INTO public.galaxy VALUES (5, 'Ojo Negro', 13000, 'Galaxia espiral que destaca por su núcleo brillante y una oscura banda de polvo interestelar.', 'Espiral');
INSERT INTO public.galaxy VALUES (6, 'Rueda de Carro', 500, 'Galaxia en anillo resultante de una colisión, con una apariencia que recuerda a una rueda de carro.', 'Anillo');


--
-- Data for Name: moon; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.moon VALUES (1, 'Selene', 3000, 25, 'Una pequeña luna rocosa orbitando Andro-1, con una fina capa de polvo y cráteres de impacto.', false, 1);
INSERT INTO public.moon VALUES (2, 'Eurybia', 2500, 25, 'Luna helada de Andro-2, con una superficie cubierta de hielo y posibles océanos subterráneos.', false, 2);
INSERT INTO public.moon VALUES (3, 'Luna', 4500, 0, 'Único satélite natural de la Tierra, con una superficie rocosa llena de cráteres.', false, 3);
INSERT INTO public.moon VALUES (4, 'Phobos', 4500, 0, 'Luna irregular y pequeña de Marte, con órbita decaída que podría hacerla colapsar en el futuro.', false, 4);
INSERT INTO public.moon VALUES (5, 'Deimos', 4500, 0, 'Segunda luna de Marte, más pequeña que Phobos y con una órbita más estable.', false, 4);
INSERT INTO public.moon VALUES (6, 'Zephyrus', 5000, 29, 'Luna principal de Sombrero Prime-b, con actividad geológica y erupciones de hielo.', false, 5);
INSERT INTO public.moon VALUES (7, 'Borealis', 4000, 29, 'Pequeña luna de Sombrero Prime-c, con una atmósfera tenue y formaciones rocosas únicas.', false, 6);
INSERT INTO public.moon VALUES (8, 'Artemis', 2000, 30, 'Luna volcánica de Triangulum-1, con enormes flujos de lava y una atmósfera tóxica.', false, 7);
INSERT INTO public.moon VALUES (9, 'Erebus', 1500, 30, 'Luna helada de Triangulum-2, con un subsuelo de agua líquida y posible actividad hidrotermal.', true, 8);
INSERT INTO public.moon VALUES (10, 'Nyx', 5000, 35, 'Luna oscura de Obscura-1b, con una órbita inclinada y compuesta de materiales primitivos.', false, 9);
INSERT INTO public.moon VALUES (11, 'Hecate', 3000, 35, 'Luna en la zona habitable de Obscura-1c, con una atmósfera delgada y lagos de metano.', true, 10);
INSERT INTO public.moon VALUES (12, 'Perseis', 1000, 40, 'Luna de Cartwheel Major I, con grandes montañas de hielo y una densa atmósfera de nitrógeno.', true, 11);
INSERT INTO public.moon VALUES (13, 'Hyperion', 900, 40, 'Luna caótica de Cartwheel Major II, con una rotación irregular y una superficie porosa.', false, 12);
INSERT INTO public.moon VALUES (14, 'Orpheus', 3000, 25, 'Luna pequeña de Andro-1, cubierta de polvo y con signos de antiguos impactos de meteoritos.', false, 1);
INSERT INTO public.moon VALUES (15, 'Thalassa', 2500, 25, 'Luna oceánica de Andro-2, con un posible océano bajo una gruesa capa de hielo.', true, 2);
INSERT INTO public.moon VALUES (16, 'Charon-X', 5000, 29, 'Luna de Sombrero Prime-b con una superficie cubierta de fracturas y actividad sísmica.', false, 5);
INSERT INTO public.moon VALUES (17, 'Hespera', 4000, 29, 'Luna desértica de Sombrero Prime-c, con tormentas de polvo que cubren su superficie.', false, 6);
INSERT INTO public.moon VALUES (18, 'Callirrhoe', 2000, 30, 'Luna externa de Triangulum-1, con una órbita altamente excéntrica.', false, 7);
INSERT INTO public.moon VALUES (19, 'Styx', 1500, 30, 'Luna helada de Triangulum-2, con depósitos de amoníaco y agua en su superficie.', false, 8);
INSERT INTO public.moon VALUES (20, 'Eos', 1000, 40, 'Luna interna de Cartwheel Major I, con una atmósfera densa de metano y nitrógeno.', true, 11);


--
-- Data for Name: planet; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.planet VALUES (1, 'Andro-1', 3000, 25, 'Un planeta rocoso en la zona habitable de Proxima Andromedae, con una delgada atmósfera de dióxido de carbono.', true, 1);
INSERT INTO public.planet VALUES (2, 'Andro-2', 2500, 25, 'Un gigante gaseoso con un sistema de anillos, compuesto principalmente de hidrógeno y helio.', false, 1);
INSERT INTO public.planet VALUES (3, 'Tierra', 4500, 0, 'El único planeta conocido con vida, con una atmósfera rica en oxígeno y agua líquida en su superficie.', true, 2);
INSERT INTO public.planet VALUES (4, 'Marte', 4500, 0, 'Un planeta rocoso con casquetes polares de hielo, atmósfera delgada y posibles signos de agua subterránea.', false, 2);
INSERT INTO public.planet VALUES (5, 'Sombrero Prime-b', 5000, 29, 'Un exoplaneta similar a Júpiter, con intensas tormentas y un gran sistema de lunas.', false, 3);
INSERT INTO public.planet VALUES (6, 'Sombrero Prime-c', 4000, 29, 'Un planeta rocoso con una fina atmósfera de nitrógeno y vestigios de actividad volcánica.', true, 3);
INSERT INTO public.planet VALUES (7, 'Triangulum-1', 2000, 30, 'Un supertierra con alta gravedad y una atmósfera rica en oxígeno y nitrógeno.', true, 4);
INSERT INTO public.planet VALUES (8, 'Triangulum-2', 1500, 30, 'Un exoplaneta con densas nubes de metano y una superficie cubierta de océanos subterráneos.', false, 4);
INSERT INTO public.planet VALUES (9, 'Obscura-1b', 5000, 35, 'Un exoplaneta con una atmósfera espesa y una luna helada que podría contener océanos subterráneos.', false, 5);
INSERT INTO public.planet VALUES (10, 'Obscura-1c', 3000, 35, 'Un planeta con una gran cantidad de compuestos orgánicos, atmósfera estable y temperaturas moderadas.', true, 5);
INSERT INTO public.planet VALUES (11, 'Cartwheel Major I', 1000, 40, 'Un planeta con una densa atmósfera de nitrógeno y nubes de agua, similar a la Tierra primitiva.', true, 6);
INSERT INTO public.planet VALUES (12, 'Cartwheel Major II', 900, 40, 'Un gigante helado con vientos supersónicos y un sistema de anillos oscuros.', false, 6);


--
-- Data for Name: star; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.star VALUES (1, 'Proxima Andromedae', 4500, 25, 'Una enana roja en la galaxia de Andrómeda, con dos planetas en su sistema, uno de ellos rocoso y en la zona habitable.', 1);
INSERT INTO public.star VALUES (2, 'Sol', 4600, 0, 'La estrella del sistema solar, una enana amarilla tipo G, con ocho planetas, incluyendo la Tierra, que tiene una luna natural.', 2);
INSERT INTO public.star VALUES (3, 'Sombrero Prime', 6000, 29, 'Una estrella de tipo F en la galaxia del Sombrero, con un sistema planetario que incluye un gigante gaseoso con tres lunas.', 3);
INSERT INTO public.star VALUES (4, 'Triangulum Alpha', 7000, 30, 'Una joven estrella masiva en la galaxia del Triángulo, rodeada por un disco de formación planetaria con al menos cuatro exoplanetas.', 4);
INSERT INTO public.star VALUES (5, 'Obscura-1', 8000, 35, 'Una estrella de tipo K en la galaxia del Ojo Negro, con un exoplaneta rocoso que posee una luna helada en su órbita.', 5);
INSERT INTO public.star VALUES (6, 'Cartwheel Major', 1000, 40, 'Una estrella azul brillante en la galaxia Rueda de Carro, con un sistema de tres planetas, uno de ellos con signos de una atmósfera densa.', 6);


--
-- Name: asteroid asteroid_asteroid_id_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.asteroid
    ADD CONSTRAINT asteroid_asteroid_id_key UNIQUE (asteroid_id);


--
-- Name: asteroid asteroid_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.asteroid
    ADD CONSTRAINT asteroid_pkey PRIMARY KEY (asteroid_id);


--
-- Name: galaxy galaxy_galaxy_id_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.galaxy
    ADD CONSTRAINT galaxy_galaxy_id_key UNIQUE (galaxy_id);


--
-- Name: galaxy galaxy_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.galaxy
    ADD CONSTRAINT galaxy_pkey PRIMARY KEY (galaxy_id);


--
-- Name: moon moon_moon_id_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.moon
    ADD CONSTRAINT moon_moon_id_key UNIQUE (moon_id);


--
-- Name: moon moon_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.moon
    ADD CONSTRAINT moon_pkey PRIMARY KEY (moon_id);


--
-- Name: planet planet_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.planet
    ADD CONSTRAINT planet_pkey PRIMARY KEY (planet_id);


--
-- Name: planet planet_planet_id_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.planet
    ADD CONSTRAINT planet_planet_id_key UNIQUE (planet_id);


--
-- Name: star star_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.star
    ADD CONSTRAINT star_pkey PRIMARY KEY (star_id);


--
-- Name: star star_star_id_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.star
    ADD CONSTRAINT star_star_id_key UNIQUE (star_id);


--
-- Name: asteroid asteroid_galaxy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.asteroid
    ADD CONSTRAINT asteroid_galaxy_id_fkey FOREIGN KEY (galaxy_id) REFERENCES public.galaxy(galaxy_id);


--
-- Name: moon moon_planet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.moon
    ADD CONSTRAINT moon_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES public.planet(planet_id);


--
-- Name: planet planet_star_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.planet
    ADD CONSTRAINT planet_star_id_fkey FOREIGN KEY (star_id) REFERENCES public.star(star_id);


--
-- Name: star star_galaxy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.star
    ADD CONSTRAINT star_galaxy_id_fkey FOREIGN KEY (galaxy_id) REFERENCES public.galaxy(galaxy_id);


--
-- PostgreSQL database dump complete
--

