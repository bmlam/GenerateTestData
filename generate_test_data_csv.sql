-- In case you need to create the demo table

CREATE TABLE employees
  (
    employee_id    NUMBER(6) ,
    first_name     VARCHAR2(20) ,
    last_name      VARCHAR2(25) ,
    email          VARCHAR2(25) ,
    phone_number   VARCHAR2(20) ,
    hire_date      DATE ,
    job_id         VARCHAR2(10) ,
    salary         NUMBER(8,2) ,
    commission_pct NUMBER(2,2) ,
    manager_id     NUMBER(6) ,
    department_id  NUMBER(4)
  ) ;
  
WITH magic AS
  ( SELECT 'EMPLOYEES' AS my_table FROM dual
  ),
  colnames AS
  (SELECT column_name,
    column_id
  FROM user_tab_columns
  CROSS JOIN magic
  WHERE 1        =1
  AND table_name = my_table
  ) ,
  pivotdata AS
  (SELECT *
  FROM
    (SELECT column_name ,
      CASE
        WHEN data_type LIKE '%CHAR%'
        THEN rpad( SUBSTR( column_name , 1, char_length ), char_length, 'X' ) -- Use the column name itself as column string value, truncate the string so the max length is not exceeded, but pad it with X up to the max length
        WHEN data_type LIKE 'DATE'
        THEN TO_CHAR( sysdate, 'YYYYMMDD' ) -- this is my date mask
        WHEN data_type LIKE 'NUMBER'
        THEN rpad('9', data_precision, '9' )
          ||
          CASE
            WHEN data_scale > 0
            THEN '.'
              ||rpad('9', data_scale, '9' )
          END
        ELSE 'type not supported'
      END AS data
    FROM user_tab_columns
    CROSS JOIN magic
    WHERE 1                                =1
    AND table_name                         = my_table
    ) pivot ( MAX( data ) FOR column_name IN ( 'EMPLOYEE_ID','FIRST_NAME','LAST_NAME','EMAIL','PHONE_NUMBER','HIRE_DATE','JOB_ID','SALARY','COMMISSION_PCT','MANAGER_ID','DEPARTMENT_ID' ) )
  )
--SELECT listagg( ''''||column_name||'''' , ',') within group (ORDER BY column_id) FROM colnames
SELECT *
FROM pivotdata
  CONNECT BY level <= 2 ;