CREATE DEFINER=`root`@`localhost` PROCEDURE `save_new_presentation`(
	IN user_id INT,
	IN class_id INT,
	IN title_in VARCHAR(45),
	IN class_name VARCHAR(150),
	IN description_in VARCHAR(200)
)
BEGIN

	# Ensure this user owns the class
	IF EXISTS(SELECT classId FROM votodb.classes WHERE classId = class_id AND userId = user_id)
	THEN

		# Insert the new presentation
		INSERT INTO votodb.presentations (userId, classId, title, className, description)
		VALUES (user_id, class_id, title_in, class_name, description_in);

		# Return the new presentationId to the caller
		SELECT *, UNIX_TIMESTAMP(dateCreated)
		AS timeStamp
		FROM votodb.presentations
		WHERE presentationId = last_insert_id();

	END IF;
END
