-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 09-09-2025 a las 23:32:29
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `punto_venta_alimentos`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ventas`
--

CREATE TABLE `detalle_ventas` (
  `id` int(11) NOT NULL,
  `venta_id` int(11) DEFAULT NULL,
  `producto_id` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT 1,
  `precio_unitario` decimal(10,2) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  `personalizacion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_ventas`
--

INSERT INTO `detalle_ventas` (`id`, `venta_id`, `producto_id`, `cantidad`, `precio_unitario`, `subtotal`, `personalizacion`) VALUES
(1, 1, 9, 1, '37.00', '37.00', '[\"12\"]'),
(2, 1, 10, 1, '63.00', '63.00', '[\"3\"]'),
(3, 1, 11, 1, '78.00', '78.00', '[\"3\"]'),
(4, 1, 12, 1, '88.00', '88.00', '[\"3\"]'),
(5, 2, 9, 1, '53.00', '53.00', '[\"3\"]'),
(6, 3, 1, 1, '45.00', '45.00', '[\"11\"]');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingredientes`
--

CREATE TABLE `ingredientes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `precio_extra` decimal(10,2) DEFAULT 0.00,
  `disponible` tinyint(1) DEFAULT 1,
  `tipo` enum('carne','verdura','salsa','queso','otro') DEFAULT 'otro'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ingredientes`
--

INSERT INTO `ingredientes` (`id`, `nombre`, `precio_extra`, `disponible`, `tipo`) VALUES
(1, 'Tocino', '15.00', 1, 'carne'),
(2, 'Jamón', '12.00', 1, 'carne'),
(3, 'Chorizo', '18.00', 1, 'carne'),
(4, 'Pollo', '20.00', 1, 'carne'),
(5, 'Queso Amarillo', '8.00', 1, 'queso'),
(6, 'Queso Oaxaca', '10.00', 1, 'queso'),
(7, 'Queso Cheddar', '12.00', 1, 'queso'),
(8, 'Queso Panela', '9.00', 1, 'queso'),
(9, 'Lechuga', '0.00', 1, 'verdura'),
(10, 'Tomate', '0.00', 1, 'verdura'),
(11, 'Cebolla', '0.00', 1, 'verdura'),
(12, 'Cebolla Morada', '2.00', 1, 'verdura'),
(13, 'Pepinillos', '3.00', 1, 'verdura'),
(14, 'Jalapeños', '2.00', 1, 'verdura'),
(15, 'Aguacate', '8.00', 1, 'verdura'),
(16, 'Chile Chipotle', '1.00', 1, 'verdura'),
(17, 'Ketchup', '0.00', 1, 'salsa'),
(18, 'Mostaza', '0.00', 1, 'salsa'),
(19, 'Mayonesa', '0.00', 1, 'salsa'),
(20, 'Salsa BBQ', '3.00', 1, 'salsa'),
(21, 'Salsa Verde', '2.00', 1, 'salsa'),
(22, 'Salsa Roja', '2.00', 1, 'salsa'),
(23, 'Guacamole', '8.00', 1, 'salsa'),
(24, 'Frijoles', '0.00', 1, 'otro'),
(25, 'Piña', '5.00', 1, 'otro'),
(26, 'Cebolla Caramelizada', '8.00', 1, 'otro');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos_pendientes`
--

CREATE TABLE `pedidos_pendientes` (
  `id` int(11) NOT NULL,
  `datos_pedido` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`datos_pedido`)),
  `total` decimal(10,2) NOT NULL,
  `estado` enum('pendiente','procesando','completado','cancelado') DEFAULT 'pendiente',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pedidos_pendientes`
--

INSERT INTO `pedidos_pendientes` (`id`, `datos_pedido`, `total`, `estado`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, '{\"items\":[{\"product_id\":\"9\",\"quantity\":1,\"unit_price\":85,\"total_price\":85,\"ingredients\":[\"3\",\"15\",\"23\",\"5\",\"26\"]}],\"total\":85}', '85.00', 'completado', '2025-09-09 20:09:33', '2025-09-09 20:14:44'),
(2, '{\"items\":[{\"product_id\":\"5\",\"quantity\":1,\"unit_price\":58,\"total_price\":58,\"ingredients\":[\"3\"]},{\"product_id\":\"6\",\"quantity\":1,\"unit_price\":58,\"total_price\":58,\"ingredients\":[\"26\"]}],\"total\":116}', '116.00', 'completado', '2025-09-09 20:12:44', '2025-09-09 20:14:27'),
(3, '{\"items\":[{\"product_id\":\"5\",\"quantity\":1,\"unit_price\":75,\"total_price\":75,\"ingredients\":[\"3\",\"15\",\"8\"]},{\"product_id\":\"5\",\"quantity\":1,\"unit_price\":70,\"total_price\":70,\"ingredients\":[\"3\",\"2\"]},{\"product_id\":\"5\",\"quantity\":1,\"unit_price\":40,\"total_price\":40,\"ingredients\":[\"11\"]}],\"total\":185}', '185.00', 'completado', '2025-09-09 20:21:14', '2025-09-09 20:21:48'),
(4, '{\"items\":[{\"product_id\":\"9\",\"quantity\":2,\"unit_price\":53,\"total_price\":106,\"ingredients\":[\"3\"]},{\"product_id\":\"9\",\"quantity\":5,\"unit_price\":53,\"total_price\":265,\"ingredients\":[\"3\"]}],\"total\":371}', '371.00', 'completado', '2025-09-09 20:27:45', '2025-09-09 20:28:10'),
(5, '{\"items\":[{\"product_id\":\"9\",\"quantity\":4,\"unit_price\":35,\"total_price\":140,\"ingredients\":[]}],\"total\":140}', '140.00', 'completado', '2025-09-09 20:37:28', '2025-09-09 20:37:46'),
(6, '{\"items\":[{\"product_id\":\"9\",\"quantity\":1,\"unit_price\":64,\"total_price\":64,\"ingredients\":[\"3\",\"16\",\"6\"]},{\"product_id\":\"9\",\"quantity\":1,\"unit_price\":45,\"total_price\":45,\"ingredients\":[\"12\",\"18\",\"5\"]}],\"total\":109}', '109.00', 'completado', '2025-09-09 20:51:46', '2025-09-09 20:52:02'),
(7, '{\"items\":[{\"product_id\":\"1\",\"quantity\":1,\"unit_price\":60,\"total_price\":60,\"ingredients\":[\"1\"]},{\"product_id\":\"2\",\"quantity\":1,\"unit_price\":55,\"total_price\":55,\"ingredients\":[\"9\"]},{\"product_id\":\"4\",\"quantity\":1,\"unit_price\":98,\"total_price\":98,\"ingredients\":[\"3\"]}],\"total\":213}', '213.00', 'completado', '2025-09-09 20:52:37', '2025-09-09 20:52:50'),
(8, '{\"items\":[{\"product_id\":\"9\",\"quantity\":1,\"unit_price\":53,\"total_price\":53,\"ingredients\":[\"3\"]},{\"product_id\":\"10\",\"quantity\":1,\"unit_price\":63,\"total_price\":63,\"ingredients\":[\"3\"]},{\"product_id\":\"11\",\"quantity\":1,\"unit_price\":78,\"total_price\":78,\"ingredients\":[\"3\"]},{\"product_id\":\"12\",\"quantity\":1,\"unit_price\":88,\"total_price\":88,\"ingredients\":[\"3\"]}],\"total\":282}', '282.00', 'completado', '2025-09-09 20:53:27', '2025-09-09 20:53:40'),
(9, '{\"items\":[{\"product_id\":\"9\",\"quantity\":1,\"unit_price\":37,\"total_price\":37,\"ingredients\":[\"12\"]},{\"product_id\":\"10\",\"quantity\":1,\"unit_price\":63,\"total_price\":63,\"ingredients\":[\"3\"]},{\"product_id\":\"11\",\"quantity\":1,\"unit_price\":78,\"total_price\":78,\"ingredients\":[\"3\"]},{\"product_id\":\"12\",\"quantity\":1,\"unit_price\":88,\"total_price\":88,\"ingredients\":[\"3\"]}],\"total\":266}', '266.00', 'completado', '2025-09-09 20:56:18', '2025-09-09 20:56:55'),
(10, '{\"items\":[{\"product_id\":\"9\",\"quantity\":1,\"unit_price\":53,\"total_price\":53,\"ingredients\":[\"3\"]}],\"total\":53}', '53.00', 'completado', '2025-09-09 21:04:35', '2025-09-09 21:05:00'),
(11, '{\"items\":[{\"product_id\":\"1\",\"quantity\":1,\"unit_price\":45,\"total_price\":45,\"ingredients\":[\"11\"]}],\"total\":45}', '45.00', 'completado', '2025-09-09 21:06:15', '2025-09-09 21:06:31');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `tipo` enum('hamburguesa','torta','perro') NOT NULL,
  `categoria` enum('clasica','especial') NOT NULL,
  `precio_base` decimal(10,2) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `ingredientes_base` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `tipo`, `categoria`, `precio_base`, `descripcion`, `ingredientes_base`, `activo`, `created_at`) VALUES
(1, 'Hamburguesa Clásica', 'hamburguesa', 'clasica', '45.00', 'Hamburguesa tradicional con ingredientes frescos', 'Pan, carne de res, lechuga, tomate, cebolla, pepinillos', 1, '2025-09-09 17:57:59'),
(2, 'Hamburguesa con Queso', 'hamburguesa', 'clasica', '55.00', 'Hamburguesa clásica con queso amarillo derretido', 'Pan, carne de res, queso amarillo, lechuga, tomate, cebolla, pepinillos', 1, '2025-09-09 17:57:59'),
(3, 'Hamburguesa BBQ', 'hamburguesa', 'especial', '75.00', 'Hamburguesa con salsa BBQ, cebolla caramelizada y queso', 'Pan artesanal, carne de res, queso cheddar, cebolla caramelizada, salsa BBQ, lechuga, tomate', 1, '2025-09-09 17:57:59'),
(4, 'Hamburguesa Mexicana', 'hamburguesa', 'especial', '80.00', 'Hamburguesa con jalapeños, guacamole y queso', 'Pan, carne de res, queso oaxaca, guacamole, jalapeños, tomate, cebolla morada, cilantro', 1, '2025-09-09 17:57:59'),
(5, 'Torta de Pierna Clásica', 'torta', 'clasica', '40.00', 'Torta tradicional de pierna con verduras frescas', 'Pan bolillo, pierna de cerdo, frijoles, aguacate, jitomate, cebolla, lechuga, chile chipotle', 1, '2025-09-09 17:57:59'),
(6, 'Torta de Pierna con Queso', 'torta', 'clasica', '50.00', 'Torta de pierna con queso derretido', 'Pan bolillo, pierna de cerdo, queso oaxaca, frijoles, aguacate, jitomate, cebolla, lechuga', 1, '2025-09-09 17:57:59'),
(7, 'Torta Hawaiana', 'torta', 'especial', '65.00', 'Torta con piña, jamón y queso', 'Pan bolillo, pierna de cerdo, jamón, queso, piña, frijoles, aguacate, jitomate, lechuga', 1, '2025-09-09 17:57:59'),
(8, 'Torta Ahogada', 'torta', 'especial', '70.00', 'Torta sumergida en salsa de jitomate picante', 'Pan birote, pierna de cerdo, frijoles, cebolla, salsa ahogada, chile de árbol', 1, '2025-09-09 17:57:59'),
(9, 'Perro Clásico', 'perro', 'clasica', '35.00', 'Hot dog tradicional con salchichas de res', 'Pan para hot dog, salchicha de res, mostaza, ketchup, cebolla', 1, '2025-09-09 17:57:59'),
(10, 'Perro con Queso', 'perro', 'clasica', '45.00', 'Hot dog con queso derretido', 'Pan para hot dog, salchicha de res, queso amarillo, mostaza, ketchup, cebolla', 1, '2025-09-09 17:57:59'),
(11, 'Perro Mexicano', 'perro', 'especial', '60.00', 'Hot dog estilo mexicano con guacamole y jalapeños', 'Pan, salchicha, guacamole, jalapeños, tomate, cebolla, cilantro, salsa verde', 1, '2025-09-09 17:57:59'),
(12, 'Perro Supremo', 'perro', 'especial', '70.00', 'Hot dog con múltiples ingredientes gourmet', 'Pan artesanal, salchicha premium, queso cheddar, tocino, cebolla caramelizada, mostaza dijon, ketchup', 1, '2025-09-09 17:57:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `pago_recibido` decimal(10,2) NOT NULL,
  `cambio` decimal(10,2) NOT NULL,
  `fecha_venta` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` enum('pendiente','completado','cancelado') DEFAULT 'pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id`, `total`, `pago_recibido`, `cambio`, `fecha_venta`, `estado`) VALUES
(1, '266.00', '500.00', '234.00', '2025-09-09 20:56:55', 'completado'),
(2, '53.00', '60.00', '7.00', '2025-09-09 21:05:00', 'completado'),
(3, '45.00', '100.00', '55.00', '2025-09-09 21:06:31', 'completado');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `ventas_del_dia`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `ventas_del_dia` (
`fecha` date
,`total_ventas` bigint(21)
,`ingresos_totales` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `ventas_mensuales`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `ventas_mensuales` (
`año` int(4)
,`mes` int(2)
,`total_ventas` bigint(21)
,`ingresos_totales` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `ventas_semanales`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `ventas_semanales` (
`año` int(4)
,`semana` int(2)
,`total_ventas` bigint(21)
,`ingresos_totales` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `ventas_del_dia`
--
DROP TABLE IF EXISTS `ventas_del_dia`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ventas_del_dia`  AS SELECT cast(`ventas`.`fecha_venta` as date) AS `fecha`, count(0) AS `total_ventas`, sum(`ventas`.`total`) AS `ingresos_totales` FROM `ventas` WHERE `ventas`.`estado` = 'completado' AND cast(`ventas`.`fecha_venta` as date) = curdate() GROUP BY cast(`ventas`.`fecha_venta` as date)  ;

-- --------------------------------------------------------

--
-- Estructura para la vista `ventas_mensuales`
--
DROP TABLE IF EXISTS `ventas_mensuales`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ventas_mensuales`  AS SELECT year(`ventas`.`fecha_venta`) AS `año`, month(`ventas`.`fecha_venta`) AS `mes`, count(0) AS `total_ventas`, sum(`ventas`.`total`) AS `ingresos_totales` FROM `ventas` WHERE `ventas`.`estado` = 'completado' AND `ventas`.`fecha_venta` >= current_timestamp() - interval 1 month GROUP BY year(`ventas`.`fecha_venta`), month(`ventas`.`fecha_venta`)  ;

-- --------------------------------------------------------

--
-- Estructura para la vista `ventas_semanales`
--
DROP TABLE IF EXISTS `ventas_semanales`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ventas_semanales`  AS SELECT year(`ventas`.`fecha_venta`) AS `año`, week(`ventas`.`fecha_venta`) AS `semana`, count(0) AS `total_ventas`, sum(`ventas`.`total`) AS `ingresos_totales` FROM `ventas` WHERE `ventas`.`estado` = 'completado' AND `ventas`.`fecha_venta` >= current_timestamp() - interval 1 week GROUP BY year(`ventas`.`fecha_venta`), week(`ventas`.`fecha_venta`)  ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `venta_id` (`venta_id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `ingredientes`
--
ALTER TABLE `ingredientes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `pedidos_pendientes`
--
ALTER TABLE `pedidos_pendientes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `ingredientes`
--
ALTER TABLE `ingredientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `pedidos_pendientes`
--
ALTER TABLE `pedidos_pendientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_ventas`
--
ALTER TABLE `detalle_ventas`
  ADD CONSTRAINT `detalle_ventas_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_ventas_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
