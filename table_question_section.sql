-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: sangam_uat
-- ------------------------------------------------------
-- Server version	8.0.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `table_question_section`
--

DROP TABLE IF EXISTS `table_question_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `table_question_section` (
  `t_q_s_id` int unsigned NOT NULL AUTO_INCREMENT,
  `section_title` varchar(50) CHARACTER SET utf8 NOT NULL,
  `description` varchar(500) CHARACTER SET utf8 NOT NULL,
  `depth` int DEFAULT '1',
  `depth_round_id` int unsigned DEFAULT '1',
  `extra_info` varchar(1500) CHARACTER SET utf8 DEFAULT NULL,
  `meta_keywords` varchar(300) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`t_q_s_id`),
  UNIQUE KEY `section_title` (`section_title`),
  KEY `fk1_idx` (`depth_round_id`),
  CONSTRAINT `FK_table_quiz_rounds_table_quiz_rounds` FOREIGN KEY (`depth_round_id`) REFERENCES `table_question_section` (`t_q_s_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_question_section`
--

LOCK TABLES `table_question_section` WRITE;
/*!40000 ALTER TABLE `table_question_section` DISABLE KEYS */;
INSERT INTO `table_question_section` VALUES (1,'Sample','Thsi is to test',1,1,NULL,NULL),(2,'GK1','Thsi is to test',1,1,NULL,NULL),(3,'GK2','Thsi is to test',1,1,NULL,NULL),(4,'GK3','Thsi is to test',1,1,NULL,NULL),(5,'GK4','Thsi is to test',1,1,NULL,NULL),(11,'GK5','Thsi is to test',1,1,NULL,NULL);
/*!40000 ALTER TABLE `table_question_section` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-15 19:39:30
