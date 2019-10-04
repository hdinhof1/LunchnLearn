search=$(git diff 4ce19158ecac5ddeff87e87ee406fce820f823a2 --unified=0 -G'Realm.configureRealm\(schemaVersion:' learning.swift | egrep '[+-]Realm.configureRealm\(schemaVersion:')
after=$(echo $search | grep + | egrep -o [0-9]+)
before=$(echo $search | grep - | egrep -o [0-9]+)
if [ ! -z "$search" ]
then
	echo "This is not an empty string success $search"
	echo "+ number is $after"
	exit 0
else 
	echo "Empty string found"
	exit 1
fi
echo Done!
# then do echo $search | grep + | egrep -o [0-9]+  # to get the number of +
# the base of the merge commit (on master) is 4ce19158ecac5ddeff87e87ee406fce820f823a2 
# we want the most recent version of master