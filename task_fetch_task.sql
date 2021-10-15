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
-- Dumping structure for procedure sangam_uat.task_fetch_task
DELIMITER // CREATE PROCEDURE `task_fetch_task`( IN `param_id` TEXT, IN `param_task_status` INT, IN `param_flag` INT ) COMMENT 'This procedure executes all task related queries to generate required reports' 
BEGIN
   -- param_id 			- Acts as user id, team id or task id based on flag
   -- param_task_status - Refers the status of task
   -- param_flag			- Defines which report to be generated
   DECLARE LOC_TEAM INT DEFAULT 101;
-- Refers team
DECLARE LOC_QUEUE INT DEFAULT 151;
-- Refers Queue
DECLARE LOC_SEGMENT_TASK INT DEFAULT 1;
-- Refers Queue
IF param_flag = 1 
THEN
   -- My Tasks with required status - param_id is user id 
   SELECT
      * 
   FROM
      view_task t 
   WHERE
      t.task_id IN 
      (
         SELECT
            l.id 
         FROM
            table_log l 
         WHERE
            (
               l.by_user_id = param_id 
               OR 
               (
                  l.to_user_id = param_id 
                  AND l.status_id NOT IN 
                  (
                     LOC_TEAM,
                     LOC_QUEUE
                  )
               )
            )
            AND l.segment_ind = LOC_SEGMENT_TASK 
      )
   ORDER BY
      t.time;
END
IF;
IF param_flag = 2 
THEN
   -- My Team Tasks with required status - - param_id is team id 
   SELECT
      * 
   FROM
      view_task t 
   WHERE
      t.task_id IN 
      (
         SELECT
            l.id 
         FROM
            table_log l 
         WHERE
            (
               l.to_user_id = param_id 
               AND l.status_id IN 
               (
                  LOC_TEAM,
                  LOC_QUEUE
               )
            )
            AND l.segment_ind = LOC_SEGMENT_TASK
      )
   ORDER BY
      t.time DESC;
END
IF;
IF param_flag = 3 
THEN
   -- Queue Tasks with required status -- param_id is team_id for queue
   -- Tasks with latest queue assignment of a specific team is required. 
   SELECT
      * 
   FROM
      view_task t 
   WHERE
      t.task_id IN 
      (
         SELECT
            CASE
               WHEN
                  l.to_user_id = param_id 
               THEN
                  l.id 
               ELSE
                  NULL 
            END
         FROM
            table_log l 
         WHERE
            (
               l.to_user_id = param_id 
               AND l.status_id IN 
               (
                  LOC_QUEUE
               )
            )
            AND l.segment_ind = LOC_SEGMENT_TASK 
      )
   ORDER BY
      t.time DESC;
END
IF;
IF param_flag = 4 
THEN
   -- Fetch with task id -- param_id is task id 
   SELECT
      * 
   FROM
      view_task t 
   WHERE
      t.task_id = param_id;
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