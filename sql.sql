/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;



USE `essentialmode`;

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('acetone', 'Aseton', 5, 0, 1),
	('methlab', 'Portatif Methlab', 1, 0, 1),
	('meth', 'Meth', 30, 0, 1),
	('lithium', 'Lityum Batarya', 10, 0, 1);
/*!40000 ALTER TABLE `addon_inventory_items` ENABLE KEYS */;

/* Çalmayın la */;