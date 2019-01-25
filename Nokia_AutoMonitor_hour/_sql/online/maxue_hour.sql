
select 
maxue.sdate SDATE,
maxue_para.enb_cell,
maxue_para.VERSION VERSION,
maxue_para.带宽,
maxue_para.actDrx,
max(maxue.最大激活用户数) 最大激活用户数,
round(max(maxue.最大激活用户数)/max(least(maxue_para.cqi资源,maxue_para.sr资源,maxue_para.maxNumActUE,maxue_para.maxNumRrc,maxue_para.maxNumRrcEmergency))*100,0) || '%' 门限值,
max(least(maxue_para.cqi资源,maxue_para.sr资源,maxue_para.maxNumActUE,maxue_para.maxNumRrc,maxue_para.maxNumRrcEmergency)) 配置最大激活用户数,
max(maxue_para.cqi资源) cqi资源,
max(maxue_para.sr资源) sr资源,
max(maxue_para.maxNumActUE) maxNumActUE,
max(maxue_para.maxNumRrc) maxNumRrc,
max(maxue_para.maxNumRrcEmergency) maxNumRrcEmergency



from
(

select 
enb_id,
enb_cell,
bts_name,
cell_name,
VERSION,

IP,
least(cqi资源,sr资源,maxNumActUE,maxNumRrc,maxNumRrcEmergency) 最大激活用户数,
cqi资源,
sr资源,
maxNumActUE,
maxNumRrc,
maxNumRrcEmergency,
addAUeTcHo,
addAUeRrHo,
addEmergencySessions,
nCqiRb,
cqiPerNp,
cellSrPeriod,
n1PucchAn,
prachFreqOff,
actLdPdcch,
maxNrSymPdcch,
actDrx,
riPerOffset,
dSrTransMax,
srsActivation
,maxNumUeDl
,maxNumUeDlDwPTS
,maxNumUeUl
,带宽
from
(
select 
       BTS.CO_OBJECT_INSTANCE enb_id,
       BTS.CO_OBJECT_INSTANCE || '_' || CELL.CO_OBJECT_INSTANCE enb_cell,
       BTS.CO_NAME bts_name,
       CELL.Co_Name cell_name,
  BTS.CO_SYS_VERSION VERSION,
       em.em_host_name IP
 
,LNCEL.LNCEL_MAX_NUM_ACT_UE maxNumActUE
,LNCEL.LNCEL_P_RACH_FREQ_OFF prachFreqOff
,decode(LNCEL.LNCEL_ACT_LD_PDCCH,0,'false (0)',1,'true (1)') actLdPdcch
,LNCEL.LNCEL_MNSP_103 maxNrSymPdcch
,decode(LNCEL.LNCEL_ACT_DRX,0,'false (0)',1,'true (1)') actDrx
,decode(LNCEL.LNCEL_D_SR_TRANS_MAX,0,'4n (0)',1,'8n (1)',2,'16n (2)',3,'32n (3)',4,'64n (4)') dSrTransMax
,decode(LNCEL.LNCEL_SRS_ACT,0,'false (0)',1,'true (1)') srsActivation
,LNCEL.LNCEL_MAX_NUM_UE_DL maxNumUeDl
,LNCEL.LNCEL_MNUDDP_288 maxNumUeDlDwPTS
,LNCEL.LNCEL_MAX_NUM_UE_UL maxNumUeUl
,nMPUCCH.M_PU_CCH_ADD_A_UE_TC_HO addAUeTcHo
,nMPUCCH.M_PU_CCH_ADD_A_UE_RR_HO addAUeRrHo
,nMPUCCH.M_PU_CCH_ADD_EMR_SES_S addEmergencySessions
,nMPUCCH.M_PU_CCH_MAX_NUM_RRC maxNumRrc
,nMPUCCH.M_PU_CCH_MAX_NUM_RRC_EMR maxNumRrcEmergency
,nMPUCCH.M_PU_CCH_N_CQI_RB nCqiRb
,nMPUCCH.M_PU_CCH_CQI_PER_NP cqiPerNp
,decode(nMPUCCH.M_PU_CCH_CLL_SR_PERIOD,0,'5ms (0)',1,'10ms (1)',2,'20ms (2)',3,'40ms (3)',4,'80ms (4)') cellSrPeriod
,nMPUCCH.M_PU_CCH_N_1_PUCCH_AN n1PucchAn
,nMPUCCH.M_PU_CCH_RI_PER_OFFS riPerOffset
,case when lncel.LNCEL_ACT_DRX = 0 and nMPUCCH.M_PU_CCH_RI_PER_OFFS = 0 then nMPUCCH.M_PU_CCH_N_CQI_RB*nMPUCCH.M_PU_CCH_CQI_PER_NP*2/10*6
     else  nMPUCCH.M_PU_CCH_N_CQI_RB*nMPUCCH.M_PU_CCH_CQI_PER_NP*2/10*3 end cqi资源
,2/10*decode(nMPUCCH.M_PU_CCH_CLL_SR_PERIOD,0,'5',1,'10',2,'20',3,'40',4,'80')*nMPUCCH.M_PU_CCH_N_1_PUCCH_AN sr资源
,lncel.LNCEL_CH_BW 带宽
 from ctp_common_objects BTS,   --基站级索引
       ctp_common_objects CELL,  --小区级索引
       ctp_common_objects mpucch,  
       UTP_COMMON_OBJECTS nBTS,  --基站级名字
       UTP_COMMON_OBJECTS nCELL, --小区级名字

       nasda_objects nao,
       nasda_objects emo,
       nd_in_em em,   --IP 基站版本          
       c_lte_lnbts lnbts, --基站级参数
       c_lte_lncel lncel,  --小区级参数
       C_LTE_M_PU_CCH nmpucch 
  where --(BTS.CO_OC_ID = 2860 or BTS.CO_OC_ID = 2140 or BTS.CO_OC_ID = 2252) --基站
        --and (CELL.CO_OC_ID = 2881 or CELL.CO_OC_ID = 2148 or CELL.CO_OC_ID = 2260)  --小区
       -- and (lnhoif.co_oc_id = 2840  or lnhoif.co_oc_id = 2132 or lnhoif.co_oc_id = 2244)
        
        --and 
         BTS.CO_GID = cell.CO_PARENT_GID  --关联基站&小区
        and  cell.co_gid = mpucch.CO_PARENT_GID   
        and nBTS.CO_GID = BTS.CO_GID  --关联基站名称&基站
        and nCELL.co_GID = CELL.co_gid  --关联小区名称&小区
        and nao.co_gid=bts.co_gid 
        and em.obj_gid=emo.co_gid 
        and emo.co_parent_gid=nao.co_gid   --关联IP&基站
        and lnbts.OBJ_GID = bts.CO_GID  --关联基站参数&基站
        and lncel.OBJ_GID = cell.CO_GID  --关联小区参数&小区
        and nmpucch.OBJ_GID = mpucch.CO_GID   
        and lnbts.CONF_ID =1  --基站参数状态
        and lncel.CONF_ID =1  --小区参数状态
        and nmpucch.CONF_ID =1  
       --and BTS.CO_OBJECT_INSTANCE in ('659962')
       /*
    AND ((BTS.CO_OBJECT_INSTANCE >='659712' and BTS.CO_OBJECT_INSTANCE <='660223') 
        or (BTS.CO_OBJECT_INSTANCE >='684032' and BTS.CO_OBJECT_INSTANCE <='684287')
       or (BTS.CO_OBJECT_INSTANCE >='701184' and BTS.CO_OBJECT_INSTANCE <='701439') 
        or (BTS.CO_OBJECT_INSTANCE >='701440' and BTS.CO_OBJECT_INSTANCE <='701951')
        or (BTS.CO_OBJECT_INSTANCE >='716800' and BTS.CO_OBJECT_INSTANCE <='717055')
        or (BTS.CO_OBJECT_INSTANCE >='201728' and BTS.CO_OBJECT_INSTANCE <='201983')
        or (BTS.CO_OBJECT_INSTANCE >='822528' and BTS.CO_OBJECT_INSTANCE <='823807'))
        */
)

        
) maxue_para

left join

(
SELECT
substr(sdate,1,10)*100+to_char(trunc(to_number(substr(sdate,11,2)/15))*15,'00') sdate
,
city
,enb_cell,enb_id,bts_version,cel_name


,round(avg(平均激活用户数),2) 平均激活用户数
,max(最大激活用户数)  最大激活用户数       
,max(RRC最大连接数)  RRC最大连接数 

,case when round(avg(上行有效RRC连接平均数),2)>round(avg(下行有效RRC连接平均数),2) then round(avg(上行有效RRC连接平均数),2) else round(avg(下行有效RRC连接平均数),2) end 有效RRC连接平均数
,case when max(上行有效RRC连接最大数)>max(下行有效RRC连接最大数) then max(上行有效RRC连接最大数) else max(下行有效RRC连接最大数) end 有效RRC连接最大数

FROM
(
SELECT M8012.sdate
          --   ,M8020.MRBTS_ID
         --    ,M8020.LNBTS_ID
         --    ,M8020.LNCEL_ID
     ,enb_id || '_' || cell_id enb_cell
     ,enb_id,
         case  when ((enb_id>=655360 and enb_id<=656383 ) or (enb_id>= 686080 and enb_id<=686591 ) or (enb_id>= 696320 and enb_id<=696831 )or (enb_id>= 119296 and enb_id<=120831 )) then 'ZhanJiang'
              when ((enb_id>=656384 and enb_id<=657151 ) or (enb_id>= 683520 and enb_id<=683775 ) or (enb_id>= 698880 and enb_id<=699647 ) or (enb_id>= 711168and enb_id<=712191 ))then 'MaoMing'
              when ((enb_id>=659712 and enb_id<=660223 ) or (enb_id >= 684032 and enb_id <=684287 ) or(enb_id>= 701184 and enb_id<=701951 ) or (enb_id>= 716800 and enb_id<=717055 ) or (enb_id >=822528 and enb_id <=823807) or (enb_id >=201728 and enb_id <=201983) or (enb_id >=837888 and enb_id <=838399) or (enb_id >=340736 and enb_id <=341247)or (enb_id >=561920 and enb_id <=562431)) then 'ChaoZhou'
              when ((enb_id>=660736 and enb_id<=661247 ) or (enb_id >= 683776 and enb_id <=684031 ) or(enb_id>= 702464 and enb_id<=703487 ) ) then 'MeiZhou'
              when ((enb_id>=662272 and enb_id<=662783 ) or (enb_id>= 704000 and enb_id<=704511 ) or (enb_id >=719616 and enb_id <=720127)) then 'YangJiang'
              else 'NA'      
        end City
       
,cell_id
--,bts_ip
,bts_version
--,bts_name
,cel_name
,M8001C147,M8001C148,M8001C150,M8001C151,M8001C153,M8001C154,M8001C200,M8001C216,M8001C217,M8001C223,M8001C224,M8001C269,m8001c286,M8001C305,M8001C306,M8001C314,M8001C315,M8001C320,M8001C321,M8001C323,M8001C324,M8001C494,M8001C495,M8001C496,m8001c6,m8001c7,M8001C8,M8051C107,M8051C108,M8051C109,M8051C110,M8051C55,M8051C56,M8051C57,M8051C58,M8051C62,M8051C63

,case when bts_version = 'TL16A' or bts_version = 'TLF16A' then M8051C57
 else M8001C223 end 平均激活用户数 
,case when bts_version = 'TL16A' or bts_version = 'TLF16A' then M8051C58
 else M8001C224 end 最大激活用户数     
,case when bts_version = 'TL16A' or bts_version = 'TLF16A' then M8051C56
 else M8001C200 end   RRC最大连接数 
   
,case when (bts_version='TL16A' or bts_version = 'TLF16A') then M8051C107/100
      else M8001C147/100 end 下行有效RRC连接平均数 
,case when (bts_version='TL16A' or bts_version = 'TLF16A') then M8051C109/100
      else M8001C150/100 end 上行有效RRC连接平均数        
,case when (bts_version='TL16A' or bts_version = 'TLF16A') then M8051C108
      else M8001C148 end 下行有效RRC连接最大数
,case when (bts_version='TL16A' or bts_version = 'TLF16A') then M8051C110
      else M8001C151 end 上行有效RRC连接最大数  
FROM
( select
             to_char(period_start_time,'yyyymmddhh24') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmddhh24')||LNCEL_ID cel_key_id
,avg(nvl(DL_UE_DATA_BUFF_AVG,0)) M8001C147 --The average number of UE contexts per TTI with UP data on the RLC-level buffers in the DL (active users). This measurement can be used to monitor the congestion level of the eNB queuing system, which is realized by schedulers for the shared channels.The reported value is 100 times higher than the actual value (for example, 1.00 is stored as 100)."
,max(nvl(DL_UE_DATA_BUFF_MAX,0)) M8001C148 --The maximum number of UE contexts per TTI with UP data on the RLC-level buffers in the DL (active users). This measurement can be used to monitor the congestion level of the eNB queuing system, which is realized by schedulers for the shared channels.
,avg(nvl(UL_UE_DATA_BUFF_AVG,0)) M8001C150 --The average number of UE contexts per TTI having buffered DRB data in the UL (active users). This measurement can be used to monitor the congestion level of the eNB queuing system, which is realized by schedulers for the shared channels.The reported value is 100 times higher than the actual value (for example, 1.00 is stored as 100)."
,max(nvl(UL_UE_DATA_BUFF_MAX,0)) M8001C151 --The maximum number of UE contexts per TTI having buffered DRB data in the UL (active users). This measurement can be used to monitor the congestion level of the eNB queuing system, which is realized by schedulers for the shared channels (Inter-RAT Redirection).
,max(nvl(RRC_CONN_UE_MAX,0)) M8001C200 --The highest value for number of UEs in RRC_CONNECTED state over the measurement period.
,avg(nvl(MEAN_PRB_AVAIL_PDSCH,0)) M8001C216 --This measurement provides the average number of PRBs on PDSCH available for dynamic scheduling.
,avg(nvl(MEAN_PRB_AVAIL_PUSCH,0)) M8001C217 --This measurement provides the average number of PRBs on PUSCH available for dynamic scheduling.
,avg(nvl(CELL_LOAD_ACT_UE_AVG,0)) M8001C223 --The average number of active UEs per cell during measurement period. A UE is active if at least a single non-GBR DRB has been successfully configured for it.
,max(nvl(CELL_LOAD_ACT_UE_MAX,0)) M8001C224 --The maximum number of active UEs per cell during measurement period. A UE is active if at least a single non-GBR DRB has been successfully configured for it.
,avg(nvl(PDCP_RET_DL_DEL_MEAN_QCI_1,0)) M8001C269 --The mean retention delay for a PDCP SDU (DL) inside eNB per QCI 1
,sum(nvl(RACH_STP_ATT_DEDICATED,0)) m8001c286 --The number of RACH setup attempts for dedicated preambles.
,sum(nvl(PDCP_SDU_UL_QCI_1,0)) M8001C305 --This measurement provides the number of received PDCP SDUs for QCI 1 bearers.Only user-plane traffic (DTCH) is considered."
,sum(nvl(PDCP_SDU_UL_QCI_2,0)) M8001C306 --This measurement provides the number of received PDCP SDUs for QCI 2 bearers.Only user-plane traffic (DTCH) is considered."
,sum(nvl(PDCP_SDU_DL_QCI_1,0)) M8001C314 --The number of transmitted PDCP SDUs in downlink for QCI 1
,sum(nvl(PDCP_SDU_DL_QCI_2,0)) M8001C315 --This measurement provides the number of transmitted PDCP SDUs in downlink for GBR DRBs of QCI2 characteristics.
,sum(nvl(SUM_ACTIVE_UE,0)) M8001C320 --This measurement provides the sum of sampled values for measuring the number of simultaneously Active UEs. This counter divided by the denominator DENOM_ACTIVE_UE provides the average number of Active UEs per cell.A UE is active if at least a single non-GBR DRB has been successfully configured for it."
,sum(nvl(DENOM_ACTIVE_UE,0)) M8001C321 --The number of samples taken for counter SUM_ACTIVE_UE used as a denominator for average calculation.
,sum(nvl(PDCP_SDU_DISC_DL_QCI_1,0)) M8001C323 --This measurement provides the number of discarded PDCP SDUs in downlink for GBR DRBs of QCI1 bearers.
,sum(nvl(PDCP_SDU_DISC_DL_QCI_2,0)) M8001C324 --This measurement provides the number of discarded PDCP SDUs in downlink for GBR DRBs of QCI2 characteristics.
,sum(nvl(RACH_STP_ATT_SMALL_MSG,0)) m8001c6 --The number of RACH setup attempts for small size messages (only contention based).
,sum(nvl(RACH_STP_ATT_LARGE_MSG,0)) m8001c7 --The number of RACH setup attempts for large size messages (only contention based).
,sum(nvl(RACH_STP_COMPLETIONS,0)) M8001C8 --The number of RACH setup completions (contention based and dedicated preambles).
,sum(nvl(PDCP_SDU_UL,0)) M8001C153
,sum(nvl(PDCP_SDU_DL,0)) M8001C154
,avg(nvl(CA_DL_CAP_UE_AVG,0)) M8001C494
,avg(nvl(CA_SCELL_CONF_UE_AVG,0)) M8001C495
,avg(nvl(CA_SCELL_ACTIVE_UE_AVG,0)) M8001C496

FROM NOKLTE_PS_LCELLD_MNC1_raw PMRAW
        where
             ---to_char(period_start_time,'yyyymmddhh24') >= to_char(SYSDATE-1,'yyyymmddhh24')
         period_start_time between to_date(&1,'yyyymmddhh24') and to_date(&2,'yyyymmddhh24')
            -- and to_char(period_start_time,'yyyymmddhh24') <= to_char(SYSDATE-1,'yyyymmddhh24')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmddhh24'),LNCEL_ID,to_char(period_start_time,'yyyymmddhh24')||LNCEL_ID
)M8001
,
(
select
             to_char(period_start_time,'yyyymmddhh24') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmddhh24')||LNCEL_ID cel_key_id
            ,sum(nvl(IP_TPUT_VOL_DL_QCI_1,0)) M8012C117 --This measurement provides IP throughput volume on QCI 1 bearers in downlink as experienced by the UE.
,sum(nvl(IP_TPUT_TIME_DL_QCI_1,0)) M8012C118 --This measurement provides IP throughput time on QCI 1 bearers in downlink.
,sum(nvl(IP_TPUT_VOL_DL_QCI_2,0)) M8012C119 --This measurement provides IP throughput volume on QCI 2 bearers in downlink as experienced by the UE.
,sum(nvl(PDCP_SDU_VOL_UL,0)) M8012C19 --The measurement gives an indication of the eUu interface traffic load by reporting the total received PDCP SDU-related traffic volume.
,sum(nvl(PDCP_SDU_VOL_DL,0)) M8012C20 --The measurement gives an indication of the eUu interface traffic load by reporting the total transmitted PDCP SDU-related traffic volume.
,sum(nvl(IP_TPUT_VOL_UL_QCI_1,0)) M8012C91 --This measurement provides IP throughput volume on QCI 1 bearers in uplink as experienced by the UE.
,sum(nvl(IP_TPUT_TIME_UL_QCI_1,0)) M8012C92 --This measurement provides IP throughput time on QCI 1 bearers in uplink.
,sum(nvl(IP_TPUT_VOL_UL_QCI_2,0)) M8012C93 --This measurement provides IP throughput volume on QCI 2 bearers in uplink as experienced by the UE.
,sum(nvl(RLC_PDU_DL_VOL_CA_SCELL,0)) M8012C151
,max(nvl(PDCP_DATA_RATE_MAX_UL,0)) M8012C22
,max(nvl(PDCP_DATA_RATE_MAX_DL,0)) M8012C25
,sum(nvl(ACTIVE_TTI_UL,0)) M8012C89
,sum(nvl(ACTIVE_TTI_DL,0)) M8012C90

,lnbts.co_object_instance enb_id
,lncel.co_object_instance cell_id
--,lnbts.co_main_host bts_ip
,lnbts.co_sys_version bts_version
,Trim(lnbts.co_name) bts_name
,Trim(lncel.co_name) cel_name            
            
            
                  
        from
             NOKLTE_PS_LCELLT_MNC1_raw PMRAW,ctp_common_objects lnbts,ctp_common_objects lncel
        where
        
         period_start_time between to_date(&1,'yyyymmddhh24') and to_date(&2,'yyyymmddhh24')
            --- to_char(period_start_time,'yyyymmddhh24')  >= to_char(SYSDATE-1,'yyyymmddhh24')
            -- and to_char(period_start_time,'yyyymmddhh24') <= to_char(SYSDATE-1,'yyyymmddhh24')
             --AND PERIOD_DURATION=15
             
             AND PMRAW.LNCEL_ID=lncel.co_gid 
             --AND (lnbts.co_oc_id=2860  or lnbts.co_oc_id=2140 or lnbts.co_oc_id=2252)
             AND lnbts.CO_STATE<>9 
             --AND (lncel.co_oc_id=2881 or lncel.co_oc_id=2148 or lncel.co_oc_id=2260)
             AND lncel.CO_STATE<>9
            and PMRAW.lnbts_id=lnbts.co_gid             
             
             
             
             
             
        group by
             to_char(period_start_time,'yyyymmddhh24'),LNCEL_ID,to_char(period_start_time,'yyyymmddhh24')||LNCEL_ID
             
             
             
             ,lnbts.co_object_instance,lncel.co_object_instance--,lnbts.co_main_host
             ,lnbts.co_sys_version,Trim(lnbts.co_name),Trim(lncel.co_name)
             
             
)M8012
,(
select
             to_char(period_start_time,'yyyymmddhh24') sdatetime
            -- ,MRBTS_ID
             ,LNBTS_ID
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmddhh24')||LNCEL_ID cel_key_id
    ,avg(nvl(RRC_CONNECTED_UE_AVG,0)) M8051C55    --This measurement provides the number of Inter System Handover attempts to GERAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
    ,max(nvl(RRC_CONNECTED_UE_MAX,0)) M8051C56    --This measurement provides the number of successful Inter System Handover completions to GERAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
    ,avg(nvl(CELL_LOAD_ACTIVE_UE_AVG,0)) M8051C57
    ,max(nvl(CELL_LOAD_ACTIVE_UE_MAX,0)) M8051C58
   ,avg(nvl(DL_UE_DATA_BUFFER_AVG,0)) M8051C107
   ,max(nvl(DL_UE_DATA_BUFFER_MAX,0)) M8051C108
   ,avg(nvl(UL_UE_DATA_BUFFER_AVG,0)) M8051C109
   ,max(nvl(UL_UE_DATA_BUFFER_MAX,0)) M8051C110
,sum(nvl(SUM_ACT_UE,0)) M8051C62
,sum(nvl(DENOM_ACT_UE,0)) M8051C63
            from
            NOKLTE_PS_LUEQ_MNC1_RAW  PMRAW  
        where
             period_start_time between to_date(&1,'yyyymmddhh24') and to_date(&2,'yyyymmddhh24')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmddhh24'),MRBTS_ID,LNBTS_ID,LNCEL_ID,to_char(period_start_time,'yyyymmddhh24')||LNCEL_ID
)M8051
WHERE      M8012.cel_key_id=m8001.cel_key_id(+)
       AND M8012.cel_key_id=m8051.cel_key_id(+)

)
WHERE  enb_id between '0' and '999999'  
--and enb_id in ('701771','823557','701812','823136','701567','823546','837915','716822','340771','838344','684246','838361','201852','823229','340995','838040','837999','340772','823580','716878','201888','838189','838146','823776','823788','837916','823579','823787','201743','838147','838233','340805','823283','340773','823654','684172','341014','838345','823448','823506','340870','838237','823467','838037','838016','838393','823382','716811','823280','823057','823447','837986','341010','823707','823309','201933','823128','201930','701341','701340','838362','701334','659922','201887','716996','701306','823432','659950','659972','701640','701407','701810','701332','701576','659902','659982','701692','701521','823431','701187','716989','660220','659954','659937','659953','659932','701811','716949','659933','701488','701436','701349','701284','701793','659961','659967','701333','659910','701773','701419','701600','701346','659963','716862','659987','659962','701480','701474','341021','717025','701417')
/*
AND ((enb_id >=659712 and enb_id <=660223) 
        or (enb_id >=684032 and enb_id <=684287)
        or (enb_id >=701184 and enb_id <=701439) 
        or (enb_id >=701440 and enb_id <=701951)
        or (enb_id >=716800 and enb_id <=717055)
        or (enb_id >=201728 and enb_id <=201983)
        or (enb_id >=822528 and enb_id <=823807)
        or (enb_id >=837888 and enb_id <=838399)
        or (enb_id >=340736 and enb_id <=341247)
        )
*/
GROUP BY 
substr(sdate,1,10)*100+to_char(trunc(to_number(substr(sdate,11,2)/15))*15,'00'),
city,enb_cell,enb_id,bts_version,cel_name
ORDER BY city,substr(sdate,1,10)*100+to_char(trunc(to_number(substr(sdate,11,2)/15))*15,'00')--,enb_cell,enb_id



) maxue

on

maxue_para.enb_cell = maxue.enb_cell
having (
(round(max(maxue.最大激活用户数)/max(least(maxue_para.cqi资源,maxue_para.sr资源,maxue_para.maxNumActUE,maxue_para.maxNumRrc,maxue_para.maxNumRrcEmergency))*100,0)>70
       and max(least(maxue_para.cqi资源,maxue_para.sr资源,maxue_para.maxNumActUE,maxue_para.maxNumRrc,maxue_para.maxNumRrcEmergency))<300)
       or 
(round(max(maxue.最大激活用户数)/max(least(maxue_para.cqi资源,maxue_para.sr资源,maxue_para.maxNumActUE,maxue_para.maxNumRrc,maxue_para.maxNumRrcEmergency))*100,0)>30    
       and max(least(maxue_para.cqi资源,maxue_para.sr资源,maxue_para.maxNumActUE,maxue_para.maxNumRrc,maxue_para.maxNumRrcEmergency))between 300 and 500)
       or 
       (round(max(maxue.最大激活用户数)/max(least(maxue_para.cqi资源,maxue_para.sr资源,maxue_para.maxNumActUE,maxue_para.maxNumRrc,maxue_para.maxNumRrcEmergency))*100,0)>95    
       and max(least(maxue_para.cqi资源,maxue_para.sr资源,maxue_para.maxNumActUE,maxue_para.maxNumRrc,maxue_para.maxNumRrcEmergency))>=500)
       )
group by maxue_para.enb_cell,VERSION,带宽,actDrx,maxue.sdate
order by 配置最大激活用户数,带宽,actDrx
--&1&2
