from __future__ import division
import sys

# Checking the validity of the Number given
def Valid( Num, base ):

	valid=1
	for _char in Num:

		if _char in num_dict:
			if num_dict[_char] >= base:
				valid= 0
				break
		elif _char in alph_dict:
			if alph_dict[_char] >= base:
				valid=0
				break
		else:
			valid=0
			break

	return valid

# Converting the string
def Convert_Base_10( Num, base, frac, isNeg ):
	
	output=0
	_length= len(Num)
	valid=1

	if frac:
		for _iter in range(0, _length):

			num= Num[ _iter ]	

			if num in num_dict:
				output+= num_dict[num]/(int_base**(1+_iter))
			elif num in alph_dict:
				output+= alph_dict[num]/(int_base**(1+_iter))

	else:
		for _iter in range(0, _length):

			num= Num[ _length - 1 - _iter ]	

			if num in num_dict:
				output+= num_dict[num]*(base**_iter)

			elif num in alph_dict:
				output+= alph_dict[num]*(base**_iter)

	if isNeg:
		return -1*output
	else:
		return output		
	
# Main Code

Num=sys.argv[1]
base=sys.argv[2]
baseValid=1
numValid=1
isNeg= 0

global num_dict
num_dict={ '0':0,'1':1,'2':2,'3':3,'4':4,'5':5,'6':6,'7':7,'8':8,'9':9 }
global alph_dict
alph_dict= { 'A': 10, 'B':11, 'C':12, 'D':13, 'E':14, 'F':15, 'G':16, 'H':17, 'I':18, 'J':19,
 'K':20, 'L':21, 'M':22, 'N':23, 'O':24, 'P':25, 'Q':26, 'R':27, 'S':28, 'T':29, 'U':30, 'V':31, 'W':32,
 'X':33, 'Y':34, 'Z':35,
 'a': 10, 'b':11, 'c':12, 'd':13, 'e':14, 'f':15, 'g':16, 'h':17, 'i':18, 'j':19,
 'k':20, 'l':21, 'm':22, 'n':23, 'o':24, 'p':25, 'q':26, 'r':27, 's':28, 't':29, 'u':30, 'v':31, 'w':32,
 'x':33, 'y':34, 'z':35 }

int_base=0
_length= len(base)

# Converting the base number and checking validity too
for _iter in range(0, _length):
	num= base[ _length -1 - _iter ]

	if num in num_dict:
		int_base += num_dict[num]*(10**_iter)
	else:
		print("Invalid Input")
		baseValid=0
		break

# Checking if base is valid
if baseValid ==1:
	if int_base<2 or int_base>36:
		print("Invalid Input")
		baseValid=0

#Checking for Negative Sign:
if Num[0] =='-':
	isNeg= 1
	Num= Num[1:]

# Check if valid number:
if baseValid:
	if '.' in Num:
		numValid= Valid( Num.split('.')[0] , int_base )
		if numValid:			
			numValid= Valid( Num.split('.')[1] , int_base )
	else:
		numValid= Valid( Num, int_base )

	# Valid Base and Number
	if numValid:
		if '.' in Num:
			# print("For N_b= "),
			# print(Num),
			# print('& b='),
			# print(int_base),
			# print('output: '),
			print(Convert_Base_10( Num.split('.')[0] , int_base, 0, isNeg ) + Convert_Base_10( Num.split('.')[1] , int_base, 1, isNeg ))
		else:
			# print("For N_b= "),
			# print(Num),
			# print('& b='),
			# print(int_base),
			# print('output: '),
			print(Convert_Base_10( Num, int_base, 0, isNeg ))
	else:
		print("Invalid Input")