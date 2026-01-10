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
  hire_date text not null,
  salary integer not null,
  department_id integer not null,
  is_remote boolean default false
);

insert into departments(name, location) values ('tech', 'Guangzhou');
insert into departments(name, location) values ('finance', 'Beijing');

insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('vince', 'engineer', null, "2022-08-12 08:30:23.000", 100, 1);
insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('marry', 'trainee', 1, "2022-08-12 08:30:23.000", 50, 1);

insert into employees(name, job, manager_id, hire_date, salary, department_id)
values ('tom', 'director', null, "2022-08-12 08:30:23.000", 200, 2);
insert into employees(name, job, manager_id, hire_date, salary, department_id, is_remote)
values ('penny', 'assistant', 3, "2022-08-12 08:30:23.000", 100, 2, true);
