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
-- Table structure for table `table_team`
--

DROP TABLE IF EXISTS `table_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `table_team` (
  `t_t_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AUTO_INCREMENT',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `summary` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `detailed_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`t_t_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='Have the data about all teams. Team id 1 to 1000 is reserved for internal maintenance teams. ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_team`
--

LOCK TABLES `table_team` WRITE;
/*!40000 ALTER TABLE `table_team` DISABLE KEYS */;
INSERT INTO `table_team` VALUES ('TEM000001','Admins','Admin - responsible for all admin works',' production support team\r\n\r\n This team  is responsible for smooth running of website  in production. It monitors the live performance of website,  analysis the data  and advices development team for any enhancements. \r\n\r\nThis team monitors the error logs.  In case of errors, this team create a task and assign to specific   queue.'),('TEM000002','Maintenance','Application maintenance','This team is responsible for overall maintenance of the website.  Below are the roles and responsibilities of this team. \r\nHandles User query feedback and comments.\r\nMaintains teams by updating its members and their roles and responsibilities\r\nManages KT for interested  contributors, setting up the development environment in the contributors machine.\r\nResponsible for backup and deletion of stale data\r\nManages development and testing environment.\r\n\r\nHandles query, feedback, comments.\r\n					provides sample postman request data which is in sync with latest updates\r\n					provides sample DB data for development\r\n				maintenance of environments\r\n					creates new teams based on requirements\r\n					Maintains roles and responsibilities acorss the application.\r\n					backup and deletion strategy\r\n	KT and aritfacts maintenance, GIT, maintenance of KT videos, support for installing dev environment\r\n'),('TEM000003','Java Development','Backend Java Development','Java Development: This team is responsible for overall Java development.  Java architect will be a lead of this team.  individual developers will be assigned with a specific task by team lead. Once assigned tasks are completed it will be committed in GitHub.  once the overall development is over, the the new code will be fixed and deployed by integration and deployment team.\r\n\r\n\r\nUtils development:  we have utilities developed in excel using VB.  These tools needs constant upgradation and development  to be in sync with new developments.\r\n'),('TEM000004','SQL Development','SQL Development','\r\n	SQL development: This team is responsible for overall database design and development.  Contributors will be assigned with specific task by team lead. once the task are completed the developed code will be committed in GitHub. Once the overall development is over, the the new code will be fixed and deployed by integration and deployment team.\r\n'),('TEM000005','Integration and deployment','Build latest code and deploy',' once the  development is  completed this team pics up the latest code  to build and deploy.'),('TEM000006','','Laborum vel voluptatem incidunt. Vel consequatur odit officiis veniam qui et.','Mock Turtle, \'they--you\'ve seen them, of course?\' \'Yes,\' said Alice to herself. At this moment Alice felt dreadfully puzzled. The Hatter\'s remark seemed to be a lesson to you never to lose YOUR.'),('TEM000007','Sample Team 2','Omnis ad vitae dolorem minus. Ducimus praesentium aut et cum ex animi necessitatibus. Omnis eaque eos ut illo sed non. Sed quas et recusandae ea.','Gryphon. \'Then, you know,\' said Alice in a hurry. \'No, I\'ll look first,\' she said, \'than waste it in asking riddles that have no idea what a Gryphon is, look at them--\'I wish they\'d get the trial.'),('TEM000008','Sample Team 3','Ratione adipisci excepturi eveniet dolor nisi et esse. Et eveniet ea numquam qui. Possimus debitis eaque dicta cum itaque.','I suppose, by being drowned in my size; and as he fumbled over the list, feeling very glad to find my way into a graceful zigzag, and was going to remark myself.\' \'Have you guessed the riddle yet?\'.'),('TEM000009','Sample Team 4','Eos qui dolor ratione ut illo nobis rerum. Est quis porro sit tempora cupiditate. Dolor fuga dignissimos eum et cupiditate quasi ratione.','Hatter. \'He won\'t stand beating. Now, if you want to go on crying in this affair, He trusts to you to sit down without being seen, when she next peeped out the Fish-Footman was gone, and the little.'),('TEM000010','Sample Team 5','Totam velit vitae et qui quia. Voluptas consequatur rerum et cupiditate. Laboriosam tenetur vel dicta porro. Provident harum ut deserunt.','Alice went on, looking anxiously about her. \'Oh, do let me help to undo it!\' \'I shall sit here,\' he said, turning to Alice, that she began thinking over other children she knew, who might do very.'),('TEM0000101','TamilLiterature','Tamil literature','Responsible to teach java online. Maintains java slide shows and quizess.'),('TEM0000102','Technical Education-SQL','Teaches SQL online','Responsbile to teach SQL online. Maintains videos and slide shows'),('TEM0000103','SVG','Develops SVG images ','Develop SVG images for all teams.');
/*!40000 ALTER TABLE `table_team` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-15 19:39:31
