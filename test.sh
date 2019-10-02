search=$(git diff --unified=0 -G'print' learning.swift)
if [ ! -z "$search" ]; then
	echo "This is not an empty string"
fi
echo Done!