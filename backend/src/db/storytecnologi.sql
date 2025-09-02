-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-09-2025 a las 20:51:57
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
-- Base de datos: `storytecnologi`
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
  `subtotal_linea` decimal(10,2) NOT NULL COMMENT 'Subtotal de la lÃ­nea (cantidad * precio_unitario)',
  `total_linea` decimal(10,2) NOT NULL COMMENT 'Total final de la lÃ­nea con descuentos e impuestos'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `detallepedido`
--
DELIMITER $$
CREATE TRIGGER `inventario_venta` AFTER INSERT ON `detallepedido` FOR EACH ROW BEGIN
    UPDATE `producto` SET `cantidad` = `cantidad` - NEW.cantidad WHERE `idProducto` = NEW.idProducto;
    INSERT INTO `movimientos_inventario` (`id_producto`, `tipo`, `cantidad`, `motivo`) 
    VALUES (NEW.idProducto, 'salida', NEW.cantidad, 'venta');
END
$$
DELIMITER ;

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
(1, 'Mastercard', 'Tarjeta de crÃ©dito Mastercard', 1, '2025-08-14 21:00:00'),
(4, 'PayPal', 'Plataforma de pagos PayPal', 1, '2025-08-14 21:00:00'),
(7, 'Efectivo', 'Pago en efectivo', 1, '2025-08-14 21:00:00'),
(8, 'Transferencia Bancaria', 'Transferencia bancaria directa', 1, '2025-08-14 21:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos_fijos`
--

CREATE TABLE `gastos_fijos` (
  `id_gastos` int(11) NOT NULL,
  `transporte` decimal(10,2) DEFAULT 0.00,
  `servicio` decimal(10,2) DEFAULT 0.00,
  `arriendado` decimal(10,2) DEFAULT 0.00,
  `publicidad` decimal(10,2) DEFAULT 0.00,
  `otros` decimal(10,2) DEFAULT 0.00,
  `periodo` date NOT NULL COMMENT 'Mes del gasto (YYYY-MM-01)',
  `total_gastos` decimal(10,2) GENERATED ALWAYS AS (`transporte` + `servicio` + `arriendado` + `publicidad` + `otros`) VIRTUAL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `gastos_fijos`
--

INSERT INTO `gastos_fijos` (`id_gastos`, `transporte`, `servicio`, `arriendado`, `publicidad`, `otros`, `periodo`, `fecha_registro`) VALUES
(1, 500000.00, 300000.00, 2000000.00, 800000.00, 0.00, '2025-09-01', '2025-09-02 18:25:02'),
(5, 450000.00, 280000.00, 1800000.00, 650000.00, 120000.00, '2025-08-01', '2025-09-02 18:36:25'),
(6, 420000.00, 290000.00, 1800000.00, 600000.00, 100000.00, '2025-07-01', '2025-09-02 18:36:25'),
(7, 480000.00, 310000.00, 1800000.00, 700000.00, 130000.00, '2025-10-01', '2025-09-02 18:36:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_inventario`
--

CREATE TABLE `movimientos_inventario` (
  `id_movimiento` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `motivo` varchar(100) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `movimientos_inventario`
--

INSERT INTO `movimientos_inventario` (`id_movimiento`, `id_producto`, `tipo`, `cantidad`, `motivo`, `fecha`) VALUES
(1, 1, 'entrada', 50, 'compra', '2025-09-02 18:35:40'),
(2, 2, 'entrada', 100, 'compra', '2025-09-02 18:35:40'),
(3, 52, 'entrada', 30, 'compra', '2025-09-02 18:35:40'),
(4, 53, 'entrada', 25, 'compra', '2025-09-02 18:35:40'),
(5, 54, 'entrada', 80, 'compra', '2025-09-02 18:35:40'),
(6, 1, 'entrada', 50, 'compra', '2025-09-02 18:36:25'),
(7, 2, 'entrada', 100, 'compra', '2025-09-02 18:36:25'),
(8, 52, 'entrada', 30, 'compra', '2025-09-02 18:36:25'),
(9, 53, 'entrada', 25, 'compra', '2025-09-02 18:36:25'),
(10, 54, 'entrada', 80, 'compra', '2025-09-02 18:36:25'),
(11, 1, 'entrada', 50, 'compra inicial iPhone 16 Pro', '2025-09-02 18:36:25'),
(12, 2, 'entrada', 100, 'compra inicial Apple Watch', '2025-09-02 18:36:25'),
(13, 52, 'entrada', 30, 'compra inicial Lenovo', '2025-09-02 18:36:25'),
(14, 53, 'entrada', 25, 'compra inicial ASUS', '2025-09-02 18:36:25'),
(15, 54, 'entrada', 80, 'compra inicial AirPods', '2025-09-02 18:36:25'),
(16, 1, 'salida', 2, 'producto daÃ±ado en transporte', '2025-09-02 18:36:25'),
(17, 54, 'salida', 5, 'muestras para exhibiciÃ³n', '2025-09-02 18:36:25');

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
  `estado_pago` varchar(50) NOT NULL DEFAULT 'realizado',
  `idUsuario` int(11) DEFAULT NULL,
  `idPedido` int(11) DEFAULT NULL,
  `referencia_pago` varchar(100) DEFAULT NULL COMMENT 'Referencia del pago en la plataforma externa',
  `notas_pago` text DEFAULT NULL COMMENT 'Notas adicionales sobre el pago'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`idPago`, `NombrePersona`, `Direccion`, `idFormaPago`, `Telefono`, `correo_electronico`, `monto_subtotal`, `descuentos`, `impuestos`, `monto_total`, `fecha_pago`, `estado_pago`, `idUsuario`, `idPedido`, `referencia_pago`, `notas_pago`) VALUES
(29, 'Laura ', 'Calle 14 No 10-13', 4, '+573175527281', 'lestevez747@gmail.com', 2960000.00, 444000.00, 478040.00, 3009040.00, '2025-08-19 04:09:06', 'realizado', 10, 30, 'PAYPAL-2025-000030-1755576546315', 'MÃ©todo de pago: paypal'),
(30, 'MarÃ­a GarcÃ­a', 'Calle 14 No 10-13', 4, '+573175527281', 'maria.garcia@email.com', 900000.00, 180000.00, 138510.00, 963510.00, '2025-08-19 19:35:40', 'realizado', 2, 31, 'PAYPAL-2025-000031-1755632142671', 'MÃ©todo de pago: paypal'),
(31, 'MarÃ­a GarcÃ­a', 'Calle 14 No 10-13', 1, '+573175527281', 'maria.garcia@email.com', 51120840.00, 12780210.00, 7430414.09, 50898128.09, '2025-08-19 20:49:45', 'realizado', 2, 32, 'CREDITCARD-2025-000032-1755636585507', 'MÃ©todo de pago: creditCard - Tarjeta terminada en 5544');

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
(30, 'enviado', 'Laura  - CC: 1096063688', 'lestevez747@gmail.com', 'Calle 14 No 10-13', 'AirPods Pro (1), iPad Pro (1), iPhone 15 Pro (1), Macbook (1)', '2025-08-19 04:09:04', '2025-08-19 04:09:40', 2960000.00, 444000.00, 478040.00, 3009040.00, 10),
(31, 'enviado', 'MarÃ­a GarcÃ­a - CC: 87654321', 'maria.garcia@email.com', 'Calle 14 No 10-13', 'Macbook (5)', '2025-08-19 19:35:40', '2025-08-23 17:31:29', 900000.00, 180000.00, 138510.00, 963510.00, 2),
(32, 'enviado', 'MarÃ­a GarcÃ­a - CC: 87654321', 'maria.garcia@email.com', 'Calle 14 No 10-13', 'Macbook (4), iPhone 15 Pro (21)', '2025-08-19 20:49:44', '2025-08-19 20:50:21', 51120840.00, 12780210.00, 7430414.09, 50898128.09, 2),
(33, 'enviado', 'MarÃ­a GarcÃ­a - CC: 87654321', 'maria.garcia@email.com', 'Calle 14 No 10-13', 'Samsung Galaxy S25 (10), iPhone 15 Pro (7)', '2025-08-23 16:56:12', '2025-08-23 17:15:09', 99999999.99, 54200070.00, 31511920.70, 99999999.99, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `precio_compra`
--

CREATE TABLE `precio_compra` (
  `id_precio_compra` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `transporte` decimal(10,2) DEFAULT 0.00,
  `almacenamiento` decimal(10,2) DEFAULT 0.00,
  `descripcion` text DEFAULT NULL,
  `iva_compra` decimal(10,2) DEFAULT 0.00,
  `retencion_fuente` decimal(10,2) DEFAULT 0.00,
  `fecha_compra` timestamp NOT NULL DEFAULT current_timestamp(),
  `proveedor` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `precio_compra`
--

INSERT INTO `precio_compra` (`id_precio_compra`, `id_producto`, `cantidad`, `precio_unitario`, `transporte`, `almacenamiento`, `descripcion`, `iva_compra`, `retencion_fuente`, `fecha_compra`, `proveedor`) VALUES
(1, 1, 50, 1800000.00, 25000.00, 15000.00, 'Compra iPhone 16 Pro - Lote 001', 342000.00, 45000.00, '2025-09-02 18:35:40', 'Apple Distribuidor Colombia'),
(2, 2, 100, 28000.00, 5000.00, 2000.00, 'Compra Apple Watch Ultra - Lote 002', 5320.00, 700.00, '2025-09-02 18:35:40', 'Tech Import SAS'),
(3, 52, 30, 1800000.00, 40000.00, 20000.00, 'Compra Lenovo IdeaPad - Lote 003', 342000.00, 45000.00, '2025-09-02 18:35:40', 'Lenovo Colombia'),
(4, 53, 25, 8000.00, 3000.00, 1000.00, 'Compra ASUS TUF Gaming - Lote 004', 1520.00, 200.00, '2025-09-02 18:35:40', 'ASUS Direct'),
(5, 54, 80, 140000.00, 8000.00, 5000.00, 'Compra AirPods Pro - Lote 005', 26600.00, 3500.00, '2025-09-02 18:35:40', 'Apple Distribuidor Colombia'),
(6, 1, 50, 1800000.00, 25000.00, 15000.00, 'Compra iPhone 16 Pro - Lote 001', 342000.00, 45000.00, '2025-09-02 18:36:25', 'Apple Distribuidor Colombia'),
(7, 2, 100, 28000.00, 5000.00, 2000.00, 'Compra Apple Watch Ultra - Lote 002', 5320.00, 700.00, '2025-09-02 18:36:25', 'Tech Import SAS'),
(8, 52, 30, 1800000.00, 40000.00, 20000.00, 'Compra Lenovo IdeaPad - Lote 003', 342000.00, 45000.00, '2025-09-02 18:36:25', 'Lenovo Colombia'),
(9, 53, 25, 8000.00, 3000.00, 1000.00, 'Compra ASUS TUF Gaming - Lote 004', 1520.00, 200.00, '2025-09-02 18:36:25', 'ASUS Direct'),
(10, 54, 80, 140000.00, 8000.00, 5000.00, 'Compra AirPods Pro - Lote 005', 26600.00, 3500.00, '2025-09-02 18:36:25', 'Apple Distribuidor Colombia');

--
-- Disparadores `precio_compra`
--
DELIMITER $$
CREATE TRIGGER `inventario_compra` AFTER INSERT ON `precio_compra` FOR EACH ROW BEGIN
    UPDATE `producto` SET `cantidad` = `cantidad` + NEW.cantidad, `precio_costo` = NEW.precio_unitario 
    WHERE `idProducto` = NEW.id_producto;
    INSERT INTO `movimientos_inventario` (`id_producto`, `tipo`, `cantidad`, `motivo`) 
    VALUES (NEW.id_producto, 'entrada', NEW.cantidad, 'compra');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `idProducto` int(11) NOT NULL,
  `nombreProducto` varchar(100) NOT NULL,
  `imagen` varchar(100) NOT NULL,
  `valor` decimal(10,2) NOT NULL COMMENT 'Precio de venta (sin IVA)',
  `cantidad` int(11) NOT NULL DEFAULT 0,
  `informacion` text DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1,
  `porcentaje_impuesto` decimal(5,2) DEFAULT 19.00 COMMENT 'Porcentaje de IVA aplicable al producto',
  `precio_costo` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Precio de compra al proveedor',
  `stock_minimo` int(11) DEFAULT 10 COMMENT 'Stock mÃ­nimo para alertas'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idProducto`, `nombreProducto`, `imagen`, `valor`, `cantidad`, `informacion`, `fecha_creacion`, `activo`, `porcentaje_impuesto`, `precio_costo`, `stock_minimo`) VALUES
(1, 'iPhone 16 Pro', 'Samsung_Galaxy_S24.jpg', 2400030.00, 200, 'iPhome de 15 pulgadas, 16GB RAM, 566GB SSD', '2025-08-13 02:30:53', 1, NULL, 1800000.00, 5),
(2, 'Apple_Watch', 'Apple_Watch_Ultra.webp', 45000.00, 300, 'Reloj inteligente resistente para deportes extremos', '2025-08-13 02:30:53', 1, 19.00, 28000.00, 15),
(52, 'Portatil LENOVO Intel Core i5 12450H RAM 8 GB 512 GB SSD IdeaPad Slim 3', 'Computador-LENOVO-IdeaPad-Slim-3-Intel-Core-i5-8-Nucleos-8-GB-RAM-512-GB-SSD-3446422_a.webp', 2500000.00, 160, 'Intel-Core-i5-8-Nucleos-8-GB-RAM-512-GB-SSD-3446422', '2025-08-26 19:09:47', 1, 19.00, 1800000.00, 3),
(53, 'Computador PortÃ¡til Gamer ASUS TUF F 16\" Pulgadas FX607VJ', 'PortÃ¡til Lenovo IdeaPad 15AMN Ryzen 5 7520U RAM 8GB 256GB SSD 15,6.jpg', 12112.00, 150, 'asSAASASAS', '2025-08-26 19:21:50', 1, 19.00, 8000.00, 3),
(54, 'AirPods_Pro', 'AirPods_Pro.png', 200000.00, 260, 'Con silenciador de auidio', '2025-08-26 21:30:40', 0, 19.00, 140000.00, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `retenciones`
--

CREATE TABLE `retenciones` (
  `id_retencion` int(11) NOT NULL,
  `tipo_cliente` varchar(20) NOT NULL,
  `monto_minimo` decimal(12,2) NOT NULL COMMENT 'Monto mÃ­nimo para aplicar retenciÃ³n',
  `porcentaje` decimal(5,2) NOT NULL COMMENT 'Porcentaje de retenciÃ³n',
  `concepto` varchar(100) NOT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `retenciones`
--

INSERT INTO `retenciones` (`id_retencion`, `tipo_cliente`, `monto_minimo`, `porcentaje`, `concepto`, `activo`) VALUES
(1, 'empresa', 1000000.00, 2.50, 'RetenciÃ³n en la fuente - Compras generales', 1),
(2, 'empresa', 5000000.00, 3.50, 'RetenciÃ³n en la fuente - Compras mayores', 1),
(3, 'persona', 2000000.00, 1.00, 'RetenciÃ³n en la fuente - Personas naturales', 1),
(4, 'empresa', 800000.00, 2.00, 'RetenciÃ³n comercio electrÃ³nico', 1),
(5, 'persona', 3000000.00, 1.50, 'RetenciÃ³n personas naturales - montos altos', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `cedula` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` text NOT NULL,
  `direccion` text NOT NULL,
  `telefono` text NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` varchar(50) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `cedula`, `nombre`, `correo`, `direccion`, `telefono`, `password`, `rol`, `fecha_creacion`, `activo`) VALUES
(1, '12345678', 'Juan PÃ©rez', 'JuanPerez@email.com', 'Calle 14 No 10-13', '+573175527281', 'Juan', 'admin', '2025-08-13 02:30:53', 1),
(2, '87654321', 'MarÃ­a GarcÃ­a', 'maria.garcia@email.com', 'Calle 14 No 10-13', '+573175527281', 'MarÃ­a', 'cliente', '2025-08-13 02:30:53', 1),
(4, '1096063677', 'Marta GarcÃ­a', 'marta.garcia@email.com', 'Calle 14 No 10-13', '+573175527281', 'Marta', 'cliente', '2025-08-14 18:01:30', 1),
(5, '1096063633', 'Brayan David Herrera Barajas', 'bherrerabarajs@gmail.com', 'Calle 14 No 10-13', '+573175527281', 'Laurayluis87', 'admin', '2025-08-16 16:40:50', 1),
(10, '1096063688', 'Laura ', 'lestevez747@gmail.com', 'Calle 14 No 10-13', '+573175527281', '123456789', 'cliente', '2025-08-19 00:23:36', 1),
(12, '1096063366', 'Juan Camilo', 'Juan@gmail.com', 'Calle 14 No 10-13', '3022762284', '123456789', 'cliente', '2025-08-19 20:41:58', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `utilidades_mes`
--

CREATE TABLE `utilidades_mes` (
  `id_utilidad` int(11) NOT NULL,
  `periodo` date NOT NULL COMMENT 'Mes (YYYY-MM-01)',
  `total_ventas` decimal(12,2) DEFAULT 0.00,
  `total_costos` decimal(12,2) DEFAULT 0.00 COMMENT 'Costo de productos vendidos',
  `total_gastos_fijos` decimal(12,2) DEFAULT 0.00 COMMENT 'Arriendo, servicios, etc',
  `total_nomina` decimal(12,2) DEFAULT 0.00 COMMENT 'Sueldos del personal',
  `total_gastos` decimal(12,2) GENERATED ALWAYS AS (`total_gastos_fijos` + `total_nomina`) VIRTUAL COMMENT 'Gastos totales',
  `fecha_calculo` timestamp NOT NULL DEFAULT current_timestamp(),
  `utilidad_neta` decimal(12,2) GENERATED ALWAYS AS (`total_ventas` - (`total_costos` + `total_gastos_fijos` + `total_nomina`)) VIRTUAL COMMENT 'Utilidad = Ventas - (Costos + Gastos)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `utilidades_mes`
--

INSERT INTO `utilidades_mes` (`id_utilidad`, `periodo`, `total_ventas`, `total_costos`, `total_gastos_fijos`, `total_nomina`, `fecha_calculo`) VALUES
(1, '2025-07-01', 15000000.00, 8500000.00, 3210000.00, 0.00, '2025-09-02 18:36:25'),
(2, '2025-08-01', 18500000.00, 10200000.00, 3300000.00, 0.00, '2025-09-02 18:36:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `idVenta` int(11) NOT NULL,
  `idPedido` int(11) NOT NULL,
  `idUsuario` int(11) DEFAULT NULL,
  `monto_subtotal` decimal(10,2) NOT NULL COMMENT 'Monto antes de descuentos e impuestos',
  `descuentos` decimal(10,2) DEFAULT 0.00 COMMENT 'Monto total de descuentos',
  `impuestos` decimal(10,2) DEFAULT 0.00 COMMENT 'Monto total de impuestos',
  `monto_total` decimal(10,2) NOT NULL COMMENT 'Monto final de la venta',
  `fecha_venta` timestamp NULL DEFAULT current_timestamp(),
  `estado_venta` varchar(50) DEFAULT 'confirmada' COMMENT 'confirmada, anulada, pendiente',
  `retencion_fuente` decimal(10,2) DEFAULT 0.00 COMMENT 'RetenciÃ³n en la fuente aplicada',
  `valor_retencion_porcentaje` decimal(5,2) DEFAULT 0.00 COMMENT 'Porcentaje de retenciÃ³n aplicado',
  `monto_recibido` decimal(10,2) GENERATED ALWAYS AS (`monto_total` - `retencion_fuente`) VIRTUAL COMMENT 'Dinero realmente recibido',
  `aplica_retencion` tinyint(1) DEFAULT 0 COMMENT '1 si el cliente aplica retenciÃ³n'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`idVenta`, `idPedido`, `idUsuario`, `monto_subtotal`, `descuentos`, `impuestos`, `monto_total`, `fecha_venta`, `estado_venta`, `retencion_fuente`, `valor_retencion_porcentaje`, `aplica_retencion`) VALUES
(1, 33, 2, 99999999.99, 54200070.00, 31511920.70, 99999999.99, '2025-08-23 16:56:12', 'confirmada', 0.00, 0.00, 0),
(8, 31, 2, 900000.00, 180000.00, 138510.00, 963510.00, '2025-08-23 17:31:29', 'confirmada', 0.00, 0.00, 0),
(31, 33, 2, 5000000.00, 0.00, 950000.00, 5950000.00, '2025-09-02 18:36:25', 'confirmada', 148750.00, 2.50, 1);

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
-- Indices de la tabla `gastos_fijos`
--
ALTER TABLE `gastos_fijos`
  ADD PRIMARY KEY (`id_gastos`),
  ADD UNIQUE KEY `uk_gastos_periodo` (`periodo`);

--
-- Indices de la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  ADD PRIMARY KEY (`id_movimiento`),
  ADD KEY `id_producto` (`id_producto`);

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
-- Indices de la tabla `precio_compra`
--
ALTER TABLE `precio_compra`
  ADD PRIMARY KEY (`id_precio_compra`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`idProducto`),
  ADD KEY `idx_producto_nombre` (`nombreProducto`),
  ADD KEY `idx_producto_activo` (`activo`);

--
-- Indices de la tabla `retenciones`
--
ALTER TABLE `retenciones`
  ADD PRIMARY KEY (`id_retencion`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD KEY `idx_usuario_cedula` (`cedula`),
  ADD KEY `idx_usuario_rol` (`rol`);

--
-- Indices de la tabla `utilidades_mes`
--
ALTER TABLE `utilidades_mes`
  ADD PRIMARY KEY (`id_utilidad`),
  ADD UNIQUE KEY `uk_utilidad_periodo` (`periodo`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`idVenta`),
  ADD KEY `idx_ventas_fecha` (`fecha_venta`),
  ADD KEY `idx_ventas_usuario` (`idUsuario`),
  ADD KEY `Ventas_ibfk_1` (`idPedido`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `detallepedido`
--
ALTER TABLE `detallepedido`
  MODIFY `idDetallePedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT de la tabla `formaspago`
--
ALTER TABLE `formaspago`
  MODIFY `idFormaPago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `gastos_fijos`
--
ALTER TABLE `gastos_fijos`
  MODIFY `id_gastos` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  MODIFY `id_movimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `idPago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `idPedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT de la tabla `precio_compra`
--
ALTER TABLE `precio_compra`
  MODIFY `id_precio_compra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idProducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `retenciones`
--
ALTER TABLE `retenciones`
  MODIFY `id_retencion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `utilidades_mes`
--
ALTER TABLE `utilidades_mes`
  MODIFY `id_utilidad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `idVenta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

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
-- Filtros para la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  ADD CONSTRAINT `movimientos_inventario_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`idProducto`) ON DELETE CASCADE;

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

--
-- Filtros para la tabla `precio_compra`
--
ALTER TABLE `precio_compra`
  ADD CONSTRAINT `precio_compra_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`idProducto`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `Ventas_ibfk_1` FOREIGN KEY (`idPedido`) REFERENCES `pedidos` (`idPedido`) ON DELETE CASCADE,
  ADD CONSTRAINT `Ventas_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
