-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost:3306
-- Время создания: Июн 20 2022 г., 12:22
-- Версия сервера: 8.0.29-0ubuntu0.20.04.3
-- Версия PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `magazin`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`osp`@`localhost` PROCEDURE `TotalDemand` (IN `iddem` VARCHAR(64))  MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Обновление сумм заказа и подтверждения по параметру Код заголовк'
UPDATE demandsHead SET
 demandsHead.totalDemand = (SELECT SUM(demandsLine.totalDemand) FROM demandsLine WHERE demandsLine.headid = iddem),
 demandsHead.totalConfirm =(SELECT SUM(demandsLine.totalConfirm) FROM demandsLine WHERE demandsLine.headid = iddem)
WHERE demandsHead.id = iddem$$

CREATE DEFINER=`osp`@`localhost` PROCEDURE `TotalTurnover` (IN `idturn` VARCHAR(64))  MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Обновление сумм движения товара по параметру Код заголовка'
UPDATE turnoversHead SET
  turnoversHead.totalin  =(SELECT SUM(turnoversLine.totalin) FROM     turnoversLine WHERE turnoversLine.headid = idturn),
  turnoversHead.totalout  =(SELECT SUM(turnoversLine.totalout) FROM     turnoversLine WHERE turnoversLine.headid = idturn)
WHERE turnoversHead.id = idturn$$

--
-- Функции
--
CREATE DEFINER=`osp`@`localhost` FUNCTION `beginperiod` () RETURNS DATE NO SQL
    DETERMINISTIC
return @beginperiod$$

CREATE DEFINER=`osp`@`localhost` FUNCTION `endperiod` () RETURNS DATE NO SQL
    DETERMINISTIC
return @endperiod$$

CREATE DEFINER=`osp`@`localhost` FUNCTION `theuserid` () RETURNS VARCHAR(65) CHARSET utf8mb4 NO SQL
RETURN @theuserid$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `demandsHead`
--

CREATE TABLE `demandsHead` (
  `id` varchar(64) NOT NULL COMMENT 'код шапки заказа',
  `docdate` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время заказа',
  `docnumber` int DEFAULT NULL COMMENT 'Номер документа',
  `userid` varchar(64) DEFAULT NULL COMMENT 'код пользователя',
  `totalDemand` decimal(12,2) DEFAULT NULL COMMENT 'Заказ на сумму',
  `totalConfirm` decimal(12,2) DEFAULT NULL COMMENT 'Подтверждено на сумму',
  `comment` text COMMENT 'Комментарий',
  `opened` tinyint(1) DEFAULT '1' COMMENT 'Заказ открыт',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Создан',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Изменен'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `demandsHead`
--

INSERT INTO `demandsHead` (`id`, `docdate`, `docnumber`, `userid`, `totalDemand`, `totalConfirm`, `comment`, `opened`, `createdAt`, `updatedAt`) VALUES
('0d98cc86-6a4c-413e-bfae-8292ed7a8dc5', '2022-05-29 16:41:08', 29, '9f0d113e-e75a-4abc-9917-b35168defca1', '96.00', '96.00', '', 1, '2022-05-29 19:41:08', '2022-05-29 19:41:08'),
('110b8eec-f9cf-4e4e-83d9-6fb13777fb01', '2022-04-17 18:06:00', 22000013, '23a40e6e-ac2f-40f2-924a-1d9f402e764d', '11.75', '11.75', 'test VUE', 0, '2022-04-17 18:06:36', '2022-04-18 20:29:08'),
('25a01e70-fcf7-420c-bf35-3bf8a5291061', '2022-05-15 00:00:00', 32, '9f0d113e-e75a-4abc-9917-b35168defca1', '65.00', '0.00', 'мій тест', 1, '2022-04-22 20:53:33', '2022-05-29 15:56:02'),
('2d66f3d6-c9e9-4d31-8b8a-e01f145ce732', '2022-04-17 17:31:00', 22000012, '23a40e6e-ac2f-40f2-924a-1d9f402e764d', '70.00', '70.00', 'Перевірка створення замовлення через АПІ', 0, '2022-04-17 17:32:21', '2022-04-17 18:09:35'),
('365f0668-6c0a-11ec-bcad-6cf049dd8488', '2022-01-01 22:25:00', 22000001, '488df84a-6c09-11ec-bcad-6cf049dd8488', '506.00', '487.00', 'тренуємось створювати замовлення', 1, '2022-01-02 22:26:05', '2022-05-15 14:33:47'),
('37e8a242-f2e4-4fd0-ab38-57d9969ca3f6', '2022-05-29 17:46:00', 31, '9f0d113e-e75a-4abc-9917-b35168defca1', '160.00', '160.00', 'мій тест', 1, '2022-05-29 20:46:15', '2022-05-29 20:46:15'),
('39354dc5-6c15-11ec-bcad-6cf049dd8488', '2022-05-15 00:00:00', 2, '02e0916f-db8c-47fb-9802-4f27bd7929ba', '249.18', '255.80', 'test VUE', 1, '2022-01-02 23:44:55', '2022-05-29 15:54:54'),
('43005210-9658-4053-8302-4cfc1633ff57', '2022-01-10 00:00:00', 22000007, '488df84a-6c09-11ec-bcad-6cf049dd8488', '2006.00', '2056.00', 'Перевірка створення замовлення через АПІ', 1, '2022-01-11 23:16:00', '2022-05-23 13:46:04'),
('5af1936e-6c15-11ec-bcad-6cf049dd8488', '2022-01-22 00:00:00', 22000002, '488df84a-6c09-11ec-bcad-6cf049dd8488', '236.90', '520.00', 'ПЕРЕВІРКА ЗМІН ЧЕРЕЗ АПІ', 1, '2022-01-02 23:45:51', '2022-04-17 11:51:42'),
('5f920b37-ca08-4401-9418-8f29f224a7f0', '2022-01-10 00:00:00', 22000009, '638c3038-da18-426b-a285-a7953c41b88d', '1090.00', '1140.00', 'Перевірка створення замовлення через АПІ', 1, '2022-01-11 23:18:04', '2022-04-06 20:41:41'),
('9691d052-a97b-470e-a724-b347f3f5f4ee', '2022-04-12 15:36:00', 7, '02e0916f-db8c-47fb-9802-4f27bd7929ba', '165.00', '0.00', 'The test', 1, '2022-04-21 20:37:35', '2022-04-21 21:37:50'),
('a70fb2d4-9607-4b05-b66d-5e7a70056891', '2022-01-10 00:00:00', 22000003, '488df84a-6c09-11ec-bcad-6cf049dd8488', '770.00', '680.00', 'test VUE', 0, '2022-01-11 22:56:21', '2022-04-06 20:45:07'),
('b34ac4e5-3b7b-4d5c-9583-2787b0ff8fe8', '2022-04-14 17:08:00', 5, '488df84a-6c09-11ec-bcad-6cf049dd8488', '236.36', '0.00', 'test VUE', 1, '2022-04-21 20:10:17', '2022-04-21 20:10:17'),
('cd356b5a-fec1-4b45-9626-9d2e5a3d028f', '2022-05-29 16:42:17', 30, '638c3038-da18-426b-a285-a7953c41b88d', '102.54', '102.54', '', 1, '2022-05-29 19:42:17', '2022-05-29 19:42:17'),
('dea60c00-6606-4ffd-b689-370355fc47f4', '2022-01-19 00:00:00', 22000005, '9f0d113e-e75a-4abc-9917-b35168defca1', '1270.00', '1499.95', 'test VUE', 0, '2022-01-11 23:13:47', '2022-05-07 07:27:49'),
('fd52e0cb-bb11-4125-9122-1a8286e2c3ef', '2022-03-30 16:12:00', 22000011, '02e0916f-db8c-47fb-9802-4f27bd7929ba', '136.72', '136.72', 'test VUE', 1, '2022-04-05 22:12:51', '2022-04-05 22:12:51');

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `demandsHeadlist`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `demandsHeadlist` (
`balance` decimal(57,2)
,`comment` text
,`createdAt` datetime
,`deliveryaddress` varchar(256)
,`docdate` varchar(21)
,`docnumber` int
,`email` varchar(128)
,`fullname` varchar(128)
,`id` varchar(64)
,`opened` tinyint(1)
,`phonenumber` varchar(32)
,`totalConfirm` decimal(12,2)
,`totalDemand` decimal(12,2)
,`updatedAt` datetime
,`userid` varchar(64)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `demandsLastNumber`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `demandsLastNumber` (
`docnumber` int
);

-- --------------------------------------------------------

--
-- Структура таблицы `demandsLine`
--

CREATE TABLE `demandsLine` (
  `id` varchar(64) NOT NULL COMMENT 'код строки заказа',
  `headid` varchar(64) NOT NULL COMMENT 'код шапки заказа',
  `goodsid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Код товара',
  `quantityDemand` decimal(12,3) DEFAULT '0.000' COMMENT 'Количество заказано',
  `priceDemand` decimal(12,2) DEFAULT '0.00' COMMENT 'Цена заказа',
  `totalDemand` decimal(12,2) DEFAULT '0.00' COMMENT 'Стоимость заказа',
  `quantityConfirm` decimal(12,3) DEFAULT '0.000' COMMENT 'Количество подтверждено',
  `priceConfirm` decimal(12,2) DEFAULT '0.00' COMMENT 'Цена подтверждена',
  `totalConfirm` decimal(12,2) DEFAULT '0.00' COMMENT 'Стоимость подтверждена',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Создано',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Изменено'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Табличная часть заказов';

--
-- Дамп данных таблицы `demandsLine`
--

INSERT INTO `demandsLine` (`id`, `headid`, `goodsid`, `quantityDemand`, `priceDemand`, `totalDemand`, `quantityConfirm`, `priceConfirm`, `totalConfirm`, `createdAt`) VALUES
('00751bee-822c-4d8c-bf99-4fce603952e4', '43005210-9658-4053-8302-4cfc1633ff57', 'f56da4fc-6c09-11ec-bcad-6cf049dd8488', '4.000', '85.00', '340.00', '4.000', '85.00', '340.00', '2022-01-11 23:16:00'),
('01decd5a-03ce-47a6-b0bf-08a6782b09f2', '39354dc5-6c15-11ec-bcad-6cf049dd8488', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '1.000', '34.18', '34.18', '1.000', '31.00', '31.00', '2022-04-06 20:11:33'),
('01fbcf06-cba8-4560-a59d-84d10b23879d', 'dea60c00-6606-4ffd-b689-370355fc47f4', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '6.000', '30.00', '180.00', '20.000', '15.00', '300.00', '2022-01-11 23:13:47'),
('151f030a-4133-4e6d-a4bf-487cc56ab0a8', 'b34ac4e5-3b7b-4d5c-9583-2787b0ff8fe8', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '2.000', '34.18', '68.36', NULL, NULL, NULL, '2022-04-21 20:10:17'),
('25c11974-e623-441f-9c29-4c2401fe0296', '43005210-9658-4053-8302-4cfc1633ff57', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '6.000', '30.00', '180.00', '6.000', '30.00', '180.00', '2022-01-11 23:16:00'),
('318d5b4e-80b5-41dd-b971-518fb16e9f12', 'dea60c00-6606-4ffd-b689-370355fc47f4', 'f56da4fc-6c09-11ec-bcad-6cf049dd8488', '4.000', '85.00', '340.00', '20.000', '20.00', '400.00', '2022-01-11 23:13:47'),
('45c1e9ef-e8a8-465e-8272-d30a3ab76ab7', 'a70fb2d4-9607-4b05-b66d-5e7a70056891', '47d55469-d898-4ec8-bbf1-60120fe6554d', '13.000', '42.31', '550.00', '12.000', '50.00', '600.00', '2022-01-11 22:56:21'),
('4b063223-5b8b-4881-bb44-a095a5d65bbe', 'a70fb2d4-9607-4b05-b66d-5e7a70056891', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '6.000', '13.33', '80.00', '6.000', '13.33', '80.00', '2022-01-11 22:56:21'),
('4e4c19fc-b989-4e55-9a27-aff0926e7826', 'fd52e0cb-bb11-4125-9122-1a8286e2c3ef', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '4.000', '34.18', '136.72', '4.000', '34.18', '136.72', '2022-04-05 22:12:51'),
('5ba1181d-9b85-435b-a8b0-6ecd63e28278', '5af1936e-6c15-11ec-bcad-6cf049dd8488', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '5.000', '34.18', '170.90', '0.000', '0.00', '0.00', '2022-04-17 11:51:42'),
('662db9f3-6c13-11ec-bcad-6cf049dd8488', '365f0668-6c0a-11ec-bcad-6cf049dd8488', 'f56d7c3d-6c09-11ec-bcad-6cf049dd8488', '13.000', '22.00', '286.00', '12.000', '21.00', '252.00', '2022-01-02 23:31:51'),
('66e86fbb-f14f-460f-bf24-3101f15fff3b', '5f920b37-ca08-4401-9418-8f29f224a7f0', 'f56da4fc-6c09-11ec-bcad-6cf049dd8488', '4.000', '85.00', '340.00', '4.000', '85.00', '340.00', '2022-01-11 23:18:05'),
('69fb11c1-d9d4-4c21-8a52-76712dc5796b', 'a70fb2d4-9607-4b05-b66d-5e7a70056891', 'f56da4fc-6c09-11ec-bcad-6cf049dd8488', '4.000', '35.00', '140.00', '0.000', '0.00', '0.00', '2022-01-11 22:56:21'),
('6a9257ac-6c16-11ec-bcad-6cf049dd8488', '5af1936e-6c15-11ec-bcad-6cf049dd8488', 'f56d7c3d-6c09-11ec-bcad-6cf049dd8488', '13.000', '4.00', '52.00', '19.000', '27.37', '520.00', '2022-01-02 23:53:27'),
('72d764d4-ceb4-4ee2-b231-c6116a4f4c8f', '9691d052-a97b-470e-a724-b347f3f5f4ee', '47d55469-d898-4ec8-bbf1-60120fe6554d', '15.000', '11.00', '165.00', '0.000', '0.00', '0.00', '2022-04-21 20:37:35'),
('7b79d3ff-6cd1-4e39-94e9-abd4798b7ad8', '43005210-9658-4053-8302-4cfc1633ff57', '8c4bf010-2b49-4d3d-9ca7-7990d1969aa9', '23.000', '32.00', '736.00', '23.000', '32.00', '736.00', '2022-05-23 13:46:04'),
('7bc3507c-178c-42d0-b6a0-c5708cdcb3a9', '110b8eec-f9cf-4e4e-83d9-6fb13777fb01', 'f56d7c3d-6c09-11ec-bcad-6cf049dd8488', '5.000', '2.35', '11.75', '5.000', '2.35', '11.75', '2022-04-18 20:28:11'),
('7e5ce9cc-544d-411d-b4e4-72a5a4a74174', '5f920b37-ca08-4401-9418-8f29f224a7f0', '47d55469-d898-4ec8-bbf1-60120fe6554d', '13.000', '57.69', '750.00', '12.000', '66.67', '800.00', '2022-01-11 23:18:05'),
('7e93ac33-1194-424e-9718-acb9cd6aafdd', '2d66f3d6-c9e9-4d31-8b8a-e01f145ce732', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '10.000', '7.00', '70.00', '10.000', '7.00', '70.00', '2022-04-17 17:32:21'),
('7e9b2f16-ef2f-4909-9e32-94832ead0eb6', '39354dc5-6c15-11ec-bcad-6cf049dd8488', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '5.000', '7.00', '35.00', '7.000', '6.40', '44.80', '2022-04-06 20:11:33'),
('8246d23b-3c78-4f14-a206-bc61f5446034', '25a01e70-fcf7-420c-bf35-3bf8a5291061', '47d55469-d898-4ec8-bbf1-60120fe6554d', '4.000', '11.00', '44.00', '0.000', '0.00', '0.00', '2022-04-22 20:53:33'),
('8d183d9c-d548-407c-8600-97130440bfe5', 'b34ac4e5-3b7b-4d5c-9583-2787b0ff8fe8', 'f56da4fc-6c09-11ec-bcad-6cf049dd8488', '7.000', '24.00', '168.00', '0.000', '0.00', '0.00', '2022-04-21 20:10:17'),
('8e8ff9cc-6c0b-11ec-bcad-6cf049dd8488', '365f0668-6c0a-11ec-bcad-6cf049dd8488', 'f56d7c3d-6c09-11ec-bcad-6cf049dd8488', '6.000', '13.33', '80.00', '6.000', '14.17', '85.00', '2022-01-02 22:35:43'),
('9f62c336-d164-494f-b1f7-1e0265bbfce6', 'dea60c00-6606-4ffd-b689-370355fc47f4', '47d55469-d898-4ec8-bbf1-60120fe6554d', '13.000', '57.69', '750.00', '15.000', '53.33', '799.95', '2022-01-12 21:14:05'),
('ad33fd62-6c15-11ec-bcad-6cf049dd8488', '39354dc5-6c15-11ec-bcad-6cf049dd8488', 'f56da4fc-6c09-11ec-bcad-6cf049dd8488', '45.000', '4.00', '180.00', '45.000', '4.00', '180.00', '2022-01-02 23:48:09'),
('b157fadb-7a7e-46f6-aad7-1ee82bcfb8db', '43005210-9658-4053-8302-4cfc1633ff57', '47d55469-d898-4ec8-bbf1-60120fe6554d', '13.000', '57.69', '750.00', '12.000', '66.67', '800.00', '2022-01-11 23:16:00'),
('b491ca9b-686f-4b77-8d6c-5703a602ffa8', '37e8a242-f2e4-4fd0-ab38-57d9969ca3f6', '8c4bf010-2b49-4d3d-9ca7-7990d1969aa9', '5.000', '32.00', '160.00', '5.000', '32.00', '160.00', '2022-05-29 20:46:15'),
('c7ed1a83-7f6d-4fd0-8caa-89b85e148d9c', '25a01e70-fcf7-420c-bf35-3bf8a5291061', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '3.000', '7.00', '21.00', '0.000', '0.00', '0.00', '2022-04-22 20:53:33'),
('cd0cb869-6c0b-11ec-bcad-6cf049dd8488', '365f0668-6c0a-11ec-bcad-6cf049dd8488', 'f56da4fc-6c09-11ec-bcad-6cf049dd8488', '4.000', '35.00', '140.00', '4.000', '37.50', '150.00', '2022-01-02 22:37:28'),
('cf02d352-58b5-41d0-a929-26d7064f80d7', '5af1936e-6c15-11ec-bcad-6cf049dd8488', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '2.000', '7.00', '14.00', '0.000', '0.00', '0.00', '2022-04-17 11:50:50'),
('e99a41b7-e6c7-4e78-ab51-2db8b53c376f', 'cd356b5a-fec1-4b45-9626-9d2e5a3d028f', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '3.000', '34.18', '102.54', '3.000', '34.18', '102.54', '2022-05-29 19:42:17'),
('fa18c023-c1fc-4d77-83cb-a90e080e210d', '0d98cc86-6a4c-413e-bfae-8292ed7a8dc5', '8c4bf010-2b49-4d3d-9ca7-7990d1969aa9', '3.000', '32.00', '96.00', '3.000', '32.00', '96.00', '2022-05-29 19:41:08');

--
-- Триггеры `demandsLine`
--
DELIMITER $$
CREATE TRIGGER `after_delete_demand` AFTER DELETE ON `demandsLine` FOR EACH ROW CALL TotalDemand(OLD.headid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_demand` AFTER INSERT ON `demandsLine` FOR EACH ROW CALL TotalDemand(NEW.headid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_demand` AFTER UPDATE ON `demandsLine` FOR EACH ROW CALL TotalDemand(NEW.headid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `chk_demandline_insert` BEFORE INSERT ON `demandsLine` FOR EACH ROW BEGIN
 IF NEW.totalDemand = 0 
 THEN
    SET NEW.totalDemand = NEW.quantityDemand*NEW.priceDemand;
 ELSE 
    SET NEW.priceDemand =  NEW.totalDemand/NEW.quantityDemand;
 END IF;
 IF NEW.totalConfirm = 0 
 THEN
    SET NEW.totalConfirm = NEW.quantityConfirm*NEW.priceConfirm;
 ELSE 
    SET NEW.priceConfirm =  NEW.totalConfirm/NEW.quantityConfirm;
 END IF;
 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `chk_demandline_update` BEFORE UPDATE ON `demandsLine` FOR EACH ROW BEGIN
 IF NEW.totalDemand = 0 
 THEN
    SET NEW.totalDemand = NEW.quantityDemand*NEW.priceDemand;
 ELSE 
    SET NEW.priceDemand =  NEW.totalDemand/NEW.quantityDemand;
 END IF;
 IF NEW.totalConfirm = 0 
 THEN
    SET NEW.totalConfirm = NEW.quantityConfirm*NEW.priceConfirm;
 ELSE 
    SET NEW.priceConfirm =  NEW.totalConfirm/NEW.quantityConfirm;
 END IF;
 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `demandsLinelist`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `demandsLinelist` (
`createdAt` datetime
,`currentprice` decimal(12,2)
,`goods` varchar(256)
,`goodsid` varchar(64)
,`headid` varchar(64)
,`id` varchar(64)
,`measure` varchar(64)
,`priceConfirm` decimal(12,2)
,`priceDemand` decimal(12,2)
,`quantityConfirm` decimal(12,3)
,`quantityDemand` decimal(12,3)
,`remainder` decimal(35,3)
,`reserved` decimal(34,3)
,`totalConfirm` decimal(12,2)
,`totalDemand` decimal(12,2)
,`updatedAt` datetime
);

-- --------------------------------------------------------

--
-- Структура таблицы `goods`
--

CREATE TABLE `goods` (
  `id` varchar(64) NOT NULL COMMENT 'код товара',
  `groupname` varchar(128) DEFAULT NULL COMMENT 'Группа товаров',
  `goods` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Название товара',
  `description` text COMMENT 'Описание товара',
  `picture` varchar(256) DEFAULT NULL COMMENT 'Изображение товара',
  `measure` varchar(64) DEFAULT NULL COMMENT 'едница измерения',
  `price` decimal(12,2) DEFAULT NULL COMMENT 'Цена',
  `barcode` varchar(32) DEFAULT NULL COMMENT 'штрихкод',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Создано',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Изменено'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Таблица списка товаров';

--
-- Дамп данных таблицы `goods`
--

INSERT INTO `goods` (`id`, `groupname`, `goods`, `description`, `picture`, `measure`, `price`, `barcode`, `createdAt`) VALUES
('47d55469-d898-4ec8-bbf1-60120fe6554d', 'Випічка', 'Чебурек зі справжнім м\'ясом', 'Добре смакує для обідньої перерви', NULL, 'шт.', '11.00', '43356732', '2022-01-09 13:18:32'),
('8c4bf010-2b49-4d3d-9ca7-7990d1969aa9', 'Випічка', 'Яблуневий струдель', 'Смачний струдель\nначинений яблуками для вечірнього чаю.', '', 'шт.', '32.00', '111223344', '2022-03-21 19:18:10'),
('bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', 'Напої', 'Чай чорний', 'Чай чорний крепкий без лімону.', '', 'склянка', '7.00', '121212121', '2022-03-21 19:26:33'),
('f56d7c3d-6c09-11ec-bcad-6cf049dd8488', 'Випічка', 'Пиріжок з горохом та чесноком', 'Дуже смачнющий пиріжечок \nдля справжніх поціновувачів', NULL, 'шт.', '2.35', '3223322', '2022-01-02 22:24:16'),
('f56da4fc-6c09-11ec-bcad-6cf049dd8488', 'Випічка', 'Пиріжок з яблукам', 'Пиріжечок з свіженькими яблучками', NULL, 'шт.', '24.00', '6543433', '2022-01-02 22:24:16'),
('fe975478-5b1c-4e4c-b857-e9c16ae11ad7', 'Випічка', 'Печиво крекер солоне', 'До чаю', NULL, 'кг.', '34.18', '543667786', '2022-01-09 13:21:30');

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `goodslist`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `goodslist` (
`barcode` varchar(32)
,`createdAt` datetime
,`description` text
,`goods` varchar(256)
,`groupname` varchar(128)
,`id` varchar(64)
,`measure` varchar(64)
,`picture` varchar(256)
,`price` decimal(12,2)
,`remainder` decimal(35,3)
,`reserved` decimal(34,3)
,`updatedAt` datetime
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `moneyPeriod`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `moneyPeriod` (
`beforemoney` decimal(13,2)
,`docdate` varchar(21)
,`docid` varchar(64)
,`docnumber` bigint
,`doctype` varchar(8)
,`endmoney` decimal(13,2)
,`fullname` varchar(128)
,`inpay` decimal(12,2)
,`outpay` decimal(12,2)
,`totalin` decimal(12,2)
,`totalout` decimal(12,2)
,`userid` varchar(64)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `moneySumPeriod`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `moneySumPeriod` (
`beforemoney` decimal(35,2)
,`endmoney` decimal(35,2)
,`fullname` varchar(128)
,`inpay` decimal(34,2)
,`outpay` decimal(34,2)
,`totalin` decimal(34,2)
,`totalout` decimal(34,2)
,`userid` varchar(64)
);

-- --------------------------------------------------------

--
-- Структура таблицы `payments`
--

CREATE TABLE `payments` (
  `id` varchar(64) NOT NULL COMMENT 'код записи оплаты',
  `docdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата документа',
  `userid` varchar(64) DEFAULT NULL COMMENT 'Код клиента',
  `inpay` decimal(12,2) DEFAULT '0.00' COMMENT 'Получено денег',
  `outpay` decimal(12,2) DEFAULT '0.00' COMMENT 'Выдано денег',
  `comment` text COMMENT 'Комментарий',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Создан',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Изменен'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `payments`
--

INSERT INTO `payments` (`id`, `docdate`, `userid`, `inpay`, `outpay`, `comment`, `createdAt`) VALUES
('06e1a7c5-38c5-4409-937f-94d27e17230d', '2022-03-17 14:28:00', '108795c0-6c63-11ec-a47c-6cf049dd8488', '0.00', '2345.00', 'Оплата постачальнику', '2022-03-26 20:34:03'),
('22fed502-d113-45a8-94a7-83d83d0e1990', '2022-03-03 14:27:00', '638c3038-da18-426b-a285-a7953c41b88d', '21111.00', '0.00', 'оплата клиентом', '2022-03-26 21:41:57'),
('2407ee86-beb6-4aa0-9c46-05b25f7e173b', '2022-04-17 10:33:00', '9f0d113e-e75a-4abc-9917-b35168defca1', '5100.00', '0.00', 'Оплата за товари', '2022-04-17 13:34:24'),
('47338581-d861-4872-a551-c471f3240546', '2022-03-18 16:45:00', '9f0d113e-e75a-4abc-9917-b35168defca1', '1234.21', '0.00', 'оплата клиентом', '2022-03-27 17:45:42'),
('5ed5b683-6438-461a-be95-84c186e89528', '2022-04-09 15:13:00', '23a40e6e-ac2f-40f2-924a-1d9f402e764d', '18000.00', '0.00', 'оплата клиентом', '2022-04-17 18:14:02'),
('8b32a4cf-bc5a-4f36-8ee2-25f3b9ef2278', '2022-04-04 09:11:00', '488df84a-6c09-11ec-bcad-6cf049dd8488', '7000.00', '0.00', 'оплата клиентом', '2022-04-21 20:12:06'),
('8b416d9d-71d2-48c0-b1dd-17ee6c1ed0e2', '2022-05-29 11:10:00', '9f0d113e-e75a-4abc-9917-b35168defca1', '5225.00', '0.00', 'test', '2022-05-29 17:10:51'),
('baffc6ad-b776-4dd4-95f1-a681163bd407', '2022-05-29 13:49:58', '9f0d113e-e75a-4abc-9917-b35168defca1', '345.00', '0.00', 'test', '2022-05-29 19:49:58'),
('f4f0c693-6c9a-11ec-a47c-6cf049dd8488', '2022-03-19 16:31:00', '108795c0-6c63-11ec-a47c-6cf049dd8488', '0.00', '25000.00', 'Оплата постачальнику', '2022-01-03 15:42:13'),
('f4f0e74d-6c9a-11ec-a47c-6cf049dd8488', '2022-01-02 22:00:00', '02e0916f-db8c-47fb-9802-4f27bd7929ba', '1900.00', '0.00', 'оплата клиентом', '2022-01-03 15:42:13'),
('fd8c729a-acca-11ec-afa1-6cf049dd8488', '2022-03-15 07:08:00', '9f0d113e-e75a-4abc-9917-b35168defca1', '2000.00', '0.00', 'Оплата за товари', '2022-03-26 08:07:17');

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `paymentslist`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `paymentslist` (
`comment` text
,`createdAt` datetime
,`docdate` varchar(21)
,`fullname` varchar(128)
,`id` varchar(64)
,`inpay` decimal(12,2)
,`outpay` decimal(12,2)
,`updatedAt` datetime
,`userid` varchar(64)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `test`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `test` (
`beforemoney` decimal(13,2)
,`docdate` varchar(21)
,`docid` varchar(64)
,`docnumber` bigint
,`doctype` varchar(8)
,`endmoney` decimal(13,2)
,`fullname` varchar(128)
,`inpay` decimal(12,2)
,`outpay` decimal(12,2)
,`totalin` decimal(12,2)
,`totalout` decimal(12,2)
,`userid` varchar(64)
);

-- --------------------------------------------------------

--
-- Структура таблицы `turnoversHead`
--

CREATE TABLE `turnoversHead` (
  `id` varchar(64) NOT NULL COMMENT 'код шапки движения товара',
  `demandid` varchar(64) DEFAULT NULL COMMENT 'Код заказа',
  `docdate` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата документа',
  `docnumber` int DEFAULT NULL COMMENT 'Номер документа',
  `userid` varchar(64) DEFAULT NULL COMMENT 'Код пользователя',
  `totalin` decimal(12,2) DEFAULT '0.00' COMMENT 'Получено товара на сумму',
  `totalout` decimal(12,2) DEFAULT '0.00' COMMENT 'Выдано товара на сумму',
  `comment` text COMMENT 'Комментарий',
  `delivered` tinyint NOT NULL DEFAULT '0' COMMENT 'Доставлен',
  `returned` tinyint NOT NULL DEFAULT '0' COMMENT 'Возврат',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Создан',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Изменен'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Шапки перемещения товаров';

--
-- Дамп данных таблицы `turnoversHead`
--

INSERT INTO `turnoversHead` (`id`, `demandid`, `docdate`, `docnumber`, `userid`, `totalin`, `totalout`, `comment`, `delivered`, `returned`, `createdAt`) VALUES
('06392ea2-5370-4909-8a03-8527237c1a85', NULL, '2022-05-10 12:39:00', 212121, '488df84a-6c09-11ec-bcad-6cf049dd8488', '0.00', '800.00', 'Перевірка створення замовлення через АПІ', 0, 0, '2022-05-23 12:40:14'),
('0764ebd8-6c66-11ec-a47c-6cf049dd8488', NULL, '2022-01-02 09:22:00', 22000002, '488df84a-6c09-11ec-bcad-6cf049dd8488', '0.00', '2100.00', 'перша покупка', 0, 1, '2022-01-03 09:23:20'),
('5971cd20-f963-4ec1-a39c-588c862a0023', NULL, '2022-05-29 16:37:00', 28, '9f0d113e-e75a-4abc-9917-b35168defca1', '0.00', '49.00', '', 1, 0, '2022-05-29 19:37:13'),
('59fe1bf4-6a39-43ec-bd56-69fe38800e5b', NULL, '2022-05-02 06:53:00', 42, '638c3038-da18-426b-a285-a7953c41b88d', '0.00', '5804.00', '', 0, 0, '2022-05-23 06:53:53'),
('78d49cad-35a7-4554-a8a0-081400d6bd46', NULL, '2022-05-02 09:58:00', 333, '638c3038-da18-426b-a285-a7953c41b88d', '0.00', '800.00', 'Перевірка створення замовлення через АПІ', 0, 0, '2022-05-23 12:59:30'),
('80999bb6-6c63-11ec-a47c-6cf049dd8488', NULL, '2022-01-01 09:04:00', 22000001, '108795c0-6c63-11ec-a47c-6cf049dd8488', '47500.00', '0.00', 'Тест постачання товару', 1, 0, '2022-01-03 09:05:15'),
('8a8063ca-4049-4b02-aba1-6158140785bd', NULL, '2022-04-25 12:07:00', 12, '02e0916f-db8c-47fb-9802-4f27bd7929ba', '0.00', '1078.50', 'перша покупка', 0, 0, '2022-05-07 12:08:39'),
('8e8e5ca2-326e-4459-8b81-f3a8bd22498d', NULL, '2022-04-05 21:18:00', 22000006, '638c3038-da18-426b-a285-a7953c41b88d', '10000.00', '0.00', 'Тест постачання товару', 0, 0, '2022-04-18 21:19:43'),
('99efe550-871d-42ae-a391-1737d9ee35ec', NULL, '2022-05-23 14:51:00', 27, '02e0916f-db8c-47fb-9802-4f27bd7929ba', '0.00', '255.80', 'test VUE', 1, 0, '2022-05-23 14:52:10'),
('9ca3e909-5cf7-4ee1-aa15-83bfd28a2de9', NULL, '2022-06-16 23:08:15', 30, '638c3038-da18-426b-a285-a7953c41b88d', '0.00', '5804.00', '', 0, 0, '2022-06-16 23:08:15'),
('a16ba7b5-cf47-49be-bc03-bc3f7637bada', NULL, '2022-06-16 22:46:26', 29, '638c3038-da18-426b-a285-a7953c41b88d', '0.00', '5804.00', 'test VUE copy', 0, 0, '2022-06-16 22:46:26'),
('ab79393c-579c-45e1-9148-ed515aa0814a', NULL, '2022-05-12 14:20:00', 234, '9f0d113e-e75a-4abc-9917-b35168defca1', '0.00', '2200.00', 'Тест постачання сайт', 0, 0, '2022-05-15 18:24:34'),
('ae990474-4689-4c32-8bdc-da54df7d11b8', NULL, '2022-04-05 10:26:00', 22000004, '751e8014-459c-4a3a-b313-caf760aaab3d', '1796.00', '0.00', 'Тест постачання сайт', 1, 0, '2022-04-10 13:25:20'),
('c57fd421-985b-437c-90aa-9ec4818fd8af', NULL, '2022-05-29 16:37:00', 28, '9f0d113e-e75a-4abc-9917-b35168defca1', '0.00', '49.00', '', 1, 0, '2022-06-16 23:13:18'),
('d5d4c050-ae64-4190-b9a9-ce8cff8f6ba5', NULL, '2022-05-02 11:19:00', 15, '23a40e6e-ac2f-40f2-924a-1d9f402e764d', '0.00', '70.00', 'Перевірка створення замовлення через АПІ', 0, 0, '2022-05-23 14:24:04');

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `turnoversHeadlist`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `turnoversHeadlist` (
`balance` decimal(57,2)
,`comment` text
,`createdAt` datetime
,`delivered` tinyint
,`deliveryaddress` varchar(256)
,`demandid` varchar(64)
,`docdate` varchar(21)
,`docnumber` int
,`email` varchar(128)
,`fullname` varchar(128)
,`id` varchar(64)
,`phonenumber` varchar(32)
,`returned` tinyint
,`totalin` decimal(12,2)
,`totalout` decimal(12,2)
,`updatedAt` datetime
,`userid` varchar(64)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `turnoversLastNumber`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `turnoversLastNumber` (
`docnumber` int
);

-- --------------------------------------------------------

--
-- Структура таблицы `turnoversLine`
--

CREATE TABLE `turnoversLine` (
  `id` varchar(64) NOT NULL COMMENT 'код записи движения товара',
  `headid` varchar(64) NOT NULL COMMENT 'Код шапки движения',
  `goodsid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Код товара',
  `quantityin` decimal(12,3) DEFAULT '0.000' COMMENT 'Количество закуплено',
  `quantityout` decimal(12,3) DEFAULT '0.000' COMMENT 'Количество продано',
  `pricein` decimal(12,2) DEFAULT '0.00' COMMENT 'Цена закупки',
  `priceout` decimal(12,2) DEFAULT '0.00' COMMENT 'Цена продажи',
  `totalin` decimal(12,2) DEFAULT '0.00' COMMENT 'Стоимость полученного товара',
  `totalout` decimal(12,2) DEFAULT '0.00' COMMENT 'Стоимость проданного товара',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Создан',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Изменен'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Табличная часть движения товаров';

--
-- Дамп данных таблицы `turnoversLine`
--

INSERT INTO `turnoversLine` (`id`, `headid`, `goodsid`, `quantityin`, `quantityout`, `pricein`, `priceout`, `totalin`, `totalout`, `createdAt`) VALUES
('06fa6fa5-f1ba-493b-8564-7f04297b2570', 'a16ba7b5-cf47-49be-bc03-bc3f7637bada', '8c4bf010-2b49-4d3d-9ca7-7990d1969aa9', '0.000', '180.000', '0.00', '32.00', '0.00', '5760.00', '2022-06-16 22:46:26'),
('1596478d-e31a-4ecd-b68a-388fdbbeaa50', '59fe1bf4-6a39-43ec-bd56-69fe38800e5b', '8c4bf010-2b49-4d3d-9ca7-7990d1969aa9', '0.000', '180.000', '0.00', '32.00', '0.00', '5760.00', '2022-05-23 06:53:53'),
('1a28ac5b-4f63-4707-8f2d-f61affd8f4c9', '59fe1bf4-6a39-43ec-bd56-69fe38800e5b', '47d55469-d898-4ec8-bbf1-60120fe6554d', '0.000', '4.000', '0.00', '11.00', '0.00', '44.00', '2022-05-23 06:53:53'),
('1b080333-f3d7-4873-92f2-a30d5e6b7fd5', '9ca3e909-5cf7-4ee1-aa15-83bfd28a2de9', '8c4bf010-2b49-4d3d-9ca7-7990d1969aa9', '0.000', '180.000', '0.00', '32.00', '0.00', '5760.00', '2022-06-16 23:08:16'),
('325a523f-65ff-4b68-aa3d-2636096916fc', '06392ea2-5370-4909-8a03-8527237c1a85', '47d55469-d898-4ec8-bbf1-60120fe6554d', '0.000', '12.000', '0.00', '66.67', '0.00', '800.00', '2022-05-23 12:40:16'),
('3635be09-900a-4d8a-ba7c-a31040d0b4ce', '5971cd20-f963-4ec1-a39c-588c862a0023', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '0.000', '7.000', '0.00', '7.00', '0.00', '49.00', '2022-05-29 19:37:14'),
('4451e096-6c66-11ec-a47c-6cf049dd8488', '0764ebd8-6c66-11ec-a47c-6cf049dd8488', 'f56d7c3d-6c09-11ec-bcad-6cf049dd8488', '0.000', '100.000', '0.00', '16.00', '0.00', '1600.00', '2022-01-03 09:25:03'),
('4451f1c0-6c66-11ec-a47c-6cf049dd8488', '0764ebd8-6c66-11ec-a47c-6cf049dd8488', 'f56da4fc-6c09-11ec-bcad-6cf049dd8488', '0.000', '124.000', '0.00', '4.03', '0.00', '500.00', '2022-01-03 09:25:03'),
('572fd527-2ea2-4a55-a4cb-90c2a813a1a2', 'ab79393c-579c-45e1-9148-ed515aa0814a', '8c4bf010-2b49-4d3d-9ca7-7990d1969aa9', '0.000', '25.000', '0.00', '32.00', '0.00', '800.00', '2022-05-15 18:24:34'),
('6118ae2e-6c64-11ec-a47c-6cf049dd8488', '80999bb6-6c63-11ec-a47c-6cf049dd8488', 'f56d7c3d-6c09-11ec-bcad-6cf049dd8488', '10000.000', '0.000', '3.85', '0.00', '38500.00', '0.00', '2022-01-03 09:11:32'),
('61e3e7e8-7421-4e55-bc5b-9b82bfa93f53', '99efe550-871d-42ae-a391-1737d9ee35ec', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '0.000', '7.000', '0.00', '6.40', '0.00', '44.80', '2022-05-23 14:52:10'),
('6517883e-4517-447b-bcb0-7c4136eccb9c', 'ae990474-4689-4c32-8bdc-da54df7d11b8', '8c4bf010-2b49-4d3d-9ca7-7990d1969aa9', '7.000', '0.000', '28.00', '32.00', '196.00', '0.00', '2022-04-10 13:25:21'),
('668fa291-d708-4bc6-8656-14c4ca5fca20', '99efe550-871d-42ae-a391-1737d9ee35ec', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '0.000', '1.000', '0.00', '31.00', '0.00', '31.00', '2022-05-23 14:52:10'),
('7e1785d7-9490-44ef-8f1c-7f1b4699b6d9', '8a8063ca-4049-4b02-aba1-6158140785bd', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '0.000', '25.000', '0.00', '34.18', '0.00', '854.50', '2022-05-23 06:50:08'),
('7f378e37-71bc-4bb2-9246-c9563b7f696a', '9ca3e909-5cf7-4ee1-aa15-83bfd28a2de9', '47d55469-d898-4ec8-bbf1-60120fe6554d', '0.000', '4.000', '0.00', '11.00', '0.00', '44.00', '2022-06-16 23:08:16'),
('81908ac7-8e53-4039-8bbb-92b0d60e5a56', 'a16ba7b5-cf47-49be-bc03-bc3f7637bada', '47d55469-d898-4ec8-bbf1-60120fe6554d', '0.000', '4.000', '0.00', '11.00', '0.00', '44.00', '2022-06-16 22:46:26'),
('8d25296b-e335-4fb3-b5b3-3e74c91b85b2', 'c57fd421-985b-437c-90aa-9ec4818fd8af', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '0.000', '7.000', '0.00', '7.00', '0.00', '49.00', '2022-06-16 23:13:18'),
('92af281a-af46-400a-920a-5078f19298e9', 'd5d4c050-ae64-4190-b9a9-ce8cff8f6ba5', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '0.000', '10.000', '0.00', '7.00', '0.00', '70.00', '2022-05-23 14:24:04'),
('a2989853-a1f9-4dc8-9bb4-9f89351ec495', '8a8063ca-4049-4b02-aba1-6158140785bd', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '0.000', '32.000', '0.00', '7.00', '0.00', '224.00', '2022-05-07 12:08:39'),
('b29738d5-1a8d-4703-9fbf-971a040a40a1', 'ae990474-4689-4c32-8bdc-da54df7d11b8', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '50.000', '0.000', '5.00', '7.00', '250.00', '0.00', '2022-04-10 13:25:20'),
('bd5c7c4d-2806-4f4d-9894-993422862c25', 'ae990474-4689-4c32-8bdc-da54df7d11b8', 'fe975478-5b1c-4e4c-b857-e9c16ae11ad7', '54.000', '0.000', '25.00', NULL, '1350.00', NULL, '2022-04-10 13:32:21'),
('cb900594-c623-486e-b805-1ef137edf1f5', '8e8e5ca2-326e-4459-8b81-f3a8bd22498d', '8c4bf010-2b49-4d3d-9ca7-7990d1969aa9', '200.000', '0.000', '26.00', '32.00', '5200.00', '0.00', '2022-04-18 21:19:43'),
('cca6fd13-6c64-11ec-a47c-6cf049dd8488', '80999bb6-6c63-11ec-a47c-6cf049dd8488', 'f56da4fc-6c09-11ec-bcad-6cf049dd8488', '3000.000', '0.000', '3.00', '0.00', '9000.00', '0.00', '2022-01-03 09:14:32'),
('ccc25d3a-8758-4e09-b3e4-d89914b2a54c', '78d49cad-35a7-4554-a8a0-081400d6bd46', '47d55469-d898-4ec8-bbf1-60120fe6554d', '0.000', '12.000', '0.00', '66.67', '0.00', '800.00', '2022-05-23 12:59:30'),
('d4406d40-a636-447a-a8fa-96a96e840832', '8e8e5ca2-326e-4459-8b81-f3a8bd22498d', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '1200.000', '0.000', '4.00', '7.00', '4800.00', '0.00', '2022-04-18 21:19:43'),
('f58a73f7-ee7e-4f3f-8ae4-4d3c9507a6da', '99efe550-871d-42ae-a391-1737d9ee35ec', 'f56da4fc-6c09-11ec-bcad-6cf049dd8488', '0.000', '45.000', '0.00', '4.00', '0.00', '180.00', '2022-05-23 14:52:10'),
('f6e6e8fe-2cae-4c27-84da-decdd925ada3', 'ab79393c-579c-45e1-9148-ed515aa0814a', 'bc1887f7-da5e-4ec2-8c1b-a5ab93fc24c4', '0.000', '200.000', '0.00', '7.00', '0.00', '1400.00', '2022-05-15 18:24:35');

--
-- Триггеры `turnoversLine`
--
DELIMITER $$
CREATE TRIGGER `after_delete_turnovers` AFTER DELETE ON `turnoversLine` FOR EACH ROW CALL TotalTurnover(OLD.headid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_turnover` AFTER INSERT ON `turnoversLine` FOR EACH ROW CALL TotalTurnover(NEW.headid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_turnover` AFTER UPDATE ON `turnoversLine` FOR EACH ROW CALL TotalTurnover(NEW.headid)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `chk_turnoversline_insert` BEFORE INSERT ON `turnoversLine` FOR EACH ROW BEGIN
 IF NEW.totalin = 0 
 THEN
    SET NEW.totalin = NEW.quantityin*NEW.pricein;
 ELSE 
    SET NEW.pricein =  NEW.totalin/NEW.quantityin;
 END IF;
 IF NEW.totalout = 0 
 THEN
    SET NEW.totalout = NEW.quantityout*NEW.priceout;
 ELSE 
    SET NEW.priceout =  NEW.totalout/NEW.quantityout;
 END IF;
 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `chk_turnoversline_update` BEFORE UPDATE ON `turnoversLine` FOR EACH ROW BEGIN
 IF NEW.totalin = 0 
 THEN
    SET NEW.totalin = NEW.quantityin*NEW.pricein;
 ELSE 
    SET NEW.pricein =  NEW.totalin/NEW.quantityin;
 END IF;
 IF NEW.totalout = 0 
 THEN
    SET NEW.totalout = NEW.quantityout*NEW.priceout;
 ELSE 
    SET NEW.priceout =  NEW.totalout/NEW.quantityout;
 END IF;
 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `turnoversLinelist`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `turnoversLinelist` (
`createdAt` datetime
,`currentprice` decimal(12,2)
,`goods` varchar(256)
,`goodsid` varchar(64)
,`headid` varchar(64)
,`id` varchar(64)
,`measure` varchar(64)
,`pricein` decimal(12,2)
,`priceout` decimal(12,2)
,`quantityin` decimal(12,3)
,`quantityout` decimal(12,3)
,`remainder` decimal(35,3)
,`reserved` decimal(34,3)
,`totalin` decimal(12,2)
,`totalout` decimal(12,2)
,`updatedAt` datetime
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `turnoversPeriod`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `turnoversPeriod` (
`beginquantity` decimal(13,3)
,`docdate` varchar(21)
,`docnumber` int
,`endquantity` decimal(13,3)
,`fullname` varchar(128)
,`goods` varchar(256)
,`goodsid` varchar(64)
,`groupname` varchar(128)
,`headid` varchar(64)
,`quantityin` decimal(12,3)
,`quantityout` decimal(12,3)
,`totalin` decimal(12,2)
,`totalout` decimal(12,2)
,`userid` varchar(64)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `turnoversSumPeriod`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `turnoversSumPeriod` (
`beginquantity` decimal(35,3)
,`endquantity` decimal(35,3)
,`goods` varchar(256)
,`goodsid` varchar(64)
,`groupname` varchar(128)
,`quantityin` decimal(34,3)
,`quantityout` decimal(34,3)
,`totalin` decimal(34,2)
,`totalout` decimal(34,2)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `turnoversSumPeriodUserID`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `turnoversSumPeriodUserID` (
`beginquantity` decimal(35,3)
,`endquantity` decimal(35,3)
,`goods` varchar(256)
,`goodsid` varchar(64)
,`groupname` varchar(128)
,`quantityin` decimal(34,3)
,`quantityout` decimal(34,3)
,`totalin` decimal(34,2)
,`totalout` decimal(34,2)
);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` varchar(64) NOT NULL COMMENT 'код пользователя',
  `fullname` varchar(128) DEFAULT NULL COMMENT 'ФИО',
  `phonenumber` varchar(32) DEFAULT NULL COMMENT 'Номер телефона',
  `email` varchar(128) DEFAULT NULL COMMENT 'эл.почта',
  `deliveryaddress` varchar(256) DEFAULT NULL COMMENT 'адрес доставки',
  `role` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'client' COMMENT 'Роль (права в системе)',
  `login` varchar(25) NOT NULL COMMENT 'Логин',
  `password` varchar(128) NOT NULL COMMENT 'Хеш пароля',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'создано',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'изменено'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Таблица учетных записей пользователей';

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `fullname`, `phonenumber`, `email`, `deliveryaddress`, `role`, `login`, `password`, `createdAt`) VALUES
('02e0916f-db8c-47fb-9802-4f27bd7929ba', 'Новий користувач', '45345534', 'test@test.com', 'Тестова адреса доставки', 'client', 'test2', 'test2', '2022-03-26 16:13:31'),
('108795c0-6c63-11ec-a47c-6cf049dd8488', 'Головний постачальник', '+380414321292', NULL, 'вул. Бердичівська 56 ', 'client', 'firstbuyer', 'firstbuyer', '2022-01-03 09:02:07'),
('23a40e6e-ac2f-40f2-924a-1d9f402e764d', 'Постачальник MARIO смачних пиріжків', '+387884561245', NULL, NULL, 'client', 'marius', 'marius', '2022-04-17 15:40:42'),
('488df84a-6c09-11ec-bcad-6cf049dd8488', 'Первый покупатель 432', '+380678474545', NULL, 'вул.Весняна', 'client', 'firstseller', 'firstseller', '2022-01-02 22:19:26'),
('638c3038-da18-426b-a285-a7953c41b88d', 'Третій Степан Гаврилович', '+380445612545', 'poshta@mail.ukr', 'Додому', 'manager', 'Stepan', 'NewPassword2020', '2022-01-07 18:55:43'),
('751e8014-459c-4a3a-b313-caf760aaab3d', 'Адміністратор системи', '+380445612545', 'poshta@mail.ukr', 'Додому вул. Європейська 12', 'admin', 'admin', 'admin', '2022-01-07 18:58:14'),
('9f0d113e-e75a-4abc-9917-b35168defca1', 'Зразковий клієнт', '2536541211', '', 'пров. Суботній 14, м.Бердичів', 'client', 'client', 'client', '2022-03-27 17:54:49');

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `userslist`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `userslist` (
`balance` decimal(57,2)
,`createdAt` datetime
,`deliveryaddress` varchar(256)
,`email` varchar(128)
,`fullname` varchar(128)
,`id` varchar(64)
,`login` varchar(25)
,`password` varchar(128)
,`phonenumber` varchar(32)
,`role` varchar(25)
,`updatedAt` datetime
);

-- --------------------------------------------------------

--
-- Структура для представления `demandsHeadlist`
--
DROP TABLE IF EXISTS `demandsHeadlist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `demandsHeadlist`  AS  select `d`.`id` AS `id`,date_format(`d`.`docdate`,'%Y-%m-%dT%H:%i') AS `docdate`,`d`.`docnumber` AS `docnumber`,`d`.`userid` AS `userid`,`d`.`totalDemand` AS `totalDemand`,`d`.`totalConfirm` AS `totalConfirm`,`d`.`comment` AS `comment`,`d`.`opened` AS `opened`,`d`.`createdAt` AS `createdAt`,`d`.`updatedAt` AS `updatedAt`,`u`.`fullname` AS `fullname`,`u`.`phonenumber` AS `phonenumber`,`u`.`email` AS `email`,`u`.`deliveryaddress` AS `deliveryaddress`,`u`.`balance` AS `balance` from (`demandsHead` `d` left join `userslist` `u` on((`d`.`userid` = `u`.`id`))) ;

-- --------------------------------------------------------

--
-- Структура для представления `demandsLastNumber`
--
DROP TABLE IF EXISTS `demandsLastNumber`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `demandsLastNumber`  AS  select `demandsHead`.`docnumber` AS `docnumber` from `demandsHead` order by `demandsHead`.`docdate` desc,`demandsHead`.`docnumber` desc limit 1 ;

-- --------------------------------------------------------

--
-- Структура для представления `demandsLinelist`
--
DROP TABLE IF EXISTS `demandsLinelist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `demandsLinelist`  AS  select `d`.`id` AS `id`,`d`.`headid` AS `headid`,`d`.`goodsid` AS `goodsid`,`d`.`quantityDemand` AS `quantityDemand`,`d`.`priceDemand` AS `priceDemand`,`d`.`totalDemand` AS `totalDemand`,`d`.`quantityConfirm` AS `quantityConfirm`,`d`.`priceConfirm` AS `priceConfirm`,`d`.`totalConfirm` AS `totalConfirm`,`d`.`createdAt` AS `createdAt`,`d`.`updatedAt` AS `updatedAt`,`g`.`goods` AS `goods`,`g`.`measure` AS `measure`,`g`.`remainder` AS `remainder`,`g`.`reserved` AS `reserved`,`g`.`price` AS `currentprice` from (`demandsLine` `d` left join `goodslist` `g` on((`d`.`goodsid` = `g`.`id`))) ;

-- --------------------------------------------------------

--
-- Структура для представления `goodslist`
--
DROP TABLE IF EXISTS `goodslist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `goodslist`  AS  select `G`.`id` AS `id`,`G`.`groupname` AS `groupname`,`G`.`goods` AS `goods`,`G`.`description` AS `description`,`G`.`picture` AS `picture`,`G`.`measure` AS `measure`,`G`.`price` AS `price`,`G`.`barcode` AS `barcode`,`G`.`createdAt` AS `createdAt`,`G`.`updatedAt` AS `updatedAt`,`Q`.`remainder` AS `remainder`,`R`.`reserved` AS `reserved` from ((`goods` `G` left join (select `turnoversLine`.`goodsid` AS `goodsid`,sum((`turnoversLine`.`quantityin` - `turnoversLine`.`quantityout`)) AS `remainder` from `turnoversLine` group by `turnoversLine`.`goodsid`) `Q` on((`G`.`id` = `Q`.`goodsid`))) left join (select `l`.`goodsid` AS `goodsid`,sum(`l`.`quantityConfirm`) AS `reserved` from (`demandsLine` `l` left join `demandsHead` `h` on((`l`.`headid` = `h`.`id`))) where (`h`.`opened` = 1) group by `l`.`goodsid`) `R` on((`G`.`id` = `R`.`goodsid`))) ;

-- --------------------------------------------------------

--
-- Структура для представления `moneyPeriod`
--
DROP TABLE IF EXISTS `moneyPeriod`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `moneyPeriod`  AS  select 'turnover' AS `doctype`,`t`.`id` AS `docid`,`t`.`docdate` AS `docdate`,`t`.`docnumber` AS `docnumber`,`t`.`userid` AS `userid`,if((`t`.`docdate` < `beginperiod`()),(`t`.`totalin` - `t`.`totalout`),0) AS `beforemoney`,if((`t`.`docdate` >= `beginperiod`()),`t`.`totalin`,0) AS `totalin`,if((`t`.`docdate` >= `beginperiod`()),`t`.`totalout`,0) AS `totalout`,0 AS `inpay`,0 AS `outpay`,(`t`.`totalin` - `t`.`totalout`) AS `endmoney`,`t`.`fullname` AS `fullname` from `turnoversHeadlist` `t` where (`t`.`docdate` < `endperiod`()) union all select 'payment' AS `doctype`,`p`.`id` AS `docid`,`p`.`docdate` AS `docdate`,0 AS `docnumber`,`p`.`userid` AS `userid`,if((`p`.`docdate` < `beginperiod`()),(`p`.`inpay` - `p`.`outpay`),0) AS `beforemoney`,0 AS `totalin`,0 AS `totalout`,if((`p`.`docdate` >= `beginperiod`()),`p`.`inpay`,0) AS `inpay`,if((`p`.`docdate` >= `beginperiod`()),`p`.`outpay`,0) AS `outpay`,(`p`.`inpay` - `p`.`outpay`) AS `endmoney`,`p`.`fullname` AS `fullname` from `paymentslist` `p` where (`p`.`docdate` < `endperiod`()) ;

-- --------------------------------------------------------

--
-- Структура для представления `moneySumPeriod`
--
DROP TABLE IF EXISTS `moneySumPeriod`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `moneySumPeriod`  AS  select `moneyPeriod`.`userid` AS `userid`,`moneyPeriod`.`fullname` AS `fullname`,sum(`moneyPeriod`.`beforemoney`) AS `beforemoney`,sum(`moneyPeriod`.`totalin`) AS `totalin`,sum(`moneyPeriod`.`totalout`) AS `totalout`,sum(`moneyPeriod`.`inpay`) AS `inpay`,sum(`moneyPeriod`.`outpay`) AS `outpay`,sum(`moneyPeriod`.`endmoney`) AS `endmoney` from `moneyPeriod` group by `moneyPeriod`.`userid`,`moneyPeriod`.`fullname` ;

-- --------------------------------------------------------

--
-- Структура для представления `paymentslist`
--
DROP TABLE IF EXISTS `paymentslist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `paymentslist`  AS  select `p`.`id` AS `id`,date_format(`p`.`docdate`,'%Y-%m-%dT%H:%i') AS `docdate`,`p`.`userid` AS `userid`,`u`.`fullname` AS `fullname`,`p`.`inpay` AS `inpay`,`p`.`outpay` AS `outpay`,`p`.`comment` AS `comment`,`p`.`createdAt` AS `createdAt`,`p`.`updatedAt` AS `updatedAt` from (`payments` `p` left join `users` `u` on((`p`.`userid` = `u`.`id`))) ;

-- --------------------------------------------------------

--
-- Структура для представления `test`
--
DROP TABLE IF EXISTS `test`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `test`  AS  select 'turnover' AS `doctype`,`t`.`id` AS `docid`,`t`.`docdate` AS `docdate`,`t`.`docnumber` AS `docnumber`,`t`.`userid` AS `userid`,if((`t`.`docdate` < `beginperiod`()),(`t`.`totalin` - `t`.`totalout`),0) AS `beforemoney`,if((`t`.`docdate` >= `beginperiod`()),`t`.`totalin`,0) AS `totalin`,if((`t`.`docdate` >= `beginperiod`()),`t`.`totalout`,0) AS `totalout`,0 AS `inpay`,0 AS `outpay`,(`t`.`totalin` - `t`.`totalout`) AS `endmoney`,`t`.`fullname` AS `fullname` from `turnoversHeadlist` `t` where (`t`.`docdate` < `endperiod`()) union all select 'payment' AS `doctype`,`p`.`id` AS `docid`,`p`.`docdate` AS `docdate`,0 AS `docnumber`,`p`.`userid` AS `userid`,if((`p`.`docdate` < `beginperiod`()),(`p`.`inpay` - `p`.`outpay`),0) AS `beforemoney`,0 AS `totalin`,0 AS `totalout`,if((`p`.`docdate` >= `beginperiod`()),`p`.`inpay`,0) AS `inpay`,if((`p`.`docdate` >= `beginperiod`()),`p`.`outpay`,0) AS `outpay`,(`p`.`inpay` - `p`.`outpay`) AS `endmoney`,`p`.`fullname` AS `fullname` from `paymentslist` `p` where (`p`.`docdate` < `endperiod`()) ;

-- --------------------------------------------------------

--
-- Структура для представления `turnoversHeadlist`
--
DROP TABLE IF EXISTS `turnoversHeadlist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `turnoversHeadlist`  AS  select `t`.`id` AS `id`,`t`.`demandid` AS `demandid`,date_format(`t`.`docdate`,'%Y-%m-%dT%H:%i') AS `docdate`,`t`.`docnumber` AS `docnumber`,`t`.`userid` AS `userid`,`t`.`totalin` AS `totalin`,`t`.`totalout` AS `totalout`,`t`.`comment` AS `comment`,`t`.`delivered` AS `delivered`,`t`.`returned` AS `returned`,`t`.`createdAt` AS `createdAt`,`t`.`updatedAt` AS `updatedAt`,`u`.`fullname` AS `fullname`,`u`.`phonenumber` AS `phonenumber`,`u`.`email` AS `email`,`u`.`deliveryaddress` AS `deliveryaddress`,`u`.`balance` AS `balance` from (`turnoversHead` `t` left join `userslist` `u` on((`t`.`userid` = `u`.`id`))) ;

-- --------------------------------------------------------

--
-- Структура для представления `turnoversLastNumber`
--
DROP TABLE IF EXISTS `turnoversLastNumber`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `turnoversLastNumber`  AS  select `turnoversHead`.`docnumber` AS `docnumber` from `turnoversHead` order by `turnoversHead`.`docdate` desc,`turnoversHead`.`docnumber` desc limit 1 ;

-- --------------------------------------------------------

--
-- Структура для представления `turnoversLinelist`
--
DROP TABLE IF EXISTS `turnoversLinelist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `turnoversLinelist`  AS  select `l`.`id` AS `id`,`l`.`headid` AS `headid`,`l`.`goodsid` AS `goodsid`,`l`.`quantityin` AS `quantityin`,`l`.`quantityout` AS `quantityout`,`l`.`pricein` AS `pricein`,`l`.`priceout` AS `priceout`,`l`.`totalin` AS `totalin`,`l`.`totalout` AS `totalout`,`l`.`createdAt` AS `createdAt`,`l`.`updatedAt` AS `updatedAt`,`g`.`goods` AS `goods`,`g`.`measure` AS `measure`,`g`.`remainder` AS `remainder`,`g`.`reserved` AS `reserved`,`g`.`price` AS `currentprice` from (`turnoversLine` `l` left join `goodslist` `g` on((`l`.`goodsid` = `g`.`id`))) ;

-- --------------------------------------------------------

--
-- Структура для представления `turnoversPeriod`
--
DROP TABLE IF EXISTS `turnoversPeriod`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `turnoversPeriod`  AS  select `l`.`headid` AS `headid`,`l`.`goodsid` AS `goodsid`,`h`.`userid` AS `userid`,`g`.`goods` AS `goods`,`g`.`groupname` AS `groupname`,`h`.`docdate` AS `docdate`,`h`.`docnumber` AS `docnumber`,`u`.`fullname` AS `fullname`,if((`h`.`docdate` < `BEGINPERIOD`()),(`l`.`quantityin` - `l`.`quantityout`),0) AS `beginquantity`,if((`h`.`docdate` >= `BEGINPERIOD`()),`l`.`quantityin`,0) AS `quantityin`,if((`h`.`docdate` >= `BEGINPERIOD`()),`l`.`totalin`,0) AS `totalin`,if((`h`.`docdate` >= `BEGINPERIOD`()),`l`.`quantityout`,0) AS `quantityout`,if((`h`.`docdate` >= `BEGINPERIOD`()),`l`.`totalout`,0) AS `totalout`,(`l`.`quantityin` - `l`.`quantityout`) AS `endquantity` from (((`turnoversLine` `l` join `turnoversHeadlist` `h` on((`h`.`id` = `l`.`headid`))) join `users` `u` on((`u`.`id` = `h`.`userid`))) join `goods` `g` on((`g`.`id` = `l`.`goodsid`))) where (`h`.`docdate` < `ENDPERIOD`()) ;

-- --------------------------------------------------------

--
-- Структура для представления `turnoversSumPeriod`
--
DROP TABLE IF EXISTS `turnoversSumPeriod`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `turnoversSumPeriod`  AS  select `t`.`goodsid` AS `goodsid`,`t`.`groupname` AS `groupname`,`t`.`beginquantity` AS `beginquantity`,`t`.`quantityin` AS `quantityin`,`t`.`totalin` AS `totalin`,`t`.`quantityout` AS `quantityout`,`t`.`totalout` AS `totalout`,`t`.`endquantity` AS `endquantity`,`g`.`goods` AS `goods` from ((select `turnoversPeriod`.`goodsid` AS `goodsid`,`turnoversPeriod`.`groupname` AS `groupname`,sum(`turnoversPeriod`.`beginquantity`) AS `beginquantity`,sum(`turnoversPeriod`.`quantityin`) AS `quantityin`,sum(`turnoversPeriod`.`totalin`) AS `totalin`,sum(`turnoversPeriod`.`quantityout`) AS `quantityout`,sum(`turnoversPeriod`.`totalout`) AS `totalout`,sum(`turnoversPeriod`.`endquantity`) AS `endquantity` from `turnoversPeriod` group by `turnoversPeriod`.`groupname`,`turnoversPeriod`.`goodsid`) `t` left join `goodslist` `g` on((`t`.`goodsid` = `g`.`id`))) order by `t`.`groupname`,`g`.`goods` ;

-- --------------------------------------------------------

--
-- Структура для представления `turnoversSumPeriodUserID`
--
DROP TABLE IF EXISTS `turnoversSumPeriodUserID`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `turnoversSumPeriodUserID`  AS  select `t`.`goodsid` AS `goodsid`,`t`.`groupname` AS `groupname`,`t`.`beginquantity` AS `beginquantity`,`t`.`quantityin` AS `quantityin`,`t`.`totalin` AS `totalin`,`t`.`quantityout` AS `quantityout`,`t`.`totalout` AS `totalout`,`t`.`endquantity` AS `endquantity`,`g`.`goods` AS `goods` from ((select `turnoversPeriod`.`goodsid` AS `goodsid`,`turnoversPeriod`.`groupname` AS `groupname`,sum(`turnoversPeriod`.`beginquantity`) AS `beginquantity`,sum(`turnoversPeriod`.`quantityin`) AS `quantityin`,sum(`turnoversPeriod`.`totalin`) AS `totalin`,sum(`turnoversPeriod`.`quantityout`) AS `quantityout`,sum(`turnoversPeriod`.`totalout`) AS `totalout`,sum(`turnoversPeriod`.`endquantity`) AS `endquantity` from `turnoversPeriod` where (`turnoversPeriod`.`userid` = `theuserid`()) group by `turnoversPeriod`.`groupname`,`turnoversPeriod`.`goodsid`) `t` left join `goodslist` `g` on((`t`.`goodsid` = `g`.`id`))) order by `t`.`groupname`,`g`.`goods` ;

-- --------------------------------------------------------

--
-- Структура для представления `userslist`
--
DROP TABLE IF EXISTS `userslist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`osp`@`localhost` SQL SECURITY DEFINER VIEW `userslist`  AS  select `U`.`id` AS `id`,`U`.`fullname` AS `fullname`,`U`.`phonenumber` AS `phonenumber`,`U`.`email` AS `email`,`U`.`deliveryaddress` AS `deliveryaddress`,`U`.`role` AS `role`,`U`.`login` AS `login`,`U`.`password` AS `password`,`U`.`createdAt` AS `createdAt`,`U`.`updatedAt` AS `updatedAt`,`B`.`balance` AS `balance` from (`users` `U` left join (select `P`.`userid` AS `userid`,sum(`P`.`balance`) AS `balance` from (select `payments`.`userid` AS `userid`,sum((`payments`.`inpay` - `payments`.`outpay`)) AS `balance` from `payments` group by `payments`.`userid` union all select `turnoversHead`.`userid` AS `userid`,sum((`turnoversHead`.`totalin` - `turnoversHead`.`totalout`)) AS `balance` from `turnoversHead` group by `turnoversHead`.`userid`) `P` group by `P`.`userid`) `B` on((`U`.`id` = `B`.`userid`))) ;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `demandsHead`
--
ALTER TABLE `demandsHead`
  ADD PRIMARY KEY (`id`),
  ADD KEY `demandUserLink` (`userid`);

--
-- Индексы таблицы `demandsLine`
--
ALTER TABLE `demandsLine`
  ADD PRIMARY KEY (`id`),
  ADD KEY `demandsHeadLink` (`headid`),
  ADD KEY `demandsGoodsLink` (`goodsid`);

--
-- Индексы таблицы `goods`
--
ALTER TABLE `goods`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `paymentsUserLink` (`userid`);

--
-- Индексы таблицы `turnoversHead`
--
ALTER TABLE `turnoversHead`
  ADD PRIMARY KEY (`id`),
  ADD KEY `turnoversUserLink` (`userid`);

--
-- Индексы таблицы `turnoversLine`
--
ALTER TABLE `turnoversLine`
  ADD PRIMARY KEY (`id`),
  ADD KEY `turnoversHeadLink` (`headid`),
  ADD KEY `turnoversGoodsLink` (`goodsid`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `demandsHead`
--
ALTER TABLE `demandsHead`
  ADD CONSTRAINT `demandUserLink` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `demandsLine`
--
ALTER TABLE `demandsLine`
  ADD CONSTRAINT `demandsGoodsLink` FOREIGN KEY (`goodsid`) REFERENCES `goods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `demandsHeadLink` FOREIGN KEY (`headid`) REFERENCES `demandsHead` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `paymentsUserLink` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `turnoversHead`
--
ALTER TABLE `turnoversHead`
  ADD CONSTRAINT `turnoversUserLink` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `turnoversLine`
--
ALTER TABLE `turnoversLine`
  ADD CONSTRAINT `turnoversGoodsLink` FOREIGN KEY (`goodsid`) REFERENCES `goods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `turnoversHeadLink` FOREIGN KEY (`headid`) REFERENCES `turnoversHead` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
