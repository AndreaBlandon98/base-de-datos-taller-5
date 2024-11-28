-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-11-2024 a las 00:41:36
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
-- Base de datos: `gestionclinicaveterinaria`
--
CREATE DATABASE IF NOT EXISTS `gestionclinicaveterinaria` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `gestionclinicaveterinaria`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `programar_cita`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `programar_cita` (IN `p_id_mascota` INT, IN `p_fecha` DATE, IN `p_hora` TIME, IN `p_motivo` VARCHAR(255))   BEGIN
    INSERT INTO citas (id_mascota, fecha, hora, motivo)
    VALUES (p_id_mascota, p_fecha, p_hora, p_motivo);
END$$

DROP PROCEDURE IF EXISTS `registrar_nueva_mascota`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_nueva_mascota` (IN `p_id_dueño` INT, IN `p_nombre` VARCHAR(100), IN `p_especie` VARCHAR(50), IN `p_raza` VARCHAR(50), IN `p_fecha_nacimiento` DATE, IN `p_sexo` ENUM('M','F'))   BEGIN
    INSERT INTO mascotas (id_dueño, nombre, especie, raza, fecha_nacimiento, sexo)
    VALUES (p_id_dueño, p_nombre, p_especie, p_raza, p_fecha_nacimiento, p_sexo);
END$$

DROP PROCEDURE IF EXISTS `registrar_tratamiento`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_tratamiento` (IN `p_id_mascota` INT, IN `p_diagnostico` VARCHAR(255), IN `p_tratamiento` VARCHAR(255), IN `p_observaciones` TEXT)   BEGIN
    INSERT INTO historial_medico (id_mascota, fecha, diagnostico, tratamiento, observaciones)
    VALUES (p_id_mascota, CURDATE(), p_diagnostico, p_tratamiento, p_observaciones);
END$$

DROP PROCEDURE IF EXISTS `registrar_vacunacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_vacunacion` (IN `p_id_mascota` INT, IN `p_vacuna` VARCHAR(100), IN `p_fecha` DATE, IN `p_proxima_vacunacion` DATE)   BEGIN
    INSERT INTO vacunaciones (id_mascota, vacuna, fecha, proxima_vacunacion)
    VALUES (p_id_mascota, p_vacuna, p_fecha, p_proxima_vacunacion);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas_vacunacion`
--

DROP TABLE IF EXISTS `alertas_vacunacion`;
CREATE TABLE `alertas_vacunacion` (
  `id_alerta` int(11) NOT NULL,
  `id_mascota` int(11) DEFAULT NULL,
  `mensaje` text DEFAULT NULL,
  `fecha_alerta` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `alertas_vacunacion`:
--   `id_mascota`
--       `mascotas` -> `id_mascota`
--

--
-- Volcado de datos para la tabla `alertas_vacunacion`
--

INSERT INTO `alertas_vacunacion` (`id_alerta`, `id_mascota`, `mensaje`, `fecha_alerta`) VALUES
(1, 1, 'La próxima vacunación para la mascota con ID: 1 está programada para el 2024-12-01', '2024-11-27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_historial_medico`
--

DROP TABLE IF EXISTS `auditoria_historial_medico`;
CREATE TABLE `auditoria_historial_medico` (
  `id_auditoria` int(11) NOT NULL,
  `id_mascota` int(11) DEFAULT NULL,
  `accion` varchar(50) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `detalle` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `auditoria_historial_medico`:
--   `id_mascota`
--       `mascotas` -> `id_mascota`
--

--
-- Volcado de datos para la tabla `auditoria_historial_medico`
--

INSERT INTO `auditoria_historial_medico` (`id_auditoria`, `id_mascota`, `accion`, `fecha`, `detalle`) VALUES
(1, 1, 'INSERT', '2024-11-27', 'Se agregó un nuevo historial médico para la mascota con ID: 1'),
(2, 1, 'INSERT', '2024-11-27', 'Se agregó un nuevo historial médico para la mascota con ID: 1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_recordatorios`
--

DROP TABLE IF EXISTS `auditoria_recordatorios`;
CREATE TABLE `auditoria_recordatorios` (
  `id` int(11) NOT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `detalle` text DEFAULT NULL,
  `fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `auditoria_recordatorios`:
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_reportes`
--

DROP TABLE IF EXISTS `auditoria_reportes`;
CREATE TABLE `auditoria_reportes` (
  `id` int(11) NOT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `detalle` text DEFAULT NULL,
  `fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `auditoria_reportes`:
--

--
-- Volcado de datos para la tabla `auditoria_reportes`
--

INSERT INTO `auditoria_reportes` (`id`, `tipo`, `detalle`, `fecha`) VALUES
(1, 'Tratamiento mensual', 'Tratamiento realizado: Desparacitación para la mascota Rex el 2024-11-27', '2024-11-27'),
(2, 'Tratamiento mensual', 'Tratamiento realizado: Antibióticos y colirio para la mascota Rex el 2024-11-27', '2024-11-27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_stock_medicamentos`
--

DROP TABLE IF EXISTS `auditoria_stock_medicamentos`;
CREATE TABLE `auditoria_stock_medicamentos` (
  `id_auditoria` int(11) NOT NULL,
  `id_medicamento` int(11) DEFAULT NULL,
  `cantidad_anterior` int(11) DEFAULT NULL,
  `cantidad_nueva` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `auditoria_stock_medicamentos`:
--   `id_medicamento`
--       `medicamentos` -> `id_medicamento`
--

--
-- Volcado de datos para la tabla `auditoria_stock_medicamentos`
--

INSERT INTO `auditoria_stock_medicamentos` (`id_auditoria`, `id_medicamento`, `cantidad_anterior`, `cantidad_nueva`, `fecha`) VALUES
(1, 1, 100, 90, '2024-11-27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_vacunaciones`
--

DROP TABLE IF EXISTS `auditoria_vacunaciones`;
CREATE TABLE `auditoria_vacunaciones` (
  `id` int(11) NOT NULL,
  `id_mascota` int(11) DEFAULT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `detalle` text DEFAULT NULL,
  `fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `auditoria_vacunaciones`:
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `citas`
--

DROP TABLE IF EXISTS `citas`;
CREATE TABLE `citas` (
  `id_cita` int(11) NOT NULL,
  `id_mascota` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `estado` enum('Pendiente','Realizada','Cancelada') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `citas`:
--   `id_mascota`
--       `mascotas` -> `id_mascota`
--

--
-- Volcado de datos para la tabla `citas`
--

INSERT INTO `citas` (`id_cita`, `id_mascota`, `fecha`, `hora`, `motivo`, `estado`) VALUES
(1, 1, '2024-11-30', '10:00:00', 'Revisión general', 'Pendiente'),
(2, 1, '2024-12-01', '10:00:00', 'Vacunación contra la rabia', NULL),
(6, 1, '2024-12-05', '10:00:00', 'Consulta general', 'Pendiente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dueños`
--

DROP TABLE IF EXISTS `dueños`;
CREATE TABLE `dueños` (
  `id_dueño` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `dueños`:
--

--
-- Volcado de datos para la tabla `dueños`
--

INSERT INTO `dueños` (`id_dueño`, `nombre`, `telefono`, `direccion`, `correo`) VALUES
(1, 'Juan Pérez', '1234567890', 'Calle Ficticia 123', 'juanperez@mail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_medico`
--

DROP TABLE IF EXISTS `historial_medico`;
CREATE TABLE `historial_medico` (
  `id_historial` int(11) NOT NULL,
  `id_mascota` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `diagnostico` varchar(255) DEFAULT NULL,
  `tratamiento` varchar(255) DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `historial_medico`:
--   `id_mascota`
--       `mascotas` -> `id_mascota`
--

--
-- Volcado de datos para la tabla `historial_medico`
--

INSERT INTO `historial_medico` (`id_historial`, `id_mascota`, `fecha`, `diagnostico`, `tratamiento`, `observaciones`) VALUES
(16, 1, '2024-03-10', 'Infección respiratoria', 'Antibióticos durante 7 días', 'Mascota mostró mejoría en 3 días.'),
(17, 1, '2024-11-27', 'Revisión de salud', 'Desparacitación', 'Se recomienda seguimiento en 3 meses.'),
(18, 1, '2024-11-27', 'Infección ocular', 'Antibióticos y colirio', 'Mascota mejoró en 3 días');

--
-- Disparadores `historial_medico`
--
DROP TRIGGER IF EXISTS `registrar_delete_historial`;
DELIMITER $$
CREATE TRIGGER `registrar_delete_historial` AFTER DELETE ON `historial_medico` FOR EACH ROW BEGIN

    INSERT INTO auditoria_historial_medico (id_mascota, accion, fecha, detalle)
    VALUES (OLD.id_mascota, 'DELETE', CURDATE(), CONCAT('Se eliminó un historial médico para la mascota con ID: ', OLD.id_mascota));
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `registrar_insert_historial`;
DELIMITER $$
CREATE TRIGGER `registrar_insert_historial` AFTER INSERT ON `historial_medico` FOR EACH ROW BEGIN

    INSERT INTO auditoria_historial_medico (id_mascota, accion, fecha, detalle)
    VALUES (NEW.id_mascota, 'INSERT', CURDATE(), CONCAT('Se agregó un nuevo historial médico para la mascota con ID: ', NEW.id_mascota));
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `registrar_update_historial`;
DELIMITER $$
CREATE TRIGGER `registrar_update_historial` AFTER UPDATE ON `historial_medico` FOR EACH ROW BEGIN

    INSERT INTO auditoria_historial_medico (id_mascota, accion, fecha, detalle)
    VALUES (NEW.id_mascota, 'UPDATE', CURDATE(), CONCAT('Se actualizó el historial médico para la mascota con ID: ', NEW.id_mascota));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario_medicamentos`
--

DROP TABLE IF EXISTS `inventario_medicamentos`;
CREATE TABLE `inventario_medicamentos` (
  `id_inventario` int(11) NOT NULL,
  `id_medicamento` int(11) DEFAULT NULL,
  `cantidad_usada` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `inventario_medicamentos`:
--   `id_medicamento`
--       `medicamentos` -> `id_medicamento`
--

--
-- Volcado de datos para la tabla `inventario_medicamentos`
--

INSERT INTO `inventario_medicamentos` (`id_inventario`, `id_medicamento`, `cantidad_usada`, `fecha`) VALUES
(1, 1, 20, '2024-03-15'),
(2, 1, 10, '2024-11-27');

--
-- Disparadores `inventario_medicamentos`
--
DROP TRIGGER IF EXISTS `controlar_stock_medicamentos`;
DELIMITER $$
CREATE TRIGGER `controlar_stock_medicamentos` AFTER INSERT ON `inventario_medicamentos` FOR EACH ROW BEGIN
    DECLARE stock_actual INT;
    

    SELECT cantidad INTO stock_actual
    FROM medicamentos
    WHERE id_medicamento = NEW.id_medicamento;
    

    UPDATE medicamentos
    SET cantidad = stock_actual - NEW.cantidad_usada
    WHERE id_medicamento = NEW.id_medicamento;
    
 
    INSERT INTO auditoria_stock_medicamentos (id_medicamento, cantidad_anterior, cantidad_nueva, fecha)
    VALUES (NEW.id_medicamento, stock_actual, stock_actual - NEW.cantidad_usada, CURDATE());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mascotas`
--

DROP TABLE IF EXISTS `mascotas`;
CREATE TABLE `mascotas` (
  `id_mascota` int(11) NOT NULL,
  `id_dueño` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `especie` varchar(50) DEFAULT NULL,
  `raza` varchar(50) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `sexo` enum('M','F') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `mascotas`:
--   `id_dueño`
--       `dueños` -> `id_dueño`
--

--
-- Volcado de datos para la tabla `mascotas`
--

INSERT INTO `mascotas` (`id_mascota`, `id_dueño`, `nombre`, `especie`, `raza`, `fecha_nacimiento`, `sexo`) VALUES
(1, 1, 'Rex', 'Perro', 'Labrador', '2020-03-15', 'M'),
(2, 1, 'Bobby', 'Perro', 'Labrador', '2020-05-10', 'M');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medicamentos`
--

DROP TABLE IF EXISTS `medicamentos`;
CREATE TABLE `medicamentos` (
  `id_medicamento` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `medicamentos`:
--

--
-- Volcado de datos para la tabla `medicamentos`
--

INSERT INTO `medicamentos` (`id_medicamento`, `nombre`, `descripcion`, `cantidad`, `precio`) VALUES
(1, 'Amoxicilina', 'Antibiótico de amplio espectro, utilizado para infecciones respiratorias.', 90, 15.50);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
CREATE TABLE `notificaciones` (
  `id` int(11) NOT NULL,
  `id_mascota` int(11) DEFAULT NULL,
  `mensaje` varchar(255) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `tipo` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `notificaciones`:
--

--
-- Volcado de datos para la tabla `notificaciones`
--

INSERT INTO `notificaciones` (`id`, `id_mascota`, `mensaje`, `fecha`, `tipo`) VALUES
(1, 1, 'Recordatorio: La mascota Rex tiene una cita el 2024-11-30', '2024-11-27', 'Cita próxima'),
(2, 1, 'Recordatorio: La mascota Rex tiene una cita el 2024-12-01', '2024-11-27', 'Cita próxima'),
(4, 1, 'Recordatorio: La mascota Rex tiene una vacunación programada para el 2024-12-01', '2024-11-27', 'Vacunación próxima'),
(5, 1, 'Reporte mensual: El tratamiento Desparacitación para la mascota Rex fue realizado el 2024-11-27', '2024-11-27', 'Reporte de Tratamiento'),
(6, 1, 'Reporte mensual: El tratamiento Antibióticos y colirio para la mascota Rex fue realizado el 2024-11-27', '2024-11-27', 'Reporte de Tratamiento');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vacunaciones`
--

DROP TABLE IF EXISTS `vacunaciones`;
CREATE TABLE `vacunaciones` (
  `id_vacunacion` int(11) NOT NULL,
  `id_mascota` int(11) DEFAULT NULL,
  `vacuna` varchar(100) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `proxima_vacunacion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `vacunaciones`:
--   `id_mascota`
--       `mascotas` -> `id_mascota`
--

--
-- Volcado de datos para la tabla `vacunaciones`
--

INSERT INTO `vacunaciones` (`id_vacunacion`, `id_mascota`, `vacuna`, `fecha`, `proxima_vacunacion`) VALUES
(1, 1, 'Rabia', '2024-01-15', '2025-01-15'),
(2, 1, 'Parvovirus', '2024-02-20', '2025-02-20'),
(3, 1, 'Vacuna contra la rabia', '2024-03-10', '2024-12-01'),
(4, 1, 'Rabia', '2024-11-30', '2025-11-30'),
(5, 1, 'Rabia', '2024-01-15', '2025-01-15');

--
-- Disparadores `vacunaciones`
--
DROP TRIGGER IF EXISTS `alertar_proxima_vacunacion`;
DELIMITER $$
CREATE TRIGGER `alertar_proxima_vacunacion` AFTER INSERT ON `vacunaciones` FOR EACH ROW BEGIN
    DECLARE alerta_fecha DATE;
    

    SET alerta_fecha = NEW.proxima_vacunacion;
    
    IF alerta_fecha <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN
   
        INSERT INTO alertas_vacunacion (id_mascota, mensaje, fecha_alerta)
        VALUES (NEW.id_mascota, CONCAT('La próxima vacunación para la mascota con ID: ', NEW.id_mascota, ' está programada para el ', NEW.proxima_vacunacion), CURDATE());
    END IF;
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alertas_vacunacion`
--
ALTER TABLE `alertas_vacunacion`
  ADD PRIMARY KEY (`id_alerta`),
  ADD KEY `id_mascota` (`id_mascota`);

--
-- Indices de la tabla `auditoria_historial_medico`
--
ALTER TABLE `auditoria_historial_medico`
  ADD PRIMARY KEY (`id_auditoria`),
  ADD KEY `id_mascota` (`id_mascota`);

--
-- Indices de la tabla `auditoria_recordatorios`
--
ALTER TABLE `auditoria_recordatorios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `auditoria_reportes`
--
ALTER TABLE `auditoria_reportes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `auditoria_stock_medicamentos`
--
ALTER TABLE `auditoria_stock_medicamentos`
  ADD PRIMARY KEY (`id_auditoria`),
  ADD KEY `id_medicamento` (`id_medicamento`);

--
-- Indices de la tabla `auditoria_vacunaciones`
--
ALTER TABLE `auditoria_vacunaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `citas`
--
ALTER TABLE `citas`
  ADD PRIMARY KEY (`id_cita`),
  ADD KEY `id_mascota` (`id_mascota`);

--
-- Indices de la tabla `dueños`
--
ALTER TABLE `dueños`
  ADD PRIMARY KEY (`id_dueño`);

--
-- Indices de la tabla `historial_medico`
--
ALTER TABLE `historial_medico`
  ADD PRIMARY KEY (`id_historial`),
  ADD KEY `id_mascota` (`id_mascota`);

--
-- Indices de la tabla `inventario_medicamentos`
--
ALTER TABLE `inventario_medicamentos`
  ADD PRIMARY KEY (`id_inventario`),
  ADD KEY `id_medicamento` (`id_medicamento`);

--
-- Indices de la tabla `mascotas`
--
ALTER TABLE `mascotas`
  ADD PRIMARY KEY (`id_mascota`),
  ADD KEY `id_dueño` (`id_dueño`);

--
-- Indices de la tabla `medicamentos`
--
ALTER TABLE `medicamentos`
  ADD PRIMARY KEY (`id_medicamento`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `vacunaciones`
--
ALTER TABLE `vacunaciones`
  ADD PRIMARY KEY (`id_vacunacion`),
  ADD KEY `id_mascota` (`id_mascota`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alertas_vacunacion`
--
ALTER TABLE `alertas_vacunacion`
  MODIFY `id_alerta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `auditoria_historial_medico`
--
ALTER TABLE `auditoria_historial_medico`
  MODIFY `id_auditoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `auditoria_recordatorios`
--
ALTER TABLE `auditoria_recordatorios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auditoria_reportes`
--
ALTER TABLE `auditoria_reportes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `auditoria_stock_medicamentos`
--
ALTER TABLE `auditoria_stock_medicamentos`
  MODIFY `id_auditoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `auditoria_vacunaciones`
--
ALTER TABLE `auditoria_vacunaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `citas`
--
ALTER TABLE `citas`
  MODIFY `id_cita` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `dueños`
--
ALTER TABLE `dueños`
  MODIFY `id_dueño` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `historial_medico`
--
ALTER TABLE `historial_medico`
  MODIFY `id_historial` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `inventario_medicamentos`
--
ALTER TABLE `inventario_medicamentos`
  MODIFY `id_inventario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `mascotas`
--
ALTER TABLE `mascotas`
  MODIFY `id_mascota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `medicamentos`
--
ALTER TABLE `medicamentos`
  MODIFY `id_medicamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `vacunaciones`
--
ALTER TABLE `vacunaciones`
  MODIFY `id_vacunacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alertas_vacunacion`
--
ALTER TABLE `alertas_vacunacion`
  ADD CONSTRAINT `alertas_vacunacion_ibfk_1` FOREIGN KEY (`id_mascota`) REFERENCES `mascotas` (`id_mascota`);

--
-- Filtros para la tabla `auditoria_historial_medico`
--
ALTER TABLE `auditoria_historial_medico`
  ADD CONSTRAINT `auditoria_historial_medico_ibfk_1` FOREIGN KEY (`id_mascota`) REFERENCES `mascotas` (`id_mascota`);

--
-- Filtros para la tabla `auditoria_stock_medicamentos`
--
ALTER TABLE `auditoria_stock_medicamentos`
  ADD CONSTRAINT `auditoria_stock_medicamentos_ibfk_1` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamentos` (`id_medicamento`);

--
-- Filtros para la tabla `citas`
--
ALTER TABLE `citas`
  ADD CONSTRAINT `citas_ibfk_1` FOREIGN KEY (`id_mascota`) REFERENCES `mascotas` (`id_mascota`);

--
-- Filtros para la tabla `historial_medico`
--
ALTER TABLE `historial_medico`
  ADD CONSTRAINT `historial_medico_ibfk_1` FOREIGN KEY (`id_mascota`) REFERENCES `mascotas` (`id_mascota`);

--
-- Filtros para la tabla `inventario_medicamentos`
--
ALTER TABLE `inventario_medicamentos`
  ADD CONSTRAINT `inventario_medicamentos_ibfk_1` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamentos` (`id_medicamento`);

--
-- Filtros para la tabla `mascotas`
--
ALTER TABLE `mascotas`
  ADD CONSTRAINT `mascotas_ibfk_1` FOREIGN KEY (`id_dueño`) REFERENCES `dueños` (`id_dueño`);

--
-- Filtros para la tabla `vacunaciones`
--
ALTER TABLE `vacunaciones`
  ADD CONSTRAINT `vacunaciones_ibfk_1` FOREIGN KEY (`id_mascota`) REFERENCES `mascotas` (`id_mascota`);


--
-- Metadatos
--
USE `phpmyadmin`;

--
-- Metadatos para la tabla alertas_vacunacion
--

--
-- Metadatos para la tabla auditoria_historial_medico
--

--
-- Metadatos para la tabla auditoria_recordatorios
--

--
-- Metadatos para la tabla auditoria_reportes
--

--
-- Metadatos para la tabla auditoria_stock_medicamentos
--

--
-- Metadatos para la tabla auditoria_vacunaciones
--

--
-- Metadatos para la tabla citas
--

--
-- Metadatos para la tabla dueños
--

--
-- Metadatos para la tabla historial_medico
--

--
-- Metadatos para la tabla inventario_medicamentos
--

--
-- Metadatos para la tabla mascotas
--

--
-- Metadatos para la tabla medicamentos
--

--
-- Metadatos para la tabla notificaciones
--

--
-- Metadatos para la tabla vacunaciones
--

--
-- Metadatos para la base de datos gestionclinicaveterinaria
--

DELIMITER $$
--
-- Eventos
--
DROP EVENT IF EXISTS `recordatorio_citas_proximas`$$
CREATE DEFINER=`root`@`localhost` EVENT `recordatorio_citas_proximas` ON SCHEDULE EVERY 1 DAY STARTS '2024-11-28 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
   
    INSERT INTO auditoria_recordatorios (tipo, detalle, fecha)
    SELECT 'Cita próxima', 
           CONCAT('Recordatorio: La mascota ', m.nombre, ' tiene una cita el ', c.fecha), 
           CURDATE()
    FROM citas c
    JOIN mascotas m ON c.id_mascota = m.id_mascota
    WHERE c.fecha BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);
END$$

DROP EVENT IF EXISTS `actualizar_calendario_vacunacion`$$
CREATE DEFINER=`root`@`localhost` EVENT `actualizar_calendario_vacunacion` ON SCHEDULE EVERY 1 MONTH STARTS '2024-11-28 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN

    UPDATE vacunaciones
    SET proxima_vacunacion = DATE_ADD(fecha, INTERVAL 1 YEAR)
    WHERE proxima_vacunacion <= CURDATE();


    INSERT INTO auditoria_vacunaciones (id_mascota, tipo, detalle, fecha)
    SELECT id_mascota, 
           'Vacunación actualizada', 
           CONCAT('La próxima vacunación de la mascota con ID ', v.id_mascota, ' ha sido actualizada.'),
           CURDATE()
    FROM vacunaciones v
    WHERE v.proxima_vacunacion <= CURDATE();
END$$

DROP EVENT IF EXISTS `reporte_mensual_tratamientos`$$
CREATE DEFINER=`root`@`localhost` EVENT `reporte_mensual_tratamientos` ON SCHEDULE EVERY 1 MONTH STARTS '2024-11-28 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
 
    INSERT INTO auditoria_reportes (tipo, detalle, fecha)
    SELECT 'Tratamiento mensual', 
           CONCAT('Tratamiento realizado: ', h.tratamiento, ' para la mascota ', m.nombre, ' el ', h.fecha),
           CURDATE()
    FROM historial_medico h
    JOIN mascotas m ON h.id_mascota = m.id_mascota
    WHERE h.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE();
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
