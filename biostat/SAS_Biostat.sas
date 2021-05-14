data hw2; *要設的新檔案的檔名
set hw; *原始資料檔名
proc sort ; *要執行分類
by Antibio; *依照Antibio分類
run;

proc means n mean std data=hw; *利用means函數求各種值要讀的資料data=hw
var Dur_stay  Age Temp WBC; *要算哪幾種變數
run;

proc means n mean std range data=hw2; *要分組分析要先弄一個新資料出來 *最上面的dataset
var Dur_stay  Age Temp WBC;
by Antibio;
run;
proc boxplot data=hw2 ; /*要畫盒狀圖*讀取資料為hw2*/
plot Dur_stay*Antibio;/*y軸為住院天數x軸為使用抗生素與否*/
run;

proc freq data=hw;/*要計算hw的百分比*/
tables Sex Antibio Bact_cul Service; /*要找哪幾個變數的*/
run;

proc freq data=hw2;
tables ( Sex Antibio Bact_cul Service)*Antibio/nopercent norow; /*前面的括弧是要分析哪個後面是以甚麼分組*/
run;
proc ttest data=T8_18;
class antibio;
var dur_stay;
run ;
proc ttest data=hw8;
class gender;
var height;
run;
proc ttest data=hw8;
class gender;
var score;
run;
