-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-10-2024 a las 02:38:37
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `inverted_index`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dictionary`
--

CREATE TABLE `dictionary` (
  `term` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `doc_count` int(11) DEFAULT NULL,
  `total_frequency` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `dictionary`
--

INSERT INTO `dictionary` (`term`, `doc_count`, `total_frequency`) VALUES
('al', 2, 2),
('aplicación', 2, 6),
('archivo', 2, 2),
('archivos', 2, 6),
('base', 2, 2),
('cada', 2, 2),
('caracteres', 2, 2),
('cargar', 2, 2),
('cargue', 2, 2),
('carpeta', 2, 2),
('colección', 2, 2),
('contiene', 2, 2),
('contienen', 2, 2),
('datos', 2, 2),
('de', 2, 22),
('del', 2, 8),
('desde', 2, 2),
('diccionario', 2, 2),
('documento', 2, 4),
('documentos', 2, 2),
('el', 2, 12),
('en', 2, 6),
('ese', 2, 2),
('formulario', 2, 2),
('frecuencia', 2, 2),
('frecuencias', 2, 2),
('generará', 2, 2),
('guardando', 2, 2),
('guardará', 2, 2),
('han', 2, 2),
('identificador', 2, 2),
('ido', 2, 2),
('índice', 2, 4),
('invertido', 2, 2),
('la', 2, 8),
('lo', 2, 4),
('los', 2, 2),
('mysql', 2, 2),
('nombre', 2, 2),
('número', 2, 2),
('permitirá', 2, 2),
('plano', 2, 2),
('porción', 2, 2),
('posting', 2, 2),
('que', 2, 8),
('se', 2, 6),
('servidor', 2, 2),
('tabla', 2, 2),
('término', 2, 4),
('texto', 2, 6),
('todos', 2, 2),
('total', 2, 2),
('un', 2, 2),
('una', 2, 10),
('usuario', 2, 2),
('utilizará', 2, 2),
('vez', 2, 2),
('web', 2, 4),
('y', 2, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `posting`
--

CREATE TABLE `posting` (
  `term` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `doc_id` int(11) NOT NULL,
  `frequency` int(11) DEFAULT NULL,
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `text_snippet` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `posting`
--

INSERT INTO `posting` (`term`, `doc_id`, `frequency`, `file_name`, `text_snippet`) VALUES
('al', 0, 1, 'texto.txt', 'aplicación Web permitirá al usuario cargar archivo'),
('al', 1, 1, 'texto.txt', 'aplicación Web permitirá al usuario cargar archivo'),
('aplicación', 0, 3, 'texto.txt', 'La aplicación Web permitirá al usuario cargar arch'),
('aplicación', 1, 3, 'texto.txt', 'La aplicación Web permitirá al usuario cargar arch'),
('archivo', 0, 1, 'texto.txt', 'mitirá al usuario cargar archivos de texto plano d'),
('archivo', 1, 1, 'texto.txt', 'mitirá al usuario cargar archivos de texto plano d'),
('archivos', 0, 3, 'texto.txt', 'mitirá al usuario cargar archivos de texto plano d'),
('archivos', 1, 3, 'texto.txt', 'mitirá al usuario cargar archivos de texto plano d'),
('base', 0, 1, 'texto.txt', 'ario y de posting de una base de datos de MySQL. S'),
('base', 1, 1, 'texto.txt', 'ario y de posting de una base de datos de MySQL. S'),
('cada', 0, 1, 'texto.txt', 'La aplicación Web permitirá al usuario cargar arch'),
('cada', 1, 1, 'texto.txt', 'La aplicación Web permitirá al usuario cargar arch'),
('caracteres', 0, 1, 'texto.txt', 'na porción del texto (50 caracteres).'),
('caracteres', 1, 1, 'texto.txt', 'na porción del texto (50 caracteres).'),
('cargar', 0, 1, 'texto.txt', 'Web permitirá al usuario cargar archivos de texto '),
('cargar', 1, 1, 'texto.txt', 'Web permitirá al usuario cargar archivos de texto '),
('cargue', 0, 1, 'texto.txt', 'mulario. Cada vez que se cargue una colección de a'),
('cargue', 1, 1, 'texto.txt', 'mulario. Cada vez que se cargue una colección de a'),
('carpeta', 0, 1, 'texto.txt', 'han ido guardando en una carpeta en el servidor. L'),
('carpeta', 1, 1, 'texto.txt', 'han ido guardando en una carpeta en el servidor. L'),
('colección', 0, 1, 'texto.txt', 'da vez que se cargue una colección de archivos, la'),
('colección', 1, 1, 'texto.txt', 'da vez que se cargue una colección de archivos, la'),
('contiene', 0, 1, 'texto.txt', 'ero de documentos que lo contienen, el total de fr'),
('contiene', 1, 1, 'texto.txt', 'ero de documentos que lo contienen, el total de fr'),
('contienen', 0, 1, 'texto.txt', 'ero de documentos que lo contienen, el total de fr'),
('contienen', 1, 1, 'texto.txt', 'ero de documentos que lo contienen, el total de fr'),
('datos', 0, 1, 'texto.txt', 'e posting de una base de datos de MySQL. Se guarda'),
('datos', 1, 1, 'texto.txt', 'e posting de una base de datos de MySQL. Se guarda'),
('de', 0, 11, 'texto.txt', ' usuario cargar archivos de texto plano desde un f'),
('de', 1, 11, 'texto.txt', ' usuario cargar archivos de texto plano desde un f'),
('del', 0, 4, 'texto.txt', 'encias, el identificador del documento, la frecuen'),
('del', 1, 4, 'texto.txt', 'encias, el identificador del documento, la frecuen'),
('desde', 0, 1, 'texto.txt', ' archivos de texto plano desde un formulario. Cada'),
('desde', 1, 1, 'texto.txt', ' archivos de texto plano desde un formulario. Cada'),
('diccionario', 0, 1, 'texto.txt', 'b utilizará una tabla de diccionario y de posting '),
('diccionario', 1, 1, 'texto.txt', 'b utilizará una tabla de diccionario y de posting '),
('documento', 0, 2, 'texto.txt', 'érmino índice, número de documentos que lo contien'),
('documento', 1, 2, 'texto.txt', 'érmino índice, número de documentos que lo contien'),
('documentos', 0, 1, 'texto.txt', 'érmino índice, número de documentos que lo contien'),
('documentos', 1, 1, 'texto.txt', 'érmino índice, número de documentos que lo contien'),
('el', 0, 6, 'texto.txt', ', la aplicación generará el índice invertido de to'),
('el', 1, 6, 'texto.txt', ', la aplicación generará el índice invertido de to'),
('en', 0, 3, 'texto.txt', 'archivos, la aplicación generará el índice inverti'),
('en', 1, 3, 'texto.txt', 'archivos, la aplicación generará el índice inverti'),
('ese', 0, 1, 'texto.txt', 'recuencia del término en ese documento, el nombre '),
('ese', 1, 1, 'texto.txt', 'recuencia del término en ese documento, el nombre '),
('formulario', 0, 1, 'texto.txt', ' de texto plano desde un formulario. Cada vez que '),
('formulario', 1, 1, 'texto.txt', ' de texto plano desde un formulario. Cada vez que '),
('frecuencia', 0, 1, 'texto.txt', 'o contienen, el total de frecuencias, el identific'),
('frecuencia', 1, 1, 'texto.txt', 'o contienen, el total de frecuencias, el identific'),
('frecuencias', 0, 1, 'texto.txt', 'o contienen, el total de frecuencias, el identific'),
('frecuencias', 1, 1, 'texto.txt', 'o contienen, el total de frecuencias, el identific'),
('generará', 0, 1, 'texto.txt', ' archivos, la aplicación generará el índice invert'),
('generará', 1, 1, 'texto.txt', ' archivos, la aplicación generará el índice invert'),
('guardando', 0, 1, 'texto.txt', ' archivos que se han ido guardando en una carpeta '),
('guardando', 1, 1, 'texto.txt', ' archivos que se han ido guardando en una carpeta '),
('guardará', 0, 1, 'texto.txt', 'se de datos de MySQL. Se guardará el término índic'),
('guardará', 1, 1, 'texto.txt', 'se de datos de MySQL. Se guardará el término índic'),
('han', 0, 1, 'texto.txt', 'odos los archivos que se han ido guardando en una '),
('han', 1, 1, 'texto.txt', 'odos los archivos que se han ido guardando en una '),
('identificador', 0, 1, 'texto.txt', 'total de frecuencias, el identificador del documen'),
('identificador', 1, 1, 'texto.txt', 'total de frecuencias, el identificador del documen'),
('ido', 0, 1, 'texto.txt', 'generará el índice invertido de todos los archivos'),
('ido', 1, 1, 'texto.txt', 'generará el índice invertido de todos los archivos'),
('índice', 0, 2, 'texto.txt', 'a aplicación generará el índice invertido de todos'),
('índice', 1, 2, 'texto.txt', 'a aplicación generará el índice invertido de todos'),
('invertido', 0, 1, 'texto.txt', 'ación generará el índice invertido de todos los ar'),
('invertido', 1, 1, 'texto.txt', 'ación generará el índice invertido de todos los ar'),
('la', 0, 4, 'texto.txt', 'argar archivos de texto plano desde un formulario.'),
('la', 1, 4, 'texto.txt', 'argar archivos de texto plano desde un formulario.'),
('lo', 0, 2, 'texto.txt', 'ndice invertido de todos los archivos que se han i'),
('lo', 1, 2, 'texto.txt', 'ndice invertido de todos los archivos que se han i'),
('los', 0, 1, 'texto.txt', 'ndice invertido de todos los archivos que se han i'),
('los', 1, 1, 'texto.txt', 'ndice invertido de todos los archivos que se han i'),
('mysql', 0, 1, 'texto.txt', 'La aplicación Web permitirá al usuario cargar arch'),
('mysql', 1, 1, 'texto.txt', 'La aplicación Web permitirá al usuario cargar arch'),
('nombre', 0, 1, 'texto.txt', 'ino en ese documento, el nombre del archivo de tex'),
('nombre', 1, 1, 'texto.txt', 'ino en ese documento, el nombre del archivo de tex'),
('número', 0, 1, 'texto.txt', 'rdará el término índice, número de documentos que '),
('número', 1, 1, 'texto.txt', 'rdará el término índice, número de documentos que '),
('permitirá', 0, 1, 'texto.txt', 'La aplicación Web permitirá al usuario cargar arch'),
('permitirá', 1, 1, 'texto.txt', 'La aplicación Web permitirá al usuario cargar arch'),
('plano', 0, 1, 'texto.txt', 'cargar archivos de texto plano desde un formulario'),
('plano', 1, 1, 'texto.txt', 'cargar archivos de texto plano desde un formulario'),
('porción', 0, 1, 'texto.txt', 'to que lo contiene y una porción del texto (50 car'),
('porción', 1, 1, 'texto.txt', 'to que lo contiene y una porción del texto (50 car'),
('posting', 0, 1, 'texto.txt', 'abla de diccionario y de posting de una base de da'),
('posting', 1, 1, 'texto.txt', 'abla de diccionario y de posting de una base de da'),
('que', 0, 4, 'texto.txt', ' un formulario. Cada vez que se cargue una colecci'),
('que', 1, 4, 'texto.txt', ' un formulario. Cada vez que se cargue una colecci'),
('se', 0, 3, 'texto.txt', 'formulario. Cada vez que se cargue una colección d'),
('se', 1, 3, 'texto.txt', 'formulario. Cada vez que se cargue una colección d'),
('servidor', 0, 1, 'texto.txt', 'ndo en una carpeta en el servidor. La aplicación W'),
('servidor', 1, 1, 'texto.txt', 'ndo en una carpeta en el servidor. La aplicación W'),
('tabla', 0, 1, 'texto.txt', 'cación Web utilizará una tabla de diccionario y de'),
('tabla', 1, 1, 'texto.txt', 'cación Web utilizará una tabla de diccionario y de'),
('término', 0, 2, 'texto.txt', 'de MySQL. Se guardará el término índice, número de'),
('término', 1, 2, 'texto.txt', 'de MySQL. Se guardará el término índice, número de'),
('texto', 0, 3, 'texto.txt', 'uario cargar archivos de texto plano desde un form'),
('texto', 1, 3, 'texto.txt', 'uario cargar archivos de texto plano desde un form'),
('todos', 0, 1, 'texto.txt', 'á el índice invertido de todos los archivos que se'),
('todos', 1, 1, 'texto.txt', 'á el índice invertido de todos los archivos que se'),
('total', 0, 1, 'texto.txt', 'tos que lo contienen, el total de frecuencias, el '),
('total', 1, 1, 'texto.txt', 'tos que lo contienen, el total de frecuencias, el '),
('un', 0, 1, 'texto.txt', 'vos de texto plano desde un formulario. Cada vez q'),
('un', 1, 1, 'texto.txt', 'vos de texto plano desde un formulario. Cada vez q'),
('una', 0, 5, 'texto.txt', '. Cada vez que se cargue una colección de archivos'),
('una', 1, 5, 'texto.txt', '. Cada vez que se cargue una colección de archivos'),
('usuario', 0, 1, 'texto.txt', 'icación Web permitirá al usuario cargar archivos d'),
('usuario', 1, 1, 'texto.txt', 'icación Web permitirá al usuario cargar archivos d'),
('utilizará', 0, 1, 'texto.txt', 'vidor. La aplicación Web utilizará una tabla de di'),
('utilizará', 1, 1, 'texto.txt', 'vidor. La aplicación Web utilizará una tabla de di'),
('vez', 0, 1, 'texto.txt', 'esde un formulario. Cada vez que se cargue una col'),
('vez', 1, 1, 'texto.txt', 'esde un formulario. Cada vez que se cargue una col'),
('web', 0, 2, 'texto.txt', 'La aplicación Web permitirá al usuario cargar arch'),
('web', 1, 2, 'texto.txt', 'La aplicación Web permitirá al usuario cargar arch'),
('y', 0, 2, 'texto.txt', 'una tabla de diccionario y de posting de una base '),
('y', 1, 2, 'texto.txt', 'una tabla de diccionario y de posting de una base ');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `dictionary`
--
ALTER TABLE `dictionary`
  ADD PRIMARY KEY (`term`);

--
-- Indices de la tabla `posting`
--
ALTER TABLE `posting`
  ADD PRIMARY KEY (`term`,`doc_id`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `posting`
--
ALTER TABLE `posting`
  ADD CONSTRAINT `posting_ibfk_1` FOREIGN KEY (`term`) REFERENCES `dictionary` (`term`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
