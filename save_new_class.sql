CREATE DEFINER=`voto`@`%` PROCEDURE `save_new_class`(
	IN user_id Int,
	IN class_name VARCHAR(100),
	IN description_in VARCHAR(100)
)
BEGIN
	# Ensure this user exists in the system
	IF EXISTS(SELECT userId FROM votodev.users WHERE userId = user_id LIMIT 1)
	THEN

		# Create the new class
		INSERT INTO votodev.classes(`userId`, `className`, `description`)
		VALUES (user_id, class_name, description_in);

		# Return the new class ID to the caller
		SELECT *
		FROM votodev.classes
		WHERE classId = last_insert_id();
	END IF;
END
