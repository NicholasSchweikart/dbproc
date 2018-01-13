CREATE DEFINER=`root`@`localhost` PROCEDURE `update_presentation`(
  IN user_id INT,
  IN presentation_id INT,
  IN title_in VARCHAR(100),
  IN description_in VARCHAR(200)
)
BEGIN

    # Make sure this user is the admin for this presentation
    IF EXISTS(SELECT * FROM votodb.presentations WHERE presentationId = presentation_id AND userId = user_id)
    THEN

      # Update the presentation
      UPDATE votodb.presentations
      SET className = class_name, title = title_in, description = description_in
      WHERE presentationId = presentation_id;

      # Return the new slide to the caller
      SELECT *, UNIX_TIMESTAMP(dateCreated)
      AS timeStamp
      FROM votodb.presentations
      WHERE presentationId = presentation_id;
    ELSE
      SELECT "UN_AUTHORIZED";
	END IF;
END
