# SCCSID @(#)  1.6 03/20/21 17:58:58
# download_corona.sh - dowload from various web sites
# 2020/05/21 written
# 2020/06/26 new file & loc for ca
# 2020/07/28 add https://covidtracking.com/api/v1/states/daily.csv
# 2021/03/12 new state https://data.chhs.ca.gov/dataset/f333528b-4d38-4814-bebb-12db1f10f535/resource/046cdd2b-31e5-4d34-9ed3-b48cdbc4be7a/download/covid19cases_test.csv
# was https://data.ca.gov/dataset/590188d5-8545-4c93-a9a0-e230f0db7290/resource/926fd08f-cc91-4828-af38-bd45de97f8c3/download/statewide_cases.csv
# 2021/03/20 add edit_ca_covid.sh to convert ca file


coronacaurl=https://data.chhs.ca.gov/dataset/f333528b-4d38-4814-bebb-12db1f10f535/resource/046cdd2b-31e5-4d34-9ed3-b48cdbc4be7a/download/covid19cases_test.csv 
coronaworldurl=https://covid.ourworldindata.org/data/owid-covid-data.csv
coronastateurl=https://covidtracking.com/api/v1/states/daily.csv

# download
firefox -new-tab $coronacaurl &
sleep 15
firefox -new-tab $coronaworldurl  &
sleep 15
firefox -new-tab $coronastateurl  & 
sleep 15
 
echo "press enter after download complete"
read enterdl

# edit ca
sh $HOME/bin/mysql/edit_ca_covid.sh
coronacacsv=statewide_cases.csv
coronaworldcsv=owid-covid-data.csv
coronastatecsv=covidtracking_state.csv
# give file a better name
mv -f ~/Downloads/daily.csv ~/Downloads/$coronastatecsv

for dlfile in $coronacacsv $coronaworldcsv $coronastatecsv
do
  ls -l ~/Downloads/$dlfile ~/bin/mysql/$dlfile
  mv -i ~/Downloads/$dlfile ~/bin/mysql/$dlfile
done
