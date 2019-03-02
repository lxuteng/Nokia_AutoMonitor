select
SDATE,
CITY
,round(sum(用户面PDCP上行数据量KB+用户面PDCP下行数据量KB)*1024/1000/1000/1000/1000,2) 数据业务量TB
,round(sum(QCI1话务量Erl_all)/10000,2) QCI1话务量_万Erl
,round(100.00*sum(RRC连接建立成功次数)/sum(RRC连接建立请求次数),2) RRC连接建立成功率
,round(100.00*sum(ERAB建立成功数REAL)/sum(ERAB建立请求数),2) ERAB建立成功率REAL
,round(100.00*sum(ERAB建立成功数)/sum(ERAB建立请求数),2) ERAB建立成功率
,round(100.00*sum(RRC连接建立成功次数)/sum(RRC连接建立请求次数)*sum(ERAB建立成功数)/sum(ERAB建立请求数),2) 无线接通率
,round(100.00*sum(无线掉线率分子)/sum(无线掉线率分母),2) 无线掉线率
,round(100.00*sum(ERAB掉线次数)/sum(ERAB掉线率分母),2) ERAB掉线率
,round(100.00*sum(切换成功次数)/sum(切换请求次数ZB),2) 切换成功率ZB
,round(100.00*sum(切换成功次数)/sum(切换请求次数QQ),2) 切换成功率QQ
,round(100.00*sum(小区可用率分子)/sum(小区可用率分母),2) 小区可用率
,round(100.00*sum(QCI1_ERAB建立成功次数)/sum(QCI1_ERAB建立请求次数),2) ERAB建立成功率QCI1
,round(100.00*sum(QCI1_ERAB建立成功次数)/sum(QCI1_ERAB建立请求次数)*sum(RRC连接建立成功次数)/sum(RRC连接建立请求次数),2) 无线接通率QCI1
,round(100.00*sum(QCI1掉线次数)/sum(QCI1掉线分母小区级),2) QCI1掉线率
,round(100.00*sum(QCI1上行丢包率分子)/sum(QCI1上行丢包率分母),2) QCI1上行丢包率
,round(100.00*sum(QCI1下行丢包率分子)/sum(QCI1下行丢包率分母),2) QCI1下行丢包率
,round(100.00*(sum(ESRVCC请求次数)-sum(ESRVCC切换失败次数))/sum(ESRVCC请求次数),2) SRVCC切换出成功率
,round(100.00*sum(VOLTE切换成功次数)/sum(VOLTE切换请求次数),2) VOLTE切换成功率
,sum(拥塞次数) 拥塞次数
,sum("干扰小区大于-105") "干扰小区大于-105"
,sum("干扰小区大于-110") "干扰小区大于-110"
,sum(激活用户数超300小区数) 激活用户数超300小区数
from "cell_hour_all"
where CITY in ("阳江","梅州","茂名","湛江","潮州")
and SDATE between &1 and &2
group by SDATE,
CITY
order by 
CITY,SDATE