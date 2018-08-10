-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 2018-07-16 19:17:45
-- 服务器版本： 8.0.11
-- PHP Version: 7.1.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lunalauren`
--

-- --------------------------------------------------------

--
-- 表的结构 `carpool`
--

CREATE TABLE `carpool` (
  `id` int(11) NOT NULL,
  `departure city` text NOT NULL,
  `arrive city` text NOT NULL,
  `depart time` varchar(20) NOT NULL,
  `last depart time` varchar(20) NOT NULL,
  `seat` int(10) NOT NULL
  PRIMARY KEY `id`
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `carpool`
--

INSERT INTO `carpool` (`id`, `departure city`, `arrive city`, `depart time`, `last depart time`, `seat`) VALUES
(1, 'toronto', 'london', '2018-07-20,20:00:00pm', '2018-07-20,21:00:00pm', '3'),
(2, 'toronto', 'london', '2018-07-20,20:00:00pm', '2018-07-20,21:00:00pm', '3'),
(3, 'toronto', 'london', '2018-07-20,20:00:00pm', '2018-07-20,21:00:00pm', '3'),
(4, 'toronto', 'london', '2018-07-20,20:00:00pm', '2018-07-20,21:00:00pm', '3'),
(5, 'toronto', 'london', '2018-07-20,20:00:00pm', '2018-07-20,21:00:00pm', '3'),
(6, 'toronto', 'london', '2018-07-20,20:00:00pm', '2018-07-20,21:00:00pm', '3'),
(7, 'toronto', 'london', '2018-07-20,20:00:00pm', '2018-07-20,21:00:00pm', '3'),
(8, 'toronto', 'london', '2018-07-20,20:00:00pm', '2018-07-20,21:00:00pm', '3');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `carpool`
--
ALTER TABLE `carpool`
  ADD PRIMARY KEY (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `carpool`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
