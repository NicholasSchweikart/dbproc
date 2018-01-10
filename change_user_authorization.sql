CREATE DEFINER=`voto`@`%` PROCEDURE `change_user_authorization`(
IN admin_user_id INT,
IN user_id INT,
IN class_id INT,
IN allowAccess INT
)
BEGIN
	DECLARE alreadyAuth INT;

	# First check to see that the admin owns this class
	IF EXISTS(SELECT userId FROM votodev.classes WHERE userId = admin_user_id AND classId = class_id)
	THEN

		# Now see if this user actually exists
		IF EXISTS(SELECT userId from votodev.users WHERE userId = user_id)
		THEN

			SET alreadyAuth = EXISTS(SELECT userId FROM authorized_users WHERE userId = user_id AND classId = class_id);

			# Remove the access if requested
			IF alreadyAuth AND NOT allowAccess
			THEN
			
				# Revoke the access
				DELETE FROM votodev.authorized_users
				WHERE userId = user_id
				AND classId = class_id;

				SELECT 1;
			END IF;

			# Allow the access if they havent
			IF NOT alreadyAuth AND allowAccess
			THEN
				# Allow the access
				INSERT INTO votodev.authorized_users(classId,userId)
				VALUES(class_id, user_id);
				SELECT 1;
			END IF;
		END IF;
	END IF;
END
