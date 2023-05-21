CREATE TYPE Gender AS ENUM (
  'Ж',
  'М'
);

CREATE TABLE OrderType (
    ID             INTEGER     NOT NULL PRIMARY KEY,
    OrderType      VARCHAR(50) NOT NULL
);

CREATE TABLE FlightType (
    ID             INTEGER     NOT NULL PRIMARY KEY,
    FlightType     VARCHAR(50) NOT NULL
);

CREATE TABLE DelayReason (
    ID             INTEGER     NOT NULL PRIMARY KEY,
    DelayReason    VARCHAR(50) NOT NULL
);

CREATE TABLE FlightStatus (
    ID             INTEGER     NOT NULL PRIMARY KEY,
    FlightStatus   VARCHAR(50) NOT NULL
);

CREATE TABLE Jobs (
    JobID         INTEGER     NOT NULL PRIMARY KEY,
    JobPosition   VARCHAR(50) NOT NULL
);

CREATE TABLE Administration (
    ChiefID            INTEGER     NOT NULL PRIMARY KEY,
    ChiefFullName      VARCHAR(50) NOT NULL,

    Age                INTEGER     NOT NULL CHECK(Age > 0),
    Sex                Gender      NOT NULL,
    Salary             INTEGER     NOT NULL CHECK(Salary > 0),
    LengthOfService    INTEGER     NOT NULL CHECK(LengthOfService >= 0),
    HasChildren        BOOLEAN     NOT NULL,
    QuantityOfChildren INTEGER
);

CREATE TABLE Department (
    DepartmentID        INTEGER    NOT NULL PRIMARY KEY,
    ChiefID             INTEGER    NOT NULL,
    JobID               INTEGER    NOT NULL,

    CONSTRAINT  Dep_ChiefID_fk
    FOREIGN KEY (ChiefID)
    REFERENCES  Administration(ChiefID),

    CONSTRAINT  Dep_JobID_fk
    FOREIGN KEY (JobID)
    REFERENCES  Jobs(JobID)
);

CREATE TABLE Brigade (
    BrigadeID           INTEGER     NOT NULL PRIMARY KEY,
    DepartmentID        INTEGER     NOT NULL,
    BrigadeType         INTEGER     NOT NULL,

    CONSTRAINT  Br_DepartmentID_fk
    FOREIGN KEY (DepartmentID)
    REFERENCES  Department(DepartmentID),

    CONSTRAINT  JobPositionID_fk
    FOREIGN KEY (BrigadeType)
    REFERENCES  Jobs(JobID)
);


CREATE TABLE Employees (
    EmployeeID         INTEGER     NOT NULL PRIMARY KEY,
    BrigadeID          INTEGER     NOT NULL,
    DepartmentID       INTEGER     NOT NULL,
    JobID              INTEGER     NOT NULL,

    EmployeeFullName   VARCHAR(50) NOT NULL,
    Age                INTEGER     NOT NULL CHECK(Age > 0),
    Sex                Gender      NOT NULL,
    Salary             INTEGER     NOT NULL CHECK(Salary > 0),
    LengthOfService    INTEGER     NOT NULL CHECK(LengthOfService >= 0),
    HasChildren        BOOLEAN     NOT NULL,
    QuantityOfChildren INTEGER,

    CONSTRAINT  Emp_BrigadeID_fk
    FOREIGN KEY (BrigadeID)
    REFERENCES  Brigade(BrigadeID),

    CONSTRAINT  Emp_JobID_fk
    FOREIGN KEY (JobID)
    REFERENCES  Jobs(JobID),

    CONSTRAINT  Emp_Department_fk
    FOREIGN KEY (DepartmentID)
    REFERENCES  Department(DepartmentID)
);

CREATE TABLE ProfSkills (
    ProfSkillID    INTEGER     NOT NULL PRIMARY KEY,
    JobID          INTEGER     NOT NULL,
    SkillName      VARCHAR(50) NOT NULL,

    CONSTRAINT  ProfSkills_JobID_fk
    FOREIGN KEY (JobID)
    REFERENCES  Jobs(JobID)
);

CREATE TABLE EmployeeSkills(
    EmployeeSkillID INTEGER     NOT NULL PRIMARY KEY,
    EmployeeID      INTEGER     NOT NULL,
    ProfSkillID     INTEGER     NOT NULL,
    SkillVal        VARCHAR(50) NOT NULL,

    CONSTRAINT  EmpSkills_EmployeeID_fk
    FOREIGN KEY (EmployeeID)
    REFERENCES  Employees(EmployeeID),

    CONSTRAINT  EmpSkills_ProfSkillID_fk
    FOREIGN KEY (ProfSkillID)
    REFERENCES  ProfSkills(ProfSkillID)
);

CREATE TABLE Aircraft  (
    AircraftID           INTEGER     NOT NULL PRIMARY KEY,
    BrigadePilotsID      INTEGER     NOT NULL,
    BrigadeTechID        INTEGER     NOT NULL,
    BrigadeServiceID     INTEGER     NOT NULL,

    AircraftType         VARCHAR(50) NOT NULL,
    Age                  INTEGER     NOT NULL CHECK(Age > 0),
    -- Поставить дату вместо age
    NumberOfSeats        INTEGER     NOT NULL CHECK(NumberOfSeats > 0),
    Airport              VARCHAR(50) NOT NULL,

    TankCapacity         INTEGER     NOT NULL CHECK(TankCapacity > 0),
    RemainFuel           INTEGER     NOT NULL CHECK(TankCapacity >= RemainFuel),

    CONSTRAINT  Air_BrigadePilotsID_fk
    FOREIGN KEY (BrigadePilotsID)
    REFERENCES  Brigade(BrigadeID),

    CONSTRAINT  Air_BrigadeTechID_fk
    FOREIGN KEY (BrigadeTechID)
    REFERENCES  Brigade(BrigadeID),

    CONSTRAINT  Air_BrigadeServiceID_fk
    FOREIGN KEY (BrigadeServiceID)
    REFERENCES  Brigade(BrigadeID)
);

CREATE TABLE AircraftServices (
    AircraftServiceID INTEGER     NOT NULL PRIMARY KEY,
    ServiceName       VARCHAR(50)     NOT NULL
);

CREATE TABLE ReceivedService(
    ReceivedServiceID INTEGER NOT NULL PRIMARY KEY,
    AircraftID        INTEGER NOT NULL,
    AircraftServiceID INTEGER NOT NULL,
    ProcedureDate     DATE    NOT NULL,
    CountOfService    INTEGER   NOT NULL,

    CONSTRAINT  RecServ_AirServ_fk
    FOREIGN KEY (AircraftServiceID)
    REFERENCES  AircraftServices(AircraftServiceID),

    CONSTRAINT  RecServ_Aircraft_fk
    FOREIGN KEY (AircraftID)
    REFERENCES  Aircraft(AircraftID)
);


CREATE TABLE Flights (
    FlightID            INTEGER      NOT NULL PRIMARY KEY,
    AircraftID          INTEGER      NOT NULL,
    FlightType          INTEGER      NOT NULL,
    DefaultTicketCost   INTEGER,
    NumberOfSeats       INTEGER,

    CONSTRAINT  Fl_AircraftID_fk
    FOREIGN KEY (AircraftID)
    REFERENCES  Aircraft(AircraftID),

    CONSTRAINT  Fl_FlightType_fk
    FOREIGN KEY (FlightType)
    REFERENCES  FlightType(ID)
);

CREATE TABLE  Airport(
    ID       INTEGER NOT NULL PRIMARY KEY,
    AirName     VARCHAR(5) NOT NULL,
    AirLocation VARCHAR(20) NOT NULL
);

CREATE TABLE Schedule (
    ID                  INTEGER      NOT NULL PRIMARY KEY,
    FlightID            INTEGER      NOT NULL,

    ScheduledDeparture  TIMESTAMP    NOT NULL,
    ScheduledArrival    TIMESTAMP    NOT NULL CHECK (ScheduledArrival > ScheduledDeparture),

    StartPoint          INTEGER      NOT NULL,
    TransferPoint       INTEGER,
    EndPoint            INTEGER      NOT NULL,
    FlightStatus        INTEGER      NOT NULL,

    ActualDeparture     TIMESTAMP,
    ActualArrival       TIMESTAMP    CHECK (ActualArrival > ActualDeparture),
    DelayReason         INTEGER,

    CONSTRAINT  Sch_FlightID_fk
    FOREIGN KEY (FlightID)
    REFERENCES  Flights(FlightID),

    CONSTRAINT  Sch_FightStatus_fk
    FOREIGN KEY (FlightStatus)
    REFERENCES  FlightStatus(ID),

    CONSTRAINT  Sch_DelayReason_fk
    FOREIGN KEY (DelayReason)
    REFERENCES  DelayReason(ID),

    CONSTRAINT  Sch_Start_fk
    FOREIGN KEY (StartPoint)
    REFERENCES  Airport(ID),

    CONSTRAINT  Sch_End_fk
    FOREIGN KEY (EndPoint)
    REFERENCES  Airport(ID)
);

CREATE TABLE Passenger(
    PassengerID           INTEGER     NOT NULL PRIMARY KEY,
    PassengerFullName     VARCHAR(50) NOT NULL,
    Age                   INTEGER     NOT NULL CHECK(Age > 0),
    Sex                   Gender      NOT NULL,
    Passport              VARCHAR(10) NOT NULL CHECK (length(Passport) = 10),
    ForeignPassport       VARCHAR(9)  CHECK (length(ForeignPassport) = 9 OR ForeignPassport IS NULL)
);

CREATE TABLE Baggage  (
    BaggageID   INTEGER NOT NULL PRIMARY KEY,
    PassengerID INTEGER NOT NULL,
    WeightKg    INTEGER NOT NULL CHECK(WeightKg > 0 AND WeightKg <= 25),

    CONSTRAINT  Baggage_Pass_fk
    FOREIGN KEY (PassengerID)
    REFERENCES  Passenger(PassengerID)
);


CREATE TABLE TicketStatus (
    ID             INTEGER     NOT NULL PRIMARY KEY,
    TicketStatus     VARCHAR(50) NOT NULL
);

CREATE TABLE Tickets (
    TicketID    INTEGER      NOT NULL PRIMARY KEY ,
    PassengerID INTEGER      NOT NULL,
    FlightID    INTEGER      NOT NULL,

    TicketCost  INTEGER      NOT NULL,
    Seat        VARCHAR(4)   NOT NULL,
    OrderType   INTEGER    NOT NULL,
    Status      INTEGER      NOT NULL,
    OrderTime   TIMESTAMP    NOT NULL,
    ReturnTime  TIMESTAMP    CHECK(ReturnTime > OrderTime),

    CONSTRAINT SeatFlight_uq
    UNIQUE     (FlightID, Seat),

    CONSTRAINT  Tick_FlightID_fk
    FOREIGN KEY (FlightID)
    REFERENCES  Flights(FlightID),

    CONSTRAINT  Tick_PassengerID_fk
    FOREIGN KEY (PassengerID)
    REFERENCES  Passenger(PassengerID),

    CONSTRAINT  Tick_Status_fk
    FOREIGN KEY (Status)
    REFERENCES  TicketStatus(ID),

    CONSTRAINT  Tick_Order_fk
    FOREIGN KEY (OrderType)
    REFERENCES  OrderType(ID)
);


-- 1. BrigadeTasks: За самолетом закреплены бригады насовсем?
-- 2. Schedule: если scheduled и actual различаются, считается ли это за задержку?
-- 3. Дефолтная цена билета в Flights и 0 в Tickets

-- Кол-во билетов для полета
-- Вместимость грузового самолета
-- список мест в самолете
