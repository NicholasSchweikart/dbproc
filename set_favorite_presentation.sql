CREATE DEFINER=`root`@`localhost` PROCEDURE `set_favorite_presentation`(
	IN user_id INT,
	IN presentation_id INT
)
BEGIN

	# Ensure this user has admin rights
	IF EXISTS(SELECT * FROM votodb.sessions WHERE userId = user_id AND presentationId = presentation_id)
	THEN

		# Update the presentation to be the favorite
		UPDATE votodb.presentations
		SET isFavorite = 1 - isFavorite
		WHERE presentationId = presentation_id;

		# Return success to the caller
		SELECT 1;
	END IF;
END
