CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_classes`(
	IN user_id INT
)
BEGIN

	SELECT *, UNIX_TIMESTAMP(dateCreated) as timeStamp FROM classes WHERE userId = user_id ORDER BY timeStamp DESC;

END
