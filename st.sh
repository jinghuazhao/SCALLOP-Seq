#!/usr/bin/bash

git add .gitignore
git commit -m ".gitignore"
git add README.md
git commit -m "README"
pandoc -f markdown --mathml -t html README.md -o index.html
git add index.html
git commit -m "index"
git add index.html INTERVAL.md README.md idmap.do weswgs.R weswgs.sh wgs.wrap
git add bgen.sb spa.* prune.wrap rva.*
git commit -m "SCALLOP-seq association analysis"
git add st.sh
git commit -m "st.sh"
git push

# git init
# git remote add origin git@github.com:jinghuazhao/SCALLOP-Seq.git
# git push --set-upstream origin master

