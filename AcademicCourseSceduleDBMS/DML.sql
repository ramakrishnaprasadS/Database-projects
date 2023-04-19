
-- Constraints for dumped tables
--

--
-- Constraints for table `DepartmentCourse`
--
ALTER TABLE `DepartmentCourse`
  ADD CONSTRAINT `DepartmentCourse_ibfk_1` FOREIGN KEY (`course`) REFERENCES `Course` (`course_id`),
  ADD CONSTRAINT `DepartmentCourse_ibfk_2` FOREIGN KEY (`department`) REFERENCES `Department` (`abbreviated_name`);

--
-- Constraints for table `Prerequisite`
--
ALTER TABLE `Prerequisite`
  ADD CONSTRAINT `Prerequisite_ibfk_1` FOREIGN KEY (`course`) REFERENCES `Course` (`course_id`),
  ADD CONSTRAINT `Prerequisite_ibfk_2` FOREIGN KEY (`prerequisite`) REFERENCES `Course` (`course_id`);

--
-- Constraints for table `Room`
--
ALTER TABLE `Room`
  ADD CONSTRAINT `Room_ibfk_1` FOREIGN KEY (`building`) REFERENCES `Building` (`name`);

--
-- Constraints for table `Section`
--
ALTER TABLE `Section`
  ADD CONSTRAINT `Section_ibfk_2` FOREIGN KEY (`course`) REFERENCES `Course` (`course_id`),
  ADD CONSTRAINT `Section_ibfk_3` FOREIGN KEY (`semester`) REFERENCES `Semester` (`season`),
  ADD CONSTRAINT `Section_ibfk_4` FOREIGN KEY (`room`) REFERENCES `Room` (`room_id`),
  ADD CONSTRAINT `Section_ibfk_5` FOREIGN KEY (`lecture_type`) REFERENCES `Lecture_Type` (`type`);

--
-- Constraints for table `SectionDayTime`
--
ALTER TABLE `SectionDayTime`
  ADD CONSTRAINT `SectionDayTime_ibfk_1` FOREIGN KEY (`section`) REFERENCES `Section` (`section_id`),
  ADD CONSTRAINT `SectionDayTime_ibfk_2` FOREIGN KEY (`TIME`) REFERENCES `Lecture_Time` (`lecture_time_id`),
  ADD CONSTRAINT `SectionDayTime_ibfk_3` FOREIGN KEY (`DAY`) REFERENCES `Lecture_Day` (`day`);

--
-- Constraints for table `StudentSection`
--
ALTER TABLE `StudentSection`
  ADD CONSTRAINT `StudentSection_ibfk_1` FOREIGN KEY (`student`) REFERENCES `Student` (`student_id`),
  ADD CONSTRAINT `StudentSection_ibfk_2` FOREIGN KEY (`section`) REFERENCES `Section` (`section_id`);

--
-- Constraints for table `TeacherSection`
--
ALTER TABLE `TeacherSection`
  ADD CONSTRAINT `TeacherSection_ibfk_1` FOREIGN KEY (`teacher`) REFERENCES `Teacher` (`teacher_id`),
  ADD CONSTRAINT `TeacherSection_ibfk_2` FOREIGN KEY (`section`) REFERENCES `Section` (`section_id`);

--
-- Constraints for table `Transcript`
--
ALTER TABLE `Transcript`
  ADD CONSTRAINT `Transcript_ibfk_1` FOREIGN KEY (`student`) REFERENCES `Student` (`student_id`);

--
-- Constraints for table `TranscriptCourse`
--
ALTER TABLE `TranscriptCourse`
  ADD CONSTRAINT `TranscriptCourse_ibfk_1` FOREIGN KEY (`transcript`) REFERENCES `Transcript` (`transcript_id`),
  ADD CONSTRAINT `TranscriptCourse_ibfk_2` FOREIGN KEY (`course`) REFERENCES `Course` (`course_id`);


