# PROJECT TEMPLATE

This repo is a **minimalistic** template for empirical economics projects. It usefully serves as a bare bone directory structure in **empirical** research projects in economics. One can easily extent the structure to allow for more complicated cases. 

```
├── code
├── data [not tracked]
│   ├── final
│   ├── inter
│   └── raw
│       ├── raw_data-1
│       │   └── doc
│       └── raw_data-2
│           └── doc
├── docs [not tracked]
├── out
├── readings [not tracked]
├── report
└── temp [not tracked]

```

The template has been constructed with a specific workflow in mind, and has the following features/recommendations:

- All code go into `code` and modified/analysis-ready data goes into `data/final` directory.
- All (if any) intermediate data should be in `data/inter`
- All output (tables, figures etc.) must go into `out` directory.
- Ideally each `data/raw/data_x` directory should have a `makefile` that runs the code in that directory and subdirectories. This `makefile` works as a master code file. Another option would be to use a `master` code file. When there are codefiles running different programming languages, `makefile` option is a better way to go.
- A main `makefile` should be in the root directory. This `makefile` works as a master code file. Another option would be to use a `master` code file. When there are scripts in different programming languages, `makefile` option is a better way to go.
- The project directory should **NEVER** be in a cloud sync directory such as Dropbox, Box or Google Drive.
- If you need to use certain libraries or configuration files to be included in the project folder, then create a `.lib` or `.config` folder in **the project root**. 
- If you add new directories to the root project folder, make sure that you are not sharing anything that you would not want to share via *Github*. So, check and, if necessary, modify `.gitignore` file.
- `.gitignore` file follows a particular logic. First unfollow everything, then follow the ones you want to be tracked by git.

The following coding principles are necessary for a reproducibility and easy collaboration:

- Each small task, such as creating a figure, table or estimation of a specific model should be done by a separate code, such as `table-2-1.R`. If code pieces must be run in an order, numbering files sequentially e.g. `04-table-3-2.do` or `table-3-2.R`is a useful practice.
- In collaboration with the research team, following the modified *Gitflow* workflow by [DIME](https://cutt.ly/PxfFOmJ) is highly recommended. Please also consult [Development Research in Practice](https://github.com/worldbank/dime-data-handbook/raw/master/mkdocs/docs/bookpdf/development-research-in-practice.pdf) by [DIME Analytics](https://cutt.ly/fxfHs8Z) of World Bank.



