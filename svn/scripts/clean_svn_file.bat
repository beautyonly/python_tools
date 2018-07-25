:: windows系统下清理当前目录下的所有svn隐藏文件
for /r . %%a in (.) do @if exist "%%a\.svn" rd /s /q "%%a\.svn"

:: linux系统下清理当前目录下的所有svn隐藏文件
::find . -type d -name ".svn"|xargs rm -rf;