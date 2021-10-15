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
-- Dumping structure for procedure sangam_uat.tool_maintenance
DELIMITER // CREATE PROCEDURE `tool_maintenance`( IN `param_task_id` INT, IN `param_task_created_time` TIMESTAMP, IN `param_flag` INT ) COMMENT 'Sampe call statement. CALL `tool_maintenance''(NULL, ''2021-08-29 12:19:43'', ''1'')' 
BEGIN
   /*		Sample calling statement
         CALL tool_maintenance(NULL, '2021-08-29 12:19:43', '1')
   */
   IF param_flag = 1 
THEN
   SELECT
      folder_path,
      GROUP_CONCAT(CONCAT(task.t_t_id, '<title>', task.title, '</title>') SEPARATOR '<!!>' ) 
   FROM
      table_task task 
      JOIN
         table_folder folder 
         ON task.folder_id = folder.folder_id 
      JOIN
         table_log l 
         ON l.id = task.t_t_id 
   WHERE
      task.folder_id IS NOT NULL 
      AND l.time > param_task_created_time 		-- '2021-05-26 11:37:41'
      AND l.status_id = '101' 
   GROUP BY
      folder_path;
END
IF;
END
 // DELIMITER ;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */
;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */
;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */
;