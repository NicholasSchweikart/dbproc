CREATE DEFINER=`root`@`localhost` PROCEDURE `save_new_response`(
  IN user_id INT,
  IN slide_id INT,
  IN user_answer VARCHAR(45)
)
BEGIN

    DECLARE answer_correct, is_active, authorized bool;
    DECLARE correct_answer VARCHAR(45);
    DECLARE presentation_id INT;

    SET answer_correct = false;

   SELECT presentationId INTO presentationId_id FROM votodev.slides WHERE slides.slideId = slide_id;

    # Check if the session is active and accepting votes
    IF EXISTS(SELECT * FROM votodev.presentations WHERE presentations.presentationId = presentationId_id AND presentations.isActive = true)
    THEN
		SET authorized = EXISTS(SELECT * FROM votodev.authorized_users WHERE userId = user_id AND presentationId = presentationId_id);

        # Extract the right answer to the question
		SELECT correctAnswer, isActive INTO correct_answer, is_active FROM votodev.slides WHERE slides.slideId = slide_id;

        # Check if this user is authorized to vote for this session
        IF(authorized AND is_active)
        THEN

            # Evaluate and mark if the user is correct
            IF( correct_answer = user_answer)
			THEN
				SET answer_correct = true;
			else
				SET answer_correct = false;
			END IF;

			# Check if this is a new vote, or simply an update of an old vote
			IF EXISTS(SELECT * FROM votodev.user_responses WHERE userId = user_id AND slideId = slide_id)
            THEN
				UPDATE votodev.user_responses SET answer = user_answer, isCorrect = answer_correct WHERE userId = user_id and slideId = slide_id;
			else
				INSERT INTO votodev.user_responses (userId, slideId, answer, isCorrect) VALUES(user_id, slide_id, user_answer, answer_correct);
			END IF;
            SELECT 1;
		END IF;

    END IF;
END
