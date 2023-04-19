
--

DELIMITER //
--
-- Procedures
--
CREATE  PROCEDURE `addcourse`( IN courseName varchar( 255 ) ,IN  courseNumberCode int(50), IN credits
  INT(10),IN courseDescription VARCHAR(500))
  BEGIN 
  if not exists(select * from Course where course_number=courseNumberCode)
  then
  Insert into Course(name,course_number,credits,description)
  values(courseName,courseNumberCode,credits,courseDescription);
  else
  Select 'Another course with this coursenumber already exists , please choose a different course number'
  as errormessage;
  END if;
END//

CREATE  PROCEDURE `addCoursetoDepartment`( IN courseId int( 25 ) ,IN  departmentCode varchar(50))
  BEGIN 
  if not exists(Select * from DepartmentCourse where course=courseId )
  then
  Insert into DepartmentCourse(course,department) values(courseId,departmentCode);
  else
  select 'course already exists in the department' as errorMessage;
  END if;
END//

CREATE  PROCEDURE `adddepartment`( IN  departmentCode varchar( 255 ) , IN departmentName VARCHAR( 255 ) ,
  IN departmentDescription VARCHAR(500))
  BEGIN 
  if not exists(Select * from Department where abbreviated_name=departmentCode)
  then
  INSERT INTO Department (abbreviated_name,name,description) VALUES
  (departmentCode,departmentName,departmentDescription);
  else
  Select 'Another department with this departmentcode already exists , please choose a different
  departmentcode'as errormessage;
  END if;
END//

CREATE  PROCEDURE `addSectiontoCourse`( IN sectionNumber int( 25 ) , IN sectionLimit int( 25 ),IN year_value int( 25 ),IN teacher_id int( 25 ),IN courseId int( 25 ),IN semester_value varchar( 25 ),IN room_id int( 25 ),IN  lecture_type varchar(50))
  BEGIN 
  DECLARE results int;
  If not exists(Select section_id from Section where section_num=sectionNumber) then
  if not exists(Select teacher from Section where teacher=teacher_id and semester = semester_value and year= year_value)
  then
  call check_Sectionlimit(sectionLimit, room_id,@result);
  if(@result=1)
  then
  Insert into Section(section_num,section_limit,year,teacher,course,semester,room,lecture_type) 
  values(sectionNumber,sectionLimit,year,teacher_id,courseId,semester,room_id,lecture_type);
  Else
  Select 'Section Limit is more than Room Capacity, Please select different room' As Message;
  END if;
  Else
  SELECT 'Teacher is already handling one Subject this Semester .Please Select another Teacher' AS Message;
  END if;
  ELSE
  SELECT 'Section Already Exists' AS Message;
  END IF; 
END//

CREATE  PROCEDURE `check_Sectionlimit`(IN `seclimit` INT(10), IN `room` INT(10), OUT `limitresult` INT(10))
  BEGIN
  DECLARE capacity INT;
  DECLARE result INT;
  Set capacity=(Select capacity from Room where room_id=room);
  if(seclimit<=capacity)
  then
  SET result=1;
  else
  SET result=0;
  SET limitresult=result;
  END if;
END//

CREATE  PROCEDURE `sectionSchedule`(IN sectionId INT,IN daySlot varchar(10),timeSlot int(10))
  BEGIN
  if not exists(select * from SectionDayTime where DAY=daySlot and TIME =timeSlot)
  then
  Insert into SectionDayTime (section,DAY,TIME) values(sectionId,daySlot,timeSlot);
  else
  Select 'Another section is alloted for this day and time slot, please select a different day or
  different time' as errorMessage;
  END if;
END//

CREATE  PROCEDURE `studentEnrollsIntoSection`(IN sectionId int(10)  , IN student_id int(10))
  BEGIN
  Declare dayresult varchar(50);
  Declare timeresult int(10);
  if not exists(select * from StudentSection where section=sectionId and student=student_id)
  then
  Set dayresult = (select day from SectionDayTime where section=sectionId);
  Set timeresult = (select time from SectionDayTime where section=sectionId);
  call timingscheck(timeresult, student_id,@result);
  if not exists(select * from StudentSection sc inner join SectionDayTime sd using(section) where sd.day=dayresult  and 
  sc.student=student_id) and @result =1
  then
  if not exists(Select p.prerequisite from Section s inner join Course c on s.course = c.course_id 
  inner join Prerequisite p on c.course_id=p.course where s.section_id= sectionId)
  then
  insert into StudentSection (student,section) values(student_id,sectionId);
  else
  Select 'The course you are trying to enroll has Prerequisite courses , Please look in the course details to know about its prerequisites' as errorMessage;
  END if;
  else
  Select 'The section you are trying to enroll is conflicting with the other sections you already enrolled';
  END if;
  else
  Select 'You have already enrolled for this section,PLease choose a different section' as errorMessage;
  END if;
END//

CREATE  PROCEDURE `studentRegistration`( IN firstName varchar( 25 ) ,IN  lastName varchar(50),OUT studentRegistration_id int(10))
  BEGIN 
  Insert into Student(first_name,last_name) values(firstName,lastName);
  Select student_id into studentRegistration_id from Student where first_name=firstName and last_name=lastName ;
  END//

  CREATE  PROCEDURE `teacherRegistration`( IN firstName VARCHAR( 25 ) , IN lastName VARCHAR( 50 ) , OUT teacherRegistration_id INT( 10 ) )
  BEGIN INSERT INTO Teacher( first_name, last_name ) 
  VALUES (
  firstName, lastName);

  SELECT teacher_id
  INTO teacherRegistration_id
  FROM Teacher
  WHERE first_name = firstName
  AND last_name = lastName;
END//

CREATE  PROCEDURE `teacherSection`(IN teacherId int(10)  , IN sectionId int(10))
  BEGIN
  Declare dayresult varchar(50);
  Declare timeresult int(10);
  if not exists(select * from TeacherSection where section=sectionId and teacher=teacherId)
  then
  Set dayresult = (select day from SectionDayTime where section=sectionId);
  Set timeresult = (select time from SectionDayTime where section=sectionId);
  call teachertimingscheck(timeresult, teacherId,@result);
  if not exists(select * from TeacherSection sc inner join SectionDayTime sd using(section) where sd.day=dayresult and
  @result=1 and sc.teacher=teacherId)
  then
  insert into TeacherSection (teacher,section) values(teacherId,sectionId);
  else
  Select 'The section you are trying to enroll is conflicting with the other sections which you are already handling';
  END if;
  else
  Select 'You are already handling this section,PLease choose a different section to handle' as errorMessage;
  END if;
END//

CREATE  PROCEDURE `teachertimingscheck`(time_id int(10),teacher_id int(25),out result int(10))
  begin
  declare start_time time ;
  declare end_time time;
  set start_time = (select start_time from Lecture_Time where lecture_time_id =time_id);
  set end_time = (select end_time from Lecture_Time where lecture_time_id =time_id);
  if not exists(select * from TeacherSection sc inner join SectionDayTime sd using (section) inner join Lecture_Time lt on sd.TIME = lt.lecture_time_id
  where sc.teacher=teacher_id and start_time between lt.start_time and lt.end_time or start_time = lt.start_time or end_time between lt.start_time and
  lt.end_time)
  then
  set result =1;
  else
  set result=0;
  end if;
END//

CREATE  PROCEDURE `timingscheck`(time_id int(10),student_id int(25),out result int(10))
  begin
  declare start_time time ;
  declare end_time time;
  set start_time = (select start_time from Lecture_Time where lecture_time_id =time_id);
  set end_time = (select end_time from Lecture_Time where lecture_time_id =time_id);
  if not exists(select * from StudentSection sc inner join SectionDayTime sd using (section) inner join Lecture_Time lt on sd.TIME = lt.lecture_time_id
  where sc.student=student_id and start_time between lt.start_time and lt.end_time or start_time = lt.start_time or end_time between lt.start_time and
  lt.end_time)
  then
  set result =1;
  else
  set result=0;
  end if;
END//

DELIMITER ;