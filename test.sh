search=$(git diff --unified=0 -G'Realm.configureRealm\(schemaVersion:' learning.swift | egrep '[+-]Realm.configureRealm\(schemaVersion:')
added=$(echo $search | grep + | egrep -o [0-9]+)
if [ ! -z "$search" ]; then
	echo "This is not an empty string success $search"
	echo "+ number is $added"
	exit 0
else 
	echo "Empty string found"
	exit 1
fi
echo Done!
# then do echo $search | grep + | egrep -o [0-9]+  # to get the number of +