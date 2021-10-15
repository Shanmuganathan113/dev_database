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
-- Table structure for table `lookup_team_member_role`
--

DROP TABLE IF EXISTS `lookup_team_member_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lookup_team_member_role` (
  `team_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `team_role_id` tinyint unsigned NOT NULL COMMENT 'refers static_role table',
  KEY `FK_table_team_user_privileges_static_role_privilege` (`team_role_id`),
  KEY `FK_lookup_team_member_role_table_user` (`user_id`),
  KEY `FK_lookup_team_member_role_table_team` (`team_id`),
  CONSTRAINT `FK_lookup_team_member_role_table_team` FOREIGN KEY (`team_id`) REFERENCES `table_team` (`t_t_id`),
  CONSTRAINT `FK_lookup_team_member_role_table_user` FOREIGN KEY (`user_id`) REFERENCES `table_user` (`t_u_id`),
  CONSTRAINT `FK_table_team_user_privileges_static_role_privilege` FOREIGN KEY (`team_role_id`) REFERENCES `static_role` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='Team members with their roles is stored here.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lookup_team_member_role`
--

LOCK TABLES `lookup_team_member_role` WRITE;
/*!40000 ALTER TABLE `lookup_team_member_role` DISABLE KEYS */;
INSERT INTO `lookup_team_member_role` VALUES ('TEM000001','USR00000001',1),('TEM000003','USR00000001',1),('TEM000004','USR00000001',1),('TEM000002','USR00000001',1),('TEM000005','USR00000001',1),('TEM0000101','USR00000002',2),('TEM0000102','USR00000001',1),('TEM0000103','USR00000001',1),('TEM000003','USR00000002',2),('TEM000003','USR00000003',2),('TEM000004','USR00000002',2),('TEM000004','USR00000003',2),('TEM000002','USR00000002',2),('TEM000002','USR00000003',2),('TEM000005','USR00000002',2),('TEM000005','USR00000003',2),('TEM0000101','USR00000003',2),('TEM0000101','USR00000001',1),('TEM0000102','USR00000002',2),('TEM0000102','USR00000003',2),('TEM0000103','USR00000002',2),('TEM0000103','USR00000003',2);
/*!40000 ALTER TABLE `lookup_team_member_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-15 19:39:27
