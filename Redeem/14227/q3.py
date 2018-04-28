import numpy as np

def Indent(_val):
	for i in range(0, _val):
		print "\t",		

def Sort(Input):
	for i in range(1, len(Input)):
		_len=i-1
		for j in range( 0, i):
			_j= _len - j
			if Input[i] >= Input[_j]:
				break
			else:
				temp= Input[i]
				Input[i]= Input[_j]
				Input[_j]= temp
				i=_j

def Print(Input, start, end):

	if end - start == 0:
		Indent(start)
		print Input[start]

		return

	if end - start == 1:
		Indent(start)
		print Input[start],
		print "\n"

		Indent(end)
		print Input[end],
		print "\n"
		
		return

	mid= (start + end)/2
	Indent( mid )	
	print Input[mid],
	print "\n"

	Print(Input, start, mid-1)
	Print(Input, mid+1, end)

# Scanning Input
def Input():
	Input=[]
	N=input("Total Number of elements: ")
	for i in range(0,N):
		temp=input("Enter the number: ")
		Input.append(temp)

	return Input

# Main Code

Input= [10,9,8,6,7,4,5,3,2,1]
# Input= Input()

Sort( Input)

Print( Input, 0, len(Input)-1)