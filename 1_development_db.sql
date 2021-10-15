-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               8.0.19 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             11.1.0.6116
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for sangam_uat
CREATE DATABASE IF NOT EXISTS `sangam_uat` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sangam_uat`;

-- Dumping structure for table sangam_uat.answer_seq
CREATE TABLE IF NOT EXISTS `answer_seq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.answer_seq: ~1 rows (approximately)
DELETE FROM `answer_seq`;
/*!40000 ALTER TABLE `answer_seq` DISABLE KEYS */;
INSERT INTO `answer_seq` (`next_val`) VALUES
	(57);
/*!40000 ALTER TABLE `answer_seq` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.data_control
CREATE TABLE IF NOT EXISTS `data_control` (
  `label` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `key` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `value` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `description` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='This table contains required meta data\r\n';

-- Dumping data for table sangam_uat.data_control: ~8 rows (approximately)
DELETE FROM `data_control`;
/*!40000 ALTER TABLE `data_control` DISABLE KEYS */;
INSERT INTO `data_control` (`label`, `key`, `value`, `description`) VALUES
	('TEM000158', 'LastestSlNo', '01', 'This is the latest sl no of this team'),
	('TEM000158', 'S3-BucketURL', 'www.s3.aws.bucketurl.com/location', 'This is the bucket url for this team'),
	('TEM000158', 'Google_drive_location', 'www.googledrive.com/location', 'This is the google drive location for this team'),
	('static', 'latest_role_privilege_updated', '2021-04-19 12:39:10', 'Latest time when static_role_privilege or role updated'),
	('static', 'latest_team_modified', '2021-04-19 12:39:10', 'Latest time new team created or updated in table_team. This needs to be reflected in xl sheet.'),
	('TEM000158', 'latest_team_members_updated', '2021-04-19 12:39:10', 'This is the latest sl no of this team'),
	('static', 'latest_task_util_xl_version', 'V2', 'Latest version of task util xl'),
	('static', 'latest_task_util_xl_path', 'google drive path', 'Path where latest task util xl is placed');
/*!40000 ALTER TABLE `data_control` ENABLE KEYS */;

-- Dumping structure for function sangam_uat.get_user_team_details
DELIMITER //
CREATE FUNCTION `get_user_team_details`(
	`param_by_user_id` VARCHAR(50),
	`param_to_user_id` VARCHAR(50),
	`param_task_status` INT
) RETURNS text CHARSET latin1
    COMMENT 'This returns the json object with user or team details for task message logs based on input indicators.'
BEGIN
	
	DECLARE LOC_TEAM 	INT DEFAULT 101; -- Refers Team
	DECLARE LOC_QUEUE	INT DEFAULT 151; -- Refers Queue
	
	RETURN(

		SELECT 	GROUP_CONCAT(
					JSON_OBJECT(
									'userId',	user_id,
									'userName', user_name,
									'userImage',image_url,
									'by_OR_TO_USER_IND',by_or_to_user_ind,
									'teamId',	team_id,
									'teamName',	team_name,
									'taskId',	param_task_status))
									
		FROM 
		(
			SELECT	u.t_u_id 	AS 'user_id',
						u.name 		AS 'user_name',
						u.image_url	AS 'image_url',
						CASE WHEN param_by_user_id = u.t_u_id THEN 'BY_USER' ELSE 'TO_USER' END AS 'by_or_to_user_ind' ,
						t.t_t_id		AS 'team_id',
						t.name		AS 'team_name'
			FROM table_user u
				
			LEFT
			JOIN table_team t
			ON t.t_t_id = param_to_user_id
			AND (param_task_status IN (LOC_TEAM,LOC_QUEUE))
			
			
			WHERE u.t_u_id = param_by_user_id
			OR	( param_task_status NOT IN (LOC_TEAM,LOC_QUEUE) AND u.t_u_id = param_to_user_id )	
			
			UNION
			
			SELECT	''				AS 'user_id',
						''				AS 'user_name',
						''				AS 'image_url',
						'TO_USER'	AS 'by_or_to_user_ind',
						t.t_t_id		AS 'team_id',
						t.name 		AS 'team_name'
						
			FROM table_team t
			WHERE
			(param_task_status  IN (LOC_TEAM,LOC_QUEUE) AND t.t_t_id = param_to_user_id )	
			
			UNION -- When both by user and to user are same, add to_user from below
			
			SELECT	u.t_u_id 	AS 'user_id',
						u.name 		AS 'user_name',
						u.image_url	AS 'image_url',
						'TO_USER'  	AS 'by_or_to_user_ind' ,
						t.t_t_id		AS 'team_id',
						t.name		AS 'team_name'
			FROM table_user u
				
			LEFT
			JOIN table_team t
			ON t.t_t_id = param_to_user_id
			AND (param_task_status IN (LOC_TEAM,LOC_QUEUE))
			
			
			WHERE u.t_u_id = param_by_user_id
			AND u.t_u_id = param_to_user_id
			OR	( param_task_status NOT IN (LOC_TEAM,LOC_QUEUE) AND u.t_u_id = param_to_user_id )
		)t
	);
	

END//
DELIMITER ;

-- Dumping structure for table sangam_uat.hibernate_sequence
CREATE TABLE IF NOT EXISTS `hibernate_sequence` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.hibernate_sequence: ~2 rows (approximately)
DELETE FROM `hibernate_sequence`;
/*!40000 ALTER TABLE `hibernate_sequence` DISABLE KEYS */;
INSERT INTO `hibernate_sequence` (`next_val`) VALUES
	(199),
	(199);
/*!40000 ALTER TABLE `hibernate_sequence` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.lookup_team_member_role
CREATE TABLE IF NOT EXISTS `lookup_team_member_role` (
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

-- Dumping data for table sangam_uat.lookup_team_member_role: ~22 rows (approximately)
DELETE FROM `lookup_team_member_role`;
/*!40000 ALTER TABLE `lookup_team_member_role` DISABLE KEYS */;
INSERT INTO `lookup_team_member_role` (`team_id`, `user_id`, `team_role_id`) VALUES
	('TEM000001', 'USR00000001', 1),
	('TEM000003', 'USR00000001', 1),
	('TEM000004', 'USR00000001', 1),
	('TEM000002', 'USR00000001', 1),
	('TEM000005', 'USR00000001', 1),
	('TEM0000101', 'USR00000002', 2),
	('TEM0000102', 'USR00000001', 1),
	('TEM0000103', 'USR00000001', 1),
	('TEM000003', 'USR00000002', 2),
	('TEM000003', 'USR00000003', 2),
	('TEM000004', 'USR00000002', 2),
	('TEM000004', 'USR00000003', 2),
	('TEM000002', 'USR00000002', 2),
	('TEM000002', 'USR00000003', 2),
	('TEM000005', 'USR00000002', 2),
	('TEM000005', 'USR00000003', 2),
	('TEM0000101', 'USR00000003', 2),
	('TEM0000101', 'USR00000001', 1),
	('TEM0000102', 'USR00000002', 2),
	('TEM0000102', 'USR00000003', 2),
	('TEM0000103', 'USR00000002', 2),
	('TEM0000103', 'USR00000003', 2);
/*!40000 ALTER TABLE `lookup_team_member_role` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.paragraph_seq
CREATE TABLE IF NOT EXISTS `paragraph_seq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.paragraph_seq: ~1 rows (approximately)
DELETE FROM `paragraph_seq`;
/*!40000 ALTER TABLE `paragraph_seq` DISABLE KEYS */;
INSERT INTO `paragraph_seq` (`next_val`) VALUES
	(1);
/*!40000 ALTER TABLE `paragraph_seq` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.question_seq
CREATE TABLE IF NOT EXISTS `question_seq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.question_seq: ~1 rows (approximately)
DELETE FROM `question_seq`;
/*!40000 ALTER TABLE `question_seq` DISABLE KEYS */;
INSERT INTO `question_seq` (`next_val`) VALUES
	(4);
/*!40000 ALTER TABLE `question_seq` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.static_message_type
CREATE TABLE IF NOT EXISTS `static_message_type` (
  `s_m_t_id` tinyint unsigned NOT NULL,
  `message_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`s_m_t_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.static_message_type: ~5 rows (approximately)
DELETE FROM `static_message_type`;
/*!40000 ALTER TABLE `static_message_type` DISABLE KEYS */;
INSERT INTO `static_message_type` (`s_m_t_id`, `message_type`) VALUES
	(1, 'Raise Concern'),
	(2, 'Report Error'),
	(3, 'Contact us'),
	(4, 'Feedback'),
	(5, 'Contribute');
/*!40000 ALTER TABLE `static_message_type` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.static_role
CREATE TABLE IF NOT EXISTS `static_role` (
  `role_id` tinyint unsigned NOT NULL DEFAULT '0',
  `role_name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role_description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.static_role: ~3 rows (approximately)
DELETE FROM `static_role`;
/*!40000 ALTER TABLE `static_role` DISABLE KEYS */;
INSERT INTO `static_role` (`role_id`, `role_name`, `role_description`) VALUES
	(1, 'TEAM_LEAD', 'Leads team, creating tasks and organising the team tasks'),
	(2, 'TEAM_MEMBER', 'Performs the tasks assigned by team lead'),
	(3, 'GLOBAL_ADMIN', 'Monitors all acitvities of the entire system');
/*!40000 ALTER TABLE `static_role` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.static_role_privilege
CREATE TABLE IF NOT EXISTS `static_role_privilege` (
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

-- Dumping data for table sangam_uat.static_role_privilege: ~21 rows (approximately)
DELETE FROM `static_role_privilege`;
/*!40000 ALTER TABLE `static_role_privilege` DISABLE KEYS */;
INSERT INTO `static_role_privilege` (`s_r_p_id`, `task_status`, `team_lead`, `team_member`, `global_admin`, `rule`, `color`, `segment_ind`) VALUES
	(101, 'Create Task', 'Y', 'N', 'N', NULL, NULL, 1),
	(102, 'Assign', 'Y', 'N', 'N', '0002,0028,0031', NULL, 1),
	(103, 'Started-In Progress', 'Y', 'Y', 'N', '0012,0023', NULL, 1),
	(104, 'Add Comment', 'Y', 'Y', 'Y', NULL, NULL, 1),
	(105, 'Require more clarification', 'Y', 'Y', 'N', NULL, NULL, 1),
	(106, 'Reassign', 'Y', 'N', 'N', '0002,0028,0031', NULL, 1),
	(107, 'Complete', 'Y', 'Y', 'N', '0012,0015', NULL, 1),
	(108, 'Reject', 'Y', 'Y', 'N', '0012,0015', NULL, 1),
	(109, 'Close', 'Y', 'N', 'N', '0010', NULL, 1),
	(151, 'Q-Added to Queue', 'Y', 'N', 'N', NULL, NULL, 1),
	(152, 'Q-Assign', 'Y', 'N', 'N', '0004,0030,0033', NULL, 1),
	(153, 'Q-Started-In Progress', 'Y', 'Y', 'N', '0014,0025', NULL, 1),
	(154, 'Q-Add comment', 'Y', 'Y', 'Y', NULL, NULL, 1),
	(155, 'Q-Require more clarification', 'Y', 'Y', 'N', NULL, NULL, 1),
	(156, 'Q-Reassign', 'Y', 'N', 'N', NULL, NULL, 1),
	(157, 'Q-Complete', 'Y', 'Y', 'N', '0014,0017', NULL, 1),
	(158, 'Q-Reject', 'Y', 'Y', 'N', '0014,0017', NULL, 1),
	(159, 'Q-Close', 'Y', 'N', 'N', '0004', NULL, 1),
	(201, 'Received', '-', '-', '-', NULL, NULL, 2),
	(202, 'Reply With Mail', 'N', 'N', 'Y', NULL, NULL, 2),
	(203, 'Close Message', 'N', 'Y', 'Y', NULL, NULL, 2);
/*!40000 ALTER TABLE `static_role_privilege` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.static_segment
CREATE TABLE IF NOT EXISTS `static_segment` (
  `segment_ind` tinyint unsigned NOT NULL,
  `segment_name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`segment_ind`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='Contains the various segments across applications\r\n1 - Task\r\n2 - Messages';

-- Dumping data for table sangam_uat.static_segment: ~2 rows (approximately)
DELETE FROM `static_segment`;
/*!40000 ALTER TABLE `static_segment` DISABLE KEYS */;
INSERT INTO `static_segment` (`segment_ind`, `segment_name`) VALUES
	(1, 'TASK'),
	(2, 'MESSAGE');
/*!40000 ALTER TABLE `static_segment` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_folder
CREATE TABLE IF NOT EXISTS `table_folder` (
  `folder_id` varchar(250) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `folder_path` varchar(250) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='This table have the folder structure for slide shows. These slideshows are placed in S3 and google drive.\r\nroot folder / language / standard / subject / ';

-- Dumping data for table sangam_uat.table_folder: ~133 rows (approximately)
DELETE FROM `table_folder`;
/*!40000 ALTER TABLE `table_folder` DISABLE KEYS */;
INSERT INTO `table_folder` (`folder_id`, `folder_path`) VALUES
	('FOL000001', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram1'),
	('FOL000002', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram2'),
	('FOL000003', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram3'),
	('FOL000004', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram4'),
	('FOL000005', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram5'),
	('FOL000006', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram6'),
	('FOL000007', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram7'),
	('FOL000008', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram8'),
	('FOL000009', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram9'),
	('FOL000010', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram10'),
	('FOL000011', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram11'),
	('FOL000012', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram12'),
	('FOL000013', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram13'),
	('FOL000014', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram14'),
	('FOL000015', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram15'),
	('FOL000016', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram16'),
	('FOL000017', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram17'),
	('FOL000018', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram18'),
	('FOL000019', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram19'),
	('FOL000020', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram20'),
	('FOL000021', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram21'),
	('FOL000022', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram22'),
	('FOL000023', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram23'),
	('FOL000024', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram24'),
	('FOL000025', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram25'),
	('FOL000026', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram26'),
	('FOL000027', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram27'),
	('FOL000028', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram28'),
	('FOL000029', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram29'),
	('FOL000030', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram30'),
	('FOL000031', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram31'),
	('FOL000032', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram32'),
	('FOL000033', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram33'),
	('FOL000034', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram34'),
	('FOL000035', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram35'),
	('FOL000036', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram36'),
	('FOL000037', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram37'),
	('FOL000038', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\1aram\\athikaram38'),
	('FOL000039', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram39'),
	('FOL000040', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram40'),
	('FOL000041', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram41'),
	('FOL000042', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram42'),
	('FOL000043', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram43'),
	('FOL000044', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram44'),
	('FOL000045', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram45'),
	('FOL000046', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram46'),
	('FOL000047', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram47'),
	('FOL000048', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram48'),
	('FOL000049', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram49'),
	('FOL000050', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram50'),
	('FOL000051', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram51'),
	('FOL000052', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram52'),
	('FOL000053', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram53'),
	('FOL000054', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram54'),
	('FOL000055', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram55'),
	('FOL000056', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram56'),
	('FOL000057', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram57'),
	('FOL000058', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram58'),
	('FOL000059', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram59'),
	('FOL000060', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram60'),
	('FOL000061', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram61'),
	('FOL000062', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram62'),
	('FOL000063', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram63'),
	('FOL000064', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram64'),
	('FOL000065', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram65'),
	('FOL000066', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram66'),
	('FOL000067', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram67'),
	('FOL000068', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram68'),
	('FOL000069', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram69'),
	('FOL000070', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram70'),
	('FOL000071', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram71'),
	('FOL000072', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram72'),
	('FOL000073', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram73'),
	('FOL000074', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram74'),
	('FOL000075', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram75'),
	('FOL000076', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram76'),
	('FOL000077', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram77'),
	('FOL000078', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram78'),
	('FOL000079', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram79'),
	('FOL000080', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram80'),
	('FOL000081', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram81'),
	('FOL000082', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram82'),
	('FOL000083', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram83'),
	('FOL000084', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram84'),
	('FOL000085', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram85'),
	('FOL000086', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram86'),
	('FOL000087', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram87'),
	('FOL000088', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram88'),
	('FOL000089', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram89'),
	('FOL000090', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram90'),
	('FOL000091', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram91'),
	('FOL000092', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram92'),
	('FOL000093', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram93'),
	('FOL000094', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram94'),
	('FOL000095', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram95'),
	('FOL000096', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram96'),
	('FOL000097', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram97'),
	('FOL000098', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram98'),
	('FOL000099', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram99'),
	('FOL000100', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram100'),
	('FOL000101', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram101'),
	('FOL000102', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram102'),
	('FOL000103', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram103'),
	('FOL000104', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram104'),
	('FOL000105', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram105'),
	('FOL000106', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram106'),
	('FOL000107', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram107'),
	('FOL000108', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\2porul\\athikaram108'),
	('FOL000109', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram109'),
	('FOL000110', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram110'),
	('FOL000111', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram111'),
	('FOL000112', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram112'),
	('FOL000113', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram113'),
	('FOL000114', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram114'),
	('FOL000115', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram115'),
	('FOL000116', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram116'),
	('FOL000117', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram117'),
	('FOL000118', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram118'),
	('FOL000119', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram119'),
	('FOL000120', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram120'),
	('FOL000121', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram121'),
	('FOL000122', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram122'),
	('FOL000123', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram123'),
	('FOL000124', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram124'),
	('FOL000125', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram125'),
	('FOL000126', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram126'),
	('FOL000127', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram127'),
	('FOL000128', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram128'),
	('FOL000129', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram129'),
	('FOL000130', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram130'),
	('FOL000131', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram131'),
	('FOL000132', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram132'),
	('FOL000133', '\\tamilliterature\\sangamliterature\\18kelkanaku\\thirukural\\3inbam\\athikaram133');
/*!40000 ALTER TABLE `table_folder` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_log
CREATE TABLE IF NOT EXISTS `table_log` (
  `t_l_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AUTO_INCREMENT',
  `id` varchar(50) CHARACTER SET latin1 NOT NULL DEFAULT '' COMMENT 'Have task, message id. Segment indicator helps to differentiate among segments.',
  `by_user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `to_user_id` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'To_user_id acts as team_id in case of "create task"',
  `description` text CHARACTER SET latin1,
  `status_id` tinyint unsigned NOT NULL COMMENT 'refers static_role_preivilege table',
  `segment_ind` tinyint unsigned NOT NULL COMMENT 'Says if task_message_id have task or message id',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`t_l_id`) USING BTREE,
  KEY `FK_table_task_log_static_segment` (`segment_ind`),
  KEY `FK_table_log_table_user` (`by_user_id`),
  CONSTRAINT `FK_table_log_table_user` FOREIGN KEY (`by_user_id`) REFERENCES `table_user` (`t_u_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='This table is shared between message and task segments for holding log.  \r\n 1. Segment_ind identifies if a specific row is related to task or message. \r\n 2. To user id -  Will have team details in case of "Create Task" in Task segment\r\n \r\n';

-- Dumping data for table sangam_uat.table_log: ~133 rows (approximately)
DELETE FROM `table_log`;
/*!40000 ALTER TABLE `table_log` DISABLE KEYS */;
INSERT INTO `table_log` (`t_l_id`, `id`, `by_user_id`, `to_user_id`, `description`, `status_id`, `segment_ind`, `time`) VALUES
	('LOG00000001', 'TSK00000001', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000002', 'TSK00000002', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000003', 'TSK00000003', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000004', 'TSK00000004', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000005', 'TSK00000005', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000006', 'TSK00000006', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000007', 'TSK00000007', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000008', 'TSK00000008', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000009', 'TSK00000009', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000010', 'TSK00000010', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000011', 'TSK00000011', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000012', 'TSK00000012', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000013', 'TSK00000013', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000014', 'TSK00000014', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000015', 'TSK00000015', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000016', 'TSK00000016', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000017', 'TSK00000017', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000018', 'TSK00000018', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000019', 'TSK00000019', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000020', 'TSK00000020', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000021', 'TSK00000021', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000022', 'TSK00000022', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000023', 'TSK00000023', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000024', 'TSK00000024', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000025', 'TSK00000025', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000026', 'TSK00000026', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000027', 'TSK00000027', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000028', 'TSK00000028', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000029', 'TSK00000029', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000030', 'TSK00000030', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000031', 'TSK00000031', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000032', 'TSK00000032', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000033', 'TSK00000033', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000034', 'TSK00000034', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000035', 'TSK00000035', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000036', 'TSK00000036', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000037', 'TSK00000037', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000038', 'TSK00000038', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000039', 'TSK00000039', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000040', 'TSK00000040', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000041', 'TSK00000041', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000042', 'TSK00000042', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000043', 'TSK00000043', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000044', 'TSK00000044', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000045', 'TSK00000045', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000046', 'TSK00000046', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000047', 'TSK00000047', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000048', 'TSK00000048', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000049', 'TSK00000049', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000050', 'TSK00000050', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000051', 'TSK00000051', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000052', 'TSK00000052', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000053', 'TSK00000053', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000054', 'TSK00000054', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000055', 'TSK00000055', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000056', 'TSK00000056', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000057', 'TSK00000057', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000058', 'TSK00000058', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000059', 'TSK00000059', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000060', 'TSK00000060', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000061', 'TSK00000061', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000062', 'TSK00000062', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000063', 'TSK00000063', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000064', 'TSK00000064', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000065', 'TSK00000065', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000066', 'TSK00000066', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000067', 'TSK00000067', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000068', 'TSK00000068', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000069', 'TSK00000069', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000070', 'TSK00000070', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000071', 'TSK00000071', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000072', 'TSK00000072', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000073', 'TSK00000073', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000074', 'TSK00000074', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000075', 'TSK00000075', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000076', 'TSK00000076', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000077', 'TSK00000077', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000078', 'TSK00000078', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000079', 'TSK00000079', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000080', 'TSK00000080', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000081', 'TSK00000081', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000082', 'TSK00000082', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000083', 'TSK00000083', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000084', 'TSK00000084', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000085', 'TSK00000085', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000086', 'TSK00000086', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000087', 'TSK00000087', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000088', 'TSK00000088', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000089', 'TSK00000089', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000090', 'TSK00000090', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000091', 'TSK00000091', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000092', 'TSK00000092', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000093', 'TSK00000093', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000094', 'TSK00000094', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000095', 'TSK00000095', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000096', 'TSK00000096', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000097', 'TSK00000097', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000098', 'TSK00000098', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000099', 'TSK00000099', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000100', 'TSK00000100', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000101', 'TSK00000101', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000102', 'TSK00000102', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000103', 'TSK00000103', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000104', 'TSK00000104', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000105', 'TSK00000105', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000106', 'TSK00000106', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000107', 'TSK00000107', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000108', 'TSK00000108', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000109', 'TSK00000109', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000110', 'TSK00000110', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000111', 'TSK00000111', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000112', 'TSK00000112', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000113', 'TSK00000113', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000114', 'TSK00000114', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000115', 'TSK00000115', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000116', 'TSK00000116', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000117', 'TSK00000117', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000118', 'TSK00000118', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000119', 'TSK00000119', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000120', 'TSK00000120', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000121', 'TSK00000121', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000122', 'TSK00000122', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000123', 'TSK00000123', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000124', 'TSK00000124', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000125', 'TSK00000125', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000126', 'TSK00000126', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000127', 'TSK00000127', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000128', 'TSK00000128', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000129', 'TSK00000129', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000130', 'TSK00000130', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000131', 'TSK00000131', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000132', 'TSK00000132', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00000133', 'TSK00000133', 'USR00000001', 'TEM0000101', 'Created', 101, 1, '2021-08-29 12:54:07'),
	('LOG00001118', 'TSK00000001', 'USR00000001', 'USR00000001', 'Please work on this task and complete it asap. This has  been targeted to completed before this YE.', 104, 1, '2021-09-27 13:08:43'),
	('LOG00001119', 'TSK00000001', 'USR00000001', 'USR00000001', 'Please work on this task and complete it asap. This has  been targeted to completed before this YE.', 102, 1, '2021-09-27 13:15:49');
/*!40000 ALTER TABLE `table_log` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_message
CREATE TABLE IF NOT EXISTS `table_message` (
  `t_m_id` int NOT NULL AUTO_INCREMENT,
  `subject` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `message_type` tinyint unsigned NOT NULL COMMENT 'Refers static_message_type',
  PRIMARY KEY (`t_m_id`),
  KEY `FK_table_message_static_message_type` (`message_type`),
  CONSTRAINT `FK_table_message_static_message_type` FOREIGN KEY (`message_type`) REFERENCES `static_message_type` (`s_m_t_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.table_message: ~1 rows (approximately)
DELETE FROM `table_message`;
/*!40000 ALTER TABLE `table_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `table_message` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_question
CREATE TABLE IF NOT EXISTS `table_question` (
  `t_q_id` int unsigned NOT NULL AUTO_INCREMENT,
  `question` varchar(5000) CHARACTER SET utf8 NOT NULL,
  `description_for_correct_answer` varchar(5000) CHARACTER SET utf8 NOT NULL,
  `section_id` int unsigned DEFAULT NULL,
  `user_id` int unsigned NOT NULL,
  `paragraph_id` int unsigned DEFAULT '0',
  `time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`t_q_id`),
  KEY `FK_table_question_table_user` (`user_id`),
  KEY `FK_table_question_table_question_paragraph` (`paragraph_id`),
  KEY `FK_table_question_table_question_section` (`section_id`),
  CONSTRAINT `FK_table_question_table_question_paragraph` FOREIGN KEY (`paragraph_id`) REFERENCES `table_question_paragraph` (`t_q_p_id`),
  CONSTRAINT `FK_table_question_table_question_section` FOREIGN KEY (`section_id`) REFERENCES `table_question_section` (`t_q_s_id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.table_question: ~103 rows (approximately)
DELETE FROM `table_question`;
/*!40000 ALTER TABLE `table_question` DISABLE KEYS */;
INSERT INTO `table_question` (`t_q_id`, `question`, `description_for_correct_answer`, `section_id`, `user_id`, `paragraph_id`, `time`) VALUES
	(2, 'what  is number', '', 5, 1, 1, NULL),
	(3, 'wat s odd', '', 5, 1, 2, NULL),
	(4, 'ewe', '', 5, 1, 2, NULL),
	(5, 'Which among the sources of energy tapped in India has shown the largest growth till the Eighth plan?', '', 5, 1, 1, '2019-10-09 12:42:26'),
	(6, 'When was Mandela inaugurated as first black President?', '', 5, 1, 1, '2019-10-09 12:42:26'),
	(7, 'Which Bank has the maximum number of branches?', '', 5, 1, 2, '2019-10-09 12:42:27'),
	(8, 'Where is the sports stadium, Green Park, located?', '', 5, 1, 2, '2019-10-09 12:42:27'),
	(9, 'Which of the following are the important sects of Islam?', '', 5, 1, 2, '2019-10-09 12:42:27'),
	(10, 'Which is the state with largest urban population?', '', 5, 1, 2, '2019-10-09 12:42:27'),
	(11, 'Which of the following agencies related to the United Nation was in existence before the Second World War?', '', 5, 1, 2, '2019-10-09 12:42:27'),
	(12, 'When was Zoroaster, the founder of Zoroastrianism born in Media(Iran)?', '', 5, 1, 3, '2019-10-09 12:42:27'),
	(13, 'Which missile is designed to defend large installation like oil-fields etc. against enemy air attacks?', '', 5, 1, 3, '2019-10-09 12:42:27'),
	(14, 'When was Lord Buddha born?', '', 5, 1, 3, '2019-10-09 12:42:27'),
	(15, 'Which are the important minerals found in Manipur?', '', 5, 1, 3, '2019-10-09 12:42:27'),
	(16, 'Which language is spoken in Karnataka?', '', 5, 1, 3, '2019-10-09 12:42:27'),
	(17, 'Which amongst the following mammals has the highest metabolic rate in terms of oxygen consumption (mm3/g hour)?', '', 5, 1, 0, '2019-10-09 12:42:27'),
	(18, 'Which is the sacred text of Hinduism?', '', 5, 1, 0, '2019-10-09 12:42:27'),
	(19, 'Which is the place of worship for Judoists?', '', 5, 1, 0, '2019-10-09 12:42:27'),
	(20, 'Which is the associated sport of Bombay Gold Cup?', '', 5, 1, 0, '2019-10-09 12:42:27'),
	(21, 'When was table tennis introduced in Olympics?', '', 5, 1, 0, '2019-10-09 12:42:27'),
	(22, 'When was Mona Lisa painted by Leonardo da Vinci?', '', 5, 1, 0, '2019-10-09 12:42:27'),
	(23, 'Who wrote the book Thirukural?', 'Thirukural was written by Thiruvalluvar.', 2, 1, 0, '2019-10-09 12:48:10'),
	(24, 'A Brief History of Time: From the Big Bang to Black Holes - is the book written by which of the following scientists', 'A Brief History of Time: From the Big Bang to Black Holes is a 1988 popular-science book by British physicist Stephen Hawking.', 2, 1, 0, '2019-10-09 12:43:58'),
	(25, 'Das Kapital is the book written by which of the following authors?', 'Karl Mark wrote the book Das Kapital', 2, 1, 0, '2019-10-09 12:43:58'),
	(26, 'Meghaduta is the book written by which of the following authors?', 'Meghaduta was written by Kalidasa', 2, 1, 0, '2019-10-09 12:43:58'),
	(27, 'Man Of Destiny was written by which of the following authors?', 'Man of destiny was written by George Bernard Shaw', 2, 1, 0, '2019-10-09 12:43:58'),
	(28, 'Mahabaratha was written by which of the below authors?', 'Mahabaratha was written by Vyasa', 2, 1, 0, '2019-10-09 12:43:58'),
	(29, 'Malgudi Days was written by which of the below authors?', 'Malgudi days was written by R.K Narayanan', 2, 1, 0, '2019-10-09 12:43:58'),
	(30, 'Paradise lost was written by?', 'Paradise lost was written by John Milton', 2, 1, 0, '2019-10-09 12:43:58'),
	(31, 'Schindler\'s List - was written by?', 'Thomas Keneally wrote Schindler\'s list', 2, 1, 0, '2019-10-09 12:43:58'),
	(32, 'Art of war was written by?', 'Art of war was written by Sun Tzu', 2, 1, 0, '2019-10-09 12:43:58'),
	(33, 'Who is popularly known as "Periyar"', 'Periyar E.V Ramasamy', 3, 1, 0, '2019-10-09 12:43:58'),
	(34, 'Who is popularly known as "Frontier Gandhi"', 'Khan Abdul Ghaffar Khan is "Frontier Gandhi".', 3, 1, 0, '2019-10-09 12:43:58'),
	(35, 'Who is popularly known as "Grand old man of India"', 'Dadabhai Naoroji is Grand oldman of India', 3, 1, 0, '2019-10-09 12:43:58'),
	(36, 'Who is known as "Maid of Orleans"', 'Joan of Ark', 3, 1, 0, '2019-10-09 12:43:58'),
	(37, 'Who is known as "Nightingale of India"?', 'Sarojini Naidu', 3, 1, 0, '2019-10-09 12:43:59'),
	(38, 'Which city is called as "City of Golden Gate"?', 'San Fransisco is City of Golden Gate', 4, 1, 0, '2019-10-09 12:44:26'),
	(39, 'Perl City of India', 'Tuticorin', 4, 1, 0, '2019-10-09 12:44:26'),
	(40, 'Which city is called "Paris of East" ?', 'Pondicherry is called "Paris of East"', 4, 1, 0, '2019-10-09 12:44:26'),
	(41, 'Gambit\' is the term associated with which game?', 'Gambit is associated with Chess', 5, 1, 0, '2019-10-09 12:44:26'),
	(42, 'The term \'double fault\' is associated with which game?', 'Double fault is associated with Tennis', 5, 1, 0, '2019-10-09 12:44:27'),
	(43, 'By whom were the Saturn rings were discovered?', 'Saturn rings was discovered by Galileo', 5, 1, 0, '2019-10-09 12:44:27'),
	(44, 'The headquarters of the International Red Cross is situated in which city?', 'Geneva', 5, 1, 0, '2019-10-09 12:44:27'),
	(45, '"Orange Revolution" took place in which of the following countries?', 'Orange Revolution took place in Ukraine', 5, 1, 0, '2019-10-09 12:44:27'),
	(46, 'Which animal breathes through the skin?', 'Frog', 5, 1, 0, '2019-10-09 12:44:27'),
	(47, 'Which is the National game of USA?', 'Base ball', 5, 1, 0, '2019-10-09 12:44:27'),
	(48, 'When iron rusts, its weight will ____________', 'Increase', 5, 1, 0, '2019-10-09 12:44:27'),
	(49, 'Related to sound which one of the following is correct', 'Sound travels faster in Iron than Air', 5, 1, 0, '2019-10-09 12:44:27'),
	(50, 'The Sivasamudram Falls is on which river ______________', 'Cauvery', 5, 1, 0, '2019-10-09 12:44:27'),
	(51, 'Where are the islands of Seychelles located', 'Indian Ocean', 5, 1, 0, '2019-10-09 12:44:27'),
	(52, 'Diego Gracia is located in which ocean', 'Indian Ocean', 5, 1, 0, '2019-10-09 12:44:27'),
	(53, 'By whom the Mahatma Gandhi was referred to \'Father of the Nation\' first?', 'Subhash Chandra Bose', 5, 1, 0, '2019-10-09 12:44:27'),
	(54, 'Where did the Indian National Army (I.N.A.) come into existence?', 'Singapore', 5, 1, 0, '2019-10-09 12:44:28'),
	(55, 'Home rule movement in India was started by', 'Anne Besant', 5, 1, 0, '2019-10-09 12:44:28'),
	(56, 'How many moons does Neptune have ____________', 'Thirteen', 5, 1, 0, '2019-10-09 12:44:28'),
	(57, 'Gobind Sagar is in which River ____________', 'Sutlej', 5, 1, 0, '2019-10-09 12:44:28'),
	(58, 'Which is called as "Bengal\'s sorrow"?', 'Damodar', 5, 1, 0, '2019-10-09 12:44:28'),
	(59, 'Brahadeeshwara temple was built by __________', 'Raja Raja chola the great built Brahadeeshwara temple', 5, 1, 0, '2019-10-09 12:44:28'),
	(60, 'A.P.J Abdul Kalam is from _______', 'Rameshwaram', 5, 1, 0, '2019-10-09 12:44:28'),
	(61, ' Felix is a famous Indian player in which of the fields?', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(62, 'The Indian to beat the computers in mathematical wizardry is', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(63, 'Who was known as Iron man of India?', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(64, 'What is common between Kutty, Shankar, Laxman and Sudhir Dar?', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(65, 'Who is the father of Geometry ?', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(66, 'VeenaGuru Gopi Krishna was a maestro of which of the following dance forma?', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(67, 'The first Indian to swim across English channel was', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(68, 'Ms Kim Campbell is the first woman Prime Minister of', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(69, 'Michael Jackson is a distinguished person in the field of?', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(70, 'Which among the famous danseuses is not an exponent of the Odissi dance style?', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(71, 'Who headed the first scientific group to leave for Antarctica in 1982?', '', 3, 1, 0, '2019-10-09 12:44:28'),
	(72, 'Girilal Jain was a noted figure in which of the following fields?', '', 3, 1, 0, '2019-10-09 12:44:29'),
	(73, 'Who is known as the "Lady with the Lamp"?', '', 3, 1, 0, '2019-10-09 12:44:29'),
	(74, 'Gangubai hangal is the name associated with', '', 3, 1, 0, '2019-10-09 12:44:29'),
	(75, 'Who is known as "Trimurthy of Carnatic Music"?', '', 3, 1, 0, '2019-10-09 12:44:29'),
	(76, 'Naina Devi, was associated with field of?', '', 3, 1, 0, '2019-10-09 12:44:29'),
	(77, 'The title of "sparrow" given to', '', 3, 1, 0, '2019-10-09 12:44:29'),
	(78, 'Who is known as "Desert Fox"?', '', 3, 1, 0, '2019-10-09 12:44:29'),
	(79, 'Raja Ravi Verma, was famous in which of the fields?', '', 3, 1, 0, '2019-10-09 12:44:29'),
	(80, 'Pandit Vishwa Mohan Bhatt, who has won the prestigious "Grammy Awards" is an exponent in which of the following musical instruments?', '', 3, 1, 0, '2019-10-09 12:44:29'),
	(81, 'Detergents used for cleaning clothes and utensils contain?', '', 11, 1, 0, '2019-10-09 12:44:29'),
	(82, 'Epoxy resins are used as', '', 11, 1, 0, '2019-10-09 12:44:29'),
	(83, 'Which of the following is commonly called a "polyamide"?', '', 11, 1, 0, '2019-10-09 12:44:29'),
	(84, 'Which type of fire extinguisher is used for petroleum fire?', '', 11, 1, 0, '2019-10-09 12:44:29'),
	(85, 'Which is/are the important raw material(s) required in cement industry?', '', 11, 1, 0, '2019-10-09 12:44:29'),
	(86, 'Deep blue colour is imparted to glass by the presence of', '', 11, 1, 0, '2019-10-09 12:44:29'),
	(87, 'In vulcanisation, natural rubber is heated with', '', 11, 1, 0, '2019-10-09 12:44:29'),
	(88, 'How does common salt help in separating soap from the solution after saponification?', '', 11, 1, 0, '2019-10-09 12:44:29'),
	(89, 'What are the soaps?', '', 11, 1, 0, '2019-10-09 12:44:29'),
	(90, ' The major ingredient of leather is', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(91, ' Optic fibres are mainly used for which of the following?', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(92, ' Rayon is chemically', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(93, ' Wood is the main raw material for the manufacture of', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(94, ' Which of the following is a protein?', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(95, ' Which of the following is used for removing air bubbles from glass during its manufacture?', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(96, ' Soap is a mixture of sodium or potassium salts of', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(97, ' Gypsum is added to cement clinker to', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(98, ' Paper is manufactured by', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(99, ' The vast resources of unutilised natural gas can be used in the production of', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(100, ' Glass is made of the mixture of', '', 11, 1, 0, '2019-10-09 12:44:30'),
	(108, 'what is the capital of India', '', 5, 1, 1, NULL),
	(109, 'what is the capital of India', '', 5, 1, 1, NULL),
	(111, 'what is the capital of India', '', 5, 1, 1, NULL),
	(112, 'wat s odd', '', 5, 1, 2, NULL);
/*!40000 ALTER TABLE `table_question` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_question_answers
CREATE TABLE IF NOT EXISTS `table_question_answers` (
  `t_q_a_id` int unsigned NOT NULL AUTO_INCREMENT,
  `question_id` int unsigned DEFAULT NULL,
  `options` varchar(1500) CHARACTER SET utf8 NOT NULL,
  `correct_answer_ind` char(1) CHARACTER SET utf8 NOT NULL COMMENT 'Contains single charact ''Y'' or ''N''. Y indicates the answer is correct and N indicates the answers is not correct',
  PRIMARY KEY (`t_q_a_id`),
  KEY `FK_table_question_answers_table_question` (`question_id`),
  CONSTRAINT `FK_table_question_answers_table_question` FOREIGN KEY (`question_id`) REFERENCES `table_question` (`t_q_id`)
) ENGINE=InnoDB AUTO_INCREMENT=439 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.table_question_answers: ~428 rows (approximately)
DELETE FROM `table_question_answers`;
/*!40000 ALTER TABLE `table_question_answers` DISABLE KEYS */;
INSERT INTO `table_question_answers` (`t_q_a_id`, `question_id`, `options`, `correct_answer_ind`) VALUES
	(3, NULL, 'Nobel Prize', 'N'),
	(4, NULL, 'Booker Prize', 'Y'),
	(5, NULL, 'Pulitzer Prize', 'N'),
	(6, NULL, 'Magsaysay Award', 'N'),
	(7, NULL, 'The Security Council', 'N'),
	(8, NULL, 'International Court of Justice', 'Y'),
	(9, NULL, 'Trusteeship Council', 'N'),
	(10, NULL, 'Secretariat', 'N'),
	(11, 5, 'Hydro', 'N'),
	(12, 5, 'Thermal', 'Y'),
	(13, 5, 'Gas', 'N'),
	(14, 5, 'Nuclear', 'N'),
	(15, 6, '1994', 'Y'),
	(16, 6, '1999', 'N'),
	(17, 6, '2000', 'N'),
	(18, 6, 'None of the above', 'N'),
	(19, 7, 'ICICI Bank', 'N'),
	(20, 7, 'HDFC Bank', 'N'),
	(21, 7, 'State Bank of India', 'Y'),
	(22, 7, 'State Bank of Patiala', 'N'),
	(23, 8, 'Kanpur', 'Y'),
	(24, 8, 'Jamshedpur', 'N'),
	(25, 8, 'Cuttack', 'N'),
	(26, 8, 'Patiala', 'N'),
	(27, 9, 'Catholics and Protestants', 'N'),
	(28, 9, 'Sunnis and Shias', 'Y'),
	(29, 9, 'Mahayana and Hinayan', 'N'),
	(30, 9, 'None of the above', 'N'),
	(31, 10, 'West Bengal', 'N'),
	(32, 10, 'Maharashtra', 'Y'),
	(33, 10, 'Kerala', 'N'),
	(34, 10, 'Goa', 'N'),
	(35, 11, 'Food and Agricultural Organisation', 'N'),
	(36, 11, 'International Labour Organisation', 'Y'),
	(37, 11, 'World Health Organisation', 'N'),
	(38, 11, 'International Monetary Fund', 'N'),
	(39, 12, '2000 BC', 'N'),
	(40, 12, '660 BC', 'Y'),
	(41, 12, '1075 BC', 'N'),
	(42, 12, '740 BC', 'N'),
	(43, 13, 'Akash', 'Y'),
	(44, 13, 'Nag', 'N'),
	(45, 13, 'Agni', 'N'),
	(46, 13, 'Prithvi', 'N'),
	(47, 14, '586 BC', 'N'),
	(48, 14, '1000 BC', 'N'),
	(49, 14, '563 BC', 'Y'),
	(50, 14, '750 BC', 'N'),
	(51, 15, 'chromite, limestone and serpentinites', 'Y'),
	(52, 15, 'Oil, coal, manganese', 'N'),
	(53, 15, 'Iron, lime, bauxite', 'N'),
	(54, 15, 'None of the above', 'N'),
	(55, 16, 'Marathi', 'N'),
	(56, 16, 'Hindi', 'N'),
	(57, 16, 'Malayalam', 'N'),
	(58, 16, 'Kannada', 'Y'),
	(59, 17, 'Dog', 'N'),
	(60, 17, 'Mouse', 'Y'),
	(61, 17, 'Rabbit', 'N'),
	(62, 17, 'Rat', 'N'),
	(63, 18, 'The Vedas', 'N'),
	(64, 18, 'The Bhagavad Gita', 'N'),
	(65, 18, 'The epics of the Mahabharata and the Ramayana', 'N'),
	(66, 18, 'All of the above', 'Y'),
	(67, 19, 'Synagogue', 'Y'),
	(68, 19, 'First temple', 'N'),
	(69, 19, 'No church or temple', 'N'),
	(70, 19, 'Monastery', 'N'),
	(71, 20, 'Basketball', 'N'),
	(72, 20, 'Weightlifting', 'N'),
	(73, 20, 'Hockey', 'Y'),
	(74, 20, 'Football', 'N'),
	(75, 21, '1896 at Athens', 'N'),
	(76, 21, '1988 at Seoul', 'Y'),
	(77, 21, '1924 at Paris', 'N'),
	(78, 21, '1924 at Seoul', 'N'),
	(79, 22, '1431 AD', 'N'),
	(80, 22, '1492 AD', 'N'),
	(81, 22, '1504 AD', 'Y'),
	(82, 22, '1556 AD', 'N'),
	(83, 23, 'Sekilar', 'N'),
	(84, 23, 'Kambar', 'N'),
	(85, 23, 'Thiruvalluvar', 'Y'),
	(86, 23, 'Sathanar', 'N'),
	(87, 24, 'Albert Einstein', 'N'),
	(88, 24, 'Stephen Hawkings', 'Y'),
	(89, 24, 'Neils Bhor', 'N'),
	(90, 24, 'Issac Newton', 'N'),
	(91, 25, 'Vladimir Lenin', 'N'),
	(92, 25, 'Leon Tortsky', 'N'),
	(93, 25, 'Karl Marx', 'Y'),
	(94, 25, 'Joseph Stalin', 'N'),
	(95, 26, 'Kalidas', 'Y'),
	(96, 26, 'Kambar', 'N'),
	(97, 26, 'Vatsyayan', 'N'),
	(98, 26, 'Vivekananda', 'N'),
	(99, 27, 'Oscar wilde', 'N'),
	(100, 27, 'William Shakesphere', 'N'),
	(101, 27, 'Mark Twain', 'N'),
	(102, 27, 'George Bernard Shaw', 'Y'),
	(103, 28, 'Kambar', 'N'),
	(104, 28, 'Vyasa', 'Y'),
	(105, 28, 'Valmiki', 'N'),
	(106, 28, 'Satyavathi', 'N'),
	(107, 29, 'K.R Narayanan', 'N'),
	(108, 29, 'R.K Narayanan', 'Y'),
	(109, 29, 'R.K Laxman', 'N'),
	(110, 29, 'Mulk Raj Anand', 'N'),
	(111, 30, 'John Milton', 'Y'),
	(112, 30, 'William shakesphere', 'N'),
	(113, 30, 'William Wordsworth', 'N'),
	(114, 30, 'Oscar Wilde', 'N'),
	(115, 31, 'Oskar Schindler', 'N'),
	(116, 31, 'Steven Spielberg', 'N'),
	(117, 31, 'Thomas Keneally', 'Y'),
	(118, 31, 'Itzhak Stern', 'N'),
	(119, 32, 'Joseph Stalin', 'N'),
	(120, 32, 'Confusius', 'N'),
	(121, 32, 'Adolf Hitler', 'N'),
	(122, 32, 'Sun Tzu', 'Y'),
	(123, 33, 'Kalaingar Karunanithi', 'N'),
	(124, 33, 'C.N Annadhurai', 'N'),
	(125, 33, 'M.G Ramachandran', 'N'),
	(126, 33, 'E.V Ramasamy', 'Y'),
	(127, 34, 'Khan Abdul Wali Khan', 'N'),
	(128, 34, 'M.K Gandhi', 'N'),
	(129, 34, 'Khan Abdul Ghaffar Khan', 'Y'),
	(130, 34, 'Jawaharlal Nehru', 'N'),
	(131, 35, 'Dadabhai Naoroji', 'Y'),
	(132, 35, 'Rabindarnath Tagore', 'N'),
	(133, 35, 'Bal Gangardhar Tilak', 'N'),
	(134, 35, 'MK Gandhi', 'N'),
	(135, 36, 'Napolean Bonaparte', 'N'),
	(136, 36, 'Maxmillien Robesphere', 'N'),
	(137, 36, 'Joan Of Ark', 'Y'),
	(138, 36, 'Voltaire', 'N'),
	(139, 37, 'Muthulakshmi Reddy', 'N'),
	(140, 37, 'Sarojini Naidu', 'Y'),
	(141, 37, 'Mother Teresa', 'N'),
	(142, 37, 'Indira Gandhi', 'N'),
	(143, 38, 'Amristar', 'N'),
	(144, 38, 'London', 'N'),
	(145, 38, 'Sydney', 'N'),
	(146, 38, 'San Fransisco(USA)', 'Y'),
	(147, 39, 'Kanyakumari', 'N'),
	(148, 39, 'Tuticorin', 'Y'),
	(149, 39, 'Kolkatta', 'N'),
	(150, 39, 'Mumbai', 'N'),
	(151, 40, 'Paris', 'N'),
	(152, 40, 'Goa', 'N'),
	(153, 40, 'Pondicherry', 'Y'),
	(154, 40, 'Chennai', 'N'),
	(155, 41, 'Hockey', 'N'),
	(156, 41, 'Chess', 'Y'),
	(157, 41, 'Volley ball', 'N'),
	(158, 41, 'Polo', 'N'),
	(159, 42, 'Rugby', 'N'),
	(160, 42, 'Tennis', 'Y'),
	(161, 42, 'Basket ball', 'N'),
	(162, 42, 'Football', 'N'),
	(163, 43, 'Plato', 'N'),
	(164, 43, 'Galileo', 'Y'),
	(165, 43, 'Einstein', 'N'),
	(166, 43, 'Newton', 'N'),
	(167, 44, 'London', 'N'),
	(168, 44, 'Geneva', 'Y'),
	(169, 44, 'New York', 'N'),
	(170, 44, 'Sydney', 'N'),
	(171, 45, 'Saudi Arabia', 'N'),
	(172, 45, 'Ukraine', 'Y'),
	(173, 45, 'Israel', 'N'),
	(174, 45, 'Cuba', 'N'),
	(175, 46, 'Crocodile', 'N'),
	(176, 46, 'Tortoise', 'N'),
	(177, 46, 'Fish', 'N'),
	(178, 46, 'Frog', 'Y'),
	(179, 47, 'Rugby', 'N'),
	(180, 47, 'Polo', 'N'),
	(181, 47, 'Base Ball', 'Y'),
	(182, 47, 'Football', 'N'),
	(183, 48, 'Increase', 'N'),
	(184, 48, 'Decreases', 'Y'),
	(185, 48, 'No Change', 'N'),
	(186, 48, 'All the above', 'N'),
	(187, 49, 'Sound travels faster in air than Iron', 'N'),
	(188, 49, 'Sound travels faster in Iron than Air', 'Y'),
	(189, 49, 'All the above', 'N'),
	(190, 49, 'None of the above', 'N'),
	(191, 50, 'Krishna', 'N'),
	(192, 50, 'Godavari', 'N'),
	(193, 50, 'Kaveri', 'Y'),
	(194, 50, 'Ganges', 'N'),
	(195, 51, 'Indian Ocean', 'Y'),
	(196, 51, 'Pacific Ocean', 'N'),
	(197, 51, 'Atlantic Ocean', 'N'),
	(198, 51, 'Arctic Ocean', 'N'),
	(199, 52, 'Artic ocean', 'N'),
	(200, 52, 'Pacific Ocean', 'N'),
	(201, 52, 'Atlantic Ocean', 'N'),
	(202, 52, 'Indian Ocean', 'Y'),
	(203, 53, 'Jawaharlal Nehru', 'N'),
	(204, 53, 'Rajaji', 'N'),
	(205, 53, 'Subhash Chandra Bose', 'Y'),
	(206, 53, 'Bala Gangadhar Tilak', 'N'),
	(207, 54, 'India', 'N'),
	(208, 54, 'Singapore', 'Y'),
	(209, 54, 'Japan', 'N'),
	(210, 54, 'German', 'N'),
	(211, 55, 'Anne Besant', 'Y'),
	(212, 55, 'Sarojini Naidu', 'N'),
	(213, 55, 'Vivekananda', 'N'),
	(214, 55, 'Jawaharlal Nehru', 'N'),
	(215, 56, 'Two', 'N'),
	(216, 56, 'Twenty Five', 'N'),
	(217, 56, 'Fourteen', 'Y'),
	(218, 56, 'One', 'N'),
	(219, 57, 'Sutlej', 'Y'),
	(220, 57, 'Indus', 'N'),
	(221, 57, 'Yamuna', 'N'),
	(222, 57, 'Ganges', 'N'),
	(223, 58, 'Brahmaputhra', 'N'),
	(224, 58, 'Damodar', 'Y'),
	(225, 58, 'Ganges', 'N'),
	(226, 58, 'Yamuna', 'N'),
	(227, 59, 'Rajendra Chola', 'N'),
	(228, 59, 'Raja Raja Chola', 'Y'),
	(229, 59, 'Kulothunga Chola', 'N'),
	(230, 59, 'RajathiRaja Chola', 'N'),
	(231, 60, 'Rameshwaram', 'Y'),
	(232, 60, 'Madurai', 'N'),
	(233, 60, 'Trichy', 'N'),
	(234, 60, 'Chennai', 'N'),
	(235, 61, 'Volleyball', 'N'),
	(236, 61, 'Tennis', 'N'),
	(237, 61, 'Football', 'N'),
	(238, 61, 'Hockey', 'Y'),
	(239, 62, 'Ramanujam', 'N'),
	(240, 62, 'Rina Panigrahi', 'N'),
	(241, 62, 'Raja Ramanna', 'N'),
	(242, 62, 'Shakunthala Devi', 'Y'),
	(243, 63, 'Govind Ballabh Pant', 'N'),
	(244, 63, 'Jawaharlal Nehru', 'N'),
	(245, 63, 'Subhash Chandra Bose', 'N'),
	(246, 63, 'Sardar Vallabhbhai Patel', 'Y'),
	(247, 64, 'Film Direction', 'N'),
	(248, 64, 'Drawing Cartoons', 'Y'),
	(249, 64, 'Instrumental Music', 'N'),
	(250, 64, 'Classical Dance', 'N'),
	(251, 65, 'Aristotle', 'N'),
	(252, 65, 'Euclid', 'Y'),
	(253, 65, 'Pythagoras', 'N'),
	(254, 65, 'Kepler', 'N'),
	(255, 66, 'Kuchipudi', 'N'),
	(256, 66, 'Kathak', 'Y'),
	(257, 66, 'Manipuri', 'N'),
	(258, 66, 'Bahratanatyam', 'N'),
	(259, 67, 'V. Merchant', 'N'),
	(260, 67, 'P. K. Banerji', 'N'),
	(261, 67, 'Mihir Sen', 'Y'),
	(262, 67, 'Arati Saha', 'N'),
	(263, 68, 'Portugal', 'N'),
	(264, 68, 'Canada', 'Y'),
	(265, 68, 'Switzerland', 'N'),
	(266, 68, 'Congo', 'N'),
	(267, 69, 'Pop Music', 'Y'),
	(268, 69, 'Journalism', 'N'),
	(269, 69, 'Sports', 'N'),
	(270, 69, 'Acting', 'N'),
	(271, 70, 'Sanjukta Panigrahi', 'N'),
	(272, 70, 'Madhavi Mudgal', 'N'),
	(273, 70, 'Sonal Man Singh', 'N'),
	(274, 70, 'Yamini Krishnamurthy', 'Y'),
	(275, 71, 'Dr. D.R. Sengupta', 'N'),
	(276, 71, 'Dr. S.Z. Kasim', 'Y'),
	(277, 71, 'Dr. V. K. Raina', 'N'),
	(278, 71, 'Dr. H. K. Gupta', 'N'),
	(279, 72, 'Social Service', 'N'),
	(280, 72, 'Journalism', 'Y'),
	(281, 72, 'Literature', 'N'),
	(282, 72, 'Politics', 'N'),
	(283, 73, 'Florence Nightingale', 'Y'),
	(284, 73, 'Sarojini Naidu', 'N'),
	(285, 73, 'Indira Gandhi', 'N'),
	(286, 73, 'Joan of Arc', 'N'),
	(287, 74, 'Literature', 'N'),
	(288, 74, 'Music', 'Y'),
	(289, 74, 'Journalism', 'N'),
	(290, 74, 'Environment', 'N'),
	(291, 75, 'Muthuswami Dikshitar', 'Y'),
	(292, 75, 'Purandardasa', 'N'),
	(293, 75, 'Swami Thirunal', 'N'),
	(294, 75, 'None of these', 'N'),
	(295, 76, 'Social Service', 'N'),
	(296, 76, 'Stage acting', 'N'),
	(297, 76, 'Classical dance', 'N'),
	(298, 76, 'Vocal music', 'Y'),
	(299, 77, 'Napoleon', 'N'),
	(300, 77, 'Major General Rajinder Singh', 'Y'),
	(301, 77, 'T. T. Krishnamachari', 'N'),
	(302, 77, 'Sardar Patel', 'N'),
	(303, 78, 'Bismarck', 'N'),
	(304, 78, 'Eisenhower', 'N'),
	(305, 78, 'Gen. Rommel', 'Y'),
	(306, 78, 'Walter Scott', 'N'),
	(307, 79, 'Painting', 'Y'),
	(308, 79, 'Politics', 'N'),
	(309, 79, 'Dance', 'N'),
	(310, 79, 'Music', 'N'),
	(311, 80, 'Guitar', 'Y'),
	(312, 80, 'Violin', 'N'),
	(313, 80, 'sarod', 'N'),
	(314, 80, 'Tabla', 'N'),
	(315, 81, 'bicarbonates', 'N'),
	(316, 81, 'bismuthates', 'N'),
	(317, 81, 'sulphonates', 'Y'),
	(318, 81, 'nitrates', 'N'),
	(319, 82, 'detergents', 'N'),
	(320, 82, 'insecticides', 'N'),
	(321, 82, 'adhesives', 'Y'),
	(322, 82, 'moth repellents', 'N'),
	(323, 83, 'Terylene', 'N'),
	(324, 83, 'Nylon', 'Y'),
	(325, 83, 'Rayon', 'N'),
	(326, 83, 'Orlon', 'N'),
	(327, 84, 'Powder type', 'Y'),
	(328, 84, 'Liquid type', 'N'),
	(329, 84, 'Soda acid type', 'N'),
	(330, 84, 'Foam type', 'N'),
	(331, 85, 'Gypsum and Clay', 'N'),
	(332, 85, 'Clay', 'N'),
	(333, 85, 'Limestone and Clay', 'Y'),
	(334, 85, 'Limestone', 'N'),
	(335, 86, 'cupric oxide', 'N'),
	(336, 86, 'nickel oxide', 'N'),
	(337, 86, 'cobalt oxide', 'Y'),
	(338, 86, 'iron oxide', 'N'),
	(339, 87, 'Carbon', 'N'),
	(340, 87, 'Silicon', 'N'),
	(341, 87, 'Sulphur', 'Y'),
	(342, 87, 'Phosphorous', 'N'),
	(343, 88, 'By decreasing density of Soap', 'N'),
	(344, 88, 'By decreasing solubility of Soap', 'Y'),
	(345, 88, 'By increasing density of Soap', 'N'),
	(346, 88, 'By increasing solubility of Soap', 'N'),
	(347, 89, 'Salts of silicates', 'N'),
	(348, 89, 'Mixture of glycerol and alcohols', 'N'),
	(349, 89, 'Sodium or potassium salts of heavier fatty acids', 'Y'),
	(350, 89, 'Esters of heavy fatty acids', 'N'),
	(351, 90, 'collagen', 'Y'),
	(352, 90, 'carbohydrate', 'N'),
	(353, 90, 'polymer', 'N'),
	(354, 90, 'nucleic acid', 'N'),
	(355, 91, 'Musical instruments', 'N'),
	(356, 91, 'Food industry', 'N'),
	(357, 91, 'Weaving', 'N'),
	(358, 91, 'Communication', 'Y'),
	(359, 92, 'cellulose', 'Y'),
	(360, 92, 'pectin', 'N'),
	(361, 92, 'glucose', 'N'),
	(362, 92, 'amylase', 'N'),
	(363, 93, 'paint', 'N'),
	(364, 93, 'paper', 'Y'),
	(365, 93, 'ink', 'N'),
	(366, 93, 'gun powder', 'N'),
	(367, 94, 'Natural rubber', 'Y'),
	(368, 94, 'Starch', 'N'),
	(369, 94, 'Cellulose', 'N'),
	(370, 94, 'None of these', 'N'),
	(371, 95, 'Arsenous oxide', 'Y'),
	(372, 95, 'Potassium carbonate', 'N'),
	(373, 95, 'Soda ash', 'N'),
	(374, 95, 'Feldspar', 'N'),
	(375, 96, 'dicarboxylic acids', 'N'),
	(376, 96, 'monocarboxylic acids', 'Y'),
	(377, 96, 'glycerol', 'N'),
	(378, 96, 'tricarboxylic acids', 'N'),
	(379, 97, 'increase the tensile strength of cement', 'N'),
	(380, 97, 'decrease the rate of setting of cement', 'Y'),
	(381, 97, 'facilitate the formation of colloidal gel', 'N'),
	(382, 97, 'bind the particles of calcium silicate', 'N'),
	(383, 98, 'Wood and resin', 'N'),
	(384, 98, 'Wood, sodium and bleaching powder', 'N'),
	(385, 98, 'Wood, calcium, hydrogen sulphite and resin', 'Y'),
	(386, 98, 'Wood and bleaching powder', 'N'),
	(387, 99, 'graphite', 'N'),
	(388, 99, 'Synthetic petroleum', 'N'),
	(389, 99, 'fertilisers', 'Y'),
	(390, 99, 'carbide', 'N'),
	(391, 100, 'quartz and mica', 'N'),
	(392, 100, 'sand and silicates', 'Y'),
	(393, 100, 'salt and quartz', 'N'),
	(394, 100, 'sand and salt', 'N'),
	(395, 108, 'Delhi"', 'Y'),
	(396, 108, 'Chennai', 'N'),
	(397, 108, 'Mumbai', 'N'),
	(398, 108, 'Kolkatta', 'N'),
	(399, 109, 'Delhi"', 'Y'),
	(400, 109, 'Chennai', 'N'),
	(401, 109, 'Mumbai', 'N'),
	(402, 109, 'Kolkatta', 'N'),
	(403, NULL, '2', 'N'),
	(404, NULL, '3', 'Y'),
	(405, NULL, '4', 'N'),
	(406, NULL, '5', 'N'),
	(407, 3, '1', 'N'),
	(408, 3, '2', 'N'),
	(409, 3, '3', 'Y'),
	(410, 3, '4', 'N'),
	(411, NULL, 'e', 'N'),
	(412, NULL, 'y', 'N'),
	(413, NULL, '4', 'N'),
	(414, NULL, '56', 'Y'),
	(423, 111, 'Delhi"', 'Y'),
	(424, 111, 'Chennai', 'N'),
	(425, 111, 'Mumbai', 'N'),
	(426, 111, 'Kolkatta', 'N'),
	(427, 2, '2', 'N'),
	(428, 2, '3', 'Y'),
	(429, 2, '4', 'N'),
	(430, 2, '5', 'N'),
	(431, 112, '1', 'N'),
	(432, 112, '2', 'N'),
	(433, 112, '3', 'Y'),
	(434, 112, '4', 'N'),
	(435, 4, 'e', 'N'),
	(436, 4, 'y', 'N'),
	(437, 4, '4', 'N'),
	(438, 4, '56', 'Y');
/*!40000 ALTER TABLE `table_question_answers` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_question_paragraph
CREATE TABLE IF NOT EXISTS `table_question_paragraph` (
  `t_q_p_id` int unsigned NOT NULL,
  `paragraph` text CHARACTER SET utf8,
  PRIMARY KEY (`t_q_p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.table_question_paragraph: ~26 rows (approximately)
DELETE FROM `table_question_paragraph`;
/*!40000 ALTER TABLE `table_question_paragraph` DISABLE KEYS */;
INSERT INTO `table_question_paragraph` (`t_q_p_id`, `paragraph`) VALUES
	(0, 'dummy'),
	(1, 'gdgdhgf'),
	(2, '1423142'),
	(3, '<p>The instinctive, natural way to express anger is to respond aggressively. Anger is a natural, adaptive response to threats: it inspires powerful, often aggressive, feelings and behaviours, which allow us to fight and to defend ourselves when we are attacked. On the other hand, we can\'t physically lash out at every person or object that irritates or annoys us: laws, social norms and common sense place on how far our anger can take us. People use a variety of both conscious and unconscious processes to deal with their angry feelings. The three main approaches are expressing, suppressing and calming. Expressing your angry feelings in an assertive anger. Being assertive dosen\'t mean being pushy or demanding: it means being respectful of yourself and others. Anger can be suppressed and then converted or redirected. This happens when you in your anger, stop thinking about it and focus on something positive.</p>'),
	(4, '<p>The crowd surged forward through the narrow streets of Paris. There was a clatter of shutters being closed hastily by trembling hands Ã¢â‚¬â€œ the citizen of Paris knew that once the fury of the people was excited there was no telling what they might do. They came to an old house which had a workshop on the ground floor. A head popped out of the door to see what it was all about "Get him Get Thimonier! Smash his devilish machines" yelled the crowd.	They found the workshop without its owner. M.Thimonier had escaped by the back door. Now the furty of the demonstrators turned against the machines that were standing in the shop, ready to be delivered to buyers. They were systematically broken up and destroyed Ã¢â‚¬â€œ dozens of them. Only when the last wheel and spindle had been tramples under foot did the infuriated crowd recover their senses.<br/>	"That is the end of M\'Sieur Thimonier and his sewing machines", they said to one another and went home satisfied. Perhaps now they would find work, for they were all unemployed tailors and seamstresses who believed that their livelihood was threatened by that new invention.</p>'),
	(5, '<p>An upsurge of new research suggests that animals have a much higher level of brain-power than previously thought. If animal do have intelligence, how do scientists measure it? Before defining animals intelligence, scientists defined what is not intelligence instinct is not intelligence. It is a skill programmed in to an animals brain by its genetic heritage. Rote conditionings is also not intelligence. Tricks can be learned by repetition, but no real thinking is involved. Cuing, in which animals learn to do or not to do certain things by following outside signals. Does not demonstrate intelligence. Scientists believe that insight, the ability to use tools, and communication using human language are all effective measures of the mental ability of animals.<br/>When judging animals intelligence, scientists look for insight which they define as a flash of sudden understanding. When a young gorilla could not reach fruit from a tree, she noticed crates scattered about the lawn near the tree. She noticed crates into a pyramid, then climbed on them to reach her reward. The gorillas insight allowed her to solve a new problem without trial and error.</p>'),
	(6, '<p>In ancient times, a king had a boulder placed on a roadway. Then he hid himself and watched to see if anyone would remove the huge rock. Some of the kingdoms wealthiest merchants and countries came by and simply walked around it. Many loudly blamed the king for not keeping the roads clear, but none did anything about getting the stone out of the way. Then a peasant came along, carrying a load of vegetables. On approaching the boulder. The peasant laid down his burden and tried to move the stone to the side of the road. After much pushing and straining, he finally succeeded.<br/>As the peasant picked up his load of vegetables, he noticed a purse lying in the road where the boulder had been. The purse contained many gold coins and a note from the king indicating that the gold was for the person who removed the boulder from the roadway.<br/>	The peasant learned what many others never understand: Every obstacle presents an opportunity to improve one\'s condition.</p>'),
	(7, '<p>Whatever the problem, someone can always oversimplify it. Sometimes a problem is simpler than it seems at first sight, and a cool mind can point to an easy answer. More often though, the simple answers don\'t really meet the case. A great scientist of an earlier day, Sir Arthur Eddington, once said that we often think all about two, because "two is one and one" We forget that we still have to make a study of "and". <br/>There\'s an important point here, an extra factor in the equation. Whether we are dealing with fellow humans, or even with observed "scientific fact", one and one often make more than two, because there\'s a relationship as well as a number. There\'s a mysterious chemistry that alters things, just through their being together. One think which makes paintings fascinating and demanding is allowing for this. Put a spot of bright yellow paint on a background of grey, and the yellow spot on a bright blue background, and the tallow looks duller and smaller. The same color is changed by what\'s around it\'s changed by relationship.</p>'),
	(8, '<p>The clergyman was finishing the graveside service. Suddenly, the 78-year-old man whose wife of 50 years had just died began screaming in a thick accent, "Oh oh, oh, how I loved her!" His mournful wail interrupted the dignified quiet of the ceremony. The other family and friends standing around the grave looked shocked and embarrassed. His grown children, blushing, tried to shush ther father. "It\'s okey, Dad: we understand. Shush." The old man stared fixedly at the casket lowering slowly into the grave. The clergyman went on. Finished, he invited the family to shovel some dirt into the coffin as a mark of the finality of death. Each , in turn, did so with the exception of the old man. "Oh how I loved her !" he moaned loudly. His daughter and two sons again tried to restrain him, but he continued, "I loved her !" Now, as the rest of those gathered around began leaving the grave, the old man stubbornly resisted. He stayed. Staring into the grave. The clergyman approached. "I know how you must feel, but it\'s time to leave. We all must leave and go on with life.""Oh, how I loved her !" the old man moaned, miserably. "You don\'t understand," he said to the clergyman. I" almost told her once."</p>'),
	(9, 'The cyber-world is ultimately ungovernable. This is alarming well as convenient; sometimes, convenient because alarming. Some Indian politicians use this to great advantage. When there is an obvious failure in governance during a crisis they deflect attention from their own incompetence towards the ungovernable. So, having failed to prevent nervous citizens from fleeing their cities of work by assuring them of proper protection, some national leaders are now busy trying to prove to one another, and to panic-prone Indians, that a  mischievous neighbor has been using the internet and social networking sites to spread dangerous rumors. And the Centre\'s automatic reaction is to start blocking these sites and begin elaborate and potentially endless negotiations with Google, Twitter and Facebook about access to information. If this is the official idea of prompt action at a time of crisis among communities, then Indians have more reason to fear their protectors than the nebulous mischief-makers of the cyber-world. Wasting time gathering proof, blocking vaguely suspicious-websites, hurling accusations across the border and worrying about bilateral relations are ways of keeping busy with inessentials because one does not quite know what to do about the essentials of a difficult situation. Besides, only a fifth of the 245 websites blocked by the Centre mention the people of the Northeast or the violence in Assam. And if a few morphed images and spurious texts can unsettle an entire nation, then there is something deeply wrong with the nation and with how it is being governed. This is what its leaders should be addressing immediately, rather than making a wrong heading display of their powers of censorship.<br/>	It is just as absurd, and part of the same syndrome, to try to ban Twitter accounts that parody dispatches from the Prime Minister\'s Office. To describe such forms of humor and dissent as "misrepresenting" the PMO-as if Twitters would take these parodies for genuine dispatches from the PMO-makes the PMO look more ridiculous than its parodists manage to. With the precedent for such action set recently by the chief minister of West Bengal, this is yet another proof that what Bengal thinks today India will think tomorrow. Using the cyber-world for flexing the wrong muscles is essentially not funny. It might even prove to be quite dangerously distracting.'),
	(10, '<p>"Nobody knows my name" is the title of one James Baldwin\'s celebrated books. Who knows the mane of the old man sitting amidst ruins pondering over his hubble-bubble? We do not. It does not matter. He is there like the North Pole, the Everest and the Alps but with one difference. The North Pole, the Everest and the Alps will be there when he is not there any more. Can we really say this? "Dust thou act to dust returneth" was not spoken of the soul. We do not know whether the old man\'s soul will go marching on like john Brown\'s. while his body lies moldering in the grave or becomes ash driven by the wind or is immersed in water, such speculation is hazardous. A soul\'s trip can take one to the treacherous shoals of metaphysics where there is no "yes" or "no". who am I? asked Tagore of the rising sun in the first dawn of his life, he received no answer. "Who am I?" he asked the setting sun in the last twilight of his. He received no answer.<br/>	We are no more on solid ground with dust which we can feel in our hands, scatter to the wind and wet with water to turn it into mud. For this much is sure, that in the end, when life\'s ceaseless labor grinds to a halt and man meets death, the brother of sleep, his body buried or burnt, becomes dust. In the form of dust he lives, inanimate yet in contact with the animate. He settles on files in endless government almirahs, on manuscripts written and not published on all shelves, on faces and hands. He becomes ubiquitous all pervasive, sometimes sneaking even into hermetically sealed chambers.<br/></p>'),
	(11, '<p>To write well you have to be able to write clearly and logically, and you cannot do this unless you can think clearly and logically. If you cannot do this yet you should train yourself to do it by taking particular problems and without leaving anything out and without avoiding any difficulties that you meet.<br/>	At first you find clear, step-by-step thought very difficult. You may find that your mind is not able to concentrate. Several unconnected ideas may occur together. But practice will improve your ability to concentrate on a single idea and think about it clearly and logically. In order to increase your vocabulary and to improve your style, you should read widely and use a good dictionary to help you find the exact meanings and correct usages of words.<br/>	Always remember that regular and frequent practice is necessary if you want to learn to write well. It is no good waiting until you have an inspiration before you write. Even with the most famous writers, inspiration is rare. Someone said that writing is ninety-nine per cent hard work and one per cent inspiration, so the sooner you get into the habit of disciplining yourself to write, the better.<br/></p>'),
	(12, '<p>Once upon an unfortunate time, there was a hairy thing called \'man\' . along with him was a hairier thing called \'animal\'. Man had a larger brain which made him think he was superior to animals. Some men thought they were superior to others. They became leader men. Leader men said \'We have no need to work: we will kill animals to eat.\' So they did. Man increased and animals decreased. Eventually leader men said, \'There are not enough animals left to eat. We must grow our own food.\' So man grew food. Everywhere man killed all wild life. Soon there was none and all the birds were poisoned. Leader men said, \'At last we are free of pests.\'<br/>	Man\'s numbers increased. The world became crowded with men. They all had to sleep standing up. One day a leader man saw some new creatures eating his crops. The creature\'s name was \'the starving people\'. These creature are a menace!\' said the leader man. <br/></p>'),
	(13, '<p>The great advantage of early rising is the good start it gives for one\'s daily work. The early riser is able to complete a lot of work before others even get out of their bed . As the mind is fresh in the morning, free from distractions, one is able to do quality work. One is able, if so inclined, to have early morning exercises which keep one energetic throughout the day. Thus one completes one\'s work during the day without hurrying much and is left with time in the evening for play or entertainment or relaxation by a leisurely walk. This leads to a good night\'s rest after which one is able to rise fresh the next morning to face another day.</p>'),
	(14, '<p>Every profession or trade, every art and every since has its technical vocabulary, the function of which is party to designate things or processes which have no names in ordinary English and party to secure greater exactness in nomenclature. Such special dialects or jargons are necessary in technical discussion of any kind. Being universally understood by the devotees of the particular since or art, they have the precision of a mathematical formula. Besides, they save time, for it is much more economical to name a process than to describe it. Thousands of these technical terms are very property included in every large dictionary, yet, as a whole, they are rather on the outskirts of the English language than actually within its borders.<br/>	Different occupations, however, differ widely in the character of their special vocabularies. In trades and handicrafts and other vocations like farming and fishing that have occupied great numbers of men from remote times, the technical vocabulary is very old. An average man now uses these in his own vocabulary. The special dialects of law, medicine, divinity and philosophy have become familiar to cultivated persons.</p>'),
	(15, '<p>Gregor Mendal appropriately called "Father of Genetics", joined as supply teacher at Brunn to study Natural sciences and Mathematics. During his tenure in teaching, he started his historic experiments with Garden Peas (Pisum Sativum) in the monastery garden. It was an annual plant with well defined characteristics. Flowers were bisexual and self fertilized, through many generation of natural self fertilization garden peas had developed into pure lines. He selected seven pairs of contrasting characters among pea plants and all were related as dominant and recessive fortunately.</p>'),
	(16, '<p>Steel and Aluminium have higher bulk and shear modulus than lead. But they are less dense than lead. Three rods. A, B, C made up of Steel, Aluminium and Lead respectively have identical shape and size.</p>'),
	(17, '<p>Directions (1-5) : Study the following information carefully and answer the given questions.<br />\r\n<strong>Data regarding number of graduates studying various courses in University A and that in University B in the year 2001.</strong></p>\r\n\r\n<p>(Note : Universities A and B offer courses in six Courses only, namely Commerce, Science, Engineering, Arts, Management and Law.)</p>\r\n\r\n<ul>\r\n	<li>In University A, Graduates in commerce, science and engineering together constituted 60% of the total number of graduates (in all the given six courses together). Graduates in Arts, Management and Law were 1300, 1440 and 860 respectively. Commerce graduates were 25% more than that of engineering graduates. Management graduates were 20% less than that of science graduates.</li>\r\n	<li>In University B, commerce graduates were 10% less than the commerce graduates in University A.</li>\r\n	<li>In University B, management graduates were 900 and they constituted 12% of the total number of graduates (in all the given six courses together). Also management graduates were 40% less than that of science graduates. Total number of graduates in engineering and arts together were double the total number of graduates in management and law together.</li>\r\n</ul>\r\n'),
	(18, '<table align="left" border="1" cellpadding="2" cellspacing="0">\r\n	<tbody>\r\n		<tr>\r\n			<td style="text-align:center"><strong>Name of the Batsman</strong></td>\r\n			<td style="text-align:center"><strong>Number if matches<br />\r\n			played in the tournament</strong></td>\r\n			<td style="text-align:center"><strong>Average runs scored<br />\r\n			in the tournament</strong></td>\r\n			<td style="text-align:center"><strong>Total balls faced<br />\r\n			in the tournament</strong></td>\r\n			<td style="text-align:center"><strong>Strike rate<br />\r\n			in the tournament</strong></td>\r\n		</tr>\r\n		<tr>\r\n			<td style="text-align:center"><strong>M</strong></td>\r\n			<td style="text-align:center"><strong>22</strong></td>\r\n			<td style="text-align:center"><strong>56</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n		</tr>\r\n		<tr>\r\n			<td style="text-align:center"><strong>N</strong></td>\r\n			<td style="text-align:center"><strong>18</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n			<td style="text-align:center"><strong>153.6</strong></td>\r\n		</tr>\r\n		<tr>\r\n			<td style="text-align:center"><strong>O</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n			<td style="text-align:center"><strong>900</strong></td>\r\n			<td style="text-align:center"><strong>110</strong></td>\r\n		</tr>\r\n		<tr>\r\n			<td style="text-align:center"><strong>P</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n			<td style="text-align:center"><strong>36</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n			<td style="text-align:center"><strong>84</strong></td>\r\n		</tr>\r\n		<tr>\r\n			<td style="text-align:center"><strong>Q</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n			<td style="text-align:center"><strong>140</strong></td>\r\n		</tr>\r\n		<tr>\r\n			<td style="text-align:center"><strong>R</strong></td>\r\n			<td style="text-align:center"><strong>24</strong></td>\r\n			<td style="text-align:center"><strong>51</strong></td>\r\n			<td style="text-align:center"><strong>1368</strong></td>\r\n			<td style="text-align:center"><strong>-</strong></td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n<p>(i) Strike rate = &nbsp;\\( \\large\\frac{Total runs scored}{ Total balls faced} \\) x 100<br />\r\n(ii) All the given batsmen could bat in all the given matches played by them.<br />\r\n(iii) Few values are missing in the table (indicated by &nbsp;-- ). A candidate is expected to calculate the missing value, if it is required to answer the given questions, on the basis of the given data and information.&nbsp;</p>\r\n'),
	(19, '<p><strong>Direction (15-19):</strong>&nbsp;|~|In these questions, a number series is given. Only one number is wrong which doesn&#39;t fit in the series. Find out the wrong numbers.</p>\n'),
	(20, '<p><strong>Directions (26-30) :</strong> Refer to the pie charts and answer the given questions.</p>\r\n\r\n<p><strong>Distribution of total number of members (both male and female) in 5 health clubs in 2008 Total number = 4200 </strong></p>\r\n\r\n<p><strong><img alt="" src="http://competoid.com/pictures/grpQues/g-20-1.jpg" /></strong></p>\r\n\r\n<p><strong>Distribution of total number of male members in 5 health clubs in 2008 Total number = 2400&nbsp;</strong></p>\r\n\r\n<p><strong><img alt="" src="http://competoid.com/pictures/grpQues/g-20-2.jpg" /></strong></p>\r\n'),
	(21, '<p><strong>Directions (31-33) : </strong>|~|In these questions, a statement is given followed by two sets of conclusions numbered I and II. These statements show relationship between different elements. You have to assume the statement to be true and then decide which of the given conclusions logically follows from the information given in the statement.</p>\n\n<p><strong>Given answer :</strong><br />\n(1) If neither conclusion I nor II is true.<br />\n(2) If either conclusion I or II is true.<br />\n(3) If only conclusion II is true.<br />\n(4) If both conclusion I and II are true.<br />\n(5) If only conclusions I is true.&nbsp;</p>\n'),
	(22, '<p>Directions (35-39) :|~| Study the following information carefully and answer the given questions.&nbsp;When a word and number arrangement machine is given an input line of words and numbers, it arranges them following a particular rule. The following is an illustration of input and rearrangement (All the numbers are two-digit numbers).</p>\n\n<p><strong>Inpu</strong>t : bear 24 binders brave 91 17 but 68 bailer 35 be 74<br />\n<strong>Step I :</strong> 19 bear 24 binders brave 17 but 68 bailer 35 74 be<br />\n<strong>Step II :</strong> 47 19 bear 24 binders brave 17 68 bailer 35 be but<br />\n<strong>Step III </strong>: 86 47 19 24 binders brave 17 bailer 35 be but bear<br />\n<strong>Step IV :</strong> 53 86 47 19 24 binders 17 bailer be but bear brave<br />\n<strong>Step V :</strong> 42 53 86 47 19 binders 17 be but bear brave bailer<br />\n<strong>Step VI :</strong> 71 42 53 86 47 19 be but bear brave bailer binders<br />\n<strong>Step VII</strong> is the last step of the above arrangement as the intended arrangement is obtained.</p>\n\n<p>As per the rules followed in the given steps, find out the appropriate steps for the given input.<br />\n<strong>Input:</strong> tyre 71 tough 59 tip 82 13 thanks to 68 table 46&nbsp;</p>\n'),
	(23, '<p><strong>Directions (40-41) :</strong>|~| Study the following information and answer the given questions.<br />\nD is the father of A. D is married to P. P is the mother of J. P has only one daughter. J is married to U. U is the son of L.</p>\n'),
	(24, '<p><strong>Directions (42-47) :</strong>|~| Study the following information carefully and answer the given questions.<br />\nEight family members S, T, U, V, W, X, Y and Z are sitting around a circular table but not necessarily in the same order. Some of them are females and some are males. All of them are related to each other in the same way or the other. Some of them are facing the centre while some are facing outside (Le. opposite to the centre).</p>\n\n<p>Only two people sit between T and W. T faces the centre. X sits second to the right of T. W is the wife of S. No female is an immediate neighbour of W. U is not an immediate neighbour of T. U is the daughter of W. Both the immediate neighbours of U face the centre. Only three people sit between S and U&rsquo;s brother. X is not the brother of U. Neither S nor U&rsquo;s brother is an immediate neighbour of X. &nbsp;Z, the wife of T, sits to the immediate left of V. Both Y and S face a direction opposite to that of U (i.e. if U faces the centre then both Y and S face outside and vice versa). U&rsquo;s husband sits second to the left of Y. T&rsquo;s father sits to the immediate right of W.</p>\n\n<p>T sits second to the right of S&#39;s father. Both the immediate neighbours of X are females.</p>\n'),
	(25, '<p><strong>Directions (50-52) :</strong> |~|In these questions, three statements are given followed by two conclusions numbered I and II. You have to consider the statements to be true . even if they seem to be at variance from commonly known facts. You have to decide which of the given conclusions, if any, follow from the given statements.</p>\n\n<p><strong>Give answer : </strong></p>\n\n<p>(1) If <strong>either</strong> conclusion I <strong>or</strong> II is true</p>\n\n<p>(2) If <strong>neither</strong> conclusion I <strong>nor</strong> II is true</p>\n\n<p>(3) If <strong>both</strong> conclusions I and II are true</p>\n\n<p>&nbsp;(4) If <strong>only</strong> conclusion I is true</p>\n\n<p>(5) If <strong>only</strong> conclusion II is true</p>\n');
/*!40000 ALTER TABLE `table_question_paragraph` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_question_section
CREATE TABLE IF NOT EXISTS `table_question_section` (
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

-- Dumping data for table sangam_uat.table_question_section: ~6 rows (approximately)
DELETE FROM `table_question_section`;
/*!40000 ALTER TABLE `table_question_section` DISABLE KEYS */;
INSERT INTO `table_question_section` (`t_q_s_id`, `section_title`, `description`, `depth`, `depth_round_id`, `extra_info`, `meta_keywords`) VALUES
	(1, 'Sample', 'Thsi is to test', 1, 1, NULL, NULL),
	(2, 'GK1', 'Thsi is to test', 1, 1, NULL, NULL),
	(3, 'GK2', 'Thsi is to test', 1, 1, NULL, NULL),
	(4, 'GK3', 'Thsi is to test', 1, 1, NULL, NULL),
	(5, 'GK4', 'Thsi is to test', 1, 1, NULL, NULL),
	(11, 'GK5', 'Thsi is to test', 1, 1, NULL, NULL);
/*!40000 ALTER TABLE `table_question_section` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_seq
CREATE TABLE IF NOT EXISTS `table_seq` (
  `next_val` bigint DEFAULT NULL,
  `next_task_id` bigint DEFAULT NULL,
  `next_log_id` bigint DEFAULT NULL,
  `next_user_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='This table is responsible for generating sequence for all other tables';

-- Dumping data for table sangam_uat.table_seq: ~1 rows (approximately)
DELETE FROM `table_seq`;
/*!40000 ALTER TABLE `table_seq` DISABLE KEYS */;
INSERT INTO `table_seq` (`next_val`, `next_task_id`, `next_log_id`, `next_user_id`) VALUES
	(1677, 2064, 1120, 1000);
/*!40000 ALTER TABLE `table_seq` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_task
CREATE TABLE IF NOT EXISTS `table_task` (
  `t_t_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `effort_hrs` int DEFAULT NULL,
  `sl_no` int NOT NULL DEFAULT '0' COMMENT 'If tasks are created from xl sl no will be added otherwise 0 will be added as default',
  `folder_id` varchar(250) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`t_t_id`),
  KEY `FK_table_task_table_folder` (`folder_id`),
  CONSTRAINT `FK_table_task_table_folder` FOREIGN KEY (`folder_id`) REFERENCES `table_folder` (`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='All Task realted info is stored in this table. Task_log will have other details associated with this task.';

-- Dumping data for table sangam_uat.table_task: ~133 rows (approximately)
DELETE FROM `table_task`;
/*!40000 ALTER TABLE `table_task` DISABLE KEYS */;
INSERT INTO `table_task` (`t_t_id`, `title`, `description`, `effort_hrs`, `sl_no`, `folder_id`) VALUES
	('TSK00000001', 'Thirukural Athikaram 1', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram1', 4, 0, 'FOL000001'),
	('TSK00000002', 'Thirukural Athikaram 2', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram2', 4, 0, 'FOL000002'),
	('TSK00000003', 'Thirukural Athikaram 3', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram3', 4, 0, 'FOL000003'),
	('TSK00000004', 'Thirukural Athikaram 4', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram4', 4, 0, 'FOL000004'),
	('TSK00000005', 'Thirukural Athikaram 5', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram5', 4, 0, 'FOL000005'),
	('TSK00000006', 'Thirukural Athikaram 6', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram6', 4, 0, 'FOL000006'),
	('TSK00000007', 'Thirukural Athikaram 7', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram7', 4, 0, 'FOL000007'),
	('TSK00000008', 'Thirukural Athikaram 8', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram8', 4, 0, 'FOL000008'),
	('TSK00000009', 'Thirukural Athikaram 9', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram9', 4, 0, 'FOL000009'),
	('TSK00000010', 'Thirukural Athikaram 10', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram10', 4, 0, 'FOL000010'),
	('TSK00000011', 'Thirukural Athikaram 11', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram11', 4, 0, 'FOL000011'),
	('TSK00000012', 'Thirukural Athikaram 12', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram12', 4, 0, 'FOL000012'),
	('TSK00000013', 'Thirukural Athikaram 13', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram13', 4, 0, 'FOL000013'),
	('TSK00000014', 'Thirukural Athikaram 14', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram14', 4, 0, 'FOL000014'),
	('TSK00000015', 'Thirukural Athikaram 15', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram15', 4, 0, 'FOL000015'),
	('TSK00000016', 'Thirukural Athikaram 16', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram16', 4, 0, 'FOL000016'),
	('TSK00000017', 'Thirukural Athikaram 17', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram17', 4, 0, 'FOL000017'),
	('TSK00000018', 'Thirukural Athikaram 18', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram18', 4, 0, 'FOL000018'),
	('TSK00000019', 'Thirukural Athikaram 19', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram19', 4, 0, 'FOL000019'),
	('TSK00000020', 'Thirukural Athikaram 20', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram20', 4, 0, 'FOL000020'),
	('TSK00000021', 'Thirukural Athikaram 21', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram21', 4, 0, 'FOL000021'),
	('TSK00000022', 'Thirukural Athikaram 22', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram22', 4, 0, 'FOL000022'),
	('TSK00000023', 'Thirukural Athikaram 23', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram23', 4, 0, 'FOL000023'),
	('TSK00000024', 'Thirukural Athikaram 24', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram24', 4, 0, 'FOL000024'),
	('TSK00000025', 'Thirukural Athikaram 25', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram25', 4, 0, 'FOL000025'),
	('TSK00000026', 'Thirukural Athikaram 26', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram26', 4, 0, 'FOL000026'),
	('TSK00000027', 'Thirukural Athikaram 27', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram27', 4, 0, 'FOL000027'),
	('TSK00000028', 'Thirukural Athikaram 28', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram28', 4, 0, 'FOL000028'),
	('TSK00000029', 'Thirukural Athikaram 29', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram29', 4, 0, 'FOL000029'),
	('TSK00000030', 'Thirukural Athikaram 30', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram30', 4, 0, 'FOL000030'),
	('TSK00000031', 'Thirukural Athikaram 31', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram31', 4, 0, 'FOL000031'),
	('TSK00000032', 'Thirukural Athikaram 32', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram32', 4, 0, 'FOL000032'),
	('TSK00000033', 'Thirukural Athikaram 33', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram33', 4, 0, 'FOL000033'),
	('TSK00000034', 'Thirukural Athikaram 34', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram34', 4, 0, 'FOL000034'),
	('TSK00000035', 'Thirukural Athikaram 35', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram35', 4, 0, 'FOL000035'),
	('TSK00000036', 'Thirukural Athikaram 36', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram36', 4, 0, 'FOL000036'),
	('TSK00000037', 'Thirukural Athikaram 37', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram37', 4, 0, 'FOL000037'),
	('TSK00000038', 'Thirukural Athikaram 38', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram38', 4, 0, 'FOL000038'),
	('TSK00000039', 'Thirukural Athikaram 39', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram39', 4, 0, 'FOL000039'),
	('TSK00000040', 'Thirukural Athikaram 40', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram40', 4, 0, 'FOL000040'),
	('TSK00000041', 'Thirukural Athikaram 41', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram41', 4, 0, 'FOL000041'),
	('TSK00000042', 'Thirukural Athikaram 42', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram42', 4, 0, 'FOL000042'),
	('TSK00000043', 'Thirukural Athikaram 43', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram43', 4, 0, 'FOL000043'),
	('TSK00000044', 'Thirukural Athikaram 44', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram44', 4, 0, 'FOL000044'),
	('TSK00000045', 'Thirukural Athikaram 45', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram45', 4, 0, 'FOL000045'),
	('TSK00000046', 'Thirukural Athikaram 46', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram46', 4, 0, 'FOL000046'),
	('TSK00000047', 'Thirukural Athikaram 47', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram47', 4, 0, 'FOL000047'),
	('TSK00000048', 'Thirukural Athikaram 48', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram48', 4, 0, 'FOL000048'),
	('TSK00000049', 'Thirukural Athikaram 49', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram49', 4, 0, 'FOL000049'),
	('TSK00000050', 'Thirukural Athikaram 50', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram50', 4, 0, 'FOL000050'),
	('TSK00000051', 'Thirukural Athikaram 51', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram51', 4, 0, 'FOL000051'),
	('TSK00000052', 'Thirukural Athikaram 52', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram52', 4, 0, 'FOL000052'),
	('TSK00000053', 'Thirukural Athikaram 53', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram53', 4, 0, 'FOL000053'),
	('TSK00000054', 'Thirukural Athikaram 54', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram54', 4, 0, 'FOL000054'),
	('TSK00000055', 'Thirukural Athikaram 55', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram55', 4, 0, 'FOL000055'),
	('TSK00000056', 'Thirukural Athikaram 56', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram56', 4, 0, 'FOL000056'),
	('TSK00000057', 'Thirukural Athikaram 57', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram57', 4, 0, 'FOL000057'),
	('TSK00000058', 'Thirukural Athikaram 58', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram58', 4, 0, 'FOL000058'),
	('TSK00000059', 'Thirukural Athikaram 59', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram59', 4, 0, 'FOL000059'),
	('TSK00000060', 'Thirukural Athikaram 60', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram60', 4, 0, 'FOL000060'),
	('TSK00000061', 'Thirukural Athikaram 61', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram61', 4, 0, 'FOL000061'),
	('TSK00000062', 'Thirukural Athikaram 62', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram62', 4, 0, 'FOL000062'),
	('TSK00000063', 'Thirukural Athikaram 63', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram63', 4, 0, 'FOL000063'),
	('TSK00000064', 'Thirukural Athikaram 64', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram64', 4, 0, 'FOL000064'),
	('TSK00000065', 'Thirukural Athikaram 65', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram65', 4, 0, 'FOL000065'),
	('TSK00000066', 'Thirukural Athikaram 66', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram66', 4, 0, 'FOL000066'),
	('TSK00000067', 'Thirukural Athikaram 67', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram67', 4, 0, 'FOL000067'),
	('TSK00000068', 'Thirukural Athikaram 68', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram68', 4, 0, 'FOL000068'),
	('TSK00000069', 'Thirukural Athikaram 69', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram69', 4, 0, 'FOL000069'),
	('TSK00000070', 'Thirukural Athikaram 70', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram70', 4, 0, 'FOL000070'),
	('TSK00000071', 'Thirukural Athikaram 71', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram71', 4, 0, 'FOL000071'),
	('TSK00000072', 'Thirukural Athikaram 72', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram72', 4, 0, 'FOL000072'),
	('TSK00000073', 'Thirukural Athikaram 73', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram73', 4, 0, 'FOL000073'),
	('TSK00000074', 'Thirukural Athikaram 74', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram74', 4, 0, 'FOL000074'),
	('TSK00000075', 'Thirukural Athikaram 75', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram75', 4, 0, 'FOL000075'),
	('TSK00000076', 'Thirukural Athikaram 76', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram76', 4, 0, 'FOL000076'),
	('TSK00000077', 'Thirukural Athikaram 77', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram77', 4, 0, 'FOL000077'),
	('TSK00000078', 'Thirukural Athikaram 78', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram78', 4, 0, 'FOL000078'),
	('TSK00000079', 'Thirukural Athikaram 79', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram79', 4, 0, 'FOL000079'),
	('TSK00000080', 'Thirukural Athikaram 80', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram80', 4, 0, 'FOL000080'),
	('TSK00000081', 'Thirukural Athikaram 81', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram81', 4, 0, 'FOL000081'),
	('TSK00000082', 'Thirukural Athikaram 82', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram82', 4, 0, 'FOL000082'),
	('TSK00000083', 'Thirukural Athikaram 83', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram83', 4, 0, 'FOL000083'),
	('TSK00000084', 'Thirukural Athikaram 84', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram84', 4, 0, 'FOL000084'),
	('TSK00000085', 'Thirukural Athikaram 85', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram85', 4, 0, 'FOL000085'),
	('TSK00000086', 'Thirukural Athikaram 86', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram86', 4, 0, 'FOL000086'),
	('TSK00000087', 'Thirukural Athikaram 87', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram87', 4, 0, 'FOL000087'),
	('TSK00000088', 'Thirukural Athikaram 88', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram88', 4, 0, 'FOL000088'),
	('TSK00000089', 'Thirukural Athikaram 89', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram89', 4, 0, 'FOL000089'),
	('TSK00000090', 'Thirukural Athikaram 90', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram90', 4, 0, 'FOL000090'),
	('TSK00000091', 'Thirukural Athikaram 91', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram91', 4, 0, 'FOL000091'),
	('TSK00000092', 'Thirukural Athikaram 92', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram92', 4, 0, 'FOL000092'),
	('TSK00000093', 'Thirukural Athikaram 93', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram93', 4, 0, 'FOL000093'),
	('TSK00000094', 'Thirukural Athikaram 94', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram94', 4, 0, 'FOL000094'),
	('TSK00000095', 'Thirukural Athikaram 95', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram95', 4, 0, 'FOL000095'),
	('TSK00000096', 'Thirukural Athikaram 96', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram96', 4, 0, 'FOL000096'),
	('TSK00000097', 'Thirukural Athikaram 97', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram97', 4, 0, 'FOL000097'),
	('TSK00000098', 'Thirukural Athikaram 98', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram98', 4, 0, 'FOL000098'),
	('TSK00000099', 'Thirukural Athikaram 99', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram99', 4, 0, 'FOL000099'),
	('TSK00000100', 'Thirukural Athikaram 100', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram100', 4, 0, 'FOL000100'),
	('TSK00000101', 'Thirukural Athikaram 101', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram101', 4, 0, 'FOL000101'),
	('TSK00000102', 'Thirukural Athikaram 102', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram102', 4, 0, 'FOL000102'),
	('TSK00000103', 'Thirukural Athikaram 103', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram103', 4, 0, 'FOL000103'),
	('TSK00000104', 'Thirukural Athikaram 104', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram104', 4, 0, 'FOL000104'),
	('TSK00000105', 'Thirukural Athikaram 105', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram105', 4, 0, 'FOL000105'),
	('TSK00000106', 'Thirukural Athikaram 106', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram106', 4, 0, 'FOL000106'),
	('TSK00000107', 'Thirukural Athikaram 107', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram107', 4, 0, 'FOL000107'),
	('TSK00000108', 'Thirukural Athikaram 108', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram108', 4, 0, 'FOL000108'),
	('TSK00000109', 'Thirukural Athikaram 109', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram109', 4, 0, 'FOL000109'),
	('TSK00000110', 'Thirukural Athikaram 110', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram110', 4, 0, 'FOL000110'),
	('TSK00000111', 'Thirukural Athikaram 111', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram111', 4, 0, 'FOL000111'),
	('TSK00000112', 'Thirukural Athikaram 112', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram112', 4, 0, 'FOL000112'),
	('TSK00000113', 'Thirukural Athikaram 113', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram113', 4, 0, 'FOL000113'),
	('TSK00000114', 'Thirukural Athikaram 114', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram114', 4, 0, 'FOL000114'),
	('TSK00000115', 'Thirukural Athikaram 115', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram115', 4, 0, 'FOL000115'),
	('TSK00000116', 'Thirukural Athikaram 116', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram116', 4, 0, 'FOL000116'),
	('TSK00000117', 'Thirukural Athikaram 117', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram117', 4, 0, 'FOL000117'),
	('TSK00000118', 'Thirukural Athikaram 118', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram118', 4, 0, 'FOL000118'),
	('TSK00000119', 'Thirukural Athikaram 119', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram119', 4, 0, 'FOL000119'),
	('TSK00000120', 'Thirukural Athikaram 120', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram120', 4, 0, 'FOL000120'),
	('TSK00000121', 'Thirukural Athikaram 121', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram121', 4, 0, 'FOL000121'),
	('TSK00000122', 'Thirukural Athikaram 122', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram122', 4, 0, 'FOL000122'),
	('TSK00000123', 'Thirukural Athikaram 123', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram123', 4, 0, 'FOL000123'),
	('TSK00000124', 'Thirukural Athikaram 124', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram124', 4, 0, 'FOL000124'),
	('TSK00000125', 'Thirukural Athikaram 125', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram125', 4, 0, 'FOL000125'),
	('TSK00000126', 'Thirukural Athikaram 126', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram126', 4, 0, 'FOL000126'),
	('TSK00000127', 'Thirukural Athikaram 127', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram127', 4, 0, 'FOL000127'),
	('TSK00000128', 'Thirukural Athikaram 128', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram128', 4, 0, 'FOL000128'),
	('TSK00000129', 'Thirukural Athikaram 129', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram129', 4, 0, 'FOL000129'),
	('TSK00000130', 'Thirukural Athikaram 130', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram130', 4, 0, 'FOL000130'),
	('TSK00000131', 'Thirukural Athikaram 131', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram131', 4, 0, 'FOL000131'),
	('TSK00000132', 'Thirukural Athikaram 132', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram132', 4, 0, 'FOL000132'),
	('TSK00000133', 'Thirukural Athikaram 133', 'Every singlie Kural should go in its specific cell in slides xl. Form slideshow for all thirukurals in  athikaram133', 4, 0, 'FOL000133');
/*!40000 ALTER TABLE `table_task` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_team
CREATE TABLE IF NOT EXISTS `table_team` (
  `t_t_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AUTO_INCREMENT',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `summary` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `detailed_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`t_t_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='Have the data about all teams. Team id 1 to 1000 is reserved for internal maintenance teams. ';

-- Dumping data for table sangam_uat.table_team: ~12 rows (approximately)
DELETE FROM `table_team`;
/*!40000 ALTER TABLE `table_team` DISABLE KEYS */;
INSERT INTO `table_team` (`t_t_id`, `name`, `summary`, `detailed_description`) VALUES
	('TEM000001', 'Admins', 'Admin - responsible for all admin works', ' production support team\r\n\r\n This team  is responsible for smooth running of website  in production. It monitors the live performance of website,  analysis the data  and advices development team for any enhancements. \r\n\r\nThis team monitors the error logs.  In case of errors, this team create a task and assign to specific   queue.'),
	('TEM000002', 'Maintenance', 'Application maintenance', 'This team is responsible for overall maintenance of the website.  Below are the roles and responsibilities of this team. \r\nHandles User query feedback and comments.\r\nMaintains teams by updating its members and their roles and responsibilities\r\nManages KT for interested  contributors, setting up the development environment in the contributors machine.\r\nResponsible for backup and deletion of stale data\r\nManages development and testing environment.\r\n\r\nHandles query, feedback, comments.\r\n					provides sample postman request data which is in sync with latest updates\r\n					provides sample DB data for development\r\n				maintenance of environments\r\n					creates new teams based on requirements\r\n					Maintains roles and responsibilities acorss the application.\r\n					backup and deletion strategy\r\n	KT and aritfacts maintenance, GIT, maintenance of KT videos, support for installing dev environment\r\n'),
	('TEM000003', 'Java Development', 'Backend Java Development', 'Java Development: This team is responsible for overall Java development.  Java architect will be a lead of this team.  individual developers will be assigned with a specific task by team lead. Once assigned tasks are completed it will be committed in GitHub.  once the overall development is over, the the new code will be fixed and deployed by integration and deployment team.\r\n\r\n\r\nUtils development:  we have utilities developed in excel using VB.  These tools needs constant upgradation and development  to be in sync with new developments.\r\n'),
	('TEM000004', 'SQL Development', 'SQL Development', '\r\n	SQL development: This team is responsible for overall database design and development.  Contributors will be assigned with specific task by team lead. once the task are completed the developed code will be committed in GitHub. Once the overall development is over, the the new code will be fixed and deployed by integration and deployment team.\r\n'),
	('TEM000005', 'Integration and deployment', 'Build latest code and deploy', ' once the  development is  completed this team pics up the latest code  to build and deploy.'),
	('TEM000006', '', 'Laborum vel voluptatem incidunt. Vel consequatur odit officiis veniam qui et.', 'Mock Turtle, \'they--you\'ve seen them, of course?\' \'Yes,\' said Alice to herself. At this moment Alice felt dreadfully puzzled. The Hatter\'s remark seemed to be a lesson to you never to lose YOUR.'),
	('TEM000007', 'Sample Team 2', 'Omnis ad vitae dolorem minus. Ducimus praesentium aut et cum ex animi necessitatibus. Omnis eaque eos ut illo sed non. Sed quas et recusandae ea.', 'Gryphon. \'Then, you know,\' said Alice in a hurry. \'No, I\'ll look first,\' she said, \'than waste it in asking riddles that have no idea what a Gryphon is, look at them--\'I wish they\'d get the trial.'),
	('TEM000008', 'Sample Team 3', 'Ratione adipisci excepturi eveniet dolor nisi et esse. Et eveniet ea numquam qui. Possimus debitis eaque dicta cum itaque.', 'I suppose, by being drowned in my size; and as he fumbled over the list, feeling very glad to find my way into a graceful zigzag, and was going to remark myself.\' \'Have you guessed the riddle yet?\'.'),
	('TEM000009', 'Sample Team 4', 'Eos qui dolor ratione ut illo nobis rerum. Est quis porro sit tempora cupiditate. Dolor fuga dignissimos eum et cupiditate quasi ratione.', 'Hatter. \'He won\'t stand beating. Now, if you want to go on crying in this affair, He trusts to you to sit down without being seen, when she next peeped out the Fish-Footman was gone, and the little.'),
	('TEM000010', 'Sample Team 5', 'Totam velit vitae et qui quia. Voluptas consequatur rerum et cupiditate. Laboriosam tenetur vel dicta porro. Provident harum ut deserunt.', 'Alice went on, looking anxiously about her. \'Oh, do let me help to undo it!\' \'I shall sit here,\' he said, turning to Alice, that she began thinking over other children she knew, who might do very.'),
	('TEM0000101', 'TamilLiterature', 'Tamil literature', 'Responsible to teach java online. Maintains java slide shows and quizess.'),
	('TEM0000102', 'Technical Education-SQL', 'Teaches SQL online', 'Responsbile to teach SQL online. Maintains videos and slide shows'),
	('TEM0000103', 'SVG', 'Develops SVG images ', 'Develop SVG images for all teams.');
/*!40000 ALTER TABLE `table_team` ENABLE KEYS */;

-- Dumping structure for table sangam_uat.table_user
CREATE TABLE IF NOT EXISTS `table_user` (
  `t_u_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AUTO_INCREMENT',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`t_u_id`),
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sangam_uat.table_user: ~100 rows (approximately)
DELETE FROM `table_user`;
/*!40000 ALTER TABLE `table_user` DISABLE KEYS */;
INSERT INTO `table_user` (`t_u_id`, `email`, `image_url`, `name`) VALUES
	('USR00000001', 'shan.nathan113@gmail.com', 'https://lh3.googleusercontent.com/a-/AOh14Gi_C4UUMNoHKoPymsMcvh6LQ-4r8od4AupUrFrPyQ=s96-c', 'Shanmuga Nathan'),
	('USR00000002', 'rreichert@example.com', 'http://www.schummturcotte.com/', 'Perry Wunsch Sr.'),
	('USR00000003', 'haley.abdullah@example.com', 'http://nienow.com/', 'Cleta Adams'),
	('USR00000004', 'little.helene@example.net', 'http://www.gottlieb.biz/', 'Jordy Nitzsche'),
	('USR00000005', 'hildegard39@example.com', 'http://oconnell.net/', 'Prof. Anibal Feest'),
	('USR00000006', 'von.raheem@example.net', 'http://townehyatt.com/', 'Dorian Lynch'),
	('USR00000007', 'swyman@example.net', 'http://www.volkman.com/', 'Dayne Hermiston'),
	('USR00000008', 'donavon51@example.org', 'http://www.mccullough.com/', 'Tyreek Labadie'),
	('USR00000009', 'pollich.veda@example.org', 'http://www.haagheidenreich.com/', 'Dr. Mckenzie Mueller V'),
	('USR00000010', 'krystina37@example.com', 'http://sauermorar.com/', 'Mrs. Meredith Gorczany'),
	('USR00000475', 'beryl08@example.com', 'http://cummings.com/', 'Dr. Lon Hilpert'),
	('USR00000601', 'qtremblay@example.com', 'http://padbergschowalter.net/', 'Mr. Ephraim Hand DDS'),
	('USR00000609', 'dandre16@example.net', 'http://kris.com/', 'Miss Lelah Wiza Jr.'),
	('USR00000844', 'wschamberger@example.org', 'http://www.nitzsche.com/', 'Laron Kirlin'),
	('USR00001120', 'tony.shanahan@example.net', 'http://hoppe.com/', 'Kennedy Tillman Jr.'),
	('USR00001148', 'okuneva.pascale@example.net', 'http://hagenes.biz/', 'Brock Smitham'),
	('USR00001175', 'jlockman@example.org', 'http://oreilly.com/', 'Selmer Ullrich'),
	('USR00001452', 'heathcote.mathew@example.net', 'http://www.kuvalisruecker.com/', 'Kailey Hane'),
	('USR00001598', 'jcummerata@example.com', 'http://barrows.com/', 'Annamarie Pollich'),
	('USR00001638', 'madisyn.medhurst@example.org', 'http://daniel.net/', 'Lowell White'),
	('USR00001770', 'jailyn.kulas@example.org', 'http://abshirelueilwitz.com/', 'Hollis Stamm'),
	('USR00001788', 'magdalena.thompson@example.com', 'http://www.pagac.com/', 'Miss Ena Kiehn'),
	('USR00001816', 'juanita92@example.org', 'http://www.kozey.com/', 'Jesse Reichert I'),
	('USR00001867', 'buckridge.patience@example.net', 'http://larson.com/', 'Jailyn Purdy Sr.'),
	('USR00002024', 'aaufderhar@example.org', 'http://casperhickle.com/', 'Prof. Yadira Labadie'),
	('USR00002086', 'gankunding@example.com', 'http://www.durgan.com/', 'Bartholome Daniel'),
	('USR00002207', 'sporer.marlen@example.org', 'http://daugherty.biz/', 'Constantin Goyette'),
	('USR00002304', 'yost.myrtice@example.net', 'http://www.creminharvey.com/', 'Rosa Larson'),
	('USR00002606', 'nd\'amore@example.com', 'http://www.murazikdietrich.com/', 'Cielo Keebler'),
	('USR00002679', 'may.spencer@example.net', 'http://murazik.biz/', 'Adrienne Wunsch'),
	('USR00002976', 'destiny92@example.com', 'http://rau.com/', 'Mr. Kim Klocko'),
	('USR00003014', 'mckenzie.vicenta@example.com', 'http://www.gaylord.com/', 'Prof. Raina Maggio'),
	('USR00003209', 'vanderson@example.org', 'http://goyette.com/', 'Jolie Krajcik'),
	('USR00003438', 'jannie.borer@example.net', 'http://huels.info/', 'Prof. Margarita Baumbach'),
	('USR00003563', 'yswaniawski@example.net', 'http://www.fadel.com/', 'Johnson Stracke'),
	('USR00003564', 'nmann@example.org', 'http://www.kovacek.biz/', 'Lacey Stiedemann'),
	('USR00003567', 'west.maybell@example.org', 'http://feeneyabshire.com/', 'Loraine Ondricka'),
	('USR00003598', 'white.patience@example.com', 'http://www.franecki.com/', 'Johathan Homenick II'),
	('USR00003722', 'terrence.batz@example.org', 'http://www.langworth.org/', 'June Hickle'),
	('USR00003852', 'solon.wiza@example.net', 'http://bruen.com/', 'Cathy Stroman'),
	('USR00003921', 'cecilia.leffler@example.net', 'http://breitenberg.com/', 'Nakia Walter'),
	('USR00004002', 'medhurst.orlo@example.net', 'http://www.howelloreilly.com/', 'Madalyn Robel'),
	('USR00004098', 'barrows.wilburn@example.com', 'http://www.bogisichaufderhar.com/', 'Hazle Weissnat'),
	('USR00004142', 'eloise.hilpert@example.com', 'http://www.armstrongolson.com/', 'Petra Rippin'),
	('USR00004261', 'micheal.gleason@example.net', 'http://harber.com/', 'Marge Spinka'),
	('USR00004452', 'selmer49@example.com', 'http://kihn.info/', 'Viviane Ferry I'),
	('USR00004520', 'fermin73@example.com', 'http://www.okunevabins.com/', 'Ova Grady'),
	('USR00004912', 'leuschke.william@example.org', 'http://feil.com/', 'Golden Kuvalis'),
	('USR00005037', 'lilla.rodriguez@example.org', 'http://trompstehr.net/', 'Dr. Ewell Hudson'),
	('USR00005123', 'sadye.schiller@example.com', 'http://www.haag.net/', 'Ms. Elisha Cummings'),
	('USR00005325', 'webster.ebert@example.com', 'http://schneider.com/', 'Zaria Simonis'),
	('USR00005340', 'gavin82@example.org', 'http://www.lowe.com/', 'Zetta Kautzer'),
	('USR00005479', 'ernesto30@example.com', 'http://doylefritsch.com/', 'Ulises Gottlieb'),
	('USR00005480', 'nyasia78@example.net', 'http://www.nitzsche.com/', 'Pablo Marquardt'),
	('USR00005534', 'gleason.paxton@example.org', 'http://www.veum.info/', 'Dereck Spencer'),
	('USR00005915', 'kebert@example.net', 'http://walter.com/', 'Mac Dooley V'),
	('USR00006024', 'wbailey@example.net', 'http://www.braun.com/', 'Melyna Leannon'),
	('USR00006064', 'feest.alfonzo@example.net', 'http://rempel.com/', 'Laverna Volkman'),
	('USR00006166', 'arturo32@example.com', 'http://www.roobward.com/', 'Miss Lessie Douglas DDS'),
	('USR00006215', 'caleigh21@example.net', 'http://boylecrist.com/', 'Clemmie Lesch'),
	('USR00006404', 'paul68@example.com', 'http://www.hanegulgowski.com/', 'Tomasa Kautzer'),
	('USR00006419', 'yrohan@example.org', 'http://www.tromp.com/', 'Estell Zulauf'),
	('USR00006498', 'xblock@example.org', 'http://www.gislason.biz/', 'Dr. Rollin Goodwin'),
	('USR00006508', 'walker.rebekah@example.com', 'http://mrazfeest.com/', 'Dr. Melisa Leannon PhD'),
	('USR00006509', 'dibbert.rafaela@example.com', 'http://www.bayer.biz/', 'Morris Ernser'),
	('USR00006670', 'witting.marcos@example.com', 'http://hills.com/', 'Justen Kilback'),
	('USR00006725', 'wschamberger@example.net', 'http://daughertyharris.info/', 'Mrs. Melyssa Jacobs Jr.'),
	('USR00006786', 'zbednar@example.org', 'http://hirthejacobs.com/', 'Celia Pagac PhD'),
	('USR00006965', 'sreinger@example.net', 'http://www.watsicarice.com/', 'Prof. Brooke Collier'),
	('USR00007377', 'stroman.lambert@example.com', 'http://bradtke.com/', 'Andrew Rolfson'),
	('USR00007441', 'nondricka@example.org', 'http://www.dickens.com/', 'Christopher Abbott'),
	('USR00007458', 'leuschke.cristian@example.com', 'http://mayert.org/', 'Isabella Halvorson IV'),
	('USR00007507', 'myles.gislason@example.net', 'http://www.bergnaumondricka.org/', 'Dr. Salvatore Barrows'),
	('USR00007520', 'timmy20@example.com', 'http://gleasongraham.com/', 'Fidel Johnson'),
	('USR00007527', 'eugenia59@example.org', 'http://www.hillsraynor.com/', 'Dejuan Dooley I'),
	('USR00007652', 'yost.emely@example.net', 'http://www.stroman.com/', 'Anabel Gleason'),
	('USR00007789', 'reuben45@example.com', 'http://www.hauck.org/', 'Mr. Gillian Balistreri'),
	('USR00007867', 'margarete59@example.org', 'http://kozey.info/', 'Brooks Jacobs'),
	('USR00008006', 'jonas50@example.com', 'http://www.conngrant.com/', 'Karson Beatty'),
	('USR00008104', 'bradford.sipes@example.net', 'http://rippin.com/', 'Magali Fahey'),
	('USR00008215', 'randal.gutmann@example.com', 'http://www.wehner.info/', 'Casimer Bailey'),
	('USR00008304', 'obayer@example.org', 'http://www.fritsch.com/', 'Kayleigh Gottlieb'),
	('USR00008370', 'ofelia28@example.net', 'http://marvintillman.com/', 'Alia Robel Jr.'),
	('USR00008518', 'vlueilwitz@example.org', 'http://www.volkman.info/', 'Marty Watsica'),
	('USR00008577', 'terrell.legros@example.net', 'http://corkery.com/', 'Brandon Wilderman'),
	('USR00008675', 'josiane61@example.com', 'http://ankunding.info/', 'Aurore Tromp'),
	('USR00008736', 'prince80@example.com', 'http://jaskolski.info/', 'Dulce Schaden V'),
	('USR00008935', 'noah.dooley@example.com', 'http://www.schadenfahey.com/', 'Johanna Murray'),
	('USR00009049', 'trutherford@example.org', 'http://denesiklittel.com/', 'Mr. Durward Towne'),
	('USR00009145', 'trantow.rossie@example.net', 'http://watsicarosenbaum.org/', 'Payton Cremin'),
	('USR00009231', 'brielle.krajcik@example.com', 'http://www.runolfsdottirhoeger.com/', 'Hertha Wisoky'),
	('USR00009442', 'pete29@example.com', 'http://dickens.com/', 'Dr. Kathryn Rutherford PhD'),
	('USR00009530', 'misael.roberts@example.com', 'http://beahan.com/', 'Lura Reinger'),
	('USR00009535', 'kelsie.hartmann@example.org', 'http://www.sanford.com/', 'Vergie Ward'),
	('USR00009591', 'kailee67@example.org', 'http://www.bayerturner.com/', 'Madison Parisian'),
	('USR00009793', 'gsmitham@example.org', 'http://www.dickinson.com/', 'Lessie Ondricka'),
	('USR00009830', 'ziemann.blake@example.com', 'http://walsh.com/', 'Gerard Bartell DDS'),
	('USR00009878', 'jess56@example.com', 'http://www.sawaynkerluke.info/', 'Mr. Arnaldo Dare PhD'),
	('USR00009885', 'schaefer.connor@example.net', 'http://bergstrom.com/', 'Vincenzo Ernser Jr.'),
	('USR00009901', 'cordelia99@example.org', 'http://dibbertbartell.org/', 'Prudence Grant Jr.'),
	('USR00009904', 'yasmin.zemlak@example.org', 'http://kiehnweimann.com/', 'Monica Hansen');
/*!40000 ALTER TABLE `table_user` ENABLE KEYS */;

-- Dumping structure for procedure sangam_uat.task_fetch_filter_task
DELIMITER //
CREATE PROCEDURE `task_fetch_filter_task`(
	IN `param_list_task_id` TEXT,
	IN `param_title` VARCHAR(255),
	IN `param_desc` TEXT,
	IN `param_created_by_team_id` VARCHAR(50),
	IN `param_created_by_user_id` VARCHAR(50),
	IN `param_my_user_id` VARCHAR(50),
	IN `param_assigned_to_team_id` VARCHAR(50),
	IN `param_task_status` INT,
	IN `param_latest_task_status` INT,
	IN `param_created_before` TIMESTAMP,
	IN `param_created_after` TIMESTAMP,
	IN `param_max_records` INT
)
    COMMENT 'This stored procedure filters task based on multiple parameters'
BEGIN

	DECLARE loc_no_of_records INT DEFAULT 100;
	SET loc_no_of_records =  CASE WHEN 	param_max_records IS NULL THEN 100 ELSE param_max_records END ;
	

		SELECT * FROM view_task t
		WHERE  	( 	param_list_task_id 			IS NULL 		OR 	FIND_IN_SET(t.task_id, param_list_task_id))
		AND    	(	param_title 					IS NULL 		OR 	LOWER(t.task_title) LIKE CONCAT('%',LOWER(param_title),'%'))
		AND    	(	param_desc 						IS NULL 		OR 	LOWER(t.task_description) LIKE CONCAT('%',LOWER(param_desc),'%'))
		AND		(	param_created_by_team_id	IS NULL  	OR 	t.task_id IN ( SELECT l.id FROM table_log l WHERE l.status_id = '101' AND l.to_user_id = param_created_by_team_id))
		AND		(	param_created_by_user_id	IS NULL  	OR 	t.task_id IN ( SELECT l.id FROM table_log l WHERE l.status_id = '101' AND l.by_user_id = param_created_by_user_id))
		AND		(	param_my_user_id				IS NULL  	OR 	t.task_id IN ( SELECT l.id FROM table_log l WHERE l.by_user_id = param_my_user_id OR l.to_user_id = param_my_user_id))
		-- Check if any status is as requested
		AND		(	param_task_status				IS NULL  	OR 	t.task_id IN ( SELECT l.id FROM table_log l WHERE l.status_id = param_task_status)) 
		-- Check if, added queue is as requested
		AND		(	param_assigned_to_team_id	IS NULL  	OR 	t.task_id IN ( SELECT l.id FROM table_log l JOIN ( SELECT id, MAX(l.time) AS 'time' FROM table_log l WHERE l.status_id = 151 GROUP BY id ) la ON l.id = la.id AND l.time = la.time WHERE l.to_user_id = param_assigned_to_team_id)) 
		-- Check if, Current status is as requested
		AND		(	param_latest_task_status	IS NULL  	OR 	t.task_id IN ( SELECT l.id FROM table_log l JOIN ( SELECT id, MAX(l.time) AS 'time' FROM table_log l GROUP BY id ) la ON l.id = la.id AND l.time = la.time WHERE l.status_id = param_latest_task_status)) 
		AND		(	param_created_after			IS NULL		OR		t.time >=	param_created_after)
		AND		(	param_created_before			IS NULL		OR		t.time <= 	param_created_before)
 	 	LIMIT		loc_no_of_records
	-- 	LIMIT		100
		;

END//
DELIMITER ;

-- Dumping structure for procedure sangam_uat.task_fetch_task
DELIMITER //
CREATE PROCEDURE `task_fetch_task`(
	IN `param_id` TEXT,
	IN `param_task_status` INT,
	IN `param_flag` INT
)
    COMMENT 'This procedure executes all task related queries to generate required reports'
BEGIN

	-- param_id 			- Acts as user id, team id or task id based on flag
	-- param_task_status - Refers the status of task
	-- param_flag			- Defines which report to be generated

	DECLARE LOC_TEAM 	INT DEFAULT 101; -- Refers team
	DECLARE LOC_QUEUE	INT DEFAULT 151; -- Refers Queue
	DECLARE LOC_SEGMENT_TASK	INT DEFAULT 1; -- Refers Queue
	
	IF param_flag = 1 THEN -- My Tasks with required status - param_id is user id 
			SELECT * FROM view_task t
			WHERE	t.task_id IN ( SELECT l.id 
										FROM table_log l 
										WHERE (	l.by_user_id = param_id 
													OR 
													(l.to_user_id = param_id 
													AND 
													l.status_id NOT IN (LOC_TEAM,LOC_QUEUE))
												)
												AND l.segment_ind = LOC_SEGMENT_TASK
										)
			ORDER BY t.time;
	END IF;
	
	IF param_flag = 2 THEN -- My Team Tasks with required status - - param_id is team id 
			SELECT * FROM view_task t
			WHERE	t.task_id IN (	SELECT	l.id 
										FROM		table_log l 
										WHERE 	(l.to_user_id = param_id 
													AND 
													l.status_id IN (LOC_TEAM,LOC_QUEUE))
													AND 
													l.segment_ind = LOC_SEGMENT_TASK)
			ORDER
			BY		t.time DESC;
	END IF;

	IF param_flag = 3 THEN -- Queue Tasks with required status -- param_id is team_id for queue
	-- Tasks with latest queue assignment of a specific team is required. 
		SELECT * FROM view_task t
			WHERE	t.task_id IN (	SELECT	CASE WHEN l.to_user_id = param_id THEN  l.id ELSE NULL END
										FROM		table_log l 
										WHERE 	(l.to_user_id = param_id 
													AND 
													l.status_id IN (LOC_QUEUE))
													AND 
													l.segment_ind = LOC_SEGMENT_TASK
										)
			ORDER BY t.time DESC;
										
	END IF;

	IF param_flag = 4 THEN -- Fetch with task id -- param_id is task id 
	
			SELECT * FROM view_task t
			WHERE	t.task_id = param_id;

	END IF;
	
END//
DELIMITER ;

-- Dumping structure for procedure sangam_uat.task_fetch_team
DELIMITER //
CREATE PROCEDURE `task_fetch_team`(
	IN `param_user_id` VARCHAR(50),
	IN `param_team_id` VARCHAR(50),
	IN `param_flag` INT
)
BEGIN

	IF param_flag = 1 THEN -- Get teamlist of a user
	
		SELECT 	*
		FROM view_team t
		WHERE 
		(param_user_id IS NULL 	OR t.team_id IN ( SELECT v.team_id FROM view_team v WHERE v.user_id IN (param_user_id)))
		ORDER BY 1 ASC;
		
	END IF;
	
	IF param_flag = 2 THEN -- Get team members, detailed info of a specific team
		SELECT *
		FROM view_team t
		WHERE t.team_id = param_team_id
		ORDER BY 1 ASC;
	END IF;
	
END//
DELIMITER ;

-- Dumping structure for procedure sangam_uat.task_util
DELIMITER //
CREATE PROCEDURE `task_util`(
	IN `param_list_id` MEDIUMTEXT,
	IN `param_id` VARCHAR(50),
	IN `param_flag` INT
)
BEGIN

	IF param_flag = 1 THEN -- Get latest task status for list of tasks
	
		SELECT a.*
		FROM view_task a
		INNER 
		JOIN (
			    SELECT 	b.task_id, 
				 			MAX(b.time) 'time'
			    FROM 	view_task b
			    GROUP 
				 BY 		task_id
				)b 
		ON 	a.task_id 	= b.task_id 
		AND 	a.time 		= b.time
		WHERE FIND_IN_SET(a.task_id, param_list_id);		

	END IF;
	
	-- Get list of team members
	IF param_flag = 2 THEN 
	
			SELECT 	t.team_id,
						t.user_id,
						t.user_name,
						t.role_name
			FROM 	view_team t
			WHERE FIND_IN_SET(t.team_id, param_list_id) -- list of team ids eg: 'TEM000158,TEM000001,TEM000616'
			ORDER 
			BY 1 ASC;

	END IF;

	-- Get list of teams
	IF param_flag = 3 THEN 
	
		SELECT DISTINCT team_id, team_name  
		FROM view_team ;

	END IF;
	
	-- Get static roles
	IF param_flag = 4 THEN
	
			SELECT 	l.team_id		AS 'team_id',
						p.s_r_p_id		AS 'role_privilege_id',
						r.role_name		AS 'role_name',
						p.task_status	AS 'task_status'
			FROM 	static_role r
			CROSS
			JOIN 	static_role_privilege p
			ON 	p.segment_ind  = 1 -- Task
			
			JOIN lookup_team_member_role l
			ON		l.team_role_id = r.role_id
			
			WHERE CASE 	WHEN r.role_id = 1 
							THEN p.team_lead = 'Y'
							WHEN r.role_id = 2
							THEN p.team_member = 'Y'
							WHEN r.role_id  = 3
							THEN p.global_admin = 'Y'
					END
			AND	l.user_id = param_id -- user Id
			ORDER
			BY 	1 ASC;
			
	END IF;
	
	-- Get data control values
	IF param_flag = 5 THEN
	
			SELECT * FROM data_control d
			WHERE FIND_IN_SET(d.label, param_list_id) -- list of team ids eg: 'TEM000158,TEM000001,TEM000616' 
			OR d.label = 'static';
			
	END IF;
	
	-- Get user details
	IF param_flag = 6 THEN
		
		SELECT 	u.t_u_id, 
					u.name, 
					u.email, 
					u.image_url 
		FROM table_user u
		WHERE u.t_u_id = param_id;
	
	END IF;
	
	-- Get my teams
	IF param_flag = 7 THEN
	
		SELECT 	t.t_t_id,
					t.name,
					l.team_role_id,
					r.role_name
		FROM 	lookup_team_member_role l
		JOIN 	table_team t
		ON 	l.team_id = t.t_t_id
		JOIN 	static_role r
		ON 	l.team_role_id = r.role_id
		WHERE user_id = param_id;
		
	END IF;
	
	IF param_flag = 8 THEN
	
		SELECT * 
		FROM static_role_privilege 
		WHERE segment_ind = 1;
	
	END IF;
	
	
	
END//
DELIMITER ;

-- Dumping structure for procedure sangam_uat.tool_maintenance
DELIMITER //
CREATE PROCEDURE `tool_maintenance`(
	IN `param_task_id` INT,
	IN `param_task_created_time` TIMESTAMP,
	IN `param_flag` INT
)
    COMMENT 'Sampe call statement. CALL `tool_maintenance''(NULL, ''2021-08-29 12:19:43'', ''1'')'
BEGIN

	/*		Sample calling statement
			CALL tool_maintenance(NULL, '2021-08-29 12:19:43', '1')
	*/
	
	IF param_flag = 1 THEN
		
		SELECT 	folder_path, 
					GROUP_CONCAT(CONCAT(task.t_t_id,
										'<title>',task.title,'</title>')
										SEPARATOR '<!!>'	
									) 
									
		FROM table_task task
		JOIN table_folder folder
		ON task.folder_id = folder.folder_id
	
		JOIN table_log l
		ON l.id = task.t_t_id
	
		WHERE  task.folder_id IS NOT NULL
		AND	l.time > param_task_created_time -- '2021-05-26 11:37:41'
		AND 	l.status_id = '101'
		GROUP BY folder_path;
	
	END IF;
	

END//
DELIMITER ;

-- Dumping structure for view sangam_uat.view_role_privilege
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_role_privilege` (
	`team_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`team_name` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`user_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`team_role_id` TINYINT(3) UNSIGNED NOT NULL COMMENT 'refers static_role table',
	`role_name` VARCHAR(15) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`Name_exp_6` TEXT NULL COLLATE 'utf8mb4_bin'
) ENGINE=MyISAM;

-- Dumping structure for view sangam_uat.view_task
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_task` (
	`task_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin',
	`task_title` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_bin',
	`task_description` TEXT NULL COLLATE 'utf8mb4_bin',
	`task_log_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`id` VARCHAR(50) NOT NULL COMMENT 'Have task, message id. Segment indicator helps to differentiate among segments.' COLLATE 'latin1_swedish_ci',
	`task_log_description` TEXT NULL COLLATE 'latin1_swedish_ci',
	`task_status_id` SMALLINT(5) UNSIGNED NOT NULL,
	`task_status` CHAR(255) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`by_user_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`to_user_id` VARCHAR(50) NOT NULL COMMENT 'To_user_id acts as team_id in case of "create task"' COLLATE 'latin1_swedish_ci',
	`user_team_details` TEXT NULL COLLATE 'latin1_swedish_ci',
	`time` TIMESTAMP NOT NULL,
	`effort_hrs` INT(10) NULL,
	`sl_No` INT(10) NOT NULL COMMENT 'If tasks are created from xl sl no will be added otherwise 0 will be added as default'
) ENGINE=MyISAM;

-- Dumping structure for view sangam_uat.view_team
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_team` (
	`team_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`team_name` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`summary` VARCHAR(150) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`detailed_description` TEXT NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`user_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`user_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`user_image` VARCHAR(255) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`role_id` TINYINT(3) UNSIGNED NOT NULL,
	`role_name` VARCHAR(15) NOT NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Dumping structure for view sangam_uat.view_role_privilege
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_role_privilege`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_role_privilege` AS select `l`.`team_id` AS `team_id`,`t`.`name` AS `team_name`,`l`.`user_id` AS `user_id`,`l`.`team_role_id` AS `team_role_id`,`r`.`role_name` AS `role_name`,group_concat(json_object('value',`p`.`s_r_p_id`,'label',`p`.`task_status`) separator ',') AS `Name_exp_6` from ((((`lookup_team_member_role` `l` join `table_team` `t` on((`t`.`t_t_id` = `l`.`team_id`))) join `table_user` `u` on((`l`.`user_id` = `u`.`t_u_id`))) join `static_role` `r` on((`l`.`team_role_id` = `r`.`role_id`))) join `static_role_privilege` `p` on((`p`.`segment_ind` = 1))) where (0 <> (case when (`r`.`role_id` = 1) then (`p`.`team_lead` = 'Y') when (`r`.`role_id` = 2) then (`p`.`team_member` = 'Y') when (`r`.`role_id` = 3) then (`p`.`global_admin` = 'Y') end)) group by `l`.`team_id`,`l`.`user_id`,`l`.`team_role_id`;

-- Dumping structure for view sangam_uat.view_task
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_task`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_task` AS select `t`.`t_t_id` AS `task_id`,`t`.`title` AS `task_title`,`t`.`description` AS `task_description`,`tml`.`t_l_id` AS `task_log_id`,`tml`.`id` AS `id`,`tml`.`description` AS `task_log_description`,`rp`.`s_r_p_id` AS `task_status_id`,`rp`.`task_status` AS `task_status`,`tml`.`by_user_id` AS `by_user_id`,`tml`.`to_user_id` AS `to_user_id`,`get_user_team_details`(`tml`.`by_user_id`,`tml`.`to_user_id`,`tml`.`status_id`) AS `user_team_details`,`tml`.`time` AS `time`,`t`.`effort_hrs` AS `effort_hrs`,`t`.`sl_no` AS `sl_No` from ((`table_task` `t` join `table_log` `tml` on(((`t`.`t_t_id` = convert(`tml`.`id` using utf8mb4)) and (`tml`.`segment_ind` = '1')))) join `static_role_privilege` `rp` on((`tml`.`status_id` = `rp`.`s_r_p_id`))) order by `tml`.`t_l_id`;

-- Dumping structure for view sangam_uat.view_team
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_team`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_team` AS select `t`.`t_t_id` AS `team_id`,`t`.`name` AS `team_name`,`t`.`summary` AS `summary`,`t`.`detailed_description` AS `detailed_description`,`u`.`t_u_id` AS `user_id`,`u`.`name` AS `user_name`,`u`.`image_url` AS `user_image`,`r`.`role_id` AS `role_id`,`r`.`role_name` AS `role_name` from (((`lookup_team_member_role` `l` join `table_user` `u` on((`l`.`user_id` = `u`.`t_u_id`))) join `table_team` `t` on((`t`.`t_t_id` = `l`.`team_id`))) join `static_role` `r` on((`l`.`team_role_id` = `r`.`role_id`)));

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
