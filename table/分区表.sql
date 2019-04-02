-------------hash分区表-------------
			drop table dds_dept purge
            /
            create table dds_dept ( deptno number, deptname varchar2(32), salmount number )
                  partition by hash(deptno) (
                    partition p1 tablespace users,
                    partition p2 tablespace users,
                    partition p3 tablespace system,
                    partition p4 tablespace system  )
            /
            alter table dds_dept add constraint PK_H primary key (deptno)
            /
			delete from dds_dept
			/
            INSERT INTO dds_dept VALUES ( 1, 'AA01', 1 )
            /
            INSERT INTO dds_dept VALUES ( 2, 'AA02', 2 )
            /

            commit
            /
			begin 
				for i in 30..30000
				loop
			insert into dds_dept  values
			(i, 'AA20',20 );

				end loop; 
			--commit;    
			end;
			/
			update dds_dept set deptname='xxx'
            /
			commit
			/
			truncate table dds_dept
			/
			
			

-----------list分区表-------------
			drop table objects purge
            /
            create table objects ( object_id NUMBER,
             object_type VARCHAR2(19) )
                   PARTITION BY LIST ( object_type ) (
                       PARTITION type_table VALUES ('TABLE' ) TABLESPACE users,
                       PARTITION type_index VALUES ('INDEX' ) NOLOGGING,
                       PARTITION type_view  VALUES ('VIEW'  ) TABLESPACE system,
                       PARTITION type_other VALUES ('FUNCTION','TRIGGER','PROCEDURE'),
                       PARTITION type_null  VALUES (NULL)
                   )
            /
            alter table objects add constraint PK_L primary key (object_id)
            /
			delete from objects
			/
            INSERT INTO objects VALUES (1,'VIEW')
            /
            INSERT INTO objects VALUES (2,'TABLE')
            /
            INSERT INTO objects VALUES (3,'INDEX')
            /
            
            COMMIT
            /
			begin 
				for i in 10..300
				loop
			insert into objects  values
			(i,'VIEW');

				end loop; 
			--commit;    
			end;
			/
			
			update objects set object_id=object_id+10000;

			
			begin 
				for i in 4000..5000
				loop
			insert into objects  values
			(i,'INDEX');

				end loop; 
			--commit;    
			end;
			/
			
			commit
			/
			truncate table objects
			/

-----------range分区表-------------
			drop table ptest purge
            /
            create table ptest (a number, b number) partition  by range (a)
                   ( partition pmax values less than (maxvalue)  )
            /
            alter table ptest add constraint PK_R primary key (a)
            /
			delete from ptest
			/
            insert into ptest values ( 10, 1 )
            /
            insert into ptest values ( 20, 10 )
            /
            insert into ptest values ( 50, 100 )
            /
            insert into ptest values ( 60, 1000 )
            /
            insert into ptest values ( 80, 10000 )
            /
            --commit
            --/
			begin 
				for i in 3001..3999
				loop
			insert into ptest values ( i, i+100 );

				end loop; 
			--commit;    
			end;
			/
			delete from ptest where a>3500
			/
			
			update ptest set a=a+2000
			/
			commit
			/
			truncate table ptest
			/