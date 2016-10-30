# WordLearning
英単語学習サポートアプリ
調べれば調べるほど力になるかもしれない単語帳的な何か

## 動作要件
以下の条件を満たしていない環境での動作保証は行っておりません
Ruby 2.3 以降
Bundler 1.13.6 以降

## 機能
+ モード1:recordモード
英単語を調べるモード
調べた英単語はデータベースに蓄えられる

+ モード2:testモード
調べた英単語をテストするモード
今までに調べた英単語の中から一つが選ばれる

+ モード3:showモード
今までに調べた英単語が全部見れる

## How to use
まずこのリポジトリを適当な場所にcloneする
```
git clone https://github.com/Happa8/WordLearning.git
```
次にbundleで必要なgemをインストール
```
bundle install
```
そのあと```main.rb```ファイルを実行すれば成功!
```
ruby main.rb
```

## License
MIT License
