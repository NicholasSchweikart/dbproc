CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user`(
	IN firstName VARCHAR(45),
	IN lastName VARCHAR(45),
	IN userName VARCHAR(45),
	IN passwordSalt VARCHAR(200),
	IN passwordHash VARCHAR(200),
	IN type VARCHAR(1),
	IN email VARCHAR(320)
)
BEGIN

	# Create the new user
	INSERT INTO users (firstName, lastName, userName, passwordSalt, passwordHash, type, email )
	VALUES(
		firstName,
		lastName,
		userName,
		passwordSalt,
		passwordHash,
		type,
		email
	);

	# Return the new user to the caller
	SELECT *
	FROM votodev.users
	WHERE userId = last_insert_id()
	LIMIT 1;
END
