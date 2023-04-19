
--
-- Table structure for table `Admin`
--

CREATE TABLE IF NOT EXISTS `Admin` (
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `username` (`username`),
  KEY `fullName` (`last_name`,`first_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Admin`
--

INSERT INTO `Admin` (`username`, `password`, `first_name`, `last_name`) VALUES
('kjohn', '123456789', 'kevin', 'john');

-- --------------------------------------------------------

--
-- Table structure for table `Building`
--

CREATE TABLE IF NOT EXISTS `Building` (
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `name` (`name`),
  KEY `buildingName` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Building`
--

INSERT INTO `Building` (`name`) VALUES
('Atkins'),
('Bio Informatics'),
('Friday'),
('Online'),
('WoodWard Hall');

-- --------------------------------------------------------

--
-- Table structure for table `Course`
--

CREATE TABLE IF NOT EXISTS `Course` (
  `course_id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `course_number` int(10) NOT NULL,
  `credits` int(10) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`course_id`),
  KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `Course`
--

INSERT INTO `Course` (`course_id`, `name`, `course_number`, `credits`, `description`) VALUES
(1, 'Database Systems', 6160, 3, 'This course covers the fundamental concepts of database systems. Topics include data models (ER, relational, and others); query languages (relational algebra, SQL, and others)'),
(2, 'Mobile Application Development', 5180, 3, 'This course covers the topics of Android application development and few topics from ios Application development'),
(3, 'Knowledge Discovery in Databases', 6162, 3, 'This Course covers the algorithms to find the association rules and reducts from the given sets of data'),
(4, 'Calculus', 1120, 3, 'This course is designed to develop the topics of differential and integral calculus. Emphasis is placed on limits, continuity, derivatives and integrals of algebraic and transcendental functions of one variable.'),
(5, 'Ord Differential Equations', 5173, 3, 'The course will demonstrate the usefulness of ordinary differential equations for modeling physical and other phenomena. Complementary mathematical approaches for their solution will be presented, including analytical methods, graphical analysis and numerical techniques'),
(6, 'Calculus-Engr Tech', 1121, 3, 'This course covers topics in calculus with an emphasis on applications in engineering technology.'),
(7, 'Ecology', 3144, 3, 'Ecology is the study of the interactions between organisms and their environment. This course provides a background in the fundamental principles of ecological science, including concepts of natural selection, population and community ecology, biodiversity, and sustainability.'),
(8, 'Financial Management', 3120, 3, 'Principles and problems of financial aspects of managing capital structure, leastcost asset management, planning and control.');

-- --------------------------------------------------------

--
-- Stand-in structure for view `CourseInDepartment`
--
CREATE TABLE IF NOT EXISTS `CourseInDepartment` (
`Department` varchar(50)
,`Course Number` int(10)
,`Course` varchar(50)
);
-- --------------------------------------------------------

--
-- Table structure for table `Department`
--

CREATE TABLE IF NOT EXISTS `Department` (
  `abbreviated_name` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`abbreviated_name`),
  UNIQUE KEY `abbreviated_name` (`abbreviated_name`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Department`
--

INSERT INTO `Department` (`abbreviated_name`, `name`, `description`) VALUES
('BIOL', 'Biology', 'The biology department provides students with courses that support a broad base for understanding principles governing life processes at all levels–molecular, cellular, organismal, and ecological.'),
('FINN', 'Finance', 'The finance department covers topics dealing with accounting, money management, and banking.'),
('ITCS', 'Computer Science', 'This department has courses that teach you how to program and manage networking operations'),
('MATH', 'Mathematics', 'The department offers seven concentrations as part of the mathematics degree: Actuarial, Applied Math, Individual, Math Computing, Pure Math, Statistics, and Teaching.');

-- --------------------------------------------------------

--
-- Table structure for table `DepartmentCourse`
--

CREATE TABLE IF NOT EXISTS `DepartmentCourse` (
  `course` int(10) NOT NULL,
  `department` varchar(50) NOT NULL,
  PRIMARY KEY (`course`,`department`),
  KEY `department` (`department`),
  KEY `dep` (`department`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `DepartmentCourse`
--

INSERT INTO `DepartmentCourse` (`course`, `department`) VALUES
(7, 'BIOL'),
(8, 'FINN'),
(1, 'ITCS'),
(2, 'ITCS'),
(3, 'ITCS'),
(4, 'MATH'),
(5, 'MATH'),
(6, 'MATH');

-- --------------------------------------------------------

--
-- Table structure for table `Lecture_Day`
--

CREATE TABLE IF NOT EXISTS `Lecture_Day` (
  `day` varchar(50) NOT NULL,
  PRIMARY KEY (`day`),
  UNIQUE KEY `day` (`day`),
  KEY `lectureDay` (`day`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Lecture_Day`
--

INSERT INTO `Lecture_Day` (`day`) VALUES
('Friday'),
('Monday'),
('Thursday'),
('Tuesday'),
('Wednesday');

-- --------------------------------------------------------

--
-- Table structure for table `Lecture_Time`
--

CREATE TABLE IF NOT EXISTS `Lecture_Time` (
  `lecture_time_id` int(10) NOT NULL AUTO_INCREMENT,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  PRIMARY KEY (`lecture_time_id`),
  KEY `timeBlock` (`start_time`,`end_time`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `Lecture_Time`
--

INSERT INTO `Lecture_Time` (`lecture_time_id`, `start_time`, `end_time`) VALUES
(1, '08:30:00', '11:15:00'),
(2, '09:30:00', '12:15:00'),
(4, '14:00:00', '16:45:00'),
(3, '15:00:00', '17:15:00');

-- --------------------------------------------------------

--
-- Table structure for table `Lecture_Type`
--

CREATE TABLE IF NOT EXISTS `Lecture_Type` (
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`type`),
  UNIQUE KEY `type` (`type`),
  KEY `lectureType` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Lecture_Type`
--

INSERT INTO `Lecture_Type` (`type`) VALUES
('Lab'),
('Lecture'),
('Online');

-- --------------------------------------------------------

--
-- Table structure for table `Prerequisite`
--

CREATE TABLE IF NOT EXISTS `Prerequisite` (
  `course` int(10) NOT NULL,
  `prerequisite` int(10) NOT NULL,
  PRIMARY KEY (`course`,`prerequisite`),
  KEY `prerequisite` (`prerequisite`),
  KEY `course` (`course`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Prerequisite`
--

INSERT INTO `Prerequisite` (`course`, `prerequisite`) VALUES
(3, 1),
(6, 4),
(6, 5);

-- --------------------------------------------------------

--
-- Stand-in structure for view `Prerequisites`
--
CREATE TABLE IF NOT EXISTS `Prerequisites` (
`Course` varchar(50)
,`Prerequisite` text
);
-- --------------------------------------------------------

--
-- Table structure for table `Room`
--

CREATE TABLE IF NOT EXISTS `Room` (
  `room_id` int(10) NOT NULL AUTO_INCREMENT,
  `number` int(10) DEFAULT NULL,
  `capacity` int(10) DEFAULT NULL,
  `building` varchar(50) NOT NULL,
  PRIMARY KEY (`room_id`),
  KEY `building` (`building`),
  KEY `number` (`number`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `Room`
--

INSERT INTO `Room` (`room_id`, `number`, `capacity`, `building`) VALUES
(1, 155, 60, 'WoodWard Hall'),
(2, 124, 30, 'Atkins'),
(3, 130, 45, 'Bio Informatics'),
(4, NULL, NULL, 'Online'),
(5, 142, 80, 'Friday');

-- --------------------------------------------------------

--
-- Table structure for table `Section`
--

CREATE TABLE IF NOT EXISTS `Section` (
  `section_id` int(10) NOT NULL AUTO_INCREMENT,
  `section_num` int(10) NOT NULL,
  `section_limit` int(10) NOT NULL,
  `year` year(4) NOT NULL,
  `course` int(10) NOT NULL,
  `semester` varchar(50) NOT NULL,
  `room` int(10) NOT NULL,
  `lecture_type` varchar(50) NOT NULL,
  `student_count` int(5) DEFAULT NULL,
  PRIMARY KEY (`section_id`),
  KEY `course` (`course`),
  KEY `semester` (`semester`),
  KEY `room` (`room`),
  KEY `lecture_type` (`lecture_type`),
  KEY `courseSection` (`course`,`section_num`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `Section`
--

INSERT INTO `Section` (`section_id`, `section_num`, `section_limit`, `year`, `course`, `semester`, `room`, `lecture_type`, `student_count`) VALUES
(1, 3541, 30, 2017, 4, 'Fall', 4, 'Online', 2),
(2, 4581, 45, 2018, 1, 'Fall', 3, 'Lecture', 2),
(3, 5861, 30, 2018, 2, 'Spring', 2, 'Lecture', 3),
(4, 1114, 60, 2017, 7, 'Fall', 1, 'Lab', 3),
(5, 8541, 40, 2018, 3, 'First Summer', 4, 'Online', 1);

-- --------------------------------------------------------

--
-- Table structure for table `SectionDayTime`
--

CREATE TABLE IF NOT EXISTS `SectionDayTime` (
  `section` int(10) NOT NULL,
  `TIME` int(10) NOT NULL,
  `DAY` varchar(50) NOT NULL,
  PRIMARY KEY (`section`,`TIME`,`DAY`),
  KEY `TIME` (`TIME`),
  KEY `DAY` (`DAY`),
  KEY `section` (`section`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `SectionDayTime`
--

INSERT INTO `SectionDayTime` (`section`, `TIME`, `DAY`) VALUES
(4, 1, 'Friday'),
(5, 1, 'Wednesday'),
(2, 2, 'Friday'),
(1, 3, 'Monday'),
(3, 4, 'Monday');

-- --------------------------------------------------------

--
-- Table structure for table `Semester`
--

CREATE TABLE IF NOT EXISTS `Semester` (
  `season` varchar(50) NOT NULL,
  PRIMARY KEY (`season`),
  UNIQUE KEY `season` (`season`),
  KEY `seas` (`season`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Semester`
--

INSERT INTO `Semester` (`season`) VALUES
('Fall'),
('First Summer'),
('Second Summer'),
('Spring');

-- --------------------------------------------------------

--
-- Table structure for table `Student`
--

CREATE TABLE IF NOT EXISTS `Student` (
  `student_id` int(10) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  PRIMARY KEY (`student_id`),
  KEY `fullName` (`last_name`,`first_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `Student`
--

INSERT INTO `Student` (`student_id`, `first_name`, `last_name`) VALUES
(4, 'Mahesh', 'Babu'),
(5, 'Smith', 'John'),
(6, 'Kooper', 'Kevin'),
(1, 'Sai', 'Krishna'),
(2, 'Karthik', 'Kumar'),
(3, 'Surya', 'Shiva');

-- --------------------------------------------------------

--
-- Stand-in structure for view `StudentSchedule`
--
CREATE TABLE IF NOT EXISTS `StudentSchedule` (
`First Name` varchar(50)
,`Last Name` varchar(50)
,`Day` varchar(50)
,`Time Block` varchar(19)
);
-- --------------------------------------------------------

--
-- Table structure for table `StudentSection`
--

CREATE TABLE IF NOT EXISTS `StudentSection` (
  `student` int(10) NOT NULL,
  `section` int(10) NOT NULL,
  PRIMARY KEY (`student`,`section`),
  KEY `section` (`section`),
  KEY `student` (`student`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `StudentSection`
--

INSERT INTO `StudentSection` (`student`, `section`) VALUES
(1, 1),
(5, 1),
(1, 2),
(5, 2),
(2, 3),
(3, 3),
(3, 4),
(4, 4),
(6, 4),
(4, 5);

-- Triggers `StudentSection`
--
DROP TRIGGER IF EXISTS `after_student_enroll`;
DELIMITER //
CREATE TRIGGER `after_student_enroll` AFTER INSERT ON `StudentSection`
 FOR EACH ROW BEGIN 
UPDATE Section SET student_count = student_count +1 WHERE section_id = new.section;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Teacher`
--

CREATE TABLE IF NOT EXISTS `Teacher` (
  `teacher_id` int(10) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  PRIMARY KEY (`teacher_id`),
  KEY `full_name` (`last_name`,`first_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `Teacher`
--

INSERT INTO `Teacher` (`teacher_id`, `first_name`, `last_name`) VALUES
(2, 'Srinivas', 'Akella'),
(4, 'Licheng', 'Jin'),
(3, 'Shakib', 'Miazi'),
(1, 'Harini', 'Ramaprasad');

-- --------------------------------------------------------

--
-- Stand-in structure for view `TeacherSchedule`
--
CREATE TABLE IF NOT EXISTS `TeacherSchedule` (
`Full Name` varchar(101)
,`Day` varchar(50)
,`Time Block` varchar(19)
);
-- --------------------------------------------------------

--
-- Table structure for table `TeacherSection`
--

CREATE TABLE IF NOT EXISTS `TeacherSection` (
  `teacher` int(10) NOT NULL,
  `section` int(10) NOT NULL,
  PRIMARY KEY (`teacher`,`section`),
  KEY `section` (`section`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `TeacherSection`
--

INSERT INTO `TeacherSection` (`teacher`, `section`) VALUES
(2, 1),
(1, 2),
(2, 2),
(3, 3),
(3, 4),
(1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `Transcript`
--

CREATE TABLE IF NOT EXISTS `Transcript` (
  `transcript_id` int(10) NOT NULL AUTO_INCREMENT,
  `student` int(10) DEFAULT NULL,
  PRIMARY KEY (`transcript_id`),
  KEY `student` (`student`),
  KEY `studentTranscript` (`student`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `Transcript`
--

INSERT INTO `Transcript` (`transcript_id`, `student`) VALUES
(6, 1),
(3, 2),
(1, 3),
(2, 4),
(4, 5),
(5, 6);

-- --------------------------------------------------------

--
-- Table structure for table `TranscriptCourse`
--

CREATE TABLE IF NOT EXISTS `TranscriptCourse` (
  `transcript` int(10) NOT NULL,
  `course` int(10) NOT NULL,
  PRIMARY KEY (`transcript`,`course`),
  KEY `course` (`course`),
  KEY `courseTrans` (`course`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `TranscriptCourse`
--

INSERT INTO `TranscriptCourse` (`transcript`, `course`) VALUES
(5, 1),
(1, 2),
(3, 3),
(1, 4),
(5, 7);