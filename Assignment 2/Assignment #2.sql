-- Marissa Goncalves
-- Amy Yip

--Assignment 2
--Database Tools (420-520-VA)

--1. Create a new user for yourself.  Note that only the SYSDBA account 
--   (password oracle) has permission to do this.
--   a. What DDL command did you execute to do this?

		CREATE USER Amy IDENTIFIED BY 123;

--   b. Why are you not able to login to the new account?  

--		Because I do not have the necessary granted privileges.

--   c. What PCL did you execute to fix this?

		GRANT CONNECT, RESOURCE TO Amy;

--2. As this new user, create a language table by importing the data in the 
--   oracle_nls file.  Use as column names lang_name and lang_abbr.  Don’t 
--   forget to include necessary constraints (e.g., pk, nn, uk, etc.)
--   a. Copy and paste the SQL that is generated for you.  (Note: Do not format 
--      the auto-generated code.)
		
	  CREATE TABLE "AMY"."LANGUAGES" 
	   (	"LANG_NAME" VARCHAR2(26 BYTE) NOT NULL ENABLE, 
		"LANG_ABBR" VARCHAR2(26 BYTE), 
		 CONSTRAINT "LANGUAGES_LANG_ABBR_PK" PRIMARY KEY ("LANG_ABBR")
	  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
	  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
	  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
	  TABLESPACE "SYSTEM"  ENABLE, 
		 CONSTRAINT "LANGUAGES_LANG_NAME_UK" UNIQUE ("LANG_NAME")
	  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
	  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
	  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
	  TABLESPACE "SYSTEM"  ENABLE
	   ) SEGMENT CREATION IMMEDIATE 
	  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
	  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
	  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
	  TABLESPACE "SYSTEM" ;

--   b. If you were writing this by hand, what would the code look like?  
--      Remember to follow the naming and formatting conventions discussed in 
--      class.

		CREATE TABLE languages (
			lang_name VARCHAR2(26) NOT NULL,
			lang_abbr VARCHAR2( 5),
			CONSTRAINT languages_lang_abbr_pk PRIMARY KEY (lang_abbr),
			CONSTRAINT languages_lang_name_uk UNIQUE (lang_name)
		);
		
--   c. Grant the OE user permission to read the records in this new table and 
--      create foreign keys into it, but nothing more.  What PCL did you execute 
--      to do this?

		GRANT SELECT, REFERENCES ON languages TO OE;

--3. As the OE user, modify the tables to have foreign keys into your new 
--   language table.
--   a. Try to add a foreign key to the product descriptions table.  You should 
--      get a “Parent keys not found error.”
--       i. What DDL command did you try?

		ALTER TABLE product_descriptions
			ADD FOREIGN KEY(language_id) 
				REFERENCES Amy.languages(lang_abbr);

--      ii. Why did this not work?  (Hint: Look at the data in the two tables.)

--		Because the data in both tables are different. Whereas lang_abbr is in lowercase,
--		language_id is in uppercase.

--   b. Try to add a foreign key to the customer table.    You should get a 
--      “Parent keys not found error.”
--       i. What DDL command did you try?

		ALTER TABLE customers
			ADD FOREIGN KEY(nls_language) 
				REFERENCES Amy.languages(lang_abbr);

--      ii. Why did this not work?    (Hint: Look at the data in the two tables.  
--          You might want to write a SELECT statement.)

		SELECT DISTINCT nls_language
			FROM customers
			WHERE nls_language NOT IN (SELECT lang_abbr 
									   FROM Amy.languages);

--		Because India (hi) is missing.

--[don't forget items 4 & 5 in the pdf]

