---
title: "Text analysis using quanteda and RcppKagome"
date: "2021-03-11"
output: rmarkdown::html_vignette
header-includes:
  - \usepackage[utf8]{inputenc}
vignette: >
  %\VignetteIndexEntry{Text analysis using quanteda and RcppKagome}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



## この記事について

[{quanteda}](https://github.com/quanteda/quanteda)と[{RcppKagome}](https://github.com/paithiov909/RcppKagome)を用いたテキストマイニングの例です（[{googledrive}](https://github.com/tidyverse/googledrive)を利用して自作の文章を分析していた過去記事については[Qiitaのログ](https://qiita.com/paithiov909/items/a47a097836e8a9ec12ef/revisions)（revision < 10）から参照してください）。

なお、以下のパッケージについては、ここではGitHubからインストールできるものを使っています。

- [uribo/zipangu](https://github.com/uribo/zipangu)
- [paithiov909/ldccr](https://github.com/paithiov909/ldccr)
- [paithiov909/RcppKagome](https://github.com/paithiov909/RcppKagome)

## データの準備

テキストデータとして[livedoorニュースコーパス](https://www.rondhuit.com/download.html#ldcc)を使います。以下の9カテゴリです。

- トピックニュース
- Sports Watch
- ITライフハック
- 家電チャンネル
- MOVIE ENTER
- 独女通信
- エスマックス
- livedoor HOMME
- Peachy

[{ldccr}](https://github.com/paithiov909/ldccr)でデータフレームにします。


```r
data <- ldccr::parse_ldcc(exdir = "cache")
#> Parsing dokujo-tsushin...
#> Parsing it-life-hack...
#> Parsing kaden-channel...
#> Parsing livedoor-homme...
#> Parsing movie-enter...
#> Parsing peachy...
#> Parsing smax...
#> Parsing sports-watch...
#> Parsing topic-news...
#> Done.
```

このうち一部だけをquantedaのコーパスオブジェクトとして格納し、いろいろ試していきます。


```r
corp <- data %>%
  dplyr::sample_frac(size = .1)

corp <- corp %>%
  dplyr::pull("body") %>%
  stringr::str_remove_all("[[:punct:]]+") %>%
  zipangu::str_jnormalize() %>%
  RcppKagome::kagome() %>%
  RcppKagome::pack_list() %>%
  dplyr::bind_cols(corp) %>%
  quanteda::corpus()
```

## ワードクラウド

ストップワードとして`rtweet::stopwordslangs`を利用しています。


```r
stopwords <- rtweet::stopwordslangs %>%
  dplyr::filter(lang == "ja") %>%
  dplyr::filter(p >= .98) %>%
  dplyr::pull(word)

corp %>%
  quanteda::tokens(what = "word") %>%
  quanteda::tokens_remove(stopwords, valuetype = "fixed") %>%
  quanteda::dfm(groups = "category") %>%
  quanteda::dfm_trim(min_termfreq = 10L) %>%
  quanteda.textplots::textplot_wordcloud(color = viridis::cividis(8L))
```

![wordcloud-1](https://raw.githack.com/paithiov909/RcppKagome/main/docs/articles/demo_ja_files/figure-html/wordcloud-1.png)

## 出現頻度の集計


```r
corp %>%
  quanteda::tokens(what = "word") %>%
  quanteda::tokens_remove(stopwords, valuetype = "fixed") %>%
  quanteda::dfm() %>%
  quanteda::dfm_weight("prop") %>%
  quanteda::textstat_frequency(groups = "category") %>%
  dplyr::top_n(-30L, rank) %>%
  ggpubr::ggdotchart(
    x = "feature",
    y = "frequency",
    group = "group",
    color = "group",
    rotate = TRUE
  ) +
  ggplot2::theme_bw()
```

![stats-1](https://raw.githack.com/paithiov909/RcppKagome/main/docs/articles/demo_ja_files/figure-html/stats-1.png)

## Keyness

ITライフハック（`it-life-hack`）グループの文書とその他の対照を見ています。


```r
corp %>%
  quanteda::tokens(what = "word") %>%
  quanteda::tokens_remove(stopwords, valuetype = "fixed") %>%
  quanteda::dfm(groups = "category") %>%
  quanteda.textstats::textstat_keyness(target = "it-life-hack") %>%
  quanteda.textplots::textplot_keyness()
#> Registered S3 methods overwritten by 'quanteda.textstats':
#>   method                       from    
#>   [.textstat                   quanteda
#>   as.data.frame.textstat_proxy quanteda
#>   as.list.textstat_proxy       quanteda
#>   head.textstat_proxy          quanteda
#>   tail.textstat_proxy          quanteda
```

![keyness-1](https://raw.githack.com/paithiov909/RcppKagome/main/docs/articles/demo_ja_files/figure-html/keyness-1.png)

## 対応分析

全部をプロットすると潰れて見えないので一部だけを抽出しています。


```r
corp_sample <- quanteda::corpus_sample(corp, size = 32L)
corp_sample %>%
  quanteda::tokens(what = "word") %>%
  quanteda::tokens_remove(stopwords, valuetype = "fixed") %>%
  quanteda::dfm() %>%
  quanteda::dfm_weight(scheme = "prop") %>%
  quanteda.textmodels::textmodel_ca() %>%
  quanteda.textplots::textplot_scale1d(
    margin = "documents",
    groups = quanteda::docvars(corp_sample, "category")
  )
```

![ca-1](https://raw.githack.com/paithiov909/RcppKagome/main/docs/articles/demo_ja_files/figure-html/ca-1.png)

## 共起ネットワーク


```r
corp %>%
  quanteda::tokens(what = "word") %>%
  quanteda::tokens_remove(stopwords, valuetype = "fixed") %>%
  quanteda::dfm(groups = "category") %>%
  quanteda::dfm_trim(min_termfreq = 100L) %>%
  quanteda::fcm() %>%
  quanteda.textplots::textplot_network(min_freq = .96)
#> Warning: ggrepel: 67 unlabeled data points (too many overlaps). Consider increasing max.overlaps
```

![network-1](https://raw.githack.com/paithiov909/RcppKagome/main/docs/articles/demo_ja_files/figure-html/network-1.png)

## クラスタリング

マンハッタン距離、ward法（ward.D2）です。ここでも一部だけを抽出しています。


```r
d <- corp_sample %>%
  quanteda::tokens(what = "word") %>%
  quanteda::tokens_remove(stopwords, valuetype = "fixed") %>%
  quanteda::dfm() %>%
  quanteda::dfm_weight(scheme = "prop") %>%
  quanteda.textstats::textstat_dist(method = "manhattan") %>%
  as.dist() %>%
  hclust(method = "ward.D2") %>%
  ggdendro::dendro_data(type = "rectangle") %>%
  purrr::list_modify(
    labels = dplyr::bind_cols(
      .$labels,
      names = names(corp_sample),
      category = quanteda::docvars(corp_sample, "category")
    )
  )

ggplot2::ggplot(ggdendro::segment(d)) +
  ggplot2::geom_segment(aes(x = x, y = y, xend = xend, yend = yend)) +
  ggplot2::geom_text(ggdendro::label(d), mapping = aes(x, y, label = names, colour = category, hjust = 0), size = 3) +
  ggplot2::coord_flip() +
  ggplot2::scale_y_reverse(expand = c(.2, 0)) +
  ggdendro::theme_dendro()
```

![clust-1](https://raw.githack.com/paithiov909/RcppKagome/main/docs/articles/demo_ja_files/figure-html/clust-1.png)

## LDA（Latent Dirichlet Allocation）


```r
dtm <- corp %>%
  quanteda::tokens(what = "word") %>%
  quanteda::tokens_remove(stopwords, valuetype = "fixed") %>%
  quanteda::dfm() %>%
  quanteda::dfm_tfidf()

features <- corp %>%
  quanteda::tokens(what = "word") %>%
  quanteda::tokens_remove(stopwords, valuetype = "fixed") %>%
  quanteda::dfm() %>%
  quanteda::ntoken()

m <- dtm %>%
  as("dgCMatrix") %>%
  textmineR::FitLdaModel(k = 9, iterations = 200, burnin = 175)

m$phi %>%
  textmineR::GetTopTerms(15L) %>%
  knitr::kable()
```



|t_1        |t_2        |t_3        |t_4          |t_5          |t_6            |t_7        |t_8        |t_9      |
|:----------|:----------|:----------|:------------|:------------|:--------------|:----------|:----------|:--------|
|賞         |ニコニコ   |ipad       |ゴルフ       |フォン       |灸             |選手       |転職       |画面     |
|ビスケット |町         |通         |肌           |スマート     |沢尻           |試合       |韓国       |クリック |
|★         |占い       |iphone     |孫           |optimus      |ケーキ         |五輪       |男性       |表示     |
|主演       |結納       |ubuntu     |美容         |htc          |当選           |ディーゼル |独         |起動     |
|ピラニア   |会議       |デジタル   |八重歯       |コモ         |クリスマス     |★         |妄想       |ファイル |
|チーズ     |安田       |キーボード |トレーニング |ソフトウェア |婚             |本田       |求人       |作成     |
|ヘルプ     |展         |ロゴ       |メイク       |sh           |エリカ         |サッカー   |みなみ     |パソコン |
|監督       |三春       |ジ         |ケア         |機種         |上映           |大会       |高橋       |firefox  |
|女優       |剣         |電子       |クリーム     |搭載         |祭             |ファンド   |有吉       |google   |
|演じる     |番組       |書籍       |票           |smax         |アベンジャーズ |長友       |企業       |ssd      |
|役         |カク       |windows    |渓流         |galaxy       |レット         |番組       |ボーナス   |リスト   |
|movie      |サトコ     |使える     |デート       |au           |現象           |監督       |ツイッター |虎の巻   |
|良子       |フィリピン |解像度     |ブランド     |android      |チョコレート   |ロンドン   |籠谷       |hdd      |
|麻里       |おまじない |ビデオ     |社長         |対応         |活             |ガブリエラ |意見       |データ   |
|ストーリー |バツ       |タブレット |カラー       |モデル       |ホテル         |広島       |年収       |excel    |

LDAvisで可視化してみます。ただ、LDAvisはもうしばらくメンテナンスされていないパッケージで、ちょっと挙動があやしいところがあります。たとえば、デフォルトロケールがCP932であるWindows環境の場合、`LDAvis::createJSON`で書き出されるラベル（vocab）のエンコーディングがそっちに引きずられてCP932になってしまうため、ブラウザで表示したときにラベルが文字化けします。書き出されたlda.jsonをUTF-8に変換すれば文字化けは解消されるので、とりあえずあとから変換して上書きするとよいです。


```r
LDAvis::createJSON(
  phi = m$phi,
  theta = m$theta,
  doc.length = features,
  vocab = stringi::stri_enc_toutf8(dtm@Dimnames$features),
  term.frequency = quanteda::colSums(dtm)
) %>%
  LDAvis::serVis(open.browser = FALSE, out.dir = file.path(getwd(), "cache/ldavis"))
#> Warning in dir.create(out.dir): 'C:\Users\user\Documents\GitHub\RcppKagome\vignettes\cache\ldavis'
#> はすでに存在します
#> Loading required namespace: servr

readr::read_lines_raw(file.path(getwd(), "cache/ldavis", "lda.json")) %>%
  iconv(from = "CP932", to = "UTF-8") %>%
  jsonlite::parse_json(simplifyVector = TRUE) %>%
  jsonlite::write_json(file.path(getwd(), "cache/ldavis", "lda.json"), dataframe = "columns", auto_unbox = TRUE)
```



> [LDAvis](https://paithiov909.github.io/RcppKagome/ldavis/index.html)

## GloVe

ここでは50次元の埋め込みを得ます。


```r
toks <- corp %>%
  quanteda::tokens(what = "word") %>%
  as.list() %>%
  text2vec::itoken()

vocab <- toks %>%
  text2vec::create_vocabulary() %>%
  text2vec::prune_vocabulary(term_count_min = 10L)

vectorize <- text2vec::vocab_vectorizer(vocab)

tcm <- text2vec::create_tcm(
  it = toks,
  vectorizer = vectorize,
  skip_grams_window = 5L
)

glove <- text2vec::GlobalVectors$new(
  rank = 50,
  x_max = 15L
)

wv <- glove$fit_transform(
  x = tcm,
  n_iter = 10L
) %>%
  as.data.frame(stringsAsFactors = FALSE) %>%
  tibble::as_tibble(.name_repair = "minimal", rownames = NA)
#> INFO  [20:59:10.694] epoch 1, loss 0.1802 
#> INFO  [20:59:11.927] epoch 2, loss 0.1007 
#> INFO  [20:59:13.231] epoch 3, loss 0.0833 
#> INFO  [20:59:14.432] epoch 4, loss 0.0730 
#> INFO  [20:59:15.629] epoch 5, loss 0.0660 
#> INFO  [20:59:16.852] epoch 6, loss 0.0608 
#> INFO  [20:59:18.058] epoch 7, loss 0.0568 
#> INFO  [20:59:19.228] epoch 8, loss 0.0536 
#> INFO  [20:59:20.372] epoch 9, loss 0.0510 
#> INFO  [20:59:21.545] epoch 10, loss 0.0488
```

[{umap}](https://github.com/tkonopka/umap)で次元を減らして可視化します。色は`kmeans`でクラスタリング（コサイン類似度）して付けています。


```r
pull_layout <- function(tbl) {
  umap <- umap::umap(as.matrix(tbl))
  layout <- umap$layout
  rownames(layout) <- rownames(tbl)
  return(as.data.frame(layout))
}

vec <- vocab %>%
  dplyr::anti_join(
    y = tibble::tibble(words = stopwords),
    by = c("term" = "words")
  ) %>%
  dplyr::arrange(desc(term_count)) %>%
  dplyr::slice_head(n = 100L) %>%
  dplyr::left_join(tibble::rownames_to_column(wv), by = c("term" = "rowname")) %>%
  tibble::column_to_rownames("term") %>%
  dplyr::select(starts_with("V"))

dist <- proxyC::simil(as(as.matrix(vec), "dgCMatrix"), method = "cosine")
clust <- kmeans(x = dist, centers = 9)
vec <- pull_layout(vec) %>%
  tibble::rownames_to_column() %>%
  dplyr::mutate(cluster = as.factor(clust$cluster))

vec %>%
  ggplot2::ggplot(aes(x = V1, y = V2, colour = cluster)) +
  ggplot2::geom_point() +
  ggrepel::geom_text_repel(aes(label = rowname)) +
  ggplot2::theme_light()
#> Warning: ggrepel: 76 unlabeled data points (too many overlaps). Consider increasing max.overlaps
```

![umap-1](https://raw.githack.com/paithiov909/RcppKagome/main/docs/articles/demo_ja_files/figure-html/umap-1.png)

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
#>  date     2021-03-11                  
#> 
#> - Packages --------------------------------------------------------------------------------------
#>  package             * version    date       lib source                              
#>  abind                 1.4-5      2016-07-21 [1] CRAN (R 4.0.0)                      
#>  askpass               1.1        2019-01-13 [1] CRAN (R 4.0.2)                      
#>  assertthat            0.2.1      2019-03-21 [1] CRAN (R 4.0.2)                      
#>  async                 0.0.0.9004 2021-03-03 [1] Github (gaborcsardi/async@e6af7be)  
#>  backports             1.2.1      2020-12-09 [1] CRAN (R 4.0.3)                      
#>  broom                 0.7.5      2021-02-19 [1] CRAN (R 4.0.2)                      
#>  bslib                 0.2.4      2021-01-25 [1] CRAN (R 4.0.3)                      
#>  callr                 3.5.1      2020-10-13 [1] CRAN (R 4.0.3)                      
#>  car                   3.0-10     2020-09-29 [1] CRAN (R 4.0.3)                      
#>  carData               3.0-4      2020-05-22 [1] CRAN (R 4.0.0)                      
#>  cellranger            1.1.0      2016-07-27 [1] CRAN (R 4.0.2)                      
#>  cli                   2.3.1      2021-02-23 [1] CRAN (R 4.0.2)                      
#>  coda                  0.19-4     2020-09-30 [1] CRAN (R 4.0.3)                      
#>  codetools             0.2-18     2020-11-04 [1] CRAN (R 4.0.3)                      
#>  colorspace            2.0-0      2020-11-11 [1] CRAN (R 4.0.3)                      
#>  crayon                1.4.1      2021-02-08 [1] CRAN (R 4.0.2)                      
#>  curl                  4.3        2019-12-02 [1] CRAN (R 4.0.3)                      
#>  data.table            1.14.0     2021-02-21 [1] CRAN (R 4.0.2)                      
#>  DBI                   1.1.1      2021-01-15 [1] CRAN (R 4.0.3)                      
#>  dbplyr                2.1.0      2021-02-03 [1] CRAN (R 4.0.2)                      
#>  digest                0.6.27     2020-10-24 [1] CRAN (R 4.0.3)                      
#>  dplyr               * 1.0.5      2021-03-05 [1] CRAN (R 4.0.4)                      
#>  ellipsis              0.3.1      2020-05-15 [1] CRAN (R 4.0.2)                      
#>  evaluate              0.14       2019-05-28 [1] CRAN (R 4.0.2)                      
#>  fansi                 0.4.2      2021-01-15 [1] CRAN (R 4.0.3)                      
#>  farver                2.1.0      2021-02-28 [1] CRAN (R 4.0.2)                      
#>  fastmatch             1.1-0      2017-01-28 [1] CRAN (R 4.0.0)                      
#>  float                 0.2-4      2020-04-22 [1] CRAN (R 4.0.0)                      
#>  forcats             * 0.5.1      2021-01-27 [1] CRAN (R 4.0.2)                      
#>  foreach               1.5.1      2020-10-15 [1] CRAN (R 4.0.3)                      
#>  foreign               0.8-81     2020-12-22 [1] CRAN (R 4.0.3)                      
#>  fs                    1.5.0      2020-07-31 [1] CRAN (R 4.0.3)                      
#>  furrr                 0.2.2      2021-01-29 [1] CRAN (R 4.0.2)                      
#>  future                1.21.0     2020-12-10 [1] CRAN (R 4.0.3)                      
#>  generics              0.1.0      2020-10-31 [1] CRAN (R 4.0.3)                      
#>  ggdendro              0.1.22     2020-09-13 [1] CRAN (R 4.0.3)                      
#>  ggplot2             * 3.3.3      2020-12-30 [1] CRAN (R 4.0.3)                      
#>  ggpubr                0.4.0      2020-06-27 [1] CRAN (R 4.0.2)                      
#>  ggrepel               0.9.1      2021-01-15 [1] CRAN (R 4.0.3)                      
#>  ggsignif              0.6.1      2021-02-23 [1] CRAN (R 4.0.2)                      
#>  glmnet                4.1-1      2021-02-21 [1] CRAN (R 4.0.4)                      
#>  globals               0.14.0     2020-11-22 [1] CRAN (R 4.0.3)                      
#>  glue                  1.4.2      2020-08-27 [1] CRAN (R 4.0.3)                      
#>  gridExtra             2.3        2017-09-09 [1] CRAN (R 4.0.2)                      
#>  gtable                0.3.0      2019-03-25 [1] CRAN (R 4.0.2)                      
#>  haven                 2.3.1      2020-06-01 [1] CRAN (R 4.0.2)                      
#>  highr                 0.8        2019-03-20 [1] CRAN (R 4.0.2)                      
#>  hms                   1.0.0      2021-01-13 [1] CRAN (R 4.0.3)                      
#>  htmltools             0.5.1.1    2021-01-22 [1] CRAN (R 4.0.3)                      
#>  httpuv                1.5.5      2021-01-13 [1] CRAN (R 4.0.3)                      
#>  httr                  1.4.2      2020-07-20 [1] CRAN (R 4.0.3)                      
#>  iterators             1.0.13     2020-10-15 [1] CRAN (R 4.0.3)                      
#>  jquerylib             0.1.3      2020-12-17 [1] CRAN (R 4.0.3)                      
#>  jsonlite              1.7.2      2020-12-09 [1] CRAN (R 4.0.3)                      
#>  kagomer               0.0.1.900  2021-03-06 [1] Github (paithiov909/kagomer@c402470)
#>  knitr                 1.31       2021-01-27 [1] CRAN (R 4.0.3)                      
#>  labeling              0.4.2      2020-10-20 [1] CRAN (R 4.0.3)                      
#>  later                 1.1.0.1    2020-06-05 [1] CRAN (R 4.0.2)                      
#>  lattice               0.20-41    2020-04-02 [2] CRAN (R 4.0.2)                      
#>  LDAvis                0.3.2      2015-10-24 [1] CRAN (R 4.0.4)                      
#>  ldccr                 0.0.4      2021-03-11 [1] Github (paithiov909/ldccr@14fc1ca)  
#>  lgr                   0.4.2      2021-01-10 [1] CRAN (R 4.0.3)                      
#>  LiblineaR             2.10-12    2021-03-02 [1] CRAN (R 4.0.4)                      
#>  lifecycle             1.0.0      2021-02-15 [1] CRAN (R 4.0.2)                      
#>  listenv               0.8.0      2019-12-05 [1] CRAN (R 4.0.2)                      
#>  lubridate             1.7.10     2021-02-26 [1] CRAN (R 4.0.2)                      
#>  magrittr              2.0.1      2020-11-17 [1] CRAN (R 4.0.3)                      
#>  MASS                  7.3-53.1   2021-02-12 [1] CRAN (R 4.0.2)                      
#>  Matrix                1.3-2      2021-01-06 [1] CRAN (R 4.0.2)                      
#>  mlapi                 0.1.0      2017-12-17 [1] CRAN (R 4.0.2)                      
#>  modelr                0.1.8      2020-05-19 [1] CRAN (R 4.0.2)                      
#>  munsell               0.5.0      2018-06-12 [1] CRAN (R 4.0.2)                      
#>  network               1.16.1     2020-10-07 [1] CRAN (R 4.0.3)                      
#>  nsyllable             1.0        2020-11-30 [1] CRAN (R 4.0.4)                      
#>  openssl               1.4.3      2020-09-18 [1] CRAN (R 4.0.3)                      
#>  openxlsx              4.2.3      2020-10-27 [1] CRAN (R 4.0.3)                      
#>  parallelly            1.23.0     2021-01-04 [1] CRAN (R 4.0.3)                      
#>  pillar                1.5.1      2021-03-05 [1] CRAN (R 4.0.4)                      
#>  pkgconfig             2.0.3      2019-09-22 [1] CRAN (R 4.0.2)                      
#>  processx              3.4.5      2020-11-30 [1] CRAN (R 4.0.3)                      
#>  promises              1.2.0.1    2021-02-11 [1] CRAN (R 4.0.2)                      
#>  proxy                 0.4-25     2021-03-05 [1] CRAN (R 4.0.4)                      
#>  proxyC                0.1.5      2019-07-21 [1] CRAN (R 4.0.2)                      
#>  ps                    1.6.0      2021-02-28 [1] CRAN (R 4.0.2)                      
#>  purrr               * 0.3.4      2020-04-17 [1] CRAN (R 4.0.2)                      
#>  quanteda              2.1.2      2020-09-23 [1] CRAN (R 4.0.3)                      
#>  quanteda.textmodels   0.9.3      2021-03-07 [1] CRAN (R 4.0.4)                      
#>  quanteda.textplots    0.93       2021-02-18 [1] CRAN (R 4.0.4)                      
#>  quanteda.textstats    0.92       2021-02-20 [1] CRAN (R 4.0.4)                      
#>  R.cache               0.14.0     2019-12-06 [1] CRAN (R 4.0.3)                      
#>  R.methodsS3           1.8.1      2020-08-26 [1] CRAN (R 4.0.3)                      
#>  R.oo                  1.24.0     2020-08-26 [1] CRAN (R 4.0.3)                      
#>  R.utils               2.10.1     2020-08-26 [1] CRAN (R 4.0.3)                      
#>  R6                    2.5.0      2020-10-28 [1] CRAN (R 4.0.3)                      
#>  Rcpp                  1.0.6      2021-01-15 [1] CRAN (R 4.0.3)                      
#>  RcppKagome            0.0.1.900  2021-03-06 [1] local                               
#>  RcppParallel          5.0.3      2021-02-24 [1] CRAN (R 4.0.2)                      
#>  RcppProgress          0.4.2      2020-02-06 [1] CRAN (R 4.0.4)                      
#>  readr               * 1.4.0      2020-10-05 [1] CRAN (R 4.0.3)                      
#>  readxl                1.3.1      2019-03-13 [1] CRAN (R 4.0.2)                      
#>  reprex                1.0.0      2021-01-27 [1] CRAN (R 4.0.3)                      
#>  reticulate            1.18       2020-10-25 [1] CRAN (R 4.0.3)                      
#>  RhpcBLASctl           0.20-137   2020-05-17 [1] CRAN (R 4.0.0)                      
#>  rio                   0.5.26     2021-03-01 [1] CRAN (R 4.0.2)                      
#>  RJSONIO               1.3-1.4    2020-01-15 [1] CRAN (R 4.0.3)                      
#>  rlang                 0.4.10     2020-12-30 [1] CRAN (R 4.0.3)                      
#>  rle                   0.9.2      2020-09-25 [1] CRAN (R 4.0.3)                      
#>  rmarkdown             2.7        2021-02-19 [1] CRAN (R 4.0.2)                      
#>  rsparse               0.4.0      2020-04-01 [1] CRAN (R 4.0.2)                      
#>  RSpectra              0.16-0     2019-12-01 [1] CRAN (R 4.0.4)                      
#>  rstatix               0.7.0      2021-02-13 [1] CRAN (R 4.0.2)                      
#>  rstudioapi            0.13       2020-11-12 [1] CRAN (R 4.0.3)                      
#>  rtweet                0.7.0      2020-01-08 [1] CRAN (R 4.0.2)                      
#>  rvest                 1.0.0      2021-03-09 [1] CRAN (R 4.0.2)                      
#>  sass                  0.3.1      2021-01-24 [1] CRAN (R 4.0.3)                      
#>  scales                1.1.1      2020-05-11 [1] CRAN (R 4.0.2)                      
#>  servr                 0.21       2020-12-14 [1] CRAN (R 4.0.4)                      
#>  sessioninfo           1.1.1      2018-11-05 [1] CRAN (R 4.0.2)                      
#>  shape                 1.4.5      2020-09-13 [1] CRAN (R 4.0.3)                      
#>  sna                   2.6        2020-10-06 [1] CRAN (R 4.0.3)                      
#>  SparseM               1.81       2021-02-18 [1] CRAN (R 4.0.2)                      
#>  statnet.common        4.4.1      2020-10-03 [1] CRAN (R 4.0.3)                      
#>  stopwords             2.2        2021-02-10 [1] CRAN (R 4.0.2)                      
#>  stringi               1.5.3      2020-09-09 [1] CRAN (R 4.0.3)                      
#>  stringr             * 1.4.0      2019-02-10 [1] CRAN (R 4.0.2)                      
#>  styler                1.3.2      2020-02-23 [1] CRAN (R 4.0.3)                      
#>  survival              3.2-7      2020-09-28 [1] CRAN (R 4.0.3)                      
#>  text2vec              0.6        2020-02-18 [1] CRAN (R 4.0.2)                      
#>  textmineR             3.0.4      2019-04-18 [1] CRAN (R 4.0.4)                      
#>  tibble              * 3.1.0      2021-02-25 [1] CRAN (R 4.0.2)                      
#>  tidyr               * 1.1.3      2021-03-03 [1] CRAN (R 4.0.4)                      
#>  tidyselect            1.1.0      2020-05-11 [1] CRAN (R 4.0.2)                      
#>  tidyverse           * 1.3.0      2019-11-21 [1] CRAN (R 4.0.2)                      
#>  umap                  0.2.7.0    2020-11-04 [1] CRAN (R 4.0.4)                      
#>  utf8                  1.1.4      2018-05-24 [1] CRAN (R 4.0.2)                      
#>  uuid                  0.1-4      2020-02-26 [1] CRAN (R 4.0.3)                      
#>  vctrs                 0.3.6      2020-12-17 [1] CRAN (R 4.0.3)                      
#>  viridis               0.5.1      2018-03-29 [1] CRAN (R 4.0.2)                      
#>  viridisLite           0.3.0      2018-02-01 [1] CRAN (R 4.0.2)                      
#>  withr                 2.4.1      2021-01-26 [1] CRAN (R 4.0.3)                      
#>  xfun                  0.21       2021-02-10 [1] CRAN (R 4.0.2)                      
#>  xml2                  1.3.2      2020-04-23 [1] CRAN (R 4.0.2)                      
#>  yaml                  2.2.1      2020-02-01 [1] CRAN (R 4.0.0)                      
#>  zip                   2.1.1      2020-08-27 [1] CRAN (R 4.0.3)                      
#>  zipangu               0.2.3.9000 2021-03-02 [1] Github (uribo/zipangu@0e43aef)      
#> 
#> [1] C:/Users/user/Documents/R/win-library/4.0
#> [2] C:/Program Files/R/R-4.0.2/library
```

