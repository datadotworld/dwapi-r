# dwapi

[![CircleCI](https://circleci.com/gh/datadotworld/dwapi-r.svg?style=svg)](https://circleci.com/gh/datadotworld/dwapi-r)
[![cran version](https://www.r-pkg.org/badges/version/dwapi)](https://CRAN.R-project.org/package=dwapi) 

The `dwapi` R package makes it easy to use [data.world's REST API](https://docs.data.world/documentation/api) in R.  
Using the package, users can:

* Create and update datasets, metadata and files
* Query datasets using SQL and SPARQL
* Download files and entire datasets

# Getting Started

To get started, load the library and checkout the `quickstart` vignette.
```R
library(dwapi)
vignette("quickstart", package = "dwapi")
```

Here is a simple example:
```R
intro_dataset <- dwapi::get_dataset(
  dataset = "https://data.world/jonloyens/an-intro-to-dataworld-dataset")
```

Notice that `dataset` is parameter required by most functions and can be provided in two formats:

1. URL: "https://data.world/jonloyens/an-intro-to-dataworld-dataset"
2. Path: "jonloyens/an-intro-to-dataworld-dataset"

## Installation

To get the current released version from CRAN:

```R
install.packages("dwapi")
```

To get the current development version from GitHub:
```R
devtools::install_github("datadotworld/dwapi-r", build_vignettes = TRUE)
```

## Configuration

First, users must obtain an API authentication token at: https://data.world/settings/advanced

**IMPORTANT**: For your security, do not include your API authentication token in code that
is intended to be shared with others.

To configure the package, use `dwapi::configure`:
```R
> library(dwapi)
> dwapi::configure(auth_token = "YOUR_TOKEN_GOES_HERE")
```

# Next

Check out the `quickstart` vignette and the package documentation (`?dwapi`).
```R
> vignette("quickstart", package = "dwapi")
> ?dwapi
```
