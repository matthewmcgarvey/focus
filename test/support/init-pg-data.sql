create table departments(
  id serial primary key,
  name varchar(128) not null,
  location varchar(128) not null,
  "mixedCase" varchar(128)
);

create table employees(
  id serial primary key,
  name varchar(128) not null,
  job varchar(128) not null,
  manager_id int null,
  hire_date date not null,
  salary bigint not null,
  department_id int not null
);

insert into departments(name, location) values ('tech', 'Guangzhou');
insert into departments(name, location) values ('finance', 'Beijing');

insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('vince', 'engineer', null, '2018-01-01', 100, 1);
insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('marry', 'trainee', 1, '2019-01-01', 50, 1);

insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('tom', 'director', null, '2018-01-01', 200, 2);
insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('penny', 'assistant', 3, '2019-01-01', 100, 2);


