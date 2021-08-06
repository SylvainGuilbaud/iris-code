import iknowpy
import mysql.connector

iknow=iknowpy.iKnowEngine()

mydb = mysql.connector.connect(
  host="localhost",
  user="yourusername",
  password="yourpassword",
  database="mydatabase"
)

mycursor = mydb.cursor()

mycursor.execute("SELECT content FROM mv_activity")

myresult = mycursor.fetchall()

for content in myresult:
    # print(content)
    iknow.index(content,'fr')
    # print(iknow.m_index)
    for s in iknow.m_index['sentences']:
        print(s['entities'].count)
        for e in s['entities']:
            print(e['type']+':   '+e['index'])

