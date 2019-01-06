SELECT
substr(sdate,1,8) sdate
,
city
,enb_cell,enb_id,bts_version,cel_name


,Round(Decode(sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21),0,0,100*sum(M8013C5)/sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21+M8013C31+ M8013C34)),2)  RRC连接建立成功率  --0409修改增加了+M8013C31+ M8013C34
--,Round(Decode(sum(M8006C0),0,0,100*sum(M8006C1)/sum(M8006C0)),2)  ERAB建立成功率
--,Round(Decode(sum(M8006C0),0,0,100*sum(M8006C0-M8006C3-M8006C4-M8006C5)/sum(M8006C0)),2)  ERAB建立成功率
,Round(Decode(sum(M8006C0),0,100,100*sum(ERAB建立成功率分子)/sum(M8006C0)),4)  ERAB建立成功率  --2017年7月31日更新
--,round(Round(Decode(sum(M8006C0),0,0,100*sum(M8006C1)/sum(M8006C0)),2)*Round(Decode(sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21),0,0,100*sum(M8013C5)/sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21)),2)/100,2)  无线接通率
,round(Decode(sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21),0,0,sum(M8013C5)/sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21+M8013C31+ M8013C34))*Decode(sum(M8006C0),0,100,100*sum(ERAB建立成功率分子)/sum(M8006C0)),2)  无线接通率

,Round(decode(sum(radio_drop_deno),0,0,100*sum(radio_drop_num)/sum(radio_drop_deno)),2) 无线掉线率
,round(decode(sum(M8006C1+M8001C223),0,0,100*sum(ERAB_drop_deno)/sum(M8006C1+M8001C223)),2) ERAB掉线率   --这公式和亿阳结果基本一致
,Round(Decode(sum(M8009C6 + M8014C0 + M8014C14),0,0,100* sum(M8009C7 + M8014C7 + M8014C19) / sum(M8009C6 + M8014C0 + M8014C14)),2) 切换成功率ZB 
,Round(Decode(sum(M8009C6 + M8014C6 + M8014C18),0,0,100* sum(M8009C7 + M8014C7 + M8014C19) / sum(M8009C6 + M8014C6 + M8014C18)),2) 切换成功率QQ
,Round(sum(M8012C19)/(1024),2)   用户面PDCP上行数据量KB
,Round(sum(M8012C20)/(1024),2)   用户面PDCP下行数据量KB
    ,round(sum(M8012C91)/8/1000/1000,2)  QCI1上行流量Mb
 ,round(sum(M8012C117)/8/1000/1000,2) QCI1下行流量Mb
 ,round(sum(M8006C181)/3600,2) QCI1话务量Erl  --2017年7月28日修改
  ,round(sum(M8012C93)/8/1000/1000,2)  QCI2上行流量Mb
 ,round(sum(M8012C119)/8/1000/1000,2) QCI2下行流量Mb
 ,round(sum(M8006C46)/3600,2) QCI2话务量Erl
 ,Round(Decode(sum(M8006C188+M8006C197),0,100,100*sum(M8006C206+M8006C215)/sum(M8006C188+M8006C197)),2)*Round(Decode(sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21),0,0,100*sum(M8013C5)/sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21+M8013C31+ M8013C34)),2)/100 qci1无线接通率
 ,Round(Decode(sum(M8006C188+M8006C197),0,100,100*sum(M8006C206+M8006C215)/sum(M8006C188+M8006C197)),2) qci1_erab建立成功率
  ,Round(Decode(sum(M8006C189+M8006C198),0,100,100*sum(M8006C207+M8006C216)/sum(M8006C189+M8006C198)),2) qci2_erab建立成功率
 ,Decode(sum(M8006C206+M8006C215)+ decode(sum(M8006C54),0,0,ceil(sum(M8006C45)/sum(M8006C54))),0,0,round(100*Sum(M8006C176+M8006C269+M8006C273)/(sum(M8006C206+M8006C215)+ decode(sum(M8006C54),0,0,ceil(sum(M8006C45)/sum(M8006C54)))),2)) QCI1掉线率小区级
 ,Round(Decode(sum(M8006C206+M8006C215),0,0,100*Sum(M8006C176+M8006C269+M8006C273)/sum(M8006C206+M8006C215)),2) QCI1掉线率网络级
 -- ,Decode(sum(M8006C206+M8006C215)+ decode(sum(M8006C54),0,0,ceil(sum(M8006C45)/sum(M8006C54))),0,0,round(100*Sum(M8006C125+M8006C176+M8006C143)/(sum(M8006C206+M8006C215)+ decode(sum(M8006C54),0,0,ceil(sum(M8006C45)/sum(M8006C54)))),2)) QCI1掉线率小区级
 --,Round(Decode(sum(M8006C206+M8006C215),0,0,100*Sum(M8006C125+M8006C176+M8006C143)/sum(M8006C206+M8006C215)),2) QCI1掉线率网络级
    ,round(decode(sum(M8001C305),0,0,sum(M8026C255)/sum(M8001C305)*100),2) QCI1上行丢包率
 ,round(decode(sum(M8001C314+M8026C260),0,0,sum(M8026C260)/sum(M8001C314+M8026C260)*100),2) QCI1下行丢包率
 ,round(decode(sum(M8001C314+M8026C260),0,0,sum(M8001C323)/sum(M8001C314+M8026C260)*100),2) QCI1下行弃包率
   ,Round(Decode(sum(M8016C33),0,100,100*sum(M8016C33-M8016C35)/sum(M8016C33)),2) esrvcc成功率new


 ,round(decode(sum(M8001C306),0,0,sum(M8026C256)/sum(M8001C306)*100),2) QCI2上行丢包率 
 ,round(decode(sum(M8001C315+M8026C261),0,0,sum(M8026C261)/sum(M8001C315+M8026C261)*100),2) QCI2下行丢包率 
 ,round(decode(sum(M8001C315+M8026C261),0,0,sum(M8001C324)/sum(M8001C315+M8026C261)*100),2) QCI2下行弃包率 



   
,round(avg(平均激活用户数),2) 平均激活用户数
,max(最大激活用户数)  最大激活用户数       
,max(RRC最大连接数)  RRC最大连接数 
,sum(M8008C4 + M8013C17 + M8013C18 + M8013C19 + M8013C20 + M8013C21)  RRC连接数
-- ,'{*_*}' 容量类
 ,max(M8006C224) QCI1最大用户数
 ,max(M8006C225) QCI2最大用户数 
,sum(拥塞次数) 拥塞次数
--,sum(M8013C65) 控制面过负荷拥塞
--,sum(M8013C66) 用户面过负荷拥塞
--,sum(M8013C67) PUCCH资源不足拥塞
--,sum(M8013C68) 最大RRC受限拥塞
--,sum(M8013C69) MME过负荷拥塞
,sum(M8013C5)  RRC连接建立成功次数
,sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21+M8013C31+ M8013C34) RRC连接建立请求次数
,sum(M8006C1) ERAB建立成功数real
--,sum(M8006C0-M8006C3-M8006C4-M8006C5) ERAB建立成功数
,sum(ERAB建立成功率分子) ERAB建立成功数  -- 2017年7月31日 更新
,sum(M8006C0) ERAB建立请求数
,sum(radio_drop_num) 无线掉线率分子
,Round(sum(radio_drop_deno),2) 无线掉线率分母 --分版本
,sum(ERAB_drop_deno) ERAB掉线次数  --RL55 15A自适应
,Round(sum(M8006C1 + M8001C223),2) ERAB掉线率分母
,sum(M8009C7 + M8014C7 + M8014C19) 切换成功次数 
,sum(M8009C6 + M8014C0 + M8014C14) 切换请求次数ZB 
,sum(M8009C6 + M8014C6 + M8014C18) 切换请求次数QQ
,case when round(avg(上行有效RRC连接平均数),2)>round(avg(下行有效RRC连接平均数),2) then round(avg(上行有效RRC连接平均数),2) else round(avg(下行有效RRC连接平均数),2) end 有效RRC连接平均数
,case when max(上行有效RRC连接最大数)>max(下行有效RRC连接最大数) then max(上行有效RRC连接最大数) else max(下行有效RRC连接最大数) end 有效RRC连接最大数
,round(decode(sum(M8011C38),0,0,(sum(M8011C39)*1+sum(M8011C40)*2+sum(M8011C41)*4+sum(M8011C42)*8)/sum(M8011C38)*100),2) PDCCH信道CCE占用率
,Round((avg(M8005C5)-avg(M8005C95)),2) PUSCH_RIP
,case when length(&1)=8 and length(&2)=8 then round(decode(avg(M8001C217)+ avg(M8001C216),0,0,(avg(M8011C50)/(24*60*60*1000*1/5) + avg(M8011C37)/10*avg(M8001C216)/100)/(avg(M8001C217)+ avg(M8001C216)))*100,2) 
      when length(&1)=10 and length(&2)=10 then round(decode(avg(M8001C217)+ avg(M8001C216),0,0,(avg(M8011C50)/(60*60*1000*1/5) + avg(M8011C37)/10*avg(M8001C216)/100)/(avg(M8001C217)+ avg(M8001C216)))*100,2)
      when length(&1)=12 and length(&2)=12 then round(decode(avg(M8001C217)+ avg(M8001C216),0,0,(avg(M8011C50)/(15*60*1000*1/5) + avg(M8011C37)/10*avg(M8001C216)/100)/(avg(M8001C217)+ avg(M8001C216)))*100,2)
end 无线利用率  --2017年10月13日更新
,case when length(&1)=8 and length(&2)=8 then round(avg(M8011C50)/(24*60*60*1000*1/5) + avg(M8011C37)/10*avg(M8001C216)/100)
      when length(&1)=10 and length(&2)=10 then round(avg(M8011C50)/(60*60*1000*1/5) + avg(M8011C37)/10*avg(M8001C216)/100)
      when length(&1)=12 and length(&2)=12 then round(avg(M8011C50)/(15*60*1000*1/5) + avg(M8011C37)/10*avg(M8001C216)/100)
end 无线利用率分子  --2017年10月13日更新
,round(avg(M8001C217)+ avg(M8001C216),0) 无线利用率分母
,round(decode(sum(m8001c6+m8001c7+m8001c286),0,0,sum(M8001C8)/sum(m8001c6+m8001c7+m8001c286))*100,2) RACH成功率
,sum(m8001c6+m8001c7+m8001c286) RACH请求次数msg1
,sum(M8001C8) RACH成功次数msg2
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- ,'{*_*}' 接入类 
 ,Round(Decode(sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21+M8013C31+M8013C34+M8008C4),0,0,100*sum(M8008C4)/sum(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21+M8013C31+M8013C34+M8008C4)),2) RRC重建比例
 ,sum(M8008C4) RRC重建次数

 ,sum(M8006C188+M8006C197) qci1_erab建立请求次数
 ,sum(M8006C206+M8006C215) qci1_erab建立成功次数

 ,sum(M8006C189+M8006C198) qci2_erab建立请求次数
 ,sum(M8006C207+M8006C216) qci2_erab建立成功次数
-- ,'{*_*}' 切换类 
 ,Round(Decode(sum(M8016C33),0,100,100*sum(M8016C34)/sum(M8016C33)),2) esrvcc成功率

 ,sum(M8016C33) esrvcc请求次数
 ,sum(M8016C34) esrvcc成功次数
 ,sum(M8016C35) esrvcc切换失败次数

--,'{*_*}' 保持类

 --,Sum(M8006C125+M8006C176+M8006C143) QCI1掉线次数
 ,Sum(M8006C176+M8006C269+M8006C273) QCI1掉线次数
 ,sum(M8006C206+M8006C215)+ decode(sum(M8006C54),0,0,ceil(sum(M8006C45)/sum(M8006C54))) QCI1掉线分母小区级

 ,sum(M8006C206+M8006C215) QCI1掉线分母网络级

 -- ,'{*_*}' 完整性

 ,sum(M8026C255) QCI1上行丢包率分子
 ,sum(M8001C305) QCI1上行丢包率分母
 ,sum(M8026C260) QCI1下行丢包率分子
 ,sum(M8001C314+M8026C260) QCI1下行丢包率分母
 ,sum(M8001C323) QCI1下行弃包率分子
 ,sum(M8001C314+M8026C260) QCI1下行弃包率分母
 ,sum(M8026C256) QCI2上行丢包率分子
 ,sum(M8001C306) QCI2上行丢包率分母
 ,sum(M8026C261) QCI2下行丢包率分子
 ,sum(M8001C315+M8026C261) QCI2下行丢包率分母
 ,sum(M8001C324) QCI2下行弃包率分子
 ,sum(M8001C315+M8026C261) QCI2下行弃包率分母
 ,round(avg(M8008C17),2) RRC平均建立时延ms
 ,round(avg(M8007C14),2) ERAB平均建立时延ms
 ,Round(avg(M8001C269+M8026C30),2) PDCP层用户面下行时延1
 ,Round（Decode(sum（M8001C314）,0,0,sum（M8001C269*M8001C314）/sum（M8001C314）),2） PDCP用户面下行时延2
 ,round(decode(sum(M8012C92),0,0,sum(M8012C91)/sum(M8012C92)*100),2) IP语音UL平均吞吐量kbps
 ,round(decode(sum(M8012C118),0,0,sum(M8012C117)/sum(M8012C118)*100),2) IP语音DL平均吞吐量kbps
 ,Round(Decode((sum(M8005C54)+sum(M8005C55)+sum(M8005C56)+sum(M8005C57)+sum(M8005C58)+sum(M8005C59)+sum(M8005C60)+sum(M8005C61)+sum(M8005C62)+sum(M8005C63)+sum(M8005C64)+sum(M8005C65)+sum(M8005C66)+sum(M8005C67)+sum(M8005C68)+sum(M8005C69)+sum(M8005C70)+sum(M8005C71)+sum(M8005C72)+sum(M8005C73)+sum(M8005C74)+sum(M8005C75)+sum(M8005C76)+sum(M8005C77)+sum(M8005C78)+sum(M8005C79)+sum(M8005C80)+sum(M8005C81)+sum(M8005C82)+sum(M8005C83)+sum(M8005C84)+sum(M8005C85)),0,0,100*(sum(M8005C54)+sum(M8005C55)+sum(M8005C56)+sum(M8005C57)+sum(M8005C58)+sum(M8005C59)+sum(M8005C60)+sum(M8005C61)+sum(M8005C62)+sum(M8005C63)+sum(M8005C64)+sum(M8005C65))/(sum(M8005C54)+sum(M8005C55)+sum(M8005C56)+sum(M8005C57)+sum(M8005C58)+sum(M8005C59)+sum(M8005C60)+sum(M8005C61)+sum(M8005C62)+sum(M8005C63)+sum(M8005C64)+sum(M8005C65)+sum(M8005C66)+sum(M8005C67)+sum(M8005C68)+sum(M8005C69)+sum(M8005C70)+sum(M8005C71)+sum(M8005C72)+sum(M8005C73)+sum(M8005C74)+sum(M8005C75)+sum(M8005C76)+sum(M8005C77)+sum(M8005C78)+sum(M8005C79)+sum(M8005C80)+sum(M8005C81)+sum(M8005C82)+sum(M8005C83)+sum(M8005C84)+sum(M8005C85))),2) PHR小于0比例
,(sum(M8005C54)+sum(M8005C55)+sum(M8005C56)+sum(M8005C57)+sum(M8005C58)+sum(M8005C59)+sum(M8005C60)+sum(M8005C61)+sum(M8005C62)+sum(M8005C63)+sum(M8005C64)+sum(M8005C65)) PHR分子
,(sum(M8005C54)+sum(M8005C55)+sum(M8005C56)+sum(M8005C57)+sum(M8005C58)+sum(M8005C59)+sum(M8005C60)+sum(M8005C61)+sum(M8005C62)+sum(M8005C63)+sum(M8005C64)+sum(M8005C65)+sum(M8005C66)+sum(M8005C67)+sum(M8005C68)+sum(M8005C69)+sum(M8005C70)+sum(M8005C71)+sum(M8005C72)+sum(M8005C73)+sum(M8005C74)+sum(M8005C75)+sum(M8005C76)+sum(M8005C77)+sum(M8005C78)+sum(M8005C79)+sum(M8005C80)+sum(M8005C81)+sum(M8005C82)+sum(M8005C83)+sum(M8005C84)+sum(M8005C85)) PHR分母

,round(decode(sum(M8001C153+ M8026C254),0,0,100*sum(M8026C254)/sum(M8001C153+ M8026C254)),2)   上行丢包率
,round(decode(sum(M8001C154+M8026C259),0,0,100*sum(M8026C259)/sum(M8001C154+M8026C259)),2)  下行丢包率
,sum(M8026C254) 上行丢包率分子
,sum(M8001C153+ M8026C254) 上行丢包率分母
,sum(M8026C259) 下行丢包率分子
,sum(M8001C154+M8026C259) 下行丢包率分母

,round(decode(2*sum(M8010C56+M8010C58+M8010C63+M8010C66)+sum(M8010C55+M8010C57+M8010C64+M8010C65+M8010C68+M8010C69), 0, 0, 100*2*sum(M8010C56+M8010C58+M8010C63+M8010C66)/(2*sum(M8010C56+M8010C58+M8010C63+M8010C66)+sum(M8010C55+M8010C57+M8010C64+M8010C65+M8010C68+M8010C69))), 2) 双流占比 --EU0409
,2*sum(M8010C56+M8010C58+M8010C63+M8010C66) 双流占比分子
,2*sum(M8010C56+M8010C58+M8010C63+M8010C66)+sum(M8010C55+M8010C57+M8010C64+M8010C65+M8010C68+M8010C69) 双流占比分母
,Round(avg(M8001C494)/100,2) CA能力UE数   --M8001C494，小区中具备CA能力的UE数，统计值为实际数x100                                                        
,avg(M8001C495)/100 配置SCell的UE数    --小区中配置SCell的UE数，统计值为实际数x100                                                                                                         
,avg(M8001C496)/100 激活SCell的UE数    --小区中有激活SCell的UE数，统计值为实际数x100
,sum(M8011C67) SCell配置请求数   --SCell配置请求数，基于相应的RRC重配置信息
,sum(M8011C68) SCell配置成功数  --SCell配置成功数，基于相应的RRC重配置完成信息
,sum(M8012C151) SCell数据量  --SCell传送的RLC层数据量
,sum(M8014C19) s1成功数
,sum(M8014C18) s1请求数

--,decode(avg(M8001C217),0,0,round(100*avg(M8011C50avg)/(24*60*60*1000/5)/avg(M8001C217),2)) 上行PRB平均利用率new  --day
--,avg(M8011C50avg) 上行PRB平均利用率分子  --day
--,24*60*60*1000/5*avg(M8001C217) 上行PRB平均利用率分母  --day
--,decode(avg(M8001C217),0,0,round(100*avg(M8011C50avg)/(60*60*1000/5)/avg(M8001C217),2)) 上行PRB平均利用率new  --hour
--,avg(M8011C50avg) 上行PRB平均利用率分子  --hour
--,60*60*1000/5*avg(M8001C217) 上行PRB平均利用率分母  --hour
--,decode(avg(M8001C217),0,0,round(100*avg(M8011C50avg)/(15*60*1000/5)/avg(M8001C217),2)) 上行PRB平均利用率new  --raw
--,avg(M8011C50avg) 上行PRB平均利用率分子  --raw
--,15*60*1000/5*avg(M8001C217) 上行PRB平均利用率分母  --raw
--,round(avg(M8011C37)/10,2) 下行PRB平均利用率new 
-- 2018年3月21日
,round(((avg(M8011C140+M8011C141+M8011C142+M8011C143+M8011C144+M8011C145+M8011C146+M8011C147+M8011C148+M8011C149))/1000+avg(M8011C150)/10000)*100,2) 上行PRB平均利用率new
,'-' 上行PRB平均利用率分子
,'-' 上行PRB平均利用率分母
,round(((avg(M8011C151+M8011C152+M8011C153+M8011C154+M8011C155+M8011C156+M8011C157+M8011C158+M8011C159+M8011C160))/1000+avg(M8011C161)/10000)*100,2) 下行PRB平均利用率new 


,Round(decode(sum(M8020C6-M8020C4),0,0, 100*sum(M8020C3)/sum(M8020C6-M8020C4)),2)  小区可用率 
,sum(M8020C3) 小区可用率分子
,sum(M8020C6-M8020C4) 小区可用率分母


,Round(Decode(sum(M8012C89),0,0,8*sum(M8012C19)/sum(M8012C89)),2) 上行PDCP平均速率kbps
,Round(Decode(sum(M8012C90),0,0,8*sum(M8012C20)/sum(M8012C90)),2) 下行PDCP平均速率kbps

,round(avg(M8012C22),2) 上行PDCP最大速率kbps
,round(avg(M8012C25),2) 下行PDCP最大速率kbps

,Round(Decode(sum(M8009C15+M8014C23+M8014C26),0,100,100* sum(M8009C16+M8014C24+M8014C27)/sum(M8009C15+M8014C23+M8014C26)),2) VOLTE切换成功率 --2017年8月28日新增
,sum(M8009C16+M8014C24+M8014C27) VOLTE切换成功次数 --2017年8月28日新增
,sum(M8009C15+M8014C23+M8014C26) VOLTE切换请求次数 --2017年8月28日新增

,decode(sum(qci2掉线率分母),0,0,100*sum(M8006C287+M8006C177+M8006C291)/sum(qci2掉线率分母)) qci2掉线率 --2017年8月28日新增
,sum(M8006C287+M8006C177+M8006C291) qci2掉线率分子 --2017年8月28日新增
,sum(qci2掉线率分母) qci2掉线率分母 --2017年8月28日新增
--2017年9月12日新增
--,sum(interference105)  "干扰小区大于-105"
--,sum(interference110)  "干扰小区大于-110"

-- 2017年9月24日 新增
/*
,round(decode(sum(总小区数),0,0,sum(volte低接通小区数)/sum(总小区数)*100),2) "volte低接通占比"
,round(decode(sum(总小区数),0,0,sum(volte高掉话小区数)/sum(总小区数)*100),2) "volte高掉话占比"
,round(decode(sum(总小区数),0,0,sum(volte上行高丢包小区数)/sum(总小区数)*100),2) "volte上行高丢包占比"
,round(decode(sum(总小区数),0,0,sum(volte下行高丢包小区数)/sum(总小区数)*100),2) "volte下行高丢包占比"
,sum(总小区数) 总小区数
,sum(volte低接通小区数) volte低接通小区数
,sum(volte高掉话小区数) volte高掉话小区数
,sum(volte上行高丢包小区数) volte上行高丢包小区数
,sum(volte下行高丢包小区数) volte下行高丢包小区数
*/
,sum(srvcc请求次数ZB) esrvcc请求次数ZB
--,sum(srvcc请求次数ZB)-sum(M8016C34) esrvcc切换失败次数ZB
,Round(Decode(sum(srvcc请求次数ZB),0,100,100*sum(M8016C34)/sum(srvcc请求次数ZB)),2) esrvcc成功率ZB

,round(sum(M8006C45)/3600,2) "QCI1话务量Erl_all"
--,sum(激活用户数超300小区) 激活用户数超300小区数
,round(sum("QCI1话务量Erl_亿阳"),2) "QCI1话务量Erl_亿阳"

--,round(decode(sum(M8005C54+M8005C55+M8005C56+M8005C57+M8005C58+M8005C59+M8005C60+M8005C61+M8005C62+M8005C63+M8005C64+M8005C65+M8005C66+M8005C67+M8005C68+M8005C69+M8005C70+M8005C71+M8005C72+M8005C73+M8005C74+M8005C75+M8005C76+M8005C77+M8005C78+M8005C79+M8005C80+M8005C81+M8005C82+M8005C83+M8005C84+M8005C85),0,0,sum(M8005C54*(-22)+M8005C55*(-20)+M8005C56*(-18)+M8005C57*(-16)+M8005C58*(-14)+M8005C59*(-12)+M8005C60*(-10)+M8005C61*(-8)+M8005C62*(-6)+M8005C63*(-4)+M8005C64*(-2)+M8005C65*(0)+M8005C66*(2)+M8005C67*(4)+M8005C68*(6)+M8005C69*(8)+M8005C70*(10)+M8005C71*(12)+M8005C72*(14)+M8005C73*(16)+M8005C74*(18)+M8005C75*(20)+M8005C76*(22)+M8005C77*(24)+M8005C78*(26)+M8005C79*(28)+M8005C80*(30)+M8005C81*(32)+M8005C82*(34)+M8005C83*(36)+M8005C84*(38)+M8005C85*(39))/sum(M8005C54+M8005C55+M8005C56+M8005C57+M8005C58+M8005C59+M8005C60+M8005C61+M8005C62+M8005C63+M8005C64+M8005C65+M8005C66+M8005C67+M8005C68+M8005C69+M8005C70+M8005C71+M8005C72+M8005C73+M8005C74+M8005C75+M8005C76+M8005C77+M8005C78+M8005C79+M8005C80+M8005C81+M8005C82+M8005C83+M8005C84+M8005C85)),2) PHR均值


FROM
(
SELECT comm.sdate
          --   ,M8020.MRBTS_ID
         --    ,M8020.LNBTS_ID
         --    ,M8020.LNCEL_ID
     ,enb_id || '_' || cell_id enb_cell
     ,enb_id,
         case  when ((enb_id>=655360 and enb_id<=656383 ) or (enb_id>= 686080 and enb_id<=686591 ) or (enb_id>= 696320 and enb_id<=696831 )or (enb_id>= 119296 and enb_id<=120831 )) then 'ZhanJiang'
              when ((enb_id>=656384 and enb_id<=657151 ) or (enb_id>= 683520 and enb_id<=683775 ) or (enb_id>= 698880 and enb_id<=699647 ) or (enb_id>= 711168and enb_id<=712191 ))then 'MaoMing'
              when ((enb_id>=659712 and enb_id<=660223 ) or (enb_id >= 684032 and enb_id <=684287 ) or(enb_id>= 701184 and enb_id<=701951 ) or (enb_id>= 716800 and enb_id<=717055 ) or (enb_id >=822528 and enb_id <=823807) or (enb_id >=201728 and enb_id <=201983) or (enb_id >=837888 and enb_id <=838399) or (enb_id >=340736 and enb_id <=341247)or (enb_id >=561920 and enb_id <=562431) or (enb_id >=895488 and enb_id <=896255)) then 'ChaoZhou'
              when ((enb_id>=660736 and enb_id<=661247 ) or (enb_id >= 683776 and enb_id <=684031 ) or(enb_id>= 702464 and enb_id<=703487 ) ) then 'MeiZhou'
              when ((enb_id>=662272 and enb_id<=662783 ) or (enb_id>= 704000 and enb_id<=704511 ) or (enb_id >=719616 and enb_id <=720127)) then 'YangJiang'
              else 'NA'      
        end City
       
,cell_id
--,bts_ip
,bts_version
--,bts_name
,cel_name
,M8001C147,M8001C148,M8001C150,M8001C151,M8001C200,M8001C216,M8001C217,M8001C223,M8001C224,M8001C269,m8001c286,M8001C305,M8001C306,M8001C314,M8001C315,M8001C320,M8001C321,M8001C323,M8001C324,m8001c6,m8001c7,M8001C8,M8005C5,M8005C95,M8006C0,M8006C1,M8006C125,M8006C13,M8006C14,M8006C143,M8006C168,M8006C169,M8006C170,M8006C176,M8006C177,M8006C178,M8006C179,M8006C180,M8006C188,M8006C189,M8006C197,M8006C198,M8006C206,M8006C207,M8006C215,M8006C216,M8006C224,M8006C225,M8006C257,M8006C3,M8006C35,M8006C36,M8006C4,M8006C45,M8006C46,M8006C5,M8006C54,M8007C14,M8008C17,M8008C4,M8009C6,M8009C7,M8011C37,M8011C38,M8011C39,M8011C40,M8011C41,M8011C42,M8011C50,M8012C117,M8012C118,M8012C119,M8012C19,M8012C20,M8012C91,M8012C92,M8012C93,M8013C16,M8013C17,M8013C18,M8013C19,M8013C20,M8013C21,M8013C31,M8013C34,M8013C47,M8013C5,M8013C59,M8013C60,M8013C65,M8013C66,M8013C67,M8013C68,M8013C69,M8013C8,M8014C0,M8014C14,M8014C18,M8014C19,M8014C6,M8014C7,M8016C25,M8016C33,M8016C34,M8016C35,M8026C255,M8026C256,M8026C260,M8026C261,M8026C30
,M8005C54,M8005C55,M8005C56,M8005C57,M8005C58,M8005C59,M8005C60,M8005C61,M8005C62,M8005C63,M8005C64,M8005C65,M8005C66,M8005C67,M8005C68,M8005C69,M8005C70,M8005C71,M8005C72,M8005C73,M8005C74,M8005C75,M8005C76,M8005C77,M8005C78,M8005C79,M8005C80,M8005C81,M8005C82,M8005C83,M8005C84,M8005C85,M8005C87,M8005C88,M8005C89,M8051C55,M8051C56,M8051C57,M8051C58,M8051C107,M8051C108,M8051C109,M8051C110
,M8051C62,M8051C63,M8001C153,M8001C154,M8026C254,M8026C259,M8006C269,M8006C273,
M8001C494,M8001C495,M8001C496,M8010C55,M8010C56,M8010C57,M8010C58,M8010C63,M8010C64,M8010C65,M8010C66,M8010C68,M8010C69,M8011C50avg,M8011C67,M8011C68,M8012C151,M8012C22,M8012C25,M8012C89,M8012C90,M8020C3,M8020C4,M8020C6,M8006C181
,M8006C244,M8006C245,M8006C248,M8006C249,M8006C252,M8006C253,M8011C140,M8011C141,M8011C142,M8011C143,M8011C144,M8011C145,M8011C146,M8011C147,M8011C148,M8011C149,M8011C150,M8011C151,M8011C152,M8011C153,M8011C154,M8011C155,M8011C156,M8011C157,M8011C158,M8011C159,M8011C160,M8011C161
,M8009C15,M8009C16,M8014C23,M8014C24,M8014C26,M8014C27,M8006C287,M8006C291,M8016C54,"QCI1话务量Erl_亿阳"
,interference105,interference110
--,case when (bts_version='LNT4.0' or bts_version='LNT3.0' ) then M8006C176+M8006C177+M8006C178+M8006C179+M8006C180+M8013C16 
--      else M8006C176+M8006C177+M8006C178+M8006C179+M8006C180+M8013C59+M8013C60 end radio_drop_num --掉线率分子 自适应RL55/45
            
--,case when (bts_version='LNT4.0' or bts_version='LNT3.0' ) then M8006C35+M8006C36+M8006C168+M8006C169+M8006C170+M8001C223 
--     else M8013C47+Decode(M8001C321,0,0,(M8001C320/M8001C321)) end radio_drop_deno --掉线率分母 自适应RL55/45  
,case when (M8013C47='0' ) then M8006C176+M8006C177+M8006C178+M8006C179+M8006C180+M8013C16 

else M8006C176+M8006C177+M8006C178+M8006C179+M8006C180+M8013C59+M8013C60 end radio_drop_num --掉线率分子 自适应RL55/45     
 
,case when (bts_version='TL15A' or bts_version = 'TLF15A' or bts_version='LNT5.0' or bts_version = 'LNZ5.0') then M8013C47+Decode(M8001C321,0,0,(M8001C320/M8001C321))
      else M8013C47+Decode(M8051C63,0,0,(M8051C62/M8051C63))
      end radio_drop_deno --掉线率分母 自适应RL55/TL16A
      
,case when (bts_version='LNT5.0' or bts_version = 'LNZ5.0') then M8013C8 

else M8013C65+M8013C66+M8013C67+M8013C68+M8013C69 end 拥塞次数 --ERAB掉线率分母 自适应RL55/15A 
  
,case when (bts_version='LNT5.0' or bts_version = 'LNZ5.0') then M8016C25+M8006C176+M8006C177+M8006C178+M8006C179+M8006C180+M8006C13+M8006C14 

else M8016C25+M8006C176+M8006C177+M8006C178+M8006C179+M8006C180+M8006C257 end erab_drop_deno --ERAB掉线率分母 自适应RL55/15A 

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


,case when (bts_version='LNT5.0' or bts_version = 'LNZ5.0' or bts_version='TL15A' or bts_version = 'TLF15A') then M8006C0-M8006C3-M8006C4-M8006C5
	else M8006C0-(M8006C244+M8006C248+M8006C245+M8006C249+M8006C252+M8006C253) end ERAB建立成功率分子 

,round(decode(M8006C54,0,M8006C207+M8006C216,M8006C207+M8006C216+M8006C46/M8006C54),0) qci2掉线率分母 --2017年8月28日新增

--2017年9月24日 新增

,case when "QCI1话务量Erl_亿阳" > 1 
			and M8006C45 is not null 
	then 1 
	else 0 end 总小区数
,case when "QCI1话务量Erl_亿阳" > 1 
			and "QCI1话务量Erl_亿阳" is not null 
			and Round(Decode((M8006C188+M8006C197),0,100,100*(M8006C206+M8006C215)/(M8006C188+M8006C197)),2)*Round(Decode((M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21),0,0,100*(M8013C5)/(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21+M8013C31+ M8013C34)),2)/100 < 95
			and Round(Decode((M8006C188+M8006C197),0,100,100*(M8006C206+M8006C215)/(M8006C188+M8006C197)),2)*Round(Decode((M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21),0,0,100*(M8013C5)/(M8013C17+M8013C18+M8013C19+M8013C20+ M8013C21+M8013C31+ M8013C34)),2)/100 is not null	
	then 1
	else 0 end volte低接通小区数
,case when "QCI1话务量Erl_亿阳" > 1 
			and "QCI1话务量Erl_亿阳" is not null 
			and Decode((M8006C206+M8006C215)+ decode((M8006C54),0,0,ceil((M8006C45)/(M8006C54))),0,0,round(100*(M8006C176+M8006C269+M8006C273)/((M8006C206+M8006C215)+ decode((M8006C54),0,0,ceil((M8006C45)/(M8006C54)))),2)) > 5
			and Decode((M8006C206+M8006C215)+ decode((M8006C54),0,0,ceil((M8006C45)/(M8006C54))),0,0,round(100*(M8006C176+M8006C269+M8006C273)/((M8006C206+M8006C215)+ decode((M8006C54),0,0,ceil((M8006C45)/(M8006C54)))),2)) is not null
		then 1
		else 0 end volte高掉话小区数
,case when "QCI1话务量Erl_亿阳" > 1 
			and "QCI1话务量Erl_亿阳" is not null 
			and round(decode((M8001C305),0,0,(M8026C255)/(M8001C305)*100),2) > 1
			and round(decode((M8001C305),0,0,(M8026C255)/(M8001C305)*100),2) is not null
		then 1
		else 0 end volte上行高丢包小区数
,case when "QCI1话务量Erl_亿阳" > 1 
			and "QCI1话务量Erl_亿阳" is not null 
			and round(decode((M8001C314+M8026C260),0,0,(M8026C260)/(M8001C314+M8026C260)*100),2) >1
			and round(decode((M8001C314+M8026C260),0,0,(M8026C260)/(M8001C314+M8026C260)*100),2) is not null
		then 1
		else 0 end volte下行高丢包小区数
		
,case when (bts_version='LNT5.0' or bts_version = 'LNZ5.0' or bts_version='TL15A' or bts_version = 'TLF15A') then M8016C33
	else M8016C54 end srvcc请求次数ZB		
		
,case when (bts_version='LNT5.0' or bts_version = 'LNZ5.0' or bts_version='TL15A' or bts_version = 'TLF15A') then 是否超300用户M8001
 else 是否超300用户M8051 end 激活用户数超300小区
FROM
( select
             to_char(period_start_time,'yyyymmdd') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
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
,case when max(nvl(CELL_LOAD_ACT_UE_MAX,0)) >= 300 and max(nvl(CELL_LOAD_ACT_UE_MAX,0)) is not null then 1 else 0 end 是否超300用户M8001

FROM NOKLTE_PS_LCELLD_lncel_day PMRAW
        where
             ---to_char(period_start_time,'yyyymmdd') >= to_char(SYSDATE-1,'yyyymmdd')
         period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8001
,



( select
             to_char(period_start_time,'yyyymmdd') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,AVG(DECODE(RSSI_PUSCH_AVG,0,NULL,RSSI_PUSCH_AVG)) M8005C5 --The Received Signal Strength Indicator (RSSI) Mean value for PUSCH, measured in the eNB.
,avg(SINR_PUSCH_AVG) M8005C95 --The Signal to Interference and Noise Ratio (SINR) Mean value for PUSCH, measured in the eNB.
,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL1,0)) M8005C54    --The UE Power Headroom values in the range of -23dB <= PHR < -21dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL2,0)) M8005C55    --The UE Power Headroom values in the range of -21dB <= PHR < -19dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL3,0)) M8005C56    --The UE Power Headroom values in the range of -19dB <= PHR < -17dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL4,0)) M8005C57    --The UE Power Headroom values in the range of -17dB <= PHR < -15dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL5,0)) M8005C58    --The UE Power Headroom values in the range of -15dB <= PHR < -13dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL6,0)) M8005C59    --The UE Power Headroom values in the range of -13dB <= PHR < -11dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL7,0)) M8005C60    --The UE Power Headroom values in the range of -11dB <= PHR < -9dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL8,0)) M8005C61    --The UE Power Headroom values in the range of -9dB <= PHR < -7dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL9,0)) M8005C62    --The UE Power Headroom values in the range of -7dB <= PHR < -5dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL10,0)) M8005C63    --The UE Power Headroom values in the range of -5dB <= PHR < -3dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL11,0)) M8005C64    --The UE Power Headroom values in the range of -3dB <= PHR < -1dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL12,0)) M8005C65    --The UE Power Headroom values in the range of -1dB <= PHR < 1dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL13,0)) M8005C66    --The UE Power Headroom values in the range of 1dB <= PHR < 3dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL14,0)) M8005C67    --The UE Power Headroom values in the range of 3dB <= PHR < 5dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL15,0)) M8005C68    --The UE Power Headroom values in the range of 5dB <= PHR < 7dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL16,0)) M8005C69    --The UE Power Headroom values in the range of 7dB <= PHR < 9dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL17,0)) M8005C70    --The UE Power Headroom values in the range of 9dB <= PHR < 11dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL18,0)) M8005C71    --The UE Power Headroom values in the range of 11dB <= PHR < 13dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL19,0)) M8005C72    --The UE Power Headroom values in the range of 13dB <= PHR < 15dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL20,0)) M8005C73    --The UE Power Headroom values in the range of 15dB <= PHR < 17dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL21,0)) M8005C74    --The UE Power Headroom values in the range of 17dB <= PHR < 19dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL22,0)) M8005C75    --The UE Power Headroom values in the range of 19dB <= PHR < 21dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL23,0)) M8005C76    --The UE Power Headroom values in the range of 21dB <= PHR < 23dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL24,0)) M8005C77    --The UE Power Headroom values in the range of 23dB <= PHR < 25dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL25,0)) M8005C78    --The UE Power Headroom values in the range of 25dB <= PHR < 27dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL26,0)) M8005C79    --The UE Power Headroom values in the range of 27dB <= PHR < 29dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL27,0)) M8005C80    --The UE Power Headroom values in the range of 29dB <= PHR < 31dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL28,0)) M8005C81    --The UE Power Headroom values in the range of 31dB <= PHR < 33dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL29,0)) M8005C82    --The UE Power Headroom values in the range of 33dB <= PHR < 35dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL30,0)) M8005C83    --The UE Power Headroom values in the range of 35dB <= PHR < 37dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL31,0)) M8005C84    --The UE Power Headroom values in the range of 37dB <= PHR < 39dB. Used for the UE Power Headroom PUSCH histogram.
      ,sum(nvl(UE_PWR_HEADROOM_PUSCH_LEVEL32,0)) M8005C85    --The UE Power Headroom values in the range of 39 dB <= PHR. Used for the UE Power Headroom PUSCH histogram.
      ,min(nvl(UE_PWR_HEADROOM_PUSCH_MIN,0)) M8005C87    --The UE Power Headroom for the PUSCH minimum value for the reporting period. To get actual dB value calculate: "counter value - 23" according to 3GPP 36.133 chapter 9.1.8.4.
      ,max(nvl(UE_PWR_HEADROOM_PUSCH_MAX,0)) M8005C88    --The UE Power Headroom for the PUSCH maximum value for the reporting period. To get actual dB value calculate: "counter value - 23" according to 3GPP 36.133 chapter 9.1.8.4.
      ,avg(nvl(UE_PWR_HEADROOM_PUSCH_AVG,0)) M8005C89    --The UE Power Headroom for the PUSCH mean value for the reporting period. To get actual dB value calculate: "counter value - 23" according to 3GPP 36.133 chapter 9.1.8.4.
,case when  avg(nvl(RSSI_PUSCH_AVG,0)) - avg(nvl(SINR_PUSCH_AVG,0)) > -105  and avg(nvl(RSSI_PUSCH_AVG,0)) - avg(nvl(SINR_PUSCH_AVG,0)) <> 0
      then 1
      else 0
 end interference105
,case when  avg(nvl(RSSI_PUSCH_AVG,0)) - avg(nvl(SINR_PUSCH_AVG,0)) > -110 and avg(nvl(RSSI_PUSCH_AVG,0)) - avg(nvl(SINR_PUSCH_AVG,0)) <> 0
      then 1
      else 0
 end interference110

FROM NOKLTE_PV_LPQUL_lncel_day PMRAW
        where

         period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
         
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8005
,


(
      select
             to_char(period_start_time,'yyyymmdd') sdatetime
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,sum(nvl(EPS_BEARER_SETUP_ATTEMPTS,0)) M8006C0 --The number of EPS bearer setup attempts. Each bearer of the "E-RAB to Be Setup List" IE is counted.
,sum(nvl(EPS_BEARER_SETUP_COMPLETIONS,0)) M8006C1 --The number of EPS bearer setup completions. Each bearer of the "E-RAB Setup List" IE is counted.
,sum(nvl(ENB_EPS_BEAR_REL_REQ_N_QCI1,0)) M8006C125 ----
,sum(nvl(ENB_EPS_BEARER_REL_REQ_OTH,0)) M8006C13 ----
,sum(nvl(ENB_EPS_BEARER_REL_REQ_TNL,0)) M8006C14 --This measurement provides the number of E-RABs released due to a failed Handover Completion phase at the target cell.
,sum(nvl(ENB_EPS_BEAR_REL_REQ_O_QCI1,0)) M8006C143 ----
,sum(nvl(EPS_BEARER_STP_COM_INI_QCI_2,0)) M8006C168 ----
,sum(nvl(EPS_BEARER_STP_COM_INI_QCI_3,0)) M8006C169 ----
,sum(nvl(EPS_BEARER_STP_COM_INI_QCI_4,0)) M8006C170 ----
,sum(nvl(ERAB_REL_ENB_ACT_QCI1,0)) M8006C176 --This measurement provides the number of released active E-RABs (that is when there was user data in the queue at the time of release) with QCI1 characteristics. The release is initiated by the eNB due to radio connectivity problems.
,sum(nvl(ERAB_REL_ENB_ACT_QCI2,0)) M8006C177 --This measurement provides the number of released active E-RABs (that is when there was user data in the queue at the time of release) with QCI2 characteristics. The release is initiated by the eNB due to radio connectivity problems.
,sum(nvl(ERAB_REL_ENB_ACT_QCI3,0)) M8006C178 --This measurement provides the number of released active E-RABs (that is when there was user data in the queue at the time of release) with QCI3 characteristics. The release is initiated by the eNB due to radio connectivity problems.
,sum(nvl(ERAB_REL_ENB_ACT_QCI4,0)) M8006C179 --This measurement provides the number of released active E-RABs (that is when there was user data in the queue at the time of release) with QCI4 characteristics. The release is initiated by the eNB due to radio connectivity problems.
,sum(nvl(ERAB_REL_ENB_ACT_NON_GBR,0)) M8006C180 --This measurement provides the number of released active E-RABs (that is when there was user data in the queue at the time of release) with non-GBR characteristics (QCI5...9). The release is initiated by the eNB due to radio connectivity problems.
,sum(nvl(ERAB_INI_SETUP_ATT_QCI1,0)) M8006C188 --This measurement provides the number of setup attempts for initial E-RABs of QCI1.
,sum(nvl(ERAB_INI_SETUP_ATT_QCI2,0)) M8006C189 --This measurement provides the number of setup attempts for initial E-RABs of QCI2.
,sum(nvl(ERAB_ADD_SETUP_ATT_QCI1,0)) M8006C197 --This measurement provides the number of setup attempts for additional E-RABs of QCI1.
,sum(nvl(ERAB_ADD_SETUP_ATT_QCI2,0)) M8006C198 --This measurement provides the number of setup attempts for additional E-RABs of QCI2.
,sum(nvl(ERAB_INI_SETUP_SUCC_QCI1,0)) M8006C206 --This measurement provides the number of successfully established initial E-RABs of QCI1.
,sum(nvl(ERAB_INI_SETUP_SUCC_QCI2,0)) M8006C207 --This measurement provides the number of successfully established initial E-RABs of QCI2.
,sum(nvl(ERAB_ADD_SETUP_SUCC_QCI1,0)) M8006C215 --This measurement provides the number of successfully established additional E-RABs of QCI1.
,sum(nvl(ERAB_ADD_SETUP_SUCC_QCI2,0)) M8006C216 --This measurement provides the number of successfully established additional E-RABs of QCI2.
,max(SIMUL_ERAB_QCI1_MAX) M8006C224 --This measurement provides the maximum of sampled values for measuring the number of simultaneously established E-RABs with QCI1 characteristics.
,max(SIMUL_ERAB_QCI2_MAX) M8006C225 --This measurement provides the maximum of sampled values for measuring the number of simultaneously established E-RABs with QCI2 characteristics.
,sum(nvl(ERAB_REL_ENB_TNL_TRU,0)) M8006C257 --This measurement provides the number of E-RABs released if the associated transport resources are not available anymore. The counter is maintained regardless of the released bearers QCI.
,sum(nvl(EPS_BEARER_SETUP_FAIL_TRPORT,0)) M8006C3 ----
,sum(nvl(EPS_BEARER_STP_COM_INI_QCI1,0)) M8006C35 ----
,sum(nvl(EPS_BEAR_STP_COM_INI_NON_GBR,0)) M8006C36 ----
,sum(nvl(EPS_BEARER_SETUP_FAIL_RESOUR,0)) M8006C4 ----
,sum(nvl(SUM_SIMUL_ERAB_QCI_1,0)) M8006C45 --This measurement provides the sum of sampled values for measuring the number of simultaneous E-RABs with QCI 1 characteristics. This counter, divided by the denominator DENOM_SUM_SIMUL_ERAB, provides the average number of simultaneous QCI 1 E-RABs per cell.
,sum(nvl(SUM_SIMUL_ERAB_QCI_2,0)) M8006C46 --This measurement provides the sum of sampled values for measuring the number of simultaneous E-RABs with QCI 2 characteristics. This counter, divided by the denominator DENOM_SUM_SIMUL_ERAB, provides the average number of simultaneous QCI 2 E-RABs per cell.
,sum(nvl(EPS_BEARER_SETUP_FAIL_OTH,0)) M8006C5 ----
,sum(nvl(DENOM_SUM_SIMUL_ERAB,0)) M8006C54 --This measurement provides the number of samples, which were taken to determine the number of simultaneous E-RABs per QCI.
,sum(nvl(ERAB_REL_ENB_TNL_TRU_QCI1,0)) M8006C269 
,sum(nvl(ERAB_REL_HO_PART_QCI1,0)) M8006C273
,sum(nvl(ERAB_IN_SESSION_TIME_QCI1,0)) M8006C181

,sum(nvl(ERAB_INI_SETUP_FAIL_RNL_RRNA,0)) M8006C244
,sum(nvl(ERAB_INI_SETUP_FAIL_TNL_TRU,0)) M8006C245
,sum(nvl(ERAB_ADD_SETUP_FAIL_RNL_RRNA,0)) M8006C248
,sum(nvl(ERAB_ADD_SETUP_FAIL_TNL_TRU,0)) M8006C249
,sum(nvl(ERAB_ADD_SETUP_FAIL_UP,0)) M8006C252
,sum(nvl(ERAB_ADD_SETUP_FAIL_RNL_MOB,0)) M8006C253
,sum(nvl(ERAB_REL_ENB_TNL_TRU_QCI2,0)) M8006C287
,sum(nvl(ERAB_REL_HO_PART_QCI2,0)) M8006C291


        from
             NOKLTE_PS_LEPSB_lncel_day PMRAW
        where
        
         period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
            ---- to_char(period_start_time,'yyyymmdd') >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8006
,
(SELECT
substr(sdate,1,8) sdate
,LNCEL_ID
,substr(sdate,1,8)||LNCEL_ID cel_key_id
,round(sum(话务量hour),2) "QCI1话务量Erl_亿阳"
FROM

(
SELECT 
substr(comm.sdate,1,10) sdate
,M8006.LNCEL_ID LNCEL_ID

,sum(M8006C45) M8006C45
--,M8006C54
,avg(话务量raw) 话务量hour

 
FROM

(
      select
             to_char(period_start_time,'yyyymmddHH24MI') sdatetime
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmddHH24MI')||LNCEL_ID cel_key_id

,sum(nvl(SUM_SIMUL_ERAB_QCI_1,0)) M8006C45 --This measurement provides the sum of sampled values for measuring the number of simultaneous E-RABs with QCI 1 characteristics. This counter, divided by the denominator DENOM_SUM_SIMUL_ERAB, provides the average number of simultaneous QCI 1 E-RABs per cell.
,sum(nvl(DENOM_SUM_SIMUL_ERAB,0)) M8006C54 --This measurement provides the number of samples, which were taken to determine the number of simultaneous E-RABs per QCI.
,decode(sum(nvl(DENOM_SUM_SIMUL_ERAB,0)),0,0,sum(nvl(SUM_SIMUL_ERAB_QCI_1,0))/sum(nvl(DENOM_SUM_SIMUL_ERAB,0))) 话务量raw
        from
             NOKLTE_PS_LEPSB_MNC1_raw PMRAW
        where
        
         period_start_time between to_date(&1||'0000','yyyymmddHH24MI') and to_date(&2||'2359','yyyymmddHH24MI')
            ---- to_char(period_start_time,'yyyymmddHH24MI') >= to_char(SYSDATE-1,'yyyymmddHH24MI')
            -- and to_char(period_start_time,'yyyymmddHH24MI') <= to_char(SYSDATE-1,'yyyymmddHH24MI')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmddHH24MI'),LNCEL_ID,to_char(period_start_time,'yyyymmddHH24MI')||LNCEL_ID
)M8006
,
(
select
to_char(period_start_time,'yyyymmddHH24MI') sdate
,LNCEL_ID
,to_char(period_start_time,'yyyymmddHH24MI')||LNCEL_ID cel_key_id
,lnbts.co_object_instance enb_id
,lncel.co_object_instance cell_id
,lnbts.co_object_instance || '_' || lncel.co_object_instance enb_cell     
--,lnbts.co_main_host bts_ip
,lnbts.co_sys_version bts_version
,Trim(lnbts.co_name) bts_name
,Trim(lncel.co_name) cel_name  

from
(
Select Distinct * from 
(
Select lnbts_id,lncel_id,period_start_time from NOKLTE_PS_LRDB_MNC1_raw m8007
Union
Select lnbts_id,lncel_id,period_start_time from NOKLTE_PS_LCELAV_MNC1_raw m8020
)
) comm,
ctp_common_objects lnbts,
ctp_common_objects lncel
where 
comm.period_start_time between to_date(&1||'0000','yyyymmddHH24MI') and to_date(&2||'2359','yyyymmddHH24MI')

and comm.lnbts_id=lnbts.co_gid
AND comm.LNCEL_ID=lncel.co_gid
AND lnbts.CO_STATE<>9 
AND lncel.CO_STATE<>9
              
)comm
WHERE      comm.cel_key_id=m8006.cel_key_id(+)
group by 
substr(comm.sdate,1,10),enb_id,enb_cell,M8006.LNCEL_ID
)


GROUP BY 
substr(sdate,1,8)
,LNCEL_ID

)M8006raw
,(
select
             to_char(period_start_time,'yyyymmdd') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,AVG(DECODE(ERAB_SETUP_TIME_MEAN,0,NULL, ERAB_SETUP_TIME_MEAN)) M8007C14 --This measurement provides the mean E-RAB setup time (3GPP TS 32.425, 36.413, 23.203).

        from
             NOKLTE_PS_LRDB_lncel_day PMRAW
        where
         period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
        --- to_char(period_start_time,'yyyymmdd') >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8007
,(
select
             to_char(period_start_time,'yyyymmdd') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,AVG(DECODE(RRC_CON_STP_TIM_MEAN,0,NULL, RRC_CON_STP_TIM_MEAN)) M8008C17 --This measurement provides the mean RRC connection setup time (3GPP TS 32.425, 36.331).
,sum(nvl(RRC_CON_RE_ESTAB_ATT,0)) M8008C4 --The number of attempted RRC Connection Re-establishment procedures.
        from
             NOKLTE_PS_LRRC_lncel_day PMRAW
        where
         period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
        --- to_char(period_start_time,'yyyymmdd') >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8008
,(
select
             to_char(period_start_time,'yyyymmdd') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,sum(nvl(ATT_INTRA_ENB_HO,0)) M8009C6 --The number of Intra-eNB Handover attempts.
,sum(nvl(SUCC_INTRA_ENB_HO,0)) M8009C7 --The number of successful Intra-eNB Handover completions.
,sum(nvl(INTRA_ENB_HO_QCI1_ATT,0)) M8009C15
,sum(nvl(INTRA_ENB_HO_QCI1_SUCC,0)) M8009C16


        from
             NOKLTE_PS_LIANBHO_lncel_day PMRAW
        where
         period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
            --- to_char(period_start_time,'yyyymmdd') >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8009,

(
select
             to_char(period_start_time,'yyyymmdd') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
            ,sum(nvl(MIMO_OL_DIV,0)) M8010C55
            ,sum(nvl(MIMO_OL_SM,0)) M8010C56
            ,sum(nvl(MIMO_CL_1CW,0)) M8010C57
            ,sum(nvl(MIMO_CL_2CW,0)) M8010C58
            ,sum(nvl(MIMO_SWITCH_OL,0)) M8010C59
            ,sum(nvl(MIMO_SWITCH_CL,0)) M8010C60
            ,sum(nvl(PDCCH_ALLOC_PDSCH_HARQ,0)) M8010C61
            ,sum(nvl(PDCCH_ALLOC_PDSCH_HARQ_NO_RES,0)) M8010C62
            ,sum(nvl(TM8_DUAL_BF_MODE,0)) M8010C63
            ,sum(nvl(TM8_SINGLE_BF_MODE,0)) M8010C64
            ,sum(nvl(TM8_TXDIV_MODE,0)) M8010C65
            ,sum(nvl(TM8_DUAL_USER_SINGLE_BF_MODE,0)) M8010C66
            ,avg(nvl(PDCCH_POWER_AVG,0)) M8010C67
            ,sum(nvl(TM7_BF_MODE,0)) M8010C68
            ,sum(nvl(TM7_TXDIV_MODE,0)) M8010C69
			

        from
             NOKLTE_PS_LPQDL_lncel_day PMRAW
        where
         period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
            --- to_char(period_start_time,'yyyymmdd') >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8010,


(
select
             to_char(period_start_time,'yyyymmdd') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,avg(DL_PRB_UTIL_TTI_MEAN) M8011C37 --The mean value of the DL Physical Resource Block (PRB) use per TTI. The use is defined by the rate of used PRB per TTI. The reported value is 10 times higher than the actual value (for example 5.4 is stored as 54)."
,sum(nvl(CCE_AVAIL_ACT_TTI,0)) M8011C38 --Total number of CCEs available for active TTIs when at least one PDCCH is going to be scheduled.
,sum(nvl(AGG1_USED_PDCCH,0)) M8011C39 --Total number of AGG1 used for PDCCH scheduling over the measurement period.
,sum(nvl(AGG2_USED_PDCCH,0)) M8011C40 --Total number of AGG2 used for PDCCH scheduling over the measurement period.
,sum(nvl(AGG4_USED_PDCCH,0)) M8011C41 --Total number of AGG4 used for PDCCH scheduling over the measurement period.
,sum(nvl(AGG8_USED_PDCCH,0)) M8011C42 --Total number of AGG8 used for PDCCH scheduling over the measurement period.
,sum(nvl(PRB_USED_PUSCH,0)) M8011C50 --Total number of PRBs used for UL transmissions on PUSCH over the measurement period is updated to this counter. A PRB covers the pair of resource blocks of two consecutive slots in a subframe.
,avg(nvl(PRB_USED_PUSCH,0)) M8011C50avg
,sum(nvl(CA_SCELL_CONFIG_ATT,0)) M8011C67
,sum(nvl(CA_SCELL_CONFIG_SUCC,0)) M8011C68
--prb利用率 2018年3月21日
,avg(nvl(UL_PRB_USAGE_SAEB_QOS_1,0)) M8011C140
,avg(nvl(UL_PRB_USAGE_SAEB_QOS_2,0)) M8011C141
,avg(nvl(UL_PRB_USAGE_SAEB_QOS_3,0)) M8011C142
,avg(nvl(UL_PRB_USAGE_SAEB_QOS_4,0)) M8011C143
,avg(nvl(UL_PRB_USAGE_SAEB_QOS_5,0)) M8011C144
,avg(nvl(UL_PRB_USAGE_SAEB_QOS_6,0)) M8011C145
,avg(nvl(UL_PRB_USAGE_SAEB_QOS_7,0)) M8011C146
,avg(nvl(UL_PRB_USAGE_SAEB_QOS_8,0)) M8011C147
,avg(nvl(UL_PRB_USAGE_SAEB_QOS_9,0)) M8011C148
,avg(nvl(UL_PRB_USAGE_SAEB_QOS_10_255,0)) M8011C149
,avg(nvl(UL_PRB_USAGE_SRB,0)) M8011C150
,avg(nvl(DL_PRB_USAGE_SAEB_QOS_1,0)) M8011C151
,avg(nvl(DL_PRB_USAGE_SAEB_QOS_2,0)) M8011C152
,avg(nvl(DL_PRB_USAGE_SAEB_QOS_3,0)) M8011C153
,avg(nvl(DL_PRB_USAGE_SAEB_QOS_4,0)) M8011C154
,avg(nvl(DL_PRB_USAGE_SAEB_QOS_5,0)) M8011C155
,avg(nvl(DL_PRB_USAGE_SAEB_QOS_6,0)) M8011C156
,avg(nvl(DL_PRB_USAGE_SAEB_QOS_7,0)) M8011C157
,avg(nvl(DL_PRB_USAGE_SAEB_QOS_8,0)) M8011C158
,avg(nvl(DL_PRB_USAGE_SAEB_QOS_9,0)) M8011C159
,avg(nvl(DL_PRB_USAGE_SAEB_QOS_10_255,0)) M8011C160
,avg(nvl(DL_PRB_USAGE_SRB,0)) M8011C161


        from 
             NOKLTE_PS_LCELLR_lncel_day PMRAW
        where
        
         period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
            --- to_char(period_start_time,'yyyymmdd')  >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID


) M8011 ,
(
select
             to_char(period_start_time,'yyyymmdd') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
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

        from 
             NOKLTE_PS_LCELLT_lncel_day PMRAW
        where
        
         period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
            --- to_char(period_start_time,'yyyymmdd')  >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID


) M8012
,(
select
             to_char(period_start_time,'yyyymmdd') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,sum(nvl(ENB_INIT_TO_IDLE_OTHER,0)) M8013C16 --The number of eNB-initiated transitions from the ECM-CONNECTED to ECM-IDLE state for all TNL causes indicating an abnormal release. The UE-associated logical S1-connection is released.
,sum(nvl(SIGN_CONN_ESTAB_ATT_MO_S,0)) M8013C17 --The number of Signaling Connection Establishment attempts for mobile originated signaling. From UE's point of view, the transition from ECM-IDLE to ECM-CONNECTED has started.
,sum(nvl(SIGN_CONN_ESTAB_ATT_MT,0)) M8013C18 --The number of Signaling Connection Establishment attempts for mobile terminated connections. From UE's point of view, the transition from ECM-IDLE to ECM-CONNECTED is started.
,sum(nvl(SIGN_CONN_ESTAB_ATT_MO_D,0)) M8013C19 --The number of Signaling Connection Establishment attempts for mobile originated data connections. From UE's point of view, the transition from ECM-IDLE to ECM-CONNECTED is started.
,sum(nvl(SIGN_CONN_ESTAB_ATT_OTHERS,0)) M8013C20 ----
,sum(nvl(SIGN_CONN_ESTAB_ATT_EMG,0)) M8013C21 --Number of Signaling Connection Establishment attempts for emergency calls.
,sum(nvl(SIGN_CONN_ESTAB_ATT_HIPRIO,0)) M8013C31 --The number of Signaling Connection Establishment attempts for highPriorityAccess connections. From UE's point of view, the transition from ECM-IDLE to ECM-CONNECTED is started.
,sum(nvl(SIGN_CONN_ESTAB_ATT_DEL_TOL,0)) M8013C34 --The number of Signaling Connection Establishment attempts for delayTolerantAccess connections. From UE's point of view, the transition from ECM-IDLE to ECM-CONNECTED is started."
,sum(nvl(UE_CTX_SETUP_SUCC,0)) M8013C47 --This measurement provides the number of successfully established UE Contexts. It includes also the UE Contexts that are subject to CS Fallback.
,sum(nvl(SIGN_CONN_ESTAB_COMP,0)) M8013C5 --This measurement provides the number of successful RRC Connection Setups.
,sum(nvl(UE_CTX_REL_ENB_NO_RADIO_RES,0)) M8013C59 --This counter provides the number of released UE contexts initiated by the eNB due to missing radio resources.
,sum(nvl(UE_CTX_REL_ENB_RNL_UNSPEC,0)) M8013C60 --This counter provides the number of released UE contexts initiated by the eNB with the release cause "RNL Unspecified". It is used e.g. in case of AS Security problems or in case of abnormal handover conditions.
,sum(nvl(SIGN_CONN_ESTAB_FAIL_OVLCP,0)) M8013C65 --This measurement provides the total number of Signaling Connection Establishment Requests rejected due to Control Plane overload.
,sum(nvl(SIGN_CONN_ESTAB_FAIL_OVLUP,0)) M8013C66 --This measurement provides the total number of Signaling Connection Establishment Requests rejected due to User Plane overload.
,sum(nvl(SIGN_CONN_ESTAB_FAIL_PUCCH,0)) M8013C67 --This measurement provides the total number of Signaling Connection Establishment Requests rejected due to lack of PUCCH resources.
,sum(nvl(SIGN_CONN_ESTAB_FAIL_MAXRRC,0)) M8013C68 --This measurement provides the total number of Signaling Connection Establishment Requests rejected in case that the maximum number of RRC Connected UEs is reached.
,sum(nvl(SIGN_CONN_ESTAB_FAIL_OVLMME,0)) M8013C69 --This measurement provides the total number of Signaling Connection Establishment Requests rejected due to overload indicated by the MME.
,sum(nvl(SIGN_CONN_ESTAB_FAIL_RRMRAC,0)) M8013C8 ----


----,lnbts.co_object_instance enb_id
----,lncel.co_object_instance cell_id
--,lnbts.co_main_host bts_ip
----,lnbts.co_sys_version bts_version
----,Trim(lnbts.co_name) bts_name
----,Trim(lncel.co_name) cel_name
        from
             NOKLTE_PS_LUEST_lncel_day PMRAW--,ctp_common_objects lnbts,ctp_common_objects lncel
        where
             period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
             
           ---  to_char(period_start_time,'yyyymmdd') >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             ----AND PMRAW.LNCEL_ID=lncel.co_gid AND lnbts.co_oc_id=2860 AND lnbts.CO_STATE<>9 AND lncel.co_oc_id=2881 AND lncel.CO_STATE<>9
            ----and PMRAW.lnbts_id=lnbts.co_gid
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),MRBTS_ID,LNBTS_ID,LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
             ----,lnbts.co_object_instance,lncel.co_object_instance--,lnbts.co_main_host
             ----,lnbts.co_sys_version,Trim(lnbts.co_name),Trim(lncel.co_name)
)M8013,(
select
             to_char(period_start_time,'yyyymmdd') sdate
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,sum(nvl(INTER_ENB_HO_PREP,0)) M8014C0 --The number of Inter-eNB X2-based Handover preparations. The Mobility management (MM) receives a list with target cells from the RRM and decides to start an Inter-eNB X2-based Handover.
,sum(nvl(INTER_ENB_S1_HO_PREP,0)) M8014C14 --The number of Inter eNB S1-based Handover preparations
,sum(nvl(INTER_ENB_S1_HO_ATT,0)) M8014C18 --The number of Inter eNB S1-based Handover attempts
,sum(nvl(INTER_ENB_S1_HO_SUCC,0)) M8014C19 --The number of successful Inter eNB S1-based Handover completions
,sum(nvl(ATT_INTER_ENB_HO,0)) M8014C6 --The number of Inter-eNB X2-based Handover attempts.
,sum(nvl(SUCC_INTER_ENB_HO,0)) M8014C7 --The number of successful Inter-eNB X2-based Handover completions.
,sum(nvl(INTER_ENB_S1_HO_QCI1_ATT,0)) M8014C23
,sum(nvl(INTER_ENB_S1_HO_QCI1_SUCC,0)) M8014C24
,sum(nvl(INTER_ENB_X2_HO_QCI1_ATT,0)) M8014C26
,sum(nvl(INTER_ENB_X2_HO_QCI1_SUCC,0)) M8014C27


        from
             NOKLTE_PS_LIENBHO_lncel_day PMRAW
        where
        
        period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
            -- to_char(period_start_time,'yyyymmdd')  >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8014,
(
select
             to_char(period_start_time,'yyyymmdd') sdatetime
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,sum(nvl(INTRA_HO_SUCC_NB,0)) M8015C2 --The number of successful Intra-eNB Handover completions per neighbour cell relationship.
,sum(nvl(INTER_HO_SUCC_NB,0)) M8015C9 --The number of successful Inter eNB Handover completions per neighbour cell relationship
,SUM(NVL(INTER_HO_PREP_FAIL_OTH_NB,0))  M8015C5   --The number of failed Inter eNB Handover preparations per cause per neighbour cell relationship
,SUM(NVL(INTER_HO_PREP_FAIL_TIME_NB,0))  M8015C6  --The number of failed Inter eNB Handover preparations per neighbour cell relationship due to the expiration of the respective guarding timer.
,SUM(NVL(INTER_HO_PREP_FAIL_AC_NB,0))  M8015C7 --The number of failed Inter eNB Handover preparations per neighbour cell relationship due to failures in the HO preparation on the target side
,SUM(NVL(INTER_HO_ATT_NB,0))  M8015C8  --The number of Inter eNB Handover attempts per neighbour cell relationship

       from
             NOKLTE_PS_LNCELHO_lncel_day PMRAW
        where
        period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
          ---   to_char(period_start_time,'yyyymmdd')  >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8015,(
select
             to_char(period_start_time,'yyyymmdd') sdatetime
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,sum(nvl(ISYS_HO_FAIL,0)) M8016C25 --Number of failed Inter System Handover attempts.
,sum(nvl(ISYS_HO_GERAN_SRVCC_ATT,0)) M8016C33 --This measurement provides the number of Inter System Handover attempts to GERAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
,sum(nvl(ISYS_HO_GERAN_SRVCC_SUCC,0)) M8016C34 --This measurement provides the number of successful Inter System Handover completions to GERAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
,sum(nvl(ISYS_HO_GERAN_SRVCC_FAIL,0)) M8016C35 --This measurement provides the number of failed Inter System Handover attempts to GERAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
,sum(nvl(ISYS_HO_GERAN_SRVCC_PREP,0)) M8016C54
        from
             NOKLTE_PS_LISHO_lncel_day PMRAW
        where
        period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
            --- to_char(period_start_time,'yyyymmdd') >= to_char(SYSDATE-1,'yyyymmdd')
            -- and to_char(period_start_time,'yyyymmdd') <= to_char(SYSDATE-1,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8016
,(
select
             to_char(period_start_time,'yyyymmdd') sdatetime
            -- ,MRBTS_ID
             ,LNBTS_ID
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,sum(nvl(CHNG_TO_CELL_AVAIL,0)) M8020C0 --Number of cell state changes to cell is available
,sum(nvl(CHNG_TO_CELL_PLAN_UNAVAIL,0)) M8020C1 --Number of cell state changes to cell is planned unavailable
,sum(nvl(CHNG_TO_CELL_UNPLAN_UNAVAIL,0)) M8020C2 --Number of cell state changes to cell is unplanned unavailable
,sum(nvl(SAMPLES_CELL_AVAIL,0)) M8020C3 --The number of samples when the cell is available
,sum(nvl(SAMPLES_CELL_PLAN_UNAVAIL,0)) M8020C4 --The number of samples when the cell is planned unavailable
,sum(nvl(SAMPLES_CELL_UNPLAN_UNAVAIL,0)) M8020C5 --The number of samples when the cell is unplanned unavailable
,sum(nvl(DENOM_CELL_AVAIL,0)) M8020C6 --The number of samples when cell availability is checked. This counter is used as a denominator for the cell availability calculation
        from
            NOKLTE_PS_LCELAV_lncel_day  PMRAW  
        where
             period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),MRBTS_ID,LNBTS_ID,LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8020
,(
select
             to_char(period_start_time,'yyyymmdd') sdatetime
            -- ,MRBTS_ID
             ,LNBTS_ID
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,sum(nvl(PDCP_SDU_LOSS_UL_QCI_1_FNA,0)) M8026C255 --Number of missing UL PDCP packets of a data bearer with QCI = 1 that are not delivered to higher layers. Missing packets are identified by the missing PDCP sequence number.Only user-plane traffic (DTCH) is considered."
,sum(nvl(PDCP_SDU_LOSS_UL_QCI_2_FNA,0)) M8026C256 --Number of missing UL PDCP packets of a data bearer with QCI = 2 that are not delivered to higher layers. Missing packets are identified by the missing PDCP sequence number.Only user-plane traffic (DTCH) is considered."
,sum(nvl(PDCP_SDU_LOSS_DL_QCI_1_FNA,0)) M8026C260 --Number of DL PDCP SDUs of a data radio bearer with QCI = 1 that could not be successfully transmitted.Only user-plane traffic (DTCH) is considered."
,sum(nvl(PDCP_SDU_LOSS_DL_QCI_2_FNA,0)) M8026C261 --Number of DL PDCP SDUs of a data radio bearer with QCI = 2 that could not be successfully transmitted. Only user-plane traffic (DTCH) is considered."
,avg(HARQ_DURATION_QCI1_AVG) M8026C30 --The counter provides the average time for HARQ transmissions of QCI 1 data during one measurement period.
,sum(nvl(PDCP_SDU_LOSS_UL_FNA,0)) M8026C254
,sum(nvl(PDCP_SDU_LOSS_DL_FNA,0)) M8026C259
        from
            NOKLTE_PS_LQOS_lncel_day  PMRAW  
        where
             period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),MRBTS_ID,LNBTS_ID,LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8026
,(
select
             to_char(period_start_time,'yyyymmdd') sdatetime
            -- ,MRBTS_ID
             ,LNBTS_ID
             ,LNCEL_ID
             ,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
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
,case when max(nvl(CELL_LOAD_ACTIVE_UE_MAX,0)) >= 300 and max(nvl(CELL_LOAD_ACTIVE_UE_MAX,0)) is not null then 1 else 0 end 是否超300用户M8051

            from
            NOKLTE_PS_LUEQ_lncel_day  PMRAW  
        where
             period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
             --AND PERIOD_DURATION=15
        group by
             to_char(period_start_time,'yyyymmdd'),MRBTS_ID,LNBTS_ID,LNCEL_ID,to_char(period_start_time,'yyyymmdd')||LNCEL_ID
)M8051
,
(
select
to_char(period_start_time,'yyyymmdd') sdate
,LNCEL_ID
,to_char(period_start_time,'yyyymmdd')||LNCEL_ID cel_key_id
,lnbts.co_object_instance enb_id
,lncel.co_object_instance cell_id
--,lnbts.co_main_host bts_ip
,lnbts.co_sys_version bts_version
,Trim(lnbts.co_name) bts_name
,Trim(lncel.co_name) cel_name  
from
(
Select Distinct * from 
(
Select lnbts_id,lncel_id,period_start_time from NOKLTE_PS_LRDB_lncel_day m8007
Union
Select lnbts_id,lncel_id,period_start_time from NOKLTE_PS_LCELAV_lncel_day m8020
)
) comm,
ctp_common_objects lnbts,
ctp_common_objects lncel
where 
comm.period_start_time between to_date(&1,'yyyymmdd') and to_date(&2,'yyyymmdd')
and comm.lnbts_id=lnbts.co_gid
AND comm.LNCEL_ID=lncel.co_gid
AND lnbts.CO_STATE<>9 
AND lncel.CO_STATE<>9
) comm
WHERE      comm.cel_key_id=m8001.cel_key_id(+)
       AND comm.cel_key_id=m8005.cel_key_id(+)
       AND comm.cel_key_id=m8006.cel_key_id(+)
       AND comm.cel_key_id=m8006raw.cel_key_id(+)
       AND comm.cel_key_id=m8008.cel_key_id(+)
       AND comm.cel_key_id=m8009.cel_key_id(+)
       AND comm.cel_key_id=m8010.cel_key_id(+)
       AND comm.cel_key_id=m8011.cel_key_id(+)
       AND comm.cel_key_id=m8012.cel_key_id(+)
       AND comm.cel_key_id=m8013.cel_key_id(+)
       AND comm.cel_key_id=m8014.cel_key_id(+)
       AND comm.cel_key_id=m8015.cel_key_id(+)
       AND comm.cel_key_id=m8016.cel_key_id(+)
       AND comm.cel_key_id=m8020.cel_key_id(+)
       AND comm.cel_key_id=m8007.cel_key_id(+)
       AND comm.cel_key_id=m8026.cel_key_id(+)
       AND comm.cel_key_id=m8051.cel_key_id(+)

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
substr(sdate,1,8),
city,enb_cell,enb_id,bts_version,cel_name
ORDER BY city,substr(sdate,1,8)--,enb_cell,enb_id
