search=$(git diff --unified=0 -G'print' learning.swift)
if [ ! -z "$search" ]; then
	echo "This is not an empty string success"
	exit 0
else 
	echo "Empty string found"
	exit 1
fi
echo Done!