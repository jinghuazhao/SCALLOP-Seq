# INTERVAL analysis

## Programs

| Sequence | Filename  | Description           |
| ---------|---------- | --------------------- |
| 1        | weswgs.sh | WES/WGS preprocessing |
| 2.1      | spa.sh    | Single-point analysis |
| 2.2      | rva.sh    | Rare-variant analysis |

The hierachy of the scripts is as follows,

```mermaid
graph TB;
setup ==> 1; 1 ==> 2;
    1 --> idmap.do; 1 --> wgs.sb;
    2 --> 2.1; 2.1 --> spa.sb; 2.1 --> bgen.sb;
    2 --> 2.2; 2.2 --> wes.R; 2.2 --> wgs.R; 2.2 --> weswgs.R; 2.2 --> rva.sb; 2.2 --> prune.wrap;
```

## Variant lists

INTERVAL variant lists and results submitted centrally are described in [variantlists.md](variantlists.md).
