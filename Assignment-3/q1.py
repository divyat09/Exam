N= raw_input()
b= raw_input()

Output=0
Base=0
_length=len(N)-1


for _iter in range(0, _length):

	Base += ord(b[_iter])

for _iter in range(0, _length):

	print ord(b)**_iter
	print N[ _length-_iter ] - '0'
	#Output += ( N[ _length-_iter ] - '0' ) *(b**_iter)

print Output
