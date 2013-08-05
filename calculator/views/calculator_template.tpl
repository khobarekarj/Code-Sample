<!--
		AUTHOR : Jayashree Khobarekar
		CREATED ON: 07/27/2013
		USAGE: HTML template for the calculator with three main sections
					Section1: Result and Error display
					Section2: Normal arithmatic calculation
					Section3: Past calculation
-->
<html>
<head>
<title>Calculator</title>
<script>
//USAGE:firstValue variable keeps track for the start of the arithmetic expression
var firstValue = 0;

//USAGE: gets the previous value in the session
//notice that since the same form is required this also fetches the final result
function previousAnswer()
{
	//if the previous value is not None or 0 it sets the calculator with the the value
	//it sets firstValue as -1 as if someone presses an operator the string must be appended with the previous result
	%if (previous != None and previous!='0'):
		document.calculator.answer.value = '{{previous}}';
		firstValue = -1;
	%end

	//if the previous value is None or 0 it sets the calculator with the value
	%if (previous == None or previous == '0'):
		document.calculator.answer.value = '0';
	%end
}

//USAGE: appends the new value to the string to form the expression
//		 val can be any digit from 0-9 , arithmetic operators + - / * , decimal point or a floating point value from previous results
function appendString(val)
{
	//condition for entering a new value disragaring the previous value. to be done in the case where numbers are entered
	if(firstValue==-1 && !(val == "+"||val == "-" ||val=="/"||val=="*"))
	{
		//if a decimal is directly entered it must add "0." to the expression to make sense of the expression
		if(val=='.')
			document.calculator.answer.value='0' + "" + val;
		else
			document.calculator.answer.value=val;
		firstValue = 1;
	}
	//a normal entry of value just to be added at the end of the expression string
	else if(firstValue!=0)
	{
		//if a decimal is directly entered it must add "0." to the expression to make sense of the expression
		if(val=='.'&&isNaN(document.calculator.answer.value.valueOf(document.calculator.answer.value.length-2)))
			document.calculator.answer.value=document.calculator.answer.value + "0" + val;
		else
			document.calculator.answer.value=document.calculator.answer.value + "" + val;
		firstValue=1;
	}
	//first entry of the expression i.e. the session is freshly started and the value on the display is '0'
	else
	{
		//if a decimal is directly entered it must add "0." to the expression to make sense of the expression
		if(val=='.')
			document.calculator.answer.value='0' + "" + val;
		else
			document.calculator.answer.value=val;
		firstValue = 1;
	}
}

//USAGE: the clear button on the calculator to start a fresh session
function clearString()
{
	document.calculator.answer.value=0;
	firstValue = 0;
}

//USAGE: the back space is used to remove the last character from the expression on the display
function bspString()
{
	if(document.calculator.answer.value.length>1)
		document.calculator.answer.value=document.calculator.answer.value.substring(0,document.calculator.answer.value.length-1);
	else
	{
		//if only one digit was on the Display relace it with '0' and treat everything as a fresh session
		document.calculator.answer.value=0;
		firstValue = 0;
	}
}
function deleteDB()
{
	document.calculator.answer.value="DELETEDB";
	document.getElementById("calculator").submit();
}
</script>
<style>
input[type="button"] 
{
	-webkit-appearance: button;
	height:50px;
	width:50px;
}
</style>
</head>

<body bgcolor="#333333" onload="previousAnswer()">

<form action="" name="calculator" id="calculator" method="post">
<table bgcolor="#FFFFFF" align="center" style="text-align:center" cellpadding="5" cellspacing="5">
	<!--SECTION 1 Begins-->
	<!--ERROR BLOCK: gets the error from the input to the template-->	
	<tr>
		<td style="text-align:left">&nbsp;
			%if (error != "NoError"):
			Error:{{error}}
			%end
		</td>
	</tr>
	<!--DISPLAY BLOCK: a readonly field-->
	<tr>
		<td align="center">
			<input type="text" size="40" style="text-align:right" readonly="readonly" name="answer" id="answer" value="0">
		</td>
	</tr>
	<!--SECTION 1 Ends-->
	<!--SECTION 2 Begins : CALCULATOR BLOCK-->
	<tr><td>
		<table cellpadding="2" cellspacing="2" align="center">
        	<tr>
            	<td><input type="button" onclick="appendString(7)" value="7"></td>
                <td><input type="button" onclick="appendString(8)" value="8"></td>
                <td><input type="button" onclick="appendString(9)" value="9"></td>
                <td><input type="button" onclick="appendString('/')" value="/"></td>
                <td><input type="button" onclick="deleteDB()" value="clr DB"></td>
           	</tr>
            <tr>
            	<td><input type="button" onclick="appendString(4)" value="4"></td>
                <td><input type="button" onclick="appendString(5)" value="5"></td>
                <td><input type="button" onclick="appendString(6)" value="6"></td>
                <td><input type="button" onclick="appendString('*')" value="*"></td>
                <td><input type="button" onclick="bspString()" value="&larr;"></td>
           	</tr>
            <tr>
            	<td><input type="button" onclick="appendString(1)" value="1"></td>
                <td><input type="button" onclick="appendString(2)" value="2"></td>
                <td><input type="button" onclick="appendString(3)" value="3"></td>
                <td><input type="button" onclick="appendString('-')" value="-"></td>
                <td><input type="button" onclick="clearString()" value="Clr"></td>
            </tr>
            <tr>
            	<td colspan="2"><input type="button" style="height:50px; width:105px" onclick="appendString(0)" value="0"></td>
                <td><input type="button" onclick="appendString('.')" value="."></td>
                <td><input type="button" onclick="appendString('+')" value="+"></td>
                <td><input type="submit" style="height:50px; width:50px" value="="></td></tr>
        </table>
	</td></tr>
	<!--SECTION 2 Ends-->
	<!--SECTION 3 Begins-->
	<tr><td>
    	<table width="100%" cellspacing="2" cellpadding="2" align="center">
        	<tr><th colspan="2" style="text-align:left">Past calculations:</th></tr>
        	<!--Gets value in small block of expressions and buttons to use the past results from the database-->
        	%for pc in pastCalc:
        	<tr>
        		<td width="70%" style="text-align:right">{{pc['exp']}} = </td>
        		<td width="30%"><input type="button" style="height:40px; width:105px" onclick="appendString('{{pc['val']}}')" value="{{pc['val']}}"></td>
        	</tr>
			%end
    	</table>
    </td></tr>
    <!--SECTION 3 Ends-->
</table>
</form>
</body>
</html>