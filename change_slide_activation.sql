CREATE DEFINER=`voto`@`%` PROCEDURE `change_slide_activation`(
	IN user_id INT,
	IN slide_id INT,
	IN activate INT
)
BEGIN
	DECLARE presentation_id, admin_id INT;
	SET presentation_id = 0;

	# Extract the presentationId for this slide
	SELECT presentationId, userId INTO presentation_id, admin_id FROM votodev.slides WHERE slideId = slide_id;

	IF(user_id != admin_id)
	THEN
		SELECT "UN_AUTHORIZED";
	ELSE
		# Check if this presentationId is active and is for this user.
		IF EXISTS(SELECT userId FROM votodev.presentations WHERE userId = user_id AND presentationId = presentation_id AND isActive = TRUE)
		THEN

			# First de-activate all slides (There should only ever be one active slide)
			UPDATE votodev.slides
			SET isActive = FALSE
			WHERE slides.presentationId = presentation_id;

			# If the new state is to be active then toggle it as such
			IF(activate)
			THEN
				# Set the slide active that was requested.
				UPDATE votodev.slides
				SET isActive = TRUE
				WHERE slides.slideId = slide_id;
			END IF;

			# Return the presentationId to the application so we can update all sockets in the room.
			SELECT presentation_id;
			ELSE
				SELECT "UN_AUTHORIZED";
		END IF;
	END IF;
END
