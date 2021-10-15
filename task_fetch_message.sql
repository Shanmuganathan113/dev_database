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
-- Dumping structure for procedure sangam_uat.task_fetch_message
DELIMITER // CREATE PROCEDURE `task_fetch_message`( IN `param_message_status` INT, IN `param_message_type` INT, IN `param_flag` INT ) 
BEGIN
   -- param_message_status 	- Create, closed etc...
   -- param_message_type 		- Feedback, comment or contribute ...etc
   -- param_flag				- Defines which report to be generated
   IF param_flag = 1 
THEN
   -- My Tasks with required status - param_id is user id 
   SELECT
      * 
   FROM
      view_message t 
   WHERE
      CASE
         WHEN
            param_message_status IS NOT NULL 				-- Create, closed etc...
         THEN
            t.message_status_id = param_message_status 
         ELSE
            t.message_status_id IS NOT NULL 
      END
      AND 
      CASE
         WHEN
            param_message_type IS NOT NULL 				-- Feedback, comment or contribute ...etc
         THEN
            t.message_type_id = param_message_type 
         ELSE
            t.message_type_id IS NOT NULL 
      END
;
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