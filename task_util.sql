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
-- Dumping structure for procedure sangam_uat.task_util
DELIMITER // CREATE PROCEDURE `task_util`( IN `param_list_id` MEDIUMTEXT, IN `param_id` VARCHAR(50), IN `param_flag` INT ) 
BEGIN
   IF param_flag = 1 
THEN
   -- Get latest task status for list of tasks
   SELECT
      a.* 
   FROM
      view_task a INNER 
      JOIN
         (
            SELECT
               b.task_id,
               MAX(b.time) 'time' 
            FROM
               view_task b 
            GROUP BY
               task_id 
         )
         b 
         ON a.task_id = b.task_id 
         AND a.time = b.time 
   WHERE
      FIND_IN_SET(a.task_id, param_list_id);
END
IF;
-- Get list of team members
IF param_flag = 2 
THEN
   SELECT
      t.team_id,
      t.user_id,
      t.user_name,
      t.role_name 
   FROM
      view_team t 
   WHERE
      FIND_IN_SET(t.team_id, param_list_id) 		-- list of team ids eg: 'TEM000158,TEM000001,TEM000616'
   ORDER BY
      1 ASC;
END
IF;
-- Get list of teams
IF param_flag = 3 
THEN
   SELECT DISTINCT
      team_id,
      team_name 
   FROM
      view_team ;
END
IF;
-- Get static roles
IF param_flag = 4 
THEN
   SELECT
      l.team_id AS 'team_id',
      p.s_r_p_id AS 'role_privilege_id',
      r.role_name AS 'role_name',
      p.task_status AS 'task_status' 
   FROM
      static_role r CROSS 
      JOIN
         static_role_privilege p 
         ON p.segment_ind = 1 			-- Task
      JOIN
         lookup_team_member_role l 
         ON l.team_role_id = r.role_id 
   WHERE
      CASE
         WHEN
            r.role_id = 1 
         THEN
            p.team_lead = 'Y' 
         WHEN
            r.role_id = 2 
         THEN
            p.team_member = 'Y' 
         WHEN
            r.role_id = 3 
         THEN
            p.global_admin = 'Y' 
      END
      AND l.user_id = param_id 		-- user Id
   ORDER BY
      1 ASC;
END
IF;
-- Get data control values
IF param_flag = 5 
THEN
   SELECT
      * 
   FROM
      data_control d 
   WHERE
      FIND_IN_SET(d.label, param_list_id) 		-- list of team ids eg: 'TEM000158,TEM000001,TEM000616' 
      OR d.label = 'static';
END
IF;
-- Get user details
IF param_flag = 6 
THEN
   SELECT
      u.t_u_id,
      u.name,
      u.email,
      u.image_url 
   FROM
      table_user u 
   WHERE
      u.t_u_id = param_id;
END
IF;
-- Get my teams
IF param_flag = 7 
THEN
   SELECT
      t.t_t_id,
      t.name,
      l.team_role_id,
      r.role_name 
   FROM
      lookup_team_member_role l 
      JOIN
         table_team t 
         ON l.team_id = t.t_t_id 
      JOIN
         static_role r 
         ON l.team_role_id = r.role_id 
   WHERE
      user_id = param_id;
END
IF;
IF param_flag = 8 
THEN
   SELECT
      * 
   FROM
      static_role_privilege 
   WHERE
      segment_ind = 1;
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