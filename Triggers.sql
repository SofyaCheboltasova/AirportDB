-- Проверяет существует ли уже такая JobPosition
CREATE OR REPLACE FUNCTION check_job_position() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.JobPosition IN (SELECT JobPosition FROM Jobs) THEN
    RAISE EXCEPTION 'Такое значение JobPosition уже существует в `Jobs`';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_job_position_trigger
BEFORE INSERT OR UPDATE ON Jobs
FOR EACH ROW
EXECUTE FUNCTION check_job_position();


-- Проверяет существует ли уже такой ProfSkill
CREATE OR REPLACE FUNCTION check_profskill() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.SkillName IN (SELECT SkillName FROM ProfSkills) THEN
    RAISE EXCEPTION 'Такое значение SkillName уже существует в `ProfSkills`';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_profskill_trigger
BEFORE INSERT OR UPDATE ON ProfSkills
FOR EACH ROW
EXECUTE FUNCTION check_profskill();


-- Проверка на соответствие бригад самолета их BrigadeType
CREATE OR REPLACE FUNCTION check_aircraft_brigades() RETURNS TRIGGER AS $$
DECLARE
  brigade_type VARCHAR(50);
BEGIN
  SELECT JobPosition INTO brigade_type FROM Jobs WHERE JobID = NEW.BrigadePilotsID;
  IF brigade_type <> 'Пилот' THEN
    RAISE EXCEPTION 'BrigadePilotsID должен соответстввать BrigadeType = `Пилот`';
  END IF;

  SELECT JobPosition INTO brigade_type FROM Jobs WHERE JobID = NEW.BrigadeTechID;
  IF brigade_type <> 'Техник' THEN
    RAISE EXCEPTION 'BrigadeTechID должен соответстввать BrigadeType = `Техник`';
  END IF;

  SELECT JobPosition INTO brigade_type FROM Jobs WHERE JobID = NEW.BrigadeServiceID;
  IF brigade_type <> 'Персонал' THEN
    RAISE EXCEPTION 'BrigadeServiceID должен соответстввать BrigadeType = `Персонал`';
  END IF;

  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_aircraft_brigades_trigger
BEFORE INSERT OR UPDATE ON Aircraft
FOR EACH ROW
EXECUTE FUNCTION check_aircraft_brigades();

INSERT INTO Aircraft (aircraftid, brigadepilotsid, aircrafttype, brigadeserviceid, age, airport, remainfuel, numberofseats, tankcapacity, brigadetechid)
VALUES (6, 4, 'Airbus a200', 13, 10, 'Пулково', 2000, 10, 2000, 4);


-- Проверяет существует ли уже такой AircraftServices
CREATE OR REPLACE FUNCTION check_aircraft_service() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.ServiceName IN (SELECT ServiceName FROM AircraftServices) THEN
    RAISE EXCEPTION 'Такое значение ServiceName уже существует в`AircraftServices`';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_aircraft_service_trigger
BEFORE INSERT OR UPDATE ON AircraftServices
FOR EACH ROW
EXECUTE FUNCTION check_aircraft_service();


-- QuantityOfChildren = 0, если HasChildren = "false":
CREATE OR REPLACE FUNCTION nochildren_trigger_chief()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.HasChildren = 'false' THEN
        UPDATE Administration SET QuantityOfChildren = 0 WHERE ChiefID = NEW.ChiefID;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER NoChildren_trigger_chief
AFTER UPDATE OR INSERT ON Administration
FOR EACH ROW
WHEN(NEW.haschildren = 'false')
EXECUTE FUNCTION nochildren_trigger_chief();


-- Проверяет существует ли уже такой FlightType
CREATE OR REPLACE FUNCTION check_flighttype() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.FlightType IN (SELECT FlightType FROM FlightType) THEN
    RAISE EXCEPTION 'Такое значение FlightType уже существует в`FlightType`';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_flighttype_trigger
BEFORE INSERT OR UPDATE ON FlightType
FOR EACH ROW
EXECUTE FUNCTION check_flighttype();


-- Удаление пассажира
CREATE OR REPLACE FUNCTION check_delete_passenger() RETURNS TRIGGER AS $$
DECLARE baggage_count INT;
BEGIN
    SELECT COUNT(*) INTO baggage_count FROM Baggage WHERE PassengerID = OLD.PassengerID;
    IF baggage_count > 0 THEN
        RAISE EXCEPTION 'Нельзя удалить пассажира, с которым связан `Baggage`';
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_delete_passenger
BEFORE DELETE ON Passenger
FOR EACH ROW
EXECUTE FUNCTION check_delete_passenger();

DELETE FROM Passenger WHERE PassengerID = 1;
