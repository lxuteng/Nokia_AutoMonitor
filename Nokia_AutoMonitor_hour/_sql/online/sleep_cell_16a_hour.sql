

select distinct
case when substr(cel_name,1,2)='YJ' or substr(bts_name,1,2)='YJ' then  'YangJiang'
when substr(cel_name,1,2)='CZ' or substr(bts_name,1,2)='CZ'    then  'ChaoZhou'
when substr(cel_name,1,2)='MM' or substr(bts_name,1,2)='MM'    then  'MaoMingM'
when substr(cel_name,1,2)='MZ' or substr(bts_name,1,2)='MZ'  then  'MeiZhou'
when substr(cel_name,1,2)='ZJ' or substr(bts_name,1,2)='ZJ'   then  'ZhanJiang'
else 'N/A'
end city  
 ,to_char(sysdate,'yyyymmddhh24') cur_time,
---to_char(M8020.period_start_time,'yyyymmddhh24')  start_time ,
enb_id,
cell_id,
enb_id||'_'||cell_id enb_cell,
bts_version
,cel_name     
,count(enb_id)  "休眠时段数" 

,cel.lncel_ch_bw 带宽
,DECODE(CEL.LNCEL_AS_26,1,'unlocked',2,'shutting down',3,'locked') 管理员闭锁状态
,cel.lncel_earfcn earfcn
,case when  cel.lncel_earfcn in (38950,39148) then '室分'
      when  bts_version like '%F16%' then '微站'
      else '宏站'
      end TYPE
,Round(avg(M8012C19+M8012C20)/1024/1024,2) 昨天总流量MB
,avg(CELL_AVAILS) 可用率 
,sum(RRC_SUM)   RRC连接数
,max(max_rrc ) 最大RRC连接数
,sum(M8013C5) as RRC连接建立成功次数
,sum(M8007C7) as SRB1建立尝试次数
,sum(M8007C8) as SRB1建立成功次数
,sum(M8007C9) as SRB1建立失败次数
,sum(M8013C24) as DRX激活子帧数
,sum(M8013C25) as DRX睡眠子帧数
----unlocked (1), shutting down (2), locked (3)
from ( 
select
LNBTS_ID
,LNCEL_ID
,period_start_time
,lnbts.co_object_instance enb_id
,lncel.co_object_instance cell_id
,lnbts.co_sys_version bts_version
,Trim(lnbts.co_name) bts_name
,Trim(lncel.co_name) cel_name

,sum(nvl(SAMPLES_CELL_AVAIL,0)) M8020C3
,sum(nvl(SAMPLES_CELL_PLAN_UNAVAIL,0)) M8020C4
,sum(nvl(DENOM_CELL_AVAIL,0)) M8020C6 
,decode(sum(nvl(DENOM_CELL_AVAIL,0))-sum(nvl(SAMPLES_CELL_PLAN_UNAVAIL,0)),0,0,100*sum(nvl(SAMPLES_CELL_AVAIL,0))/(sum(nvl(DENOM_CELL_AVAIL,0))-sum(nvl(SAMPLES_CELL_PLAN_UNAVAIL,0))))  CELL_AVAILS
from
Noklte_Ps_Lcelav_mnc1_raw  PMRAW    ,ctp_common_objects lnbts,ctp_common_objects lncel
where
period_start_time >= to_date(to_char(sysdate-2/24,'yyyymmddhh24'),'YYYYMMDDHH24') 
and period_start_time <to_date(to_char(sysdate-0,'YYYYMMDDHH24'),'YYYYMMDDHH24')

AND PMRAW.LNCEL_ID=lncel.co_gid  AND lnbts.CO_STATE<>9 AND lncel.CO_STATE<>9             and PMRAW.lnbts_id=lnbts.co_gid

group by
period_start_time,MRBTS_ID,LNBTS_ID,LNCEL_ID   ,period_start_time
,lnbts.co_object_instance ,lncel.co_object_instance ,lnbts.co_sys_version ,Trim(lnbts.co_name) ,Trim(lncel.co_name)) M8020


,(select
LNCEL_ID ,period_start_time
,sum(nvl(SIGN_CONN_ESTAB_ATT_MO_S,0)) +sum(nvl(SIGN_CONN_ESTAB_ATT_MT,0))+sum(nvl(SIGN_CONN_ESTAB_ATT_MO_D,0))
+sum(nvl(SIGN_CONN_ESTAB_ATT_OTHERS,0)) +sum(nvl(SIGN_CONN_ESTAB_ATT_EMG,0))+sum(NVL(SIGN_CONN_ESTAB_ATT_HIPRIO,0))
+sum(NVL(SIGN_CONN_ESTAB_ATT_DEL_TOL,0)) RRC_SUM
,sum(SIGN_CONN_ESTAB_COMP) M8013C5
,sum(SUBFRAME_DRX_ACTIVE_UE) M8013C24
,sum(SUBFRAME_DRX_SLEEP_UE) M8013C25




from
NOKLTE_PS_LUEST_mnc1_raw PMRAW

where
period_start_time >= to_date(to_char(sysdate-2/24,'YYYYMMDDHH24'),'YYYYMMDDHH24') 
and period_start_time < to_date(to_char(sysdate-0,'YYYYMMDDHH24'),'YYYYMMDDHH24')
group by  LNCEL_ID,period_start_time) M8013
,(




 
select period_start_time, lncel_id ,nvl(RRC_CONNECTED_UE_MAX,0)    MAX_RRC
from   NOKLTE_PS_LUEQ_mnc1_raw
 where
period_start_time >= to_date(to_char(sysdate-2/24,'YYYYMMDDHH24'),'YYYYMMDDHH24')
 and period_start_time < to_date(to_char(sysdate-0,'YYYYMMDDHH24'),'YYYYMMDDHH24')
 --and RRC_CONNECTED_UE_MAX is not null

) rrc
,(

 
select period_start_time
, lncel_id 
  ,SUM(SRB1_SETUP_ATT)  M8007C7
  ,SUM(SRB1_SETUP_SUCC)  M8007C8
  ,SUM(SRB1_SETUP_FAIL)  M8007C9

from   NOKLTE_PS_LRDB_mnc1_raw
 where
period_start_time >= to_date(to_char(sysdate-2/24,'YYYYMMDDHH24'),'YYYYMMDDHH24')
 and period_start_time < to_date(to_char(sysdate-0,'YYYYMMDDHH24'),'YYYYMMDDHH24')
 GROUP BY  period_start_time
, lncel_id 
) M8007  ---NOKLTE_PS_LRDB_MNC1_RAW

,(

 
select period_start_time
, lncel_id 
,sum(nvl(PDCP_SDU_VOL_UL,0)) M8012C19 --The measurement gives an indication of the eUu interface traffic load by reporting the total received PDCP SDU-related traffic volume.
,sum(nvl(PDCP_SDU_VOL_DL,0)) M8012C20 --The measurement gives an indication of the eUu interface traffic load by reporting the total transmitted PDCP SDU-related traffic volume.


from   NOKLTE_PS_LCELLT_lncel_day
 where
period_start_time = to_date(to_char(sysdate-1,'YYYYMMDD'),'YYYYMMDD')
 GROUP BY  period_start_time
, lncel_id 
) M8012


,c_lte_lncel CEL

WHERE M8013.LNCEL_ID=M8020.LNCEL_ID  
and M8013.period_start_time = M8020.period_start_time

and M8020.LNCEL_ID=M8012.LNCEL_ID  

AND M8013.LNCEL_ID=M8007.LNCEL_ID  
and M8013.period_start_time = M8007.period_start_time
and rrc.LNCEL_ID=M8020.LNCEL_ID  
and rrc.period_start_time = M8020.period_start_time
AND CEL.CONF_ID=1 AND CEL.OBJ_GID =M8013.LNCEL_ID
AND CEL.LNCEL_AS_26<>3  
and max_rrc=0   
and ((RRC_SUM=0 and CELL_AVAILS=100 and max_rrc=0  and  to_char(M8013.period_start_time,'hh24') not in ('01','02','03','04','05')   ) 

or (M8007C8=0 and M8007C7>5) 
or  ( M8013C5=0 and (M8013C24)+(M8013C25)>250) 
or (M8007C8=0 and (M8013C24)+(M8013C25)>250)  
)

 group by   sysdate,   enb_id,cell_id,bts_version
,cel_name     
,case when substr(cel_name,1,2)='YJ' or substr(bts_name,1,2)='YJ' then  'YangJiang'
when substr(cel_name,1,2)='CZ' or substr(bts_name,1,2)='CZ'    then  'ChaoZhou'
when substr(cel_name,1,2)='MM' or substr(bts_name,1,2)='MM'    then  'MaoMingM'
when substr(cel_name,1,2)='MZ' or substr(bts_name,1,2)='MZ'  then  'MeiZhou'
when substr(cel_name,1,2)='ZJ' or substr(bts_name,1,2)='ZJ'   then  'ZhanJiang'
else 'N/A'
end  

,cel.lncel_ch_bw 
,CEL.LNCEL_AS_26 ,cel.lncel_earfcn 

,case when  cel.lncel_earfcn in (38950,39148) then '室分'
      when  bts_version like '%F16%' then '微站'
      else '宏站'
        end
---having     sum(RRC_SUM)=0 AND sum(CELL_AVAILS)>=100  and max(max_rrc) =0 
having count(enb_id)  >= 8
ORDER BY  昨天总流量MB desc ,DRX睡眠子帧数 desc,enb_id,cell_id  ,to_char(sysdate,'yyyymmddhh24')  
--&1&2