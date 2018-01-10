
CREATE DEFINER=`root`@`localhost` PROCEDURE `save_new_slide`(
  IN user_id INT,
  IN presentation_id INT,
  IN img_file_name varchar(200),
  IN question varchar(200),
  IN order_number INT,
  IN correct_answer varchar(45)
)
BEGIN
  DECLARE class_id INT;
  SET class_id = 0;

  SELECT classId
  INTO class_id
  FROM votodev.presentations
  WHERE userId = user_id
  AND presentationId = presentation_id;

  # Ensure this user has admin rights
  IF(class_id)
  THEN
    # Create questions
    INSERT INTO votodev.slides (userId, classId, presentationId, imgFileName, question, orderNumber, correctAnswer)
    VALUES (user_id, class_id, presentation_id, img_file_name, question, order_number, correct_answer);

    # Update the presentations
    UPDATE votodev.presentations
    SET totalSlides = totalSlides + 1
    WHERE presentationId = presentation_id;

    # Return success to the application
    SELECT 1;
  END IF;
END
