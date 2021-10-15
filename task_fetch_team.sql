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
-- Dumping structure for procedure sangam_uat.task_fetch_team
DELIMITER // CREATE PROCEDURE `task_fetch_team`( IN `param_user_id` VARCHAR(50), IN `param_team_id` VARCHAR(50), IN `param_flag` INT ) 
BEGIN
   IF param_flag = 1 
THEN
   -- Get teamlist of a user
   SELECT
      * 
   FROM
      view_team t 
   WHERE
      (
         param_user_id IS NULL 
         OR t.team_id IN 
         (
            SELECT
               v.team_id 
            FROM
               view_team v 
            WHERE
               v.user_id IN 
               (
                  param_user_id
               )
         )
      )
   ORDER BY
      1 ASC;
END
IF;
IF param_flag = 2 
THEN
   -- Get team members, detailed info of a specific team
   SELECT
      * 
   FROM
      view_team t 
   WHERE
      t.team_id = param_team_id 
   ORDER BY
      1 ASC;
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