# edit_ca_covid.sh
# 2021/03/20 created

newca=$HOME/Downloads/covid19cases_test.csv
tmpsrt=edit_ca_covid.srt
editout=$HOME/Downloads/statewide_cases.csv

echo "$0 editing $newca into $editout"

echo "county,totalcountconfirmed,totalcountdeaths,newcountconfirmed,newcountdeaths,date" > $editout

# input 1=date,2=county,cases=9,deaths=10
cat $newca|sed "/^date/d"|sed "/^,/d"|\
# sort by county/asc (col2), date/asc (col1)
sort -t',' -k2,2 -k1,1|\
# running subtotal by county, date
awk 'BEGIN {FS=","};\
{if (county == $2) {cases+=$9;deaths+=$10; print county","cases","deaths","$9","$10","$1}\
 else {county=$2;cases=0;deaths=0} }' >> $editout

echo "$0 edited"
ls -l $newca $editout

