data hw2; *�n�]���s�ɮת��ɦW
set hw; *��l����ɦW
proc sort ; *�n�������
by Antibio; *�̷�Antibio����
run;

proc means n mean std data=hw; *�Q��means��ƨD�U�حȭnŪ�����data=hw
var Dur_stay  Age Temp WBC; *�n����X���ܼ�
run;

proc means n mean std range data=hw2; *�n���դ��R�n���ˤ@�ӷs��ƥX�� *�̤W����dataset
var Dur_stay  Age Temp WBC;
by Antibio;
run;
proc boxplot data=hw2 ; /*�n�e������*Ū����Ƭ�hw2*/
plot Dur_stay*Antibio;/*y�b����|�Ѽ�x�b���ϥΧܥͯ��P�_*/
run;

proc freq data=hw;/*�n�p��hw���ʤ���*/
tables Sex Antibio Bact_cul Service; /*�n����X���ܼƪ�*/
run;

proc freq data=hw2;
tables ( Sex Antibio Bact_cul Service)*Antibio/nopercent norow; /*�e�����A���O�n���R���ӫ᭱�O�H�ƻ����*/
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
