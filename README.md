
<!-- README.md is generated from README.Rmd. Please edit that file -->

# RcppKagome <a href='https://paithiov909.github.io/RcppKagome'><img src='https://raw.githack.com/paithiov909/RcppKagome/master/man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![GitHub last
commit](https://img.shields.io/github/last-commit/paithiov909/RcppKagome)](#)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/paithiov909/RcppKagome/workflows/R-CMD-check/badge.svg)](https://github.com/paithiov909/RcppKagome/actions)
[![Codecov test
coverage](https://codecov.io/gh/paithiov909/RcppKagome/branch/master/graph/badge.svg)](https://codecov.io/gh/paithiov909/RcppKagome?branch=master)
<!-- badges: end -->

RcppKagome is an R interface to
[ikawaha/Kagome](https://github.com/ikawaha/kagome); Self-contained
Japanese morphological analyzer written in pure Go.

## System Requirements

-   GNU make
-   GNU GCC
-   Go
-   C++11

## Installation

``` r
remotes::install_github("paithiov909/RcppKagome")
```

## Usage

### Call Kagome

``` r
res <- RcppKagome::kagome("にわにはにわにわとりがいる")
str(res)
#> List of 1
#>  $ :List of 6
#>   ..$ 0:List of 5
#>   .. ..$ Id     : int 53040
#>   .. ..$ Start  : int 0
#>   .. ..$ End    : int 1
#>   .. ..$ Surface: chr "に"
#>   .. ..$ Feature: chr [1:9] "助詞" "格助詞" "一般" "*" ...
#>   ..$ 1:List of 5
#>   .. ..$ Id     : int 80172
#>   .. ..$ Start  : int 1
#>   .. ..$ End    : int 3
#>   .. ..$ Surface: chr "わに"
#>   .. ..$ Feature: chr [1:9] "名詞" "一般" "*" "*" ...
#>   ..$ 2:List of 5
#>   .. ..$ Id     : int 58916
#>   .. ..$ Start  : int 3
#>   .. ..$ End    : int 6
#>   .. ..$ Surface: chr "はにわ"
#>   .. ..$ Feature: chr [1:9] "名詞" "一般" "*" "*" ...
#>   ..$ 3:List of 5
#>   .. ..$ Id     : int 53999
#>   .. ..$ Start  : int 6
#>   .. ..$ End    : int 10
#>   .. ..$ Surface: chr "にわとり"
#>   .. ..$ Feature: chr [1:9] "名詞" "一般" "*" "*" ...
#>   ..$ 4:List of 5
#>   .. ..$ Id     : int 19676
#>   .. ..$ Start  : int 10
#>   .. ..$ End    : int 11
#>   .. ..$ Surface: chr "が"
#>   .. ..$ Feature: chr [1:9] "助詞" "格助詞" "一般" "*" ...
#>   ..$ 5:List of 5
#>   .. ..$ Id     : int 6652
#>   .. ..$ Start  : int 11
#>   .. ..$ End    : int 13
#>   .. ..$ Surface: chr "いる"
#>   .. ..$ Feature: chr [1:9] "動詞" "自立" "*" "*" ...
```

### Prettify Output

``` r
res <- RcppKagome::kagome(c("庭に埴輪に輪と李がいる", "庭には二羽鶏がいる"))
res <- RcppKagome::prettify(res)
print(res)
#>    sentence_id token POS1     POS2   POS3 POS4 X5StageUse1 X5StageUse2 Original
#> 1            1    庭 名詞     一般   <NA> <NA>        <NA>        <NA>       庭
#> 2            1    に 助詞   格助詞   一般 <NA>        <NA>        <NA>       に
#> 3            1  埴輪 名詞     一般   <NA> <NA>        <NA>        <NA>     埴輪
#> 4            1    に 助詞   格助詞   一般 <NA>        <NA>        <NA>       に
#> 5            1    輪 名詞     一般   <NA> <NA>        <NA>        <NA>       輪
#> 6            1    と 助詞 並立助詞   <NA> <NA>        <NA>        <NA>       と
#> 7            1    李 名詞 固有名詞   人名   姓        <NA>        <NA>       李
#> 8            1    が 助詞   格助詞   一般 <NA>        <NA>        <NA>       が
#> 9            1  いる 動詞     自立   <NA> <NA>        一段      基本形     いる
#> 10           2    庭 名詞     一般   <NA> <NA>        <NA>        <NA>       庭
#> 11           2    に 助詞   格助詞   一般 <NA>        <NA>        <NA>       に
#> 12           2    は 助詞   係助詞   <NA> <NA>        <NA>        <NA>       は
#> 13           2    二 名詞       数   <NA> <NA>        <NA>        <NA>       二
#> 14           2    羽 名詞     接尾 助数詞 <NA>        <NA>        <NA>       羽
#> 15           2    鶏 名詞     一般   <NA> <NA>        <NA>        <NA>       鶏
#> 16           2    が 助詞   格助詞   一般 <NA>        <NA>        <NA>       が
#> 17           2  いる 動詞     自立   <NA> <NA>        一段      基本形     いる
#>       Yomi1    Yomi2
#> 1      ニワ     ニワ
#> 2        ニ       ニ
#> 3    ハニワ   ハニワ
#> 4        ニ       ニ
#> 5        ワ       ワ
#> 6        ト       ト
#> 7        リ       リ
#> 8        ガ       ガ
#> 9      イル     イル
#> 10     ニワ     ニワ
#> 11       ニ       ニ
#> 12       ハ       ワ
#> 13       ニ       ニ
#> 14       ワ       ワ
#> 15 ニワトリ ニワトリ
#> 16       ガ       ガ
#> 17     イル     イル
```

Prettified output has these columns.

-   sentence\_id: 文番号（sentence index）
-   token: 表層形 (surface form)
-   POS1\~POS4: 品詞, 品詞細分類1, 品詞細分類2, 品詞細分類3
-   X5StageUse1: 活用型（ex. 五段, 下二段…）
-   X5StageUse2: 活用形（ex. 連用形, 基本形…）
-   Original: 原形（lemmatised form）
-   Yomi1: 読み（readings）
-   Yomi2: 発音（pronunciation）

## Code of Conduct

Please note that the RcppKagome project is released with a [Contributor
Code of
Conduct](https://paithiov909.github.io/RcppKagome/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## License

MIT license.

Icons made by [Freepik](http://www.freepik.com/) from
[www.flaticon.com](https://www.flaticon.com/).
