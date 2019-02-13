-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Время создания: Авг 20 2017 г., 16:04
-- Версия сервера: 5.5.25
-- Версия PHP: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `doshirak`
--

-- --------------------------------------------------------

--
-- Структура таблицы `actors`
--

CREATE TABLE IF NOT EXISTS `actors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(32) NOT NULL DEFAULT '-',
  `character` int(11) NOT NULL,
  `pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `virtualworld` int(11) NOT NULL,
  `interior` int(11) NOT NULL,
  `anim` varchar(64) NOT NULL DEFAULT '||0.0|1|0|0|0|0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=5 ;

--
-- Дамп данных таблицы `actors`
--

INSERT INTO `actors` (`id`, `description`, `character`, `pos`, `virtualworld`, `interior`, `anim`) VALUES
(1, 'Андрей', 171, '1410.3704|-1691.1630|39.6919|4.7235', 1, 0, 'INT_OFFICE|OFF_Sit_Type_Loop|4.0|1|0|0|0|0'),
(2, 'Дмитрий', 171, '1411.4706|-1679.3422|39.6989|90.8676', 1, 0, 'INT_OFFICE|OFF_Sit_Type_Loop|4.0|1|0|0|0|0'),
(3, 'Максим', 171, '1411.5372|-1676.2910|39.7097|96.4843', 1, 0, 'INT_OFFICE|OFF_Sit_Type_Loop|4.0|1|0|0|0|0'),
(4, 'Анна', 76, '1411.4731|-1673.0493|39.7097|96.4843', 1, 0, 'INT_OFFICE|OFF_Sit_Type_Loop|4.0|1|0|0|0|0');

-- --------------------------------------------------------

--
-- Структура таблицы `bank_accounts`
--

CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(24) NOT NULL,
  `password` varchar(24) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `description` varchar(32) NOT NULL,
  `money` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=10000 ;

-- --------------------------------------------------------

--
-- Структура таблицы `ba_transactions`
--

CREATE TABLE IF NOT EXISTS `ba_transactions` (
  `ba_id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `money` int(11) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `transfer_id` int(11) NOT NULL,
  PRIMARY KEY (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `connects`
--

CREATE TABLE IF NOT EXISTS `connects` (
  `id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ip` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Структура таблицы `entrance`
--

CREATE TABLE IF NOT EXISTS `entrance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(32) NOT NULL DEFAULT '-',
  `locked` int(11) NOT NULL DEFAULT '1',
  `enter_pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `exit_pos` varchar(64) NOT NULL DEFAULT '0.0|0.0|0.0|0.0',
  `interior` int(11) NOT NULL,
  `virtualworld` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `entrance`
--

INSERT INTO `entrance` (`id`, `description`, `locked`, `enter_pos`, `exit_pos`, `interior`, `virtualworld`) VALUES
(1, 'Банк', 0, '1411.7273|-1699.7323|13.5395|233.8938', '1397.5680|-1683.1973|39.6919|274.4592', 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `general`
--

CREATE TABLE IF NOT EXISTS `general` (
  `cheque` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `general`
--

INSERT INTO `general` (`cheque`) VALUES
(20);

-- --------------------------------------------------------

--
-- Структура таблицы `promocodes`
--

CREATE TABLE IF NOT EXISTS `promocodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` varchar(24) NOT NULL,
  `promocode` varchar(32) NOT NULL,
  `money` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `experience` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `payday` varchar(24) NOT NULL DEFAULT '0|0|0',
  `money` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
