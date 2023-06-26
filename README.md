# g3data_wpd_test
## Goal and Purpose
In _script.R_ I scraped a table from wikipedia [Source](https://de.wikipedia.org/wiki/Wikipedia:Spendenstatistik), made a lineplot and tried to recreate the data with WebPlotDigitizer and g3data to see if they are useful tools.

## Findings
Mean percentage deviation compared to the original data:
|          | WebPlotDigitizer |   g3Data  |
|----------|------------------|-----------|
|**mean**  |      ca. 1,7%    | ca. 36%   |
|**median**|      ca. 0,75%   | ca. 1,2%  |

### main source of errors
- values near 0 are easy to miss with the mouse then trying to aim at the line
  - when missing those small values the error may be as big as the value itself

## Conclusion
- both tools are great for reproducing data from plots
- webplotdigitizer is a great alternative for g3data

### limitations
- only tested with lineplots, but it probably works just fine with barplots aswell
