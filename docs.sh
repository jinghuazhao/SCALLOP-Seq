#!/usr/bin/bash

function setup()
{
  module load python/3.7
  source ~/COVID-19/py37/bin/activate
}

setup
mkdocs build
mkdocs gh-deploy

git add .gitignore
git commit -m ".gitignore"
git add README.md
git commit -m "README"
git add SCALLOP-Seq.svg INTERVAL.md README.md idmap.do wes.R weswgs.R weswgs.sh wgs.wrap
git add bgen.sb spa.* prune.wrap rva.*
git commit -m "SCALLOP-seq association analysis"
git add docs.sh
git commit -m "docs.sh"
git add cmp.sh
git commit -m "compare"
git add test
git commit -m test
git add mkdocs.yml
git commit -m "mkdocs.yml"
git push

# git init
# git remote add origin git@github.com:jinghuazhao/SCALLOP-Seq.git
# git push --set-upstream origin master
# pandoc -f markdown --mathml -t html README.md -o index.html