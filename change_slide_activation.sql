CREATE DEFINER=`voto`@`%` PROCEDURE `change_slide_activation`(
	IN user_id INT,
	IN slide_id INT,
	IN activate INT
)
BEGIN
	DECLARE presentation_id INT;
	SET presentation_id = 0;

	# Extract the presentationId for this slide
	SELECT presentationId INTO presentation_id FROM votodb.slides WHERE slideId = slide_id;

	# Check if this presentationId is active and is for this user.
	IF EXISTS(SELECT userId FROM votodb.presentations WHERE userId = user_id AND presentationId = presentation_id AND isActive = TRUE)
	THEN
		# First de-activate all slides (There should only ever be one active slide)
		UPDATE votodb.slides
		SET isActive = FALSE
		WHERE slides.presentationId = presentation_id;

		# If the new state is to be active then toggle it as such
		IF(activate)
		THEN
			# Set the slide active that was requested.
			UPDATE votodb.slides
			SET isActive = TRUE
			WHERE slides.slideId = slide_id;
		END IF;

		# Return the presentationId to the application so we can update all sockets in the room.
		SELECT presentation_id;
	END IF;
END
