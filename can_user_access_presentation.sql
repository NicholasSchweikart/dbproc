CREATE DEFINER=`root`@`localhost` PROCEDURE `can_user_access_presentation`(
	IN user_id INT,
	IN presentation_id INT
)
BEGIN
	DECLARE class_id, is_active INT;

	SELECT classId, isActive
	INTO class_id, is_active
	FROM votodb.presentations
	WHERE presentationId = presentation_id;

	IF (is_active)
	THEN

		# Check authorization for userId
		IF EXISTS(SELECT userId FROM votodb.authorized_users WHERE userId = user_id AND classId = class_id)
		THEN

			# Let the caller know all is well
			SELECT 1;

		END IF;
	END IF;
END
