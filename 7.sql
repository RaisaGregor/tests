create table clients(
ID number
,NAME Varchar2(100)
);

COMMENT ON TABLE clients IS 'Клиенты';

COMMENT ON COLUMN  clients.name IS 'Наименование';

ALTER TABLE clients
ADD CONSTRAINT client_id_pk PRIMARY KEY (ID);

--------------------------------------------------
create table contacts(
ID number
,CLIENT_ID number
,C_TYPE number
,C_INFO varchar2(100) ---Контакт – телефон либо адрес email
,CREATED date
,ACTIVE Char(1)
,CONSTRAINT contacts_id_pk PRIMARY KEY (ID)
,CONSTRAINT c_type_check CHECK (C_TYPE in (1,2))
,CONSTRAINT active_check CHECK (ACTIVE in ('Y','N'))
,CONSTRAINT clients_fk
    FOREIGN KEY (CLIENT_ID)
    REFERENCES clients(ID)
);

COMMENT ON TABLE contacts IS 'Контакты';

COMMENT ON COLUMN  contacts.C_TYPE IS 'Тип контакта 1-телефон 2-email';

COMMENT ON COLUMN  contacts.C_INFO IS 'Контакт – телефон либо адрес email';

COMMENT ON COLUMN  contacts.CREATED IS 'Дата внесения в базу';

COMMENT ON COLUMN  contacts.ACTIVE IS 'Y/N активный или архив';

----------------------------------------------------------------------

create table addresses(
ID number
,CLIENT_ID number
,A_TYPE number
,CITY varchar2(100)
,STREET varchar2(100)
,HOUSE varchar2(100) 
,FLAT varchar2(100) 
,CREATED date
,ACTIVE Char(1)
,CONSTRAINT addresses_id_pk PRIMARY KEY (ID)
,CONSTRAINT c_address_type_check CHECK (A_TYPE in (1,2,3))
,CONSTRAINT address_active_check CHECK (ACTIVE in ('Y','N'))
,CONSTRAINT addresses_fk
    FOREIGN KEY (CLIENT_ID)
    REFERENCES clients(ID)
);

COMMENT ON TABLE addresses IS 'Адреса';

COMMENT ON COLUMN  addresses.A_TYPE IS ' Тип адреса 1-домашний 2-регистрации 3- фактический';

COMMENT ON COLUMN  addresses.CITY IS 'Город';

COMMENT ON COLUMN  addresses.STREET IS 'Улица';

COMMENT ON COLUMN  addresses.HOUSE IS 'Дом';

COMMENT ON COLUMN  addresses.FLAT IS 'Квартира';

COMMENT ON COLUMN  addresses.CREATED IS 'Дата внесения в базу';

COMMENT ON COLUMN  addresses.ACTIVE IS 'Y/N активный или архив';

----------------------------------------------------------------
INSERT INTO clients(ID, NAME) values (1,'#1');

INSERT INTO clients(ID, NAME) values (2,'#2');

INSERT INTO clients(ID, NAME) values (3,'#3');
----------------------------------------------------------------
--
INSERT INTO contacts(ID
,CLIENT_ID
,C_TYPE
,C_INFO
,CREATED
,ACTIVE)
values
(
1,
1,
1,
'+7 3-01-2018',
TO_DATE('3-01-2018','DD-MM-YYYY'),
'Y'
);

INSERT INTO contacts(ID
,CLIENT_ID
,C_TYPE
,C_INFO
,CREATED
,ACTIVE)
values
(
2,
1,
1,
'+7 3-02-2018',
TO_DATE('3-02-2018','DD-MM-YYYY'),
'Y'
);


INSERT INTO contacts(ID
,CLIENT_ID
,C_TYPE
,C_INFO
,CREATED
,ACTIVE)
values
(
3,
1,
1,
'+7 3-02-2018 INACTIV',
TO_DATE('3-02-2018','DD-MM-YYYY'),
'N'
);
----
INSERT INTO contacts(ID
,CLIENT_ID
,C_TYPE
,C_INFO
,CREATED
,ACTIVE)
values
(
4,
1,
2,
'sample_3-02-2018@mail.ru',
TO_DATE('3-02-2018','DD-MM-YYYY'),
'Y'
);

INSERT INTO contacts(ID
,CLIENT_ID
,C_TYPE
,C_INFO
,CREATED
,ACTIVE)
values
(
5,
1,
2,
'sample_3-02-2017@mail.ru',
TO_DATE('3-02-2017','DD-MM-YYYY'),
'Y'
);

INSERT INTO contacts(ID
,CLIENT_ID
,C_TYPE
,C_INFO
,CREATED
,ACTIVE)
values
(
6,
1,
2,
'sample_3-01-2018_inactiv@mail.ru',
TO_DATE('3-01-2018','DD-MM-YYYY'),
'N'
);
----
INSERT INTO contacts(ID
,CLIENT_ID
,C_TYPE
,C_INFO
,CREATED
,ACTIVE)
values
(
7,
2,
2,
'sample_contact2_4-01-2018_inactiv@mail.ru',
TO_DATE('4-01-2018','DD-MM-YYYY'),
'N'
);
---------------------------------------

INSERT INTO addresses(
ID
,CLIENT_ID
,A_TYPE
,CITY
,STREET
,HOUSE 
,FLAT 
,CREATED
,ACTIVE) VALUES
(
1,
1,
1,
'NY',
's1',
'h1',
'f1',
SYSDATE,
'Y'
);

INSERT INTO addresses(
ID
,CLIENT_ID
,A_TYPE
,CITY
,STREET
,HOUSE 
,FLAT 
,CREATED
,ACTIVE) VALUES
(
2,
1,
2,
'NY',
's1_type2',
'h1',
'f1',
SYSDATE,
'Y'
);

INSERT INTO addresses(
ID
,CLIENT_ID
,A_TYPE
,CITY
,STREET
,HOUSE 
,FLAT 
,CREATED
,ACTIVE) VALUES
(
3,
1,
3,
'NY',
's1_type3',
'h1',
'f1',
SYSDATE,
'Y'
);

---------

INSERT INTO addresses(
ID
,CLIENT_ID
,A_TYPE
,CITY
,STREET
,HOUSE 
,FLAT 
,CREATED
,ACTIVE) VALUES
(
4,
2,
1,
'NY',
's1',
'h1',
'f1',
SYSDATE,
'Y'
);

INSERT INTO addresses(
ID
,CLIENT_ID
,A_TYPE
,CITY
,STREET
,HOUSE 
,FLAT 
,CREATED
,ACTIVE) VALUES
(
5,
2,
2,
'NY',
's1_type2',
'h1',
'f1',
SYSDATE,
'Y'
);

INSERT INTO addresses(
ID
,CLIENT_ID
,A_TYPE
,CITY
,STREET
,HOUSE 
,FLAT 
,CREATED
,ACTIVE) VALUES
(
6,
2,
3,
'NY',
's1_type3',
'h1',
'f1',
SYSDATE,
'N'
);
---
INSERT INTO addresses(
ID
,CLIENT_ID
,A_TYPE
,CITY
,STREET
,HOUSE 
,FLAT 
,CREATED
,ACTIVE) VALUES
(
7,
3,
1,
'NY',
's1',
'h1',
'f1',
SYSDATE,
'Y'
);

INSERT INTO addresses(
ID
,CLIENT_ID
,A_TYPE
,CITY
,STREET
,HOUSE 
,FLAT 
,CREATED
,ACTIVE) VALUES
(
8,
3,
2,
'NY',
's1_type2',
'h1',
'f1',
SYSDATE,
'N'
);

INSERT INTO addresses(
ID
,CLIENT_ID
,A_TYPE
,CITY
,STREET
,HOUSE 
,FLAT 
,CREATED
,ACTIVE) VALUES
(
9,
3,
3,
'NY',
's1_type3',
'h1',
'f1',
SYSDATE,
'N'
);


create or replace package fullness_pck is

function address_fullness(i_city varchar2, i_street varchar2, i_house varchar2, i_flat varchar2) return number;

procedure test_address_fullness;

end fullness_pck;

create or replace package body fullness_pck is

function address_fullness(i_city varchar2, i_street varchar2, i_house varchar2, i_flat varchar2) return number is
l_fullness number := 0;
begin
  if (i_city is not null) then l_fullness := l_fullness + 1; end if;
  if (i_street is not null) then l_fullness := l_fullness + 1; end if;
  if (i_house is not null) then l_fullness := l_fullness + 1; end if;
  if (i_flat is not null) then l_fullness := l_fullness + 1; end if;
  return l_fullness;
end;

procedure test_address_fullness_proc(i_city varchar2, i_street varchar2, i_house varchar2, i_flat varchar2) IS
l_res varchar2(2000);
begin
  l_res := address_fullness(i_city, i_street, i_house, i_flat);
  dbms_output.put_line(l_res);
end;

procedure test_address_fullness  is
begin
  test_address_fullness_proc(NULL, NULL,NULL,NULL);
  test_address_fullness_proc(NULL, NULL,NULL,'y');
  test_address_fullness_proc(NULL, NULL,'y',NULL);
  test_address_fullness_proc(NULL, NULL,'y','y');
  
  dbms_output.put_line('
    ');
  
  test_address_fullness_proc(NULL, 'y',NULL,NULL);
  test_address_fullness_proc(NULL, 'y',NULL,'y');
  test_address_fullness_proc(NULL, 'y','y',NULL);
  test_address_fullness_proc(NULL, 'y','y','y');

  dbms_output.put_line('
    ');
    
  test_address_fullness_proc('y', NULL,NULL,NULL);
  test_address_fullness_proc('y', NULL,NULL,'y');
  test_address_fullness_proc('y', NULL,'y',NULL);
  test_address_fullness_proc('y', NULL,'y','y');
  
    dbms_output.put_line('
    ');
    
  test_address_fullness_proc('y', 'y',NULL,NULL);
  test_address_fullness_proc('y', 'y',NULL,'y');
  test_address_fullness_proc('y', 'y','y',NULL);
  test_address_fullness_proc('y', 'y','y','y');

end;

end fullness_pck;
