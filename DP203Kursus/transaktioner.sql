

SELECT		*
FROM		hr.Ansat


BEGIN TRANSACTION
	UPDATE		hr.ansat
	SET			Salgsmaal = 23000
	WHERE		ansatId=7

ROLLBACK

COMMIT 

SELECT		*
FROM		sys.database_files

-- s� vi indf�rer transaktionsbegrebet for vores databaser i et Lake House
-- Databricks tilbyder et lakehouse
-- Synapse tilbyder et lakehouse

-- data gemmes i delta format - dvs -- delta - forskel
-- vi har en transaktionslog fil som holder styr p� alle �ndringer i vores database



