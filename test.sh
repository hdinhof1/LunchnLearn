filesToCheck='realm-update-reminder.yml|learning.swift' # .yml here to remind that the path is based on the location of the file
filesModified=$(git diff "$GIT_DESTINATION_BRANCHNAME" "$GIT_PR_BRANCHNAME" --unified=0 --name-only | egrep $filesToCheck)
if [ ! -z "$filesModified" ]
then 
	echo "Modified a Realm file, continue to check for version bump"
else
	exit 0
fi
search=$(git diff 31c6b3f0f2c46ff006eece209849e0bed1d7c4a8 --unified=0 -G'Realm.configureRealm\(schemaVersion:' learning.swift | egrep '[+-]Realm.configureRealm\(schemaVersion:')
before=$(echo $search | egrep -o [0-9]+ | head -1)
after=$(echo $search | egrep -o [0-9]+ | tail -1 )
if [[ (! -z "$search") && "$before" -lt "$after" ]]
then
	echo "This is not an empty string success"
	echo "- number is $before"
	echo "+ number is $after"
	exit 0
else 
	echo "Empty string found make sure that $before < $after"
	echo "Instead got $search"
	exit 1
fi
echo Done!
# then do echo $search | grep + | egrep -o [0-9]+  # to get the number of +
# the base of the merge commit (on master) is 4ce19158ecac5ddeff87e87ee406fce820f823a2 
# we want the most recent version of master