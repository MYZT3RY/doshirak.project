-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Май 31 2019 г., 08:37
-- Версия сервера: 8.0.12
-- Версия PHP: 7.2.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `doshirak`
--

-- --------------------------------------------------------

--
-- Структура таблицы `actors`
--

CREATE TABLE `actors` (
  `id` int(11) NOT NULL,
  `description` varchar(32) NOT NULL DEFAULT '-',
  `character` int(11) NOT NULL,
  `pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `virtualworld` int(11) NOT NULL,
  `interior` int(11) NOT NULL,
  `anim` varchar(64) NOT NULL DEFAULT '||0.0|1|0|0|0|0'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `actors`
--

INSERT INTO `actors` (`id`, `description`, `character`, `pos`, `virtualworld`, `interior`, `anim`) VALUES
(1, 'Андрей', 171, '1410.3704|-1691.1630|39.6919|4.7235', 1, 0, 'INT_OFFICE|OFF_Sit_Type_Loop|4.0|1|0|0|0|0'),
(2, 'Дмитрий', 171, '1411.4706|-1679.3422|39.6989|90.8676', 1, 0, 'INT_OFFICE|OFF_Sit_Type_Loop|4.0|1|0|0|0|0'),
(3, 'Максим', 171, '1411.5372|-1676.2910|39.7097|96.4843', 1, 0, 'INT_OFFICE|OFF_Sit_Type_Loop|4.0|1|0|0|0|0'),
(4, 'Анна', 76, '1411.4731|-1673.0493|39.7097|96.4843', 1, 0, 'INT_OFFICE|OFF_Sit_Type_Loop|4.0|1|0|0|0|0'),
(5, 'Илья', 98, '1491.8193|-1774.6887|1006.0600|91.0740', 1, 0, '||0.0|1|0|0|0|0'),
(6, 'Данил', 98, '1489.8409|-1795.3636|1009.5559|49.4235', 1, 0, '||0.0|1|0|0|0|0'),
(7, 'Дарья', 141, '1486.0469|-1761.5701|1009.5559|358.3732', 1, 0, '||0.0|1|0|0|0|0'),
(8, 'Евгения', 76, '1406.3134|-1691.1526|39.6919|357.9750', 1, 0, '||0.0|1|0|0|0|0'),
(9, 'Денис', 1, '2627.0745|-2244.0981|13.7639|97.3066', 0, 0, '||0.0|1|0|0|0|0');

-- --------------------------------------------------------

--
-- Структура таблицы `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `name` varchar(24) NOT NULL,
  `commands` varchar(64) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0',
  `password` varchar(24) NOT NULL DEFAULT '-'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `admins`
--

INSERT INTO `admins` (`id`, `name`, `commands`, `password`) VALUES
(1, 'Dmitriy_Yakimov', '1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1', '123456'),
(2, 'Test_Account', '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '123456');

-- --------------------------------------------------------

--
-- Структура таблицы `ban`
--

CREATE TABLE `ban` (
  `id` int(11) NOT NULL,
  `name` varchar(24) NOT NULL,
  `reason` varchar(32) NOT NULL DEFAULT '-',
  `adminname` varchar(24) NOT NULL,
  `bantime` int(11) NOT NULL,
  `expiretime` int(11) NOT NULL,
  `unbanned` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `ban`
--

INSERT INTO `ban` (`id`, `name`, `reason`, `adminname`, `bantime`, `expiretime`, `unbanned`) VALUES
(3, 'Andrey_Khomyakov', 'забаню', 'Dmitriy_Yakimov', 1516982742, 1517069142, 1),
(4, 'Valeria_Medvedeva', 'забаню', 'Dmitriy_Yakimov', 1516982754, 1517069154, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `banip`
--

CREATE TABLE `banip` (
  `id` int(11) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `adminname` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Структура таблицы `bank_accounts`
--

CREATE TABLE `bank_accounts` (
  `id` int(11) NOT NULL,
  `owner` varchar(24) NOT NULL,
  `password` varchar(24) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` varchar(32) NOT NULL,
  `money` int(11) NOT NULL DEFAULT '0',
  `main` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `bank_accounts`
--

INSERT INTO `bank_accounts` (`id`, `owner`, `password`, `date`, `description`, `money`, `main`) VALUES
(10000, 'Test_Account', '123456', '2018-06-22 14:37:53', 'aera', 30000, 0),
(10001, 'Dmitriy_Yakimov', '123456', '2018-06-22 14:37:59', 'тест', 1000250934, 1),
(10002, 'Dmitriy_Yakimov', '123456', '2018-06-22 14:38:04', 'тест подписи', 0, 0),
(10003, 'Dmitriy_Yakimov', '123456', '2018-10-31 10:22:12', '123', 0, 0),
(10004, 'Dmitriy_Yakimov', '123456', '2018-10-31 10:22:53', 'qWEФЫЦУКЦУцуау', 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `ba_transactions`
--

CREATE TABLE `ba_transactions` (
  `ba_id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `money` int(11) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `transfer_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `ba_transactions`
--

INSERT INTO `ba_transactions` (`ba_id`, `transaction_id`, `type`, `date`, `money`, `ip`, `transfer_id`) VALUES
(1, 1, 3, '2017-09-03 15:41:03', 10000, '127.0.0.1', 2),
(1, 2, 3, '2017-09-03 15:41:13', 10000, '127.0.0.1', 2),
(2, 3, 3, '2017-09-23 15:08:17', 234234, '127.0.0.1', 1),
(10001, 4, 3, '2018-06-22 14:41:20', 10000, '127.0.0.1', 1),
(10001, 5, 1, '2018-06-22 14:42:03', -10000, '127.0.0.1', 10000),
(10000, 6, 1, '2018-06-22 14:42:03', 10000, '127.0.0.1', 10001),
(10001, 7, 3, '2019-03-04 11:07:38', -10000, '127.0.0.1', 1),
(10001, 8, 1, '2019-03-04 11:25:52', -1, '127.0.0.1', 10001),
(10001, 9, 1, '2019-03-04 11:25:52', 1, '127.0.0.1', 10001);

-- --------------------------------------------------------

--
-- Структура таблицы `businesses`
--

CREATE TABLE `businesses` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `owner` varchar(24) NOT NULL DEFAULT '-',
  `pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `business_interior` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `locked` int(11) NOT NULL DEFAULT '1',
  `items` varchar(256) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',
  `load_pos` varchar(64) DEFAULT '0.0|0.0|0.0|0.0'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `businesses`
--

INSERT INTO `businesses` (`id`, `name`, `owner`, `pos`, `business_interior`, `price`, `type`, `locked`, `items`, `load_pos`) VALUES
(1, 'Grotti', 'Dmitriy_Yakimov', '542.0197|-1293.7083|17.2414|357.2781', 1, 250000, 1, 0, '0|0|0|0|562|400|411|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '561.3166|-1286.8284|16.8468|5.8846'),
(2, 'Coutt N Schutz', 'Dmitriy_Yakimov', '2131.7979|-1151.1082|24.0835|359.8831', 1, 200000, 1, 1, '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0', '2119.6426|-1149.3485|23.8360|2.6844');

-- --------------------------------------------------------

--
-- Структура таблицы `business_interiors`
--

CREATE TABLE `business_interiors` (
  `id` int(11) NOT NULL,
  `description` varchar(64) NOT NULL,
  `pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `interior` int(11) NOT NULL,
  `action_pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `business_interiors`
--

INSERT INTO `business_interiors` (`id`, `description`, `pos`, `interior`, `action_pos`) VALUES
(1, 'Cardealership Showroom', '850.4740|-973.6782|1090.1021|89.0623', 1, '816.9111|-974.1781|1090.1021');

-- --------------------------------------------------------

--
-- Структура таблицы `connects`
--

CREATE TABLE `connects` (
  `id` int(11) NOT NULL,
  `connect_time` int(11) NOT NULL DEFAULT '0',
  `ip` varchar(24) NOT NULL,
  `disconnect_time` int(11) NOT NULL DEFAULT '0',
  `reason` varchar(32) CHARACTER SET cp1251 COLLATE cp1251_general_ci NOT NULL DEFAULT 'null'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `connects`
--

INSERT INTO `connects` (`id`, `connect_time`, `ip`, `disconnect_time`, `reason`) VALUES
(1, 1559287863, '127.0.0.1', 1559287906, 'Выход из игры'),
(1, 1559288465, '127.0.0.1', 1559288556, 'Выход из игры'),
(1, 1559288598, '127.0.0.1', 1559289151, 'Выход из игры'),
(1, 1559289740, '127.0.0.1', 1559290164, 'Выход из игры'),
(1, 1559290201, '127.0.0.1', 1559290244, 'Выход из игры'),
(1, 1559290512, '127.0.0.1', 1559290527, 'Выход из игры'),
(1, 1559290597, '127.0.0.1', 1559290651, 'Выход из игры'),
(1, 1559291318, '127.0.0.1', 1559291372, 'Выход из игры'),
(1, 1559291575, '127.0.0.1', 1559291664, 'Вылет'),
(1, 1559291717, '127.0.0.1', 0, 'null'),
(1, 1559291777, '127.0.0.1', 1559291814, 'Выход из игры');

-- --------------------------------------------------------

--
-- Структура таблицы `entrance`
--

CREATE TABLE `entrance` (
  `id` int(11) NOT NULL,
  `description` varchar(32) NOT NULL DEFAULT '-',
  `locked` int(11) NOT NULL DEFAULT '1',
  `enter_pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `exit_pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `interior` int(11) NOT NULL,
  `virtualworld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `entrance`
--

INSERT INTO `entrance` (`id`, `description`, `locked`, `enter_pos`, `exit_pos`, `interior`, `virtualworld`) VALUES
(1, 'Банк', 0, '1411.7273|-1699.7323|13.5395|233.8938', '1397.5680|-1683.1973|39.6919|274.4592', 0, 1),
(2, 'Мэрия', 0, '1479.4407|-1771.6605|18.7958|357.0964', '1472.5143|-1774.9888|1004.0146|268.5573', 0, 1),
(3, 'Спортзал', 0, '2229.5894|-1721.6174|13.5647|136.7595', '-2976.382|472.039|998.251|0.0', 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `factions`
--

CREATE TABLE `factions` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `spawn` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0|0|0',
  `clothes` varchar(32) NOT NULL DEFAULT '0.0|0.0|0.0',
  `skin` varchar(64) NOT NULL DEFAULT '0|0|0|0|0|0|0|0|0|0|0',
  `rank` varchar(274) NOT NULL DEFAULT '-|-|-|-|-|-|-|-|-|-|-',
  `leader` varchar(24) NOT NULL DEFAULT '-',
  `sub_leader` varchar(24) NOT NULL DEFAULT '-',
  `bank` int(11) NOT NULL DEFAULT '25000',
  `sub_leader_access` varchar(24) NOT NULL DEFAULT '0|0|0|0',
  `entrance_id` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `factions`
--

INSERT INTO `factions` (`id`, `name`, `spawn`, `clothes`, `skin`, `rank`, `leader`, `sub_leader`, `bank`, `sub_leader_access`, `entrance_id`) VALUES
(1, 'Банк', '1403.5546|-1664.0609|39.6919|178.5783|1|0', '1401.0548|-1664.1080|39.6919', '301|302|234|222|222|223|222|222|222|311|111', '-|-|-|-|-|-|-|-|-|-|-', 'Dmitriy_Yakimov', '-', 25000, '0|0|0|0', 1),
(2, 'Мэрия', '1500.0941|-1792.5920|1009.5760|90.1806|1|0', '1500.0529|-1783.8666|1009.5759', '301|302|234|222|222|223|222|222|222|32|111', 'Первый|-|-|-|-|-|-|-|-|Заместитель лидера|Лидер', '-', '-', 25000, '0|0|0', 2);

-- --------------------------------------------------------

--
-- Структура таблицы `general`
--

CREATE TABLE `general` (
  `cheque` int(11) NOT NULL DEFAULT '1',
  `fee_for_passport` int(11) NOT NULL DEFAULT '1',
  `class_cost` varchar(64) NOT NULL DEFAULT '0|0|0|0|0'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `general`
--

INSERT INTO `general` (`cheque`, `fee_for_passport`, `class_cost`) VALUES
(60, 5, '125000|100000|75000|50000|25000');

-- --------------------------------------------------------

--
-- Структура таблицы `houses`
--

CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `owner` varchar(24) NOT NULL DEFAULT '-',
  `enter_pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `house_interior` int(2) NOT NULL,
  `locked` int(11) NOT NULL DEFAULT '1',
  `cost` int(11) NOT NULL,
  `confirmed` int(1) NOT NULL DEFAULT '0',
  `class` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `houses`
--

INSERT INTO `houses` (`id`, `owner`, `enter_pos`, `house_interior`, `locked`, `cost`, `confirmed`, `class`) VALUES
(1, '-', '1980.4980|-1718.9044|17.0303|90.8908', 1, 1, 70000, 1, 5),
(2, '-', '1980.9924|-1682.8542|17.0538|89.0108', 2, 0, 85000, 1, 5),
(3, 'Test_Account', '1986.9374|-1605.1892|13.5309|219.8219', 3, 1, 71000, 1, 5),
(4, 'Dmitriy_Yakimov', '2002.6909|-1594.1050|13.5774|224.5219', 4, 1, 100000, 1, 5),
(5, 'Dmitriy_Yakimov', '2011.5599|-1594.1857|13.5839|223.8953', 5, 0, 90000, 1, 5),
(6, '-', '1958.7944|-1560.4465|13.5948|218.8819', 6, 1, 170000, 1, 5),
(7, 'Dmitriy_Yakimov', '1972.9792|-1559.8329|13.6398|222.9553', 7, 1, 150000, 1, 5),
(8, 'Test_Account', '2018.0538|-1629.7010|14.0426|89.8342', 8, 1, 80000, 1, 5),
(9, 'Dmitriy_Yakimov', '2016.541|-1641.714|14.113|268.244', 1, 1, 1, 1, 5),
(10, '-', '2013.577|-1656.329|14.136|92.893', 1, 1, 1, 1, 5);

-- --------------------------------------------------------

--
-- Структура таблицы `house_interiors`
--

CREATE TABLE `house_interiors` (
  `id` int(11) NOT NULL,
  `description` varchar(32) NOT NULL,
  `pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `interior` int(11) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `house_interiors`
--

INSERT INTO `house_interiors` (`id`, `description`, `pos`, `interior`, `price`) VALUES
(1, '', '2283.0691|-1140.2855|1050.8984|1.3751', 11, 15000),
(2, '', '2259.7244|-1135.9023|1050.6328|263.6142', 10, 0),
(3, '', '2270.0718|-1210.5579|1047.5625|85.2789', 10, 0),
(4, '', '2196.5229|-1204.3927|1049.0234|84.6522', 6, 0),
(5, '', '2807.7717|-1174.1318|1025.5703|356.9415', 8, 0),
(6, '', '2237.7166|-1081.3383|1049.0234|2.5582', 2, 0),
(7, '', '2365.1353|-1135.3059|1050.8750|357.5446', 8, 0),
(8, '', '244.0307|305.0530|999.1484|267.9305', 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `passports`
--

CREATE TABLE `passports` (
  `id` int(11) NOT NULL,
  `owner` varchar(24) NOT NULL,
  `valid_to` int(11) NOT NULL,
  `signature` varchar(16) NOT NULL,
  `taken` int(1) NOT NULL,
  `birthday` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `passports`
--

INSERT INTO `passports` (`id`, `owner`, `valid_to`, `signature`, `taken`, `birthday`) VALUES
(100001, 'Dmitriy_Yakimov', 1583321314, 'dmitriy', 1, ''),
(100002, 'Test_Account2', 1517509788, 'dm', 1, '25/5/1999');

-- --------------------------------------------------------

--
-- Структура таблицы `promocodes`
--

CREATE TABLE `promocodes` (
  `id` int(11) NOT NULL,
  `creator` varchar(24) NOT NULL,
  `promocode` varchar(32) NOT NULL,
  `money` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `experience` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `promocodes`
--

INSERT INTO `promocodes` (`id`, `creator`, `promocode`, `money`, `level`, `experience`, `created`) VALUES
(1, 'Sanz_Plea', '2018000', 50000, 1, 20, '2018-01-30 20:57:15'),
(2, 'Vlad_Terros', 'VTERROS', 50000, 4, 5, '2018-02-11 10:28:49');

-- --------------------------------------------------------

--
-- Структура таблицы `transport`
--

CREATE TABLE `transport` (
  `id` int(3) NOT NULL,
  `model` int(3) NOT NULL,
  `name` varchar(35) NOT NULL,
  `price` int(8) NOT NULL,
  `fuel_tank` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

--
-- Дамп данных таблицы `transport`
--

INSERT INTO `transport` (`id`, `model`, `name`, `price`, `fuel_tank`) VALUES
(1, 400, 'Landstalker', 120000, 80),
(2, 401, 'Bravura', 19000, 40),
(3, 402, 'Buffalo', 900000, 50),
(4, 403, 'Linerunner', 0, 140),
(5, 404, 'Perenniel', 19000, 40),
(6, 405, 'Sentinel', 130000, 50),
(7, 406, 'Dumper', 0, 200),
(8, 407, 'Firetruck', 0, 100),
(9, 408, 'Trashmaster', 0, 80),
(10, 409, 'Stretch', 0, 60),
(11, 410, 'Manana', 15000, 50),
(12, 411, 'Infernus', 5000000, 60),
(13, 412, 'Voodoo', 40000, 60),
(14, 413, 'Pony', 29000, 110),
(15, 414, 'Mule', 0, 110),
(16, 415, 'Cheetah', 1000000, 60),
(17, 416, 'Ambulance', 0, 80),
(18, 417, 'Leviathan', 0, 0),
(19, 418, 'Moonbeam', 120000, 70),
(20, 419, 'Esperanto', 35000, 50),
(21, 420, 'Taxi', 0, 60),
(22, 421, 'Washington', 140000, 70),
(23, 422, 'Bobcat', 36000, 80),
(24, 423, 'Mr Whoopee', 0, 35),
(25, 424, 'BF Injection', 1300000, 40),
(26, 425, 'Hunter', 0, 0),
(27, 426, 'Premier', 150000, 60),
(28, 427, 'Enforcer', 0, 120),
(29, 428, 'Securicar', 0, 100),
(30, 429, 'Banshee Banger', 1000000, 50),
(31, 430, 'Predator', 0, 0),
(32, 431, 'Bus', 0, 100),
(33, 432, 'Rhino', 0, 200),
(34, 433, 'Barracks', 0, 150),
(35, 434, 'Hotknife', 2000000, 30),
(36, 435, 'Article Trailer', 0, 0),
(37, 436, 'Previon', 70000, 35),
(38, 437, 'Coach', 0, 100),
(39, 438, 'Cabbie', 0, 40),
(40, 439, 'Stallion', 42000, 45),
(41, 440, 'Rumpo', 0, 100),
(42, 441, 'RC Bandit', 0, 0),
(43, 442, 'Romero', 0, 60),
(44, 443, 'Packer', 0, 140),
(45, 444, 'Monster', 0, 100),
(46, 445, 'Admiral', 100000, 60),
(47, 446, 'Squallo', 0, 0),
(48, 447, 'Seasparrow', 0, 0),
(49, 448, 'Pizzaboy', 0, 0),
(50, 453, 'Reefer', 0, 0),
(51, 449, 'Tram', 0, 0),
(52, 450, 'Article Trailer 2', 0, 0),
(53, 451, 'Turismo', 1500000, 50),
(54, 452, 'Speeder', 0, 0),
(55, 454, 'Tropic', 0, 0),
(56, 455, 'Flatbed', 0, 110),
(57, 456, 'Yankee', 0, 110),
(58, 457, 'Caddy', 30000, 20),
(59, 458, 'Solair', 400000, 50),
(60, 459, 'Topfun', 0, 70),
(61, 460, 'Skimmer', 0, 0),
(62, 461, 'PCJ-600', 120000, 25),
(63, 462, 'Faggio', 10000, 40),
(64, 463, 'Freeway', 100000, 25),
(65, 464, 'RC Baron', 0, 0),
(66, 465, 'RC Raider', 0, 0),
(67, 466, 'Glendale', 34000, 60),
(68, 467, 'Oceanic', 34000, 60),
(69, 468, 'Sanchez', 80000, 15),
(70, 469, 'Sparrow', 0, 0),
(71, 470, 'Patriot', 0, 80),
(72, 471, 'Quad', 50000, 30),
(73, 472, 'Coastguard', 0, 0),
(74, 473, 'Dinghy', 0, 0),
(75, 474, 'Hermes', 39000, 50),
(76, 475, 'Sabre', 120000, 50),
(77, 476, 'Rustler', 0, 0),
(78, 477, 'ZR-350', 900000, 50),
(79, 478, 'Walton', 80000, 35),
(80, 479, 'Regina', 28000, 70),
(81, 480, 'Comet', 600000, 40),
(82, 481, 'BMX', 2000, 0),
(83, 482, 'Burrito', 35000, 70),
(84, 483, 'Camper', 140000, 50),
(85, 484, 'Marquis', 0, 0),
(86, 485, 'Baggage', 0, 0),
(87, 486, 'Dozer', 0, 50),
(88, 487, 'Maverick', 0, 0),
(89, 488, 'San News Maverick', 0, 0),
(90, 489, 'Rancher', 250000, 80),
(91, 490, 'FBI Rancher', 0, 80),
(92, 491, 'Virgo', 28000, 45),
(93, 492, 'Greenwood', 35000, 50),
(94, 493, 'Jetmax', 0, 0),
(95, 494, 'Hotring Racer', 1300000, 50),
(96, 495, 'Sandking', 0, 100),
(97, 496, 'Blista Compact', 190000, 40),
(98, 497, 'Police Maverick', 0, 0),
(99, 498, 'Boxville', 0, 80),
(100, 499, 'Benson', 0, 80),
(101, 500, 'Mesa', 120000, 40),
(102, 501, 'RC Goblin', 0, 0),
(103, 502, 'Hotring Racer', 1600000, 50),
(104, 503, 'Hotring Racer', 1500000, 50),
(105, 504, 'Bloodring Banger', 0, 50),
(106, 505, 'Rancher', 130000, 80),
(107, 506, 'Super GT', 850000, 50),
(108, 507, 'Elegant', 140000, 60),
(109, 508, 'Camper', 350000, 45),
(110, 509, 'Bike', 2100, 0),
(111, 510, 'Mountain Bike', 5000, 0),
(112, 511, 'Beagle', 0, 0),
(113, 512, 'Cropduster', 0, 0),
(114, 513, 'Stuntplane', 0, 0),
(115, 514, 'Petrol Tanker', 0, 120),
(116, 515, 'Roadtrain', 0, 140),
(117, 516, 'Nebula', 90000, 50),
(118, 517, 'Majestic', 38000, 50),
(119, 518, 'Buccaneer', 40000, 50),
(120, 519, 'Shamal', 0, 0),
(121, 520, 'Hydra', 0, 0),
(122, 521, 'FCR-900', 140000, 25),
(123, 522, 'NRG-500', 2500000, 35),
(124, 523, 'Cop Bike HPV1000', 0, 25),
(125, 524, 'Cement Truck', 0, 80),
(126, 525, 'Towtruck', 0, 50),
(127, 526, 'Fortune', 115000, 50),
(128, 527, 'Cadrona', 70000, 40),
(129, 528, 'FBI Truck', 0, 60),
(130, 529, 'Willard', 100000, 60),
(131, 530, 'Forklift', 0, 15),
(132, 531, 'Tractor', 0, 20),
(133, 532, 'Combine Harvester', 0, 30),
(134, 533, 'Feltzer', 150000, 40),
(135, 534, 'Remington', 200000, 60),
(136, 535, 'Slamvan', 180000, 60),
(137, 536, 'Blade', 580000, 60),
(138, 537, 'Freight (Train)', 0, 0),
(139, 538, 'Brownstreak (Train)', 0, 0),
(140, 539, 'Vortex', 0, 10),
(141, 540, 'Vincent', 120000, 50),
(142, 541, 'Bullet', 1100000, 50),
(143, 542, 'Clover', 19000, 50),
(144, 543, 'Sadler', 15000, 50),
(145, 544, 'Firetruck', 0, 90),
(146, 545, 'Hustler', 33000, 35),
(147, 546, 'Intruder', 90000, 50),
(148, 547, 'Primo', 90000, 50),
(149, 548, 'Cargobob', 0, 0),
(150, 549, 'Tampa', 27000, 50),
(151, 550, 'Sunrise', 300000, 50),
(152, 551, 'Merit', 130000, 50),
(153, 552, 'Utility Van', 0, 50),
(154, 553, 'Nevada', 0, 0),
(155, 554, 'Yosemite', 165000, 50),
(156, 555, 'Windsor', 120000, 35),
(157, 556, 'Monster \"A\"', 0, 100),
(158, 557, 'Monster \"B\"', 0, 100),
(159, 558, 'Uranus', 110000, 50),
(160, 559, 'Jester', 540000, 50),
(161, 560, 'Sultan', 570000, 50),
(162, 561, 'Stratum', 120000, 50),
(163, 562, 'Elegy', 540000, 50),
(164, 563, 'Raindance', 0, 0),
(165, 564, 'RC Tiger', 0, 0),
(166, 565, 'Flash', 800000, 50),
(167, 566, 'Tahoma', 150000, 50),
(168, 567, 'Savanna', 150000, 50),
(169, 568, 'Bandito', 0, 15),
(170, 569, 'Flat Trailer (Train)', 0, 0),
(171, 570, 'Streak Trailer (Train)', 0, 0),
(172, 571, 'Kart', 0, 10),
(173, 572, 'Mower', 0, 10),
(174, 573, 'Dune', 0, 35),
(175, 574, 'Sweeper', 0, 10),
(176, 575, 'Broadway', 30000, 50),
(177, 576, 'Tornado', 30000, 50),
(178, 577, 'AT400', 0, 0),
(179, 578, 'DFT-30', 0, 70),
(180, 579, 'Huntley', 160000, 70),
(181, 580, 'Stafford', 90000, 50),
(182, 581, 'BF-400', 900000, 25),
(183, 582, 'Newsvan', 0, 80),
(184, 583, 'Tug', 0, 10),
(185, 584, 'Petrol Trailer', 0, 0),
(186, 585, 'Emperor', 30000, 50),
(187, 586, 'Wayfarer', 30000, 25),
(188, 587, 'Euros', 600000, 50),
(189, 588, 'Hotdog', 0, 30),
(190, 589, 'Club', 120000, 50),
(191, 590, 'Box Trailer (Train)', 0, 0),
(192, 591, 'Article Trailer 3', 0, 0),
(193, 592, 'Andromada', 0, 0),
(194, 593, 'Dodo', 0, 0),
(195, 594, 'RC Cam', 0, 0),
(196, 595, 'Launch', 0, 0),
(197, 596, 'Police Car (LSPD)', 0, 50),
(198, 597, 'Police Car (SFPD)', 0, 50),
(199, 598, 'Police Car (LVPD)', 0, 50),
(200, 599, 'Ranger', 0, 80),
(201, 600, 'Picador', 25000, 40),
(202, 601, 'S.W.A.T.', 0, 30),
(203, 602, 'Alpha', 530000, 50),
(204, 603, 'Phoenix', 80000, 50),
(205, 604, 'Glendale Shit', 0, 50),
(206, 605, 'Sadler Shit', 0, 50),
(207, 606, 'Baggage Trailer \"A\"', 0, 0),
(208, 607, 'Baggage Trailer \"B\"', 0, 0),
(209, 608, 'Tug Stairs Trailer', 0, 0),
(210, 609, 'Boxburg', 0, 50),
(211, 610, 'Farm Trailer', 0, 0),
(212, 611, 'Utility Trailer', 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(24) NOT NULL,
  `password` varchar(32) NOT NULL,
  `email` varchar(32) NOT NULL,
  `referal_name` varchar(24) NOT NULL,
  `age` int(11) NOT NULL,
  `origin` int(11) NOT NULL,
  `gender` int(11) NOT NULL,
  `character` int(11) NOT NULL,
  `level` int(11) NOT NULL DEFAULT '1',
  `experience` int(11) NOT NULL DEFAULT '0',
  `reg_ip` varchar(16) NOT NULL,
  `reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `payday` varchar(24) NOT NULL DEFAULT '0|0|0',
  `money` int(11) NOT NULL,
  `passport_id` int(11) NOT NULL,
  `description` varchar(64) NOT NULL DEFAULT '-',
  `faction_id` int(11) NOT NULL DEFAULT '0',
  `rank_id` int(11) NOT NULL DEFAULT '0',
  `mute` int(3) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `password`, `email`, `referal_name`, `age`, `origin`, `gender`, `character`, `level`, `experience`, `reg_ip`, `reg_date`, `payday`, `money`, `passport_id`, `description`, `faction_id`, `rank_id`, `mute`) VALUES
(1, 'Dmitriy_Yakimov', '123456', 'd1maz-mda@yandex.com', '', 17, 3, 1, 170, 5, 8, '127.0.0.1', '2017-11-12 12:25:25', '1233|0|0', 458108829, 100001, '-', 1, 9, 0),
(2, 'Test_Account', '123456', '', '', 16, 1, 1, 26, 1, 1, '127.0.0.1', '2017-11-12 12:25:25', '1698|0|0', -94000, 0, '-', 2, 1, 0),
(3, 'Test_Account2', '123456', '', '', 16, 1, 1, 23, 1, 0, '31.173.87.70', '2018-01-27 15:14:45', '943|0|0', 19975, 100002, '-', 0, 0, 0),
(4, 'Damien_Tomaso', '123123qq', '', '', 21, 3, 1, 44, 1, 0, '91.216.66.117', '2018-01-29 16:21:03', '1049|0|0', 0, 0, '-', 0, 0, 0),
(5, 'Sanz_Plea', '1234567890', '', '', 22, 1, 1, 23, 1, 1, '91.107.43.38', '2018-01-30 20:39:23', '1800|0|1', 0, 0, '-', 0, 0, 0),
(9, 'Vlad_Terros', '123123', 'akakak@mail.ru', '', 60, 1, 1, 6, 1, 0, '88.200.214.106', '2018-02-11 10:28:02', '218|0|0', 0, 0, '-', 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `model` int(11) DEFAULT NULL,
  `owner` varchar(24) NOT NULL DEFAULT 'The State',
  `def_pos` varchar(32) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `park_pos` varchar(32) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `parkable` int(11) NOT NULL DEFAULT '0',
  `color` varchar(8) NOT NULL DEFAULT '0|0',
  `number_plate` varchar(24) NOT NULL DEFAULT 'The State',
  `fuel` float NOT NULL DEFAULT '0',
  `mileage` float NOT NULL DEFAULT '0',
  `locked` int(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `vehicles`
--

INSERT INTO `vehicles` (`id`, `model`, `owner`, `def_pos`, `park_pos`, `parkable`, `color`, `number_plate`, `fuel`, `mileage`, `locked`) VALUES
(1, 462, 'The State', '1672.0|-2310.381|13.543|180.0', '1672.0|-2310.381|13.543|180.0', 0, '7|7', 'The State', 12.567, 166.537, 0),
(2, 462, 'The State', '1669.0|-2310.381|13.543|180.0', '1669.0|-2310.381|13.543|180.0', 0, '7|7', 'The State', 39.761, 0.691, 0),
(3, 462, 'The State', '1666.0|-2310.381|13.543|180.0', '1666.0|-2310.381|13.543|180.0', 0, '7|7', 'The State', 39.902, 0.284, 0),
(4, 462, 'The State', '1663.0|-2310.381|13.543|180.0', '1663.0|-2310.381|13.543|180.0', 0, '7|7', 'The State', 34.302, 16.607, 0),
(5, 462, 'The State', '1803.0|-1933.15|13.386|0.0', '1803.0|-1933.15|13.386|0.0', 0, '7|7', 'The State', 39.996, 0.012, 0),
(6, 462, 'The State', '1800.0|-1933.15|13.386|0.0', '1800.0|-1933.15|13.386|0.0', 0, '7|7', 'The State', 39.997, 0.009, 0),
(7, 462, 'The State', '1797.0|-1933.15|13.386|0.0', '1797.0|-1933.15|13.386|0.0', 0, '7|7', 'The State', 39.998, 0.006, 0),
(8, 462, 'The State', '1794.0|-1933.15|13.386|0.0', '1794.0|-1933.15|13.386|0.0', 0, '7|7', 'The State', 39.999, 0.003, 0),
(9, 462, 'The State', '1791.0|-1933.15|13.386|0.0', '1791.0|-1933.15|13.386|0.0', 0, '7|7', 'The State', 40, 5.234, 0),
(19, 558, 'Dmitriy_Yakimov', '561.317|-1286.828|16.847|5.885', '0.0|0.0|0.0|0.0', 1, '1|1', 'TRANSIT', 44.207, 16.797, 0),
(20, 559, 'Dmitriy_Yakimov', '561.317|-1286.828|16.847|5.885', '0.0|0.0|0.0|0.0', 1, '1|1', 'TRANSIT', 43.581, 18.611, 1),
(21, 560, 'Dmitriy_Yakimov', '561.317|-1286.828|16.847|5.885', '0.0|0.0|0.0|0.0', 1, '1|1', 'TRANSIT', 48.411, 4.607, 0),
(22, 561, 'Test_Account', '561.317|-1286.828|16.847|5.885', '0.0|0.0|0.0|0.0', 1, '1|1', 'TRANSIT', 50, 0, 0);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `actors`
--
ALTER TABLE `actors`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `ban`
--
ALTER TABLE `ban`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `banip`
--
ALTER TABLE `banip`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `bank_accounts`
--
ALTER TABLE `bank_accounts`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `ba_transactions`
--
ALTER TABLE `ba_transactions`
  ADD PRIMARY KEY (`transaction_id`);

--
-- Индексы таблицы `businesses`
--
ALTER TABLE `businesses`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `business_interiors`
--
ALTER TABLE `business_interiors`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `entrance`
--
ALTER TABLE `entrance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Индексы таблицы `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `house_interiors`
--
ALTER TABLE `house_interiors`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `passports`
--
ALTER TABLE `passports`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `promocodes`
--
ALTER TABLE `promocodes`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `transport`
--
ALTER TABLE `transport`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `actors`
--
ALTER TABLE `actors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `ban`
--
ALTER TABLE `ban`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `banip`
--
ALTER TABLE `banip`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `bank_accounts`
--
ALTER TABLE `bank_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10005;

--
-- AUTO_INCREMENT для таблицы `ba_transactions`
--
ALTER TABLE `ba_transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `businesses`
--
ALTER TABLE `businesses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `business_interiors`
--
ALTER TABLE `business_interiors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `entrance`
--
ALTER TABLE `entrance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `factions`
--
ALTER TABLE `factions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `house_interiors`
--
ALTER TABLE `house_interiors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `passports`
--
ALTER TABLE `passports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100003;

--
-- AUTO_INCREMENT для таблицы `promocodes`
--
ALTER TABLE `promocodes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `transport`
--
ALTER TABLE `transport`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=213;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
