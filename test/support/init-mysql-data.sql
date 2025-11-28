create table departments(
  id int not null primary key auto_increment,
  name varchar(128) not null,
  location varchar(128) not null,
  mixedCase varchar(128)
);

create table employees(
  id int not null primary key auto_increment,
  name varchar(128) not null,
  job varchar(128) not null,
  manager_id int null,
  hire_date date not null,
  salary bigint not null,
  department_id int not null,
  is_remote boolean default false
);

create fulltext index employee_name_job on employees(name, job);

insert into departments(name, location) values ('tech', 'Guangzhou');
insert into departments(name, location) values ('finance', 'Beijing');

insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('vince', 'engineer', null, '2018-01-01', 100, 1);
insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('marry', 'trainee', 1, '2019-01-01', 50, 1);

insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('tom', 'director', null, '2018-01-01', 200, 2);
insert into employees(name, job, manager_id, hire_date, salary, department_id, is_remote)
values ('penny', 'assistant', 3, '2019-01-01', 100, 2, true);


