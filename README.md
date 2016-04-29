# About

This repository provides XSLT transformation of DICOM Structured Report (SR) measurements document that follows DICOM SR template TID 1500 Measurement Report [1] into CSV table.

# Usage

Convert DICOM SR into XML using DCMTK dsr2xml command line tool [2].

```
% dsr2xml tumor_User3_SemiAuto_Trial2.dcm \
  | tidy -xml -quiet -wrap 1000 -indent > tumor_User3_SemiAuto_Trial2.xml
```

Use `xsltproc` to apply the XSLT transformation as follows.

```
% xsltproc -maxdepth 10000 --nonet \
  -o tumor_User3_SemiAuto_Trial2.csv \
  dicomsr_fromdsr2xml_to_csv.xsl \
  tumor_User3_SemiAuto_Trial2.xml
```

# Credits

The script was developed by David Clunie. 

Development was supported in part by NIH via U24 CA180918, Quantitative Image Informatics for Cancer Research (QIICR), http://qiicr.org.

# References

[1] http://dicom.nema.org/medical/dicom/current/output/chtml/part16/chapter_A.html#table_TID_1500
[2] http://support.dcmtk.org/docs/dsr2xml.html
