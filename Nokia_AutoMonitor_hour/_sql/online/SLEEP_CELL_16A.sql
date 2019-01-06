select distinct
case when substr(cel_name,1,2)='YJ' or substr(bts_name,1,2)='YJ' then  'YangJiang'
when substr(cel_name,1,2)='CZ' or substr(bts_name,1,2)='CZ'    then  'ChaoZhou'
when substr(cel_name,1,2)='MM' or substr(bts_name,1,2)='MM'    then  'MaoMing'
when substr(cel_name,1,2)='MZ' or substr(bts_name,1,2)='MZ'  then  'MeiZhou'
when substr(cel_name,1,2)='ZJ' or substr(bts_name,1,2)='ZJ'   then  'ZhanJiang'
else 'N/A'
end city  
--- ,to_char(sysdate,'yyyymmddhh24') cur_time,
,to_char(M8020.period_start_time,'YYYYMMDDHH24')  start_time ,
enb_id,cell_id,bts_version
,cel_name     ,count(enb_id)  "休眠时段数" 


,cel.lncel_ch_bw 带宽
,DECODE(CEL.LNCEL_AS_26,1,'unlocked',2,'shutting down',3,'locked') 管理员闭锁状态
,cel.lncel_earfcn earfcn
,case when  cel.lncel_earfcn in (38950,39148) then '室分'
      when  bts_version like '%F16%' then '微站'
      else '宏站'
      end TYPE
   
  /*
   ,CELL_AVAILS
      ,nvl(RRC_SUM,0) RRC_SUM
      ,nvl(max_rrc,0) max_rrc
   */ 
,avg(CELL_AVAILS) 可用率 
,sum(RRC_SUM)   RRC连接数
 , max(max_rrc ) 最大RRC连接数
,sum(M8013C5) as RRC连接建立成功次数
,sum(M8007C7) as SRB1建立尝试次数
,sum(M8007C8) as SRB1建立成功次数
,sum(M8007C9) as SRB1建立失败次数
,sum(M8013C24) as DRX激活子帧数
,sum(M8013C25) as DRX睡眠子帧数
,sum(INTRA_HO_SUCC+INTER_HO_ATT) 切入成功次数
,sum(INTRA_HO_PREP_FAIL+INTRA_HO_ATT+INTER_HO_PREP_FAIL_AC+INTER_HO_PREP_FAIL_OTH+INTER_HO_PREP_FAIL_TIME+INTER_HO_ATT) as 切入次数
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
--- enb_id*256+cell_id
,sum(nvl(SAMPLES_CELL_AVAIL,0)) M8020C3
,sum(nvl(SAMPLES_CELL_PLAN_UNAVAIL,0)) M8020C4
,sum(nvl(DENOM_CELL_AVAIL,0)) M8020C6 
,decode(sum(nvl(DENOM_CELL_AVAIL,0))-sum(nvl(SAMPLES_CELL_PLAN_UNAVAIL,0)),0,0,100*sum(nvl(SAMPLES_CELL_AVAIL,0))/(sum(nvl(DENOM_CELL_AVAIL,0))-sum(nvl(SAMPLES_CELL_PLAN_UNAVAIL,0))))  CELL_AVAILS
from
Noklte_Ps_Lcelav_lncel_hour  PMRAW    ,ctp_common_objects lnbts,ctp_common_objects lncel
where
period_start_time between to_date(to_char(sysdate-1/24,'YYYYMMDDHH24'),'YYYYMMDDHH24') 
and to_date(to_char(sysdate,'YYYYMMDDHH24'),'YYYYMMDDHH24')

AND PMRAW.LNCEL_ID=lncel.co_gid  AND lnbts.CO_STATE<>9 AND lncel.CO_STATE<>9             
and PMRAW.lnbts_id=lnbts.co_gid

group by
period_start_time,MRBTS_ID,LNBTS_ID,LNCEL_ID   ,period_start_time
,lnbts.co_object_instance ,lncel.co_object_instance ,lnbts.co_sys_version ,Trim(lnbts.co_name) ,Trim(lncel.co_name)) M8020


left join (select
LNCEL_ID ,period_start_time
,sum(nvl(SIGN_CONN_ESTAB_ATT_MO_S,0)) +sum(nvl(SIGN_CONN_ESTAB_ATT_MT,0))+sum(nvl(SIGN_CONN_ESTAB_ATT_MO_D,0))
+sum(nvl(SIGN_CONN_ESTAB_ATT_OTHERS,0)) +sum(nvl(SIGN_CONN_ESTAB_ATT_EMG,0))+sum(NVL(SIGN_CONN_ESTAB_ATT_HIPRIO,0))
+sum(NVL(SIGN_CONN_ESTAB_ATT_DEL_TOL,0)) RRC_SUM
,sum(NVL(SIGN_CONN_ESTAB_COMP,0)) M8013C5
,sum(NVL(SUBFRAME_DRX_ACTIVE_UE,0)) M8013C24
,sum(NVL(SUBFRAME_DRX_SLEEP_UE,0)) M8013C25




from
NOKLTE_PS_LUEST_lncel_hour PMRAW

where
period_start_time between to_date(to_char(sysdate-1/24,'YYYYMMDDHH24'),'YYYYMMDDHH24') 
and to_date(to_char(sysdate,'YYYYMMDDHH24'),'YYYYMMDDHH24')
group by  LNCEL_ID,period_start_time) M8013  on M8013.LNCEL_ID=M8020.LNCEL_ID  and M8013.period_start_time = M8020.period_start_time
left join (




 
select period_start_time, lncel_id ,nvl(RRC_CONNECTED_UE_MAX,0)    MAX_RRC
from   NOKLTE_PS_LUEQ_lncel_hour
 where
period_start_time between to_date(to_char(sysdate-1/24,'YYYYMMDDHH24'),'YYYYMMDDHH24')
 and to_date(to_char(sysdate,'YYYYMMDDHH24'),'YYYYMMDDHH24')
 --and RRC_CONNECTED_UE_MAX is not null

) rrc on  rrc.LNCEL_ID=M8020.LNCEL_ID  and rrc.period_start_time = M8020.period_start_time
left join (

 
select period_start_time
, lncel_id 
  ,SUM(nvl(SRB1_SETUP_ATT,0))  M8007C7
  ,SUM(nvl(SRB1_SETUP_SUCC,0))  M8007C8
  ,SUM(nvl(SRB1_SETUP_FAIL,0))  M8007C9

from   NOKLTE_PS_LRDB_LNCEL_HOUR
 where
period_start_time between to_date(to_char(sysdate-1/24,'YYYYMMDDHH24'),'YYYYMMDDHH24')
 and to_date(to_char(sysdate,'YYYYMMDDHH24'),'YYYYMMDDHH24')
 GROUP BY  period_start_time
, lncel_id 
) M8007  on M8020.LNCEL_ID=M8007.LNCEL_ID  and M8020.period_start_time = M8007.period_start_time


left join c_lte_lncel CEL on CEL.CONF_ID=1 AND CEL.OBJ_GID =M8020.LNCEL_ID
left join  (
select
p.period_start_time,

p.eci_id ECI_ID,
sum(NVL(p.INTRA_HO_PREP_FAIL_NB,0)) INTRA_HO_PREP_FAIL,
sum(NVL(p.INTRA_HO_ATT_NB,0)) INTRA_HO_ATT,
sum(NVL(p.INTRA_HO_SUCC_NB,0)) INTRA_HO_SUCC,
sum(NVL(p.INTRA_HO_FAIL_NB,0)) INTRA_HO_FAIL,
sum(NVL(p.INTER_HO_PREP_FAIL_AC_NB,0)) INTER_HO_PREP_FAIL_AC,
sum(NVL(p.INTER_HO_PREP_FAIL_OTH_NB,0)) INTER_HO_PREP_FAIL_OTH,
sum(NVL(p.INTER_HO_PREP_FAIL_TIME_NB,0)) INTER_HO_PREP_FAIL_TIME,
sum(NVL(p.INTER_HO_ATT_NB,0)) INTER_HO_ATT,
sum(NVL(p.INTER_HO_SUCC_NB,0)) INTER_HO_SUCC,
sum(NVL(p.INTER_HO_FAIL_NB,0)) INTER_HO_FAIL,
sum(NVL(p.INTER_HO_DROPS_NB,0)) INTER_HO_DROPS
--INTRA_HO_PREP_FAIL+INTRA_HO_ATT+INTER_HO_PREP_FAIL_AC+INTER_HO_PREP_FAIL_OTH+INTER_HO_PREP_FAIL_TIME+INTER_HO_ATT

from noklte_ps_lncelho_dmnc1_HOUR p

where   --bts1.co_object_instance = ('&enb')  and cell1.co_object_instance =('&cellid') and 
--bts1.co_object_instance >= '704000' and  bts1.co_object_instance <= '704511' and
p.PERIOD_START_TIME >=  to_date(to_char(sysdate-1/24,'YYYYMMDDHH24'),'YYYYMMDDHH24') And
p.PERIOD_START_TIME < to_date(to_char(sysdate,'YYYYMMDDHH24'),'YYYYMMDDHH24')
group by  p.period_start_time, p.eci_id 
having sum(NVL(p.INTRA_HO_SUCC_NB,0))+sum(NVL(p.INTER_HO_SUCC_NB,0)) =0
and sum(NVL(p.INTRA_HO_ATT_NB,0))+sum(NVL(p.INTRA_HO_PREP_FAIL_NB,0))+sum(NVL(p.INTER_HO_PREP_FAIL_AC_NB,0))
+sum(NVL(p.INTER_HO_PREP_FAIL_OTH_NB,0))+sum(NVL(p.INTER_HO_PREP_FAIL_TIME_NB,0))+sum(NVL(p.INTER_HO_ATT_NB,0))>0
) ho_in  on  M8020.enb_id*256+M8020.cell_id=ho_in.ECI_ID  and M8020.period_start_time = ho_in.period_start_time
WHERE 

 
 CEL.LNCEL_AS_26<>3     
and (( CELL_AVAILS=100 and  
( nvl(RRC_SUM,0)=0 and  nvl(max_rrc,0)=0 )
 and  to_char(M8013.period_start_time,'hh24') not in ('01','02','03','04','05')   ) 

or (nvl(M8007C8,0)=0 and  nvl(M8007C7,0)>5) 
or  ( nvl(M8013C5,0)=0 and nvl(M8013C24,0)+nvl(M8013C25,0)>1000) 
or (nvl(M8007C8,0)=0 and nvl(M8013C24,0)+nvl(M8013C25,0)>1000)  
or (
CELL_AVAILS=100 and   INTRA_HO_SUCC+INTER_HO_SUCC=0

)
)


 

 group by  
 to_char(M8020.period_start_time,'YYYYMMDDHH24')  ,
 --- sysdate  ,
    enb_id,cell_id,bts_version
,cel_name     
,case when substr(cel_name,1,2)='YJ' or substr(bts_name,1,2)='YJ' then  'YangJiang'
when substr(cel_name,1,2)='CZ' or substr(bts_name,1,2)='CZ'    then  'ChaoZhou'
when substr(cel_name,1,2)='MM' or substr(bts_name,1,2)='MM'    then  'MaoMing'
when substr(cel_name,1,2)='MZ' or substr(bts_name,1,2)='MZ'  then  'MeiZhou'
when substr(cel_name,1,2)='ZJ' or substr(bts_name,1,2)='ZJ'   then  'ZhanJiang'
else 'N/A'
end  

,cel.lncel_ch_bw 
,CEL.LNCEL_AS_26 ,cel.lncel_earfcn 

,case when  cel.lncel_earfcn in (38950,39148) then '室分'
      when  bts_version like '%F16%'   or  bts_version like '%F15%' then '微站'
      else '宏站'
        end
---having     sum(RRC_SUM)=0 AND sum(CELL_AVAILS)>=100  and max(max_rrc) =0 -----&1&2---
having count(enb_id)  >=1
ORDER BY  enb_id,cell_id  ,to_char(sysdate,'yyyymmddhh24')  


