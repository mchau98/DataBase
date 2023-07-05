--11
select concat(first_name,' ',last_name) as full_name, (2023 - extract(year from dob)) as age
from student where 2023 - extract(year from dob) >=25;
--12.
select student_id, concat(first_name,' ',last_name) as full_name
from student where extract(year from dob) = 1988 and extract(month from dob) = 10;
--13. 
select name , count(student_id) as so_luong
from clazz left join student on clazz.clazz_id = student.clazz_id
group by (clazz.name) order by (so_luong) desc;
--14.
select max(midterm_score), min(midterm_score), avg(midterm_score)
from enrollment where subject_id in 
(select subject_id from subject where name = 'Tin học đại cương') and semester = '20171';
--15. 
select concat(first_name,' ',last_name) as full_name, lecturer.lecturer_id, 
count(subject_id) as so_luong_mon
from lecturer
inner join teaching on lecturer.lecturer_id = teaching.lecturer_id
group by (lecturer.lecturer_id)
--16. 
select subject_id , count(lecturer_id) as lecturer_in_charge
from teaching group by (subject_id) having count(lecturer_id) >= 2
--17. 
select subject_id , count(*) as lecturer_in_charge
from teaching group by (subject_id) having  count(*)< 2;
--18. 
select student_id, concat (first_name,' ',last_name) as full_name
from subject join (select * from student join enrollment using (student_id)) as Gop using (subject_id)
where midterm_score *(100-percentage_final_exam)/100 + final_score*percentage_final_exam/100 = (select max(midterm_score *(100-percentage_final_exam)/100 + final_score*percentage_final_exam/100)
from subject join (select * from student join enrollment using (student_id)) as Gop using (subject_id)
where subject_id = 'IT1110' and semester = '20171')
and subject_id = 'IT1110' and semester = '20171';

select student.student_id, concat (first_name,' ',last_name) as full_name
from student
inner join enrollment on student.student_id = enrollment.student_id
inner join subject on enrollment.subject_id = subject.subject_id
where enrollment.subject_id = 'IT1110' and semester = '20171' 
group by full_name, 
student_id, midterm_score, final_score, percentage_final_exam 
order by (midterm_score *(1-percentage_final_exam/100) + final_score*percentage_final_exam/100) desc

select student_id, concat(last_name, ' ', first_name) as student_name, midterm_score, final_score, (midterm_score*(100-percentage_final_exam)/100+final_score*percentage_final_exam/100)as subject_score 
from student 
left join enrollment using(student_id) 
left join subject using(subject_id) 
where subject_id='IT3080' AND semester='20172' group by student_name, 
student_id, midterm_score, final_score, percentage_final_exam 
order by (midterm_score*(100-percentage_final_exam)/100+final_score*percentage_final_exam/100) desc limit 3;