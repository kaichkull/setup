--these commands and scripts are intended for FRA troubleshoot fixes RCAs and workarounds
-- Flash Recovery Area Utilization.

set lines 400
col name format a30
col HOST_NAME for a14
col DB_NAME for a10
col SPACE_LIMIT format 999,999,999,999,999
col SPACE_LIMIT format 999,999,999,999,999
col SPACE_USED format 999,999,999,999,999
col SPACE_RECLAIMABLE format 999,999,999,999
col FILE_TYPE format a30
col PCT_USED format 999.99

SELECT (select name from v$database) DB_NAME, (select HOST_NAME from v$instance) HOST_NAME, NAME, SPACE_LIMIT, SPACE_USED, SPACE_RECLAIMABLE, NUMBER_OF_FILES, (SPACE_USED/SPACE_LIMIT)*100 PCT_USED
  FROM V$RECOVERY_FILE_DEST;

--Recovery_Area_Usage by type of file.

select file_type, space_used*percent_space_used/100/1024/1024 used,
space_reclaimable*percent_space_reclaimable/100/1024/1024 reclaimable, frau.number_of_files
from v$recovery_file_dest rfd, v$flash_recovery_area_usage frau;


-- Volume and rate archive production per hour today
set lines 180
set pages 300

col name format a70
col arch format a20
col total_bytes format 999,999,999,999,999
col optimal_size format 999,999,999,999,999

select arch, cnt, cnt*redo_size total_bytes, ((cnt*redo_size)/instance_count)/(redo_count/instance_count) optimal_size
from (
select DEST_ID, trunc(FIRST_TIME,'HH24') arch, count(*) CNT, (select avg(bytes) from v$log) redo_size, (select count(1) from v$log) redo_count, (select count(1) from v$thread) instance_count
from gv$archived_log
where dest_id = 1
and
trunc(FIRST_TIME,'DD') >= trunc(sysdate)
group by DEST_ID,trunc(FIRST_TIME,'HH24')
order by DEST_ID,trunc(FIRST_TIME,'HH24'));

--#To check remaining restore points

SELECT NAME, SCN, TIME, DATABASE_INCARNATION#,
       GUARANTEE_FLASHBACK_DATABASE,STORAGE_SIZE
FROM   V$RESTORE_POINT;


--#To check outstanding alerts
SELECT object_type, message_type, message_level, reason, suggested_action
FROM dba_outstanding_alerts ;



--Diskgroup Utilization -- Physical Space
COL name for a30
COL free% FORMAT 99.0
SELECT name, free_mb, total_mb, free_mb/total_mb*100 "free%" FROM v$asm_diskgroup ;
