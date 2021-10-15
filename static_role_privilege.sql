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
-- Table structure for table `static_role_privilege`
--

DROP TABLE IF EXISTS `static_role_privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `static_role_privilege` (
  `s_r_p_id` smallint unsigned NOT NULL DEFAULT '0',
  `task_status` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `team_lead` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `team_member` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `global_admin` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `color` int DEFAULT NULL,
  `segment_ind` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Segment specifies if it is Task, Messages,Monitor',
  PRIMARY KEY (`s_r_p_id`),
  KEY `FK_static_role_privilege_static_segment` (`segment_ind`),
  CONSTRAINT `FK_static_role_privilege_static_segment` FOREIGN KEY (`segment_ind`) REFERENCES `static_segment` (`segment_ind`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='This static table have list of roles with the associated previleges for different segments.\r\n  100 keys are assigned to each segment.\r\n 100 - 200 is assigned for segment - Task\r\n            For segment Task, 100 - 150 is reserved for tasks and 151 to 200 is reserved for Queued tasks\r\n 200 - 300  is assigned to segment - Message\r\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `static_role_privilege`
--

LOCK TABLES `static_role_privilege` WRITE;
/*!40000 ALTER TABLE `static_role_privilege` DISABLE KEYS */;
INSERT INTO `static_role_privilege` VALUES (101,'Create Task','Y','N','N',NULL,NULL,1),(102,'Assign','Y','N','N','0002,0028,0031',NULL,1),(103,'Started-In Progress','Y','Y','N','0012,0023',NULL,1),(104,'Add Comment','Y','Y','Y',NULL,NULL,1),(105,'Require more clarification','Y','Y','N',NULL,NULL,1),(106,'Reassign','Y','N','N','0002,0028,0031',NULL,1),(107,'Complete','Y','Y','N','0012,0015',NULL,1),(108,'Reject','Y','Y','N','0012,0015',NULL,1),(109,'Close','Y','N','N','0010',NULL,1),(151,'Q-Added to Queue','Y','N','N',NULL,NULL,1),(152,'Q-Assign','Y','N','N','0004,0030,0033',NULL,1),(153,'Q-Started-In Progress','Y','Y','N','0014,0025',NULL,1),(154,'Q-Add comment','Y','Y','Y',NULL,NULL,1),(155,'Q-Require more clarification','Y','Y','N',NULL,NULL,1),(156,'Q-Reassign','Y','N','N',NULL,NULL,1),(157,'Q-Complete','Y','Y','N','0014,0017',NULL,1),(158,'Q-Reject','Y','Y','N','0014,0017',NULL,1),(159,'Q-Close','Y','N','N','0004',NULL,1),(201,'Received','-','-','-',NULL,NULL,2),(202,'Reply With Mail','N','N','Y',NULL,NULL,2),(203,'Close Message','N','Y','Y',NULL,NULL,2);
/*!40000 ALTER TABLE `static_role_privilege` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-15 19:39:28
