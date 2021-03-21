# PROJECT TEMPLATE

This repo is a **minimalistic** template for empirical economics projects. It usefully serves as a barebone directory structure in empirical research projects in economics. One can easily extent the structure to allow for more complicated cases. 

```
├── analysis
│   ├── code
│   └── output
├── data
│   └── dataset_name
│       ├── clean
│       ├── code
│       ├── documentation
│       ├── output
│       ├── questionnaire
│       └── raw
├── documentation
└── report
```

The template has been constructed with a specific workflow in mind, and has the following features/recommendations:

- All data cleaning and construction and descriptive analysis code related to the dataset `<dataset_name>` goes into `data/<dataset_name>/code` and modified/analysis-ready code goes into `data/<dataset_name>/clean` directory.
- All descriptive output (tables, figures etc.) that are solely related to the dataset `<dataset_name>` should be in `data/<dataset_names>/output` directory.
- Each `code` directory should have a `makefile` that runs the code in that directory and subdirectories.
- A main `makefile` should be in the root directory.
- The project directory should **NEVER** be in a cloud sync directory such as Dropbox, Box or Google Drive.
- If more than one coding environment (`R`, `Stata`, `Matlab`, `Python` etc.) is used, related subdirectories (`r`, `do`, `py`, `m` etc.) should be created inside `code` directories. 
- Unused directories (`questionnaire` etc.) could be deleted, or needed directories ( eg. `lib`, `ado`, `env` ) could be created.



