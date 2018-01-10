# Returns 1 if  the transaction worked. 
CREATE DEFINER=`root`@`localhost` PROCEDURE `change_presentation_activation`(
  IN user_id INT,
  IN presentation_id INT,
  IN activate bool
)
BEGIN

  # Confirm that this userId owns this presentation
  IF EXISTS(SELECT presentationId FROM votodev.presentations WHERE userId = user_id AND presentationId = presentation_id)
  THEN

    # First de-activate all other presentations that are active.
    UPDATE votodev.presentations
    SET presentations.isActive = FALSE
    WHERE presentations.userId = user_id
    AND presentations.isActive = TRUE;

    UPDATE votodev.slides
    SET isActive = FALSE
    WHERE slides.presentationId = presentation_id;

    IF(activate)
    THEN
      # Then activate the session requested by the state_change
      UPDATE votodev.presentations
      SET isActive = TRUE, dateLastUsed = CURRENT_TIMESTAMP(), useCount = useCount + 1
      WHERE presentationId = presentation_id;
    END IF;

    SELECT 1;
  END IF;
END
