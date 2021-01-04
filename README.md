<script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.3.1/mermaid.min.js" crossorigin="anonymous"></script>
<script>mermaid.initialize({startOnLoad:false});</script>
<script>let graphStr = `graph LR;
A[setup] -->B(weswgs.sh);
    B --> C{2-parts};
    C -->|spa.sh| D[aggregate/upload];
    C -->|rva.sh| E[aggregate/upload]`;
onload = () => {
  mermaid.render("mermaid", graphStr, document.getElementsByTagName("div")[0]);
}
</script>

## Programs

| Filename  | Description           |
| --------- | --------------------- |
| weswgs.sh | WES/WGS preprocessing |
| rva.sh    | Rare-variant analysis |
| spa.sh    | Single-point analysis |

idmap.do, ngs.wrap, weswgs.R, prune.wrap, rva.sb, spa.sb are subprograms; and remarks on variant lists submitted centrally are described in INTERVAL.md.

The natural order is therefore
<div class="mermaid">
graph LR;
A[setup] -->B(weswgs.sh);
    B --> C{2-parts};
    C -->|spa.sh| D[aggregate/upload];
    C -->|rva.sh| E[aggregate/upload];
</div>
noting in particular that sbatch implicates the --wait option as the succeeding steps would require its full results.

## Contacts

* Grace Png: grace.png@helmholtz-muenchen.de
* Arthur Gilly: arthur.gilly@helmholtz-muenchen.de

## Slack channel

* [https://scallop-seq.slack.com](https://scallop-seq.slack.com)

## URLs

* https://github.com/hmgu-itg/burden_testing
* https://sites.google.com/site/jpopgen/dbNSFP
* https://sites.google.com/site/jpopgen/wgsa
* http://web.corral.tacc.utexas.edu/WGSAdownload/resources/precomputed_hg38/
* http://www.columbia.edu/~ii2135/Eigen_functions_112015.R
