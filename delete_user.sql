CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user`(
	IN user_id VARCHAR(45)
)
BEGIN

	IF EXISTS(SELECT userId FROM votodev.users WHERE userId = user_id)
	THEN
		DELETE FROM votodev.users WHERE userId = user_id LIMIT 1;
	ELSE
    SELECT "USER_DOESNT_EXIST";
	END IF;
END
