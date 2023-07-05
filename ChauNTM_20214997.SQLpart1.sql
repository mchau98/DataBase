-- student(student_id, first_name, last_name, dob, gender, address, note, clazz_id)
-- subject(subject_id, name, credit, percentage_final_exam)
--lecturer(lecturer_id, first_name, last_name, dob, gender, address, email)
--teaching(subject_id, lecturer_id)
--clazz(clazz_id, name, lecturer_id, monitor_id)
--enrollment(student_id, subject_id, semester, midterm_score, final_score)

--1
select * from subject
where credit > 3;
--2
select student_id, concat(first_name,' ',last_name) from student 
where student_id in 
(select student_id from clazz where name = 'CNTT2.01-K62');
--3
select student_id, concat (student.first_name,' ',student.last_name) from student,clazz 
where student.clazz_id = clazz.clazz_id
and clazz.name like '%CNTT%';
--4
 select student_id, concat(first_name,' ',last_name) from student 
where student_id in 
(select student_id from enrollment where subject_id in 
(select subject_id from subject where name = 'Cơ sở dữ liệu')
intersect 
 select student_id from enrollment where subject_id in 
(select subject_id from subject where name = 'Tin học đại cương'));
--5
select student.student_id, concat(first_name,' ',last_name) from student 
inner join enrollment on student.student_id = enrollment.student_id
inner join subject on enrollment.subject_id = subject.subject_id
where subject.name = 'Cơ sở dữ liệu' or subject.name = 'Tin học đại cương'
--6
select subject_id, subject.name from subject 
where subject_id in 
((select subject.subject_id from subject)
 except (select enrollment.subject_id from enrollment));
--7
select subject.name, credit from subject
inner join enrollment on subject.subject_id = enrollment.subject_id
inner join student on enrollment.student_id = student.student_id
where student.first_name like '%Nhật Ánh%' and semester like '%20171%'
--8
select student.student_id, concat(first_name,' ',last_name) as full_name,
midterm_score, final_score, 
(midterm_score*(1-percentage_final_exam/100)+final_score*percentage_final_exam/100) as sb_score
from student
inner join enrollment on student.student_id = enrollment.student_id
inner join subject on enrollment.subject_id = subject.subject_id
where subject.name = 'Cơ sở dữ liệu' and semester = '20172'
--9
select student.student_id from student
inner join enrollment on student.student_id = enrollment.student_id
inner join subject on enrollment.subject_id = subject.subject_id
where midterm_score < 3 or final_score <3 
or 
(midterm_score*(1-percentage_final_exam/100)+final_score*percentage_final_exam/100)<4
and enrollment.subject_id = 'IT1110' and semester = '20171'
--10
select student_id, concat(first_name,' ',last_name), monitor_id as monitor, name 
from student
inner join clazz on student.clazz_id = clazz.clazz_id
