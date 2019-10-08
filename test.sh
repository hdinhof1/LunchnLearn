echo "Beginning work"
# make an array here with the two different versions defaultUser and default realm
declare -a array=("learning.swift", "defaultUser.swift")
declare -a secondArray=("Realm.configureRealm\(schemaVersion:", "Realm.Configuration\(schemaVersion: ")
arraylength=${#array[@]}
for (( i=0; i<${arraylength}; i++ ));
do
	echo $i " / " ${arraylength} " : " ${array[$i]}
	search=$(git diff master test-branch7 --unified=0 -G'Realm.configureRealm\(schemaVersion:' "${array[$i]}"  | egrep '[+-]Realm.configureRealm\(schemaVersion:' || [[ $? == 1 ]] | echo "didntModify")
	if [[ (! -z "$search") && "$search" = "didntModify" ]]
    then 
        echo "Didnt update schemaVersion number at all, exiting"
        exit 10
    fi
    before=$(echo $search | egrep -o [0-9]+ | head -1)
    after=$(echo $search | egrep -o [0-9]+ | tail -1)
    if [[ (! -z "$search") && "$before" -lt "$after" ]]
    then
        echo "Good!"
        echo "$search"
        echo "- old version was $before"
        echo "+ new version is  $after"
        exit 0
    else 
        echo "failure"
        echo "Empty or Invalid realm version found make sure that $before < $after"
        echo "Instead got $search"
        exit 1
    fi
done
### back to normal
filesToCheck="learning.swift"
modifiedNames=$(git diff master test-branch5 --name-only)
filesModified=$(git diff master test-branch5 --name-only | egrep 'learning.swift' || "")
filesModified=$(echo $modifiedNames | egrep 'learning.swift')
echo "filesModified is $filesModified" 
if [ ! -z "$filesModified" ]
then 
	echo "Modified a Realm file, continue to check for version bump"
else
	echo "No $filesToCheck is modified exiting"
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


          # just go by filename or part of path