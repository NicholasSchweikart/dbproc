
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_presentation`(
	IN user_id INT,
	IN presentation_id INT
)
BEGIN

		SELECT *
        FROM votodev.presentations
        WHERE presenationId = presentation_id
        LIMIT 1;

END
