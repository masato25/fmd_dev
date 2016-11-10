
# FMAN

### 參考的開發環境版本
```
➜  FMAN git:(master) ✗ ruby --version
ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-linux]
➜  FMAN git:(master) ✗ rails --version
Rails 5.0.0.1
```

### 如何安裝
```
bundle
npm install
cd config
cp application.yml.bak application.yml
cp database.yml.bak database.yml
```
將 `application.yml` & `database.yml` 填入正確的設定值

### 如何啟動
```
start_dev.sh
```
### 如何中止
```
thin stop -e development -p 3000
```
