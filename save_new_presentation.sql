CREATE DEFINER=`root`@`localhost` PROCEDURE `save_new_presentation`(
	IN user_id INT,
	IN class_id INT,
	IN title_in VARCHAR(45),
	IN description_in VARCHAR(200)
)
BEGIN

	# Ensure this user owns the class
	IF EXISTS(SELECT classId FROM votodev.classes WHERE classId = class_id AND userId = user_id)
	THEN

		# Insert the new presentation
		INSERT INTO votodev.presentations (userId, classId, title, description)
		VALUES (user_id, class_id, title_in, description_in);

		# Update the class presentation count
		UPDATE votodev.classes
		SET totalPresentations = totalPresentations + 1
		WHERE classId = class_id;

		# Return the new presentationId to the caller
		SELECT *, UNIX_TIMESTAMP(dateCreated)
		AS timeStamp
		FROM votodev.presentations
		WHERE presentationId = last_insert_id();
	ELSE
		SELECT "UN_AUTHORIZED";
	END IF;
END
