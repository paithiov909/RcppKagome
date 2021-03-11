---
title: "About RcppKagome package"
date: "2021-03-10"
output: rmarkdown::html_vignette
header-includes:
  - \usepackage[utf8]{inputenc}
vignette: >
  %\VignetteIndexEntry{About RcppKagome package}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



[![paithiov909/RcppKagome - GitHub](https://gh-card.dev/repos/paithiov909/RcppKagome.svg)](https://github.com/paithiov909/RcppKagome)

## これは何？

Rで形態素解析するためのパッケージです。[Pure Goで辞書同梱な形態素解析器](https://qiita.com/ikawaha/items/ff27ac03e22b7f36811b)として知られる[ikawaha/kagome](https://github.com/ikawaha/kagome)をラップしています。

## 使い方

### インストール

ソースからビルドします。makeとGCCとGoが必要です。

``` r
if (!requireNamespace("async", "kagomer")) {
  remotes::install_github("gaborcsardi/async")
  remotes::install_github("paithiov909/kagomer")
}
remotes::install_github("paithiov909/RcppKagome")
```

### 形態素解析

character vectorを渡せます。戻り値はリストです。


```r
res <- RcppKagome::kagome("雨にも負けず　風にも負けず")
str(res)
#> List of 1
#>  $ :List of 11
#>   ..$ 0 :List of 5
#>   .. ..$ Id     : int 376225
#>   .. ..$ Start  : int 0
#>   .. ..$ End    : int 1
#>   .. ..$ Surface: chr "雨"
#>   .. ..$ Feature: chr [1:9] "名詞" "一般" "*" "*" ...
#>   ..$ 1 :List of 5
#>   .. ..$ Id     : int 53040
#>   .. ..$ Start  : int 1
#>   .. ..$ End    : int 2
#>   .. ..$ Surface: chr "に"
#>   .. ..$ Feature: chr [1:9] "助詞" "格助詞" "一般" "*" ...
#>   ..$ 2 :List of 5
#>   .. ..$ Id     : int 73244
#>   .. ..$ Start  : int 2
#>   .. ..$ End    : int 3
#>   .. ..$ Surface: chr "も"
#>   .. ..$ Feature: chr [1:9] "助詞" "係助詞" "*" "*" ...
#>   ..$ 3 :List of 5
#>   .. ..$ Id     : int 352000
#>   .. ..$ Start  : int 3
#>   .. ..$ End    : int 5
#>   .. ..$ Surface: chr "負け"
#>   .. ..$ Feature: chr [1:9] "動詞" "自立" "*" "*" ...
#>   ..$ 4 :List of 5
#>   .. ..$ Id     : int 36553
#>   .. ..$ Start  : int 5
#>   .. ..$ End    : int 6
#>   .. ..$ Surface: chr "ず"
#>   .. ..$ Feature: chr [1:9] "助動詞" "*" "*" "*" ...
#>   ..$ 5 :List of 5
#>   .. ..$ Id     : int 95
#>   .. ..$ Start  : int 6
#>   .. ..$ End    : int 7
#>   .. ..$ Surface: chr "　"
#>   .. ..$ Feature: chr [1:9] "記号" "空白" "*" "*" ...
#>   ..$ 6 :List of 5
#>   .. ..$ Id     : int 380203
#>   .. ..$ Start  : int 7
#>   .. ..$ End    : int 8
#>   .. ..$ Surface: chr "風"
#>   .. ..$ Feature: chr [1:9] "名詞" "一般" "*" "*" ...
#>   ..$ 7 :List of 5
#>   .. ..$ Id     : int 53040
#>   .. ..$ Start  : int 8
#>   .. ..$ End    : int 9
#>   .. ..$ Surface: chr "に"
#>   .. ..$ Feature: chr [1:9] "助詞" "格助詞" "一般" "*" ...
#>   ..$ 8 :List of 5
#>   .. ..$ Id     : int 73244
#>   .. ..$ Start  : int 9
#>   .. ..$ End    : int 10
#>   .. ..$ Surface: chr "も"
#>   .. ..$ Feature: chr [1:9] "助詞" "係助詞" "*" "*" ...
#>   ..$ 9 :List of 5
#>   .. ..$ Id     : int 352000
#>   .. ..$ Start  : int 10
#>   .. ..$ End    : int 12
#>   .. ..$ Surface: chr "負け"
#>   .. ..$ Feature: chr [1:9] "動詞" "自立" "*" "*" ...
#>   ..$ 10:List of 5
#>   .. ..$ Id     : int 36553
#>   .. ..$ Start  : int 12
#>   .. ..$ End    : int 13
#>   .. ..$ Surface: chr "ず"
#>   .. ..$ Feature: chr [1:9] "助動詞" "*" "*" "*" ...
```

結果をデータフレームに整形できます。


```r
res <- RcppKagome::kagome(
  c(
    "陽が照って鳥が啼き　あちこちの楢の林も、けむるとき",
    "ぎちぎちと鳴る　汚い掌を、おれはこれからもつことになる"
  )
)
res <- RcppKagome::prettify(res)
print(res)
#>    sentence_id    token   POS1       POS2     POS3 POS4      X5StageUse1 X5StageUse2 Original
#> 1            1       陽   名詞       一般     <NA> <NA>             <NA>        <NA>       陽
#> 2            1       が   助詞     格助詞     一般 <NA>             <NA>        <NA>       が
#> 3            1     照っ   動詞       自立     <NA> <NA>       五段・ラ行  連用タ接続     照る
#> 4            1       て   助詞   接続助詞     <NA> <NA>             <NA>        <NA>       て
#> 5            1       鳥   名詞       一般     <NA> <NA>             <NA>        <NA>       鳥
#> 6            1       が   助詞     格助詞     一般 <NA>             <NA>        <NA>       が
#> 7            1     啼き   動詞       自立     <NA> <NA> 五段・カ行イ音便      連用形     啼く
#> 8            1       　   記号       空白     <NA> <NA>             <NA>        <NA>       　
#> 9            1 あちこち   名詞     代名詞     一般 <NA>             <NA>        <NA> あちこち
#> 10           1       の   助詞     連体化     <NA> <NA>             <NA>        <NA>       の
#> 11           1       楢   名詞       一般     <NA> <NA>             <NA>        <NA>       楢
#> 12           1       の   助詞     連体化     <NA> <NA>             <NA>        <NA>       の
#> 13           1       林   名詞       一般     <NA> <NA>             <NA>        <NA>       林
#> 14           1       も   助詞     係助詞     <NA> <NA>             <NA>        <NA>       も
#> 15           1       、   記号       読点     <NA> <NA>             <NA>        <NA>       、
#> 16           1   けむる   動詞       自立     <NA> <NA>       五段・ラ行      基本形   けむる
#> 17           1     とき   名詞     非自立 副詞可能 <NA>             <NA>        <NA>     とき
#> 18           2 ぎちぎち   副詞       一般     <NA> <NA>             <NA>        <NA> ぎちぎち
#> 19           2       と   助詞     格助詞     一般 <NA>             <NA>        <NA>       と
#> 20           2     鳴る   動詞       自立     <NA> <NA>       五段・ラ行      基本形     鳴る
#> 21           2       　   記号       空白     <NA> <NA>             <NA>        <NA>       　
#> 22           2     汚い 形容詞       自立     <NA> <NA> 形容詞・アウオ段      基本形     汚い
#> 23           2       掌   名詞       一般     <NA> <NA>             <NA>        <NA>       掌
#> 24           2       を   助詞     格助詞     一般 <NA>             <NA>        <NA>       を
#> 25           2       、   記号       読点     <NA> <NA>             <NA>        <NA>       、
#> 26           2     おれ   名詞     代名詞     一般 <NA>             <NA>        <NA>     おれ
#> 27           2       は   助詞     係助詞     <NA> <NA>             <NA>        <NA>       は
#> 28           2 これから   副詞 助詞類接続     <NA> <NA>             <NA>        <NA> これから
#> 29           2     もつ   動詞       自立     <NA> <NA>       五段・タ行      基本形     もつ
#> 30           2     こと   名詞     非自立     一般 <NA>             <NA>        <NA>     こと
#> 31           2       に   助詞     格助詞     一般 <NA>             <NA>        <NA>       に
#> 32           2     なる   動詞       自立     <NA> <NA>       五段・ラ行      基本形     なる
#>         Yomi1      Yomi2
#> 1          ヒ         ヒ
#> 2          ガ         ガ
#> 3        テッ       テッ
#> 4          テ         テ
#> 5        トリ       トリ
#> 6          ガ         ガ
#> 7        ナキ       ナキ
#> 8          　         　
#> 9    アチコチ   アチコチ
#> 10         ノ         ノ
#> 11       ナラ       ナラ
#> 12         ノ         ノ
#> 13     ハヤシ     ハヤシ
#> 14         モ         モ
#> 15         、         、
#> 16     ケムル     ケムル
#> 17       トキ       トキ
#> 18   ギチギチ   ギチギチ
#> 19         ト         ト
#> 20       ナル       ナル
#> 21         　         　
#> 22   キタナイ   キタナイ
#> 23 タナゴコロ タナゴコロ
#> 24         ヲ         ヲ
#> 25         、         、
#> 26       オレ       オレ
#> 27         ハ         ワ
#> 28   コレカラ   コレカラ
#> 29       モツ       モツ
#> 30       コト       コト
#> 31         ニ         ニ
#> 32       ナル       ナル
```

整形されたデータフレームは次のカラムからなります。

- sentence_id: 文番号（sentence index）
- token: 表層形（surface form）
- POS1~POS4: 品詞, 品詞細分類1, 品詞細分類2, 品詞細分類3
- X5StageUse1: 活用型（ex. 五段, 下二段…）
- X5StageUse2: 活用形（ex. 連用形, 終止形…）
- Original: 原形（lemmatised form）
- Yomi1: 読み（readings）
- Yomi2: 発音（pronunciation）

このうちtoken列だけを半角スペースでcollapseして返す（分かち書きにする）ことができます。


```r
RcppKagome::pack_df(res)
#>   doc_id                                                                 text
#> 1      1   陽 が 照っ て 鳥 が 啼き 　 あちこち の 楢 の 林 も 、 けむる とき
#> 2      2 ぎちぎち と 鳴る 　 汚い 掌 を 、 おれ は これから もつ こと に なる
```

なお、`prettify`を経由しなくても同じかたちのデータフレームを得ることができます。


```r
RcppKagome::kagome("雨にも負けず　風にも負けず") %>%
  RcppKagome::pack_list()
#>   doc_id                                 text
#> 1      1 雨 に も 負け ず 　 風 に も 負け ず
```

### Web APIの利用

サーバーコマンドを非同期で叩くことができます。kagomeのサーバーモードの利用の仕方については公式の案内にしたがってください。
デフォルトでは環境変数`KAGOME_URL`に設定したURLにアクセスします。`Sys.setenv(KAGOME_URL = "http://localhost:6060")`などとして環境変数を設定するか、アクセスしたいURLを`RcppKagome::queue(url = "http://localhost:6060")`のように明示的に指定してください。


```r
library(RcppKagome)
#> 
#> Attaching package: 'RcppKagome'
#> The following object is masked from 'package:base':
#> 
#>     serialize

sentences <- c(
  "激しい激しい熱や喘ぎのあいだから、お前は私に頼んだのだ",
  "銀河や太陽、気圏などと呼ばれた世界の　空から落ちた雪の最後の一碗を"
)

sentences %>%
  RcppKagome::serialize() %>%
  RcppKagome::queue() %>%
  RcppKagome::kick() %>%
  RcppKagome::pack_df("surface")
#>   doc_id                                                                                      text
#> 1      1                    激しい 激しい 熱 や 喘ぎ の あいだ から 、 お前 は 私 に 頼ん だ の だ
#> 2      2 銀河 や 太陽 、 気圏 など と 呼ば れ た 世界 の 　 空 から 落ち た 雪 の 最後 の 一 碗 を
```

## 速度比較

RMeCab、RcppMeCabと速度比較しています。

- [paithiov909/RcppKagome](https://github.com/paithiov909/RcppKagome)
  - RcppKagome::kagome
- [IshidaMotohiro/RMeCab](https://github.com/IshidaMotohiro/RMeCab)
  - RMeCab::RMeCabC
- [junhewk/RcppMeCab](https://github.com/junhewk/RcppMeCab)
  - RcppMeCab::pos
  - RcppMeCab::posParallel

### 単文を渡す場合

単文の解析速度としてはRMeCabなどと比較してとくに遅いということはないはずです。

![bench-plot-1](https://raw.githack.com/paithiov909/RcppKagome/main/man/figures/README-bench-plot-1-1.png)

### 複数の文を渡す場合

ベクトルを渡す場合、ふつうに使うかぎりではRcppMeCabのほうが速いと思われます。なお、`RMeCab::RMeCabC`は長さが1のベクトル（character scalar）しか受けつけないため、ここでは`purrr::map`でラップして比較しています。

このような結果になる理由として、RcppMeCabはC++のレベルでvectorizeされているという点があります。`RcppMeCab::pos`はMeCabのタガーインスタンスを一つだけつくってそれぞれの文をひとつずつ解析する処理を繰り返します。一方で、`RcppMeCab::posParallel`はマルチスレッドで、スレッドごとにMeCabのタガーインスタンスを生成します。いずれにせよ、RcppMeCabではベクトルを与えられた場合、各文の解析に用いるタガーを内部的に使いまわしています。形態素解析をするライブラリでは一般にタガーインスタンスの生成はコストが高い処理であるため、解析の際にタガーの生成が繰り返されるとそれがネックになって、解析に時間がかかります（これはRcppMeCabだけについてみても同様で、たとえばスレッドごとに処理する文の分量が極端に少ない場合、個々の文の解析にかかる時間の割にインスタンスの生成にコストが割かれることになって、`RcppMeCab::pos`より`RcppMeCab::posParallel`のほうがかえってパフォーマンスが悪化することがあります）。

RMeCabやRcppKagomeではベクトルの要素ごとにタガーの生成を繰り返す必要があるため、実用上はおそらくRcppMeCabに比べて遅くなります。

![bench-plot-2](https://raw.githack.com/paithiov909/RcppKagome/main/man/figures/README-bench-plot-2-1.png)

## RとGoの連携について

日本語情報としては以下の記事があります。

- [RからGoの関数をつかう→はやい - ★データ解析備忘録★](https://y-mattu.hatenablog.com/entry/2019/05/20/232340)

この記事はもともとRomain Francois氏（RcppとかrJavaとかの開発にかかわっているスゴい人らしい）が書いたブログ記事を参考にしているものです。

Goには`cgo`というコマンドが用意されていて、Goで書かれたコードをC言語から利用するためのライブラリにすることができます。この機能を利用して生成したC言語向けのライブラリをRパッケージから呼び出すことで、いちおうはGoの資産をRから利用することができます。

本来、Cなどで書かれた関数をRパッケージで直接呼ぶためには`.Call`を使って呼べる状態にするために関数の`registration`という操作が必要になります。この手間を省略するために、RcppKagomeではcgoで生成したライブラリをC++から利用するラッパーを書いて、それをRcppでエクスポートしています。

また、より便利に扱うためにはGoとのあいだに型マッピングを定義するのが望ましいのでしょうが、RcppKagomeではその点については深入りせず、文字列だけを受け渡しするようにしています。参考までに、Goとのあいだに型マッピングが定義されているほかの例を挙げておきます。

- [rgonomic/rgo: R/Go integration](https://github.com/rgonomic/rgo)
- [EMurray16/Rgo: Connecting R and Go](https://github.com/EMurray16/Rgo)

## セッション情報


```r
sessioninfo::session_info()
#> - Session info ----------------------------------------------------------------------------------
#>  setting  value                       
#>  version  R version 4.0.2 (2020-06-22)
#>  os       Windows 10 x64              
#>  system   x86_64, mingw32             
#>  ui       RStudio                     
#>  language (EN)                        
#>  collate  Japanese_Japan.932          
#>  ctype    Japanese_Japan.932          
#>  tz       Asia/Tokyo                  
#>  date     2021-03-10                  
#> 
#> - Packages --------------------------------------------------------------------------------------
#>  package     * version    date       lib source                              
#>  assertthat    0.2.1      2019-03-21 [1] CRAN (R 4.0.2)                      
#>  async         0.0.0.9004 2021-03-03 [1] Github (gaborcsardi/async@e6af7be)  
#>  backports     1.2.1      2020-12-09 [1] CRAN (R 4.0.3)                      
#>  bslib         0.2.4      2021-01-25 [1] CRAN (R 4.0.3)                      
#>  callr         3.5.1      2020-10-13 [1] CRAN (R 4.0.3)                      
#>  cli           2.3.1      2021-02-23 [1] CRAN (R 4.0.2)                      
#>  codetools     0.2-18     2020-11-04 [1] CRAN (R 4.0.3)                      
#>  crayon        1.4.1      2021-02-08 [1] CRAN (R 4.0.2)                      
#>  curl          4.3        2019-12-02 [1] CRAN (R 4.0.3)                      
#>  DBI           1.1.1      2021-01-15 [1] CRAN (R 4.0.3)                      
#>  digest        0.6.27     2020-10-24 [1] CRAN (R 4.0.3)                      
#>  dplyr         1.0.4      2021-02-02 [1] CRAN (R 4.0.3)                      
#>  ellipsis      0.3.1      2020-05-15 [1] CRAN (R 4.0.2)                      
#>  evaluate      0.14       2019-05-28 [1] CRAN (R 4.0.2)                      
#>  fansi         0.4.2      2021-01-15 [1] CRAN (R 4.0.3)                      
#>  furrr         0.2.2      2021-01-29 [1] CRAN (R 4.0.2)                      
#>  future        1.21.0     2020-12-10 [1] CRAN (R 4.0.3)                      
#>  generics      0.1.0      2020-10-31 [1] CRAN (R 4.0.3)                      
#>  globals       0.14.0     2020-11-22 [1] CRAN (R 4.0.3)                      
#>  glue          1.4.2      2020-08-27 [1] CRAN (R 4.0.3)                      
#>  hms           1.0.0      2021-01-13 [1] CRAN (R 4.0.3)                      
#>  htmltools     0.5.1.1    2021-01-22 [1] CRAN (R 4.0.3)                      
#>  jquerylib     0.1.3      2020-12-17 [1] CRAN (R 4.0.3)                      
#>  jsonlite      1.7.2      2020-12-09 [1] CRAN (R 4.0.3)                      
#>  kagomer       0.0.1.900  2021-03-06 [1] Github (paithiov909/kagomer@c402470)
#>  knitr         1.31       2021-01-27 [1] CRAN (R 4.0.3)                      
#>  lifecycle     1.0.0      2021-02-15 [1] CRAN (R 4.0.2)                      
#>  listenv       0.8.0      2019-12-05 [1] CRAN (R 4.0.2)                      
#>  magrittr      2.0.1      2020-11-17 [1] CRAN (R 4.0.3)                      
#>  parallelly    1.23.0     2021-01-04 [1] CRAN (R 4.0.3)                      
#>  pillar        1.5.0      2021-02-22 [1] CRAN (R 4.0.2)                      
#>  pkgconfig     2.0.3      2019-09-22 [1] CRAN (R 4.0.2)                      
#>  processx      3.4.5      2020-11-30 [1] CRAN (R 4.0.3)                      
#>  ps            1.6.0      2021-02-28 [1] CRAN (R 4.0.2)                      
#>  purrr       * 0.3.4      2020-04-17 [1] CRAN (R 4.0.2)                      
#>  R.cache       0.14.0     2019-12-06 [1] CRAN (R 4.0.3)                      
#>  R.methodsS3   1.8.1      2020-08-26 [1] CRAN (R 4.0.3)                      
#>  R.oo          1.24.0     2020-08-26 [1] CRAN (R 4.0.3)                      
#>  R.utils       2.10.1     2020-08-26 [1] CRAN (R 4.0.3)                      
#>  R6            2.5.0      2020-10-28 [1] CRAN (R 4.0.3)                      
#>  Rcpp          1.0.6      2021-01-15 [1] CRAN (R 4.0.3)                      
#>  RcppKagome  * 0.0.1.900  2021-03-06 [1] local                               
#>  readr         1.4.0      2020-10-05 [1] CRAN (R 4.0.3)                      
#>  rlang         0.4.10     2020-12-30 [1] CRAN (R 4.0.3)                      
#>  rmarkdown     2.7        2021-02-19 [1] CRAN (R 4.0.2)                      
#>  sass          0.3.1      2021-01-24 [1] CRAN (R 4.0.3)                      
#>  sessioninfo   1.1.1      2018-11-05 [1] CRAN (R 4.0.2)                      
#>  stringi       1.5.3      2020-09-09 [1] CRAN (R 4.0.3)                      
#>  stringr       1.4.0      2019-02-10 [1] CRAN (R 4.0.2)                      
#>  styler        1.3.2      2020-02-23 [1] CRAN (R 4.0.3)                      
#>  tibble        3.1.0      2021-02-25 [1] CRAN (R 4.0.2)                      
#>  tidyselect    1.1.0      2020-05-11 [1] CRAN (R 4.0.2)                      
#>  utf8          1.1.4      2018-05-24 [1] CRAN (R 4.0.2)                      
#>  uuid          0.1-4      2020-02-26 [1] CRAN (R 4.0.3)                      
#>  vctrs         0.3.6      2020-12-17 [1] CRAN (R 4.0.3)                      
#>  withr         2.4.1      2021-01-26 [1] CRAN (R 4.0.3)                      
#>  xfun          0.21       2021-02-10 [1] CRAN (R 4.0.2)                      
#>  yaml          2.2.1      2020-02-01 [1] CRAN (R 4.0.0)                      
#> 
#> [1] C:/Users/user/Documents/R/win-library/4.0
#> [2] C:/Program Files/R/R-4.0.2/library
```

