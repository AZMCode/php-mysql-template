Create Database alquimia;
Use alquimia;

create table Semester (
    id int not null auto_increment,
    dateStart date not null,
    dateEnd date not null,
    frozen boolean not null,
    primary key (id)
);

create table ServingTurn (
    id int not null auto_increment,
    startTime datetime not null,
    endTime datetime not null,
    semesterId int not null,
    descript varchar(1024),
    maxSlots int not null,
    frozen boolean not null,
    primary key (id),
    foreign key (semesterId) references Semester(id)
);


create table Client (
    id int not null auto_increment,
    fullName varchar(64) not null,
    passwordSalt binary(32) not null,
    passwordHash binary(32) not null,
    phone varchar(32) not null,
    email varchar(64) not null,
    primary key (id)
);

create table ClientToken (
    id char(64) not null,
    expiration datetime not null,
    clientId int not null,
    primary key (id),
    foreign key (clientId) references Client(id)
);

create table Reservation (
    id int not null auto_increment,
    clientId int not null,
    servingTurnId int not null,
    slots int not null,
    confirmed boolean not null,
    confirmationEnableTime datetime not null,
    confirmationEndTime datetime not null,
    note varchar(1024),
    frozen boolean not null,
    primary key (id),
    foreign key (servingTurnId) references ServingTurn(id),
    foreign key (clientId) references Client(id)
);

create table ClientNote (
    id int not null auto_increment,
    reservationId int not null,
    note varchar(1024) not null,
    primary key (id),
    foreign key (reservationId) references Reservation(id)
);

create table Plate (
    id int not null auto_increment,
    plateName varchar(128) not null,
    defaultPrice decimal(16,2) not null,
    descriptionShort varchar(256),
    descriptionLong varchar(1024),
    frozen boolean not null,
    primary key (id)
);

create table PlateImage (
    id int not null auto_increment,
    isPrimary boolean not null,
    plateId int not null,
    imageBlob longblob not null,
    mimetype varchar(64) not null,
    primary key (id),
    foreign key (plateId) references Plate(id)
);

create table Menu (
    id int not null auto_increment,
    servingTurnId int not null,
    menuDescription varchar(1024) not null,
    isOpen boolean not null,
    primary key(id),
    foreign key (servingTurnId) references ServingTurn(id)
);

create table PlateServing (
    id int not null auto_increment,
    plateId int not null,
    menuId int not null,
    slots int not null,
    price decimal(16,2) not null,
    primary key (id),
    foreign key (plateId) references Plate(id),
    foreign key (menuId) references Menu(id)
);

create table ReservationItem (
    id int not null auto_increment,
    reservationId int not null,
    servingId int not null,
    servingCount int not null,
    primary key (id),
    foreign key (reservationId) references Reservation(id),
    foreign key (servingId) references PlateServing(id)
);

create table Employee (
    id int not null auto_increment,
    username varchar(32) not null,
    passwordSalt binary(32) not null,
    passwordHash binary(32) not null,
    primary key (id)
);

create table EmployeePrivilege (
    id int not null auto_increment,
    employeeId int not null,
    privilegeLevel varchar(16) not null,
    constraint PrivilegeLevel check (privilegeLevel in ('table', 'register', 'kitchen','admin')),
    primary key (id),
    foreign key (employeeId) references Employee(id)
);

create table AdminToken (
    id char(64) not null,
    employeeId int not null,
    expiration datetime not null,
    primary key (id),
    foreign key (employeeId) references Employee(id)
);

create table SeatingTable (
    id int not null auto_increment,
    primary key (id)
);

create table OccupiedSeatingTable (
    id int not null auto_increment,
    seatingTableId int not null,
    reservationId int not null,
    primary key (id),
    foreign key (seatingTableId) references SeatingTable(id),
    foreign key (reservationId) references Reservation(id)
);

create table CookingJob (
    id int not null auto_increment,
    occupiedSeatingTableId int not null,
    expectedCompletionTime datetime not null,
    primary key (id),
    foreign key (occupiedSeatingTableId) references OccupiedSeatingTable(id)
);

create table PaymentInfo (
    id int not null auto_increment,
    reservationId int not null,
    paymentMethod varchar(32) not null,
    billingName varchar(128) not null,
    billingNit varchar(64) not null,
    constraint PaymentMethod check (paymentMethod in ('cash','card','qr')),
    primary key (id),
    foreign key (reservationId) references Reservation(id)
);