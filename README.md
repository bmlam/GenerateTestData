# GenerateTestData
Generate test data for CSV file to populate an Oracle database table, particularly useful for testing external tables
Basically only one SQL query is needed ( ok, it is actually two queries in the disguise of one). 

Suppose we want to populate the empty Oracle demo table EMPLOYEES with test data, we need to produce a test data result set which 
has as many columns as EMPLOYEES. Well, we can not query EMPLOYESS since it is still empty. So one query retrieves from
USER_TAB_COLUMNS (or the ALL_ version) the column names and data type information. With the data type it is able to generate
appropiate dummy test data. Since we query USER_TAB_COLUMNS, each column initially is returned as one row. Hence we use the 
PIVOT clause transpose the rows to columns. That is where we need the columns name.

emp_dept_tables.sql simply creates and populate the old style demo tables EMP and DEPT.

An excellent resource to populate a test schema with a more interesting data module is provided by Oracle Corporation:

http://download.oracle.com/oll/tutorials/DBXETutorial/html/module2/les02_load_data_sql.htm
