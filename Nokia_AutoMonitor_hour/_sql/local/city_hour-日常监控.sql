select
SDATE
,CITY
,round(100.00*sum(RRC连接建立成功次数)/sum(RRC连接建立请求次数),2) RRC连接建立成功率
,round(100.00*sum(ERAB建立成功数REAL)/sum(ERAB建立请求数),2) ERAB建立成功率REAL
,round(100.00*sum(ERAB建立成功数)/sum(ERAB建立请求数),2) ERAB建立成功率
,round(100.00*sum(RRC连接建立成功次数)/sum(RRC连接建立请求次数)*sum(ERAB建立成功数)/sum(ERAB建立请求数),2) 无线接通率
,round(100.00*sum(无线掉线率分子)/sum(无线掉线率分母),2) 无线掉线率
,round(100.00*sum(ERAB掉线次数)/sum(ERAB掉线率分母),2) ERAB掉线率
,round(100.00*sum(切换成功次数)/sum(切换请求次数ZB),2) 切换成功率ZB
,round(100.00*sum(切换成功次数)/sum(切换请求次数QQ),2) 切换成功率QQ
,round(100.00*sum(可用率分子)/sum(可用率分母),2) 小区可用率
,round(100.00*sum(QCI1_ERAB建立成功次数)/sum(QCI1_ERAB建立请求次数),2) ERAB建立成功率QCI1
,round(100.00*sum(QCI1_ERAB建立成功次数)/sum(QCI1_ERAB建立请求次数)*sum(RRC连接建立成功次数)/sum(RRC连接建立请求次数),2) 无线接通率QCI1
,round(100.00*sum(QCI1上行丢包率分子)/sum(QCI1上行丢包率分母),2) QCI1上行丢包率
,round(100.00*sum(QCI1下行丢包率分子)/sum(QCI1下行丢包率分母),2) QCI1下行丢包率
,round(100.00*(sum(ESRVCC请求次数)-sum(ESRVCC切换失败次数))/sum(ESRVCC请求次数),2) SRVCC切换出成功率
from "city_hour-日常监控"
where CITY in ("湛江","阳江","茂名","梅州","潮州")
group by SDATE,CITY
order by CITY,SDATE