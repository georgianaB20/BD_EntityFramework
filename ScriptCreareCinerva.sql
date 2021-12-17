
--BEGIN TRANSACTION
--DROP TABLE Reviews
--DROP TABLE RoomReservations
--DROP TABLE Reservations
--DROP TABLE RoomFacilities
--DROP TABLE RoomFeatures
--DROP TABLE Rooms
--DROP TABLE RoomCategories
--DROP TABLE PropertyFacilities
--DROP TABLE GeneralFeatures
--DROP TABLE PropertyImages
--DROP TABLE Properties
--DROP TABLE PropertyTypes
--DROP TABLE Cities
--DROP TABLE Countries
--DROP TABLE Users
--DROP TABLE Roles
--COMMIT

--CREATE DATABASE Cinerva;

CREATE TABLE Roles(
Id INT IDENTITY(1,1) NOT NULL,
Name NVARCHAR(50),
PRIMARY KEY(Id)
)

CREATE TABLE Users(
Id INT IDENTITY(1,1) NOT NULL,
FirstName NVARCHAR(200) NOT NULL,
LastName NVARCHAR(200) NOT NULL,
RoleId INT NOT NULL,
Email nvarchar(100) NOT NULL,
Password CHAR(100) NOT NULL,
Phone CHAR(25),
IsDeleted BIT DEFAULT 0,
IsBanned BIT DEFAULT 0,
PRIMARY KEY (Id),
CONSTRAINT fk_Users_RoleId FOREIGN KEY (RoleId) REFERENCES Roles(Id),
) 

CREATE TABLE Countries(
Id INT IDENTITY(1,1) NOT NULL,
Name NVARCHAR(100) NOT NULL,
PRIMARY KEY (Id)
)

CREATE TABLE Cities(
Id INT IDENTITY(1,1) NOT NULL,
Name NVARCHAR(100) NOT NULL,
CountryId INT NOT NULL,
PRIMARY KEY (Id),
CONSTRAINT fk_Citites_CountryId FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

CREATE TABLE PropertyTypes(
Id INT IDENTITY(1,1) NOT NULL,
Type NVARCHAR(50)--Name?
PRIMARY KEY (Id)
)

CREATE TABLE Properties(
Id INT IDENTITY(1,1) NOT NULL,
Name NVARCHAR(250) NOT NULL,
Rating DECIMAL(2,1) NOT NULL,
Description NVARCHAR(MAX),
Address NVARCHAR(200),
AdministratorId INT NOT NULL,
CityId INT NOT NULL,
Phone CHAR(25),
TotalRooms INT NOT NULL,
NumberOfDaysForRefunds INT NOT NULL,
PropertyTypeId INT NOT NULL,
PRIMARY KEY (Id),
CONSTRAINT fk_Properties_AdministratorId FOREIGN KEY (AdministratorId) REFERENCES Users(Id),
CONSTRAINT fk_Properties_CityId FOREIGN KEY (CityId) REFERENCES Cities(Id),
CONSTRAINT fk_Properties_PropertyTypeId FOREIGN KEY (PropertyTypeId) REFERENCES PropertyTypes(Id),
)

CREATE TABLE PropertyImages(
Id INT IDENTITY(1,1) NOT NULL,
ImageUrl NVARCHAR(2500) NOT NULL,
PropertyId INT NOT NULL,
PRIMARY KEY (Id),
CONSTRAINT fk_PropertyImages_PropertyId FOREIGN KEY (PropertyId) REFERENCES Properties(Id),
)

CREATE TABLE GeneralFeatures(
Id INT IDENTITY(1,1) NOT NULL,
Name NVARCHAR(500) NOT NULL,
IconUrl NVARCHAR(500) NOT NULL,
PRIMARY KEY (Id)
)

CREATE TABLE PropertyFacilities(
PropertyId INT NOT NULL,
FacilityId INT NOT NULL,
PRIMARY KEY (PropertyId,FacilityId),
CONSTRAINT fk_PropertyFacilities_PropertyId FOREIGN KEY (PropertyId) REFERENCES Properties(Id),
CONSTRAINT fk_PropertyFacilities_FacilityId FOREIGN KEY (FacilityId) REFERENCES GeneralFeatures(Id)
)

CREATE TABLE RoomCategories(
Id INT IDENTITY(1,1) NOT NULL,
Name VARCHAR(100) NOT NULL,
BedsCount INT NOT NULL,
Description NVARCHAR(500),
Price DECIMAL(20,2) NOT NULL,
PRIMARY KEY (Id)
)

CREATE TABLE Rooms(
Id INT IDENTITY(1,1) NOT NULL,
RoomCategoryId INT NOT NULL,
PropertyId INT NOT NULL,
PRIMARY KEY (Id),
CONSTRAINT fk_Rooms_RoomCategoryId FOREIGN KEY (RoomCategoryId) REFERENCES RoomCategories(Id),
CONSTRAINT fk_Rooms_PropertyId FOREIGN KEY (PropertyId) REFERENCES Properties(Id),
)

CREATE TABLE RoomFeatures(
Id INT IDENTITY(1,1) NOT NULL,
Name NVARCHAR(500) NOT NULL,
IconUrl NVARCHAR(500) NOT NULL,
PRIMARY KEY (Id)
)

CREATE TABLE RoomFacilities(
RoomId INT NOT NULL,
FacilityId INT NOT NULL,
PRIMARY KEY (RoomId,FacilityId),
CONSTRAINT fk_RoomFacilities_RoomId FOREIGN KEY (RoomId) REFERENCES Rooms(Id),
CONSTRAINT fk_RoomFacilities_FacilityId FOREIGN KEY (FacilityId) REFERENCES RoomFeatures(Id)
)

CREATE TABLE Reservations(
Id INT IDENTITY(1,1) NOT NULL,
UserId INT NOT NULL,
CheckInDate DATE NOT NULL,
CheckOutDate DATE NOT NULL,
PayedStatus BIT DEFAULT 0,
PaymentMethod VARCHAR(20) NOT NULL,
CancelDate DATE,
Price DECIMAL(20,2) NOT NULL,
PRIMARY KEY (Id),
CONSTRAINT fk_Reservations_UserId FOREIGN KEY (UserId) REFERENCES Users(Id)
)

CREATE TABLE RoomReservations(
Id INT IDENTITY(1,1) NOT NULL,
RoomId INT NOT NULL,
ReservationId INT NOT NULL,
PRIMARY KEY (Id),
CONSTRAINT fk_RoomReservations_RoomId FOREIGN KEY (RoomId) REFERENCES Rooms(Id),
CONSTRAINT fk_RoomReservations_ReservationId FOREIGN KEY (ReservationId) REFERENCES Reservations(Id)
)

CREATE TABLE Reviews(
UserId INT NOT NULL,
PropertyId INT NOT NULL,
Description NVARCHAR(200),
Rating int NOT NULL,
ReviewDate DATE NOT NULL,
PRIMARY KEY (UserId,PropertyId),
CONSTRAINT fk_Reviews_UserId FOREIGN KEY (UserId) REFERENCES Users(Id),
CONSTRAINT fk_Reviews_PropertyId FOREIGN KEY (PropertyId) REFERENCES Properties(Id)
)


INSERT INTO Roles(Name) VALUES('SuperAdmin');
INSERT INTO Roles(Name) VALUES('PropertyAdmin');
INSERT INTO Roles(Name) VALUES('Client');

INSERT INTO GeneralFeatures(Name,IconUrl) VALUES ('Pool','https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/50/000000/external-pool-vacation-vitaliy-gorbachev-flat-vitaly-gorbachev.png');
INSERT INTO GeneralFeatures(Name,IconUrl) VALUES ('Kids Pool','https://img.icons8.com/fluency/50/000000/kids-pool.png');
INSERT INTO GeneralFeatures(Name,IconUrl) VALUES ('Tennis','https://img.icons8.com/external-icongeek26-flat-icongeek26/50/000000/external-tennis-sports-and-games-icongeek26-flat-icongeek26.png');
INSERT INTO GeneralFeatures(Name,IconUrl) VALUES ('Spa','https://img.icons8.com/external-icongeek26-flat-icongeek26/50/000000/external-spa-ayurveda-icongeek26-flat-icongeek26.png');
INSERT INTO GeneralFeatures(Name,IconUrl) VALUES ('Parking Lot','https://img.icons8.com/color/64/000000/parking.png');
INSERT INTO GeneralFeatures(Name,IconUrl) VALUES ('No Parking','https://img.icons8.com/color/48/000000/no-parking.png');
INSERT INTO GeneralFeatures(Name,IconUrl) VALUES ('Paid Parking','https://img.icons8.com/color/48/000000/paid-parking.png');
INSERT INTO GeneralFeatures(Name,IconUrl) VALUES ('Conference Room','https://img.icons8.com/fluency/48/000000/meeting-room.png');
INSERT INTO GeneralFeatures(Name,IconUrl) VALUES ('Cooking Stove','https://img.icons8.com/color/48/000000/fry.png');
INSERT INTO GeneralFeatures(Name,IconUrl) VALUES ('Cooking Utensils','https://img.icons8.com/color/48/000000/spachelor.png');

INSERT INTO RoomFeatures(Name,IconUrl) VALUES ('Air Conditioner','https://img.icons8.com/color/48/000000/air-conditioner.png');
INSERT INTO RoomFeatures(Name,IconUrl) VALUES ('Hair Dryer','https://img.icons8.com/color/48/000000/hair-dryer.png');
INSERT INTO RoomFeatures(Name,IconUrl) VALUES ('Queen Bed','https://img.icons8.com/color/48/000000/double-bed.png');
INSERT INTO RoomFeatures(Name,IconUrl) VALUES ('Extendable Sofa','https://img.icons8.com/color/48/000000/three-seater-sofa.png');
INSERT INTO RoomFeatures(Name,IconUrl) VALUES ('Single Bed','https://img.icons8.com/color/48/000000/single-bed.png');
INSERT INTO RoomFeatures(Name,IconUrl) VALUES ('Bunk Bed','https://img.icons8.com/color/48/000000/kids-bedroom.png');
INSERT INTO RoomFeatures(Name,IconUrl) VALUES ('Balcony','https://img.icons8.com/color/48/000000/balcony.png');
INSERT INTO RoomFeatures(Name,IconUrl) VALUES ('Sea View','https://img.icons8.com/color/48/000000/bay.png');
INSERT INTO RoomFeatures(Name,IconUrl) VALUES ('Mountains View','https://img.icons8.com/color/48/000000/mountain.png');
INSERT INTO RoomFeatures(Name,IconUrl) VALUES ('Panoramic View','https://img.icons8.com/color/48/000000/medium-icons.png');

INSERT INTO PropertyTypes(Type) VALUES ('Hotel');
INSERT INTO PropertyTypes(Type) VALUES ('Motel');
INSERT INTO PropertyTypes(Type) VALUES ('Guest House');
INSERT INTO PropertyTypes(Type) VALUES ('Apartment');
INSERT INTO PropertyTypes(Type) VALUES ('House');
INSERT INTO PropertyTypes(Type) VALUES ('Penthouse');
INSERT INTO PropertyTypes(Type) VALUES ('Bungalow');
INSERT INTO PropertyTypes(Type) VALUES ('Chalet');
INSERT INTO PropertyTypes(Type) VALUES ('Mansion');
INSERT INTO PropertyTypes(Type) VALUES ('Treehouse');
INSERT INTO PropertyTypes(Type) VALUES ('Igloo');
INSERT INTO PropertyTypes(Type) VALUES ('Lake house');


