/*----------設立新檔案_排序用------------*/
data hw2; /*要設的新檔案的檔名*/
set hw; /*原始資料檔名*/
proc sort ; /*要執行分類*/
by Antibio; /*依照Antibio分類*/
run;
/*----------平均標準差等等地統計描述------------*/
proc means n mean std data=hw; /*利用means函數求各種值要讀的資料data=hw*/
var Dur_stay  Age Temp WBC; /*要算哪幾種變數*/
run;

proc means n mean std range data=hw2; /*要分組分析要先弄一個新資料出來 用上面的dataset函數*/
var Dur_stay  Age Temp WBC;
by Antibio;
run;
proc boxplot data=hw2 ; /*要畫盒狀圖*讀取資料為hw2*/
plot Dur_stay*Antibio;/*y軸為住院天數x軸為使用抗生素與否*/
run;
/*--------敘述性統計-----------*/
proc freq data=hw;/*要計算hw的百分比*/
tables Sex Antibio Bact_cul Service; /*要找哪幾個變數的*/
run;

proc freq data=hw2;
tables ( Sex Antibio Bact_cul Service)*Antibio/nopercent norow; /*前面的括弧是要分析哪個後面是以甚麼分組*/
run;
/*-----------獨立樣本t檢定-----------*/
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
/*-------McNemar test---------*/
data McNemar;
input outcomeA $ outcomeB $ count; /*幾個變相名稱*/
cards;  
As Bs 510
Ad Bs 5
As Bd 16
Ad Bd 90
;/*s存活過5年 d5年內死亡*/
run;
proc freq;
tables outcomeA*outcomeB/agree; exact mcnem; /*npq大於5的話只需打agree，但這行程式碼兩個都會跑*/
weight count;
run;
/*-----------McNemar test精算法----------*/
data McNemar;
input outcomeC $ outcomeT $ count;
cards; 
C1 T1 3
C0 T1 1
C1 T0 7
C0 T0 9
;/*1有高血壓0無高血壓*//*上面是在輸入數據*/
run;
proc freq;
tables outcomeC*outcomeT/agree; exact mcnem;
weight count;
run;
/*--------配對t檢定------*/
data paired_t;
input id before after; /*輸入3變相*/
cards;
1 115 128
2 112 115
3 107 106
4 119 128
5 115 122
6 138 145
7 126 132
8 105 109
9 104 102
10 115 117
;
run;
PROC TTEST DATA =paired_t;
    PAIRED before*after;/*前減後，要後減前就對調，只會差負號*/
RUN;

PROC TTEST DATA =paired_t;
    PAIRED after*before;
RUN;
/*-------kappa----------*/
data kappa; /*創立kappa檔案*/
input survey1 $ survey2 $ count;
cards;
1 1 136
1 2 92
2 1 69
2 2 240
;
run;
proc freq;
tables survey1*survey2/agree; test kappa; /*只打agree會只算McNema test*/
weight count;/*沒這行會以為每列只有一個人*/
run;
/*------------皮爾森相關係數--------------*/
proc gplot data=c1;/*畫圖，看關係*/
 plot  FEV*height ;/*先寫的在Y軸*/
run;

proc corr data=c1;/*求皮爾森相關係數*/
var height FEV;
run;
