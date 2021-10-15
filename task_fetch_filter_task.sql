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
-- Dumping structure for procedure sangam_uat.task_fetch_filter_task
DELIMITER // CREATE PROCEDURE `task_fetch_filter_task`( IN `param_list_task_id` TEXT, IN `param_title` VARCHAR(255), IN `param_desc` TEXT, IN `param_created_by_team_id` VARCHAR(50), IN `param_created_by_user_id` VARCHAR(50), IN `param_my_user_id` VARCHAR(50), IN `param_assigned_to_team_id` VARCHAR(50), IN `param_task_status` INT, IN `param_latest_task_status` INT, IN `param_created_before` TIMESTAMP, IN `param_created_after` TIMESTAMP, IN `param_max_records` INT ) COMMENT 'This stored procedure filters task based on multiple parameters' 
BEGIN
   DECLARE loc_no_of_records INT DEFAULT 100;
SET
   loc_no_of_records = 
   CASE
      WHEN
         param_max_records IS NULL 
      THEN
         100 
      ELSE
         param_max_records 
   END
;
SELECT
   * 
FROM
   view_task t 
WHERE
   (
      param_list_task_id IS NULL 
      OR FIND_IN_SET(t.task_id, param_list_task_id)
   )
   AND 
   (
      param_title IS NULL 
      OR LOWER(t.task_title) LIKE CONCAT('%', LOWER(param_title), '%')
   )
   AND 
   (
      param_desc IS NULL 
      OR LOWER(t.task_description) LIKE CONCAT('%', LOWER(param_desc), '%')
   )
   AND 
   (
      param_created_by_team_id IS NULL 
      OR t.task_id IN 
      (
         SELECT
            l.id 
         FROM
            table_log l 
         WHERE
            l.status_id = '101' 
            AND l.to_user_id = param_created_by_team_id
      )
   )
   AND 
   (
      param_created_by_user_id IS NULL 
      OR t.task_id IN 
      (
         SELECT
            l.id 
         FROM
            table_log l 
         WHERE
            l.status_id = '101' 
            AND l.by_user_id = param_created_by_user_id
      )
   )
   AND 
   (
      param_my_user_id IS NULL 
      OR t.task_id IN 
      (
         SELECT
            l.id 
         FROM
            table_log l 
         WHERE
            l.by_user_id = param_my_user_id 
            OR l.to_user_id = param_my_user_id
      )
   )
   -- Check if any status is as requested
   AND 
   (
      param_task_status IS NULL 
      OR t.task_id IN 
      (
         SELECT
            l.id 
         FROM
            table_log l 
         WHERE
            l.status_id = param_task_status
      )
   )
   -- Check if, added queue is as requested
   AND 
   (
      param_assigned_to_team_id IS NULL 
      OR t.task_id IN 
      (
         SELECT
            l.id 
         FROM
            table_log l 
            JOIN
               (
                  SELECT
                     id,
                     MAX(l.time) AS 'time' 
                  FROM
                     table_log l 
                  WHERE
                     l.status_id = 151 
                  GROUP BY
                     id 
               )
               la 
               ON l.id = la.id 
               AND l.time = la.time 
         WHERE
            l.to_user_id = param_assigned_to_team_id
      )
   )
   -- Check if, Current status is as requested
   AND 
   (
      param_latest_task_status IS NULL 
      OR t.task_id IN 
      (
         SELECT
            l.id 
         FROM
            table_log l 
            JOIN
               (
                  SELECT
                     id,
                     MAX(l.time) AS 'time' 
                  FROM
                     table_log l 
                  GROUP BY
                     id 
               )
               la 
               ON l.id = la.id 
               AND l.time = la.time 
         WHERE
            l.status_id = param_latest_task_status
      )
   )
   AND 
   (
      param_created_after IS NULL 
      OR t.time >= param_created_after
   )
   AND 
   (
      param_created_before IS NULL 
      OR t.time <= param_created_before
   )
   LIMIT loc_no_of_records 	-- 	LIMIT		100
;
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