__author__ = 'Jayashree'
import pymongo
import calcDAO
import bottle
import re

#USAGE: IndexPage
#       Initalizing previous value '0' and 'NoError'
#       Also getting back the first 5 records
@bottle.route('/')
def calulator_index():
    previous = "0"
    error = "NoError"
    l = calc.get_calc(5)
    print(l)
    return bottle.template('calculator_template', dict(previous=previous,error=error,pastCalc=l))

#USAGE: After submition of the form
@bottle.post('/')
def present_calc():
    #"answer" is the readonly box to display the expression and show the result
    previous = bottle.request.forms.get("answer")
    if(previous!="DELETEDB"):
        exp = previous
        error = "NoError"
        l=[]
        try:
            print(previous)
            #getting the value for the expression
            previous = cal(previous)
            print "previous", previous
            #inserting the value in the database if correct
            calc.insert_calc(exp,previous)
            l = calc.get_calc(5)
            print(l)
        except:
            error = "Check your Expression"
        finally:
            #displaying the final value and the values in the database
            return bottle.template('calculator_template', dict(previous=previous, error=error,pastCalc=l))
    else:
        previous = "0"
        error = "NoError"
        calc.delete_db()
        l = []
        return bottle.template('calculator_template', dict(previous=previous, error=error,pastCalc=l))

#USAGE: Calculating the value of the expression by using operator precedence
#       expression should be correclty formed else throws an exception
def cal(expression):
    #substitution of - with negative symbol m to differentiate between negative numbers and subtraction
    expression = re.sub(r'\+\-', '+m', expression)
    expression = re.sub(r'\-\-', '-m', expression)
    expression = re.sub(r'\/\-', '/m', expression)
    expression = re.sub(r'\*\-', '*m', expression)
    expression = re.sub(r'^-', 'm', expression)
    print(expression)
    numbers = re.split("[+|\-|/|\*]*", expression)
    numberf = []
    for i in xrange(0,len(numbers)):
        #resubstituting back the negative symbol and converting to float
        numberf.append(float(re.sub(r'm', '-', numbers[i])))
    #creating a list of operators
    operators = re.split('[0-9|.|m]*', expression)
    flag = True
    i = 0
    #loop for the higher precedence of / and *
    while flag:
        if(operators[i]=='/'):
            numberf[i-1] = numberf[i-1]/numberf[i]
            numberf[i] = 'x'
            numberf.remove('x')
            operators.remove('/')
            i=i-1
        if(operators[i]=='*'):
            numberf[i-1] = numberf[i-1]*numberf[i]
            numberf[i] = 'x'
            numberf.remove('x')
            operators.remove('*')
            i=i-1
        i = i+1
        if(i>=len(numberf)):
            flag = False
    flag = True
    i = 0
    #loop for lower precendece of + and -
    while flag:
        if(operators[i]=='+'):
            numberf[i-1] = numberf[i-1]+numberf[i]
            numberf[i] = 'x'
            numberf.remove('x')
            operators.remove('+')
            i=i-1
        if(operators[i]=='-'):
            numberf[i-1] = numberf[i-1]-numberf[i]
            numberf[i] = 'x'
            numberf.remove('x')
            operators.remove('-')
            i=i-1
        i = i+1
        if(i>=len(numberf)):
            flag = False
    print(numberf[0])
    #throwing an exception if more than one element remains in the array which shows that the expression was not correctly formed.
    if(len(numberf)>1):
        x = 1/0
    return numberf[0]


#Database connection
connection_string = "mongodb://localhost"
connection = pymongo.MongoClient(connection_string)
database = connection.calc
calc = calcDAO.calcDAO(database)

bottle.debug(True)
bottle.run(host='localhost', port=8082)         
# Start the webserver running and wait for requests