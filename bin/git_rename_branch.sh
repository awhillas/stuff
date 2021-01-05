old=$1
new=$2
# Rename your local branch
git branch -m $old $new
# Delete the old-name remote branch and push the new-name local branch.
git push origin :$old $new
# Reset the upstream branch for the new-name local branch
git push origin -u $new
