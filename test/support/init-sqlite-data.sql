create table departments(
  id integer primary key autoincrement,
  name text not null,
  location text not null,
  mixedCase text
);

create table employees(
  id integer primary key autoincrement,
  name text not null,
  job text not null,
  manager_id integer null,
  hire_date integer not null,
  salary integer not null,
  department_id integer not null
);

insert into departments(name, location) values ('tech', 'Guangzhou');
insert into departments(name, location) values ('finance', 'Beijing');

insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('vince', 'engineer', null, 1514736000000, 100, 1);
insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('marry', 'trainee', 1, 1546272000000, 50, 1);

insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('tom', 'director', null, 1514736000000, 200, 2);
insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('penny', 'assistant', 3, 1546272000000, 100, 2);