#
- 下载网站所有网页
  > wget -m http://www.example.com/

- 遇到下载首页后退出的情况,如何排查原因
  > wget -d debug -m http://www.example.com/
  
- 忽略robots.txt协议
  > wget -m -e robots=off http://www.example.com/

- 网站禁用wget情况处理
  > wget -m -e robots=off -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6" "http://www.example.com/"
