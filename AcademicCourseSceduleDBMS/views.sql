

-- Structure for view `CourseInDepartment`
--
DROP TABLE IF EXISTS `CourseInDepartment`;

CREATE ALGORITHM=UNDEFINED   VIEW `CourseInDepartment` AS select `d`.`name` AS `Department`,`c`.`course_number` AS `Course Number`,`c`.`name` AS `Course` from ((`Course` `c` join `DepartmentCourse` `dc` on((`c`.`course_id` = `dc`.`course`))) join `Department` `d` on((`dc`.`department` = `d`.`abbreviated_name`)));

-- --------------------------------------------------------

--
-- Structure for view `Prerequisites`
--
DROP TABLE IF EXISTS `Prerequisites`;

CREATE ALGORITHM=UNDEFINED   VIEW `Prerequisites` AS select `c`.`name` AS `Course`,group_concat(`c2`.`name` separator ',') AS `Prerequisite` from ((`Prerequisite` `p` join `Course` `c` on((`p`.`course` = `c`.`course_id`))) join `Course` `c2` on((`p`.`prerequisite` = `c2`.`course_id`))) group by `c`.`name`;

-- --------------------------------------------------------

--
-- Structure for view `StudentSchedule`
--
DROP TABLE IF EXISTS `StudentSchedule`;

CREATE ALGORITHM=UNDEFINED   VIEW `StudentSchedule` AS select `s`.`first_name` AS `First Name`,`s`.`last_name` AS `Last Name`,`sdt`.`DAY` AS `Day`,concat(`lt`.`start_time`,' - ',`lt`.`end_time`) AS `Time Block` from ((((`Student` `s` left join `StudentSection` `ss` on((`s`.`student_id` = `ss`.`student`))) left join `Section` `se` on((`ss`.`section` = `se`.`section_id`))) left join `SectionDayTime` `sdt` on((`se`.`section_id` = `sdt`.`section`))) left join `Lecture_Time` `lt` on((`sdt`.`TIME` = `lt`.`lecture_time_id`)));

-- --------------------------------------------------------

--
-- Structure for view `TeacherSchedule`
--
DROP TABLE IF EXISTS `TeacherSchedule`;

CREATE ALGORITHM=UNDEFINED   VIEW `TeacherSchedule` AS select concat(`t`.`first_name`,' ',`t`.`last_name`) AS `Full Name`,`sdt`.`DAY` AS `Day`,concat(`lt`.`start_time`,' - ',`lt`.`end_time`) AS `Time Block` from ((((`Teacher` `t` left join `TeacherSection` `ts` on((`t`.`teacher_id` = `ts`.`teacher`))) left join `Section` `se` on((`ts`.`section` = `se`.`section_id`))) left join `SectionDayTime` `sdt` on((`se`.`section_id` = `sdt`.`section`))) left join `Lecture_Time` `lt` on((`sdt`.`TIME` = `lt`.`lecture_time_id`)));
