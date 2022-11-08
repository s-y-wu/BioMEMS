# BioMEMS

[![Build Status](https://travis-ci.org/s-y-wu/HMCResearchRandomWalks.svg?branch=main)](https://travis-ci.org/s-y-wu/HMCResearchRandomWalks)
[![Build status](https://ci.appveyor.com/api/projects/status/lc6qmhcinm82gdal?svg=true)](https://ci.appveyor.com/project/s-y-wu/hmcresearchrandomwalks)
[![Coverage Status](https://coveralls.io/repos/github/s-y-wu/HMCResearchRandomWalks/badge.svg?branch=main)](https://coveralls.io/github/s-y-wu/HMCResearchRandomWalks?branch=main)

Random walk simulation to test BioMEMS developed in the Caltech Roukes Group Nanosystems 

[Project Document](https://docs.google.com/document/d/1OkFzBO0tgATsgLkhx3WByxNUmUTfh7rPBNzS_yUHYCo/edit?usp=sharing)

[Videos](https://youtube.com/playlist?list=PLQ4NmvpnlBHG_VHUp1NCgwYjvKVz8M-mb) 

## Requirements
- Julia (tested on 1.4.2)
  - Official Download Page [link](https://julialang.org/downloads/)
  - Homebrew [link](https://formulae.brew.sh/cask/julia)


## Installation
To clone and cd into the repo
```bash
$ git clone https://github.com/s-y-wu/BioMEMS.git
$ cd BioMEMS
```
To enter Julia interactive shell
```bash
$ julia
```
To activate the project
```julia
julia> ]
(@v1.4) pkg> activate .
```
To run all tests
```julia
(BioMEMS) pkg> test
```
