--Marissa Gonçalves
--Amy Yip

--Database Tools 
--Assignment 3 - DML

-- 1. Create a foreign key in the product descriptions table by doing the 
--    following:
--    a. Modify the data in the language id field in the product descriptions 
--       table so that the foreign key can be made into the language table.  
--       What UPDATE command did you use?

		UPDATE product_descriptions
		   SET language_id = LOWER(language_id);

--    b. What SELECT statement could you use to see that there are matching records in the two tables?

		SELECT *
		  FROM product_descriptions INNER JOIN languages ON language_id = lang_abbr;

--    c. Issue a ROLLBACK command and then run the SELECT again.  Did anything change?

--		Yes, in the product_descriptions table, the language_id column reverted its data back to capital letters.
--		Therefore, when we issued the SELECT statement again, there were no matching records between the two tables.

--    d. If needed, issue the UPDATE command again.  Create the foreign key.  
--       What DDL command did you use?

		ALTER TABLE product_descriptions
			ADD CONSTRAINT product_desc_language_id_fk 
				FOREIGN KEY(language_id) 
				REFERENCES languages(lang_abbr);

--    e. Issue a ROLLBACK command and then run the SELECT again.  
--       Did anything change?  Why or why not?

--		Nothing has changed, because changes caused by issuing DDL commands cannot be rolled back.
--		Only DML commands (SELECT, INSERT, UPDATE, DELETE) can be rolled back.

-- 2. Create a foreign key in the customers table by doing the following:
--    a. Insert the language that you found to be missing in the last assignment. 
--       What INSERT command did you use?

		INSERT INTO languages 
			   (lang_name, lang_abbr)
		VALUES ('Hindi',   'hi');

--    b. Create the foreign key.  What DDL command did you use?

		ALTER TABLE customers
			ADD CONSTRAINT customers_nls_language_fk 
				FOREIGN KEY(nls_language) 
				REFERENCES languages(lang_abbr);

--    c. Try to DELETE the language that you added in 2a.  
--       What command did you use?  Was it successful?  If no, why not?

		DELETE FROM languages
			   WHERE lang_name LIKE 'Hindi';
			
--		It was not successful because we attempted to delete a parent key value that had a foreign key dependency.

--    d. What is the difference between a TRUNCATE and a DELETE without a WHERE clause?

--		If you TRUNCATE rows in a table, it would delete regardless of the WHERE clause.
--		Whereas DELETE only removes rows according to the WHERE clause specified in the SQL statement.


-- 3. Modify the language table to have a numeric column that could be a surrogate key.  
--    What commands are needed to do the following?
--    a. Create a sequence called language_seq that starts at 100 and goes up by 10.

		CREATE SEQUENCE  language_seq
			START WITH   100
			INCREMENT BY 10;

--    b. Add a column called lang_id to the language table that holds a 
--       3-digit integer.

		ALTER TABLE languages
			ADD lang_id NUMBER(3);

--    c. Populate the new column using a single UPDATE command.

		UPDATE languages
			SET lang_id = language_seq.NEXTVAL;








