# treemap_ca_trend.sh
# 2020/12/07 written
# 2021/03/11 invoke sql to get data
# 2021/03/14 use ~

mysql -p < treemap_ca_trend.sql

treehtm=treemap_ca_trend.html
treedt=$(date)
echo "<!-- $treehtm created $treedt --\>" > $treehtm
cat treemap_ca_trend.header >> $treehtm
cat ~/bin/mysql/treemap_ca_trend.csv|\
awk 'BEGIN {FS="\t"};{print ",[\""$1"\",\"CA\","$2","$3,"]"}' |\
sed '/\\N/d' >> $treehtm
cat treemap_ca_trend.trailer >> $treehtm
ls -l $treehtm


