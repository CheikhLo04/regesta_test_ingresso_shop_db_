
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS `regesta_test_ingresso_shop_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `regesta_test_ingresso_shop_db`;


CREATE TABLE `acquistare` (
  `shop_id` int(11) NOT NULL,
  `good_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


INSERT INTO `acquistare` (`shop_id`, `good_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4);


CREATE TABLE `fornire` (
  `good_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



INSERT INTO `fornire` (`good_id`, `supplier_id`) VALUES
(1, 1),
(1, 5),
(2, 2),
(2, 3),
(2, 4),
(3, 1),
(3, 3),
(4, 4),
(4, 6);


CREATE TABLE `good` (
  `good_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `purchase_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



INSERT INTO `good` (`good_id`, `name`, `selling_price`, `purchase_price`) VALUES
(1, 'Philips monitor 17\"', 1459.20, 120.00),
(2, 'Sharp 15\"', 150.00, 120.00),
(3, 'Samsung Monitor 24\"', 200.00, 160.00),
(4, 'LG Monitor 27\"', 250.00, 220.00);



CREATE TABLE `shop` (
  `shop_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `via` varchar(100) NOT NULL,
  `civico` varchar(10) NOT NULL,
  `citta` varchar(50) NOT NULL,
  `nazione` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



INSERT INTO `shop` (`shop_id`, `name`, `via`, `civico`, `citta`, `nazione`) VALUES
(1, 'Negozio 1', 'Via Roma', '1', 'Milano', 'Italia');


CREATE TABLE `stock` (
  `stock_id` int(11) NOT NULL,
  `quantita` int(11) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `good_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


INSERT INTO `stock` (`stock_id`, `quantita`, `supplier_id`, `good_id`) VALUES
(1, 0, 1, 1),
(2, 15, 2, 1),
(3, 23, 3, 1),
(4, 8, 4, 2),
(5, 15, 5, 3),
(6, 23, 6, 4),
(7, 10, 1, 2),
(8, 20, 4, 1),
(9, 30, 3, 3);


CREATE TABLE `supplier` (
  `supplier_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `discount_total_value_ind` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`discount_total_value_ind`)),
  `discount_on_quantity_ind` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`discount_on_quantity_ind`)),
  `discount_date_season_ind` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`discount_date_season_ind`)),
  `min_days_to_ship` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `supplier`
--

INSERT INTO `supplier` (`supplier_id`, `name`, `discount_total_value_ind`, `discount_on_quantity_ind`, `discount_date_season_ind`, `min_days_to_ship`) VALUES
(1, 'Fornitore 1', '{\"discount\": 5, \"threshold\": 1000}', NULL, NULL, 5),
(2, 'Fornitore 2', NULL, '{\"3_percent_discount\": {\"quantity_threshold\": 5, \"discount\": 3}, \"5_percent_discount\": {\"quantity_threshold\": 10, \"discount\": 5}}', NULL, 7),
(3, 'Fornitore 3', '{\"discount\": 5, \"threshold\": 1000}', NULL, NULL, 4),
(4, 'Fornitore 4', '{\"discount\": 3, \"threshold\": 1500}', NULL, '{\"month\": \"November\", \"discount\": 5}', 5),
(5, 'Fornitore 5', NULL, '{\"3_percent_discount\": {\"quantity_threshold\": 5, \"discount\": 3}, \"5_percent_discount\": {\"quantity_threshold\": 10, \"discount\": 5}}', NULL, 7),
(6, 'Fornitore 6', '{\"discount\": 5, \"threshold\": 1000}', '{\"discount\": 2, \"quantity_threshold\": 20}', '{\"month\": \"September\", \"discount\": 2}', 4);


ALTER TABLE `acquistare`
  ADD PRIMARY KEY (`shop_id`,`good_id`),
  ADD KEY `good_id` (`good_id`);


ALTER TABLE `fornire`
  ADD PRIMARY KEY (`good_id`,`supplier_id`),
  ADD KEY `supplier_id` (`supplier_id`);


ALTER TABLE `good`
  ADD PRIMARY KEY (`good_id`);


ALTER TABLE `shop`
  ADD PRIMARY KEY (`shop_id`);


ALTER TABLE `stock`
  ADD PRIMARY KEY (`stock_id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `good_id` (`good_id`);


ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supplier_id`);


ALTER TABLE `good`
  MODIFY `good_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;


ALTER TABLE `shop`
  MODIFY `shop_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;


ALTER TABLE `stock`
  MODIFY `stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;


ALTER TABLE `supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;


ALTER TABLE `acquistare`
  ADD CONSTRAINT `acquistare_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`),
  ADD CONSTRAINT `acquistare_ibfk_2` FOREIGN KEY (`good_id`) REFERENCES `good` (`good_id`);


ALTER TABLE `fornire`
  ADD CONSTRAINT `fornire_ibfk_1` FOREIGN KEY (`good_id`) REFERENCES `good` (`good_id`),
  ADD CONSTRAINT `fornire_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`);


ALTER TABLE `stock`
  ADD CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`),
  ADD CONSTRAINT `stock_ibfk_2` FOREIGN KEY (`good_id`) REFERENCES `good` (`good_id`);
COMMIT;
