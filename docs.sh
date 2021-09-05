#!/usr/bin/bash

function setup()
{
  module load python/3.7
  source ~/COVID-19/py37/bin/activate
  mkdocs build
  mkdocs gh-deploy
}

setup

git add .gitignore
git commit -m ".gitignore"
git add README.md
git commit -m "README"
git add README.md idmap.do wes.R weswgs.R weswgs.sh wgs.R wgs.wrap
git add bgen.sb spa.* prune.wrap rva.* geneset_data/config.txt
git commit -m "SCALLOP-seq association analysis"
git add docs docs.sh
git commit -m "docs"
git add tests
git commit -m tests
git add mkdocs.yml
git commit -m "mkdocs.yml"
git push

# git init
# git remote add origin git@github.com:jinghuazhao/SCALLOP-Seq.git
# git push --set-upstream origin master
# OK with html and MathJax but not md and mermaid
# pandoc -f markdown --mathml -t html README.md -o index.html
