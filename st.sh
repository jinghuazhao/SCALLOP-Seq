#!/usr/bin/bash

git add .gitignore
git commit -m ".gitignore"
git add README.md README.pdf
git commit -m "README"
git add index.html mermain.css
git commit -m "index"
git add SCALLOP-Seq.svg INTERVAL.md README.md idmap.do wes.R weswgs.R weswgs.sh wgs.wrap
git add bgen.sb spa.* prune.wrap rva.*
git commit -m "SCALLOP-seq association analysis"
git add st.sh
git commit -m "st.sh"
git add cmp.sh
git commit -m "compare"
git push

# git init
# git remote add origin git@github.com:jinghuazhao/SCALLOP-Seq.git
# git push --set-upstream origin master
# pandoc -f markdown --mathml -t html README.md -o index.html

