The Project mainly focuses on the concept of having too much of calculations and needing a lot of memory to get the previous results to calculate the next results.

I have created 5 memory space which can be used directly but note that as the expressions and values are stored in the database it is possible to extend to a lot more number than 5. 
There is also a button available for clearing the database just in cases where the db is taking a lot of memory after too many calculations.

The projects needs MongoDB up and running along with pymongo and bottle installed.

Windows Installation for pymongo, MongoDB and bottle:
https://www.youtube.com/watch?feature=player_embedded&v=hOEV-q176kc
https://www.youtube.com/watch?feature=player_embedded&v=hX5louVryOQ
https://www.youtube.com/watch?feature=player_embedded&v=OhEpXjL0vt8



Steps:
Start Mongodb and give the following command 
mongoimport --db calc --collection calculations --file calc.json
Note that the calc.json is already provided

after the file gets imported run Calculator.py and open a browser with URL: http://localhost:8082/