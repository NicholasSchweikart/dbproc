CREATE DEFINER=`voto`@`%` PROCEDURE `save_new_class`(
	IN user_id Int,
	IN class_name VARCHAR(100)
)
BEGIN
	# Ensure this user exists in the system
	IF EXISTS(SELECT userId FROM votodb.users WHERE userId = user_id LIMIT 1)
	THEN

		# Create the new class
		INSERT INTO votodb.classes(`userId`, `className`)
		VALUES (user_id, class_name);

		# Return the new class ID to the caller
		SELECT *
		FROM votodb.classes
		WHERE classId = last_insert_id();
	END IF;
END
