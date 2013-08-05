__author__ = 'Jayashree'
import pymongo
import sys
import re
#USAGE: comunicate with the database for past results
class calcDAO:

    #USAGE: Initialization
    def __init__(self, database):
        self.db = database
        self.calculations = database.calculations

    #USAGE: Finding the recent calculations. 
    #       num_calc is to define the number of results to be displayed. It is a number
    def get_calc(self, num_calc):
        l = []
        try:
            #getting only the needed attributes from the database
            cursor = self.calculations.find({},{"_id":False,"exp":True,"val":True})
            #sorting the result with respect to the _id as the first 4 bytes of the _id are always timestamp
            cursor = cursor.sort([('_id',pymongo.DESCENDING)])
            #limiting the result
            cursor = cursor.limit(num_calc)
            for calc1 in cursor:
                l.append({'exp':calc1['exp'], 'val':calc1['val']})
        except:
            print "Unexpected error:", sys.exc_info()[0]
        return l

    #USAGE: inserting the new calculation in the database
    #       exp is a string. It is the expression eg. "4+7"
    #       val is a string. It is the value of the expression eg. "11"
    def insert_calc(self, exp, val):
        calc = {"exp": exp,
                "val": val}
        try:
            self.calculations.insert(calc)
        except:
            print "Error inserting calculations"
            print "Unexpected error:", sys.exc_info()[0]

    #USAGE: Deleting all the expressions in db. Made if there is a need to clear the collection through UI
    def delete_db(self):
        try:
            self.calculations.remove()
        except:
            print "Error removing calculations"
            print "Unexpected error:", sys.exc_info()[0]