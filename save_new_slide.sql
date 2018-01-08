
CREATE DEFINER=`root`@`localhost` PROCEDURE `save_new_slide`(
  IN user_id INT,
  IN presentation_id INT,
  IN class_id INT,
  IN img_file_name varchar(200),
  IN question varchar(200),
  IN order_number INT,
  IN correct_answer varchar(45)
)
BEGIN

  # Ensure this user has admin rights
  IF EXISTS(SELECT userId FROM votodb.presentations WHERE userId = user_id AND presenationId = presentation_id);
  THEN
    # Create questions
    INSERT INTO votodb.slides (presentationId, imgFileName, question, orderNumber, correctAnswer)
    VALUES (presentation_id, imgFileName,question,orderNumber,correctAnswer);

    # Return success to the application
    SELECT 1;
  END IF;
END
