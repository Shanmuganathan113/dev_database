-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               8.0.19 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             11.1.0.6116
-- --------------------------------------------------------
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;
/*!40101 SET NAMES utf8 */
;
/*!50503 SET NAMES utf8mb4 */
;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */
;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */
;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */
;
-- Dumping database structure for sangam_uat
CREATE DATABASE IF NOT EXISTS `sangam_uat` /*!40100 DEFAULT CHARACTER SET latin1 */
/*!80016 DEFAULT ENCRYPTION='N' */
;
USE `sangam_uat`;
-- Dumping structure for view sangam_uat.view_task
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_task` ( `task_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin', `task_title` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_bin', `task_description` TEXT NULL COLLATE 'utf8mb4_bin', `task_log_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_0900_ai_ci', `id` VARCHAR(50) NOT NULL COMMENT 'Have task, message id. Segment indicator helps to differentiate among segments.' COLLATE 'latin1_swedish_ci', `task_log_description` TEXT NULL COLLATE 'latin1_swedish_ci', `task_status_id` SMALLINT(5) UNSIGNED NOT NULL, `task_status` CHAR(255) NOT NULL COLLATE 'utf8mb4_0900_ai_ci', `by_user_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_0900_ai_ci', `to_user_id` VARCHAR(50) NOT NULL COMMENT 'To_user_id acts as team_id in case of "create task"' COLLATE 'latin1_swedish_ci', `user_team_details` TEXT NULL COLLATE 'latin1_swedish_ci', `time` TIMESTAMP NOT NULL, `effort_hrs` INT(10) NULL, `sl_No` INT(10) NOT NULL COMMENT 'If tasks are created from xl sl no will be added otherwise 0 will be added as default' ) ENGINE = MyISAM;
-- Dumping structure for view sangam_uat.view_task
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_task`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_task` AS 
select
   `t`.`t_t_id` AS `task_id`,
   `t`.`title` AS `task_title`,
   `t`.`description` AS `task_description`,
   `tml`.`t_l_id` AS `task_log_id`,
   `tml`.`id` AS `id`,
   `tml`.`description` AS `task_log_description`,
   `rp`.`s_r_p_id` AS `task_status_id`,
   `rp`.`task_status` AS `task_status`,
   `tml`.`by_user_id` AS `by_user_id`,
   `tml`.`to_user_id` AS `to_user_id`,
   `get_user_team_details`(`tml`.`by_user_id`, `tml`.`to_user_id`, `tml`.`status_id`) AS `user_team_details`,
   `tml`.`time` AS `time`,
   `t`.`effort_hrs` AS `effort_hrs`,
   `t`.`sl_no` AS `sl_No` 
from
   (
(`table_task` `t` 
      join
         `table_log` `tml` 
         on(((`t`.`t_t_id` = convert(`tml`.`id` using utf8mb4)) 
         and 
         (
            `tml`.`segment_ind` = '1'
         )
))) 
      join
         `static_role_privilege` `rp` 
         on((`tml`.`status_id` = `rp`.`s_r_p_id`))
   )
order by
   `tml`.`t_l_id`;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */
;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */
;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */
;