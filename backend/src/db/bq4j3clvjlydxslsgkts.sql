-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: bq4j3clvjlydxslsgkts-mysql.services.clever-cloud.com:3306
-- Tiempo de generación: 14-08-2025 a las 16:07:12
-- Versión del servidor: 8.0.22-13
-- Versión de PHP: 8.2.29

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
-- Estructura de tabla para la tabla `Pagos`
--

CREATE TABLE `Pagos` (
  `idPago` int NOT NULL,
  `NombrePersona` varchar(100) NOT NULL,
  `Direccion` varchar(255) NOT NULL,
  `forma_de_pago` varchar(50) NOT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_pago` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `estado_pago` varchar(50) NOT NULL DEFAULT 'pendiente',
  `idUsuario` int DEFAULT NULL,
  `idPedido` int DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `Pagos`
--

INSERT INTO `Pagos` (`idPago`, `NombrePersona`, `Direccion`, `forma_de_pago`, `Telefono`, `correo_electronico`, `monto`, `fecha_pago`, `estado_pago`, `idUsuario`, `idPedido`) VALUES
(1, 'María García', 'Calle 123 #45-67', 'tarjeta_credito', '3001234567', 'maria.garcia@email.com', 2590000.00, '2025-08-12 21:30:53', 'pendiente', 2, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Pedidos`
--

CREATE TABLE `Pedidos` (
  `idPedido` int NOT NULL,
  `estado` varchar(50) NOT NULL DEFAULT 'pendiente',
  `infopersona` varchar(200) NOT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `Direccion` varchar(255) NOT NULL,
  `nombresProductos` text NOT NULL,
  `fecha_pedido` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `total` decimal(10,2) DEFAULT '0.00',
  `idUsuario` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `Pedidos`
--

INSERT INTO `Pedidos` (`idPedido`, `estado`, `infopersona`, `correo_electronico`, `Direccion`, `nombresProductos`, `fecha_pedido`, `fecha_actualizacion`, `total`, `idUsuario`) VALUES
(1, 'pendiente', 'María García - CC: 87654321', 'maria.garcia@email.com', 'Calle 123 #45-67', 'Laptop Dell Inspiron (1), Mouse Inalámbrico (2)', '2025-08-12 21:30:53', '2025-08-12 21:30:53', 2590000.00, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Producto`
--

CREATE TABLE `Producto` (
  `idProducto` int NOT NULL,
  `nombreProducto` varchar(100) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `cantidad` int NOT NULL DEFAULT '0',
  `informacion` text,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `Producto`
--

INSERT INTO `Producto` (`idProducto`, `nombreProducto`, `valor`, `cantidad`, `informacion`, `fecha_creacion`, `activo`) VALUES
(1, 'Laptop Dell Inspiron', 2500000.00, 10, 'Laptop de 15 pulgadas, 8GB RAM, 256GB SSD', '2025-08-12 21:30:53', 1),
(2, 'Mouse Inalámbrico', 45000.00, 50, 'Mouse óptico inalámbrico con receptor USB', '2025-08-12 21:30:53', 1),
(3, 'Teclado Mecánico', 180000.00, 25, 'Teclado mecánico retroiluminado', '2025-08-12 21:30:53', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Usuario`
--

CREATE TABLE `Usuario` (
  `idUsuario` int NOT NULL,
  `cedula` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `Rol` varchar(50) NOT NULL DEFAULT 'cliente',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `Usuario`
--

INSERT INTO `Usuario` (`idUsuario`, `cedula`, `nombre`, `password`, `Rol`, `fecha_creacion`, `activo`) VALUES
(1, '12345678', 'Juan Pérez', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'admin', '2025-08-12 21:30:53', 1),
(2, '87654321', 'María García', 'c6ba91b90d922e159893f46c387e5dc1b3dc5c101a5a4522f03b987177a24a91', 'cliente', '2025-08-12 21:30:53', 1),
(3, '11223344', 'Carlos López', '5efc2b017da4f7736d192a74dde5891369e0685d4d38f2a455b6fcdab282df9c', 'vendedor', '2025-08-12 21:30:53', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `Pagos`
--
ALTER TABLE `Pagos`
  ADD PRIMARY KEY (`idPago`),
  ADD KEY `idUsuario` (`idUsuario`),
  ADD KEY `idPedido` (`idPedido`),
  ADD KEY `idx_pagos_estado` (`estado_pago`),
  ADD KEY `idx_pagos_fecha` (`fecha_pago`);

--
-- Indices de la tabla `Pedidos`
--
ALTER TABLE `Pedidos`
  ADD PRIMARY KEY (`idPedido`),
  ADD KEY `idUsuario` (`idUsuario`),
  ADD KEY `idx_pedidos_estado` (`estado`),
  ADD KEY `idx_pedidos_fecha` (`fecha_pedido`);

--
-- Indices de la tabla `Producto`
--
ALTER TABLE `Producto`
  ADD PRIMARY KEY (`idProducto`),
  ADD KEY `idx_producto_nombre` (`nombreProducto`);

--
-- Indices de la tabla `Usuario`
--
ALTER TABLE `Usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD KEY `idx_usuario_cedula` (`cedula`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `Pagos`
--
ALTER TABLE `Pagos`
  MODIFY `idPago` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Pedidos`
--
ALTER TABLE `Pedidos`
  MODIFY `idPedido` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `Producto`
--
ALTER TABLE `Producto`
  MODIFY `idProducto` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Usuario`
--
ALTER TABLE `Usuario`
  MODIFY `idUsuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `Pagos`
--
ALTER TABLE `Pagos`
  ADD CONSTRAINT `Pagos_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `Usuario` (`idUsuario`) ON DELETE SET NULL,
  ADD CONSTRAINT `Pagos_ibfk_2` FOREIGN KEY (`idPedido`) REFERENCES `Pedidos` (`idPedido`) ON DELETE CASCADE;

--
-- Filtros para la tabla `Pedidos`
--
ALTER TABLE `Pedidos`
  ADD CONSTRAINT `Pedidos_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `Usuario` (`idUsuario`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
