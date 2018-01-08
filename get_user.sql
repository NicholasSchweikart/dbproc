CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user`(
	IN userName VARCHAR(100)
)
BEGIN

	# Return the new user to the caller
	SELECT *
	FROM votodb.users
	WHERE userName = userName
	LIMIT 1;

END
