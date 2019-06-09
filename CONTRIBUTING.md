# Contributing to fRanz
> WIP: First Draft of Contributing

The primary goal of this guide is to help you contribute to `fRanz` as quickly and as easily possible. It's secondary goal is to document important information for maintainers.

#### Table of contents

* [Creating an Issue](#issues)
* [Submitting a Pull Request](#prs)
* [Running Tests Locally](#testing)
* [Versioning](#version)
* [Releasing to CRAN](#cran)

## Creating an Issue <a name="issues"></a>

To report bugs, request features, or ask questions about the structure of the code, please [open an issue](https://github.com/UptakeOpenSource/fRanz/issues).

### Bug Reports

If you are reporting a bug, please describe as many as possible of the following items in your issue:

- your operating system (type and version)
- your version of python
- your version of `R`, `docker`, and `librdkafka`

The text of your issue should answer the question "what did you expect `fRanz` to do and what did it actually do?".

We welcome any and all bug reports. However, we'll be best able to help you if you can reduce the bug down to a **minimum working example**. A **minimal working example (MWE)** is the minimal code needed to reproduce the incorrect behavior you are reporting. Please consider the [stackoverflow guide on MWE authoring](https://stackoverflow.com/help/mcve).

If you're interested in submitting a pull request to address the bug you're reporting, please indicate that in the issue.

### Feature Requests

We welcome feature requests, and prefer the issues page as a place to log and categorize them. If you would like to request a new feature, please open an issue there and add the `enhancement` tag.

Good feature requests will note all of the following:

- what you would like to do with `fRanz`
- how valuable you think being able to do that with `fRanz` would be
- sample code showing how you would use this feature if it was added

If you're interested in submitting a pull request to address the bug you're reporting, please indicate that in the issue.

## Submitting a Pull Request <a name="prs"></a>

We welcome [pull requests](https://help.github.com/articles/about-pull-requests/) from anyone interested in contributing to `fRanz`. This section describes best practices for submitting PRs to this project.

If you are interested in making changes that impact the way `fRanz` works, please [open an issue](#issues) proposing what you would like to work on before you spend time creating a PR.

If you would like to make changes that do not directly impact how `fRanz` works, such as improving documentation, adding unit tests, or minor bug fixes, please feel free to implement those changes and directly create PRs.

If you are not sure which of the preceding conditions applies to you, open an issue. We'd love to hear your idea!

To submit a PR, please follow these steps:

1. Fork `fRanz` to your GitHub account
2. Create a branch on your fork and add your changes
3. If you are changing or adding to the R code in the package, add unit tests and integration tests confirming that your code works as expected
4. Any commits added should ideally follow [conventional commits](https://conventionalcommits.org). See the Conventional Commits section below for more detail
5. When you are ready, click "Compare & Pull Request". Open A PR comparing your branch to the `master` branch in this repo
6. In the description section on your PR, please indicate the following:
    - description of what the PR is trying to do and how it improves `fRanz`
    - links to any open [issues](https://github.com/UptakeOpenSource/fRanz/issues) that your PR is addressing

We will try to review PRs promptly and get back to you within a few days.

### Conventional Commits

We strive to follow conventional commits to make creating NEWS.md and other files easy to maintain. Additionally it provides ease to PR reviewers to semantically check which commit they want to review and sift through the changes. Though we are not terribly strict around this rule since it will cause lots of friction for first time contributors to have to re-author commits, and that is more important than havea   pure git history, we do ask frequent commiters to follow this convention. 

In other words, this is a good useful convention but not at the expense of reducing interest or involvement in the project. This will come at the expense of automation, but that's ok.

For more details see [conventional commits](https://conventionalcommits.org)

## Running Tests Locally <a name="testing"></a>

### Development
`NOTE TO DEVELOPERS: Please add tips as you find them`
- You need to have g++ to work with this package properly. The clang compiler is not supported because of differences in static linking in the namespace. See this issue for more details 

#### Speeding up development times

Currently `fRanz` installs the entire pulls and compiles the entire `librdkafka` source each time it is installed. This is good for portability but adds significant install time each time. In order to improve the experience developing a guard is put in ./configure which might cause caching issues. Use `make clean` to purge your install.

### Running Unit and Integration Tests
> You must have `docker` and `docker-compose` configured correctly
> run `docker-compose up -d` from the root of the repository. This will start kafka running on your machine
> run `make test` or other R testing tools
> when done, make sure to call `docker-compose down` to shutdown any running docker instances

### Creating Releases
> Currently the best practice known is under `make check`
> When we figure this out we will document it!

## Package Versioning <a name="version"></a>

### Version Format
We follow semantic versioning for `fRanz` releases, `MAJOR`.`MINOR`.`PATCH`: 

* the `MAJOR` version will be updated when incompatible API changes are made,   
* the `MINOR` version will be updated when functionality is added in a backwards-compatible manner, and  
* the `PATCH` version will be updated when backwards-compatible bug fixes are made.   

In addition, the latest development version will have a .9999 appended to the end of the `MAJOR`.`MINOR`.`PATCH`. 

For more details, see https://semver.org/

### Release Planning
The authors of this package have adopted [milestones on github](https://help.github.com/en/articles/about-milestones) as a vehile to scope and schedule upcoming releases.  The main goal for a release is written in the milestone description.  Then, any ideas, specific functionality, bugs, etcs submitted as [issues](https://help.github.com/en/articles/about-issues) pertinent to that goal are tagged for that milestone.  Goals for milestone are dicsused openly via a github issue.  

Past and upcoming releases can be seen on the  [fRanz milestones page](https://github.com/UptakeOpenSource/fRanz/milestones). 

## Releasing to CRAN (for maintainer) <a name="cran"></a>
> WIP: Document How to Package Official Releases 

Once substantial time has passed or significant changes have been made to `fRanz`, a new release should be pushed to [CRAN](https://cran.r-project.org). 

This is the exclusively the responsibility of the package maintainer, but is documented here for our own reference and to reflect the consensus reached between the maintainer and other contributors.

This is a manual process, with the following steps.

### Open a PR 

Open a PR with a branch name `release/v0.0.0` (replacing 0.0.0 with the actual version number).

Add a section for this release to `NEWS.md`.  This file details the new features, changes, and bug fixes that occurred since the last version.  

Add a section for this release to `cran-comments.md`. This file holds details of our submission comments to CRAN and their responses to our submissions.  

Change the `Version:` field in `DESCRIPTION` to the official version you want on CRAN (should not have a trailing `.9999`).

Rebuild the documentation by running:

```
Rscript -e "devtools::document()"
Rscript -e "install.packages('pkgdown', repos = 'cran.rstudio.com')"
Rscript -e "pkgdown::build_site()"
```

`pkgdown` is changing pretty rapidly, so it's important to pull the latest from CRAN before building the site.

Check in whichever of the files generated by `pkgdown` seem relevant to you. Anything that shows up as "modified" when you run `git status` should be checked in to the PR branch. New files ("not tracked by git") should be considered on a case-by-case basis.

### Test on latest development version of R (i.e. "R-Devel") 

This is a CRAN requirement.  [This docker based process](https://alexandereckert.com/post/testing-r-packages-with-latest-r-devel/) from Alexander Eckert is very useful.

### Submit to CRAN

Build the package tarball by running the following

```
R CMD BUILD .
```

Go to https://cran.r-project.org/submit.html and submit this new release! In the upload section, upload the tarball you just built.

### Handle feedback from CRAN

The maintainer will get an email from CRAN with the status of the submission. 

If the submission is not accepted, do whatever CRAN asked you to do. Update `cran-comments.md` with some comments explaining the requested changes. Rebuild the `pkgdown` site. Repeat this process until the package gets accepted.

### Merge the PR

Once the submission is accepted, great! Update `cran-comments.md` and merge the PR.

### Create a Release on GitHub

We use [the releases section](https://github.com/UptakeOpenSource/fRanz/releases) in the repo to categorize certain important commits as release checkpoints. This makes it easier for developers to associate changes in the source code with the release history on CRAN, and enables features like `devtools::install_github()` for old versions.

Navigate to https://github.com/UptakeOpenSource/fRanz/releases/new. Click the drop down in the "target" section, then click "recent commits". Choose the latest commit for the release PR you just merged. This will automatically create a [git tag](https://git-scm.com/book/en/v2/Git-Basics-Tagging) on that commit and tell Github which revision to build when people ask for a given release.

Add some notes explaining what has changed since the previous release.

### Open a new PR to begin development on the next version

Now that everything is done, the last thing you have to do is move the repo ahead of the version you just pushed to CRAN.

Make a PR that adds a `.9000` on the end of the version you just released. This is a common practice in open source software development. It makes it obvious that the code in source control is newer than what's available from package managers, but doesn't interfere with the [semantic versioning](https://semver.org/) components of the package version.

