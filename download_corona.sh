# SCCSID @(#) ð€°_corona.sh 1.9 05/17/21 09:46:25
# download_corona.sh - dowload from various web sites
# 2020/05/21 written
# 2020/06/26 new file & loc for ca
# 2020/07/28 add https://covidtracking.com/api/v1/states/daily.csv
# 2021/03/12 new state https://data.chhs.ca.gov/dataset/f333528b-4d38-4814-bebb-12db1f10f535/resource/046cdd2b-31e5-4d34-9ed3-b48cdbc4be7a/download/covid19cases_test.csv
# was https://data.ca.gov/dataset/590188d5-8545-4c93-a9a0-e230f0db7290/resource/926fd08f-cc91-4828-af38-bd45de97f8c3/download/statewide_cases.csv
# 2021/03/20 add edit_ca_covid.sh to convert ca file
# 2021/03/22 clean up old files
# 2021/05/03 change to curl from firefox
# note: daily state file n/a now, maybe source at https://data.cdc.gov/Case-Surveillance/United-States-COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36
# file: https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD
# 2021/05/17 make csv filenames uniform

coronacaurl=https://data.chhs.ca.gov/dataset/f333528b-4d38-4814-bebb-12db1f10f535/resource/046cdd2b-31e5-4d34-9ed3-b48cdbc4be7a/download/covid19cases_test.csv 
coronaworldurl=https://covid.ourworldindata.org/data/owid-covid-data.csv
coronastateurl=https://covidtracking.com/api/v1/states/daily.csv

coronacadl=corona_info_ca_dl.csv
coronacacsv=corona_info_ca.csv
coronaworldcsv=corona_info.csv
coronastatecsv=corona_info_state.csv

coronacadl_old=daily.csv
coronacacsv_old=statewide_cases.csv
coronaworldcsv_old=owid-covid-data.csv
coronastatecsv_old=covidtracking_state.csv

# clean up old files
for dlfile in $coronacacsv $coronaworldcsv $coronastatecsv $coronacadl
do
  if [ -e ~/Downloads/$dlfile ]; 
    then  
    ( rm ~/Downloads/$dlfile )
  fi
done

# download using -L to force use redirects if any

echo "CA download"
curl -L -m 120 --connect-timeout 120 -o ~/Downloads/$coronacadl "$coronacaurl"
curlrc=$?
if [ $curlrc -ne 0 ]; then
  echo "FAILED: $curlrc"
  exit 1
else
  echo "Success: $curlrc"
fi

echo "World download"
curl -L -m 120 --connect-timeout 120 -o ~/Downloads/$coronaworldcsv "$coronaworldurl"
curlrc=$?
if [ $curlrc -ne 0 ]; then
  echo "FAILED: $curlrc"
  exit 1
else
  echo "Success: $curlrc"
fi

echo "US States download"
curl -L -m 120 --connect-timeout 120 -o ~/Downloads/$coronastatecsv "$coronastateurl" 
curlrc=$?
if [ $curlrc -ne 0 ]; then
  echo "FAILED: $curlrc"
  exit 1
else
  echo "Success: $curlrc"
fi

echo "edit ca after backup"
# cp ~/Downloads/$coronacadl ~/Downloads/$coronacadl.old
sh $HOME/bin/mysql/edit_ca_covid.sh

echo "downloaded and edited files"
wc -l ~/Downloads/$coronacacsv ~/Downloads/$coronaworldcsv ~/Downloads/$coronastatecsv ~/Downloads/$coronacadl.old

for dlfile in $coronacacsv $coronaworldcsv $coronastatecsv
do
  echo "Downloaded ~/Downloads/$dlfile - lines in new and old file"  
  wc -l ~/Downloads/$dlfile ~/bin/mysql/$dlfile
  mv -f ~/Downloads/$dlfile ~/bin/mysql/$dlfile
done
