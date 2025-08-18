-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-08-2025 a las 20:12:38
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bq4j3clvjlydxslsgkts`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallepedido`
--

CREATE TABLE `detallepedido` (
  `idDetallePedido` int(11) NOT NULL,
  `idPedido` int(11) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `precio_unitario` decimal(10,2) NOT NULL COMMENT 'Precio del producto al momento del pedido',
  `descuento_unitario` decimal(10,2) DEFAULT 0.00 COMMENT 'Descuento aplicado por unidad',
  `impuesto_unitario` decimal(10,2) DEFAULT 0.00 COMMENT 'Impuesto aplicado por unidad',
  `subtotal_linea` decimal(10,2) NOT NULL COMMENT 'Subtotal de la línea (cantidad * precio_unitario)',
  `total_linea` decimal(10,2) NOT NULL COMMENT 'Total final de la línea con descuentos e impuestos'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detallepedido`
--

INSERT INTO `detallepedido` (`idDetallePedido`, `idPedido`, `idProducto`, `cantidad`, `precio_unitario`, `descuento_unitario`, `impuesto_unitario`, `subtotal_linea`, `total_linea`) VALUES
(1, 1, 1, 1, 2500000.00, 0.00, 475000.00, 2500000.00, 2975000.00),
(2, 1, 2, 2, 45000.00, 0.00, 8550.00, 90000.00, 107100.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formaspago`
--

CREATE TABLE `formaspago` (
  `idFormaPago` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `formaspago`
--

INSERT INTO `formaspago` (`idFormaPago`, `nombre`, `descripcion`, `activo`, `fecha_creacion`) VALUES
(1, 'Mastercard', 'Tarjeta de crédito Mastercard', 1, '2025-08-14 21:00:00'),
(2, 'Visa', 'Tarjeta de crédito Visa', 1, '2025-08-14 21:00:00'),
(3, 'Daviplata', 'Billetera digital Daviplata', 1, '2025-08-14 21:00:00'),
(4, 'PayPal', 'Plataforma de pagos PayPal', 1, '2025-08-14 21:00:00'),
(5, 'Nequi', 'Billetera digital Nequi', 1, '2025-08-14 21:00:00'),
(6, 'PSE', 'Pagos Seguros en Línea', 1, '2025-08-14 21:00:00'),
(7, 'Efectivo', 'Pago en efectivo', 1, '2025-08-14 21:00:00'),
(8, 'Transferencia Bancaria', 'Transferencia bancaria directa', 1, '2025-08-14 21:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `idPago` int(11) NOT NULL,
  `NombrePersona` varchar(100) NOT NULL,
  `Direccion` varchar(255) NOT NULL,
  `idFormaPago` int(11) NOT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `monto_subtotal` decimal(10,2) NOT NULL COMMENT 'Monto antes de impuestos y descuentos',
  `descuentos` decimal(10,2) DEFAULT 0.00 COMMENT 'Monto total de descuentos aplicados',
  `impuestos` decimal(10,2) DEFAULT 0.00 COMMENT 'Monto total de impuestos (IVA, etc.)',
  `monto_total` decimal(10,2) NOT NULL COMMENT 'Monto final a pagar (subtotal - descuentos + impuestos)',
  `fecha_pago` timestamp NULL DEFAULT current_timestamp(),
  `estado_pago` varchar(50) NOT NULL DEFAULT 'pendiente',
  `idUsuario` int(11) DEFAULT NULL,
  `idPedido` int(11) DEFAULT NULL,
  `referencia_pago` varchar(100) DEFAULT NULL COMMENT 'Referencia del pago en la plataforma externa',
  `notas_pago` text DEFAULT NULL COMMENT 'Notas adicionales sobre el pago'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`idPago`, `NombrePersona`, `Direccion`, `idFormaPago`, `Telefono`, `correo_electronico`, `monto_subtotal`, `descuentos`, `impuestos`, `monto_total`, `fecha_pago`, `estado_pago`, `idUsuario`, `idPedido`, `referencia_pago`, `notas_pago`) VALUES
(1, 'María García', 'Calle 123 #45-67', 2, '3001234567', 'maria.garcia@email.com', 2590000.00, 0.00, 492100.00, 3082100.00, '2025-08-13 02:30:53', 'pendiente', 2, 1, 'VISA-2025-001', 'Pago con tarjeta Visa terminada en 4567');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `idPedido` int(11) NOT NULL,
  `estado` varchar(50) NOT NULL DEFAULT 'pendiente',
  `infopersona` varchar(200) NOT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `Direccion` varchar(255) NOT NULL,
  `nombresProductos` text NOT NULL,
  `fecha_pedido` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `subtotal` decimal(10,2) DEFAULT 0.00 COMMENT 'Total antes de impuestos y descuentos',
  `descuentos_totales` decimal(10,2) DEFAULT 0.00 COMMENT 'Descuentos aplicados al pedido',
  `impuestos_totales` decimal(10,2) DEFAULT 0.00 COMMENT 'Impuestos aplicados al pedido',
  `total` decimal(10,2) DEFAULT 0.00 COMMENT 'Total final del pedido',
  `idUsuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`idPedido`, `estado`, `infopersona`, `correo_electronico`, `Direccion`, `nombresProductos`, `fecha_pedido`, `fecha_actualizacion`, `subtotal`, `descuentos_totales`, `impuestos_totales`, `total`, `idUsuario`) VALUES
(1, 'pendiente', 'María García - CC: 87654321', 'maria.garcia@email.com', 'Calle 123 #45-67', 'Laptop Dell Inspiron (1), Mouse Inalámbrico (2)', '2025-08-13 02:30:53', '2025-08-14 21:00:00', 2590000.00, 0.00, 492100.00, 3082100.00, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `idProducto` int(11) NOT NULL,
  `nombreProducto` varchar(100) NOT NULL,
  `imagen` varchar(100) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 0,
  `informacion` text DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1,
  `porcentaje_impuesto` decimal(5,2) DEFAULT 19.00 COMMENT 'Porcentaje de IVA aplicable al producto'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idProducto`, `nombreProducto`, `imagen`, `valor`, `cantidad`, `informacion`, `fecha_creacion`, `activo`, `porcentaje_impuesto`) VALUES
(1, 'iPhone 15 Pro', 'iPhone.jpg', 2500000.00, 10, 'iPhome de 15 pulgadas, 8GB RAM, 256GB SSD', '2025-08-13 02:30:53', 1, 19.00),
(2, 'Apple_Watch', 'Apple_Watch_Ultra.webp', 45000.00, 50, 'Reloj inteligente resistente para deportes extremos', '2025-08-13 02:30:53', 0, 19.00),
(3, 'iPad Pro', 'iPad Pro 12.9.webp', 180000.00, 25, 'Tablet profesional con pantalla Liquid Retina XDR', '2025-08-13 02:30:53', 1, 19.00),
(4, 'Macbook', 'Macbook-air-m2.jpeg', 180000.00, 25, 'Laptop ultradelgada con chip M2 y batería de larga duración\"', '2025-08-17 21:45:13', 1, 19.00),
(5, 'Samsung Galaxy S24', 'Samsung_Galaxy_S24.jpg', 120000.00, 12, 'Muy buen celular', '2025-08-18 02:28:31', 1, 19.00),
(6, 'AirPods Pro', 'AirPods_Pro.png', 100000.00, 12, 'Muy buenos', '2025-08-18 02:36:31', 1, 19.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `cedula` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` text NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` varchar(50) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `cedula`, `nombre`, `correo`, `password`, `rol`, `fecha_creacion`, `activo`) VALUES
(1, '12345678', 'Juan Pérez', 'JuanPerez@email.com', 'Juan', 'admin', '2025-08-13 02:30:53', 1),
(2, '87654321', 'María García', 'maria.garcia@email.com', 'María', 'cliente', '2025-08-13 02:30:53', 1),
(4, '1096063677', 'Marta García', 'marta.garcia@email.com', 'Marta', 'cliente', '2025-08-14 18:01:30', 1),
(5, '1096063633', 'Brayan David Herrera Barajas', 'bherrerabarajs@gmail.com', 'Laurayluis87', 'admin', '2025-08-16 16:40:50', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `detallepedido`
--
ALTER TABLE `detallepedido`
  ADD PRIMARY KEY (`idDetallePedido`),
  ADD KEY `idPedido` (`idPedido`),
  ADD KEY `idProducto` (`idProducto`);

--
-- Indices de la tabla `formaspago`
--
ALTER TABLE `formaspago`
  ADD PRIMARY KEY (`idFormaPago`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `idx_formas_pago_activo` (`activo`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`idPago`),
  ADD KEY `idUsuario` (`idUsuario`),
  ADD KEY `idPedido` (`idPedido`),
  ADD KEY `idFormaPago` (`idFormaPago`),
  ADD KEY `idx_pagos_estado` (`estado_pago`),
  ADD KEY `idx_pagos_fecha` (`fecha_pago`),
  ADD KEY `idx_pagos_referencia` (`referencia_pago`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`idPedido`),
  ADD KEY `idUsuario` (`idUsuario`),
  ADD KEY `idx_pedidos_estado` (`estado`),
  ADD KEY `idx_pedidos_fecha` (`fecha_pedido`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`idProducto`),
  ADD KEY `idx_producto_nombre` (`nombreProducto`),
  ADD KEY `idx_producto_activo` (`activo`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD KEY `idx_usuario_cedula` (`cedula`),
  ADD KEY `idx_usuario_rol` (`rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `detallepedido`
--
ALTER TABLE `detallepedido`
  MODIFY `idDetallePedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `formaspago`
--
ALTER TABLE `formaspago`
  MODIFY `idFormaPago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `idPago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `idPedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idProducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detallepedido`
--
ALTER TABLE `detallepedido`
  ADD CONSTRAINT `DetallePedido_ibfk_1` FOREIGN KEY (`idPedido`) REFERENCES `pedidos` (`idPedido`) ON DELETE CASCADE,
  ADD CONSTRAINT `DetallePedido_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`);

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `Pagos_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`) ON DELETE SET NULL,
  ADD CONSTRAINT `Pagos_ibfk_2` FOREIGN KEY (`idPedido`) REFERENCES `pedidos` (`idPedido`) ON DELETE CASCADE,
  ADD CONSTRAINT `Pagos_ibfk_3` FOREIGN KEY (`idFormaPago`) REFERENCES `formaspago` (`idFormaPago`);

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `Pedidos_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
