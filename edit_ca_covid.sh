# edit_ca_covid.sh
# 2021/03/20 created
# 2021/05/17 chg csv files to unifom names: statewide_cases.csv to corona_info_ca.csv
#            covid19cases_test.csv to corona_info_ca_dl.csv

cadownload=$HOME/Downloads/corona_info_ca_dl.csv
tmpsrt=edit_ca_covid.srt
editout=$HOME/Downloads/corona_info_ca.csv

echo "$0 editing $cadownload into $editout"

echo "county,totalcountconfirmed,totalcountdeaths,newcountconfirmed,newcountdeaths,date" > $editout

# input 1=date,2=county,cases=9,deaths=10
cat $cadownload|sed "/^date/d"|sed "/^,/d"|sed "/,California,/d"|\
# sort by county/asc (col2), date/asc (col1)
sort -t',' -k2,2 -k1,1|\
# running subtotal by county, date
awk 'BEGIN {FS=","};\
{if (county == $2) {cases+=$9;deaths+=$10; print county","cases","deaths","$9","$10","$1}\
 else {county=$2;cases=0;deaths=0} }' >> $editout

echo "$0 edited"
wc -l $cadownload $editout

