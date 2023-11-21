set lines 170
set pages 100
col SID format a15
col osuser format a13
col username format a10
col program format a37
col logon format a20
col status format a9
col spid format A8
col machine format a15

select s.inst_ID||'-'||CHR(39)||TO_CHAR(s.sid)||','||TO_CHAR(s.serial#)||CHR(39) SID,s.username,
        s.status, decode(s.program,NULL,machine,s.program) program, s.machine,
        p.spid, to_char(s.logon_time,'DD/MM/YY hh24:mi:ss') Logon, s.sql_address
from gv$session s,
      gv$process p
where s.paddr = p.addr
   and  s.inst_id = p.inst_id
       order by 1,status, logon;
