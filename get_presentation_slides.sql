CREATE DEFINER=`root`@`localhost` PROCEDURE `get_presentation_slides`(
	IN user_id INT,
	IN presentation_id INT
)
BEGIN
	# Ensure this user is the admin
	IF exists(SELECT userId FROM votodb.presentations WHERE userId = user_id AND presentationId = presentation_id)
    THEN
			SELECT *, UNIX_TIMESTAMP(dateCreated) as timeStamp FROM slides WHERE presentationId = presentation_id ORDER BY orderNumber ASC;
	END IF;
END
