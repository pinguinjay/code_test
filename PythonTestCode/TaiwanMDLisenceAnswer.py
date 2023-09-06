import csv
import collections

#把答案拆開並加入一個list
def add2list(listA,answers) :
    answer = answers[1].split(" ")
    for element in answer :
        listA.append(element)
    return listA
#計算答案數量
def calculateAnswerNumber(listB) :
    cnt = collections.Counter(listB)
    print(cnt)
    return cnt

answer_list = list()
PATH = "D:\\answer.csv"
with open(PATH,encoding="utf-8") as fh :
    rows = csv.reader(fh)
    for row in rows: #讀取每一個row，結構['112-1','A B C D.....']
        add2list(answer_list,row)

cnt = calculateAnswerNumber(answer_list)
#print(cnt)