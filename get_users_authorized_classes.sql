CREATE DEFINER=`root`@`localhost` PROCEDURE `get_users_authorized_classes`(
	IN user_id VARCHAR(100)
)
BEGIN

	# Return the classes this user has access too
	SELECT classId
	FROM votodev.authorized_users
	WHERE userId = user_id;

END
