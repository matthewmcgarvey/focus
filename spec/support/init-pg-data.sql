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
  department_id int not null,
  is_remote boolean default false
);

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

create table airports(
  id serial primary key,
  code varchar(8) not null unique,
  name varchar(128) not null,
  city varchar(128) not null,
  country varchar(128) not null
);

create table aircrafts(
  id serial primary key,
  tail_number varchar(16) not null,
  model varchar(64) not null,
  seat_capacity int not null
);

create table flights(
  id serial primary key,
  flight_number varchar(16) not null,
  aircraft_id int not null,
  depart_airport_id int not null,
  arrive_airport_id int not null,
  depart_time timestamp not null,
  arrive_time timestamp not null,
  status varchar(16) default 'scheduled'
);

create table passengers(
  id serial primary key,
  first_name varchar(128) not null,
  last_name varchar(128) not null,
  email varchar(255) not null,
  birth_date date not null
);

create table bookings(
  id serial primary key,
  passenger_id int not null,
  booked_at timestamp not null,
  total_amount numeric(10, 2) not null,
  status varchar(16) not null
);

create table booking_flights(
  id serial primary key,
  booking_id int not null,
  flight_id int not null,
  seat varchar(6) null,
  service_class varchar(16) not null,
  price numeric(10, 2) not null
);

create table tickets(
  id serial primary key,
  booking_id int not null,
  passenger_id int not null,
  issued_at timestamp not null,
  status varchar(16) not null,
  is_refundable boolean default true
);

insert into airports(code, name, city, country)
values ('SFO', 'San Francisco International', 'San Francisco', 'USA');
insert into airports(code, name, city, country)
values ('LAX', 'Los Angeles International', 'Los Angeles', 'USA');
insert into airports(code, name, city, country)
values ('NRT', 'Narita International', 'Tokyo', 'Japan');

insert into aircrafts(tail_number, model, seat_capacity)
values ('N101FX', 'Airbus A320', 180);
insert into aircrafts(tail_number, model, seat_capacity)
values ('N202FX', 'Boeing 737-800', 160);
insert into aircrafts(tail_number, model, seat_capacity)
values ('N303FX', 'Boeing 787-9', 290);

insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX100', 1, 1, 2, '2024-04-01 08:30:00', '2024-04-01 10:05:00', 'scheduled');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX200', 2, 2, 3, '2024-04-02 13:15:00', '2024-04-03 17:45:00', 'delayed');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX300', 3, 3, 1, '2024-04-05 09:50:00', '2024-04-05 16:25:00', 'scheduled');

insert into passengers(first_name, last_name, email, birth_date)
values ('Avery', 'Nguyen', 'avery.nguyen@example.com', '1990-06-15');
insert into passengers(first_name, last_name, email, birth_date)
values ('Lena', 'Ortiz', 'lena.ortiz@example.com', '1985-11-23');
insert into passengers(first_name, last_name, email, birth_date)
values ('Miles', 'Patel', 'miles.patel@example.com', '1997-03-04');

insert into bookings(passenger_id, booked_at, total_amount, status)
values (1, '2024-03-20 12:00:00', 280.00, 'confirmed');
insert into bookings(passenger_id, booked_at, total_amount, status)
values (2, '2024-03-21 09:30:00', 920.00, 'ticketed');
insert into bookings(passenger_id, booked_at, total_amount, status)
values (3, '2024-03-22 15:45:00', 310.00, 'pending');

insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (1, 1, '12A', 'economy', 280.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (2, 2, '2C', 'business', 920.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (3, 3, null, 'economy', 310.00);

insert into airports(code, name, city, country)
values ('JFK', 'John F. Kennedy International', 'New York', 'USA');
insert into airports(code, name, city, country)
values ('ORD', 'O Hare International', 'Chicago', 'USA');
insert into airports(code, name, city, country)
values ('LHR', 'Heathrow', 'London', 'UK');
insert into airports(code, name, city, country)
values ('CDG', 'Charles de Gaulle', 'Paris', 'France');
insert into airports(code, name, city, country)
values ('SYD', 'Sydney Kingsford Smith', 'Sydney', 'Australia');

insert into aircrafts(tail_number, model, seat_capacity)
values ('N404FX', 'Airbus A350', 300);
insert into aircrafts(tail_number, model, seat_capacity)
values ('N505FX', 'Boeing 777-300ER', 350);

insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX110', 1, 4, 1, '2024-04-06 07:10:00', '2024-04-06 10:45:00', 'scheduled');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX120', 2, 1, 4, '2024-04-07 16:20:00', '2024-04-08 00:35:00', 'scheduled');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX130', 2, 5, 2, '2024-04-07 06:00:00', '2024-04-07 08:15:00', 'cancelled');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX140', 1, 2, 5, '2024-04-08 18:40:00', '2024-04-08 22:05:00', 'scheduled');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX150', 3, 6, 7, '2024-04-09 09:25:00', '2024-04-09 11:30:00', 'scheduled');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX160', 1, 7, 6, '2024-04-10 14:00:00', '2024-04-10 16:05:00', 'scheduled');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX170', 4, 8, 3, '2024-04-11 21:30:00', '2024-04-12 16:20:00', 'delayed');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX180', 4, 3, 8, '2024-04-13 10:05:00', '2024-04-13 20:10:00', 'scheduled');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX190', 5, 9, 1, '2024-04-14 07:45:00', '2024-04-14 15:30:00', 'scheduled');
insert into flights(flight_number, aircraft_id, depart_airport_id, arrive_airport_id, depart_time, arrive_time, status)
values ('FX195', 5, 1, 9, '2024-04-15 22:15:00', '2024-04-16 06:30:00', 'scheduled');

insert into passengers(first_name, last_name, email, birth_date)
values ('Nora', 'Kim', 'nora.kim@example.com', '1992-02-10');
insert into passengers(first_name, last_name, email, birth_date)
values ('Theo', 'Wright', 'theo.wright@example.com', '1980-09-14');
insert into passengers(first_name, last_name, email, birth_date)
values ('Isla', 'Garcia', 'isla.garcia@example.com', '1978-12-03');
insert into passengers(first_name, last_name, email, birth_date)
values ('Omar', 'Ali', 'omar.ali@example.com', '1995-07-22');
insert into passengers(first_name, last_name, email, birth_date)
values ('Sophie', 'Davis', 'sophie.davis@example.com', '1988-05-19');
insert into passengers(first_name, last_name, email, birth_date)
values ('Jun', 'Ito', 'jun.ito@example.com', '1993-01-09');

insert into bookings(passenger_id, booked_at, total_amount, status)
values (4, '2024-03-23 08:05:00', 450.00, 'confirmed');
insert into bookings(passenger_id, booked_at, total_amount, status)
values (5, '2024-03-24 20:40:00', 1200.00, 'ticketed');
insert into bookings(passenger_id, booked_at, total_amount, status)
values (6, '2024-03-25 11:15:00', 650.00, 'cancelled');
insert into bookings(passenger_id, booked_at, total_amount, status)
values (7, '2024-03-26 17:25:00', 310.00, 'confirmed');
insert into bookings(passenger_id, booked_at, total_amount, status)
values (8, '2024-03-27 07:50:00', 980.00, 'pending');
insert into bookings(passenger_id, booked_at, total_amount, status)
values (9, '2024-03-28 13:30:00', 1120.00, 'ticketed');

insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (4, 4, '14F', 'economy', 450.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (5, 5, '3A', 'business', 1200.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (6, 6, null, 'economy', 650.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (7, 7, '7B', 'premium', 310.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (8, 8, '22C', 'economy', 980.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (9, 9, '18D', 'economy', 1120.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (4, 10, '15A', 'economy', 180.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (5, 11, '1D', 'business', 650.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (8, 12, null, 'economy', 420.00);
insert into booking_flights(booking_id, flight_id, seat, service_class, price)
values (9, 13, '20E', 'economy', 500.00);

insert into tickets(booking_id, passenger_id, issued_at, status, is_refundable)
values (1, 1, '2024-03-20 12:10:00', 'issued', true);
insert into tickets(booking_id, passenger_id, issued_at, status, is_refundable)
values (2, 2, '2024-03-21 09:40:00', 'issued', true);
insert into tickets(booking_id, passenger_id, issued_at, status, is_refundable)
values (3, 3, '2024-03-22 16:05:00', 'held', true);
insert into tickets(booking_id, passenger_id, issued_at, status, is_refundable)
values (4, 4, '2024-03-23 08:20:00', 'issued', true);
insert into tickets(booking_id, passenger_id, issued_at, status, is_refundable)
values (5, 5, '2024-03-24 20:55:00', 'issued', false);
insert into tickets(booking_id, passenger_id, issued_at, status, is_refundable)
values (6, 6, '2024-03-25 11:30:00', 'voided', false);
insert into tickets(booking_id, passenger_id, issued_at, status, is_refundable)
values (7, 7, '2024-03-26 17:40:00', 'issued', true);
insert into tickets(booking_id, passenger_id, issued_at, status, is_refundable)
values (8, 8, '2024-03-27 08:05:00', 'held', true);
insert into tickets(booking_id, passenger_id, issued_at, status, is_refundable)
values (9, 9, '2024-03-28 13:50:00', 'issued', false);

create view booking_itineraries as
select
  b.id as booking_id,
  p.id as passenger_id,
  p.first_name,
  p.last_name,
  f.id as flight_id,
  f.flight_number,
  da.code as depart_airport_code,
  aa.code as arrive_airport_code,
  f.depart_time,
  f.arrive_time,
  bf.service_class,
  bf.seat,
  bf.price,
  b.status as booking_status
from bookings b
join passengers p on p.id = b.passenger_id
join booking_flights bf on bf.booking_id = b.id
join flights f on f.id = bf.flight_id
join airports da on da.id = f.depart_airport_id
join airports aa on aa.id = f.arrive_airport_id;

