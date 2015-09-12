﻿-- Select user by UserName
CREATE PROCEDURE uspUserProfile_UserName
@Name NVarChar(50)
AS  
SELECT
	UserInformation.UserId,
	UserInformation.UserName,
	UserInformation.Location,
	UserInformation.Profession,
	UserInformation.Gender,
	UserInformation.AgeRange,
	UserInformation.SexualOrientation,
	UserInformation.EyeColor,
	UserInformation.HairColor,
	UserInformation.Height,
	UserInformation.Build

FROM UserInformation
wHERE UserName=@Name


-- Search for users by gender & sexual orientation
CREATE PROCEDURE uspSearchByGender_Orientation
@Gender NVarChar(50),
@Orientation NVarChar(50)

AS  
SELECT
	UserInformation.UserId,
	UserInformation.UserName,
	UserInformation.Location,
	UserInformation.Profession,
	UserInformation.Gender,
	UserInformation.AgeRange,
	UserInformation.SexualOrientation,
	UserInformation.EyeColor,
	UserInformation.HairColor,
	UserInformation.Height,
	UserInformation.Build

FROM UserInformation
wHERE Gender= @Gender
And
SexualOrientation=@Orientation

-- Select a user's profile information for a given ID
CREATE PROCEDURE uspUserProfile_UserID
@UserId int
AS  
SELECT
	--UserInformation.UserId,
	UserInformation.UserName,
	UserInformation.Location,
	UserInformation.Profession,
	UserInformation.Gender,
	UserInformation.AgeRange,
	UserInformation.SexualOrientation,
	UserInformation.EyeColor,
	UserInformation.HairColor,
	UserInformation.Height,
	UserInformation.Build

FROM UserInformation
wHERE UserId=@UserId


-- 
CREATE VIEW [UserLogin_W_UserName] AS
SELECT UserInformation.UserName, UserLogin.UserId, UserLogin.Email, UserLogin.Password
FROM UserInformation
Left Join  UserLogin
On UserInformation.UserId = UserLogin.UserId

SElect * From [UserLogin_W_UserName]


-- Add basic user information 
CREATE PROCEDURE uspAddNewUser
@UserName varchar(50),
@Password varchar (50),
@Email varchar(50)
AS

DECLARE @NewID INT

INSERT INTO UserInformation(UserName) VALUES(@userName)

SELECT @NewID = SCOPE_IDENTITY()

INSERT INTO UserLogin(UserID,Email,Password) VALUES(@NewID,@Password,@Email)


exec uspAddNewUser 'Grainne','Password','Grainne@gmail.com'


-- Add details for an existing user
CREATE PROCEDURE uspAddUserDetails
@userid int,
@profession varchar(50),
@location varchar (50),
@gender varchar(50),
@orientation varchar (50),
@age varchar(50),
@haircolor varchar(50),
@eyecolor varchar(50),
@height varchar (50),
@build varchar(50),
@profilepic varchar(max)
AS
UPDATE UserInformation SET Profession =@profession,
						   Location=@location,
						   Gender=@gender,
						   SexualOrientation=@orientation,
						   AgeRange=@age,
						   HairColor=@haircolor,
						   EyeColor=@eyecolor,
						   Height=@height,
						   Build=@build,
						   ProfilePicturePath=@profilepic
				

WHERE UserId=@userid

exec uspAddUserDetails 16, 'Dublin','Teacher','Female','Straight','18-25','Brown','Green','Tall','Slim','wwwe'