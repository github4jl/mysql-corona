# load_corona.sh loads all corona data & run basic listings
# 2020/05/21 written
# 2020/06/20 add list_corona_info_ca_trend.sql 
# 2020/07/30 add load-corona_info_state.sql
# 2020/08/01 add list_corona_info_state_trend.sql
# 2020/10/04 add list_corona_info_sd_trend.sql
# 2020/10/08 add load_corona_qc.sql
# 2020/10/13 add list_state_gov.sql

tmpsql=load_corona.sh.sql
echo source load_corona_info.sql >  $tmpsql
echo source load_corona_info_ca.sql >> $tmpsql
echo source load_corona_info_state.sql >> $tmpsql
echo source list_corona_info.sql >>  $tmpsql
echo source list_corona_info_ca.sql >> $tmpsql
echo source list_corona_info_ca_trend.sql  >> $tmpsql
echo source list_corona_info_state_trend.sql  >> $tmpsql
echo source list_corona_info_sd_trend.sql  >> $tmpsql
echo source list_state_gov.sql >> $tmpsql
echo source load_corona_qc.sql  >> $tmpsql

echo exit >> $tmpsql

mysql --table -p < $tmpsql
rm $tmpsql
