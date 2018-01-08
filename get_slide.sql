CREATE DEFINER=`root`@`localhost` PROCEDURE `get_slide`(
	IN user_id INT,
	IN slide_id INT
)
BEGIN
	DECLARE presentation_id, class_id, admin_user_id INT;

    # Extract the presenationId from this slide.
    SELECT presentationId, classId, userId INTO presentation_id, class_id, admin_user_id FROM votodb.slides WHERE slideId = slide_id;

    # See if this is the admin requesting the slide
    IF(user_id = admin_user_id)
    THEN
		# Admin so return the slide
		SELECT *
        FROM votodb.slides
        WHERE slideId = slide_id
        LIMIT 1;
	ELSE

        # See if user has privilage in the authorization table
        IF EXISTS(SELECT userId FROM votodb.authorized_users WHERE userId = user_id AND classId = class_id)
        THEN
			# Return the slide only if active
			SELECT *
            FROM votodb.slides
            WHERE slideId = slide_id AND isActive = true
            LIMIT 1;
        END IF;
    END IF;
END
