:: windows系统下清理当前目录下的所有git隐藏文件
for /r . %%a in (.) do @if exist "%%a\.git" rd /s /q "%%a\.git"