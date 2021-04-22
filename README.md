# PROJECT TEMPLATE

This repo is a **minimalistic** template for empirical economics projects. It usefully serves as a barebone directory structure in **empirical** research projects in economics. One can easily extent the structure to allow for more complicated cases. 

```
.
├── datawork
│   ├── analysis
│   ├── data
│   │   ├── code
│   │   ├── dataset-1
│   │   │   └── documentation
│   │   ├── dataset-2
│   │   │   └── documentation
│   │   ├── dataset-3
│   │   │   └── documentation
│   │   ├── final
│   │   └── intermediate
│   └── output
├── documentation
└── report

```

The template has been constructed with a specific workflow in mind, and has the following features/recommendations:

- All data cleaning and construction code go into `datawork/data/code` and modified/analysis-ready code goes into `datawork/data/final` directory.
- All (if any) intermediate data should be in `datawork/data/intermediate`
- All output (tables, figures etc.) must go into `datawork/output` directory.
- Ideally each `code` directory should have a `makefile` that runs the code in that directory and subdirectories. This `makefile` works as a master code file. Another option would be to use a `master` code file. When there are codefiles running different programming languages, `makefile` option is a better way to go.
- A main `makefile` should be in the root directory.
- The project directory should **NEVER** be in a cloud sync directory such as Dropbox, Box or Google Drive.
- If there you need to use certain libraries or configration files to be included in the project folder, then make code library directories under code directories such as `../code/lib` or `../code/ado` or `../code/config`.
- **DO NOT** create new variables in `datawork/analysis` scripts. All variables must be created in `/datawork/data/code` scripts.
- If you add new directories to the root project folder, make sure that you are not sharing anything that you would not want to share via *Github*. So, check and, if necessary, modify `.gitignore` file.
- `.gitignore` file follows a particular logic. First unfollow everything, then follow the ones you want to be tracked by git.

The following coding principles are necessary for a reproducibility and easy collaboration:

- Each small task, such as creating a figure, table or estimation of a specific model should be done by a separate code, such as `table-2-1.R`. If code pieces must be run in an order, numbering files sequentially e.g. `04-table-3-2.do` is a useful practice.
- In collaboration with the research team, following the modified *Gitflow* workflow by [DIME](https://cutt.ly/PxfFOmJ) is highly recommended. Please also consult [Development Research in Practice](https://github.com/worldbank/dime-data-handbook/raw/master/mkdocs/docs/bookpdf/development-research-in-practice.pdf) by [DIME Anlytics](https://cutt.ly/fxfHs8Z) of World Bank.



