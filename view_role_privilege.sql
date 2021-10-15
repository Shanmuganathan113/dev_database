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

-- Dumping structure for view sangam_uat.view_role_privilege
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_role_privilege`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_role_privilege` AS select `l`.`team_id` AS `team_id`,`t`.`name` AS `team_name`,`l`.`user_id` AS `user_id`,`l`.`team_role_id` AS `team_role_id`,`r`.`role_name` AS `role_name`,group_concat(json_object('value',`p`.`s_r_p_id`,'label',`p`.`task_status`) separator ',') AS `Name_exp_6` from ((((`lookup_team_member_role` `l` join `table_team` `t` on((`t`.`t_t_id` = `l`.`team_id`))) join `table_user` `u` on((`l`.`user_id` = `u`.`t_u_id`))) join `static_role` `r` on((`l`.`team_role_id` = `r`.`role_id`))) join `static_role_privilege` `p` on((`p`.`segment_ind` = 1))) where (0 <> (case when (`r`.`role_id` = 1) then (`p`.`team_lead` = 'Y') when (`r`.`role_id` = 2) then (`p`.`team_member` = 'Y') when (`r`.`role_id` = 3) then (`p`.`global_admin` = 'Y') end)) group by `l`.`team_id`,`l`.`user_id`,`l`.`team_role_id`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
