-- Create a tablespace
CREATE TABLESPACE test_tablespace
DATAFILE 'test_tablespace.dbf' SIZE 100M;

-- Create a test table
CREATE TABLE test_table (
    id NUMBER,
    name VARCHAR2(100),
    description VARCHAR2(500)
)
TABLESPACE test_tablespace;

-- Insert a large amount of data into the test table to fill up the tablespace
DECLARE
    i NUMBER := 1;
BEGIN
    LOOP
        INSERT INTO test_table VALUES (i, 'Test Name ' || i, 'Test Description ' || i);
        i := i + 1;
    END LOOP;
END;
/
